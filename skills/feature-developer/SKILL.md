---
name: feature-developer
description: >-
  Implements a feature specification (what-to-build.md) in the current repo: feature branch,
  needed structure, code, then what-was-implemented.md. Use when the user asks
  to build a specified feature. Do not use when the idea is still fuzzy
  (feature-specifier first).
---

# feature-developer

Core job: implement `what-to-build.md`. Do not invent product. Do not run testing, documentation, or CI/CD as separate programs.

Input: `docs/features/<feature-name>/what-to-build.md` from `feature-specifier`. If only an older `concept.md` exists, treat it as `what-to-build.md`.

Output: a feature branch, the code, and `what-was-implemented.md`.

## When to use

The user wants the feature specification built in this repo.

Do not use when the idea is still fuzzy (`feature-specifier`), when they want a review of shipped code (`feature-code-reviewer`), only tests (`feature-verifier`), or the whole path (`feature-harness`).

## How (mandatory order)

1. **Feature branch.** From the current default branch, create and check out `cursor/<feature-name>` (or the project's usual prefix if one is obvious). Do not push unless asked. Do not commit unless asked. On Windows PowerShell, do not join git commands with `&&`; run them as separate commands.
2. **Necessary structure.** Add only folders and files this repo already uses. Do not add a documentation pack. Do not rewrite `what-to-build.md`.
3. **Implement.** Make the in-scope behavior true. Obey walls and the specification. Match local style. If the project already has a test command, run it and add tests only in the existing pattern. If there is no test runner, do not invent one.
4. **Describe.** Write `docs/features/<feature-name>/what-was-implemented.md` from [templates/what-was-implemented.md](templates/what-was-implemented.md): what you did, why, where, how to try it. Full context for a reviewer who did not see the chat. Not a second spec.

## what-to-build.md is the specification

- Follow in scope, decisions, done-when, do-not.
- If that file is missing or still ambiguous, stop and run `feature-specifier`. Do not guess product.
- If two real technical options remain, stop and ask. Do not pick a library or store the specification did not name.
- Do not "improve" the product unless the specification required it.
- If implementation discovers a landmine the specification did not cover, stop and ask.

## Look at the repo (quiet)

Before coding, notice language, layout, and how similar features are built. Do not write a capability report. Do not claim tools that are not in the repo.

## Guardrails

MUST:

1. Announce `Using skill: feature-developer`.
2. Run the four steps in order.
3. Keep secrets out of `what-was-implemented.md` and source.

MUST NOT:

1. Produce a planning pack, CI reports, or a threat-model essay as part of this skill.
2. Stand up CI/CD, new pipelines, or a test framework.
3. Expand scope.
4. Delete or weaken tests to get a green run.
5. Use icons or emojis in `what-was-implemented.md`.

## Handoff

Code is on the feature branch. The write-up is `what-was-implemented.md`. Next daily skill is `feature-code-reviewer`, then `feature-verifier` — or `feature-harness` if the operator asked for the whole path.
