# Acceptance Criteria

- Feature: {{FEATURE_NAME}}
- Source PRD: {{PATH}}
- Status: {{draft | ready-for-review | approved}}

Rules:

1. Observable behavior only. Do not name classes, tables, or frameworks unless they are user-visible contracts.
2. Every `FR-###` maps to at least one scenario.
3. Include negative paths for authorization, validation, and empty state when those concepts exist.
4. `Then` clauses are checks a tester can perform without reading source.

```gherkin
Feature: {{FEATURE_TITLE}}
  As a {{ACTOR}}
  I want {{CAPABILITY}}
  So that {{OUTCOME}}

  @id:AC-001
  Scenario: {{TITLE}}
    Given {{precondition}}
    And {{additional precondition if needed}}
    When {{action}}
    Then {{observable result}}
    And {{additional observable result if needed}}

  @id:AC-002 @negative
  Scenario: {{TITLE}}
    Given {{precondition}}
    When {{invalid or unauthorized action}}
    Then {{observable rejection}}
    And {{system state unchanged in a stated way}}

  @id:AC-003 @security
  Scenario: {{TITLE}}
    Given {{authenticated actor without permission}}
    When {{forbidden action}}
    Then {{access is denied}}
    And {{no sensitive payload is returned}}

  @id:AC-004 @nfr
  Scenario: {{TITLE}}
    Given {{load or environmental precondition}}
    When {{action}}
    Then {{measurable NFR result}}
```

## Traceability

| AC | Tags | FR / NFR | Given (summary) | When (summary) | Then (summary) |
| --- | --- | --- | --- | --- | --- |
| AC-001 | | FR-001 | {{...}} | {{...}} | {{...}} |
| AC-002 | negative | FR-001 | {{...}} | {{...}} | {{...}} |

## Coverage gaps

| FR / NFR | Gap | Resolution |
| --- | --- | --- |
| {{ID or none}} | {{GAP or none}} | {{add scenario | mark N/A with reason}} |
