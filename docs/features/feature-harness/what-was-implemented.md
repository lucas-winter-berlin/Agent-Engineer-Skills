# What was implemented

- Feature: `feature-harness`
- Branch: `cursor/feature-harness`
- Built from: `docs/features/feature-harness/what-to-build.md`
- Date: 2026-08-18

## What I did

- Added skill `feature-harness`: one command runs `feature-developer`, then `feature-code-reviewer`, then `feature-verifier`.
- Verify fail retries that path once, then stops.
- Later user feedback is classified: lock-mismatch goes to the path; new product goes to specifier first; unsure asks.
- Wrote `what-was-run.md` as the only extra feature file. Wired dispatcher, Cursor rule, README, GUIDE, and ARCHITECTURE.

## Why

- The lock required a fifth portable skill, not an Automation or SDK.
- Inner `SKILL.md` files stay the jobs; the harness only orders them, retries once, and logs.

## Where

| Path | Change |
| --- | --- |
| `skills/feature-harness/SKILL.md` | create -- harness contract |
| `skills/feature-harness/schema.json` | create -- run fields |
| `skills/feature-harness/templates/what-was-run.md` | create -- log template |
| `.cursor/rules/feature-harness.mdc` | create -- Cursor binding |
| `.cursor/rules/agent-engineer-skills.mdc` | modify -- dispatcher row |
| `README.md` | modify -- how to run the path |
| `docs/GUIDE.md` | modify -- install and which-skill |
| `docs/ARCHITECTURE.md` | modify -- harness in the control plane |
| `docs/features/README.md` | modify -- `what-was-run.md` |
| `skills/feature-specifier/SKILL.md` | modify -- do-not when harness applies |
| `skills/feature-developer/SKILL.md` | modify -- do-not / handoff |

## How to try it

- Copy `skills/feature-harness/` and `.cursor/rules/feature-harness.mdc` into a consuming repo that already has the other four skills. Start a new Agent chat.
- With a locked `docs/features/<name>/what-to-build.md`, send: `Use skill: feature-harness` and the folder path.
- Expect inner skill announcements, then `what-was-run.md`. Say stop to cancel. After a run, send product-shaped feedback and expect specifier, not a silent recode.

## Tests

- Command run: none in this repo
- Result: not run -- this repo has no test runner; the skill is markdown contracts

## Followed what-to-build

- Followed: yes
- Stopped to ask: none
- Did not implement (walls): Cursor Automation, SDK, CLI daemon, CI, queue UI, stack scaffold, infinite retry, rewrite of the four skills, auto-specifier with no lock
