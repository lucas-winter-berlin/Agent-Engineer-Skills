# {{TITLE}}

- Feature: `{{FEATURE_NAME}}`
- Status: {{awaiting-questions | draft | ready-for-developer | blocked-need-evidence}}
- Date: {{DATE}}
- Kind: {{UI | API | CLI | job | library | mixed}}
- Origin: `feature-bug-analyst`
- Root-cause status: {{confirmed | likely | blocked-need-evidence}}

`feature-developer` implements this file and nothing else. Write the failing test named below before changing product code.

## Problem

- Expected: {{observable correct behavior}}
- Actual: {{observable wrong behavior}}
- Reproducibility: {{always | intermittent | unknown -- and how often}}
- Environment: {{only what matters: app surface, OS/browser/runtime, env name, or n/a}}
- Why it matters: {{hurt}}

## Reproduction

1. {{step}}
2. {{step}}
3. {{observable failure}}

## Questions and decisions

| Q | Asked because a wrong guess would... | Answer | Spec |
| --- | --- | --- | --- |
| {{question or none}} | {{waste}} | {{verbatim, locked-default, or n/a}} | {{what the developer must do}} |

## Hypotheses

| Rank | Hypothesis | Verdict | Evidence |
| --- | --- | --- | --- |
| 1 | {{cause}} | {{confirmed | rejected | open}} | {{path:line or log fact}} |

## Root cause

- Status: {{confirmed | likely | blocked-need-evidence}}
- Cause: {{precise explanation tied to evidence; if likely, say what would disprove it}}
- Evidence: {{path:line, and any log or test fact}}

## Affected code

Paths the developer must change or must read for the fix. Neighbors go under Regression risks.

| Path | Lines | Role |
| --- | --- | --- |
| {{path}} | {{lines or range}} | {{change | read -- why}} |

## In scope

- {{the smallest behavior change that restores Expected}}

## Out of scope (do not implement)

- {{item}} -- {{reject | defer}}

## Behavior

- {{When X happens, the system does Y (the corrected contract).}}
- Entry points in / out: {{screens, routes, commands, jobs, or packages -- only what this kind of work has}}
- Leave / cancel / switch: {{what happens, or n/a}}
- Failure: {{what the user or caller sees or gets back after the fix}}

## Done when

```text
Given {{reproduction setup}}
When {{the failing action}}
Then {{Expected holds}}

Given {{setup}}
When {{important adjacent path}}
Then {{no regression}}
```

## Proposed failing test

- Layer: {{unit | integration | e2e -- matching this repo}}
- Where to put it: {{existing test folder or file pattern, or none if this repo has no runner}}
- Asserts: {{what fails today and must pass after the fix}}
- Developer writes this test first, confirms it fails, then fixes.

## Fix approach

- Minimal change: {{what to change; name functions or modules, not a rewrite}}
- Edge cases: {{none, or only cases already in Reproduction / Done when -- no speculative extras}}

## Regression risks

- {{adjacent area or dependency that a fix could break}}

## Do not

- {{wrong product, rewrite, or hardening the developer might invent}}
