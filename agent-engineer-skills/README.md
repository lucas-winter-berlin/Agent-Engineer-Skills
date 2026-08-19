# Feature folders

This folder lives in the **app** repo. It is named after this pack so write-ups are not mixed with the app's own `docs/`.

Install creates `agent-engineer-skills/` if it is missing. Copy this README into the app folder if it has none. Do not copy this pack's `docs/` or `schemas/` into the app.

One folder per feature, lowercase with hyphens, for example `invoice-csv-export`.

```
agent-engineer-skills/<feature-name>/
  what-to-build.md           Specification: feature-specifier or mvp-specifier output
  what-was-implemented.md    What the developer changed and why
  what-was-reviewed.md       Review findings and refactors
  what-was-verified.md       Test cases, runs, slop check
```

Do not add extra spec files in this folder.

## Naming

1. Folder name comes from the feature title (kebab-case).
2. Do not reuse a folder for a different feature.
3. `what-to-build.md` is the specification. The developer does not rewrite it while coding.
4. Write-ups appear only for skills that ran. You do not need every file if you used one skill alone.

Compatibility: if `agent-engineer-skills/<name>/` is missing but `docs/features/<name>/` exists, use the old folder for that feature. If only `concept.md` exists, it counts as `what-to-build.md`. If only `notes.md` exists, it counts as `what-was-implemented.md`. If a human says "lock" meaning the spec file, they mean `what-to-build.md`.
