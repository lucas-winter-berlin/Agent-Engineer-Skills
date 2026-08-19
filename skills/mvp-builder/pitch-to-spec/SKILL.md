---
name: pitch-to-spec
description: >-
  Turns a rough, detail-missing idea into an MVP or new-project specification.
  Not implemented yet. Use when the operator names this skill. Do not use for a
  feature in an existing repo (feature-specifier). Do not invent the MVP spec
  while this contract is a stub.
---

# pitch-to-spec

Core job (when implemented): take a rough idea and write a short MVP / new-project specification.

This skill is **not implemented**. Do not write an MVP spec. Do not scaffold. Do not guess product.

## When to use

Only when the operator names `Use skill: pitch-to-spec`.

Do not use for a feature in an existing repo. That job is `feature-specifier` (`what-to-build.md`).

Do not treat a generic "I have an idea" as this skill. That still maps to `feature-specifier`.

## How (mandatory order)

1. **Announce** `Using skill: pitch-to-spec`.
2. **Stop.** Tell the operator this skill is a stub: the collection layout exists, the contract does not. They may use `feature-specifier` for a feature in an existing repo. They should specify how pitch-to-spec works before anyone fills this job in.
3. Do not fill a feature-folder write-up. Do not copy `what-to-build.md`. Do not start `feature-developer` or any other skill.

## Guardrails

MUST:

1. Announce `Using skill: pitch-to-spec`.
2. Stop after the stub message.
3. English. No icons or emojis.

MUST NOT:

1. Write `what-to-build.md`, `mvp-spec.md`, or any other specification file.
2. Scaffold a stack or create app boilerplate.
3. Ask landmine questions as if the skill were live.
4. Chain another skill.

## Handoff

Nothing was written. Next: a later change fills this `SKILL.md` after the operator specifies the MVP spec job.
