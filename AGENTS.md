# Agent Engineer Skills

This repo uses Agent Engineer Skills. Each skill is a named job. `Use skill: <id>` runs only that job.

Skill packages live once, at `skills/<id>/` (`SKILL.md` plus `assets/`). Family (`feature-builder` or `mvp-builder`) is a README grouping and `metadata.family`, not a folder.

When this pack is installed into an app, copy those leaves (no `evals/`) into the host discovery folders. Do not keep a third copy under the app's `skills/`.

| Host | App discovery path |
| --- | --- |
| Cursor | `.cursor/skills/<id>/` |
| Antigravity | `.agents/skills/<id>/` (legacy `.agent/skills/<id>/` also accepted) |

Feature-folder write-ups live under agent-engineer-skills/<name>/.
