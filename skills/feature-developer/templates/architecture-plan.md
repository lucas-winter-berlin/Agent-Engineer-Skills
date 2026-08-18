# Architecture and Spec Blueprint

Use this template to fill `docs/features/<feature-name>/architecture.md`. Copy product-facing sections into `spec.md` when no upstream PRD exists. Do not delete sections; unused sections are `N/A` plus a one-line reason.

- Feature name: {{FEATURE_NAME}}
- Status: {{draft | in-review}}
- Spec source: {{path to PRD or "authored in this blueprint"}}
- Capability report: {{path}}
- Related ADRs: {{paths or n/a}}

## 1. Problem and outcome

{{What user or system outcome this feature produces. One to three paragraphs.}}

## 2. Scope

### In scope

| ID | Item | Notes |
| --- | --- | --- |
| SCOPE-001 | {{ITEM}} | {{NOTES}} |

### Out of scope

| ID | Item | Handling |
| --- | --- | --- |
| XSCOPE-001 | {{ITEM}} | {{defer | reject | separate-change-request}} |

## 3. Requirements

### Functional

| ID | Requirement | Acceptance mapping |
| --- | --- | --- |
| FR-001 | {{REQUIREMENT}} | {{AC-001}} |

### Non-functional

| ID | Category | Requirement | Measurement |
| --- | --- | --- | --- |
| NFR-001 | {{latency | security | availability | observability | accessibility | other}} | {{REQUIREMENT}} | {{MEASURE}} |

## 4. Acceptance criteria (Gherkin)

```gherkin
Feature: {{FEATURE_TITLE}}

  Scenario: {{AC-001 title}}
    Given {{precondition}}
    When {{action}}
    Then {{observable result}}
```

Every `FR-###` maps to at least one scenario. Negative paths are first-class scenarios, not footnotes.

## 5. Constraints from discovery

| Constraint | Source | Impact on design |
| --- | --- | --- |
| {{CONSTRAINT}} | {{capability-report field}} | {{IMPACT}} |

Hard constraints are not optional preferences. Do not propose violating them.

## 6. Context diagram

```mermaid
flowchart LR
  actor[{{Actor}}] --> edge[{{Edge / API}}]
  edge --> app[{{Application component}}]
  app --> data[{{Datastore}}]
```

Replace node labels with real component names from the repository. Do not use icons.

## 7. Component design

| Component | Responsibility | Existing path or new path | Public interface |
| --- | --- | --- | --- |
| {{NAME}} | {{RESPONSIBILITY}} | {{PATH}} | {{function / route / event}} |

## 8. Data and APIs

### Data model

| Entity | Key fields | Persistence | Ownership |
| --- | --- | --- | --- |
| {{ENTITY}} | {{FIELDS}} | {{table / collection / file / n/a}} | {{COMPONENT}} |

### Interfaces

| Interface | Contract | Authn / authz | Idempotency |
| --- | --- | --- | --- |
| {{HTTP / RPC / event / CLI}} | {{signature or spec path}} | {{MODEL}} | {{yes | no | n/a}} |

## 9. Failure modes

| Failure | Detection | User-visible effect | Recovery |
| --- | --- | --- | --- |
| {{FAILURE}} | {{DETECTION}} | {{EFFECT}} | {{RETRY / COMPENSATE / FAIL CLOSED}} |

## 10. Test strategy

| Layer | Tool (from discovery) | What will be tested | Command |
| --- | --- | --- | --- |
| Unit | {{FRAMEWORK or n/a}} | {{...}} | {{COMMAND or n/a}} |
| Integration | {{FRAMEWORK or n/a}} | {{...}} | {{COMMAND or n/a}} |
| Manual QA | checklist | {{scenarios without automation}} | n/a |

If `tests.automated` is false, state that tests will still be written and marked unverified-local until a runner exists.

## 11. Files expected to change

| Path | Action (`create` / `modify` / `delete`) | Reason |
| --- | --- | --- |
| {{PATH}} | {{ACTION}} | {{REASON}} |

## 12. Rollout and backout

- Rollout: {{feature flag, migration, deploy order}}
- Backout: {{revert strategy, data compatibility}}
- Observability: {{logs, metrics, traces to add}}

## 13. Open assumptions

| ID | Assumption | Risk (`low` / `medium` / `high`) | Owner | Invalidated if |
| --- | --- | --- | --- | --- |
| ASM-001 | {{ASSUMPTION}} | {{RISK}} | {{OWNER}} | {{CONDITION}} |

## 14. Irreversible decisions submitted for Phase 3

1. {{DECISION}}
2. {{DECISION}}

## 15. Gate ask

Reviewer must reply with `APPROVED: feature-developer Phase 3` or `REJECTED: feature-developer Phase 3` plus numbered changes. Implementation must not start without the approval token.
