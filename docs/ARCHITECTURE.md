# How Agent Engineer Skills work

Start with [README.md](../README.md). Operator notes: [GUIDE.md](GUIDE.md). Feature folders: [../agent-engineer-skills/README.md](../agent-engineer-skills/README.md).

This file is the internals for authors of this pack. Skill list and install live in the README. Gemini and adding a skill live in the GUIDE.

## Picture

```text
You name one skill (or describe feature work)
  -> Agent runs only that skill
    -> Agent reads skills/<family>/<id>/SKILL.md
      -> Agent does that job
        -> Writes that skill's files (often under agent-engineer-skills/<name>/)
          -> Stop. Do not start the next skill unless they named it.
```

`family` is `feature-builder` or `mvp-builder`. The **id** is what you type (`Use skill: feature-specifier`).

A skill is a recipe card. The agent is the cook. Your git repo is the kitchen. `what-to-build.md` is the specification from `feature-specifier`, `feature-bug-analyst`, or `mvp-specifier`; later skills may not build a different product.

## Rules

1. `Use skill: <id>` runs only that skill. Do not chain the next job unless they named it.
2. When the operator names skills in sequence, the output of an earlier skill is the input of the next. The feature name in the specification is the folder name.
3. Do not start `feature-developer` while the specification is missing or still fuzzy.
4. Do not skip `feature-code-reviewer` when the operator asked for implement then test unless they said to skip review.
5. Do not rerun an earlier skill unless a later one finds a hole (ambiguous spec, product change, failed tests).
6. If a later skill would change what the user gets, stop and go back to the skill that wrote the spec (`feature-specifier`, `feature-bug-analyst`, or `mvp-specifier`).

There is no composer / harness skill. Do not invent one.

## Contracts

Each skill is a leaf folder `skills/<family>/<id>/`: `SKILL.md` and `assets/*.md`. The directory names follow the Agent Skills specification (`assets/` for templates and resources, `references/` for on-demand docs, `scripts/` for executables). Required output content lives in each skill's `Before you finish` list, written as lines the agent can objectively fail. Missing test layers are `absent`, not invented.

Cursor: `.cursor/rules/agent-engineer-skills.mdc` always applies. If the short rule and `SKILL.md` disagree, `SKILL.md` wins.

## What each skill must not swallow

| Skill | Not this skill |
| --- | --- |
| Specifier | Code, extra PRD files, class names the user did not require, defect root-cause hunts |
| Bug analyst | Code, new tests on disk, product invention, CI, a threat-model essay |
| mvp-specifier | Code, scaffold, same-chat Goldfish, chaining, a feature in an existing repo |
| Developer | Product invention, CI, new test frameworks, review essays, STRIDE |
| Reviewer | New product, new dependencies, unrelated rewrites |
| Tester | New product, new CI, new scanners, a threat-model essay |

Security on the daily path is a **negative test** in `feature-tester` when the change has a who/auth or a new entry point. It is not a threat-model pack.

Technical forks the specification did not name: **stop and ask**.

## Waiting for a human

The agent waits when `feature-specifier`, `feature-bug-analyst`, or `mvp-specifier` needs landmine answers or evidence, developer finds a hole, reviewer would have to change the product, or tester needs a manual check. `ok` / `lgtm` does not skip questions or turn a fail into a pass.

## Failures

| Problem | What to do |
| --- | --- |
| Specification missing or fuzzy (existing-repo feature) | `feature-specifier` |
| Defect reported; root cause or fix not locked | `feature-bug-analyst` |
| Specification missing or fuzzy (prototype / MVP / new project) | `mvp-specifier` |
| New product landmine mid-build | Stop. Ask. |
| Review must-fix remains | Stay in `feature-code-reviewer` until it is gone or blocked for the skill that wrote the spec |
| Tests fail | Stay in `feature-tester`. Do not delete tests to get green. |
| A test layer does not exist | Write `absent`. Do not invent the layer. |

Quiet and read-only until the skill says to write. Do not add Playwright, CI, or a scanner because another repo had them. Windows PowerShell 5.1 has no `&&` operator, so joined commands fail there; PowerShell 7 and POSIX shells accept it.

## Conflicts with the consuming project

1. That project's security, secrets, and legal rules win.
2. For skill-bound work, that skill's templates and required write-up content from this framework win. Skill order wins only when the user named the next skill.
3. That project's code style wins for source.

Share the app's git files (`skills/`, the AES `.mdc` files, `agent-engineer-skills/`), not chat logs. Do not copy this pack's `docs/` or `evals/` into the app.

## Versioning

- Skill ids stay stable except `feature-verifier`, now `feature-tester`, and `pitch-to-spec`, now `mvp-specifier`. There is no `feature-harness`.
- Adding a new skill id is a minor change. Place it under `feature-builder` or `mvp-builder`. It must run alone via `Use skill: <id>`.
- Removing or renaming a required write-up or a skill id is a major change.

## This framework does not

- Replace the team's product process outside `what-to-build.md`
- Copy this pack's `docs/` or `evals/` into an app, or replace that app's `.cursor/rules/` folder
- Set up CI or cloud accounts
- Guarantee tests are enough without a human look
- Let the agent ignore the consuming project's security policy
- Define a network protocol between agents

## Glossary

| Term | Meaning |
| --- | --- |
| Skill | Job plus required outputs. Runnable alone. Id is the leaf folder. |
| Family | `feature-builder` or `mvp-builder`. Browse path only. |
| Feature specification | `what-to-build.md` from `feature-specifier`, `feature-bug-analyst`, or `mvp-specifier` |
| Feature directory | `agent-engineer-skills/<feature-name>/` for one change |
| mvp-specifier | Elephant: prototype / MVP / new project spec. Not `feature-specifier`. Goldfish is a new chat with `feature-developer`. |
| feature-bug-analyst | Defect analysis that writes a fix-ready `what-to-build.md`. Not product invention. |
| Wall | Out-of-scope. Hard reject if code builds it |
| Landmine | A question whose wrong guess would waste implementation time |
| Slop | Tests or code that do not match the specification, or hollow asserts |
