# Clarification Log

- Feature (working title): {{TITLE}}
- Feature name (if known): {{FEATURE_NAME}}
- Round: {{1 | 2}}
- Status: {{open | closed}}

## Ambiguity scan

| Gap class | Known | Blocking | Evidence |
| --- | --- | --- | --- |
| Actor | {{TEXT or unknown}} | {{yes|no}} | {{USER MESSAGE / DOC PATH}} |
| Problem | {{TEXT or unknown}} | {{yes|no}} | {{EVIDENCE}} |
| Success metric | {{TEXT or unknown}} | {{yes|no}} | {{EVIDENCE}} |
| Constraints | {{TEXT or unknown}} | {{yes|no}} | {{EVIDENCE}} |
| Data | {{TEXT or unknown}} | {{yes|no}} | {{EVIDENCE}} |
| Channel | {{TEXT or unknown}} | {{yes|no}} | {{EVIDENCE}} |
| Non-functionals | {{TEXT or unknown}} | {{yes|no}} | {{EVIDENCE}} |
| Exclusions | {{TEXT or unknown}} | {{yes|no}} | {{EVIDENCE}} |

If all blocking columns are `no`, record:

```text
clarification round skipped: request already unambiguous
```

## Questions (maximum 5)

Ask only blocking gaps. Prefer enumerated options.

### Q1

- Gap class: {{CLASS}}
- Question: {{QUESTION}}
- Options: {{A}} / {{B}} / {{C}} / Other
- Answer (verbatim): {{ANSWER or empty}}
- Status: {{asked | answered | converted-to-assumption}}
- Assumption id if converted: {{ASM-### or n/a}}

### Q2

- Gap class: {{CLASS}}
- Question: {{QUESTION}}
- Options: {{A}} / {{B}} / {{C}} / Other
- Answer (verbatim): {{ANSWER or empty}}
- Status: {{asked | answered | converted-to-assumption}}
- Assumption id if converted: {{ASM-### or n/a}}

### Q3

- Gap class: {{CLASS}}
- Question: {{QUESTION}}
- Options: {{A}} / {{B}} / {{C}} / Other
- Answer (verbatim): {{ANSWER or empty}}
- Status: {{asked | answered | converted-to-assumption}}
- Assumption id if converted: {{ASM-### or n/a}}

### Q4 (optional)

- Gap class: {{CLASS}}
- Question: {{QUESTION}}
- Options: {{A}} / {{B}} / {{C}} / Other
- Answer (verbatim): {{ANSWER or empty}}
- Status: {{asked | answered | converted-to-assumption | unused}}
- Assumption id if converted: {{ASM-### or n/a}}

### Q5 (optional)

- Gap class: {{CLASS}}
- Question: {{QUESTION}}
- Options: {{A}} / {{B}} / {{C}} / Other
- Answer (verbatim): {{ANSWER or empty}}
- Status: {{asked | answered | converted-to-assumption | unused}}
- Assumption id if converted: {{ASM-### or n/a}}

## Scope expansion watch

If an answer adds work not present in the original request, record it here and do not place it In-Scope until the user confirms.

| Answer | Added work | User confirmed (`yes` / `no` / `pending`) |
| --- | --- | --- |
| {{Q#}} | {{WORK}} | {{STATUS}} |

## Closure

- Questions asked: {{N}} (must be <= 5)
- Answered: {{N}}
- Converted to assumptions: {{N}}
- Ready for PRD synthesis: {{yes | no}}
