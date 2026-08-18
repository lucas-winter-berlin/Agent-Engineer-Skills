# Mitigation Plan

- System under review: {{SYSTEM}}
- Threat model: {{PATH}}
- Date: {{DATE}}
- Status: {{proposed | approved-fixes | awaiting-risk-acceptance | complete}}

## Disposition rules

- `fix`: implement or specify a control in this change (or the linked `feature-developer` run)
- `accept-risk`: residual risk remains; requires named human owner for high/critical; expiry date required
- `out-of-scope`: tracked as a follow-up specifier item, not silently ignored

High/critical `accept-risk` requires:

```text
APPROVED: sec-analyzer-tester Phase 4
```

## Mitigations

| Finding | Severity | Disposition | Control | Owner | Expiry | Test / QA id |
| --- | --- | --- | --- | --- | --- | --- |
| SEC-001 | {{SEV}} | {{fix|accept-risk|out-of-scope}} | {{CONTROL DESCRIPTION}} | {{OWNER or agent-for-fix}} | {{DATE or n/a}} | {{T-### or QA-###}} |

## Control design notes

For each `fix`, describe the control in engineering terms (where it runs, fail-open vs fail-closed, what identity it uses). Do not describe attacks.

### SEC-001

- Control: {{CONTROL}}
- Location: {{PATH or component}}
- Fail mode: {{fail-closed | fail-open with justification}}
- Dependencies: {{none | decision-matrix-architect | new vendor}}

## Residual risk register

| Finding | Residual risk | Owner | Expiry | Review signal |
| --- | --- | --- | --- | --- |
| {{SEC-### or none}} | {{STATEMENT}} | {{HUMAN}} | {{DATE}} | {{METRIC OR REVIEW DATE}} |

## Out of scope follow-ups

| Finding | Specifier item |
| --- | --- |
| {{SEC-### or none}} | {{ONE-LINE FUTURE WORK}} |

## Gate record

| Field | Value |
| --- | --- |
| Token required | {{yes if any high/critical accept-risk else no}} |
| Token | {{empty or APPROVED: sec-analyzer-tester Phase 4}} |
| Reviewer | {{NAME or empty}} |
