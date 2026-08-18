# {{ADR_TITLE}}

- Status: {{proposed | accepted | rejected | deprecated | superseded}}
- Date: {{YYYY-MM-DD}}
- Deciders: {{NAMES or unknown}}
- Consulted: {{NAMES or n/a}}
- Informed: {{NAMES or n/a}}
- Decision id: {{DEC-###}}
- Matrix: {{PATH TO decision-matrix.md}}
- Supersedes: {{ADR path or n/a}}

## Context and problem statement

{{Two to four sentences. Neutral. No winner in this section.}}

Decision question: {{CLOSED CHOICE QUESTION}}

## Decision drivers

### Hard constraints

- HC-001: {{STATEMENT}} (source: {{SOURCE}})

### Weighted criteria

Weights sum to 100.

- C-001 {{NAME}} (weight {{N}}): {{ONE LINE}}

## Considered options

- {{OPT-A NAME}}
- {{OPT-B NAME}}
- {{OPT-C NAME or omit}}
- Status quo / do nothing: {{included | not viable because}}

## Decision outcome

Chosen option: "{{WINNER}}", because {{MATRIX-BACKED REASON, including weighted total and hard-constraint status}}.

### Consequences

- Good: {{POSITIVE CONSEQUENCE}}
- Bad: {{NEGATIVE CONSEQUENCE}}
- Neutral: {{NEUTRAL CONSEQUENCE}}

### Confirmation

We will know this decision succeeded when {{MEASURABLE SIGNAL, SLO, OPERATIONAL CHECK, OR MILESTONE}}.

### Reversal

If we reverse this decision we must {{MIGRATION, DATA COMPATIBILITY, API COMPATIBILITY}}. Estimated difficulty: {{low | medium | high}}.

## Confirmation of eligibility

| Option | Hard constraints | Eligible | Weighted total |
| --- | --- | --- | --- |
| {{NAME}} | {{all pass | failed HC-###}} | {{yes|no}} | {{TOTAL or n/a}} |

## Pros and cons of the options

### {{OPT-A NAME}}

- Pros: {{...}}
- Cons: {{...}}
- Edge cases: {{...}}

### {{OPT-B NAME}}

- Pros: {{...}}
- Cons: {{...}}
- Edge cases: {{...}}

### {{OPT-C NAME}}

- Pros: {{...}}
- Cons: {{...}}
- Edge cases: {{...}}

## More information

- Product spec: {{PATH or n/a}}
- Follow-on skill: `feature-developer` after status is `accepted`
- Security delta vs alternatives: {{PATH or n/a}}
- Approval token (recommended): `APPROVED: decision-matrix-architect Phase 5`

## Gate record

| Field | Value |
| --- | --- |
| Token | {{empty or APPROVED: decision-matrix-architect Phase 5}} |
| Reviewer | {{NAME or empty}} |
| Notes | {{NOTES or n/a}} |
