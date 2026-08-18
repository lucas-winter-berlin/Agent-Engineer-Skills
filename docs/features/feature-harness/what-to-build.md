# Feature path harness

- Feature: `feature-harness`
- Status: ready-for-developer
- Date: 2026-08-18
- Kind: mixed (skill contract in this repo; job the agent runs in a consuming project)

`feature-developer` implements this file and nothing else.

## Problem

- Who: The operator talking to the agent in a consuming project (same as the other skills).
- What is wrong or missing: The four skills only run if someone names each one. After a fail or after feedback, the next skill is easy to skip or to send to the wrong job.
- Why it matters: A lock, then code, then review, then tests should be one path with one retry, not four separate reminders.

## Questions and locked decisions

| Q | Asked because a wrong guess would... | Answer | Lock |
| --- | --- | --- | --- |
| Where does v1 live? | Build a Cursor-only robot instead of a portable skill | Fifth skill `feature-harness` | Add `skills/feature-harness/` plus `.cursor/rules/feature-harness.mdc`. Same install as the other skills. Not an Automation, not an SDK/CLI runtime |
| Verify-fail retries? | Infinite loops or a stop that is too weak | One retry, then stop | First pass: develop → review → verify. If verify verdict is fail: one more develop → review → verify. If still fail: stop and wait. Do not loop further |
| User feedback after a run? | Auto-developer invents extra product | Classify | Lock-mismatch / bug vs lock → develop → review → verify. New product or extra scope → run `feature-specifier`, then those three. If unsure, ask. Do not recode a new product as a "fix" |
| Empty repo / no stack? | Scaffold a stack the operator did not pick | Out of scope | If there is no language/layout to match, stop. Do not invent a stack. Harness runs slices in an existing kitchen |
| Fifth write-up? | Operator cannot see what ran | Yes | Write `docs/features/<name>/what-was-run.md` from this skill's template |

## In scope

- Skill `feature-harness`: SKILL.md, schema.json, template `what-was-run.md`, Cursor rule, dispatcher row, README/GUIDE/ARCHITECTURE mention.
- One command: `Use skill: feature-harness` plus a feature folder or lock path.
- If `what-to-build.md` (or older `concept.md`) exists: run `feature-developer`, then `feature-code-reviewer`, then `feature-verifier`, by following each skill's `SKILL.md` in order. Announce each inner skill as that skill requires.
- Verify fail: exactly one retry of develop → review → verify, then stop if still fail.
- User feedback on an already-run folder: classify as above (including specifier when it is new product).
- Cancel: if the operator says stop / cancel, halt, write `what-was-run.md` with why, do not start the next skill.
- Failure the operator can see: missing lock, verify still fail after retry, review blocked because the product would change, empty kitchen, classify-unsure question.

## Out of scope (do not implement)

- Cursor Automation, Cursor SDK, CLI daemon, GitHub Action -- reject
- Greenfield stack scaffold -- reject
- Queue of many features, dashboard, web UI -- reject
- Infinite verify retry -- reject
- Replacing or rewriting the four existing skills -- reject
- Auto-start specifier when there is no lock and no product-feedback message -- reject (tell them to use `feature-specifier`)
- New test runner, CI, or extra spec pack in the consuming app -- reject

## Behavior

- Entry in: `Use skill: feature-harness` in Agent chat (Cursor or Gemini Gem), with `docs/features/<name>/` or `what-to-build.md`. Dispatcher also maps "run the path", "end to end", "harness" to this skill when a lock is in play.
- Entry out: no Automation trigger, no HTTP, no `npx` runner.
- Start: if the folder/lock is missing, stop. Name `feature-specifier`. Write `what-was-run.md` only if a feature name is already known; otherwise say so in chat and write nothing.
- Happy path: develop, review, verify. If verify passes, write `what-was-run.md` (steps, retries used = 0, stopped-because = pass) and stop.
- Review `fail` on code: that skill keeps going until must-fix is gone (not a harness retry). Review blocked-specifier: stop, record it, wait. Do not auto-specifier unless the operator's next message is classified as new product.
- Verify `fail`: one retry of the three skills. Record retries used = 1. Still fail → stop and wait.
- Feedback cycle is a new run of the path (retry budget resets to one verify-fail retry).
- Leave / cancel / switch: stop immediately. Do not start the next inner skill. Finish `what-was-run.md` with stopped-because = cancelled.
- Failure: missing lock → specifier named, no code. Empty kitchen → stop, no scaffold. Classify unsure → ask, do not pick. Inner skill blocked on questions → wait; do not skip them.

## Done when

```text
Given a consuming repo with a locked docs/features/<name>/what-to-build.md
When the operator uses feature-harness on that folder
Then the agent announces feature-harness, then runs developer, reviewer, and verifier in that order
And writes docs/features/<name>/what-was-run.md listing those steps

Given verify fails on the first pass
When the harness retries
Then it runs develop → review → verify exactly once more
And if that still fails it stops, waits, and the log says retries used = 1 and stopped-because = verify-fail

Given the operator says stop while a skill is running
When the harness sees cancel
Then it does not start the next skill
And what-was-run.md records cancelled

Given what-to-build.md is missing
When they use feature-harness
Then no implement/review/verify runs
And they are told to use feature-specifier

Given a finished run and the operator describes extra product
When the harness classifies feedback
Then it runs feature-specifier (questions + lock update) before developer
And does not send that message straight to developer
```

## Do not

- Do not build an SDK, Automation, or background worker.
- Do not scaffold a new app stack.
- Do not treat "also add billing" as a developer fix.
- Do not retry verify more than once per run.
- Do not skip review on the way to verify.
- Do not invent a sixth feature write-up besides `what-was-run.md`.
