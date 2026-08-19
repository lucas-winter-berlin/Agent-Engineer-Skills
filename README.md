# Agent Engineer Skills

A collection of agent skills for developing features. Each skill is a separate job. Name the one you want.

```text
Use skill: <id>
```

That runs only that skill. Folders `feature-builder/` and `mvp-builder/` are for browsing this repo, not for typing.

## What does the pack do

In an existing repo, a common sequence is specify, then implement, then review, then test. Name each skill when you want it. There is no composer skill in this collection right now.

### Feature builder

| Skill | What it does |
| --- | --- |
| `feature-specifier` | Turn an idea into a feature specification for an existing repo. Writes `what-to-build.md`. |
| `feature-developer` | Build from a feature specification. Writes `what-was-implemented.md`. |
| `feature-code-reviewer` | Check that the new code is clean and will stay easy to change. Writes `what-was-reviewed.md`. |
| `feature-tester` | Test a build against the feature specification. Writes `what-was-verified.md`. |

### MVP builder

| Skill | What it does |
| --- | --- |
| `pitch-to-spec` | Stub. Will turn a rough idea into an MVP / new-project spec. Not implemented. Do not use for a feature in an existing repo. |

`feature-specifier` is for a **feature in an existing repo**. `pitch-to-spec` is for a **rough idea turned into an MVP / new project**. If you name the stub, the agent stops and does not write a spec.

## How to install

Point an agent at **this** repo and at the **app** repo, then tell it to install Agent Engineer Skills.

The agent must:

1. Copy `skills/` into the app repo (keep `feature-builder/` and `mvp-builder/` inside it).
2. Copy only these Cursor rules into the app's `.cursor/rules/` (create that folder if needed). Do not delete or overwrite the app's other rules:
   - `agent-engineer-skills.mdc`
   - `feature-specifier.mdc`
   - `feature-developer.mdc`
   - `feature-code-reviewer.mdc`
   - `feature-tester.mdc`
   - `pitch-to-spec.mdc`
3. Create `agent-engineer-skills/` in the app repo if it is missing. Copy this pack's `agent-engineer-skills/README.md` into it if the app folder has no README yet.

Do not copy `docs/` or `schemas/` into the app. Do not replace the app's existing `.cursor/rules/` folder.

Then start a **new Agent chat** in the app. `Use skill: <id>` runs only that skill.

Gemini: one Custom Gem per skill. Details: [docs/GUIDE.md](docs/GUIDE.md).

## How to use

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

Skip specifier only if `what-to-build.md` already exists and is clear. If the idea is still fuzzy, specify first. The agent must not invent product while coding.

## More

- Operator guide (Gemini, add a skill): [docs/GUIDE.md](docs/GUIDE.md)
- How the skills connect: [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md)
- Feature folder layout: [agent-engineer-skills/README.md](agent-engineer-skills/README.md)

## License

[PolyForm Noncommercial License 1.0.0](LICENSE). Free for noncommercial use. Not free for commercial use.
