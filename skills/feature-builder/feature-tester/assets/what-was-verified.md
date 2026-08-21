# What was verified

- Feature: `{{FEATURE_NAME}}`
- Built from: `agent-engineer-skills/{{FEATURE_NAME}}/what-to-build.md`
- Date: {{DATE}}

## Test cases added or updated

| Case | From spec | Path |
| --- | --- | --- |
| {{name}} | {{done-when or wall}} | {{test file}} |

## Commands run

| Layer | Command | Result | Reason if not-run |
| --- | --- | --- | --- |
| Unit | {{command or absent}} | {{pass / fail / not-run}} | {{reason}} |
| Integration | {{command or absent}} | {{pass / fail / not-run}} | {{reason}} |
| E2E | {{command or absent}} | {{pass / fail / not-run}} | {{reason}} |
| Security | {{command or absent}} | {{pass / fail / not-run}} | {{reason}} |

## Slop check

- Done-when covered: {{yes / gaps}}
- Walls still held (no extra product): {{yes / what leaked}}
- Tests assert real behavior: {{yes / which test is hollow}}

## Manual checks (only if no runner for that path)

- {{steps and result, or none}}

## Verdict

{{pass | fail | not-run}} -- {{one line}}
