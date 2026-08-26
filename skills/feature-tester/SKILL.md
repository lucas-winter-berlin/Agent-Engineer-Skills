---
name: feature-tester
description: >-
  Use when someone wants to know whether a change actually works and is not AI
  slop: "test this", "QA it", "write tests for the feature", "does this really
  do what we said", "prove it works", "check it is secure", or a pointer at a
  feature folder. Writes test cases from what-to-build.md in the repo's existing
  framework, runs the unit, integration, e2e, and security commands that already
  exist, checks that out-of-scope work was not built, and writes
  what-was-verified.md with a per-layer verdict. Also answers to the older name
  feature-verifier. Do not use to decide what to build (feature-specifier), to
  implement it (feature-developer), to judge code cleanliness
  (feature-code-reviewer), to restructure a messy module (feature-refactorer),
  or to set up CI.
compatibility: >-
  Requires a shell and the repository's existing test tooling. Works in any
  Agent Skills host. Runs the project's own test commands; e2e runs may need a
  dev server and installed browsers. Does not install test frameworks or CI.
license: PolyForm Noncommercial License 1.0.0
metadata:
  author: Lucas Winter
  version: "1.0"
  family: feature-builder
---

# feature-tester

Core job: make sure the new work is not AI slop. That means test cases that match the feature specification, then actually running this repo's tests (unit, integration, e2e, security) and saying what passed, failed, or could not be run.

Input: `what-to-build.md` and the implementation, plus `what-was-implemented.md` and `what-was-reviewed.md` when they exist.

Output: tests in the project's existing style, a test run, and `what-was-verified.md` from [assets/what-was-verified.md](assets/what-was-verified.md).

On the daily path this runs after `feature-code-reviewer` (or after `feature-developer` if review was skipped).

## Gotchas

- Find the test commands in this order: `package.json` scripts, `Makefile`, `pyproject.toml` / `tox.ini` / `noxfile.py`, the CI workflow files, then the README. Only write `absent` for a layer after that search comes up empty. `absent` must mean the layer does not exist, never that you did not look hard enough.
- e2e usually needs a dev server already running and browsers installed (`npx playwright install`), and can take minutes without printing anything. A red e2e run caused by a missing precondition is not a feature failure. Fix the precondition, or record that layer as `not-run` with the reason. Reporting `fail` for a setup problem is the worst error this skill can make.
- Verdicts are spelled `pass`, `fail`, `not-run`, with the hyphen, exactly as the template writes them. `absent` is for a layer this repo does not have, and is not a verdict.
- **Write-up root.** `<root>` is the docs **directory** named on the Feature-folder write-ups line in the repo's `AGENTS.md`. If that line is missing, use the same line in `.cursor/rules/agent-engineer-skills.mdc`. If both are missing, `<root>` is `agent-engineer-skills`. That path must be a folder. Never create or read a file named `aes-write-up-root`. The specification lives at `<root>/<feature-name>/what-to-build.md`. If that tree is missing but `docs/features/<feature-name>/` exists, use the old folder. Never create both trees for one name. `concept.md` is the old filename for the same artifact. Write `what-was-verified.md` next to whichever one you used.
- Windows PowerShell 5.1 has no `&&` operator, so joined commands fail there. PowerShell 7 and POSIX shells accept it. When the shell is unknown, run commands one per call.

## How (mandatory order)

1. **Read the specification.** `what-to-build.md`. Done-when, walls, who, leave/cancel, failure.
2. **Read what shipped.** `what-was-implemented.md` and the diff. Look for extras the specification forbade (new routes, new deps, extra UI).
3. **Write test cases.** In this repo's existing test folders and runner. Cover the happy path, the important no-path, leave/cancel, and at least one check that a wall was not built.
4. **Run what exists.** Use the project's own commands, found through the discovery order in Gotchas. If `test:e2e` or Playwright already exists, MUST run it for UI work; do not skip e2e because unit passed. If a layer genuinely does not exist, write `absent`, and do not invent Playwright, CI, or a scanner.
5. **Record.** Fill `what-was-verified.md`, one line per layer.

## What "not slop" means here

- Every done-when item has a test, or a manual check with steps a human can repeat.
- Out-of-scope extras are absent, or listed as a fail.
- Tests hit real behavior (UI, API, CLI, job) the way this repo already tests.
- Tests fail when the behavior is wrong. These pass while verifying nothing:
  - asserting against a mock the test itself configured
  - snapshotting without ever reading the snapshot
  - asserting that a function was called, rather than what it produced
  - covering only the happy path
  - `expect(true).toBe(true)`
- Security: if the change has a who/auth question or a new entry point, add or run a negative case (unauthorized caller, no new public route, no secrets in source). Do not write a threat-model essay.

## Before you finish

Check `what-was-verified.md` against every line here. Fix what fails, then check again.

- The header names the feature, and the overall Verdict reads exactly `pass`, `fail`, or `not-run`.
- Every done-when item has a test or a repeatable manual check. None are unaccounted for.
- Every wall has a check that it was not built.
- Every layer reads `pass`, `fail`, or `not-run` with a reason. No layer is blank.
- Every `absent` was reached through the discovery order, not a guess.
- No claim that CI passed unless CI was actually run.
- You added no test framework, CI workflow, or security vendor.

## Guardrails

MUST:

1. Announce `Using skill: feature-tester`.
2. Use existing test commands and file layout.
3. Say `pass`, `fail`, or `not-run` with a reason.

MUST NOT:

1. Implement new product.
2. Add a test framework, CI workflow, or security vendor.
3. Skip walls because "it looked fine in the browser."
4. Log secrets.
5. Use icons or emojis.

## Handoff

Fails stay fails. Fix is `feature-developer` (or a human), then run this skill again.
