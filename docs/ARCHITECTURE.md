# How Agent Engineer Skills work

Start with [README.md](../README.md) if you want to *use* the skills. This file explains *how they run* once they are bound.

You do not need senior-level vocabulary to follow it. Each section starts with the simple version, then lists the exact rules the agent must keep.

Related files:

- Operator guide: [`README.md`](../README.md)
- Shared skill format: [`schemas/skill-schema.json`](../schemas/skill-schema.json)
- Feature folder layout: [`docs/features/README.md`](features/README.md)

## Plain picture

Think of a skill as a recipe card, the agent as the cook, your git repo as the kitchen, and you as the person who tastes the dish before it is served.

```text
You ask for work
  -> Agent names the skill
    -> Agent looks around the repo (tests, CI, linters)
      -> Agent writes a plan or document
        -> You say APPROVED or REJECTED (when the skill requires it)
          -> Agent writes tests and code
            -> Agent does a security pass
              -> Agent saves docs
                -> Agent runs CI, or walks a checklist
                  -> Done, or back to coding if checks fail
```

The agent is not allowed to skip a step because it "already knows." If a step does not apply, it still writes `N/A` and a one-line reason.

## 1. Roles

| Role | What they do | Who that usually is |
| --- | --- | --- |
| You (requester) | Describe the work, answer questions, type approval lines | Human |
| Agent | Follow the skill, write files and code, stop at gates | Cursor or Gemini |
| Reviewer | Approve or reject a plan | Often the same human |
| Record | Keep specs, decisions, code, and CI results | Git, plus your CI provider if you have one |

## 2. Rules that never change

1. **Do the steps in order.** No skipping, merging, or reordering.
2. **Show proof for repo facts.** "We use Jest" is only allowed if a file path shows Jest.
3. **Fill every required field.** If something is missing, write `unknown`, `absent`, or an assumption. Do not leave a hole.
4. **Adapt the method, not the step.** No CI means "use a checklist," not "skip verification."
5. **You are in charge at gates.** "ok" or "looks good" is not approval unless it names the skill and phase.
6. **Feature files live together.** Work goes under `docs/features/<feature-name>/` before shared docs are edited.
7. **No icons or emojis** in these files.

## 3. Lifecycle (the same story with official names)

`feature-developer` uses every stage below. Other skills use a shorter path. Unused stages are marked `N/A` in that skill's `SKILL.md`.

| Stage | Simple meaning | Ready to leave this stage when... |
| --- | --- | --- |
| Selected | The agent says which skill it is using | You can see the skill name in the chat |
| Discovering | It inspects the repo | A capability report exists |
| Planning | It writes specs, plans, matrices, or threat models | The required templates are filled |
| AwaitingHumanGate | It waits for you | You typed `APPROVED: <skill> Phase <n>` or `REJECTED` plus numbered changes |
| Executing | It implements (usually test-first) | Tests exist and match the approved plan |
| Auditing | It reviews security and odd cases | Every finding has a decision (`fix`, `accept-risk`, or `out-of-scope`) |
| Freezing | It locks the feature docs and updates shared docs | A freeze list of files exists |
| Verifying | It runs CI or a checklist | Pass evidence is attached |
| Complete | Success | Required outputs are all present |
| Failed | Stop or retry | The report names the stage, the cause, and the next action |

### 3.1 Allowed moves

1. After naming the skill, inspect the repo (unless that skill says not to).
2. After discovery, plan. If the repo was not available, confidence is `low` and the plan must not depend on guessed tools.
3. After the plan, wait for you when the skill says so. For `feature-developer` this wait is required.
4. After `APPROVED`, implement. After `REJECTED`, fix only the rejected docs and wait again. Do not start coding on a rejection.
5. After the code matches the plan, audit.
6. After every finding has a decision, freeze docs.
7. After freeze, verify.
8. After CI is green, or every checklist row has evidence, complete.
9. If verification fails, go back to coding. Do not redo discovery unless the tools in the repo actually changed.

### 3.2 Using more than one skill

A full delivery usually looks like this:

```text
feature-specifier
  -> decision-matrix-architect   (only if more than one real option remains)
    -> feature-developer
      -> sec-analyzer-tester     (already step 5 of feature-developer, or a later extra pass)
```

Rules:

1. The output of an earlier skill is the input of the next one. The spec's feature name becomes the folder name under `docs/features/`.
2. Do not rerun an earlier skill unless the later skill finds a hole (missing acceptance test, new design option, scope gap).
3. A security pass inside `feature-developer` looks at that feature folder. A standalone security pass can look at any service or interface you name.

### 3.3 When something goes wrong

| Problem | What to do |
| --- | --- |
| Wrong tools detected | Rewrite the capability report. Do not quietly edit one line. Re-plan if the plan depended on the mistake. |
| Missing required fields | Stop. Finish the document. |
| You rejected the plan | Go back to planning with your numbered list. |
| Tests fail | Stay in implementation. Do not delete tests to get a green run. |
| CI fails but your laptop passes | Write down the difference. Fix until they match, or record a blocked dependency. |
| New scope appears mid-build | Stop. Run `feature-specifier`. Do not squeeze extra work into the open feature folder. |

## 4. Capability Discovery (looking at your repo)

Discovery is a **read-only** look at the project. The agent writes a capability report. It does not install packages, change CI, or "upgrade" your stack.

Each item is `present`, `absent`, or `unknown`. `present` needs a file path.

| What it looks for | Example files | Why it matters |
| --- | --- | --- |
| Language and package manager | `package.json`, `go.mod`, `pyproject.toml` | File types and commands |
| Test framework | Jest, Vitest, pytest, `go test`, JUnit | Whether tests can be run |
| Test command | `npm test`, `make test` | The exact command to run |
| Linter / formatter | ESLint, Ruff, Prettier, Black | Must be clean on touched files if it already runs in CI |
| Type checker | `tsc`, `mypy` | Extra check when your project already uses it |
| CI | `.github/workflows/`, `.gitlab-ci.yml` | CI mode vs checklist mode |
| Security scanners | CodeQL, Semgrep, Dependabot | Extra input for the security skill, not a replacement for STRIDE |
| Deploy files | Docker, Terraform, Helm | Extra security and verification surface |
| Docs layout | `docs/`, ADR folders | Where freeze updates go |
| Other agent rules | `.cursor/rules/`, `AGENTS.md` | Avoid conflicting instructions |

### 4.1 How the agent inspects

1. List the repo root. Note if `.git` exists.
2. Find language files. If there are several languages, pick the one for *this* request and list the others.
3. Find how tests run (`package.json` scripts, `pytest.ini`, `_test.go`, and so on).
4. Read CI files. Copy job names that already exist. Do not invent jobs.
5. Find linter config. Note whether it runs locally, in CI, both, or unknown.
6. Find docs folders. If `docs/features/` is missing, the report says the feature skill will create it.
7. Fill `skills/feature-developer/templates/capability-report.md` (or that skill's own discovery template).
8. Set three flags:
   - `tests.automated` = true only if a runner **and** a command were found
   - `ci.present` = true only if a CI config file was found
   - `lint.blocking` = true if lint already runs in CI or a documented git hook

### 4.2 Confidence

| Level | Meaning |
| --- | --- |
| high | Config file and command both found |
| medium | Config file found, command guessed from defaults |
| low | No workspace, or several languages with no clear primary |

Low confidence does not block planning. It does block pretending a tool exists.

### 4.3 Discovery must not

1. Install packages "to see what works" unless you asked to bootstrap.
2. Change lockfiles.
3. Treat README claims as proof without a matching config file.
4. Assume GitHub Actions just because the remote is GitHub. CI is present only when a workflow file exists.

## 5. Human gates (your approval)

A gate is a hard stop. The agent writes a small review pack, then waits.

### 5.1 What you type

Approve:

```text
APPROVED: <skill-id> Phase <n>
```

You can add more sentences after that line. The first line must name the skill and the phase number.

Reject:

```text
REJECTED: <skill-id> Phase <n>
1. Change X
2. Change Y
```

### 5.2 What the agent shows you at a gate

1. Paths of the files under review
2. Decisions that are hard to undo after you say yes
3. Open assumptions and their risk
4. A clear ask: approve, reject with changes, or change one named thing

### 5.3 Where gates sit

| Skill | Gate | Required? |
| --- | --- | --- |
| `feature-developer` | After the architecture plan (Phase 3) | Yes |
| `feature-specifier` | After a PRD that still has high-risk assumptions | Optional; questions are still required |
| `decision-matrix-architect` | Before treating the ADR as accepted | Recommended |
| `sec-analyzer-tester` | Before accepting leftover high/critical risk | Yes for those findings |

### 5.4 What does not count as approval

- "lgtm", "ship it", "ok", "yes"
- Approval of a different phase
- Approval from another chat unless you paste the token again here
- Approval that also sneaks in new scope (that needs the specifier skill)

If the token is wrong, the agent asks you to retype it and keeps waiting.

Gates do not time out. "Continue" without a token is not enough. You may waive a *recommended* gate with `WAIVED: <skill> Phase <n> by <your name>`. The agent cannot waive a *required* gate.

## 6. Adaptive execution (same steps, different tools)

### 6.1 Tests

| What was found | What the agent does |
| --- | --- |
| Test runner and command | Write a failing test, run the real command, write code, run again |
| Test files but no command | Write tests in the same style. Mark them unverified-local |
| No tests yet | Create the first test file in the usual place for that language. Still write tests |
| Snapshot tests | Do not update snapshots just to hide a failure |

### 6.2 CI

| What was found | What the agent does |
| --- | --- |
| CI exists and can be started | Start it or tell you how. Save job names and results |
| CI exists but the agent cannot start it | List the exact jobs and wait for your logs |
| No CI | Use a written QA checklist. Never write "CI passed." |

### 6.3 Linters

If lint already blocks in your project, dirty lint on touched files means implementation is not done. If you have no linter, the agent does not add one unless the approved plan says to.

### 6.4 Security

| What was found | What the security skill produces |
| --- | --- |
| Test runner | Automated tests for the fixes, plus a full STRIDE table |
| No test runner | STRIDE, fixes, and a manual QA checklist |
| Existing scanners | Extra findings to merge in. Scanners do not replace STRIDE |

## 7. Where files go

`feature-developer` creates:

```text
docs/features/<feature-name>/
  README.md
  spec.md
  architecture.md
  decisions.md
  capability-report.md
  review-gate.md
  implementation-log.md
  security-audit.md
  verification.md
```

`<feature-name>` is lowercase with hyphens (`invoice-csv-export`). It is chosen at the end of planning and confirmed when you approve.

When docs freeze, the agent also updates shared files that discovery listed (your app README, API docs, and similar), and only those files. Each shared edit is listed with a reason.

Templates use `{{PLACEHOLDER}}`. The agent must not delete sections. Unused optional sections stay with `N/A` and one line of reason.

Skill definitions in this repo must match `schemas/skill-schema.json`. A run should cover every field in `skills/<skill-name>/schema.json`. When the user-facing file is Markdown, each schema field has a matching heading or table column.

## 8. Cursor, Gemini, and mixed teams

**Cursor.** Rules live in `.cursor/rules/`. The dispatcher always applies. The agent must still open `skills/<skill-name>/SKILL.md`. If a short rule and `SKILL.md` disagree, `SKILL.md` wins.

**Gemini Custom Gems.** Each Gem gets the README preamble, then `SKILL.md`, plus schema and templates. Gems do not share chat memory. You pass file paths from one Gem to the next (for example the PRD path).

**Gemini API.** System instruction is `SKILL.md`. Your application must not continue into coding without a stored approval token. Markdown files in git are the record. JSON is only a summary if you use it.

**Both tools on one team.** Share git files, not chat logs. The feature folder is the handoff. A Cursor agent must honor a PRD written in Gemini, and the reverse.

**Conflicts with your project rules:**

1. Your security, secrets, and legal rules win.
2. For work done under these skills, phase order, gates, and required fields from this framework win.
3. Your project's code style wins for source files.

Write conflicts into the capability report as `instructionConflicts`.

## 9. Versioning

- Skill ids (`feature-developer` and the others) stay stable.
- Versions look like `1.2.3`.
- Adding an optional field is a minor change.
- Removing or renaming a required field is a major change.
- Inserting a phase that shifts gate numbers is a major change. Prefer adding a phase at the end.

## 10. This framework does not

- Replace your product process outside the PRD file
- Set up CI or cloud accounts for you
- Guarantee generated tests are enough without a human look
- Let the agent ignore your security policy
- Define a network protocol between agents

## 11. Glossary

| Term | Meaning |
| --- | --- |
| Skill | Procedure plus required outputs (steps, schema, templates, rules) |
| Phase | One numbered step with a start condition and a done condition |
| Capability report | Written list of what the repo actually has |
| Adaptive mode | Automated vs manual way to finish the same step |
| Approval token | The exact `APPROVED: ...` line |
| Feature directory | `docs/features/<feature-name>/` for one change |
| Docs freeze | After this, spec and architecture do not change unless you open a new request |
| MADR | Markdown Architectural Decision Records |
| STRIDE | Six security questions: Spoofing, Tampering, Repudiation, Information Disclosure, Denial of Service, Elevation of Privilege |
