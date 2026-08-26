---
name: feature-refactorer
description: >-
  Use when existing code in this repo needs a behavior-preserving restructure
  and there is no new product to specify: "refactor src/api/orders.ts", "this
  module is a mess", "extract a helper", "split this god class", "tech debt in
  X", or "pull this out of the god file". Locks scope and invariants, applies
  the restructure on a feature branch, runs existing tests, writes
  what-was-refactored.md, and stops. Do not use to invent product
  (feature-specifier), to root-cause a defect (feature-bug-analyst), to
  implement a specification (feature-developer), to judge a just-built feature
  diff (feature-code-reviewer), to verify against what-to-build.md
  (feature-tester), to design a new project (mvp-specifier), or to reformat the
  whole tree.
compatibility: >-
  Requires git and a shell. Works in any Agent Skills host. Creates a local
  branch and commits to it; never pushes unless asked. Uses the host's
  clickable multiple-choice UI for the question batch when one exists (for
  example Cursor AskQuestion), and falls back to lettered options in chat.
license: PolyForm Noncommercial License 1.0.0
metadata:
  author: Lucas Winter
  version: "1.0"
  family: feature-builder
---

# feature-refactorer

Core job: restructure named existing code without changing behavior. Lock scope and invariants first. Do not invent product.

Input: a messy module, file, or small set of files in this repo. There is no `what-to-build.md` for this work.

Output: a feature branch with the restructure committed on it, and `what-was-refactored.md` from [assets/what-was-refactored.md](assets/what-was-refactored.md).

Do **not** write `what-to-build.md`. That filename is the product or defect specification.

## Gotchas

- **Write-up root.** `<root>` is the docs **directory** named on the Feature-folder write-ups line in the repo's `AGENTS.md`. If that line is missing, use the same line in `.cursor/rules/agent-engineer-skills.mdc`. If both are missing, `<root>` is `agent-engineer-skills`. That path must be a folder. Never create or read a file named `aes-write-up-root`. Write `<root>/<kebab-name>/what-was-refactored.md`. If `docs/features/<kebab-name>/` already exists for that name and `<root>/<kebab-name>/` does not, write there instead. Never create both trees for one name.
- **Folder name.** Kebab-case from the primary scoped path's basename without extension: `src/api/orders.ts` → `orders`. If that folder already exists, prefix `refactor-`.
- Commit your work on the feature branch. Never push, never commit to the default branch, never amend or rebase. If the user explicitly told you not to commit, say so in the handoff.
- Windows PowerShell 5.1 has no `&&` operator, so joined commands fail there. PowerShell 7 and POSIX shells accept it. When the shell is unknown, run git commands one per call.
- If the repo has no test runner, that is a fact to report, not a gap to fill. Do not add tests unless the user asked.
- A stack rewrite, new public behavior, or "while you are here add X" is product. Stop and name `feature-specifier`.

## How (mandatory order)

1. **Classify.** Wrong skill: stop and name it. Do not start that skill unless the operator named it.
   - Pointer at a feature folder, a just-built diff, or "review this" / "clean this up, it works but feels wrong" → `feature-code-reviewer`. Status `blocked-need-reviewer` if you write a file.
   - New capability, extra product, or "add X while you are here" → `feature-specifier`. Status `blocked-need-specifier` if you write a file.
   - Defect with expected vs actual, crash, or stacktrace → `feature-bug-analyst`.
2. **Restate** the structural goal and the files in scope. Add nothing.
3. **Find landmines** using the types below. Skip any the request already answered. Exact "refactor `src/orders.js`, do not change `listOrders`" skips this step.
4. **Ask** remaining questions in one batch, as clickable choices. Do not ask what the user or the repo already answered. Do not ask two questions that are the same decision. If leftovers would still waste the restructure, Status is `blocked-need-ask` and you stop.
5. **Feature branch.**
   - Run `git status --porcelain`. If the tree is dirty, stop and ask before switching branches.
   - Find the default branch with `git rev-parse --abbrev-ref origin/HEAD`. If that fails, try `main`, then `master`.
   - `git switch <default>`, then `git switch -c cursor/<kebab-name>`.
   - Use the `cursor/` prefix unless the repo's existing branch names show a different convention, in which case match the most common one.
   - If `cursor/<kebab-name>` already exists, stop and ask. Do not reuse or overwrite it.
6. **Refactor** only in-scope files. Match local style: naming, folder layout, error handling, imports. Allowed: extract, rename, dedupe, move to the right home, flatten. No new product, screens, endpoints, or dependencies. After two full passes, stop even if still imperfect.
7. **Run** the repo's existing test command if one exists. Separate pre-existing failures from ones your change caused. If there is no command, record `none` / `not-run`.
8. **Describe.** Write `<root>/<kebab-name>/what-was-refactored.md`.
9. **Commit.** Stage the source changes and the write-up, then commit on the feature branch with a message naming the restructure. One commit is enough unless the work has genuinely separable parts. Do not push.

## Landmine types (pick what applies)

Do not walk this list as a questionnaire. Skip any type the request or repo already decided.

| Type | Wrong guess wastes time on... | Ask about this when |
| --- | --- | --- |
| Scope | Rewriting neighbors | Which paths are in, and which are out, is missing or wider than a module |
| Invariants | Changing what callers get | Public signatures, routes, schema, or user-visible copy are unnamed |
| Safety net | Silent behavior change | It is unclear whether an existing test command covers the scope |

### How to ask (binding)

If the host has clickable multiple choice (Cursor `AskQuestion` or equivalent), MUST use it for the whole batch. One call, lettered options, optional Other.

MUST NOT print the questionnaire only as chat prose when that UI exists.

If the click UI is missing or failed, print letters and one line: `Choice UI unavailable; answer with letters.`

## Before you finish

Check `what-was-refactored.md` against every line here. Fix what fails, then check again. Skip this list when you stopped at classify without writing a file.

- The header names the work, the branch, the base branch, and the commit, and Status reads `refactored`, `blocked-need-ask`, `blocked-need-specifier`, or `blocked-need-reviewer`.
- Every section of the write-up is filled: scope in and out, invariants, what changed internally, where with a path per change, tests, walls held.
- Invariants name what must not change. None are left as "don't break anything."
- Public behavior, signatures, routes, and user-visible copy in scope are unchanged unless an invariant explicitly allowed a rename of a private symbol.
- Nothing from walls, and no new product, screen, endpoint, or dependency, was added.
- The repo's test command was run and the result recorded, or recorded as `none` / `not-run` with why.
- The work is committed on the feature branch when Status is `refactored`, and nothing was pushed.
- No secrets in source, in the write-up, or in the commit message.

## Guardrails

MUST:

1. Announce `Using skill: feature-refactorer`.
2. Run the steps in order.
3. Keep behavior identical to the locked invariants.
4. Keep secrets out of `what-was-refactored.md` and source.

MUST NOT:

1. Write `what-to-build.md`.
2. Add features, screens, endpoints, or libraries "while we are here."
3. Rewrite files outside scope for taste.
4. Invent a test runner or add tests the user did not ask for.
5. Push, commit to the default branch, amend, or rebase.
6. Start `feature-code-reviewer`, `feature-tester`, `feature-developer`, or `feature-specifier` unless the operator named that skill.
7. Use icons or emojis.

## Handoff

If you classified as the wrong skill, name that skill and stop.

Otherwise say the branch name, the base branch, and the commit. The write-up is `what-was-refactored.md`. Stop. Do not start `feature-code-reviewer` or `feature-tester` unless the operator named that skill.
