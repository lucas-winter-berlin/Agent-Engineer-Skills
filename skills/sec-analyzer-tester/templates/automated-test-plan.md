# Automated Test Plan

Use this template when Capability Discovery set `tests.automated` to true. Write tests in the consuming project's framework. This file is the map; the tests themselves live in source paths listed below.

- System under review: {{SYSTEM}}
- Framework: {{FRAMEWORK}}
- Test command: {{COMMAND}}
- Date: {{DATE}}

## Principles

1. Tests assert secure behavior (deny, validate, expire, integrity mismatch, missing role).
2. Tests do not include exploit payloads or attack playbooks.
3. Tests do not require production credentials.
4. Each `fix` mitigation maps to at least one test id.
5. `accept-risk` items are not marked passing by a vacuous test.

## Mapping

| Test id | Finding | Layer (`unit` / `integration`) | Path | Assertion (secure behavior) | Command subset |
| --- | --- | --- | --- | --- | --- |
| T-001 | SEC-001 | {{unit|integration}} | {{PATH}} | {{WHAT MUST BE TRUE}} | {{COMMAND}} |

## Implementation notes

- Follow existing test utilities and fixtures.
- Prefer the project's naming and directory conventions.
- If a new test file is required, record why existing files were insufficient.

## Execution record

| Run at | Command | Result | Notes (no secrets) |
| --- | --- | --- | --- |
| {{TIMESTAMP}} | {{COMMAND}} | {{pass|fail|not-run}} | {{NOTES}} |

## Gaps

| Finding with `fix` and no test | Reason | Resolution |
| --- | --- | --- |
| {{none or SEC-###}} | {{REASON}} | {{add test | convert to manual QA-###}} |
