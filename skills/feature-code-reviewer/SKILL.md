---
name: feature-code-reviewer
description: >-
  Strict code review of a feature diff for clean code, project conventions, and
  long-term maintainability. Refactors internals only when behavior stays as specified.
  Use after feature-developer and before feature-verifier.
---

# feature-code-reviewer

Core job: judge whether this change will still be easy to live with in a year. Be strict. Clean code and this repo's good practice win over "it works."

Input: `what-to-build.md` (or older `concept.md`), the feature diff, and nearby existing code.

Output: safe refactors if needed, and `docs/features/<feature-name>/what-was-reviewed.md`.

Run **after** `feature-developer` and **before** `feature-verifier`.

## When to use

A feature was just implemented and you care that it is not throwaway.

Skip only for a tiny, obvious one-line fix the user already trusts.

Do not use to invent product (`feature-specifier`), to write the first implementation (`feature-developer`), or to replace tests (`feature-verifier`).

## How (mandatory order)

1. **Read the specification and the diff.** Product walls stay closed. Review code, not the idea.
2. **Read how this repo already does the same kind of work.** The local pattern is the standard. Do not import a generic textbook style that fights the codebase.
3. **Review every touched file** against the bar below. Record findings. "Looks fine" with no file list is a fail of this skill.
4. **Fix must-fix and should-fix** when the fix does not change user-visible behavior or walls. Then re-run the existing test command if one exists. On Windows PowerShell, no `&&`.
5. **Write** [templates/what-was-reviewed.md](templates/what-was-reviewed.md). Verdict is `fail` until every must-fix is done or explicitly blocked (needs specifier, not a silent product change).

If a fix would change what the user gets, **stop**. Go to `feature-specifier`. Do not "improve" the product in review.

## Strict bar (all apply)

A change fails review if any of these is true and unfixed:

- **Wrong home:** new helper/module that duplicates something this repo already has
- **Unreadable later:** names that do not say what they are; a function or module that does several jobs; dead code; commented-out leftovers; magic values with no name
- **Hidden control flow:** swallowed errors; ignored promises; surprising globals; copy-paste with one line different
- **Hard to change:** tight coupling that will break the next feature; a new dependency that is not required by the specification
- **Project fit:** fights existing folder layout, naming, i18n, or error style
- **Hygiene:** secrets, debug leftovers, unrelated drive-by edits

Nits (spacing fights, optional commas) only if this repo already enforces them. Do not invent a new style guide.

Long-term test: "Would I trust a stranger to change this in twelve months without fear?" If no, it is must-fix or should-fix, not a nit.

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

If verdict is `pass`, run `feature-verifier` next. If `fail` and blocked on product, run `feature-specifier`. If `fail` on code still in the diff, keep reviewing until must-fix is gone.
