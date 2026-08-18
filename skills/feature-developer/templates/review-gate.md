# Human Review Gate

- Skill: `feature-developer`
- Phase: 3
- Feature: {{FEATURE_NAME}}
- Directory: `docs/features/{{FEATURE_NAME}}/`
- Submitted at: {{TIMESTAMP}}
- Gate state: {{pending | approved | rejected | invalid-token}}

## Artifacts under review

| Artifact | Path |
| --- | --- |
| Capability report | `docs/features/{{FEATURE_NAME}}/capability-report.md` |
| Spec | `docs/features/{{FEATURE_NAME}}/spec.md` |
| Architecture | `docs/features/{{FEATURE_NAME}}/architecture.md` |
| Decisions | `docs/features/{{FEATURE_NAME}}/decisions.md` |

## Scope submitted

### In scope

{{BULLET LIST FROM SPEC}}

### Out of scope

{{BULLET LIST FROM SPEC}}

## Irreversible decisions

If approved, the agent will treat the following as locked:

1. {{DECISION}}

## Adaptive execution modes that will apply after approval

```text
tests.automated={{true|false}}
ci.present={{true|false}}
lint.blocking={{true|false}}
verificationMode={{ci|manual-qa|unverified-local}}
```

## Open assumptions

| ID | Assumption | Risk | Requested action |
| --- | --- | --- | --- |
| ASM-001 | {{ASSUMPTION}} | {{RISK}} | {{accept | reject | replace}} |

## Files expected to change after approval

{{LIST FROM ARCHITECTURE PLAN}}

## Agent stop condition

The agent is stopped. No source or test files will be modified until a valid token is recorded below.

Required approval:

```text
APPROVED: feature-developer Phase 3
```

Required rejection:

```text
REJECTED: feature-developer Phase 3
1. <change>
2. <change>
```

## Reviewer record

| Field | Value |
| --- | --- |
| Token received | {{TOKEN or empty}} |
| Reviewer | {{NAME or empty}} |
| Recorded at | {{TIMESTAMP or empty}} |
| Notes | {{NOTES or n/a}} |

## Invalid token log

If the user sent a non-conforming approval, record it here and remain in `pending`.

| Attempt at | Text (verbatim, no emoji expected) | Reason invalid |
| --- | --- | --- |
| {{TIMESTAMP}} | {{TEXT}} | {{missing-skill | missing-phase | wrong-phase | implied-only}} |
