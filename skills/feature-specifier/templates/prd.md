# Product Requirements Document

- Feature name: `{{FEATURE_NAME}}`
- Title: {{TITLE}}
- Status: {{draft | awaiting-clarification | ready-for-review | approved}}
- Author: {{AUTHOR}}
- Date: {{DATE}}
- Clarification log: {{PATH}}
- Acceptance criteria: {{PATH}}

## 1. Problem statement

{{Who is affected, what is failing or missing today, and why it matters. No proposed solution in this section.}}

## 2. Goals

| ID | Goal | Success signal |
| --- | --- | --- |
| GOAL-001 | {{GOAL}} | {{OBSERVABLE SIGNAL}} |

## 3. Non-goals

| ID | Non-goal | Reason |
| --- | --- | --- |
| NGOAL-001 | {{NON-GOAL}} | {{REASON}} |

## 4. Scope boundaries

### In scope

| ID | Item | Notes |
| --- | --- | --- |
| SCOPE-001 | {{ITEM}} | {{NOTES}} |

### Out of scope

| ID | Item | Handling (`defer` / `reject` / `separate-change-request`) |
| --- | --- | --- |
| XSCOPE-001 | {{ITEM}} | {{HANDLING}} |

In-scope must be non-empty. Out-of-scope must be non-empty. If the user said "do everything," still list realistic exclusions (unrelated platforms, data migrations not requested, visual redesigns not requested).

## 5. Actors and channels

| Actor | Goal with this feature | Channel (UI / API / job / CLI / other) |
| --- | --- | --- |
| {{ACTOR}} | {{GOAL}} | {{CHANNEL}} |

## 6. Functional requirements

| ID | Requirement | Acceptance |
| --- | --- | --- |
| FR-001 | {{TESTABLE STATEMENT}} | AC-001 |

Each `FR-###` is a single testable statement. Do not combine unrelated behaviors in one row.

## 7. Non-functional requirements

| ID | Category | Requirement | Measurement |
| --- | --- | --- | --- |
| NFR-001 | {{latency | throughput | availability | security | privacy | observability | accessibility | compatibility | maintainability | cost | other}} | {{STATEMENT}} | {{HOW MEASURED}} |

If no NFR was stated, add the minimum set implied by the domain (for example authz for multi-user data) and mark them as derived, with assumption ids.

## 8. Data model

| Entity | Field | Type | Required | Sensitivity (`public` / `internal` / `confidential` / `restricted`) | Lifetime |
| --- | --- | --- | --- | --- | --- |
| {{ENTITY}} | {{FIELD}} | {{TYPE}} | {{yes|no}} | {{LABEL}} | {{session | durable | ephemeral}} |

Relationships:

{{ENTITY A}} {{1:1 | 1:N | N:M}} {{ENTITY B}} because {{REASON}}.

If the feature is stateless, set this section to `N/A` and explain what payload is ephemeral.

## 9. Product-level interfaces

| Interface | Actor | Operation | Inputs | Outputs | Error model |
| --- | --- | --- | --- | --- | --- |
| {{NAME}} | {{ACTOR}} | {{OPERATION}} | {{INPUTS}} | {{OUTPUTS}} | {{ERRORS}} |

Do not specify class names unless mandated.

## 10. Acceptance criteria

Gherkin lives in `acceptance-criteria.md`. Summary map:

| FR / NFR | AC ids | Negative path covered |
| --- | --- | --- |
| FR-001 | AC-001, AC-002 | {{yes|no}} |

## 11. Assumptions

| ID | Statement | Risk | Owner | Default if true |
| --- | --- | --- | --- | --- |
| ASM-001 | {{STATEMENT}} | {{low|medium|high}} | {{OWNER}} | {{DEFAULT}} |

## 12. Risks

| ID | Risk | Likelihood | Impact | Mitigation |
| --- | --- | --- | --- | --- |
| RISK-001 | {{RISK}} | {{low|medium|high}} | {{low|medium|high}} | {{MITIGATION}} |

## 13. Definition of done

- [ ] Every `AC-###` passes (automated or manual)
- [ ] Every `NFR-###` has a measurement result or an accepted exception
- [ ] Out-of-scope items are not implemented
- [ ] Assumptions still valid or explicitly replaced
- [ ] Handoff path recorded (`feature-developer` specPath)

## 14. Handoff

- Next skill: {{feature-developer | decision-matrix-architect | sec-analyzer-tester}}
- Spec path: {{PATH}}
- Open architectural options: {{none | list}}
