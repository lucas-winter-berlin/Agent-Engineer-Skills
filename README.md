# Agent Engineer Skills

Four skills you can run one at a time when building a product or feature, plus a fifth that runs implement, review, and verify in order so the agent can continue without you naming the next job.

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

## Words this repo uses

| Term | Meaning |
| --- | --- |
| Skill | One job plus its `SKILL.md`, schema, and template |
| Specification | `what-to-build.md` — what to build. Later skills must not change the product. |
| Wall | Out of scope. Do not implement it. |
| Landmine | A question whose wrong guess would waste implementation time |
| Slop | Tests or code that do not match the specification, or hollow asserts |
| Harness | `feature-harness` running implement, review, and verify for one specification |

If someone says "lock" for the spec file, they mean `what-to-build.md`.

## How to Install

Copy these folders into the project, same names:

- `skills/`
- `schemas/`
- `docs/`
- `.cursor/rules/` (Cursor)

Create `docs/features/` if it is missing.

**Cursor:** reload the window or start a **new Agent chat**. The dispatcher in `.cursor/rules/agent-engineer-skills.mdc` is always on. It only picks a skill for feature-shaped work, or when you name a skill id.

**Gemini:** one Custom Gem per skill. Paste the preamble in [docs/GUIDE.md](docs/GUIDE.md), then that skill's `SKILL.md`. Attach `schema.json` and `templates/`.

## How to create a feature

```text
Use skill: feature-specifier
I want users to export their invoices as CSV.
```

Answer the clickable questions. Specifier creates `docs/features/<name>/what-to-build.md`. Names such as `invoice-csv-export` in the examples below are utterances, not a folder this repo ships.

Then either name each skill, or run the path:

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
- How the four skills plus harness connect: [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md)
- Feature folder layout: [docs/features/README.md](docs/features/README.md)

## License

[PolyForm Noncommercial License 1.0.0](LICENSE). Free for noncommercial use. Not free for commercial use.
