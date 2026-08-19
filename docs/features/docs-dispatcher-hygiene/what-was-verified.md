# What was verified

- Feature: `docs-dispatcher-hygiene`
- Built from: `docs/features/docs-dispatcher-hygiene/what-to-build.md`
- Date: 2026-08-19

## Test cases added or updated

| Case | From spec | Path |
| --- | --- | --- |
| none | this repo has no test runner; do not invent one | n/a |

## Commands run

| Layer | Command | Result |
| --- | --- | --- |
| Unit | absent | not run |
| Integration | absent | not run |
| E2E | absent | not run |
| Security | absent | not run |

## Slop check

- Done-when covered: yes, by contract files plus the manual checks below
- Walls still held (no extra product): yes -- no AUTHORING.md, no validator, no `invoice-csv-export/` folder, no rewrite of `docs/features/feature-harness/`, `concept.md` fallbacks still in inner SKILL.md files, `locked-default` unchanged
- Tests assert real behavior: n/a -- no test files added

## Manual checks (only if no runner for that path)

- README no longer says "Four jobs"; it states four separable skills plus harness; glossary names specification / `what-to-build.md`; example `invoice-csv-export` is described as an utterance.
- GUIDE which-skill table does not map generic "Test it" / "Is this slop?" to verifier; Gemini preamble says generic review/test is not enough without a folder or skill id.
- ARCHITECTURE and `docs/features/README.md` keep `concept.md` / `notes.md` as compatibility, not current names.
- Dispatcher mapping no longer has rows for generic "Code review, refactor" or "Verify, test, integration". `Use skill: feature-verifier` still wins. Human "lock" is treated as `what-to-build.md`.
- Harness template uses `Specification:`, not `Lock:`. Specifier template status includes `awaiting-questions`. Verifier schema and template allow `not-run`.
- No new public route, no secrets in the diff. Per-skill `.mdc` files were left as pointers (they did not teach the old mapping).

## Verdict

pass -- Specification is in the operator docs and dispatcher; layers are absent, not faked; walls held.
