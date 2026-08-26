# {{TITLE}}

- Feature: `{{FEATURE_NAME}}`
- Status: {{awaiting-questions | draft | ready-for-developer}}
- Date: {{DATE}}
- Kind: {{UI | API | CLI | job | library | mixed}}

`feature-developer` implements this file and nothing else. Run it in a new Agent chat (Goldfish). Do not use other chat context.

This file is the complete v1 design and the only input the implementer gets.

## Concept

- What this is: {{one or two sentences}}
- Who it is for: {{actors}}
- What v1 must prove: {{the demo or MVP outcome}}
- Why this cut: {{why later ideas are out}}

## Prototype cut

- v1 (build): {{what ships now}}
- Later (do not build): {{defer}}

## Users, access, and rights

- Roles: {{who exists in v1}}
- Access: {{what each role may see and do; public vs gated}}
- Data we keep: {{minimum fields}}
- Data we refuse: {{what we do not collect}}
- Where it lives: {{device, LAN, disk, no cloud, ...}}
- Product rules: {{privacy and access rules; not legal advice}}

## Architecture

- Shape: {{clients, process, store, session, network}}
- How they connect: {{e.g. phone and TV hit the same local server; PIN cookie on staff routes}}
- Stack: {{locked stack, or use the stack already in this workspace}}

## Data

| Entity | Fields | States / rules |
| --- | --- | --- |
| {{entity}} | {{fields}} | {{states}} |
| {{entity}} | {{fields}} | {{states}} |

## Screens and UI

### {{Screen name}} (`{{path or entry}}`)

- Purpose: {{why this screen exists}}
- On screen: {{what the user sees; main controls}}
- Empty: {{plain text, not a spinner forever}}
- Error: {{what they see}}
- Success: {{what they see, if any}}

### {{Screen name}} (`{{path or entry}}`)

- Purpose: {{why this screen exists}}
- On screen: {{what the user sees; main controls}}
- Empty: {{plain text, not a spinner forever}}
- Error: {{what they see}}
- Success: {{what they see, if any}}

## Functions

| Function | Who | Input | Result |
| --- | --- | --- | --- |
| {{Check in / Call next / ...}} | {{role}} | {{fields}} | {{what is stored or shown}} |
| {{Check in / Call next / ...}} | {{role}} | {{fields}} | {{what is stored or shown}} |

## APIs or server operations

| Operation | Auth | Input | Result |
| --- | --- | --- | --- |
| {{method and path, or server action}} | {{none / PIN session}} | {{body or args}} | {{data or error}} |
| {{method and path, or server action}} | {{none / PIN session}} | {{body or args}} | {{data or error}} |

## Decisions

| Q | Asked because a wrong guess would... | Answer | Spec |
| --- | --- | --- | --- |
| {{question}} | {{waste}} | {{verbatim answer, or locked-default}} | {{what the developer must do}} |
| {{question}} | {{waste}} | {{verbatim answer, or locked-default}} | {{what the developer must do}} |

## Out of scope (do not implement)

- {{item}} -- {{reject | defer}}

## Done when

```text
Happy path
Given {{setup}}
When {{the action this v1 exists to prove}}
Then {{observable result}}
```

```text
The important no-path
Given {{setup}}
When {{the refusal, the empty case, or the wrong person}}
Then {{what they see instead}}
```

```text
Leave or cancel
Given {{setup, mid-flow}}
When {{they back out, close, or refresh}}
Then {{what is kept and what is discarded}}
```

## Do not

- {{wrong product the Goldfish might invent}}
