# {{TITLE}}

- Feature: `{{FEATURE_NAME}}`
- Status: {{awaiting-questions | draft | ready-for-developer}}
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

Given {{setup}}
When {{the important no-path}}
Then {{what the user sees or the caller gets back}}

Given {{work in progress}}
When {{the user leaves, cancels, or switches}}
Then {{what happens to that work}}
```

## Do not

- {{wrong product the developer might invent}}
