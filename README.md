# Agent Engineer Skills

Four jobs for an agent building a feature in any kind of repo (UI, API, CLI, worker, library), plus a runner that chains three of them after a feature specification exists.

```text
specify  ->  implement  ->  review  ->  verify
              \____________________________/
                     feature-harness
```

| Skill | What it does |
| --- | --- |
| `feature-specifier` | Helps you turn your idea into a feature specification. Writes `what-to-build.md`. |
| `feature-developer` | Builds a feature based on a given feature specification. Writes `what-was-implemented.md`. |
| `feature-code-reviewer` | Checks the new code is clean and will stay easy to change. Writes `what-was-reviewed.md`. |
| `feature-verifier` | Tests a given build against the feature specification. Writes `what-was-verified.md`. |
| `feature-harness` | Runs implement -> review -> verify in one go. Writes `what-was-run.md`. |

## How to Install

Copy these folders into the project, same names:

- `skills/`
- `schemas/`
- `docs/`
- `.cursor/rules/` (Cursor)

Create `docs/features/` if it is missing.

**Cursor:** reload the window or start a **new Agent chat**. The dispatcher in `.cursor/rules/agent-engineer-skills.mdc` is always on.

**Gemini:** one Custom Gem per skill. Paste the preamble in [docs/GUIDE.md](docs/GUIDE.md), then that skill's `SKILL.md`. Attach `schema.json` and `templates/`.

## How to create a feature

```text
Use skill: feature-specifier
I want users to export their invoices as CSV.
```

Answer the clickable questions. Then either name each skill, or run the path:

```text
Use skill: feature-harness
Run docs/features/invoice-csv-export/
```

That runs implement, review, and verify. One extra pass if verify fails. Then it stops. New product in later feedback goes back to specifier, not silent recode.

Or step by step:

```text
Use skill: feature-developer
Implement docs/features/invoice-csv-export/what-to-build.md
```

```text
Use skill: feature-code-reviewer
Review docs/features/invoice-csv-export/
```

```text
Use skill: feature-verifier
Verify docs/features/invoice-csv-export/ against what-to-build.md
```

Skip specifier only if `what-to-build.md` already exists and is clear. Skip review only if you say so. `feature-harness` does not skip review.

If the idea is still fuzzy, the agent must specify first. It must not invent product while coding.

## More

- Install and Gemini details: [docs/GUIDE.md](docs/GUIDE.md)
- How the four skills connect: [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md)
- Feature folder layout: [docs/features/README.md](docs/features/README.md)

## License

[PolyForm Noncommercial License 1.0.0](LICENSE). Free for noncommercial use. Not free for commercial use.
