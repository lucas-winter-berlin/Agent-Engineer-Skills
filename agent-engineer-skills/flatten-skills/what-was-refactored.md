# What was refactored

- Name: `flatten-skills`
- Status: `refactored`
- Branch: `cursor/flatten-skills`
- Base branch: `main`
- Commit: `dd440af`
- Date: 2026-08-25

## Scope

In:

- `skills/` (flatten `feature-builder/` and `mvp-builder/` wrappers)
- `.cursor/rules/agent-engineer-skills.mdc`
- `.cursor/rules/<id>.mdc` (removed)
- `AGENTS.md`
- `README.md`
- `docs/GUIDE.md`
- `docs/ARCHITECTURE.md`
- `evals/lib/QualityEval.ps1`
- `evals/run-quality-eval.ps1`
- `evals/README.md`
- each `skills/<id>/SKILL.md` write-up-root gotcha and `metadata.family`

Out:

- Skill steps, templates, and evals case content (except path lookups)
- Consuming-app product behavior
- Trigger query JSON
- License text except filling missing `feature-bug-analyst` frontmatter to match siblings

## Invariants

- Skill ids stay `feature-specifier`, `feature-bug-analyst`, `feature-developer`, `feature-code-reviewer`, `feature-refactorer`, `feature-tester`, `mvp-specifier`.
- `Use skill: <id>` still runs only that skill and does not chain.
- Each skill still writes the same feature-folder filenames (`what-to-build.md`, `what-was-implemented.md`, `what-was-reviewed.md`, `what-was-verified.md`, `what-was-refactored.md`).
- Default write-up root remains the folder `agent-engineer-skills/` unless install sets another directory.
- Author evals stay in `skills/<id>/evals/` and are not copied into host discovery folders or into apps.
- No new skill ids, screens, endpoints, or npm/python dependencies.

## What I changed internally

- Moved each skill leaf from `skills/<family>/<id>/` to `skills/<id>/`.
- Stored family as `metadata.family` and README grouping instead of a filesystem layer.
- Pointed write-up root at `AGENTS.md` first, then the Cursor dispatcher, then the default folder.
- Dropped per-skill `.mdc` stubs. Kept one always-on dispatcher.
- This pack stores each skill once under `skills/<id>/`. Install copies that leaf into the app's `.cursor/skills/<id>/` and `.agents/skills/<id>/` only.
- Quality evals resolve `skills/<id>/` and still read old `skills/<family>/<id>/` snapshots from prior commits.

## Where

| Path | Change |
| --- | --- |
| `skills/<id>/` | create -- the only skill packages in this pack |
| `skills/feature-builder/`, `skills/mvp-builder/` | delete -- family wrappers |
| `.cursor/skills/`, `.agents/` | delete -- were duplicate copies; install creates these in the app only |
| `.cursor/rules/<id>.mdc` | delete -- seven per-skill stubs |
| `.cursor/rules/agent-engineer-skills.mdc` | modify -- flat paths, first-existing SKILL.md lookup, AGENTS.md |
| `AGENTS.md` | create -- host-neutral write-up root and skill map |
| `scripts/sync-host-skills.ps1` | delete -- was only to keep duplicate copies in sync |
| `README.md` | modify -- install copies into host folders only |
| `docs/GUIDE.md` | modify -- add a skill, Cursor, Antigravity |
| `docs/ARCHITECTURE.md` | modify -- flat contracts |
| `evals/lib/QualityEval.ps1` | modify -- flat skill path, host install, old-commit fallback |
| `evals/run-quality-eval.ps1` | modify -- baseline export uses commit-aware path |
| `evals/README.md` | modify -- `skills/<id>/evals/` |
| `skills/*/SKILL.md` | modify -- write-up root; `metadata.family`; bug-analyst license |

## Tests

- Command run: `evals/run-quality-eval.ps1 -Skill all -ValidateOnly`
- Result: `pass` -- all seven `evals.json` files OK
- Already failing before this change: none

## Walls held

- Behavior unchanged: yes -- same skill ids, same jobs, same write-up filenames, same no-chain rule
- Did not add: new skill ids, product features, test frameworks, CI
- Stopped to ask: none -- flatten was locked earlier; duplicate host copies in this pack were removed after that
