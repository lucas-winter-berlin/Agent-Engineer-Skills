# Feature folders

One folder per feature, lowercase with hyphens, for example `invoice-csv-export`.

```
docs/features/<feature-name>/
  what-to-build.md           Locked product: specifier output
  what-was-implemented.md    What the developer changed and why
  what-was-reviewed.md       Review findings and refactors
  what-was-verified.md       Test cases, runs, slop check
  what-was-run.md            Harness log (only if feature-harness ran)
```

Do not add extra spec files in this folder.

## Naming

1. Folder name comes from the feature title (kebab-case).
2. Do not reuse a folder for a different feature.
3. `what-to-build.md` is the lock. The developer does not rewrite it while coding.
4. Daily order of write-ups: lock, implemented, reviewed, verified. Harness adds `what-was-run.md`.

Older fallbacks: `concept.md` counts as `what-to-build.md`. `notes.md` counts as `what-was-implemented.md`.
