# Agent Engineer Skills

Four jobs for an agent building a feature in any kind of repo (UI, API, CLI, worker, library). After the lock exists, `feature-harness` can run implement → review → verify for you.

```text
specify  ->  implement  ->  review  ->  verify
              \____________________________/
                     feature-harness
```

| You want | Skill | File you get |
| --- | --- | --- |
| Lock what to build | `feature-specifier` | `docs/features/<name>/what-to-build.md` |
| Write the code | `feature-developer` | feature branch + `what-was-implemented.md` |
| Keep the code clean | `feature-code-reviewer` | `what-was-reviewed.md` |
| Prove it is not slop | `feature-verifier` | tests + `what-was-verified.md` |
| Run implement → review → verify | `feature-harness` | those files plus `what-was-run.md` |

Do not rename the skill ids.

## Install

Copy these folders into the project, same names:

- `skills/`
- `schemas/`
- `docs/`
- `.cursor/rules/` (Cursor)

Create `docs/features/` if it is missing.

**Cursor:** reload the window or start a **new Agent chat**. The dispatcher in `.cursor/rules/agent-engineer-skills.mdc` is always on.

**Gemini:** one Custom Gem per skill. Paste the preamble in [docs/GUIDE.md](docs/GUIDE.md), then that skill's `SKILL.md`. Attach `schema.json` and `templates/`.

## Run a feature

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
