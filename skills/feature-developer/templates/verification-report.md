# Verification Report

- Feature: {{FEATURE_NAME}}
- Mode: {{ci | manual-qa | unverified-local | blocked}}
- Started: {{TIMESTAMP}}
- Finished: {{TIMESTAMP or empty}}
- Result: {{pass | fail | blocked}}

## Mode selection (from capability report)

| Flag | Value | Consequence |
| --- | --- | --- |
| `ci.present` | {{true|false}} | {{ci jobs or manual QA}} |
| `tests.automated` | {{true|false}} | {{command used or tests not executed}} |
| Agent can trigger CI | {{yes|no|n/a}} | {{ran jobs | waited for user logs}} |

## CI evidence

Complete this section when mode is `ci`. Otherwise mark the table `N/A`.

| Job | Identifier / URL | Lint | Test | Build | Security | Result |
| --- | --- | --- | --- | --- | --- | --- |
| {{JOB}} | {{ID}} | {{pass|fail|n/a}} | {{pass|fail|n/a}} | {{pass|fail|n/a}} | {{pass|fail|n/a}} | {{pass|fail}} |

Logs summary (no secrets):

{{TRIMMED LOG EXCERPT OR N/A}}

## Manual QA checklist

Complete this section when mode is `manual-qa` or when CI does not cover a scenario. Derived from Gherkin plus Phase 5 items.

| ID | Step | Expected | Result (`pass` / `fail` / `blocked`) | Evidence |
| --- | --- | --- | --- | --- |
| QA-001 | {{STEP}} | {{EXPECTED}} | {{RESULT}} | {{NOTE / screenshot path / log pointer}} |

A `pass` overall requires every non-N/A item to be `pass`. `blocked` overall is used when an environment dependency prevents execution; list the dependency.

## Unverified local tests

Use when tests were written but no runner or CI executed them.

| Test path | Intent | Executed | Result |
| --- | --- | --- | --- |
| {{PATH}} | {{INTENT}} | {{yes|no}} | {{pass|fail|not-run}} |

Do not report the feature as `verified` if this table is the only evidence.

## Defects

| ID | Found in | Description | Returned to | Status |
| --- | --- | --- | --- | --- |
| DEF-001 | {{job or QA-###}} | {{DESCRIPTION}} | Phase 4 | {{open | fixed | accepted}} |

## Final status

| Field | Value |
| --- | --- |
| Feature README status | {{verified | failed | blocked}} |
| Allowed to merge / ship | {{yes | no}} |
| Residual risks carried | {{SEC-### or none}} |

Overall result is `pass` only when CI is green or 100% of applicable manual QA items are `pass`, and no open defects remain.
