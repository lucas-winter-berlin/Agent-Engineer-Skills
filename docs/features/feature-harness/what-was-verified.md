# What was verified

- Feature: `feature-harness`
- Built from: `docs/features/feature-harness/what-to-build.md`
- Date: 2026-08-18

## Test cases added or updated

| Case | From lock | Path |
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

- Done-when covered: yes, by contract files plus the manual checks below (no automated tests in this repo)
- Walls still held (no extra product): yes -- no Automation, SDK, CLI daemon, CI, scaffold, or sixth write-up
- Tests assert real behavior: n/a -- no test files added

## Manual checks (only if no runner for that path)

- `skills/feature-harness/SKILL.md` exists and orders developer, then reviewer, then verifier; one verify-fail retry; cancel writes the log; missing lock names specifier; classify sends new product to specifier.
- Template `what-was-run.md` and schema `stoppedBecause` / `retriesUsed` match the lock.
- `.cursor/rules/feature-harness.mdc` and dispatcher row `Run the path, harness, end to end after a lock` exist.
- README shows `Use skill: feature-harness` after specifier.
- No `package.json` scripts, GitHub Action, or SDK entry were added.

## Verdict

pass -- Lock is in the skill contract and Cursor binding; layers are absent, not faked; walls held.
