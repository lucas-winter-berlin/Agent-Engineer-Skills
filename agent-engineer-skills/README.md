# Feature-folder write-ups

Markdown for one change lives in this folder, under `<feature-name>/`.

`<root>` is this directory after a default install. If install used a custom folder, that folder is `<root>` and this README is copied there.

| File | Who writes it | Job |
| --- | --- | --- |
| `what-to-build.md` | `feature-specifier`, `feature-bug-analyst`, or `mvp-specifier` | The specification. Later skills may not build a different product. |
| `what-was-implemented.md` | `feature-developer` | What was built, on which branch. |
| `what-was-reviewed.md` | `feature-code-reviewer` | Maintainability verdict on a feature diff. |
| `what-was-verified.md` | `feature-tester` | Whether the feature matches the specification. |
| `what-was-refactored.md` | `feature-refactorer` | Behavior-preserving restructure of existing code. No `what-to-build.md`. |

One name, one subfolder. Do not create both `agent-engineer-skills/<name>/` and `docs/features/<name>/` for the same change. `concept.md` is the old filename for `what-to-build.md`; always write `what-to-build.md`.
