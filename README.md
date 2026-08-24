# Agent Engineer Skills

Agents write code faster than you can check it. The pain is not speed. It is that they skip a concept, do not follow your idea, hallucinate what is not there, skip tests, or build overhead you never asked for. You get something that looks finished and is not.

This pack is a set of named jobs for those problems. You point at one job. The agent does that job and stops. It does not run the whole path unless you name the next skill.

Tell the agent which job, by its name. The names are in the tables below (`feature-specifier`, `mvp-specifier`, and so on):

```text
Use skill: feature-specifier
```

`feature-builder/` and `mvp-builder/` are only folders in this repo. Do not type those. Type the skill name.

## What skills are included?

Two groups. Feature builder is for a change in an app you already have. MVP builder is for an MVP, prototype, or demo. Each skill is one job. Run the next one only when you name it.

### Feature builder

Use this when you already have an app and want to add or change a feature.

| Skill | Problem | What it does |
| --- | --- | --- |
| `feature-specifier` | No concept. The agent would guess the product. | Asks the questions that matter, then writes the actual concept in `what-to-build.md`. No code is generated. |
| `feature-developer` | The agent does not follow the spec, hallucinates, or builds overhead. | Implements `what-to-build.md` and nothing else, on its own feature branch, and commits there. Never pushes. Writes an implementation log in `what-was-implemented.md`. |
| `feature-code-reviewer` | The change works now but will be hard to maintain. | Strict review against this repo: duplication, unclear names, hidden control flow, coupling, layout, secrets. May refactor internals. Must not change what the user gets. Writes a review log in `what-was-reviewed.md`. |
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

1. Copy `skills/` into the app repo (keep `feature-builder/` and `mvp-builder/` inside it).
2. Copy only these Cursor rules into the app's `.cursor/rules/` (create that folder if needed). Do not delete or overwrite the app's other rules:
   - `agent-engineer-skills.mdc`
   - `feature-specifier.mdc`
   - `feature-developer.mdc`
   - `feature-code-reviewer.mdc`
   - `feature-tester.mdc`
   - `mvp-specifier.mdc`
3. MUST stop and ask the operator where markdown docs should be saved, before creating that folder. Use the host's clickable choice UI (`AskQuestion`) when it exists. Two options only:
   - **Default:** keep the folder `agent-engineer-skills/` (docs go in `agent-engineer-skills/<feature-name>/`, for example `agent-engineer-skills/invoice-csv-export/what-to-build.md`).
   - **Custom:** the operator types a repo-relative **folder** name; create that directory and put docs in `<that-folder>/<feature-name>/`.
   Do not skip this question. Do not pick a path for them. Reject and re-ask if a custom path has `..`, is absolute, starts with `~`, or is exactly `skills`, `.cursor`, `evals`, or `docs`.
4. Create the chosen path as a **directory**. Default directory name is `agent-engineer-skills`. Never write a file at the repo root for this choice. If a file named `aes-write-up-root` exists, delete it and create the directory instead.
5. Set the Feature-folder write-ups line in the **app's** `.cursor/rules/agent-engineer-skills.mdc` to that directory: `Feature-folder write-ups live under <folder>/<name>/`.
6. If this pack has `agent-engineer-skills/README.md` and the chosen folder has no README yet, copy it into that folder. If this pack has no such README, skip this step.

Do not copy `docs/` or `evals/` into the app. Do not replace the app's existing `.cursor/rules/` folder. Do not rewrite copied `SKILL.md` files to hardcode the path. Do not create `aes-write-up-root`.

Then start a **new Agent chat** in the app.

Gemini: one Custom Gem per skill. Details: [docs/GUIDE.md](docs/GUIDE.md).

## How to use

A feature in an app you already have:

```text
Use skill: feature-specifier
I want users to export their invoices as CSV.
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

## More

- Operator guide (Gemini, add a skill): [docs/GUIDE.md](docs/GUIDE.md)
- How the skills connect: [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md)
- Where write-ups live: [agent-engineer-skills/README.md](agent-engineer-skills/README.md)

## License

[PolyForm Noncommercial License 1.0.0](LICENSE). Free for noncommercial use. Not free for commercial use.
