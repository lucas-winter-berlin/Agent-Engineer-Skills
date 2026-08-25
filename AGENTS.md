# Agent Engineer Skills

This repo uses Agent Engineer Skills. Each skill is a named job. `Use skill: <id>` runs only that job.

Canonical skill packages live at `skills/<id>/` (`SKILL.md` plus `assets/`). Family (`feature-builder` or `mvp-builder`) is a README grouping and `metadata.family`, not a folder.

| Host | Discovery path (copy of the leaf, no `evals/`) |
| --- | --- |
| Cursor | `.cursor/skills/<id>/` |
| Antigravity | `.agents/skills/<id>/` (legacy `.agent/skills/<id>/` also accepted) |

After editing a canonical skill, run `scripts/sync-host-skills.ps1` so both host copies match.

Feature-folder write-ups live under agent-engineer-skills/<name>/.
