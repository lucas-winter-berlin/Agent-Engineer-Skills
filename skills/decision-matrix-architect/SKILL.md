---
name: decision-matrix-architect
description: >-
  Produces objective trade-off analysis and Architectural Decision Records
  using hard-constraint identification, a weighted 1-5 scoring matrix, and
  MADR-formatted ADRs with pros, cons, and edge cases. Use when the user asks
  which option to choose, requests an ADR, or needs a scored comparison of
  architectures, libraries, or designs.
---

# decision-matrix-architect

Objective trade-off analysis and Architectural Decision Records. This file is an execution contract. Do not implement the chosen option unless the user subsequently invokes `feature-developer`. Do not produce a matrix to retroactively justify code unless the user asked to document a decision after the fact.

Canonical schema: [schema.json](schema.json). Framework: [docs/ARCHITECTURE.md](../../docs/ARCHITECTURE.md). ADR format: MADR (Markdown Architectural Decision Records).

## When to use

Use when two or more technically viable options remain, the choice is costly to reverse, or an ADR is required.

Do not use when a single viable option exists, the user issued a hard mandate and only wants implementation, or the choice is trivial and reversible with no architectural blast radius.

## Guardrails

Must:

1. Announce `Using skill: decision-matrix-architect`.
2. Separate hard constraints from weighted criteria. Hard constraints are pass/fail. They are not scored.
3. Use a 1-5 integer scale for scored criteria. Define what 1 and 5 mean per criterion.
4. Assign weights that sum to 100.
5. Score every option against every criterion. Do not leave cells blank; use `n/a` only when a criterion cannot apply, and explain why.
6. Disqualify any option that fails a hard constraint. Do not keep it in the weighted total as if it were eligible.
7. Record pros, cons, and edge cases per option.
8. Emit a MADR ADR using [templates/adr.md](templates/adr.md).
9. State the recommendation as a consequence of the matrix, not as an unexplained preference.
10. No icons or emojis.

Must not:

1. Introduce a favored option that was not in the candidate set without labeling it as a newly discovered option and re-scoring.
2. Change weights after seeing scores unless the user directs a sensitivity analysis (then record both matrices).
3. Treat vendor marketing claims as evidence.
4. Hide a hard constraint inside a scored criterion.
5. Implement production code.

## Scoring rules

| Score | Meaning |
| --- | --- |
| 1 | Poor fit. High cost, high risk, or severe limitation relative to the criterion. |
| 2 | Weak fit. Workable with significant drawbacks. |
| 3 | Acceptable fit. Neutral or industry-default adequacy. |
| 4 | Strong fit. Clear advantage with manageable drawbacks. |
| 5 | Excellent fit. Best among realistic options for this criterion. |

Weighted total for option O:

```text
sum(score(O, criterion_i) * weight_i) / 1
```

Weights are percentages that sum to 100. Report totals with one decimal place.

Ties: prefer the option that passes more hard constraints with margin, then the option with higher score on the highest-weighted criterion, then record a tie and stop for human choice.

## Phases

### Phase 1. Frame the decision

**Objective.** Write a decision question that one option can answer.

**Steps.**

1. State the context and problem in two to four sentences.
2. Write the decision question as a closed choice ("Which X will we use for Y?") not as a wish ("How do we make it scalable?").
3. Identify deciders, consulted parties, and informed parties if the user named them; otherwise mark `unknown`.
4. List non-goals of this decision (what will not be solved by this ADR).

### Phase 2. Hard constraints

**Objective.** Identify pass/fail constraints before scoring.

**Steps.**

1. Extract constraints from the user, the PRD, regulation, and Capability Discovery if a workspace is present (existing language, mandated vendor, data residency, latency SLO, offline requirement).
2. Phrase each constraint so a candidate can fail it with evidence.
3. Do not put preferences here ("we prefer open source") unless they are actual mandates.

### Phase 3. Criteria and weights

**Objective.** Build the scored model.

**Steps.**

1. Derive 4-8 criteria from the problem (operability, latency, consistency, team skill, cost, maturity, lock-in, security model, local/offline, ecosystem).
2. Define 1 and 5 for each criterion in one line each.
3. Assign integer weights summing to 100. Higher weight means more damage if wrong.
4. Present criteria and weights before scoring when the user is available. If they are not, proceed and label weights as `agent-proposed`.

### Phase 4. Options and matrix

**Objective.** Enumerate options and score them.

**Steps.**

1. List 2-5 options. Include "status quo / do nothing" when continuing without change is viable.
2. For each option: short description, evidence sources, pros, cons, edge cases.
3. Evaluate hard constraints. Mark `pass` or `fail` with evidence. Failed options drop out of the weighted ranking.
4. Score remaining options 1-5 per criterion. Instantiate [templates/decision-matrix.md](templates/decision-matrix.md).
5. Compute weighted totals. Rank eligible options.

### Phase 5. ADR (MADR)

**Objective.** Record the decision in MADR form.

**Steps.**

1. Instantiate [templates/adr.md](templates/adr.md).
2. Set status `proposed` until the user accepts it. Recommended gate token: `APPROVED: decision-matrix-architect Phase 5`.
3. Decision outcome names the winning option, consequences (positive, negative, neutral), and confirmation (how we will know it worked).
4. Include "If we later reverse this decision" notes (migration cost, data compatibility).
5. Link the matrix file from the ADR.

If the user rejects the recommendation, do not silently pick another winner. Re-open Phase 3 or Phase 4 with the stated objection (wrong weight, missing option, failed constraint that is actually a preference).

## MADR field mapping

This skill uses the MADR 3.x information model:

| MADR field | This skill |
| --- | --- |
| Title | ADR title, imperative or noun phrase |
| Status | proposed / accepted / rejected / deprecated / superseded |
| Deciders | named or unknown |
| Date | ISO date |
| Context and problem statement | Phase 1 |
| Decision drivers | hard constraints + weighted criteria |
| Considered options | Phase 4 |
| Decision outcome | winner + consequences |
| Confirmation | measurable signal |
| Pros and cons of the options | per-option sections |
| More information | links to matrix, PRD, follow-on skill |

## Composition

- Upstream: `feature-specifier` (problem and constraints).
- Downstream: `feature-developer` consumes the accepted ADR as a locked constraint.
- Peer: `sec-analyzer-tester` may be required when options differ by trust-boundary shape; if so, do not finalize the ADR until the security delta is stated.
