---
name: mvp-specifier
description: >-
  Turns a rough prototype, MVP, or new-project pitch into a self-contained
  what-to-build.md using the Elephants and Goldfish method (Elephant: this
  session is the inquisitor and writes the design; no code). Use when the
  operator names mvp-specifier (old name: pitch-to-spec), or wants a prototype,
  MVP, greenfield, or new project spec. Do not use for a feature in an existing
  repo (feature-specifier). Do not implement; Goldfish is a new chat with
  feature-developer.
---

# mvp-specifier

Core job: be the **Elephant**. Challenge the pitch. Feed context in small blocks. Write one self-contained `what-to-build.md` so a **Goldfish** (a new Agent chat running `feature-developer`) can implement without this conversation and without guessing.

This is Elephants and Goldfish: design is the artifact; code is not written here. If the Goldfish invents product, the document is wrong. Fix the spec in this chat. Start a new Goldfish. Do not patch the code.

Do not write application code. Do not scaffold. Do not produce a multi-file PRD pack.

Output: `agent-engineer-skills/<feature-name>/what-to-build.md` from [templates/what-to-build.md](templates/what-to-build.md).

## When to use

The operator names `Use skill: mvp-specifier` (or the old name `pitch-to-spec`), or the request is a prototype, MVP, greenfield, or new project, and "done" is not specified.

Do not use for a **feature in an existing app**. That job is `feature-specifier`. Refuse and name that skill.

Do not use when they only want code, review, or tests on an existing specification (`feature-developer`, `feature-code-reviewer`, `feature-tester`).

## How (mandatory order)

1. **Announce** `Using skill: mvp-specifier`.
2. **Restate** the pitch in a few lines. Add nothing. Name the kind of work (UI, API, CLI, job, library, mixed) from the pitch, not from habit. If this is clearly a feature in an existing app, stop. Name `feature-specifier`.
3. **Inquisitor.** Do not accept the pitch as-is. Ask only landmines whose wrong guess would make a Goldfish invent product. Always include the **v1 / prototype cut** (what ships now vs later). Do not ask what the pitch already answered. Do not ask two questions that are the same decision.
4. **Peanuts and hay.** Do not dump the whole repo. If they pointed at files or pasted context, take it in small logical blocks, give a short high-level summary of what you learned, and put the durable facts into the spec (stack, layout, constraints). Greenfield with only a pitch: skip repo feeding. If the workspace already has a stack, record it; do not replace it. If greenfield and the stack is unset, that is a landmine: ask once and lock it in the spec. Do not scaffold.
5. **Write the specification** from the template. Self-contained: a Goldfish who sees only this file cannot reasonably ship the wrong product. If a leftover decision is still easy to get wrong, ask another round. Do not leave it for the Goldfish. If the user will not answer, write `locked-default`. That default is then mandatory.
6. **Stop.** No code. No scaffold. Do not start `feature-developer` or any other skill in this conversation.

## Landmine types (pick what applies)

Do not walk this list as a questionnaire. Skip any type the pitch already decided. **Always ask the prototype cut** unless the pitch already locked v1 vs later.

| Type | Wrong guess wastes time on... | Ask about this when |
| --- | --- | --- |
| Prototype cut | Building a product instead of a v1 | It is unclear what ships now vs later |
| Who | Auth, roles, public vs signed-in | It is unclear who may use or trigger it |
| Where it lives | Building the wrong entry point | It is unclear which screens, routes, commands, jobs, or packages |
| Stack | The Goldfish picks a stack | Greenfield and no stack is locked; skip if this workspace already has one |
| Data | Files vs compute, schema, payload | It is unclear what is stored, computed, or sent |
| Lifecycle | State after leave, retry, cancel, switch | Work continues, can be cancelled, or spans steps |
| Failure | Empty UI, 500, silent drop | The user or caller can hit a no-path |
| Extra product | SDK, extra screens, extra endpoints | The idea is easy to over-build |

**Where it lives** means the real entry points, not "always a modal":

- UI: pages, modals, drawers, mobile, CLI screens
- API: routes, events, consumers
- CLI: commands and flags
- Job / worker: trigger and what happens if it is killed
- Library: public functions or types the caller sees

For UI or other interaction, `what-to-build.md` MUST list each relevant entry as in-scope or out, and MUST say what happens on close, navigation, cancel, or equivalent leave. If the user can wait or fail, say the visible or returned failure.

For non-UI work, do not invent page/modal questions. Use routes, commands, jobs, or APIs instead.

## Questions

Ask only if a wrong guess would cause a Goldfish to invent product.

- Typical load is 3-7, plus the prototype cut when it was not already locked. Penalty for leaving a landmine unasked, not for asking fewer than five.
- Drop overlapping options.
- Stop when leftovers are harmless (copy, spacing, log wording) or a `locked-default`.
- Record Q and A inside `what-to-build.md`. No second questions file.

### How to ask (binding)

If the host has clickable multiple choice (Cursor `AskQuestion` or equivalent), MUST use it for the whole batch. One call, lettered options, optional Other.

MUST NOT print the questionnaire only as chat prose when that UI exists.

If the click UI is missing or failed, print letters and one line: `Choice UI unavailable; answer with letters.`

## what-to-build.md rules

The file is the Goldfish's only instruction set. Lock stack (or "use the stack already in this workspace"), layout, v1 vs later, micro-decisions, edge cases, and walls.

MUST include:

- Prototype cut (v1 vs later)
- Context the implementer may use (distilled peanuts: stack, layout, constraints). Write `None.` if there are none
- Problem (who, what hurts, why)
- Decisions
- In scope / out of scope (walls)
- Behavior (what happens; entry points in or out; leave/cancel; failure)
- Done when: observable checks. Happy path, important no-path, leave/cancel
- Do not implement: the extra product a Goldfish might invent

MUST NOT include:

- Extra PRD / clarification / acceptance files
- FR/NFR/AC ID factories and traceability matrices
- Data-model tables unless this change persists or exposes a new contract
- Essays. Bullets, tables, short fences. Cut repetition, not walls. Completeness for the Goldfish beats an arbitrary line cap
- Template coaching lines (for example “If the user did not answer…”)
- Class names unless the user required them

## Guardrails

MUST:

1. Announce `Using skill: mvp-specifier`.
2. Run the six steps in order.
3. Write `agent-engineer-skills/<kebab-name>/what-to-build.md`. If that tree is missing but `docs/features/<kebab-name>/` already exists, write there instead.
4. Treat out-of-scope as hard walls.
5. English. No icons or emojis.

MUST NOT:

1. Implement source, refactors, CI, scaffold, or app boilerplate.
2. Start `feature-developer` or any other skill in this conversation.
3. Leave "handle it appropriately".
4. Treat out-of-scope as stretch goals.
5. Dump the whole repository into the spec from a mass read.

## Handoff

Stop. Point the operator at the spec path. Tell them to open a **new** Agent chat in the **target workspace** (the prototype repo, not this Elephant chat) and run:

```text
Use skill: feature-developer
Implement agent-engineer-skills/<feature-name>/what-to-build.md
```

That new chat is the Goldfish. If it guesses or ships the wrong product, return to this Elephant chat and tighten the spec. Do not ask this skill to fix the code. After the spec changes, they start another new Goldfish.
