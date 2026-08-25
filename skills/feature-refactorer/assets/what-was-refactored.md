# What was refactored

- Name: `{{FEATURE_NAME}}`
- Status: {{refactored | blocked-need-ask | blocked-need-specifier | blocked-need-reviewer}}
- Branch: `{{BRANCH}}`
- Base branch: `{{BASE_BRANCH}}`
- Commit: `{{SHA}}`
- Date: {{DATE}}

## Scope

In:

- {{path}}

Out:

- {{path or none}}

## Invariants

- {{what must not change: public signature, route, schema, user-visible copy}}

## What I changed internally

- {{structural change, or none}}

## Where

| Path | Change |
| --- | --- |
| {{path}} | {{create / modify / delete -- one line}} |

## Tests

- Command run: {{existing test command, or none in this repo}}
- Result: {{pass / fail / not-run, and why}}
- Already failing before this change: {{none, or which tests}}

## Walls held

- Behavior unchanged: {{yes}}
- Did not add: {{short list, or none}}
- Stopped to ask: {{none, or the landmine}}
