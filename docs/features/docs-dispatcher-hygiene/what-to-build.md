# Docs, dispatcher, and contract hygiene

- Feature: `docs-dispatcher-hygiene`
- Status: ready-for-developer
- Date: 2026-08-19
- Kind: mixed (markdown contracts, Cursor rules, JSON schemas)

`feature-developer` implements this file and nothing else.

## Problem

- Who: The operator of this repo, and anyone who copy-installs the skills into a consuming project.
- What is wrong or missing: The 4+1 model (four separable jobs plus `feature-harness`) is buried under mixed names (`lock` vs specification), a README that says four jobs and lists five, and an always-on dispatcher that treats generic “review” / “test” / “refactor” as this pipeline.
- Why it matters: Wrong skill, skipped specifier, or a shallow reading of the spec wastes the expensive steps (implement, review, verify, retry). Cleanup is docs and contracts only; the jobs stay the same.

## Questions and decisions

| Q | Asked because a wrong guess would... | Answer | Spec |
| --- | --- | --- | --- |
| What is in this first cleanup? | Clean the wrong files, or pull in AUTHORING/validator/examples | Docs + dispatcher + contract hygiene | Change README, GUIDE, ARCHITECTURE, `docs/features/README.md`, always-on dispatcher, per-skill `.mdc` pointers if they repeat the old mapping, SKILL.md / templates where they say `lock` for the spec file, and schema/template mismatches listed below. Keep 4+1. |
| When should the dispatcher pick a skill? | Hijack unrelated review/test work, or never auto-pick | Feature-shaped only | Map idea/spec, implement this spec, review this feature folder, verify against `what-to-build.md`, run the path / harness. Do not map generic “review this”, “refactor”, or “test it” unless a feature folder or skill id is in play. `Use skill: <id>` still wins. |
| How far may the contract change? | Break copy-installs, or leave `Lock:` in agent templates | Change agent-facing wording; keep fallbacks | User and agent prose: specification / `what-to-build.md`, not `lock` for that file. Keep `concept.md` and `notes.md` fallbacks, documented once in ARCHITECTURE and `docs/features/README.md`. Keep `locked-default` as the unanswered-question mechanism (different word). |

## In scope

- README: state four separable skills plus one harness; fix the “Four jobs” vs five-skill table; five-word (or six) glossary: skill, specification, wall, landmine, slop, harness; example prompts stay utterances, not a folder that must exist.
- GUIDE: same model and dispatcher policy; Gemini which-skill examples must not teach generic “test it” → verifier.
- ARCHITECTURE: control plane for 4+1; primary name is specification / `what-to-build.md`; one compatibility note for `concept.md` / `notes.md`; do not use `lock` as the name of the spec file.
- `docs/features/README.md`: same naming; keep fallbacks.
- `.cursor/rules/agent-engineer-skills.mdc`: feature-shaped decision table; keep global contract (order, templates, schemas, wait, no secrets).
- Skill contracts: replace `lock` meaning the spec file (harness template header `Lock:`, SKILL.md / GUIDE / ARCHITECTURE / example wording). Align: verifier schema `verdict` includes `not run` as `not-run`; specifier template status allows `awaiting-questions`; harness template uses the specification path, not `Lock:`.
- Per-skill `.mdc` files: only if they still teach the old dispatcher mapping or call the spec a `lock`.

## Out of scope (do not implement)

- MVP skill -- defer
- Spec-depth / S-M-L question budget -- defer
- `docs/AUTHORING.md` -- defer
- Schema validator, CI, test runner -- reject
- New worked example folder or `invoice-csv-export/` on disk -- defer
- Rewrite `docs/features/feature-harness/` historical write-ups -- reject
- Remove `concept.md` / `notes.md` fallbacks -- reject
- Explicit-only dispatcher (skill id required) -- reject
- License change, `.cursor/skills/` native layout, Copilot/Claude adapters -- reject
- New skill ids; changing implement → review → verify order; harness retry budget -- reject
- `skill-schema.json` id pattern stays `feature-*` -- do not widen

## Behavior

- Entry points in: files listed in scope; Cursor always-on dispatcher; Gemini GUIDE text. No UI, no new commands.
- Entry points out: no Automation, SDK, CI, validator script, new feature skill.
- When the user names `Use skill: <id>`, run that skill.
- When the user describes a fuzzy product/feature idea and “done” is not specified, run `feature-specifier`.
- When a specification exists and they want it built, run `feature-developer` (or `feature-harness` if they want the path).
- When they point at a feature folder (or `what-to-build.md`) for review or verify, run those skills.
- When they say “run the path”, “harness”, or “end to end” and a specification exists, run `feature-harness`.
- When they say review/refactor/test with no feature folder and no skill id, do not pick a feature-* skill.
- If a human still says “lock” meaning the spec, treat it as `what-to-build.md`. Do not rename `locked-default`.
- Leave / cancel: this cleanup is one change set. Do not ship half the rename (docs say specification, templates still say `Lock:`).
- Failure: if a required file is missing from the copy-install list, README/GUIDE still list the same folders as today (`skills/`, `schemas/`, `docs/`, `.cursor/rules/`).

## Done when

```text
Given README.md, GUIDE.md, and ARCHITECTURE.md
When an operator reads them without the old chat
Then they see four separable skills plus feature-harness
And the spec file is called a specification / what-to-build.md
And lock is not used as the name of that file
And concept.md / notes.md are mentioned once as fallbacks, not as current names

Given .cursor/rules/agent-engineer-skills.mdc
When the user says “review this function” or “test it” with no feature folder and no skill id
Then the mapping does not send them to feature-code-reviewer or feature-verifier
And “Use skill: feature-verifier” or “verify docs/features/<name>/” still maps to verifier

Given skills/feature-harness/templates/what-was-run.md and skills/feature-verifier/schema.json
When the developer has finished
Then the harness template does not label the spec path Lock:
And verifier schema verdict allows pass, fail, and not-run
And specifier template status includes awaiting-questions

Given a copy-install consumer with an old concept.md only
When developer or harness runs
Then concept.md still counts as what-to-build.md
```

## Do not

- Do not add a sixth feature skill or an MVP skill.
- Do not add a spec-depth slider.
- Do not add AUTHORING.md, a validator, CI, or a sample app.
- Do not delete `concept.md` / `notes.md` fallbacks.
- Do not make the dispatcher explicit-only.
- Do not rewrite historical `docs/features/feature-harness/` artifacts.
- Do not rename `locked-default`.
