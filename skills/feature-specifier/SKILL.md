---
name: feature-specifier
description: >-
  Transforms ambiguous ideas or user requests into unambiguous PRDs with
  in-scope and out-of-scope boundaries, at most five clarification questions,
  logged assumptions, functional and non-functional requirements, data models,
  and Gherkin acceptance criteria. Use when the user asks to specify a feature,
  write a PRD, define scope, or produce Given-When-Then criteria before
  implementation.
---

# feature-specifier

Transform ambiguous ideas or user requests into unambiguous product requirement documents. This file is an execution contract. Do not implement code. Do not skip clarification when the request is underspecified. Do not invent stakeholder intent.

Canonical schema: [schema.json](schema.json). Framework: [docs/ARCHITECTURE.md](../../docs/ARCHITECTURE.md).

## When to use

Use when the request is ambiguous, scope is unset, "done" is undefined, or the user asks for a PRD, spec, scope boundary, or acceptance criteria.

Do not use when a PRD is already approved and the user wants code (`feature-developer`), a trade-off (`decision-matrix-architect`), or only a threat model (`sec-analyzer-tester`). Do not re-specify as a delay tactic.

## Guardrails

Must:

1. Announce `Using skill: feature-specifier`.
2. Ask at most three to five clarification questions, batched in one turn, only for information that changes scope, risk, or acceptance.
3. Log remaining unknowns as numbered assumptions with risk and owner.
4. Produce explicit In-Scope and Out-of-Scope lists.
5. Write functional and non-functional requirements with stable ids.
6. Include a data model when state is persisted or exchanged.
7. Express acceptance as Gherkin (`Given` / `When` / `Then`), including negative paths.
8. Instantiate templates. Do not replace them with an essay.
9. Write in English. No icons or emojis.

Must not:

1. Implement source code, refactors, or CI changes.
2. Ask more than five questions in the clarification round.
3. Ask questions whose answers are already in the repository or the user message.
4. Hide uncertainty inside vague requirements ("handle this appropriately").
5. Treat out-of-scope items as stretch goals to be coded later without a new specifier run.
6. Produce Gherkin that restates implementation details instead of observable behavior.

## Clarification policy

Ask a question only if all of the following are true:

1. The answer would change In-Scope, Out-of-Scope, a requirement, or an acceptance scenario.
2. The answer cannot be evidenced from the workspace.
3. The question is not already answered in the user request.

Batch 3-5 questions. Prefer closed or enumerated options. If the user declines to answer, convert each unanswered question into `ASM-###` with risk `high` unless the item is dropped to Out-of-Scope.

Do not wait indefinitely. After one clarification round, produce the PRD with assumptions. A second round is allowed only if the user contradicts the first answers.

## Phases

### Phase 1. Intake and ambiguity scan

**Objective.** Extract what is known and what is blocking an unambiguous spec.

**Steps.**

1. Restate the request in one paragraph without adding features.
2. List known actors, systems, and constraints from the user and from a lightweight workspace scan (existing product docs, domain terms).
3. Classify gaps: actor, problem, success metric, constraints, data, channels, non-functionals, exclusions.
4. If no blocking gaps exist, skip to Phase 3 and record "clarification round skipped: request already unambiguous."
5. Otherwise draft 3-5 questions using [templates/clarification-log.md](templates/clarification-log.md).

### Phase 2. Clarification round

**Objective.** Resolve blocking gaps or convert them into assumptions.

**Steps.**

1. Present the questions. Stop implementation-oriented discussion.
2. Record answers verbatim in the clarification log.
3. Unanswered items become assumptions (`ASM-###`) with risk and a proposed default.
4. If an answer expands scope beyond the original request, call it out and require the user to confirm the expansion before it enters In-Scope.

### Phase 3. PRD synthesis

**Objective.** Write the PRD.

**Steps.**

1. Instantiate [templates/prd.md](templates/prd.md).
2. Fill metadata: title, kebab-case `featureName`, status `draft`, authors, date.
3. Write problem statement, goals, non-goals.
4. Write In-Scope and Out-of-Scope as tables with ids.
5. Write `FR-###` and `NFR-###`. Each FR is testable. Each NFR has a measurement.
6. Write the data model: entities, fields, identities, lifetimes, retention, sensitivity.
7. Write interfaces at the product level (who does what, through which channel), not class names unless the user mandated them.
8. Write Gherkin in [templates/acceptance-criteria.md](templates/acceptance-criteria.md) and embed or link it from the PRD.
9. Map every `FR-###` to at least one scenario. Include unauthorized, invalid, and empty-state scenarios where applicable.
10. List assumptions, risks, and open questions that survived.
11. Define `Definition of Done` as: all AC scenarios pass, NFRs measured, out-of-scope untouched.

### Phase 4. Consistency check

**Objective.** Catch internal contradictions before handoff.

**Steps.**

1. Every In-Scope item has a requirement or is explicitly a constraint.
2. No Out-of-Scope item appears in Gherkin as required behavior.
3. No requirement lacks an acceptance scenario.
4. Data entities used in scenarios exist in the data model.
5. Assumptions do not silently override hard constraints stated by the user.
6. Set status to `ready-for-review` or keep `draft` if high-risk assumptions remain.
7. If high-risk assumptions remain, recommend a human review before `feature-developer` Phase 3. This skill's own gate is optional; questions and assumption logging are not.

## Output formatting

- Feature name: lowercase kebab-case, max 64 characters.
- Requirement ids: `FR-001`, `NFR-001`, `AC-001`, `SCOPE-001`, `XSCOPE-001`, `ASM-001`, `RISK-001`.
- Gherkin: one `Feature` block, multiple `Scenario` or `Scenario Outline` blocks. No UI-emoji. Tags optional (`@negative`, `@security`, `@nfr`).
- Sensitivity labels for data fields: `public`, `internal`, `confidential`, `restricted`.

## Handoff

When the user next asks to implement, instruct them (and the next agent) to run `feature-developer` with `specPath` pointing at the PRD. If more than one architectural option is still open, run `decision-matrix-architect` first.

## Composition

- Downstream: `decision-matrix-architect`, `feature-developer`.
- Peer: `sec-analyzer-tester` may consume the PRD as the system description for threat modeling before code exists.
