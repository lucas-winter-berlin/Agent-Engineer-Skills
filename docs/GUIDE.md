# Guide

Short operator notes. Start with [README.md](../README.md). Internals: [ARCHITECTURE.md](ARCHITECTURE.md). Feature-folder layout: [../agent-engineer-skills/README.md](../agent-engineer-skills/README.md).

This repo is a **collection of skills for developing features**. Each skill is a job, not a persona. Name one skill to run only that job.

The agent announces `Using skill: <id>`, reads `skills/<family>/<id>/SKILL.md` (family is `feature-builder` or `mvp-builder`), fills that skill's template, and checks the result against that skill's `Before you finish` list. `SKILL.md` wins if a short Cursor rule disagrees.

| Piece | Where |
| --- | --- |
| Job | `skills/<family>/<id>/SKILL.md` |
| Required output content | The `Before you finish` list in that `SKILL.md` |
| Write-up shape | `skills/<family>/<id>/assets/` |
| Skill folder shape | [Add a skill](#add-a-skill) in this guide (authors). Not copied into the app. |
| Trigger evals | `evals/` in **this** repo (authors). Not copied into the app. |
| Cursor | `.cursor/rules/` |
| Gemini | Custom Gem or system prompt |

## Which skill

`Use skill: <id>` always runs **only** that skill. Do not start the next job unless they named it. There is no harness / path-runner skill.

| You say | Skill |
| --- | --- |
| `Use skill: <id>` | That skill only |
| "I have an idea." / "Write a spec." (feature in an existing repo) | `feature-specifier` |
| "This is broken." / bug, crash, regression, wrong output (analyze before fix) | `feature-bug-analyst` |
| Prototype / MVP / new project / greenfield / pitch, or `Use skill: mvp-specifier` | `mvp-specifier` (Elephant: spec only; Goldfish is a new chat). Old name: `pitch-to-spec` |
| "Build this spec." / "Implement what-to-build.md." | `feature-developer` |
| "Review this feature folder." | `feature-code-reviewer` |
| "Test this feature folder against what-to-build.md." | `feature-tester` |

If the idea is fuzzy, specify first. A feature in an existing app is `feature-specifier`. A defect with expected vs actual (or a stacktrace) is `feature-bug-analyst`. A prototype, MVP, new project, or greenfield is `mvp-specifier`. A generic "I have an idea" in an existing app still maps to `feature-specifier`. To implement, review, and test, name those skills one at a time. After `mvp-specifier` or `feature-bug-analyst`, open a **new** Agent chat for `feature-developer` unless you named that skill in the same chat.

## Install

Same contract as [README.md](../README.md) (How to install). Cursor and Gemini notes below. Then start a **new Agent chat** in the app.

### Cursor

`agent-engineer-skills.mdc` always applies. The other skill rules apply when that skill is selected. Rules open `SKILL.md` under `skills/<family>/<id>/`.

| File | When | Role |
| --- | --- | --- |
| `.cursor/rules/agent-engineer-skills.mdc` | Always | Dispatcher |
| `.cursor/rules/feature-specifier.mdc` | Selected | Specify (existing repo) |
| `.cursor/rules/feature-bug-analyst.mdc` | Selected | Analyze a defect (existing repo) |
| `.cursor/rules/feature-developer.mdc` | Selected | Implement |
| `.cursor/rules/feature-code-reviewer.mdc` | Selected | Review |
| `.cursor/rules/feature-tester.mdc` | Selected | Test |
| `.cursor/rules/mvp-specifier.mdc` | Selected | Prototype / MVP spec (Elephant; no code) |

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
3. Before handing over, check the finished write-up against that skill's `Before you finish` list. Fix what fails.
4. Stop when SKILL.md says to wait for the user (questions, a missing specification, a product landmine).
5. Do not use icons or emojis in any artifact.
6. If this request belongs to a different skill in the collection, refuse and name that skill. Do not start a second skill unless the user named it.
```

3. Attach every file in that skill's `assets/` folder.
4. Start a chat. Point at the feature folder and the repo.

**One dispatcher Gem (optional)**

1. Gem name: `agent-engineer-skills`.
2. Tell it to pick one primary skill, announce it, then follow that `SKILL.md`. Do not chain other skills unless the user named each skill.
3. Attach every `SKILL.md` in `skills/`.

**Gemini API**

1. System instruction = `SKILL.md`.
2. Send the feature folder paths and repo facts first, then the user request.
3. Do not start coding if `what-to-build.md` is missing or still fuzzy.

## Add a skill

New skills are additive. Each one must work alone via `Use skill: <id>`.

1. Create `skills/<family>/<id>/` with kebab-case leaf `id` matching the skill id. Family is `feature-builder` or `mvp-builder`.
2. Add `SKILL.md` (YAML `name` + `description` that says what it does and when to use it, including when not to use it, plus `compatibility` when the skill needs a particular host, shell, or tool) and `assets/` holding the write-up templates. State the required output content as a `Before you finish` list of lines the agent can objectively fail, not as a separate schema file.
3. Keep the folder shape: `name` in `SKILL.md` matches the leaf folder name, and `assets/` holds at least one Markdown template. Nothing else is required. Add `references/` only for material the skill loads on demand, and `scripts/` only for executables.
4. Add `.cursor/rules/<id>.mdc` that points at that `SKILL.md` (Cursor). Do not rename existing skill ids.
5. Add a row to the matching family table in [README.md](../README.md), a mapping row (only if the skill should auto-pick), and a path row in `.cursor/rules/agent-engineer-skills.mdc` (Where SKILL.md lives).
6. If the skill writes a feature-folder file, name that file in [agent-engineer-skills/README.md](../agent-engineer-skills/README.md). If it does not, do not force `agent-engineer-skills/` onto it.
7. Add `evals/queries/<id>.json` with about twenty labelled prompts, half of which should not trigger the skill. See [evals/README.md](../evals/README.md). The near-miss prompts matter most: they are what keep a new skill from stealing another skill's work.
8. Add `skills/<family>/<id>/evals/evals.json` with 2-3 quality cases (fixture, checks). See [evals/README.md](../evals/README.md) (Quality evals).

Keep existing ids stable. Adding a skill is a minor change. Removing or renaming an id is a major change.

## Guardrails

1. Fill the template. Do not invent a new document shape.
2. Match the consuming repo. Do not add a test runner, CI, or library the specification did not require.
3. Out-of-scope in `what-to-build.md` is a wall, not a stretch goal.
4. Unknown tools are `unknown` or `absent`. Do not imply them.
5. No icons or emojis in skill files.
6. Do not write secrets into skill files.

## License

[PolyForm Noncommercial License 1.0.0](../LICENSE).
