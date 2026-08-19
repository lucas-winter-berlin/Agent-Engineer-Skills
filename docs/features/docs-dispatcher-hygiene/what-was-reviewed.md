# What was reviewed

- Feature: `docs-dispatcher-hygiene`
- Built from: `docs/features/docs-dispatcher-hygiene/what-to-build.md`
- Date: 2026-08-19

## Files reviewed

- `README.md`
- `docs/GUIDE.md`
- `docs/ARCHITECTURE.md`
- `docs/features/README.md`
- `.cursor/rules/agent-engineer-skills.mdc`
- `.cursor/rules/feature-specifier.mdc`
- `.cursor/rules/feature-developer.mdc`
- `.cursor/rules/feature-code-reviewer.mdc`
- `.cursor/rules/feature-verifier.mdc`
- `.cursor/rules/feature-harness.mdc`
- `skills/feature-harness/templates/what-was-run.md`
- `skills/feature-specifier/templates/what-to-build.md`
- `skills/feature-specifier/schema.json`
- `skills/feature-verifier/schema.json`
- `skills/feature-verifier/templates/what-was-verified.md`
- `docs/features/docs-dispatcher-hygiene/what-to-build.md`
- `docs/features/docs-dispatcher-hygiene/what-was-implemented.md`

## Findings

| ID | Severity (`must-fix` / `should-fix` / `nit`) | File | Problem | Fix applied (`yes` / `blocked-specifier` / `no`) |
| --- | --- | --- | --- | --- |
| R-001 | should-fix | `skills/feature-specifier/schema.json` | Property `lock` on a decision is the Spec column, easy to read as the spec file name | yes -- description added; key kept so `locked-default` is unchanged |
| R-002 | should-fix | `skills/feature-verifier/templates/what-was-verified.md` | Verdict line still `pass \| fail` after schema gained `not-run` | yes |

## Refactors in this pass

- Described specifier schema `lock` as the Spec column, not the specification file.
- Verifier write-up template verdict includes `not-run`.

## Tests after review

- Command: none
- Result: not run -- this repo has no test runner

## Long-term

- Stranger can change this in a year without fear: yes -- 4+1 is stated once in operator docs, dispatcher negatives are explicit, old `concept.md` fallbacks still live in the skill contracts.

## Verdict

pass -- Internals match existing markdown-contract layout; walls held; should-fix applied.
