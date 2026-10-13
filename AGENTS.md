# Agent Engineer Skills

This repo uses Agent Engineer Skills. Each skill is a named job. `Use skill: <id>` runs only that job.

Skill packages live once, at `skills/<id>/` (`SKILL.md` plus `assets/`). Family (`feature-builder` or `mvp-builder`) is a README grouping and `metadata.family`, not a folder.

When this pack is installed into an app, copy those leaves (no `evals/`) into the host discovery folders. Do not keep a third copy under the app's `skills/`.

| Host | App discovery path |
| --- | --- |
| Cursor | `.cursor/skills/<id>/` |
| Antigravity | `.agents/skills/<id>/` (legacy `.agent/skills/<id>/` also accepted) |

Feature-folder write-ups live under agent-engineer-skills/<name>/.

## Global standards

Skills are host-agnostic Markdown. The same `SKILL.md` runs in Cursor and in Antigravity. Do not put host-only syntax in a skill.

### Write-up root

`<root>` is the docs **directory** named on the Feature-folder write-ups line in this file. If that line is missing, use the same line in `.cursor/rules/agent-engineer-skills.mdc`. If both are missing, `<root>` is `agent-engineer-skills`.

Create `<root>` as a folder when a skill must write. Never create or read a file named `aes-write-up-root`.

Write `<root>/<kebab-name>/<artifact>`. If `docs/features/<kebab-name>/` already exists for that name and `<root>/<kebab-name>/` does not, write in the old folder instead. Never create both trees for one name. Write the skill's artifact next to the specification you used.

`concept.md` is the old filename for `what-to-build.md`. Always write `what-to-build.md`. Never create `concept.md`. If `concept.md` already exists, treat it as `what-to-build.md`.

### Shell

Windows PowerShell 5.1 has no `&&` operator, so joined commands fail there. PowerShell 7 and POSIX shells accept it. When the shell is unknown, run commands one per call.

### Artifacts

English. No icons or emojis. No secrets in write-ups, source, or commit messages.
