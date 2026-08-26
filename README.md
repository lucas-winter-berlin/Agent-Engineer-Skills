# Agent Engineer Skills

Agents write code faster than you can check it. The pain is not speed. It is that they skip a concept, do not follow your idea, hallucinate what is not there, skip tests, or build overhead you never asked for. You get something that looks finished and is not.

This pack is a set of named jobs for those problems. You point at one job. The agent does that job and stops. It does not run the whole path unless you name the next skill.

Tell the agent which job, by its name. The names are in the tables below (`feature-specifier`, `mvp-specifier`, and so on):

```text
Use skill: feature-specifier
```

`feature-builder` and `mvp-builder` are family labels in the tables below (`metadata.family`). They are not folders. Type the skill name.

## What skills are included?

Two groups. Feature builder is for a change in an app you already have. MVP builder is for an MVP, prototype, or demo. Each skill is one job. Run the next one only when you name it.

### Feature builder

Use this when you already have an app and want to add or change a feature.

| Skill | Problem | What it does |
| --- | --- | --- |
| `feature-specifier` | No concept. The agent would guess the product. | Asks the questions that matter, then writes the actual concept in `what-to-build.md`. No code is generated. |
| `feature-bug-analyst` | A defect is reported, but the root cause and fix are not locked. | Pins Expected vs Actual, finds evidence in the repo, and writes a fix-ready `what-to-build.md` (failing-test plan, minimal fix). No code is generated. |
| `feature-developer` | The agent does not follow the spec, hallucinates, or builds overhead. | Implements `what-to-build.md` and nothing else, on its own feature branch, and commits there. Never pushes. Writes an implementation log in `what-was-implemented.md`. |
| `feature-code-reviewer` | The change works now but will be hard to maintain. | Strict review against this repo: duplication, unclear names, hidden control flow, coupling, layout, secrets. May refactor internals. Must not change what the user gets. Writes a review log in `what-was-reviewed.md`. |
| `feature-refactorer` | Existing code is a mess, and there is no feature spec. | Locks scope and invariants, restructures named files without changing behavior, commits on a feature branch. Never pushes. Writes `what-was-refactored.md`. |
| `feature-tester` | Nothing was tested against the spec. It may be slop. | Writes cases from the spec, runs this repo's tests, and reports `pass`, `fail`, or `not-run`. Writes `what-was-verified.md`. |

### MVP builder

Use this when you do not have that app yet: an MVP, a prototype, or a demo.

| Skill | Problem | What it does |
| --- | --- | --- |
| `mvp-specifier` | No concept for an MVP, prototype, or demo. The agent would guess the product. | Challenges the idea (cut, architecture, UI, data, APIs, access, rights), then writes a full v1 design in `what-to-build.md`. No code is generated. |

After `mvp-specifier`, start a **new** Agent chat and name `feature-developer` (Goldfish). Then review and test with the feature-builder skills, same as above. If that build invents product, the spec was unclear. Tighten the spec. Do not patch the idea in the code.

## How to install

Point an agent at **this** repo and at the **app** repo. Tell it to install Agent Engineer Skills.

The agent must:

1. Copy each `skills/<id>/` folder (no `evals/`) into the app's host discovery paths only. Do not also copy them into the app's `skills/` folder. Do not create `feature-builder/` or `mvp-builder/` wrappers.
   - Cursor: `.cursor/skills/<id>/`
   - Antigravity: `.agents/skills/<id>/` (if the app already uses `.agent/skills/`, copy there instead)
2. Copy only `.cursor/rules/agent-engineer-skills.mdc` into the app's `.cursor/rules/` (create that folder if needed). Do not delete or overwrite the app's other rules. Do not copy per-skill `.mdc` files; those no longer exist.
3. MUST stop and ask the operator where markdown docs should be saved, before creating that folder. Use the host's clickable choice UI (`AskQuestion`) when it exists. Two options only:
   - **Default:** keep the folder `agent-engineer-skills/` (docs go in `agent-engineer-skills/<feature-name>/`, for example `agent-engineer-skills/invoice-csv-export/what-to-build.md`).
   - **Custom:** the operator types a repo-relative **folder** name; create that directory and put docs in `<that-folder>/<feature-name>/`.
   Do not skip this question. Do not pick a path for them. Reject and re-ask if a custom path has `..`, is absolute, starts with `~`, or is exactly `skills`, `.cursor`, `.agents`, `.agent`, `evals`, or `docs`.
4. Create the chosen path as a **directory**. Default directory name is `agent-engineer-skills`. Never write a file at the repo root for this choice. If a file named `aes-write-up-root` exists, delete it and create the directory instead.
5. Set the Feature-folder write-ups line in the **app's** `AGENTS.md` and `.cursor/rules/agent-engineer-skills.mdc` to that directory: `Feature-folder write-ups live under <folder>/<name>/`. If the app has no `AGENTS.md`, copy this pack's `AGENTS.md` and then set that line. If the app already has `AGENTS.md`, add or replace only that write-ups line; do not overwrite the rest of the file.
6. If this pack has `agent-engineer-skills/README.md` and the chosen folder has no README yet, copy it into that folder. If this pack has no such README, skip this step.

Do not copy `evals/` into the app. Do not copy `skills/**/evals/`. Do not replace the app's existing `.cursor/rules/` folder. Do not rewrite copied `SKILL.md` files to hardcode the path. Do not create `aes-write-up-root`.

Then start a **new Agent chat** in the app.

## Hosts

### Cursor

This pack is driven by `skills/<id>/SKILL.md`. Cursor also loads `.cursor/rules/agent-engineer-skills.mdc` (always on): it maps vague prompts to one skill, forbids chaining, and points at `SKILL.md`. After install, Cursor discovers `.cursor/skills/<id>/`. There are no per-skill `.mdc` files.

### Antigravity

Antigravity does not read `.cursor/rules/` or this pack's `skills/` folder. After install it discovers `.agents/skills/<id>/` (legacy `.agent/skills/<id>/` also accepted). Follow `SKILL.md`. The docs folder is the Feature-folder write-ups line in `AGENTS.md`.

### Gemini Custom Gems

Gemini does not read `.cursor/rules/` or `.agents/skills/`. One Gem per skill.

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

Optional dispatcher Gem: name it `agent-engineer-skills`, pick one primary skill, follow that `SKILL.md`, attach every `SKILL.md` in `skills/`. For the Gemini API, system instruction is `SKILL.md`. Do not start coding if `what-to-build.md` is missing or still fuzzy.

## How to use

A feature in an app you already have:

```text
Use skill: feature-specifier
I want users to export their invoices as CSV.
```

```text
Use skill: feature-bug-analyst
Checkout throws when the cart is empty. Expected: empty-state message. Actual: 500.
```

```text
Use skill: feature-developer
Implement agent-engineer-skills/invoice-csv-export/what-to-build.md
```

```text
Use skill: feature-code-reviewer
Review agent-engineer-skills/invoice-csv-export/
```

```text
Use skill: feature-tester
Test agent-engineer-skills/invoice-csv-export/ against what-to-build.md
```

```text
Use skill: feature-refactorer
Refactor src/api/orders.ts. It is a mess. Do not change behavior.
```

A prototype or new project. Spec first, then a **new** chat to build:

```text
Use skill: mvp-specifier
I want a small app where teams log standup notes.
```

```text
Use skill: feature-developer
Implement agent-engineer-skills/<name>/what-to-build.md
```

Skip specify only if `what-to-build.md` already exists and is clear. If the idea is still fuzzy, specify first. The agent must not invent product while coding.

The paths above are the default docs folder (`agent-engineer-skills/<feature-name>/`). If install created a custom directory, substitute that folder. Each feature still gets its own `<feature-name>` subfolder.

## Add a skill

New skills are additive. Each one must work alone via `Use skill: <id>`. Adding an id is a minor change. Removing or renaming an id or a required write-up is a major change. `feature-verifier` is now `feature-tester`. `pitch-to-spec` is now `mvp-specifier`. There is no `feature-harness`.

1. Create `skills/<id>/` with kebab-case leaf `id` matching the skill id. Set `metadata.family` to `feature-builder` or `mvp-builder`. Family is not a folder.
2. Add `SKILL.md` (YAML `name` + `description` that says what it does and when to use it, including when not to use it, plus `compatibility` when needed, plus `license: PolyForm Noncommercial License 1.0.0` and `metadata.author` / `metadata.version` / `metadata.family`) and `assets/` holding the write-up templates. Required output content is a `Before you finish` list the agent can fail, not a separate schema file.
3. `name` in `SKILL.md` matches the leaf folder. `assets/` holds at least one Markdown template. Add `references/` only for on-demand docs, and `scripts/` only for executables.
4. Do not add a per-skill `.mdc` file. Do not add copies under `.cursor/skills/` or `.agents/skills/` in this pack. Do not rename existing skill ids.
5. Add a row to the matching family table above, a mapping row in `.cursor/rules/agent-engineer-skills.mdc` if the skill should auto-pick, and a path row in that file (Where SKILL.md lives).
6. If the skill writes a feature-folder file, name that file in `agent-engineer-skills/README.md`. If it does not, do not force a write-up folder onto it.
7. Add `evals/queries/<id>.json` with about twenty labelled prompts, half of which should not trigger the skill. See [evals/README.md](evals/README.md).
8. Add `skills/<id>/evals/evals.json` with 2-3 quality cases. Reuse [evals/fixtures/](evals/fixtures/) when the skill needs a toy app.

## Guardrails

1. Fill the template. Do not invent a new document shape.
2. Match the consuming repo. Do not add a test runner, CI, or library the specification did not require.
3. Out-of-scope in `what-to-build.md` is a wall, not a stretch goal.
4. Unknown tools are `unknown` or `absent`. Do not imply them.
5. No icons or emojis in skill files.
6. Do not write secrets into skill files.

## More

- Write-up root pointer: [AGENTS.md](AGENTS.md)
- Where write-ups live: [agent-engineer-skills/README.md](agent-engineer-skills/README.md)
- Trigger and quality evals (authors, not installed): [evals/README.md](evals/README.md)

## License

[PolyForm Noncommercial License 1.0.0](LICENSE). Free for noncommercial use. Not free for commercial use.
