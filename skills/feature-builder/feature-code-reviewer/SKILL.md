---
name: feature-code-reviewer
description: >-
  Use when a change has been written and the user wants it judged before it
  ships: "review this", "is this code any good", "will this be maintainable",
  "clean this up" on a just-built change, "did we do this the right way", or a
  pointer at a feature folder. Reads the specification and the diff, checks
  every touched file against clean-code practice and this repo's own
  conventions, applies internal refactors that leave behavior unchanged, and
  writes what-was-reviewed.md with a pass or fail verdict. Use even when the
  user does not say "review" or "code quality". Do not use to decide what to
  build (feature-specifier), to write the first implementation
  (feature-developer), to write and run tests (feature-tester), or for a messy
  module with no feature specification (feature-refactorer).
compatibility: >-
  Requires git and a shell to resolve the diff. Works in any Agent Skills host.
  Edits files when applying refactors; does not commit or push unless asked. No
  network access required.
license: PolyForm Noncommercial License 1.0.0
metadata:
  author: Lucas Winter
  version: "1.0"
---

# feature-code-reviewer

Core job: judge whether this change will still be easy to live with in a year. Be strict. Clean code and this repo's good practice win over "it works."

Input: `what-to-build.md`, the diff, and nearby existing code.

Output: safe refactors if needed, and `what-was-reviewed.md` from [assets/what-was-reviewed.md](assets/what-was-reviewed.md).

Run **after** `feature-developer` and **before** `feature-tester`.

## When to use

A feature was just implemented and you care that it is not throwaway.

Skip only for a tiny, obvious one-line fix the user already trusts.

Do not use to invent product (`feature-specifier`), to write the first implementation (`feature-developer`), to replace tests (`feature-tester`), or to restructure a messy module that has no feature spec (`feature-refactorer`).

## Gotchas

- `feature-developer` commits on its feature branch, so the diff is `git diff <base>...HEAD`. `what-was-implemented.md` names the branch, the base, and the commit. If the user told the developer not to commit, the work sits in the working tree instead: use `git diff`, `git diff --cached`, and the untracked files from `git status --porcelain`. If neither yields files, stop and ask. Never review from the write-up alone.
- **Write-up root.** `<root>` is the docs **directory** named on the Feature-folder write-ups line in the app's `.cursor/rules/agent-engineer-skills.mdc`. If that line is missing, `<root>` is `agent-engineer-skills`. That path must be a folder. Never create or read a file named `aes-write-up-root`. The specification lives at `<root>/<feature-name>/what-to-build.md`. If that tree is missing but `docs/features/<feature-name>/` exists, use the old folder. Never create both trees for one name. `concept.md` is the old filename for the same artifact. Write `what-was-reviewed.md` next to whichever one you used.
- A must-fix that cannot be fixed without changing what the user gets is still a `fail`. Record the finding as `blocked-specifier` and send them to `feature-specifier`. Blocked is a property of the finding, not a third verdict.
- Windows PowerShell 5.1 has no `&&` operator, so joined commands fail there. PowerShell 7 and POSIX shells accept it. When the shell is unknown, run git commands one per call.
- Refactoring is allowed; redesigning is not. If a fix would change behavior, an interface the specification named, or a wall, it is out of bounds no matter how much better it would be.

## How (mandatory order)

1. **Read the specification, then get the diff** using the resolution order in Gotchas. Product walls stay closed. Review code, not the idea.
2. **Read how this repo already does the same kind of work.** The local pattern is the standard. Do not import a generic textbook style that fights the codebase.
3. **Review every touched file** against the gate below. Record findings with their file paths. "Looks fine" with no file list is a fail of this skill.
4. **Fix must-fix and should-fix** where the fix does not change user-visible behavior or walls. Then re-run the existing test command if one exists.
5. **Decide and stop** by one of the three exits below. Write `what-was-reviewed.md`.

## The gate

One question decides everything: **would a stranger change this file in twelve months without fear?**

Everything below is evidence for that question, not a list of automatic failures. Weigh each against how this repo already works.

- **Wrong home:** a new helper or module that duplicates something this repo already has
- **Unreadable later:** names that do not say what they are; a function or module doing several jobs; dead code; commented-out leftovers; unnamed magic values
- **Hidden control flow:** swallowed errors; ignored promises; surprising globals; copy-paste with one line different
- **Hard to change:** coupling that will break the next feature; a dependency the specification did not call for
- **Project fit:** fights the existing folder layout, naming, i18n, or error style
- **Hygiene:** secrets, debug leftovers, unrelated drive-by edits

Severity follows the gate. If a stranger would be afraid, it is `must-fix`. If they would be slowed but not endangered, `should-fix`. Nits only where this repo already enforces them; do not invent a style guide.

A new dependency is not automatically a failure. Ask whether the repo could have done this with what it already has, and whether the next person would understand why it is there.

## The three exits

The review ends in exactly one of these. There is no fourth, and no open-ended loop.

1. **`pass`**: no must-fix remains.
2. **`fail`, blocked on product**: a must-fix cannot be fixed without changing what the user gets. Record it as `blocked-specifier`, and tell them to use `feature-specifier`.
3. **`fail`, reported**: after two full passes, must-fix findings remain. Stop refactoring, write the file, and tell the user exactly what is left.

## Before you finish

Check `what-was-reviewed.md` against every line here. Fix what fails, then check again.

- The header names the feature, the Verdict reads exactly `pass` or `fail`, and the exit taken is recorded beneath it.
- Every file in the diff appears under "Files reviewed". None were skipped.
- The findings table has at least one row. If you found nothing, that row says `none` and names the files you read. An empty table is not a pass.
- Every must-fix is either fixed or recorded as `blocked-specifier`, and the verdict matches.
- Behavior and walls are identical to `what-to-build.md`. You changed how, never what.
- The existing test command was re-run after your refactors, and the result recorded.
- You added no feature, screen, endpoint, or dependency of your own.
- No secrets in the write-up.

## Guardrails

MUST:

1. Announce `Using skill: feature-code-reviewer`.
2. Be strict. Do not pass to be polite.
3. Keep behavior and walls identical to `what-to-build.md`.

MUST NOT:

1. Add features, screens, endpoints, or libraries "while we are here."
2. Rewrite unrelated files for taste.
3. Skip must-fix because tests passed.
4. Use icons or emojis.
5. Log secrets.

## Handoff

Report the verdict and which of the three exits you took. Stop. Do not start `feature-tester` unless the operator named that skill.
