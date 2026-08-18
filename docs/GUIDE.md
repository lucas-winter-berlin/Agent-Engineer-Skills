# Guide

Short operator notes. Start with [README.md](../README.md). Internals: [ARCHITECTURE.md](ARCHITECTURE.md).

A skill is a job, not a persona. The agent announces `Using skill: <id>`, reads `skills/<id>/SKILL.md`, fills that skill's template, and covers `schema.json`. `SKILL.md` wins if a short Cursor rule disagrees.

| Piece | Where |
| --- | --- |
| Job | `skills/<id>/SKILL.md` |
| Required fields | `skills/<id>/schema.json` |
| Write-up shape | `skills/<id>/templates/` |
| Shared package shape | `schemas/skill-schema.json` |
| Cursor | `.cursor/rules/` |
| Gemini | Custom Gem or system prompt |

## Which skill

| You say | Skill |
| --- | --- |
| "I have an idea." / "Write a spec." | `feature-specifier` |
| "Build this." / "Implement the lock." | `feature-developer` |
| "Review the code." / "Clean this up." | `feature-code-reviewer` |
| "Test it." / "Is this slop?" | `feature-verifier` |
| "Run the path." / "Harness." / "End to end." | `feature-harness` (lock must exist) |

If the idea is fuzzy, specify first. If a lock exists and they want the whole path, use `feature-harness` instead of naming the three inner skills. Skip review only if the user said to skip it. The harness does not skip review.

## Install

1. Copy `skills/`, `schemas/`, `docs/`, and `.cursor/rules/` into the consuming project. Keep the same folder names.
2. Confirm these exist:
   - `skills/feature-specifier/SKILL.md`
   - `skills/feature-developer/SKILL.md`
   - `skills/feature-code-reviewer/SKILL.md`
   - `skills/feature-verifier/SKILL.md`
   - `skills/feature-harness/SKILL.md`
   - `.cursor/rules/agent-engineer-skills.mdc` (Cursor)
3. Do not rename skill ids.
4. Create `docs/features/` if it is missing.

### Cursor

1. Copy `.cursor/rules/`. `agent-engineer-skills.mdc` always applies. Skill rules apply when that skill is selected.
2. Copy `skills/` and `schemas/` so rules can open `SKILL.md`.
3. Reload Cursor or start a new Agent chat.

| File | When | Role |
| --- | --- | --- |
| `.cursor/rules/agent-engineer-skills.mdc` | Always | Dispatcher |
| `.cursor/rules/feature-specifier.mdc` | Selected | Specify |
| `.cursor/rules/feature-developer.mdc` | Selected | Implement |
| `.cursor/rules/feature-code-reviewer.mdc` | Selected | Review |
| `.cursor/rules/feature-verifier.mdc` | Selected | Verify |
| `.cursor/rules/feature-harness.mdc` | Selected | Path runner |

### Gemini Custom Gems

Gemini does not read `.cursor/rules/`. Paste the contract into a Gem.

**One Gem per skill**

1. Name the Gem after the skill, for example `feature-developer`.
2. Paste this preamble, then the full `SKILL.md`:

```text
You are executing an Agent Engineer Skill. The skill text that follows is an execution contract, not optional style guidance.

Rules:
1. Follow the steps in SKILL.md in order. Do not skip, merge, or reorder them.
2. Fill only the templates that skill names. Do not invent extra documents.
3. Cover every required field in that skill's schema.json.
4. Stop when SKILL.md says to wait for the user (questions, a missing lock, a product landmine).
5. Do not use icons or emojis in any artifact.
6. If this request belongs to a different skill, refuse and name the correct one: feature-specifier, feature-developer, feature-code-reviewer, feature-verifier, or feature-harness.
```

3. Attach that skill's `schema.json` and every file in `templates/`.
4. Start a chat. Point at the feature folder and the repo.

**One dispatcher Gem (optional)**

1. Gem name: `agent-engineer-skills`.
2. Tell it to pick one primary skill, announce it, then follow that `SKILL.md`.
3. Attach the five `SKILL.md` files and the five `schema.json` files.

**Gemini API**

1. System instruction = `SKILL.md`.
2. Send the feature folder paths and repo facts first, then the user request.
3. Do not start coding if `what-to-build.md` is missing or still fuzzy.

## Guardrails

1. Fill the template. Do not invent a new document shape.
2. Match the consuming repo. Do not add a test runner, CI, or library the lock did not require.
3. Out-of-scope in `what-to-build.md` is a wall, not a stretch goal.
4. Unknown tools are `unknown` or `absent`. Do not imply them.
5. No icons or emojis in skill files.
6. Do not write secrets into skill files.

## License

[PolyForm Noncommercial License 1.0.0](../LICENSE).
