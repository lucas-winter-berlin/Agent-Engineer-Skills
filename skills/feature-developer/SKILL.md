---
name: feature-developer
description: >-
  Executes an end-to-end adaptive feature implementation pipeline: capability
  discovery, spec and architecture blueprint, human review gate, TDD
  implementation, security audit, docs freeze, and CI/CD or manual QA. Use when
  the user asks to implement a feature, build a capability end to end, apply
  TDD to a specified change, or deliver code after an approved PRD.
---

# feature-developer

End-to-end adaptive feature implementation pipeline. This file is an execution contract. Follow every phase in order. Do not skip, merge, or reorder phases. Instantiate templates instead of inventing document structures. Stop at Phase 3 until an explicit approval token is recorded.

Canonical schema: [schema.json](schema.json). Framework control plane: [docs/ARCHITECTURE.md](../../docs/ARCHITECTURE.md). Feature directory convention: [docs/features/README.md](../../docs/features/README.md).

## When to use

Use this skill when the user requests implementation of a feature, capability, or behavioral change and expects planning, tests, security review, documentation, and verification to be part of the same delivery.

Do not use this skill when the requirement is still ambiguous (use `feature-specifier`), when the user only wants a trade-off or ADR (use `decision-matrix-architect`), when the user only wants a threat model (use `sec-analyzer-tester`), or when the change is a trivial non-behavioral edit with no feature surface.

## Guardrails

Must:

1. Announce `Using skill: feature-developer` before Phase 1.
2. Write a capability report from repository evidence, not from README claims alone.
3. Create `docs/features/<feature-name>/` during Phase 2 and use it as the system of record.
4. Stop at Phase 3. Continue only after `APPROVED: feature-developer Phase 3`.
5. Implement with TDD when a test runner exists. Write tests first even when a runner is absent.
6. Keep implementation inside the approved In-Scope section.
7. Run a security and edge-case audit before docs freeze.
8. Freeze feature docs and sync global docs in the same phase.
9. Verify via CI when present; otherwise complete a structured manual QA checklist with evidence.
10. Produce artifacts that cover every required field in `schema.json`.

Must not:

1. Start coding before Phase 3 approval.
2. Invent toolchain facts (`present` requires a path).
3. Expand scope silently.
4. Delete or weaken tests to obtain a green run.
5. Claim CI passed when CI is absent.
6. Use icons or emojis in any artifact.
7. Waive Phase 3.
8. Commit secrets, credentials, or production data dumps into the feature directory.

## Approval token

```text
APPROVED: feature-developer Phase 3
```

Rejection:

```text
REJECTED: feature-developer Phase 3
<numbered change requests>
```

On rejection, revise only the rejected planning artifacts and resubmit Phase 3. Do not code.

---

## Phase 1. Capability Discovery

**Objective.** Detect local test frameworks, CI/CD, linters, languages, and documentation layout. Set adaptive flags for later phases.

**Entry.** Skill selected. Workspace accessible or user-supplied tree described.

**Exit.** `docs/features/_incoming/capability-report.md` drafted. After Phase 2 names the feature, move this file into `docs/features/<feature-name>/capability-report.md`.

**Steps.**

1. Inspect the repository root and record VCS presence.
2. Detect language manifests (`package.json`, `go.mod`, `pyproject.toml`, `Cargo.toml`, `pom.xml`, `*.csproj`, and equivalents). Identify the primary module for this request.
3. Detect test frameworks and the exact test command from scripts, Makefiles, or CI jobs.
4. Detect linters, formatters, and type checkers. Note whether they run locally, in CI, both, or unknown.
5. Detect CI/CD configs: `.github/workflows/`, `.gitlab-ci.yml`, `Jenkinsfile`, `azure-pipelines.yml`, `.circleci/`, `bitbucket-pipelines.yml`.
6. Detect security scanners and IaC surfaces if present.
7. Detect docs layout, ADR folders, and whether `docs/features/` exists.
8. Record instruction conflicts (other rules that contradict this skill). Consuming-project security policy wins; this skill wins on phase order.
9. Set adaptive flags:
   - `tests.automated` true only if runner and command are evidenced
   - `ci.present` true only if a CI config file is evidenced
   - `lint.blocking` true if lint runs in CI or a documented hook
10. Instantiate [templates/capability-report.md](templates/capability-report.md). Every signal is `present`, `absent`, or `unknown` with evidence paths for `present`.

**Adaptive rule.** If the workspace is unavailable, emit the report with confidence `low`, list missing signals, and plan only with fallbacks (manual QA, no assumed linter). Do not pretend a stack exists.

---

## Phase 2. Spec and Architecture Plan Blueprint

**Objective.** Produce an unambiguous implementation blueprint under `docs/features/<feature-name>/` before any production code is written.

**Entry.** Capability report complete.

**Exit.** Feature directory exists. `spec.md`, `architecture.md`, `README.md`, and `decisions.md` are filled from templates. Feature name is locked (kebab-case).

**Steps.**

1. Derive `<feature-name>` from the approved or drafted specification title. Lowercase kebab-case. Do not reuse an unrelated existing directory.
2. If no PRD exists, either invoke `feature-specifier` first and wait, or produce a minimal spec in `spec.md` that still includes In-Scope, Out-of-Scope, requirements, and Gherkin criteria. If the request is ambiguous, stop and switch to `feature-specifier`.
3. If multiple architectural options remain, invoke `decision-matrix-architect` or produce a short decision record in `decisions.md`. Do not hide an irreversible choice inside prose.
4. Write `spec.md` using [templates/architecture-plan.md](templates/architecture-plan.md) sections that belong to product scope, or copy an upstream PRD into `spec.md` and link it.
5. Write `architecture.md` covering: context, constraints from discovery, component diagram (Mermaid, no icons), data flow, APIs, failure modes, rollout/backout, test strategy mapped to discovered runner, and files expected to change.
6. Write `README.md` as the feature index (paths, status, gate state).
7. List open assumptions with owner and risk. Unresolved product questions cannot be papered over with implementation guesses.
8. Move the capability report into the feature directory.
9. Prepare the Phase 3 gate package.

**Formatting rules.**

- Mermaid diagrams only; no emoji node labels.
- Public identifiers (routes, events, table names) are literal, not placeholders, unless the spec marks them TBD with an assumption id.
- File paths are repository-relative.

---

## Phase 3. Human Review Gate

**Objective.** Pause until the reviewer accepts the blueprint. This gate is mandatory and not waivable by the agent.

**Entry.** Phase 2 artifacts exist.

**Exit.** `review-gate.md` contains `APPROVED: feature-developer Phase 3` or a rejection change list.

**Steps.**

1. Instantiate [templates/review-gate.md](templates/review-gate.md).
2. Present: feature name, In-Scope / Out-of-Scope, architecture summary, irreversible decisions, assumption list, files expected to change, adaptive modes (tests/CI/lint), and the exact token to type.
3. Stop generating code, tests, and refactors. Do not "get a head start" in untracked files.
4. If the user replies without a valid token, restate the required format and remain stopped.
5. On `REJECTED`, apply numbered change requests to `spec.md` and/or `architecture.md`, then resubmit this phase.
6. On `APPROVED`, record the token, timestamp, and reviewer identity as stated by the user. Lock `spec.md` and `architecture.md` against silent edits.

Irreversible decisions typically include: storage engine, public API shape, authn/authz model, multi-tenancy strategy, and new network trust boundaries.

---

## Phase 4. TDD / Iterative Code Implementation

**Objective.** Implement only the approved scope, test-first, in small increments.

**Entry.** Phase 3 approved.

**Exit.** Approved behavior is implemented. Tests exist. Linting is clean on touched files if `lint.blocking`. Implementation log is up to date.

**Steps.**

1. Instantiate [templates/implementation-log.md](templates/implementation-log.md) and append one entry per increment.
2. For each increment:
   1. Select one Gherkin scenario or requirement id.
   2. Write a failing test that expresses that behavior.
   3. Run the discovered test command. Confirm failure is the intended assertion, not a compile/import error you will "fix" by deleting the test.
   4. Write the minimum production code to pass.
   5. Run tests again. Confirm pass.
   6. Refactor without changing behavior. Re-run tests.
   7. If `lint.blocking`, run the linter on touched files and fix issues.
3. Keep changes aligned with `architecture.md` file list. If a new module is required, record a deviation in the implementation log with justification. Deviations that change public API or storage require returning to Phase 3.
4. Do not implement Out-of-Scope items. Park them as follow-ups in the feature README.
5. After all in-scope scenarios are green (or written if no runner), summarize coverage vs acceptance criteria.

**Adaptive rules.**

| Discovery | Behavior |
| --- | --- |
| Runner + command | Execute the command after every increment. Record the command verbatim. |
| No command | Write tests in conventional locations. Mark `verificationMode: unverified-local`. |
| Snapshot tests | Do not update snapshots to hide failures. Snapshot updates are explicit product decisions logged in the implementation log. |

**Prohibited.** Implementing multiple scenarios in one untested dump. Mixing refactors of unrelated code. Drive-by dependency upgrades.

---

## Phase 5. Security and Edge Case Audit

**Objective.** Threat-model the change, disposition findings, and add tests or a manual checklist for mitigations.

**Entry.** Phase 4 complete for in-scope behavior.

**Exit.** `security-audit.md` complete. Every finding has a disposition. High/critical `accept-risk` requires a named human owner.

**Steps.**

1. Instantiate [templates/security-audit.md](templates/security-audit.md).
2. Identify trust boundaries touched by the change (client, edge, app, worker, datastore, third party).
3. Run STRIDE per boundary and per new or changed interface. If the change is large, invoke `sec-analyzer-tester` in full and file its outputs into the feature directory.
4. Enumerate edge cases: empty input, oversized input, concurrency, retries, timeouts, partial failure, authz negative paths, localization, clock skew.
5. For each finding: `fix` (implement now), `accept-risk` (owner + expiry), or `out-of-scope` (pointer to a new specifier item).
6. If `tests.automated`, add regression tests for each `fix`. If not, add manual QA items for Phase 7.
7. Do not treat a scanner badge as a substitute for STRIDE.

---

## Phase 6. Local Feature Docs Freeze and Global System Sync

**Objective.** Lock feature-local documents and update global system docs in one recorded sync.

**Entry.** Phase 5 complete; no open `fix` dispositions.

**Exit.** Freeze manifest written. Spec and architecture treated as immutable.

**Steps.**

1. Instantiate [templates/docs-freeze.md](templates/docs-freeze.md).
2. Finalize feature `README.md`, `spec.md`, `architecture.md`, `implementation-log.md`, `security-audit.md`, and `decisions.md`.
3. Update global documents listed in the capability report (application README, architecture overview, API catalog, runbooks, OpenAPI) only where this feature changes externally visible behavior.
4. Record every global file touched, the reason, and a summary of the diff.
5. Declare freeze: subsequent spec changes require a new change request, not edits in place.
6. Do not rewrite unrelated documentation for style.

---

## Phase 7. CI/CD Verification or Manual QA Execution

**Objective.** Prove the change in the project's actual verification system.

**Entry.** Phase 6 freeze complete.

**Exit.** `verification.md` records pass evidence or a failure that reopens Phase 4.

**Steps.**

1. Instantiate [templates/verification-report.md](templates/verification-report.md).
2. If `ci.present` and invocable, run or request the relevant workflows. Record job identifiers and results.
3. If `ci.present` but not invocable, list exact jobs the user must run and wait for logs. Do not mark passed without evidence.
4. If CI is absent, execute the manual QA checklist derived from Gherkin scenarios plus security items from Phase 5. Every item needs a result: `pass`, `fail`, or `blocked`, with evidence notes.
5. On failure, return to Phase 4 with a linked defect. Do not un-freeze docs until verification passes or the user explicitly accepts a known failure in writing.
6. On success, set feature README status to `verified` and stop.

---

## Output formatting

- Language: English. Technical, precise, no marketing tone.
- No icons or emojis.
- Status values: `draft`, `in-review`, `approved`, `implementing`, `auditing`, `frozen`, `verified`, `failed`.
- Requirement ids: `FR-###`, `NFR-###`, `AC-###`.
- Finding ids: `SEC-###`, `EDGE-###`.
- Assumption ids: `ASM-###`.

## Composition

- Upstream: `feature-specifier` (PRD), `decision-matrix-architect` (ADR).
- Embedded: `sec-analyzer-tester` may fully replace a thin Phase 5 when the change crosses multiple trust boundaries.
- Downstream: none. Verification is terminal for this skill.
