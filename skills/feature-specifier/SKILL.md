---
name: feature-specifier
description: >-
  Use when someone wants a feature, change, or improvement in an existing
  codebase and what to build is not yet pinned down: a rough idea, a complaint
  about missing capability, a "can we make X better", or a request where "done"
  is undefined. Asks the few questions whose wrong answers would waste
  implementation time, then writes agent-engineer-skills/<name>/what-to-build.md
  with locked decisions, scope walls, and observable done-when checks. Covers
  UI, API, CLI, jobs, libraries, and mixed work. Use even when the user does not
  say "spec", "PRD", "requirements", or "acceptance criteria". Do not use for a
  new project, prototype, MVP, or pitch (mvp-specifier), for a defect with
  expected vs actual (feature-bug-analyst), for an exact one-line change, when
  a specification already exists and the user wants it built
  (feature-developer), reviewed (feature-code-reviewer), or tested
  (feature-tester), or to restructure existing code (feature-refactorer).
compatibility: >-
  Works in any Agent Skills host. Uses the host's clickable multiple-choice UI
  for the question batch when one exists (for example Cursor AskQuestion), and
  falls back to lettered options in chat. Writes files. No network access or
  system packages required.
license: PolyForm Noncommercial License 1.0.0
metadata:
  author: Lucas Winter
  version: "1.0"
  family: feature-builder
---

# feature-specifier

Core job: understand the idea, problem, or feature. Ask the questions whose wrong answers would waste implementation time. Hand `feature-developer` one concept so the developer cannot invent a different product.

Do not write code. Do not produce a multi-file PRD pack.

Output: `<root>/<feature-name>/what-to-build.md` from [assets/what-to-build.md](assets/what-to-build.md). Resolve `<root>` as in Gotchas.

## When to use

The request is an idea, a problem, or a feature, and "done" is not specified.

Do not use when the change is a defect to root-cause (`feature-bug-analyst`), already exact and trusted as a one-line edit, the user only wants code, review, or tests on an existing specification, or the request is a behavior-preserving cleanup of existing code (`feature-refactorer`).

## Gotchas

- **Write-up root.** `<root>` is the docs **directory** named on the Feature-folder write-ups line in the repo's `AGENTS.md`. If that line is missing, use the same line in `.cursor/rules/agent-engineer-skills.mdc`. If both are missing, `<root>` is `agent-engineer-skills`. Create `<root>` as a folder if needed. Never create or read a file named `aes-write-up-root`. Write `<root>/<kebab-name>/what-to-build.md`. If `docs/features/<kebab-name>/` already exists for that name and `<root>/<kebab-name>/` does not, write there instead. Never create both trees for one name.
- `concept.md` is the old filename for this artifact, and the downstream skills still read it. Always write `what-to-build.md`. Never create a `concept.md`.
- `locked-default` binds the developer. Writing one means you decided on the user's behalf and the developer may not choose otherwise. Use it only after the user declined to answer, never to save a round of questions.
- A new project, prototype, MVP, or pitch belongs to `mvp-specifier`, even when the user phrases it as a feature. `pitch-to-spec` is that skill's old name, not this one's.
- The repo already answers some of these questions. Read it before asking, and drop anything the request or the codebase has settled.

## How

1. **Restate** the request in a few lines. Add nothing. Name the kind of work (UI, API, CLI, job, library, mixed) from the request and the repo, not from habit.
2. **Find landmines** using the types below. Ask only the types that would cause rework **on this request**.
3. **Ask** those questions in one batch, as clickable choices. Do not ask what the user or the repo already answered. Do not ask two questions that are the same decision.
4. **Write the specification.** Decisions, in/out, behavior, done-when, walls.
5. **Check** the file against every line of `Before you finish` below. Fix what fails, then check again. Do not hand over while a line fails.

If a leftover decision is still easy to get wrong, ask another round. Do not leave it for the developer.

## Landmine types (pick what applies)

Do not walk this list as a questionnaire. Skip any type the request or repo already decided.

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

- Typical load is 3-7. The penalty is for leaving a landmine unasked, not for asking few.
- Drop overlapping options.
- Stop when leftovers are harmless (copy, spacing, log wording) or a `locked-default`.
- Record Q and A inside `what-to-build.md`. No second questions file.

### How to ask (binding)

If the host has clickable multiple choice (Cursor `AskQuestion` or equivalent), MUST use it for the whole batch. One call, lettered options, optional Other.

MUST NOT print the questionnaire only as chat prose when that UI exists.

If the click UI is missing or failed, print letters and one line: `Choice UI unavailable; answer with letters.`

## what-to-build.md rules

The template supplies the required sections. Fill them. Do not add more.

MUST NOT include:

- Extra PRD / clarification / acceptance files
- FR/NFR/AC ID factories and traceability matrices
- Data-model tables unless this change persists or exposes a new contract
- Essays. Bullets, tables, short fences. Usually under 120 lines. Cut repetition, not walls
- Instructions to the reader about how to fill the file

## Before you finish

Check `what-to-build.md` against every line here. Fix what fails, then check again.

- The header names the feature, and Status reads `awaiting-questions`, `draft`, or `ready-for-developer`.
- In scope and Out of scope each list at least one item.
- Every decisions row has both an Answer and a Spec, and no Spec cell is empty.
- Done when holds at least one Given/When/Then, covering the happy path, the important no-path, and leave or cancel.
- Every done-when check is observable: a second person runs it and gets the same yes or no. No "works well", no "is fast".
- Every entry point this kind of work has is written as in scope or out of scope. None are left unmentioned.
- Any work that can be interrupted states what happens on leave, cancel, or switch.
- Any path that can fail or wait states what the user sees or the caller gets back.
- Every landmine you found is answered by the user or written as `locked-default`. None are open.
- "Do not" names the specific wrong product this idea invites, not a generic warning.
- Out of scope is a wall: nothing listed there is needed to satisfy done-when.
- The file holds the specification only. No leftover placeholders, no notes about how to fill it in.

## Guardrails

MUST:

1. Announce `Using skill: feature-specifier`.
2. Treat out-of-scope as hard walls.
3. English. No icons or emojis.

MUST NOT:

1. Implement source, refactors, or CI.
2. Leave "handle it appropriately".
3. Treat out-of-scope as stretch goals.
4. Specify class names unless the user required them.

## Handoff

Point `feature-developer` at `what-to-build.md`. If two real technical options remain (libraries, stores), ask. Do not leave the developer to pick. Product choices stay in this skill.
