---
name: feature-bug-analyst
description: >-
  Use when someone reports a defect in an existing codebase and needs the cause
  pinned before a fix: a bug, crash, wrong output, regression, flaky failure,
  stacktrace, ticket with expected vs actual, or "why is this broken". Asks only
  the questions whose wrong answers would waste a fix, searches the tree for
  evidence, ranks root-cause hypotheses, and writes
  agent-engineer-skills/<name>/what-to-build.md so feature-developer can write a
  failing test then a minimal fix. Do not use for fuzzy new product work
  (feature-specifier), greenfield or MVP design (mvp-specifier), implementing a
  ready specification (feature-developer), judging cleanliness
  (feature-code-reviewer), verifying a shipped feature (feature-tester), or
  restructuring a messy module with no defect report (feature-refactorer).
compatibility: >-
  Works in any Agent Skills host. Uses the host's clickable multiple-choice UI
  for the question batch when one exists (for example Cursor AskQuestion), and
  falls back to lettered options in chat. Reads the repo and may run existing
  tests for evidence. Writes files. Does not edit product source or add tests.
license: PolyForm Noncommercial License 1.0.0
metadata:
  author: Lucas Winter
  version: "1.0"
  family: feature-builder
---

# feature-bug-analyst

Core job: turn a reported defect into a locked fix specification. Pin expected vs actual, locate evidence, name the root cause when the code supports it, and hand `feature-developer` one `what-to-build.md` so the fix cannot invent a different product.

Do not write product code. Do not add or edit tests on disk. Do not produce a multi-file investigation pack.

Output: `<root>/<feature-name>/what-to-build.md` from [assets/what-to-build.md](assets/what-to-build.md). Resolve `<root>` as in Gotchas.

## When to use

The request is a bug, crash, wrong behavior, regression, or flaky failure in an existing app, and the fix is not yet locked in a specification.

Do not use when the request is a new capability without an existing contract (`feature-specifier`), a new project (`mvp-specifier`), the user only wants code, review, or tests on an existing specification, or the request is a messy-module restructure with no defect (`feature-refactorer`).

## Gotchas

- **Write-up root.** `<root>` is the docs **directory** named on the Feature-folder write-ups line in the repo's `AGENTS.md`. If that line is missing, use the same line in `.cursor/rules/agent-engineer-skills.mdc`. If both are missing, `<root>` is `agent-engineer-skills`. Create `<root>` as a folder if needed. Never create or read a file named `aes-write-up-root`. Write `<root>/<kebab-name>/what-to-build.md`. If `docs/features/<kebab-name>/` already exists for that name and `<root>/<kebab-name>/` does not, write there instead. Never create both trees for one name.
- `concept.md` is the old filename for this artifact. Always write `what-to-build.md`. Never create a `concept.md`.
- If the behavior was never promised (no existing contract, no prior done-when, no clear Expected), stop and name `feature-specifier`. This skill does not invent product.
- Exact reports already naming path, lines or symbol, Expected, and Actual skip the question batch. Go straight to code analysis and the write-up.
- Ask only landmines that still matter. The repo usually answers app type, stack, and folder layout. Do not ask GPU, viewport, OS, or lifecycle unless the symptom could depend on them.
- Root cause needs evidence paths. Prefer `confirmed` only with `path:line` (or an equivalent log/test fact). Use `likely` when the best hypothesis remains, and say what would disprove it. Use `blocked-need-evidence` and stop when logs or repro are missing.
- Edge cases in Fix approach are only cases already in Reproduction or Done when. If none, write `none`. Do not invent DST folds, leap seconds, null trees, or other textbook edges the report never showed.
- Affected code lists paths the developer must change or must read to apply the fix. Put neighbors that might break under Regression risks, not as a second inventory of the call graph.
- Windows PowerShell 5.1 has no `&&` operator, so joined commands fail there. PowerShell 7 and POSIX shells accept it. When the shell is unknown, run commands one per call.

## How (mandatory order)

1. **Restate** the defect in a few lines: Expected, Actual, where it shows up. Add nothing. Name the kind of work (UI, API, CLI, job, library, mixed) from the request and the repo.
2. **Classify.** Defect with an existing contract continues here. Missing feature or undefined product stops; name `feature-specifier`.
3. **Find landmines** using the types below. If path (or symbol), Expected, and Actual are already in the request, skip this step.
4. **Ask** remaining questions in one batch, as clickable choices. Do not ask what the user or the repo already answered. Do not ask two questions that are the same decision.
5. **Analyze.** Search the tree. Form two or three root-cause hypotheses. Confirm or reject each with evidence. Run existing tests only when that produces evidence; do not add a runner or a new test file.
6. **Write the specification.** Fill every section of the template. The developer-facing contract is In scope, Out of scope, Behavior, Done when, Proposed failing test, Fix approach, and Do not.
7. **Check** the file against every line of `Before you finish` below. Fix what fails, then check again. Do not hand over while a line fails.

If Status is `blocked-need-evidence`, stop after the write-up (or after the question batch) and wait. Do not invent a root cause.

## Landmine types (pick what applies)

Do not walk this list as a questionnaire. Skip any type the request or repo already decided.

| Type | Wrong guess wastes time on... | Ask about this when |
| --- | --- | --- |
| Expected vs actual | Fixing the wrong behavior | Either side is missing or fuzzy |
| Reproduction | Chasing a ghost | Steps, trigger, or reliability are missing |
| Environment | Env-only fixes that miss the bug | Symptom could be browser, OS, runtime, or staging/prod specific |
| State / data | Wrong fixture or auth path | Needs a particular user, token, row, null, or timing |
| Impact | Over-scoping the fix | Unclear whether one path or a class of failures |

## Questions

Ask only if a wrong guess would cause rework.

- Typical load is 0-5. Exact reports ask zero.
- Drop overlapping options.
- Stop when leftovers are harmless or a `locked-default`.
- Record Q and A inside `what-to-build.md`. No second questions file.

### How to ask (binding)

If the host has clickable multiple choice (Cursor `AskQuestion` or equivalent), MUST use it for the whole batch. One call, lettered options, optional Other.

MUST NOT print the questionnaire only as chat prose when that UI exists.

If the click UI is missing or failed, print letters and one line: `Choice UI unavailable; answer with letters.`

## what-to-build.md rules

The template supplies the required sections. Fill them. Do not add more.

MUST NOT include:

- Product source edits, new tests on disk, or CI
- Extra investigation files beside `what-to-build.md`
- FR/NFR/AC ID factories and traceability matrices
- Speculative edge cases, alternate algorithms, or "prefer / or document" forks the repro did not force
- Essays. Bullets, tables, short fences. Usually under 120 lines. Cut repetition and call-graph tours, not walls
- Instructions to the reader about how to fill the file
- Secrets from logs or payloads; redact tokens and personal data

## Before you finish

Check `what-to-build.md` against every line here. Fix what fails, then check again.

- The header names the feature, Origin reads `feature-bug-analyst`, and Status reads `awaiting-questions`, `draft`, `ready-for-developer`, or `blocked-need-evidence`.
- Root-cause status reads exactly `confirmed`, `likely`, or `blocked-need-evidence`.
- Problem states Expected and Actual as observable facts, plus reproducibility.
- Reproduction has numbered steps a second person can follow, or Status is `blocked-need-evidence` because they are missing.
- In scope and Out of scope each list at least one item.
- Every decisions row that was asked has both an Answer and a Spec, and no Spec cell is empty. If no questions were asked, the table says so.
- Every hypothesis has a verdict and an evidence cell. No invented paths.
- Root cause cites evidence paths when Status is `confirmed` or `likely`. `blocked-need-evidence` names what is still missing.
- Affected code lists at least one path the fix touches or must read, or Status is `blocked-need-evidence`. Transitive callers belong in Regression risks if they matter, not as filler rows.
- Done when holds at least one Given/When/Then for the failing path, and one adjacent non-regression check when a neighbor could break.
- Proposed failing test names layer, where to put it (or that this repo has no runner), and what it must assert. Asserts match Done when; no extra cases.
- Fix approach is minimal: modules or functions to change, not a rewrite. Edge cases read `none`, or only cases already named in Reproduction or Done when. No speculative forks.
- Regression risks lists at least one concrete adjacent area, or explicitly `none` with a reason.
- "Do not" names the wrong fix this report invites (rewrite, drive-by cleanup, inventing product, inventing edge cases).
- Out of scope is a wall: nothing listed there is needed to satisfy done-when.
- The file holds the specification only. No leftover placeholders, no notes about how to fill it in. No secrets. Usually under 120 lines.

## Guardrails

MUST:

1. Announce `Using skill: feature-bug-analyst`.
2. Treat out-of-scope as hard walls.
3. English. No icons or emojis.
4. Keep secrets out of the write-up.

MUST NOT:

1. Implement source, refactors, or CI.
2. Add or edit test files.
3. Leave "handle it appropriately".
4. Treat out-of-scope as stretch goals.
5. Invent a precise root cause without evidence.
6. Invent edge cases, algorithms, or hardening outside Reproduction and Done when.
7. Start `feature-developer`, `feature-code-reviewer`, or `feature-tester` unless the operator named that skill.

## Handoff

Point `feature-developer` at `what-to-build.md`. The developer writes the proposed failing test first, confirms it fails, then applies the minimal fix. If Status is `blocked-need-evidence`, wait for the missing evidence. If the report is really a missing feature, name `feature-specifier` instead.
