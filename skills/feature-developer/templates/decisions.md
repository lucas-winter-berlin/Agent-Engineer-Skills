# Decisions

- Feature: {{FEATURE_NAME}}
- Status: {{none | linked | authored-here}}

Record accepted constraints for this feature. Prefer linking ADRs produced by `decision-matrix-architect`. If a single option was mandated, record it as a constraint without a fake matrix.

## Linked ADRs

| ADR | Path | Status | Constraint imposed on this feature |
| --- | --- | --- | --- |
| {{TITLE or none}} | {{PATH}} | {{proposed|accepted}} | {{CONSTRAINT}} |

## In-feature constraints (no ADR)

| ID | Constraint | Source | Reversible |
| --- | --- | --- | --- |
| CON-001 | {{STATEMENT}} | {{user mandate | existing code | discovery}} | {{yes|no}} |

Do not hide irreversible choices only in prose inside `architecture.md`. If more than one viable option remains, stop and run `decision-matrix-architect`.
