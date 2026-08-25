---
name: feature-developer
description: >-
  Use when a feature specification already exists and the user wants it built:
  "implement what-to-build.md", "build this feature", "now write the code", or a
  pointer at an agent-engineer-skills/<name>/ folder. Creates a feature branch,
  writes the code in the repo's existing structure and style, runs the tests the
  repo already has, commits to that branch, then writes what-was-implemented.md
  so a reviewer who never saw the chat can follow it. Covers UI, API, CLI, jobs,
  libraries, and mixed work, including fixes whose what-to-build.md came from
  feature-bug-analyst. Do not use while the idea is fuzzy or "done" is undefined
  (feature-specifier), while a defect still needs root-cause analysis
  (feature-bug-analyst), for a new project, prototype, or MVP (mvp-specifier),
  or when the code already exists and the user wants it reviewed
  (feature-code-reviewer), tested (feature-tester), or restructured without a
  specification (feature-refactorer).
compatibility: >-
  Requires git and a shell. Works in any Agent Skills host. Creates a local
  branch and commits to it; never pushes unless asked. Needs no network access
  beyond the repo's own package manager.
license: PolyForm Noncommercial License 1.0.0
metadata:
  author: Lucas Winter
  version: "1.0"
---

# feature-developer

Core job: implement `what-to-build.md`. Do not invent product. Do not run testing, documentation, or CI/CD as separate programs.

Input: `<root>/<feature-name>/what-to-build.md` from `feature-specifier`, `feature-bug-analyst`, or `mvp-specifier`. Resolve `<root>` as in Gotchas.

Output: a feature branch with the change committed on it, and `what-was-implemented.md` from [assets/what-was-implemented.md](assets/what-was-implemented.md).

## When to use

The user wants the feature specification built in this repo.

Do not use when the idea is still fuzzy (`feature-specifier`), when a defect still needs analysis (`feature-bug-analyst`), when they want a review of shipped code (`feature-code-reviewer`), only tests (`feature-tester`), or a behavior-preserving cleanup with no specification (`feature-refactorer`).

## Gotchas

- **Write-up root.** `<root>` is the docs **directory** named on the Feature-folder write-ups line in the app's `.cursor/rules/agent-engineer-skills.mdc`. If that line is missing, `<root>` is `agent-engineer-skills`. That path must be a folder. Never create or read a file named `aes-write-up-root`. The specification lives at `<root>/<feature-name>/what-to-build.md`. If that tree is missing but `docs/features/<feature-name>/` exists, use the old folder and write your write-up next to it. Never create both trees for one name. `concept.md` is the old filename for the same artifact; treat it as `what-to-build.md`. When Origin is `feature-bug-analyst`, write the proposed failing test first, confirm it fails, then apply the minimal fix.
- Commit your work on the feature branch. That commit is what `feature-code-reviewer` diffs against the base, so leaving it uncommitted hides the change. Never push, never commit to the default branch, never amend or rebase. If the user explicitly told you not to commit, say so in the handoff so the reviewer knows to read the working tree instead.
- Windows PowerShell 5.1 has no `&&` operator, so joined commands fail there. PowerShell 7 and POSIX shells accept it. When the shell is unknown, run git commands one per call.
- Repos routinely have tests that were already failing before you touched anything. Record those as pre-existing and own only the failures your diff caused. Never delete, skip, or weaken a test to get a green run.
- If the repo has no test runner, that is a fact to report, not a gap to fill.

## How (mandatory order)

1. **Feature branch.**
   - Run `git status --porcelain`. If the tree is dirty, stop and ask before switching branches.
   - Find the default branch with `git rev-parse --abbrev-ref origin/HEAD`. If that fails, try `main`, then `master`.
   - `git switch <default>`, then `git switch -c cursor/<feature-name>`.
   - Use the `cursor/` prefix unless the repo's existing branch names show a different convention, in which case match the most common one.
   - If `cursor/<feature-name>` already exists, stop and ask. Do not reuse or overwrite it.
2. **Necessary structure.** Add only folders and files this repo already uses. Do not add a documentation pack. Do not rewrite `what-to-build.md`.
3. **Implement.** Work through these in order:
   - Make the in-scope behavior true. Obey the walls and the decisions.
   - Match local style: naming, folder layout, error handling, imports, user-facing text.
   - Add tests only in the repo's existing pattern and folders. If there is no test runner, add none.
   - Run the repo's existing test command. Separate pre-existing failures from ones your change caused.
4. **Describe.** Write `<root>/<feature-name>/what-was-implemented.md`: what you did, why, where, how to try it. Full context for a reviewer who did not see the chat. Not a second spec.
5. **Commit.** Stage the source changes and the write-up, then commit on the feature branch with a message naming the feature. One commit is enough unless the work has genuinely separable parts. Do not push.

## Read the repo first (quiet)

Before coding, read:

- the nearest existing feature that does the same kind of work, end to end
- the test file beside it
- the lint, formatter, and compiler or type-checker config
- how that code handles errors, logging, and user-facing text

Do not write a capability report. Do not claim tools that are not in the repo.

## what-to-build.md is the specification

- Follow in scope, decisions, done-when, do-not.
- If that file is missing or still ambiguous, stop and run `feature-specifier` (or `feature-bug-analyst` when the request is a defect). Do not guess product.
- If two real technical options remain, stop and ask. Do not pick a library or store the specification did not name.
- Do not "improve" the product unless the specification required it.
- If implementation discovers a landmine the specification did not cover, stop and ask.

## Before you finish

Check your work against every line here. Fix what fails, then check again.

- `what-was-implemented.md` names the feature, the branch, the base branch, and the commit, and Status reads `implemented`, `blocked-need-concept`, or `blocked-need-ask`.
- Every section of the write-up is filled: what, why, where with a path per change, how to try it, tests, and followed-what-to-build.
- Every done-when check in `what-to-build.md` is true in the code, not merely intended.
- Nothing from "Do not" or out of scope was built.
- The repo's test command was run and the result recorded, with pre-existing failures marked as pre-existing.
- The work is committed on the feature branch, and nothing was pushed.
- No secrets in source, in the write-up, or in the commit message.

## Guardrails

MUST:

1. Announce `Using skill: feature-developer`.
2. Run the five steps in order.
3. Keep secrets out of `what-was-implemented.md` and source.

MUST NOT:

1. Produce a planning pack, CI reports, or a threat-model essay as part of this skill.
2. Stand up CI/CD, new pipelines, or a test framework.
3. Expand scope.
4. Delete or weaken tests to get a green run.
5. Push, commit to the default branch, amend, or rebase.
6. Use icons or emojis in `what-was-implemented.md`.

## Handoff

Say the branch name, the base branch, and the commit. The write-up is `what-was-implemented.md`. Stop. Do not start `feature-code-reviewer` or `feature-tester` unless the operator named that skill.
