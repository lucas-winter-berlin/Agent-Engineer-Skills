# Agent Engineer Skills Architecture

This document is the framework specification. Skill files (`skills/*/SKILL.md`) are execution contracts. This file defines the control plane those contracts run on: lifecycle, Capability Discovery, human-in-the-loop gates, adaptive rules, artifact layout, and integration patterns.

Related artifacts:

- Meta-schema: [`schemas/skill-schema.json`](../schemas/skill-schema.json)
- Skill inventory and operator guide: [`README.md`](../README.md)
- Feature documentation convention: [`docs/features/README.md`](features/README.md)

## 1. Framework Model

An Agent Engineer Skill is a deterministic state machine executed by an AI agent against a project workspace.

```text
Idle
  -> Selected
    -> Discovering
      -> Planning
        -> AwaitingHumanGate (optional, skill-defined)
          -> Executing
            -> Auditing
              -> Freezing
                -> Verifying
                  -> Complete
                  -> Failed
          -> Rejected (return to Planning)
```

The agent is the interpreter. The skill is the program. The repository is the environment. The human is the authority at declared gates.

### 1.1 Design invariants

1. **Phase integrity.** Phases run in the order declared by the skill. An agent may not skip, merge, or reorder phases.
2. **Evidence over assertion.** Claims about the repository (test runner, CI vendor, linter) are backed by file paths recorded in the capability report.
3. **Schema completeness.** Every required field in the skill's `schema.json` appears in the output. Missing data is represented as an explicit `unknown`, `absent`, or logged assumption, never as omission.
4. **Adaptive mode, fixed contract.** Discovery changes *how* a phase is discharged (automated vs manual, Jest vs pytest), not *whether* the phase exists.
5. **Human authority.** Gates consume an explicit approval token. Silence, implied agreement, or "looks good" without a named gate is not approval.
6. **Artifact locality.** Feature work is written under `docs/features/<feature-name>/` before any global document is edited.
7. **No emoji, no iconography.** All artifacts are plain technical English and structured Markdown / JSON.

### 1.2 Roles

| Role | Authority | Typical actor |
| --- | --- | --- |
| Requester | States intent, answers clarification questions, issues approval tokens | Human |
| Agent | Interprets skills, writes artifacts and code, stops at gates | Gemini or Cursor agent |
| Reviewer | Signs off or rejects a gate | Human; may be the requester |
| System of record | Stores specs, ADRs, code, CI results | Git repository plus CI vendor |

## 2. Execution Lifecycle

The lifecycle below is the default for `feature-developer`. Other skills are projections of the same lifecycle with unused stages marked N/A in their `SKILL.md`.

### 2.1 Stage catalog

| Stage | Purpose | Exit criteria |
| --- | --- | --- |
| Selected | Bind one primary skill from the Decision Mapping table | Skill identifier announced to the user |
| Discovering | Inspect the workspace for toolchain and constraints | Capability report written and internally consistent |
| Planning | Produce specs, architecture, matrices, or threat models | Required planning artifacts exist and validate against templates |
| AwaitingHumanGate | Pause until named approval | `APPROVED: <skill> Phase <n>` recorded, or `REJECTED` with change list |
| Executing | Implement under TDD or produce the skill's primary artifact | Tests exist; implementation matches approved plan |
| Auditing | Security and edge-case review | Audit record lists findings, severities, and dispositions |
| Freezing | Lock feature docs and sync global docs | Freeze manifest with file list and hashes or git paths |
| Verifying | CI/CD or manual QA | Pass evidence attached; failures reopen Executing |
| Complete | Terminal success | All required schema outputs present |
| Failed | Terminal or retryable failure | Failure report names the stage, cause, and recovery action |

### 2.2 Transition rules

1. **Selected -> Discovering** occurs immediately after the skill is announced, unless the skill declares discovery not applicable.
2. **Discovering -> Planning** requires a capability report. Incomplete discovery is allowed only when the workspace is unavailable; the report must list missing signals and the confidence as `low`.
3. **Planning -> AwaitingHumanGate** is mandatory for `feature-developer` Phase 3 and recommended for ADR adoption and security-exception acceptance.
4. **AwaitingHumanGate -> Executing** requires an approval token that names the skill and phase. A generic "ok" or "go ahead" is insufficient if it does not identify the gate; the agent must ask the user to restate approval in the token format.
5. **AwaitingHumanGate -> Planning** on `REJECTED`. The agent revises only the rejected artifacts and resubmits the same gate.
6. **Executing -> Auditing** after the implementation matches the approved scope and tests pass locally, or after tests are written as unverified files when no runner exists.
7. **Auditing -> Freezing** after every finding is dispositioned (`fix`, `accept-risk` with owner, or `out-of-scope` with pointer to a new specifier run).
8. **Freezing -> Verifying** after local feature docs are complete and global system docs contain a recorded sync.
9. **Verifying -> Complete** after CI green or 100% of the manual QA checklist is evidenced.
10. **Verifying -> Executing** on failure. The capability report is not redone unless the toolchain itself changed.

### 2.3 Composition across skills

Skills compose in a fixed order when the user requests a full delivery:

```text
feature-specifier
  -> decision-matrix-architect   (only if more than one viable option remains)
    -> feature-developer
      -> sec-analyzer-tester     (Phase 5 of feature-developer, or a standalone rerun)
```

Composition rules:

1. Outputs of an upstream skill become inputs of the downstream skill. A PRD `featureName` becomes the `docs/features/<feature-name>/` directory name.
2. Do not re-run an upstream skill unless the downstream skill finds a contradiction (scope gap, missing acceptance criterion, or a new architectural option).
3. `sec-analyzer-tester` run as Phase 5 of `feature-developer` uses the feature directory as its system-under-review. A standalone run may target a service, package, or interface that is not a feature.

### 2.4 Failure and retry

| Failure class | Handling |
| --- | --- |
| Discovery miss (toolchain misdetected) | Rewrite capability report; do not patch it silently. Re-enter Planning if the plan depended on the error. |
| Schema violation | Do not proceed. Repair the artifact until all required fields exist. |
| Gate rejection | Return to Planning with a numbered change list. |
| Test failure | Remain in Executing. Do not "fix" by deleting tests. |
| CI failure with local pass | Record environment delta; fix until CI matches local, or document a blocked dependency. |
| Scope creep request mid-implementation | Stop. Route to `feature-specifier`. Do not fold new scope into the open feature directory. |

## 3. Capability Discovery

Capability Discovery is the project-awareness mechanism. It is a read-only inspection of the workspace that produces a structured capability report. It does not install tools, modify CI, or "upgrade" the stack.

### 3.1 Signals to collect

The agent searches the repository root and common subpaths. Each signal is recorded as `present`, `absent`, or `unknown`, with evidence paths when present.

| Domain | Evidence examples | Downstream effect |
| --- | --- | --- |
| Language and package manager | `package.json`, `go.mod`, `pyproject.toml`, `Cargo.toml`, `pom.xml`, `*.csproj` | Chooses file extensions, import style, and toolchain commands |
| Test framework | `jest`, `vitest`, `pytest`, `go test`, `JUnit`, `NUnit`, `rspec`, `mocha`, `phpunit` | Enables automated TDD and generated tests |
| Test command | `package.json` scripts, `Makefile`, `Taskfile`, `justfile` | Exact command used in Executing and Verifying |
| Linter / formatter | ESLint, Ruff, golangci-lint, Checkstyle, Spotless, Prettier, Black | Must pass before freeze; config is not rewritten unless the approved plan says so |
| Type checker | `tsc`, `mypy`, `pyright`, `go vet` | Treated as a blocking verifier when configured in CI or local scripts |
| CI/CD | `.github/workflows/`, `.gitlab-ci.yml`, `Jenkinsfile`, `azure-pipelines.yml`, `.circleci/`, `bitbucket-pipelines.yml` | Selects CI verification mode vs manual QA |
| Security scanners | CodeQL, Semgrep, Snyk, Dependabot, `govulncheck` | Consumed by `sec-analyzer-tester`; not a substitute for STRIDE |
| IaC / delivery | Terraform, Pulumi, Helm, Dockerfiles, Kubernetes manifests | Expands trust boundaries and verification surface |
| Docs layout | `docs/`, `ADR` folders, OpenAPI, README architecture sections | Targets for Docs Freeze sync |
| Existing skills / rules | `.cursor/rules/`, `skills/`, `AGENTS.md` | Prevents conflicting instructions; this framework wins on phase order when bound |

### 3.2 Detection algorithm

1. List the repository root. Record the VCS type if `.git` exists.
2. Detect language manifests. If multiple languages exist, identify the primary module for the requested feature and list others as adjacent.
3. Parse test configuration:
   - Node: `package.json` `devDependencies` and `scripts.test`
   - Python: `pytest.ini`, `pyproject.toml` `[tool.pytest]`, `tox.ini`
   - Go: `_test.go` files and `go.mod`
   - JVM: Surefire/Failsafe, Gradle `test` task
4. Parse CI entrypoints. Extract job names that run lint, test, build, and security scans. Do not invent jobs that are not in the file.
5. Parse linter configs. Record whether they run locally, in CI, both, or unknown.
6. Detect documentation conventions. If `docs/features/` is missing, the capability report notes that `feature-developer` will create it.
7. Emit the capability report using `skills/feature-developer/templates/capability-report.md` (or the skill's declared discovery template).
8. Set `adaptiveMode` flags used by later phases:
   - `tests.automated` true iff a runner and a command were evidenced
   - `ci.present` true iff a CI config file was evidenced
   - `lint.blocking` true iff lint runs in CI or a documented pre-commit hook

### 3.3 Confidence and incompleteness

| Confidence | Condition |
| --- | --- |
| high | Manifest and command both evidenced |
| medium | Manifest evidenced, command inferred from defaults |
| low | Workspace missing, or conflicting manifests without a primary module |

Low-confidence discovery does not block Planning, but the plan must not depend on unevidenced tools. The agent states the fallback (manual QA, no assumed linter) in the plan.

### 3.4 Prohibited discovery behaviors

1. Do not run package installs "to see what works" unless the user asked to bootstrap.
2. Do not mutate lockfiles during discovery.
3. Do not treat README claims as evidence without a corresponding config file.
4. Do not assume GitHub Actions because the remote is GitHub. CI is present only when a workflow file exists.

## 4. Human-in-the-Loop Gates

A Human Review Gate is a hard stop. The agent produces the gate package, then waits.

### 4.1 Approval token

Canonical form:

```text
APPROVED: <skill-id> Phase <n>
```

Optional free text may follow the token. The first line must match the form above (case-insensitive skill id, integer phase).

Rejection form:

```text
REJECTED: <skill-id> Phase <n>
<numbered change requests>
```

### 4.2 Gate package

Every gate submission includes:

1. The artifacts under review (paths)
2. A summary of decisions that become irreversible after approval
3. Open assumptions and their risk
4. Explicit ask: approve, reject with changes, or request a specific amendment

### 4.3 Gate placement

| Skill | Gate | Default |
| --- | --- | --- |
| `feature-developer` | Phase 3 after architecture blueprint | Mandatory |
| `feature-specifier` | After PRD draft if high-risk assumptions remain | Optional; questions must still be asked |
| `decision-matrix-architect` | Before treating the ADR as accepted | Recommended |
| `sec-analyzer-tester` | Before `accept-risk` dispositions | Mandatory for high/critical findings |

### 4.4 Invalid approvals

The following are not valid tokens:

- "lgtm", "ship it", "ok", "yes", thumbs-up emoji (emoji is banned in any case)
- Approval of a different phase
- Approval in a different conversation without restating the token in the active thread
- Approval that adds new scope in the same message without a specifier run

If the user issues an invalid approval, the agent restates the required token format and remains in `AwaitingHumanGate`.

### 4.5 Timeout and continuation

Skills do not auto-expire gates. If the user later says "continue" without a token, the agent re-requests the token. If the user explicitly waives a recommended (not mandatory) gate, record `WAIVED: <skill> Phase <n> by <user>` in the gate file and proceed. Mandatory gates cannot be waived by the agent; only a token or a written process exception stored in the feature directory can pass them.

## 5. Adaptive Execution

Adaptive rules map discovered capabilities to phase implementations.

### 5.1 Test adaptation

| Discovery | Executing phase behavior |
| --- | --- |
| Runner + command present | Red-green-refactor. Run the exact test command after each increment. |
| Test files exist, no command | Write tests in the existing style. Record `verificationMode: unverified-local`. |
| No tests | Create the first test file in the language's conventional location. Record that a runner is absent. Still write tests. |
| Snapshot / approval tests | Do not update snapshots to hide failures. Treat snapshot updates as explicit product decisions. |

### 5.2 CI adaptation

| Discovery | Verifying phase behavior |
| --- | --- |
| CI present and invocable | Trigger or instruct the user how to trigger the relevant workflow. Record job URLs or logs. |
| CI present but agent cannot trigger | Produce a verification checklist of the exact jobs to run and wait for user-supplied logs. |
| CI absent | Execute `skills/sec-analyzer-tester/templates/manual-qa-checklist.md` plus feature-specific functional checks. Do not claim "CI passed." |

### 5.3 Linter adaptation

If a linter is blocking, the Executing phase is not complete until lint is clean on touched files. If a linter is absent, do not introduce one unless the approved architecture plan includes it.

### 5.4 Security adaptation

| Discovery | `sec-analyzer-tester` output |
| --- | --- |
| Test runner present | Generate automated unit/integration tests for mitigations; STRIDE remains mandatory |
| Test runner absent | STRIDE + mitigations + manual QA checklist |
| Existing scanner jobs | Consume findings as inputs; they do not replace STRIDE |

## 6. Artifact System

### 6.1 Feature directory

Created by `feature-developer` Phase 2:

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

`<feature-name>` is kebab-case, locked at the end of Phase 2, confirmed at Phase 3.

### 6.2 Global sync

During Docs Freeze, the agent updates global documents that the capability report listed (for example `README.md`, `docs/ARCHITECTURE.md` of the consuming app, OpenAPI files). Every global edit is listed in the freeze manifest with the reason. Unrelated global docs are not rewritten.

### 6.3 Templates

Templates are instantiated by replacing mustache-style placeholders of the form `{{PLACEHOLDER}}`. Agents must not delete template sections. Unused optional sections remain with `N/A` and a one-line reason.

### 6.4 Schema validation

Skill definitions in this repository must validate against `schemas/skill-schema.json`. Runtime outputs of a skill execution should conceptually satisfy `skills/<skill-name>/schema.json`. Where a JSON object is not the user-facing artifact, Markdown fields map one-to-one onto schema properties.

## 7. Skill Integration Patterns

### 7.1 Cursor

Cursor consumes `.cursor/rules/*.mdc`. The dispatcher rule is always applied. Skill rules are requested by identifier. The agent must read `skills/<skill-name>/SKILL.md` before executing phases. Rules are projections; `SKILL.md` is authoritative if they diverge.

### 7.2 Gemini Custom Gems

Each Gem's instruction body is: preamble (contract language from the README) + `SKILL.md` + attached `schema.json` and templates. Gems do not share memory. The user carries artifact paths across Gems (PRD path into the developer Gem).

### 7.3 Gemini API

System instruction = `SKILL.md`. Application code owns gate enforcement: it must not enqueue an Executing turn without a stored approval token. JSON mode, when available, should use `schema.json` as the response schema for machine-readable summaries; Markdown artifacts remain the system of record in git.

### 7.4 Dual-runtime teams

Teams using both Cursor and Gemini share the git artifacts, not the chat transcripts. The feature directory is the handoff surface. A Cursor agent must not ignore a PRD written by a Gemini Gem, and the reverse.

### 7.5 Conflict resolution

If consuming-project rules contradict this framework:

1. Security, secrets, and legal rules of the consuming project win.
2. Phase order, gate tokens, and schema completeness of this framework win for work executed under an Agent Engineer Skill.
3. Style/format rules of the consuming project win for source code.

Record conflicts in the capability report under `instructionConflicts`.

## 8. Versioning and Compatibility

- Skill `metadata.id` values are stable public identifiers.
- `metadata.version` follows semver.
- Additive optional schema fields are minor.
- Removing or renaming required fields is major.
- Phase insertion that changes gate numbers is major; prefer appending phases.

## 9. Non-goals

This framework does not:

- Replace product management process outside the PRD artifact
- Provision CI or cloud infrastructure
- Guarantee that generated tests are sufficient without review
- Authorize the agent to bypass consuming-project security policy
- Define a network protocol between agents

## 10. Glossary

| Term | Definition |
| --- | --- |
| Skill | Structured instruction set plus execution contract (procedure, schema, templates, guardrails) |
| Phase | Ordered unit of work inside a skill with entry and exit criteria |
| Capability report | Evidence-backed inventory of local toolchain |
| Adaptive mode | Selection of automated vs manual discharge of a phase |
| Approval token | Named, explicit human sign-off for a gate |
| Feature directory | `docs/features/<feature-name>/` system of record for one change |
| Docs freeze | Point after which spec and architecture are immutable without a new change request |
| MADR | Markdown Architectural Decision Records |
| STRIDE | Spoofing, Tampering, Repudiation, Information Disclosure, Denial of Service, Elevation of Privilege |
