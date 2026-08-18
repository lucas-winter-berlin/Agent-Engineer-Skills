# Manual QA Checklist (Security)

Use this template when Capability Discovery set `tests.automated` to false, or when a mitigation cannot be exercised in unit tests. Every item needs a result and evidence note. Do not claim CI passed.

- System under review: {{SYSTEM}}
- Environment: {{local | staging | other; never production unless the user explicitly requires it}}
- Date: {{DATE}}
- Operator: {{NAME or empty}}

## Preconditions

| ID | Precondition | Satisfied (`yes` / `no`) |
| --- | --- | --- |
| PRE-001 | {{ACCOUNT / DATA / CONFIG needed}} | {{yes|no}} |

If any precondition is `no`, mark the dependent items `blocked`.

## Items

Steps describe legitimate verification of controls (attempt an unauthorized action and expect denial). They are not attack recipes. Do not include payload construction guidance.

| ID | Finding | Setup | Action | Expected secure result | Result (`pass` / `fail` / `blocked`) | Evidence |
| --- | --- | --- | --- | --- | --- | --- |
| QA-001 | SEC-001 | {{SETUP}} | {{UNAUTHORIZED OR INVALID ACTION IN PRODUCT TERMS}} | {{DENY / VALIDATE / NO LEAK}} | {{RESULT}} | {{LOG POINTER / NOTE}} |

Minimum coverage when applicable:

- Unauthenticated request to an authenticated route is denied
- Authenticated user cannot access another tenant's record
- Invalid or oversized input is rejected without stack traces containing secrets
- Expired or malformed token is rejected
- Admin action is denied to a non-admin
- Rate-limiting or timeout degrades safely if that control was in the mitigation plan

## Residual-risk reviews

| Finding | Review action | Due | Result |
| --- | --- | --- | --- |
| {{SEC-### accept-risk}} | {{WHAT TO RECHECK}} | {{DATE}} | {{open | done}} |

## Overall

| Field | Value |
| --- | --- |
| Items passed | {{N}} |
| Items failed | {{N}} |
| Items blocked | {{N}} |
| Ready to report complete | {{yes only if failed=0 and blocked=0}} |
