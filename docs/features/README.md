# Feature folders

When the agent implements a feature, it creates one folder per feature. The name is lowercase with hyphens, for example `invoice-csv-export`.

```
docs/features/<feature-name>/
  README.md                 Short index of the feature
  spec.md                   What we are building
  architecture.md           How we are building it
  decisions.md              Linked decisions (ADRs)
  capability-report.md      What the agent found in the repo (tests, CI, linters)
  review-gate.md            Your approve / reject record
  implementation-log.md     Test-then-code history
  security-audit.md         Security and edge-case notes
  verification.md           CI results or a filled QA checklist
```

## Naming

1. Derive the folder name from the spec title. Use lowercase and hyphens.
2. Do not reuse a folder for a different feature. Start a new name.
3. After docs freeze, do not quietly edit `spec.md` or `architecture.md`. Open a new change request instead.
4. Shared docs (app README, API catalog) are updated only during freeze, and only with a listed reason.

## For the agent

Do not invent a new folder name after coding has started. The name is chosen at the end of the plan step and confirmed when the human approves Phase 3.
