# {{TITLE}}

- Feature: `{{FEATURE_NAME}}`
- Status: {{draft | ready-for-developer}}
- Date: {{DATE}}
- Kind: {{UI | API | CLI | job | library | mixed}}

`feature-developer` implements this file and nothing else.

## Problem

- Who: {{actor or caller}}
- What is wrong or missing: {{hurt}}
- Why it matters: {{why}}

## Questions and decisions

| Q | Asked because a wrong guess would... | Answer | Spec |
| --- | --- | --- | --- |
| {{question}} | {{waste}} | {{verbatim or locked-default}} | {{what the developer must do}} |

If the user did not answer: write `locked-default` and still fill Spec. The developer may not pick a different spec.

Do not copy this coaching sentence into the output file.

## In scope

- {{behavior or entry point}}

## Out of scope (do not implement)

- {{item}} -- {{reject | defer}}

## Behavior

- {{When X happens, the system does Y.}}
- Entry points in / out: {{screens, routes, commands, jobs, or packages -- only what this kind of work has}}
- Leave / cancel / switch: {{what happens to work in progress}}
- Failure: {{what the user or caller sees or gets back}}

## Done when

```text
Given {{setup}}
When {{action}}
Then {{observable result}}
```

Cover: happy path, the important no-path, and leave/cancel. No second scenario file.

## Do not

- {{wrong product the developer might invent}}
