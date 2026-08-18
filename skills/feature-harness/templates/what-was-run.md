# What was run

- Feature: `{{FEATURE_NAME}}`
- Lock: `docs/features/{{FEATURE_NAME}}/what-to-build.md`
- Date: {{DATE}}

## Steps

| Order | Skill | Result (`pass` / `fail` / `blocked` / `cancelled` / `not-run`) | Note |
| --- | --- | --- | --- |
| 1 | `feature-developer` | {{result}} | {{note or n/a}} |

## Retries

- Verify-fail retries used: {{0 | 1}}
- Max allowed: 1

## Feedback

- Classified as: {{none | spec-mismatch | new-product | asked}}
- Then: {{n/a or what ran next}}

## Stopped because

{{pass | verify-fail | cancelled | missing-spec | empty-kitchen | review-blocked-specifier | classify-unsure}} -- {{one line}}

## Next

- {{what the operator should do, or none}}
