---
name: feature-specifier
description: >-
  Understands an idea, problem, or feature in any kind of software project by
  asking critical questions, then writes docs/features/<name>/what-to-build.md that
  feature-developer can implement without guessing. Use when the request is
  fuzzy or "done" is not locked, for UI, API, CLI, jobs, libraries, or mixed work.
---

# feature-specifier

Core job: understand the idea, problem, or feature. Ask the questions whose wrong answers would waste implementation time. Hand `feature-developer` one concept so the developer cannot invent a different product.

This skill is **universal**: same job in a website, API, CLI, worker, library, game, or mixed repo. It is **not** vague: only landmine questions, then hard locks and walls.

Do not write code. Do not produce a multi-file PRD pack.

Output: `docs/features/<feature-name>/what-to-build.md` from [templates/what-to-build.md](templates/what-to-build.md).

## When to use

The request is an idea, a problem, or a feature, and "done" is not locked.

Do not use when the change is already exact (known bug, one-line fix), or the user only wants code, review, tests, or the path run on an existing lock.

## How

1. **Restate** the request in a few lines. Add nothing. Name the kind of work (UI, API, CLI, job, library, mixed) from the request and the repo, not from habit.
2. **Find landmines** using the types below. Ask only the types that would cause rework **on this request**.
3. **Ask** those questions in one batch, as clickable choices. Do not ask what the user or the repo already answered. Do not ask two questions that are the same decision.
4. **Write the concept.** Locked decisions, in/out, behavior, done-when, walls.
5. **Check** that a developer who follows only `what-to-build.md` cannot reasonably ship the wrong thing.

If a leftover decision is still easy to get wrong, ask another round. Do not leave it for the developer. If the user will not answer, write `locked-default` in `what-to-build.md`. That default is then mandatory.

## Landmine types (pick what applies)

Do not walk this list as a questionnaire. Skip any type the request or repo already locks.

| Type | Wrong guess wastes time on... | Ask about this when |
| --- | --- | --- |
| Who | Auth, roles, public vs signed-in | It is unclear who may use or trigger it |
| Where it lives | Building the wrong entry point | It is unclear which screens, routes, commands, jobs, or packages |
| Data | Files vs compute, schema, payload | It is unclear what is stored, computed, or sent |
| Lifecycle | State after leave, retry, cancel, switch | Work continues, can be cancelled, or spans steps |
| Failure | Empty UI, 500, silent drop | The user or caller can hit a no-path |
| Extra product | SDK, extra screens, extra endpoints | The idea is easy to over-build |

**Where it lives** means the real entry points for this repo, not "always a modal":

- UI: pages, modals, drawers, mobile, CLI screens
- API: routes, events, consumers
- CLI: commands and flags
- Job / worker: trigger and what happens if it is killed
- Library: public functions or types the caller sees

For UI or other interaction, `what-to-build.md` MUST list each relevant entry as in-scope or out, and MUST say what happens on close, navigation, cancel, or equivalent leave. If the user can wait or fail, say the visible or returned failure.

For non-UI work, do not invent page/modal questions. Use routes, commands, jobs, or APIs instead.

## Questions

Ask only if a wrong guess would cause rework.

- Typical load is 3-7. Penalty for leaving a landmine unasked, not for asking fewer than five.
- Drop overlapping options.
- Stop when leftovers are harmless (copy, spacing, log wording) or a `locked-default`.
- Record Q and A inside `what-to-build.md`. No second questions file.

### How to ask (binding)

If the host has clickable multiple choice (Cursor `AskQuestion` or equivalent), MUST use it for the whole batch. One call, lettered options, optional Other.

MUST NOT print the questionnaire only as chat prose when that UI exists.

If the click UI is missing or failed, print letters and one line: `Choice UI unavailable; answer with letters.`

## what-to-build.md rules

MUST include:

- Problem (who, what hurts, why)
- Locked decisions
- In scope / out of scope (walls)
- Behavior (what happens; entry points in or out; leave/cancel; failure)
- Done when: observable checks. Happy path, important no-path, leave/cancel
- Do not implement: the extra product a developer might invent

MUST NOT include:

- Extra PRD / clarification / acceptance files
- FR/NFR/AC ID factories and traceability matrices
- Data-model tables unless this change persists or exposes a new contract
- Essays. Bullets, tables, short fences. Usually under 120 lines. Cut repetition, not walls
- Template coaching lines (for example “If the user did not answer…”)

## Guardrails

MUST:

1. Announce `Using skill: feature-specifier`.
2. Write `docs/features/<kebab-name>/what-to-build.md`.
3. Treat out-of-scope as hard walls.
4. English. No icons or emojis.

MUST NOT:

1. Implement source, refactors, or CI.
2. Leave "handle it appropriately".
3. Treat out-of-scope as stretch goals.
4. Specify class names unless the user required them.

## Handoff

Point `feature-developer` at `what-to-build.md`. If two real technical options remain (libraries, stores), ask. Do not leave the developer to pick. Product choices stay in this skill.
