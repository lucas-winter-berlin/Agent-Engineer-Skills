# How Agent Engineer Skills work

Start with [README.md](../README.md). Operator notes: [GUIDE.md](GUIDE.md). Feature folders: [features/README.md](features/README.md).

This file is the control plane: four jobs, one folder, one order. `feature-harness` runs the last three for one lock.

## Picture

```text
You describe work
  -> Agent names one skill (or feature-harness)
    -> Agent reads skills/<id>/SKILL.md
      -> Agent does that job (harness runs three inner jobs)
        -> Writes files under docs/features/<name>/
          -> Next skill, retry, or stop
```

A skill is a recipe card. The agent is the cook. Your git repo is the kitchen. `what-to-build.md` is the dish you ordered; later skills may not serve something else.

## The skills

| Skill | Job | Input | Output |
| --- | --- | --- | --- |
| `feature-specifier` | Understand the idea. Ask landmine questions. Lock the product. | A fuzzy request | `what-to-build.md` |
| `feature-developer` | Implement the lock. Nothing else. | `what-to-build.md` | Feature branch, code, `what-was-implemented.md` |
| `feature-code-reviewer` | Strict clean-code review. Safe internals only. | Lock + diff | Refactors if needed, `what-was-reviewed.md` |
| `feature-verifier` | Tests that match the lock. Run this repo's existing commands. | Lock + code | Tests, `what-was-verified.md` |
| `feature-harness` | Run developer, reviewer, verifier for one lock. One verify-fail retry. Classify later feedback. | Lock (or feedback on a folder) | Inner files + `what-was-run.md` |

Daily path:

```text
feature-specifier
  -> feature-harness
       -> feature-developer
       -> feature-code-reviewer
       -> feature-verifier
       -> if verify fail: those three once more, then stop
```

You can still name an inner skill alone. Harness does not skip review.

Rules:

1. The output of an earlier skill is the input of the next. The feature name in the lock is the folder name.
2. Do not start `feature-developer` or `feature-harness` while the lock is missing or still fuzzy.
3. Do not skip `feature-code-reviewer` on the daily path unless the user said to skip review.
4. Do not rerun an earlier skill unless a later one finds a hole (ambiguous lock, product change, failed tests).
5. If a later skill would change what the user gets, stop and go back to `feature-specifier`.

## Feature folder

One folder per feature, kebab-case:

```text
docs/features/<feature-name>/
  what-to-build.md           Lock. Specifier writes. Developer does not rewrite it.
  what-was-implemented.md    Developer write-up
  what-was-reviewed.md       Review findings and refactors
  what-was-verified.md       Tests, runs, slop check
  what-was-run.md            Harness log (only if feature-harness ran)
```

Older names: if only `concept.md` exists, treat it as `what-to-build.md`. If only `notes.md` exists, treat it as `what-was-implemented.md`. Do not keep inventing extra spec files.

Templates live under `skills/<id>/templates/`. The agent fills them. It does not invent a parallel pack (PRD, architecture plan, capability report, STRIDE, CI freeze).

## Dispatcher

Cursor: `.cursor/rules/agent-engineer-skills.mdc` always applies. The agent must still open `skills/<id>/SKILL.md`. If the short rule and `SKILL.md` disagree, `SKILL.md` wins.

Gemini: each Gem pastes `SKILL.md`. Gems do not share chat memory. The feature folder is the handoff.

When the user wants the whole path and a lock exists, run `feature-harness`. Announce `Using skill: <id>` before each skill, including inner ones.

## Contracts

Each skill folder has:

| File | Role |
| --- | --- |
| `SKILL.md` | Steps, when to use, must / must not |
| `schema.json` | Required run fields |
| `templates/*.md` | The only allowed write-up shape |

Shared package shape: [`schemas/skill-schema.json`](../schemas/skill-schema.json).

Required fields in a run must appear in the Markdown write-up (heading or table). Do not leave holes. If a test layer does not exist, write `absent` and a reason. Do not claim a tool that has no evidence path.

## What each skill must not swallow

| Skill | Not this skill |
| --- | --- |
| Specifier | Code, extra PRD files, class names the user did not require |
| Developer | Product invention, CI, new test frameworks, review essays, STRIDE |
| Reviewer | New product, new dependencies, unrelated rewrites |
| Verifier | New product, new CI, new scanners, a threat-model essay |
| Harness | SDK, Automation, scaffold, skipping review, extra product as a "fix" |

Security on the daily path is a **negative test** in `feature-verifier` (unauthorized caller, no new public route, no secrets in source) when the change has a who/auth or a new entry point. It is not a threat-model pack.

Technical forks (which library, which store) that the lock did not name: **stop and ask**. Do not pick silently. Do not stand up a scoring matrix skill.

## Waiting for a human

There is no `APPROVED: <skill> Phase <n>` machine on this path.

The agent waits when:

- Specifier needs landmine answers (clickable `AskQuestion` when the host has it)
- Developer finds a lock hole or a new landmine
- Reviewer would have to change the product to fix a finding
- Verifier needs a human to run a manual check it cannot run
- Harness: missing lock, empty kitchen, verify still fail after one retry, review blocked-specifier, classify-unsure, or cancel

`ok` / `lgtm` does not skip specifier questions or turn a fail into a pass.

## Looking at the repo

Quiet and read-only until the skill says to write.

- Specifier: enough to name the kind of work and the real entry points
- Developer: language, layout, how similar features are built
- Reviewer: local patterns are the standard, not a textbook style
- Verifier: existing test folders and commands only

Do not write a capability report. Do not install packages "to see what works." Do not add Playwright, CI, or a scanner because another repo had them.

Windows PowerShell: do not join commands with `&&`.

## Failures

| Problem | What to do |
| --- | --- |
| Lock missing or fuzzy | `feature-specifier` |
| New product landmine mid-build | Stop. Ask. Do not squeeze it into the open folder. |
| Review must-fix remains | Stay in `feature-code-reviewer` until it is gone or blocked for specifier |
| Tests fail | `feature-harness` retries develop → review → verify once, then stops. Alone, stay in `feature-verifier` (or send a product miss back to developer). Do not delete tests to get green. |
| Harness classify unsure | Ask. Do not pick specifier vs developer. |
| A test layer does not exist | Write `absent`. Do not invent the layer. |

## Cursor, Gemini, mixed teams

**Cursor.** Dispatcher always on. New Agent chat after copy so rules load.

**Gemini Custom Gems.** Preamble + `SKILL.md` + schema + templates. Pass feature-folder paths from Gem to Gem.

**Both on one team.** Share git files, not chat logs. The feature folder is the record.

**Conflicts with the consuming project:**

1. That project's security, secrets, and legal rules win.
2. For skill-bound work, skill order, templates, and required fields from this framework win.
3. That project's code style wins for source.

## Versioning

- Skill ids stay stable (`feature-specifier`, `feature-developer`, `feature-code-reviewer`, `feature-verifier`, `feature-harness`).
- Adding an optional template section is a minor change.
- Removing or renaming a required write-up or a skill id is a major change.

## This framework does not

- Replace the team's product process outside `what-to-build.md`
- Set up CI or cloud accounts
- Guarantee tests are enough without a human look
- Let the agent ignore the consuming project's security policy
- Define a network protocol between agents

## Glossary

| Term | Meaning |
| --- | --- |
| Skill | Job plus required outputs (`SKILL.md`, schema, template) |
| Lock | `what-to-build.md` — the product the later skills must not change |
| Feature directory | `docs/features/<feature-name>/` for one change |
| Wall | Out-of-scope item. Hard reject if code builds it |
| Landmine | A question whose wrong guess would waste implementation time |
| Slop | Tests or code that do not match the lock, or hollow asserts |
| Harness | `feature-harness` running developer, reviewer, verifier for one lock |
