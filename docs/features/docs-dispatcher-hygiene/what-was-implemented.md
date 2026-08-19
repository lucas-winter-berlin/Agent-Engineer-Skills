# What was implemented

- Feature: `docs-dispatcher-hygiene`
- Branch: `cursor/docs-dispatcher-hygiene`
- Built from: `docs/features/docs-dispatcher-hygiene/what-to-build.md`
- Date: 2026-08-19

## What I did

- Stated the model as four separable skills plus `feature-harness`.
- Put a glossary on the README (skill, specification, wall, landmine, slop, harness). The spec file is a specification / `what-to-build.md`, not a lock.
- Narrowed the always-on dispatcher to feature-shaped work, a feature folder, `what-to-build.md`, or `Use skill: <id>`. Generic review/test/refactor no longer maps here.
- Aligned GUIDE and ARCHITECTURE to the same dispatcher policy and naming.
- Kept `concept.md` / `notes.md` fallbacks, documented in ARCHITECTURE and `docs/features/README.md`.
- Renamed the harness template spec path from `Lock:` to `Specification:`. Added `awaiting-questions` to the specifier template status. Added `not-run` to the verifier schema verdict.
- Left example prompts as utterances (`invoice-csv-export` is not a folder this repo ships).

## Why

- The specification required docs, dispatcher, and contract wording only. The four jobs and harness order did not change.
- Compatibility: old `concept.md` still counts; a human who still says "lock" means `what-to-build.md`. `locked-default` is unchanged.

## Where

| Path | Change |
| --- | --- |
| `README.md` | modify -- 4+1 wording, glossary, example utterances, dispatcher note |
| `docs/GUIDE.md` | modify -- feature-shaped which-skill table; Gemini preamble |
| `docs/ARCHITECTURE.md` | modify -- 4+1 control plane, dispatcher policy, compatibility, glossary |
| `docs/features/README.md` | modify -- compatibility note for fallbacks and "lock" |
| `.cursor/rules/agent-engineer-skills.mdc` | modify -- feature-shaped mapping; lock synonym |
| `skills/feature-harness/templates/what-was-run.md` | modify -- Specification path, not Lock |
| `skills/feature-specifier/templates/what-to-build.md` | modify -- status includes awaiting-questions |
| `skills/feature-verifier/schema.json` | modify -- verdict enum includes not-run |
| `docs/features/docs-dispatcher-hygiene/what-was-implemented.md` | create -- this write-up |

## How to try it

- Read `README.md` and `.cursor/rules/agent-engineer-skills.mdc`.
- In a new Agent chat, say `review this function` with no feature folder: the dispatcher must not pick `feature-code-reviewer`.
- Say `Use skill: feature-verifier` or `Verify docs/features/docs-dispatcher-hygiene/`: that still maps to verifier.
- Confirm `skills/feature-harness/templates/what-was-run.md` has `Specification:` not `Lock:`.

## Tests

- Command run: none in this repo
- Result: not run -- this repo has no test runner; the change is markdown contracts and Cursor rules

## Followed what-to-build

- Followed: yes
- Stopped to ask: none
- Did not implement (walls): MVP skill, spec-depth slider, AUTHORING.md, validator/CI, worked example folder, rewrite of `docs/features/feature-harness/`, dropping `concept.md` fallbacks, explicit-only dispatcher, license / native `.cursor/skills/`, new skill ids, renaming `locked-default`
