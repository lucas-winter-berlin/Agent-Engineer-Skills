# Docs Freeze Manifest

- Feature: {{FEATURE_NAME}}
- Frozen at: {{TIMESTAMP}}
- Frozen by: {{RUNTIME}}
- Precondition: Phase 5 dispositions complete

After this file is complete, `spec.md` and `architecture.md` are immutable without a new change request.

## Local feature artifacts (frozen)

| Path | Role | Complete (`yes` / `no`) |
| --- | --- | --- |
| `docs/features/{{FEATURE_NAME}}/README.md` | Index | {{yes|no}} |
| `docs/features/{{FEATURE_NAME}}/spec.md` | Product spec | {{yes|no}} |
| `docs/features/{{FEATURE_NAME}}/architecture.md` | Architecture | {{yes|no}} |
| `docs/features/{{FEATURE_NAME}}/decisions.md` | ADRs / links | {{yes|no}} |
| `docs/features/{{FEATURE_NAME}}/capability-report.md` | Discovery | {{yes|no}} |
| `docs/features/{{FEATURE_NAME}}/review-gate.md` | Gate record | {{yes|no}} |
| `docs/features/{{FEATURE_NAME}}/implementation-log.md` | TDD history | {{yes|no}} |
| `docs/features/{{FEATURE_NAME}}/security-audit.md` | Audit | {{yes|no}} |

All rows must be `yes` to freeze.

## Global system sync

| Global path | Action (`create` / `modify` / `none`) | Reason | Summary of change |
| --- | --- | --- | --- |
| {{PATH}} | {{ACTION}} | {{REASON}} | {{SUMMARY}} |

If no global document requires an update, include one row with action `none` and reason `no externally visible behavior change`.

## Diff policy

- Unrelated files were not rewritten for style: {{yes}}
- Public identifiers in global docs match the feature spec: {{yes | no, with gaps}}
- OpenAPI / API catalog updated if public HTTP/RPC changed: {{yes | n/a}}

## Freeze declaration

```text
FREEZE: feature-developer {{FEATURE_NAME}}
spec.md = immutable
architecture.md = immutable
```

Amendments require a new `feature-specifier` run or an explicit change request document, not in-place silent edits.

## Exceptions

{{none | list of files intentionally left draft, with owner}}
