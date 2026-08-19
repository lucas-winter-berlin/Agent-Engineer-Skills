# Guide

Short operator notes. Start with [README.md](../README.md). Internals: [ARCHITECTURE.md](ARCHITECTURE.md).

A skill is a job, not a persona. The agent announces `Using skill: <id>`, reads `skills/<id>/SKILL.md`, fills that skill's template, and covers `schema.json`. `SKILL.md` wins if a short Cursor rule disagrees.

Four skills are separable (`feature-specifier`, `feature-developer`, `feature-code-reviewer`, `feature-verifier`). `feature-harness` runs implement, review, and verify for one specification so you do not have to name the next job.

| Piece | Where |
| --- | --- |
| Job | `skills/<id>/SKILL.md` |
| Required fields | `skills/<id>/schema.json` |
| Write-up shape | `skills/<id>/templates/` |
| Shared package shape | `schemas/skill-schema.json` |
| Cursor | `.cursor/rules/` |
| Gemini | Custom Gem or system prompt |

## Which skill

`Use skill: <id>` always selects that skill.

| You say | Skill |
| --- | --- |
| "I have an idea." / "Write a spec." | `feature-specifier` |
| "Implement this spec." / "Build docs/features/<name>/" | `feature-developer` |
| "Review this feature folder." / "Review against what-to-build.md" | `feature-code-reviewer` |
| "Verify docs/features/<name>/" / "Verify against what-to-build.md" | `feature-verifier` |
| "Run the path." / "Harness." / "End to end." | `feature-harness` (specification must exist) |

Do not map generic "review this", "refactor", or "test it" to these skills unless a feature folder or a skill id is in play.

If the idea is fuzzy, specify first. If a specification exists and they want the whole path, use `feature-harness` instead of naming the three inner skills. Skip review only if the user said to skip it. The harness does not skip review.

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
| `.cursor/rules/agent-engineer-skills.mdc` | Always | Dispatcher (feature-shaped work, or a named skill id) |
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
4. Stop when SKILL.md says to wait for the user (questions, a missing specification, a product landmine).
5. Do not use icons or emojis in any artifact.
6. If this request belongs to a different skill, refuse and name the correct one: feature-specifier, feature-developer, feature-code-reviewer, feature-verifier, or feature-harness.
7. Generic "review this", "refactor", or "test it" is not a reason to run a feature skill unless the user named a skill id or a docs/features/<name>/ folder (or what-to-build.md).
```

3. Attach that skill's `schema.json` and every file in `templates/`.
4. Start a chat. Point at the feature folder and the repo.

**One dispatcher Gem (optional)**

1. Gem name: `agent-engineer-skills`.
2. Tell it to pick one primary skill for feature-shaped work (or a named skill id), announce it, then follow that `SKILL.md`. Do not map generic review/test/refactor with no feature folder.
3. Attach the five `SKILL.md` files and the five `schema.json` files.

**Gemini API**

1. System instruction = `SKILL.md`.
2. Send the feature folder paths and repo facts first, then the user request.
3. Do not start coding if `what-to-build.md` is missing or still fuzzy.

## Guardrails

1. Fill the template. Do not invent a new document shape.
2. Match the consuming repo. Do not add a test runner, CI, or library the specification did not require.
3. Out-of-scope in `what-to-build.md` is a wall, not a stretch goal.
4. Unknown tools are `unknown` or `absent`. Do not imply them.
5. No icons or emojis in skill files.
6. Do not write secrets into skill files.

## License

[PolyForm Noncommercial License 1.0.0](../LICENSE).
