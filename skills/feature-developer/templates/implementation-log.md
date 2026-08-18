# Implementation Log

- Feature: {{FEATURE_NAME}}
- Test command: {{COMMAND or n/a}}
- `tests.automated`: {{true | false}}
- `lint.blocking`: {{true | false}}
- Status: {{implementing | auditing | frozen | verified | failed}}

Append one increment per section. Do not rewrite history. If an increment is abandoned, mark it `abandoned` with a reason.

## Coverage map

| Requirement / scenario | Increment | Test path | Result |
| --- | --- | --- | --- |
| {{FR-001 / AC-001}} | {{INC-001}} | {{PATH}} | {{red | green | unverified | failed}} |

---

## INC-001

- Requirement: {{FR-### / AC-###}}
- Started: {{TIMESTAMP}}
- Result: {{red-confirmed | green | abandoned}}

### Failing test

- Path: {{PATH}}
- Assertion intent: {{what must fail}}
- Command run: {{COMMAND}}
- Observed failure: {{verbatim relevant output, trimmed}}

### Production change

- Paths: {{PATHS}}
- Minimum change summary: {{SUMMARY}}

### Passing run

- Command run: {{COMMAND}}
- Observed pass: {{summary}}

### Refactor

- Performed: {{yes | no}}
- Notes: {{NOTES or n/a}}
- Tests re-run: {{yes | no}}

### Lint

- Command: {{COMMAND or n/a}}
- Result: {{pass | fail | skipped-not-blocking}}

### Deviations from architecture file list

{{none | description and whether Phase 3 re-approval is required}}

---

## Follow-ups parked (out of scope)

| Item | Reason parked |
| --- | --- |
| {{ITEM}} | {{from XSCOPE or mid-run request routed to feature-specifier}} |
