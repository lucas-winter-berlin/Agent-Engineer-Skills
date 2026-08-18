---
name: sec-analyzer-tester
description: >-
  Performs threat modeling, vulnerability mitigation planning, and adaptive
  test-plan generation using trust-boundary mapping and STRIDE. Generates
  automated unit and integration tests when a test framework is discovered;
  otherwise produces a structured manual QA checklist. Use when the user asks
  for threat modeling, security tests, STRIDE analysis, or a security QA plan.
---

# sec-analyzer-tester

Threat modeling, vulnerability mitigation, and adaptive test-plan generation. This file is an execution contract. STRIDE is mandatory. Scanner output is an input, not a substitute. Adaptive output changes the test artifact, not the requirement to model threats.

Canonical schema: [schema.json](schema.json). Framework: [docs/ARCHITECTURE.md](../../docs/ARCHITECTURE.md).

## When to use

Use when work crosses a trust boundary, handles authentication or authorization, processes sensitive data, exposes a network interface, or the user asks for threat modeling, vulnerability analysis, or a security test plan.

Do not use for copy edits, comment-only changes, or purely internal documentation with no process or exposure impact. Do not perform STRIDE theater on changes that do not cross a trust boundary; instead, record "no trust boundary crossed" and stop after a short local tampering/repudiation check if still requested.

## Guardrails

Must:

1. Announce `Using skill: sec-analyzer-tester`.
2. Map trust boundaries before listing threats.
3. Apply STRIDE to each boundary and each new or changed interface.
4. Severity-rate every finding (`low`, `medium`, `high`, `critical`).
5. Disposition every finding: `fix`, `accept-risk`, or `out-of-scope`.
6. Require a named human owner for high/critical `accept-risk`. The agent cannot self-own residual risk.
7. Run Capability Discovery for test framework and CI before choosing the test artifact type.
8. If a test framework exists, generate automated unit and/or integration tests for mitigations. If it does not, generate a structured manual QA checklist. Never skip both.
9. No icons or emojis. No exploit payloads, weaponized PoCs, or attack reproduction procedures. Tests assert secure behavior (deny, validate, encrypt, expire) without providing offensive how-tos.

Must not:

1. Claim "no findings" without a completed STRIDE table.
2. Treat a green scanner as STRIDE completion.
3. Generate malware, exploit code, or step-by-step attack playbooks.
4. Mark `accept-risk` on critical findings without a human owner and expiry.
5. Implement unrelated features under the guise of hardening.
6. Log secrets in artifacts.

## STRIDE catalog

| Letter | Category | Question the agent must answer per boundary |
| --- | --- | --- |
| S | Spoofing | Can an actor claim a false identity here? |
| T | Tampering | Can data or code be modified in transit or at rest? |
| R | Repudiation | Can an actor deny an action due to missing or weak audit? |
| I | Information Disclosure | Can data be read by an unauthorized party? |
| D | Denial of Service | Can availability be degraded by abuse of this interface? |
| E | Elevation of Privilege | Can an actor gain a higher role or bypass authz? |

If a category does not apply, write `N/A` with a one-line reason. Blank cells are invalid.

## Adaptive test output

| Discovery | Output |
| --- | --- |
| Test runner and command evidenced | Automated tests in the project's style plus a short mapping table from `SEC-###` to test ids |
| Runner absent | [templates/manual-qa-checklist.md](templates/manual-qa-checklist.md) only for tests; threat model still required |
| CI present | Note which CI jobs should run the new tests; do not invent jobs |
| Existing scanners | Ingest findings as extra rows; still complete STRIDE |

Automated tests must follow the consuming project's framework. Prefer:

- Negative authorization tests
- Input validation tests
- Token expiry / audience / issuer tests where auth exists
- Integrity tests for signed or hashed payloads
- Failure-mode tests that fail closed

Do not write tests that require live production credentials.

## Phases

### Phase 1. Capability Discovery (security-relevant)

**Objective.** Detect test framework, CI, scanners, and identity/storage components.

**Steps.**

1. Reuse a feature capability report if present; otherwise inspect the workspace for test command, CI, linters, auth libraries, and data stores.
2. Record `tests.automated` and `ci.present`.
3. Identify candidate identity providers, session mechanisms, and secret managers from manifests and config filenames. Do not dump secret values.

### Phase 2. System and trust boundaries

**Objective.** Define the system under review and its boundaries.

**Steps.**

1. Instantiate [templates/threat-model.md](templates/threat-model.md).
2. Draw a Mermaid data-flow diagram. Nodes are processes, stores, and actors. Edges are data flows. No icons.
3. List trust boundaries (network, process, privilege, organizational).
4. List assets (credentials, PII, tokens, admin functions, integrity of records).
5. List assumptions (`ASM-###`) including "attacker is on the public network" unless the system is documented as isolated.

### Phase 3. STRIDE analysis

**Objective.** Produce findings.

**Steps.**

1. For each boundary and each flow, answer all six STRIDE questions.
2. Write `SEC-###` findings with affected asset, attacker precondition (high level, not a recipe), impact, and severity.
3. Deduplicate. Merge identical issues across flows with multiple boundary references.

### Phase 4. Mitigations

**Objective.** Map findings to controls.

**Steps.**

1. Instantiate [templates/mitigation-plan.md](templates/mitigation-plan.md).
2. For each finding, propose a mitigation aligned with existing architecture (do not introduce a new vendor unless necessary; if necessary, flag `decision-matrix-architect`).
3. Disposition: `fix` now, `accept-risk` with owner and expiry, or `out-of-scope` with a specifier follow-up.
4. Stop for `APPROVED: sec-analyzer-tester Phase 4` before accepting high/critical residual risk. Fixes that are clearly in scope may proceed to Phase 5 without that token.

### Phase 5. Adaptive test generation

**Objective.** Prove mitigations.

**Steps.**

1. If `tests.automated`, instantiate [templates/automated-test-plan.md](templates/automated-test-plan.md) and write the tests in the repository using TDD against secure behavior.
2. If not, instantiate [templates/manual-qa-checklist.md](templates/manual-qa-checklist.md).
3. Map every `fix` to at least one test or QA item.
4. `accept-risk` items get a monitoring or review QA item, not a fake passing test.

### Phase 6. Report freeze

**Objective.** Hand off a complete pack.

**Steps.**

1. Index all artifacts. Residual risks listed first.
2. If invoked from `feature-developer` Phase 5, copy or link the pack into `docs/features/<feature-name>/security-audit.md`.
3. Do not claim the system is "secure." Claim that identified threats were modeled and dispositions recorded.

## Severity rubric

| Severity | Meaning |
| --- | --- |
| critical | Direct, likely compromise of a high-value asset or auth boundary with low attacker effort |
| high | Significant confidentiality, integrity, or availability impact with a realistic path |
| medium | Limited impact or higher attacker effort; still must be dispositioned |
| low | Defense-in-depth gap or low-likelihood issue |

## Composition

- Embedded in `feature-developer` Phase 5.
- May run on a PRD from `feature-specifier` before code exists (threat model only; automated tests wait for interfaces).
- May require `decision-matrix-architect` when mitigations imply an irreversible control choice (for example in-app authz vs gateway policy).
