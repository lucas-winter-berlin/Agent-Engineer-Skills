# Decision Matrix

- Decision id: {{DEC-###}}
- Question: {{DECISION_QUESTION}}
- Date: {{DATE}}
- Weight source: {{user-approved | agent-proposed}}
- Related spec: {{PATH or n/a}}

Weights must sum to 100. Scores are integers 1-5 as defined in the skill contract.

## Hard constraints

| ID | Constraint | Source | Option A | Option B | Option C |
| --- | --- | --- | --- | --- | --- |
| HC-001 | {{STATEMENT}} | {{USER / PRD / REGULATION / DISCOVERY}} | {{pass|fail}} | {{pass|fail}} | {{pass|fail}} |

Failed options are ineligible. Do not include them in the ranking of totals.

## Criteria definitions

| ID | Criterion | Weight | Score 1 means | Score 5 means |
| --- | --- | --- | --- | --- |
| C-001 | {{NAME}} | {{N}} | {{MEANING}} | {{MEANING}} |

Weight total: {{SUM}} (must equal 100).

## Scores and rationale

For each eligible option, score every criterion. Rationale is mandatory.

### Option {{OPT-A}}: {{NAME}}

Eligible: {{yes | no}}

| Criterion | Score (1-5) | Rationale (evidence, not marketing) |
| --- | --- | --- |
| C-001 | {{N}} | {{RATIONALE}} |

Weighted total: {{TOTAL}}

Pros:

- {{PRO}}

Cons:

- {{CON}}

Edge cases:

- {{EDGE CASE AND HOW THIS OPTION BEHAVES}}

### Option {{OPT-B}}: {{NAME}}

Eligible: {{yes | no}}

| Criterion | Score (1-5) | Rationale |
| --- | --- | --- |
| C-001 | {{N}} | {{RATIONALE}} |

Weighted total: {{TOTAL}}

Pros:

- {{PRO}}

Cons:

- {{CON}}

Edge cases:

- {{EDGE CASE}}

### Option {{OPT-C}}: {{NAME}} (omit section if unused)

Eligible: {{yes | no}}

| Criterion | Score (1-5) | Rationale |
| --- | --- | --- |
| C-001 | {{N}} | {{RATIONALE}} |

Weighted total: {{TOTAL}}

Pros:

- {{PRO}}

Cons:

- {{CON}}

Edge cases:

- {{EDGE CASE}}

## Ranking (eligible only)

| Rank | Option | Weighted total | Notes |
| --- | --- | --- | --- |
| 1 | {{NAME}} | {{TOTAL}} | {{margin vs rank 2}} |

## Recommendation

- Winner: {{NAME or TIE}}
- Why the matrix selected it: {{ONE PARAGRAPH}}
- Sensitivity: {{what happens if the top-weighted criterion is reduced by 10 points}}
- Human gate: reply `APPROVED: decision-matrix-architect Phase 5` to accept the ADR, or reject with numbered objections.

## Disqualified options

| Option | Failed constraint | Evidence |
| --- | --- | --- |
| {{NAME or none}} | {{HC-###}} | {{EVIDENCE}} |
