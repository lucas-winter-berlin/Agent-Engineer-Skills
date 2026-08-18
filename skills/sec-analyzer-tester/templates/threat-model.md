# Threat Model

- System under review: {{SYSTEM}}
- Feature directory: {{PATH or n/a}}
- Date: {{DATE}}
- Runtime: {{RUNTIME}}
- `tests.automated`: {{true | false}}
- `ci.present`: {{true | false}}
- Status: {{draft | modeled | complete}}

## 1. Scope of review

{{What is in the review. What is excluded. Do not threat-model the entire company if the user named one API.}}

## 2. Assets

| ID | Asset | Sensitivity | Location | Owner |
| --- | --- | --- | --- | --- |
| AST-001 | {{ASSET}} | {{public | internal | confidential | restricted}} | {{COMPONENT}} | {{OWNER}} |

## 3. Actors

| Actor | Trust level | Capabilities |
| --- | --- | --- |
| {{anonymous | authenticated-user | admin | insider | service-account | third-party}} | {{untrusted | semi-trusted | trusted}} | {{CAPABILITIES}} |

## 4. Data-flow diagram

```mermaid
flowchart LR
  user[{{Actor}}] -->|{{flow}}| edge[{{Edge}}]
  edge -->|{{flow}}| app[{{Process}}]
  app -->|{{flow}}| db[{{Store}}]
```

Replace labels with real names. Edges are data flows. Annotate secrets, PII, and tokens in the table below, not as emoji on the diagram.

## 5. Trust boundaries

| ID | From | To | Data | Existing control |
| --- | --- | --- | --- | --- |
| TB-001 | {{NODE}} | {{NODE}} | {{DATA CLASS}} | {{TLS | authn | authz | signing | none}} |

If no trust boundary is crossed, state that here and limit STRIDE to local tampering and log repudiation.

## 6. Assumptions

| ID | Assumption | Invalidated if |
| --- | --- | --- |
| ASM-001 | {{ASSUMPTION}} | {{CONDITION}} |

## 7. STRIDE per boundary

Complete every cell. Use `N/A: reason` when a category does not apply.

| Boundary | Spoofing | Tampering | Repudiation | Information Disclosure | Denial of Service | Elevation of Privilege |
| --- | --- | --- | --- | --- | --- | --- |
| TB-001 | {{SEC-### or N/A}} | {{SEC-### or N/A}} | {{SEC-### or N/A}} | {{SEC-### or N/A}} | {{SEC-### or N/A}} | {{SEC-### or N/A}} |

## 8. Findings catalog

| ID | Boundary | STRIDE | Description | Attacker precondition (non-actionable) | Impact | Severity |
| --- | --- | --- | --- | --- | --- | --- |
| SEC-001 | TB-001 | {{category}} | {{WHAT CAN GO WRONG}} | {{WHO WOULD NEED TO BE WHERE, NOT HOW TO EXPLOIT}} | {{IMPACT}} | {{low|medium|high|critical}} |

Do not include exploit payloads, reproduction steps, or weaponized PoCs.

## 9. Scanner inputs consumed

| Scanner | Finding | Mapped to |
| --- | --- | --- |
| {{SCANNER or none}} | {{ID}} | {{SEC-### or new row}} |

## 10. Exit

- [ ] Diagram matches the system under review
- [ ] Every boundary has a full STRIDE row
- [ ] Every finding has severity
- [ ] No blank STRIDE cells
