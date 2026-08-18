---
name: feature-harness
description: >-
  Runs the feature path in one go: developer, then code-reviewer, then verifier.
  One verify-fail retry. Classifies later user feedback (spec-mismatch vs new
  product). Use when the operator wants the path run, a harness, or end-to-end
  after a feature specification exists.
---

# feature-harness

Core job: run the other feature skills in order for one specified feature. Do not replace them. Do not invent product.

Input: `docs/features/<feature-name>/what-to-build.md` (or older `concept.md`).

Output: those skills' files, plus `docs/features/<feature-name>/what-was-run.md`.

## When to use

The operator wants the path run: "harness", "end to end", "run the path", or `Use skill: feature-harness`.

Do not use when the idea is still fuzzy and there is no specification (`feature-specifier` first). Do not use to rewrite the four skills.

## How (mandatory order)

1. **Announce** `Using skill: feature-harness`. Resolve the feature folder. If the path is missing, ask for it. If `what-to-build.md` / `concept.md` is missing, stop. Tell them to use `feature-specifier`. Write `what-was-run.md` only when the feature name is already known; otherwise chat only.
2. **Kitchen.** If this repo has no layout to match (developer would have to invent a stack), stop. `stopped-because: empty-kitchen`. Do not scaffold.
3. **Run the path once:** read and execute `skills/feature-developer/SKILL.md`, then `skills/feature-code-reviewer/SKILL.md`, then `skills/feature-verifier/SKILL.md`. Announce each inner skill. Do not skip review. If an inner skill waits on questions, wait. If review is `blocked-specifier`, stop (`review-blocked-specifier`). Do not auto-specifier here.
4. **Verify fail:** if verifier verdict is `fail`, run the three skills **once more**. If it still fails, stop (`verify-fail`). Retries used is `1`. Do not loop again.
5. **Write** [templates/what-was-run.md](templates/what-was-run.md). Always, except when the feature name was never known.

### Cancel

If the operator says stop or cancel, halt. Do not start the next inner skill. Write the log with `stopped-because: cancelled`.

### Feedback (after a run, new user message)

Classify. Retry budget resets to one verify-fail retry.

| Feedback looks like | Do |
| --- | --- |
| Bug or behavior that misses the specification | Develop → review → verify |
| New product, extra scope, extra surface | Run `feature-specifier` (questions + spec), then develop → review → verify |
| Unsure | Ask. Do not pick |

Do not send extra product to developer as a "fix".

## Classify (keep it dumb)

- **Specifier:** new screens, routes, roles, fields, in-scope expansion, "also add…", walls they now want dropped.
- **Developer:** wrong vs the specification, crash, test fail, review leftover, "it doesn't do what what-to-build says".
- **Ask:** both readings are reasonable.

## Guardrails

MUST:

1. Announce this skill, then each inner skill as that skill requires.
2. Follow each inner `SKILL.md`. Do not invent a parallel pipeline.
3. One verify-fail retry per run, then stop.
4. English. No icons or emojis.

MUST NOT:

1. Automation, SDK, CLI daemon, CI, or a queue UI.
2. Scaffold a stack.
3. Skip review on the way to verify.
4. Auto-start specifier when there is no specification and no product-feedback message.
5. Write a sixth feature file besides `what-was-run.md`.

## Handoff

Pass or stopped: the log is `what-was-run.md`. Inner write-ups stay those skills' files. Next action is in the log (`stopped-because`).
