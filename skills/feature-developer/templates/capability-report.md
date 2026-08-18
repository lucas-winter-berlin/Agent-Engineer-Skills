# Capability Report

- Feature (if known): {{FEATURE_NAME}}
- Generated at: {{TIMESTAMP}}
- Agent runtime: {{RUNTIME}}
- Workspace root: {{WORKSPACE_ROOT}}
- Confidence: {{high | medium | low}}

## Summary

{{One paragraph: languages, test command, CI vendor, linters, docs layout. No speculation presented as fact.}}

## Language and package management

| Signal | Status (`present` / `absent` / `unknown`) | Evidence paths | Notes |
| --- | --- | --- | --- |
| Primary language | {{STATUS}} | {{PATHS}} | {{NOTES}} |
| Package manager | {{STATUS}} | {{PATHS}} | {{NOTES}} |
| Additional languages | {{STATUS}} | {{PATHS}} | {{NOTES}} |

## Test framework

| Field | Value |
| --- | --- |
| Status | {{present | absent | unknown}} |
| Framework | {{jest | vitest | pytest | go test | JUnit | other | n/a}} |
| Exact test command | {{COMMAND or n/a}} |
| Evidence | {{PATHS}} |
| `tests.automated` | {{true | false}} |

If `tests.automated` is false, Phase 4 still writes tests. Phase 7 uses manual QA unless CI independently runs tests.

## Linters, formatters, and type checkers

| Tool | Status | Config path | Runs locally | Runs in CI | Blocking |
| --- | --- | --- | --- | --- | --- |
| {{TOOL}} | {{STATUS}} | {{PATH}} | {{yes | no | unknown}} | {{yes | no | unknown}} | {{yes | no}} |

`lint.blocking`: {{true | false}}

## CI/CD

| Field | Value |
| --- | --- |
| Status | {{present | absent | unknown}} |
| Vendor | {{github-actions | gitlab-ci | jenkins | azure-pipelines | circleci | bitbucket | other | n/a}} |
| Config paths | {{PATHS}} |
| Jobs (lint / test / build / security) | {{JOB NAMES or n/a}} |
| Agent can trigger | {{yes | no | unknown}} |
| `ci.present` | {{true | false}} |

## Security scanners

| Scanner | Status | Evidence | Notes |
| --- | --- | --- | --- |
| {{SCANNER}} | {{STATUS}} | {{PATHS}} | {{NOTES}} |

Scanners inform Phase 5. They do not replace STRIDE.

## Infrastructure and delivery

| Signal | Status | Evidence | Trust-boundary impact |
| --- | --- | --- | --- |
| Containers | {{STATUS}} | {{PATHS}} | {{NOTES}} |
| IaC | {{STATUS}} | {{PATHS}} | {{NOTES}} |
| Kubernetes / Helm | {{STATUS}} | {{PATHS}} | {{NOTES}} |

## Documentation layout

| Signal | Status | Evidence |
| --- | --- | --- |
| `docs/` | {{STATUS}} | {{PATHS}} |
| `docs/features/` | {{STATUS}} | {{PATHS}} |
| ADR directory | {{STATUS}} | {{PATHS}} |
| API spec (OpenAPI/AsyncAPI) | {{STATUS}} | {{PATHS}} |
| Global architecture doc | {{STATUS}} | {{PATHS}} |

## Instruction conflicts

| Source | Conflict with this skill | Resolution applied |
| --- | --- | --- |
| {{PATH or n/a}} | {{DESCRIPTION or n/a}} | {{security-policy-wins | this-skill-phase-order | style-of-consuming-project}} |

## Adaptive flags (locked for this run)

```text
tests.automated={{true|false}}
ci.present={{true|false}}
lint.blocking={{true|false}}
verificationMode={{ci|manual-qa|unverified-local}}
```

## Missing signals

List every `unknown` with the reason (workspace excerpt incomplete, encrypted file, generated path ignored).

{{MISSING_SIGNAL_LIST_OR_N/A}}

## Prohibitions observed

- No installs were performed during discovery: {{yes | no, with justification}}
- No lockfile mutations: {{yes | no}}
- No README-only claims recorded as `present`: {{yes | no}}
