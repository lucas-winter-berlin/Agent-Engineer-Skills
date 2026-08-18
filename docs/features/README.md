# Feature Documentation Convention

Feature work produced by `feature-developer` is stored under this directory using a kebab-case feature identifier.

```
docs/features/<feature-name>/
  README.md                 Canonical feature index
  spec.md                   Frozen product specification
  architecture.md           Approved architecture plan
  decisions.md              Linked ADRs and trade-off records
  capability-report.md      Detected local toolchain
  review-gate.md            Human sign-off record
  implementation-log.md     TDD iteration history
  security-audit.md         Security and edge-case audit
  verification.md           CI/CD or manual QA evidence
```

## Naming Rules

1. `<feature-name>` is lowercase kebab-case, derived from the approved specification title.
2. Do not reuse a feature directory for an unrelated change. Create a new identifier.
3. After the Docs Freeze phase, treat `spec.md` and `architecture.md` as immutable unless a new change request is opened.
4. Global system documents (architecture overviews, API catalogs, runbooks) are updated only during Docs Freeze, and only with explicit diffs recorded in the feature directory.

## Agent Contract

Agents must not invent a feature directory name after implementation starts. The name is locked at the end of Phase 2 (Spec & Architecture Plan Blueprint) and confirmed at the Human Review Gate.
