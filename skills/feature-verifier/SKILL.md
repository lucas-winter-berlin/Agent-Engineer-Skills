---
name: feature-verifier
description: >-
  Writes test cases from what-to-build.md, runs the repo's unit, integration,
  and security tests, and reports whether the implementation is real or slop.
  Use after feature-code-reviewer (or after feature-developer if review was skipped),
  or when the user asks to verify a feature, MVP, or product change.
---

# feature-verifier

Core job: make sure the new work is not AI slop. That means: test cases that match the locked product, then actually run this repo's tests (unit, integration, security) and say what passed, failed, or could not be run.

Input: `docs/features/<feature-name>/what-to-build.md` and the implementation (and `what-was-implemented.md` / `what-was-reviewed.md` if they exist).

Output: tests in the project's existing style, a test run, and `docs/features/<feature-name>/what-was-verified.md`.

## When to use

After `feature-code-reviewer` on the daily path (or after `feature-developer` if review was skipped), or when the user asks to verify, test, or security-check a feature.

Do not use to invent the product (`feature-specifier`), to write the feature (`feature-developer`), to review cleanliness (`feature-code-reviewer`), or to stand up CI.

## How (mandatory order)

1. **Read the lock.** `what-to-build.md` (or older `concept.md`). Done-when, walls, who, leave/cancel, failure.
2. **Read what shipped.** `what-was-implemented.md` and the diff. Look for extras the lock forbade (new routes, new deps, extra UI).
3. **Write test cases.** In this repo's existing test folders and runner. Cover: happy path, important no-path, leave/cancel, and at least one check that a wall was not built. Tests must fail on wrong behavior. `expect(true).toBe(true)` is slop.
4. **Run what exists.** Use the project's commands only. Typical names: unit, integration, e2e, security. On Windows PowerShell, do not join with `&&`. If a layer does not exist, write `absent` and do not invent Playwright, CI, or a scanner. If `test:e2e` or Playwright already exists, MUST run it for UI work. Do not skip e2e because unit passed.
5. **Record.** Fill [templates/what-was-verified.md](templates/what-was-verified.md).

## What "not slop" means here

- Every done-when item has a test, or a manual check with steps a human can repeat.
- Out-of-scope extras are absent (or listed as a fail).
- Tests hit real behavior (UI, API, CLI, job) the way this repo already tests.
- Security: if the change has a who/auth or a new entry point, add or run a negative case (unauthorized caller, no new public route, no secrets in source). Do not write a threat-model essay.

## Guardrails

MUST:

1. Announce `Using skill: feature-verifier`.
2. Use existing test commands and file layout.
3. Say `pass`, `fail`, or `not run` with a reason. Do not claim CI passed if CI was not run.

MUST NOT:

1. Implement new product.
2. Add a test framework, CI workflow, or security vendor.
3. Skip walls because "it looked fine in the browser."
4. Log secrets.
5. Use icons or emojis.

## Handoff

Fails stay fails. Fix is `feature-developer` (or a human), then run this skill again.
