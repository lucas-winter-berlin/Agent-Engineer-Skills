# Security and Edge Case Audit

- Feature: {{FEATURE_NAME}}
- Auditor (agent runtime): {{RUNTIME}}
- Date: {{TIMESTAMP}}
- Mode: {{embedded-phase-5 | full-sec-analyzer-tester}}
- Status: {{open | dispositions-complete}}

## System under review

{{Short description of the implemented change and the interfaces it added or modified.}}

## Trust boundaries

| ID | From | To | Data crossing | Control (authn/authz/integrity) |
| --- | --- | --- | --- | --- |
| TB-001 | {{COMPONENT}} | {{COMPONENT}} | {{DATA}} | {{CONTROL or none}} |

If no trust boundary is crossed, state that explicitly and limit STRIDE to local tampering and repudiation of logs.

## STRIDE findings

| ID | Boundary | Category | Description | Severity (`low` / `medium` / `high` / `critical`) | Disposition |
| --- | --- | --- | --- | --- | --- |
| SEC-001 | TB-001 | {{S|T|R|I|D|E}} | {{DESCRIPTION}} | {{SEVERITY}} | {{fix | accept-risk | out-of-scope}} |

Category letters: Spoofing, Tampering, Repudiation, Information Disclosure, Denial of Service, Elevation of Privilege.

## Edge cases

| ID | Case | Expected behavior | Covered by | Result |
| --- | --- | --- | --- | --- |
| EDGE-001 | {{CASE}} | {{BEHAVIOR}} | {{test path or QA item}} | {{pass | fail | open}} |

Minimum cases to consider: empty input, oversized input, invalid types, unauthorized caller, expired credential, duplicate submission, timeout, partial downstream failure, clock skew, concurrent writers.

## Mitigations implemented

| Finding | Change path | Test path or QA item |
| --- | --- | --- |
| {{SEC-###}} | {{PATH}} | {{PATH}} |

## Accepted risks

| Finding | Owner | Expiry | Residual risk | User confirmation |
| --- | --- | --- | --- | --- |
| {{SEC-###}} | {{OWNER}} | {{DATE}} | {{RESIDUAL}} | {{APPROVED: feature-developer Phase 5-risk or n/a}} |

High and critical `accept-risk` rows require a named human owner. The agent cannot self-own accepted risk.

## Out of scope findings

| Finding | Reason | Follow-up |
| --- | --- | --- |
| {{SEC-###}} | {{REASON}} | {{new specifier item or ticket}} |

## Scanner inputs (optional)

| Scanner | Used | Finding IDs consumed | Notes |
| --- | --- | --- | --- |
| {{SCANNER}} | {{yes | no}} | {{IDS or n/a}} | {{does not replace STRIDE}} |

## Exit checklist

- [ ] Every trust boundary has at least one STRIDE pass recorded or an explicit "no applicable threat" note
- [ ] Every finding has a disposition
- [ ] Every `fix` has a test or a Phase 7 QA item
- [ ] No open `fix` remains
- [ ] High/critical accepted risks have owners
