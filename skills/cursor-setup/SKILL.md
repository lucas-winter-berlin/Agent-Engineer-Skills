---
name: cursor-setup
description: >-
  Analyzes a project's stack and structure, then writes a compact .cursorrules
  and a .cursorignore that drop dependencies, build output, caches, lockfiles,
  and large assets so Cursor indexes less and prompts stay focused. Use when
  initializing or setting up a project in Cursor, when the user asks to
  generate or optimize .cursorrules or .cursorignore, or when Cursor token use
  is high and context should be narrowed. Do not use for product specification
  (feature-specifier), defect analysis (feature-bug-analyst), implementing a
  specification (feature-developer), code review (feature-code-reviewer),
  verification (feature-tester), restructuring a module (feature-refactorer),
  MVP or greenfield design (mvp-specifier), or installing this pack.
compatibility: >-
  Works in any Agent Skills host. Reads the repo. Writes .cursorignore and
  either .cursorrules or one file under .cursor/rules/. Does not edit product
  source.
license: PolyForm Noncommercial License 1.0.0
metadata:
  author: Lucas Winter
  version: "1.0"
  family: feature-builder
---

# cursor-setup

This skill analyzes the project context and generates optimized `.cursorrules` and `.cursorignore` files to reduce token consumption and keep LLM context focused.

For root path resolution, shell behavior, and global standards, see `AGENTS.md`.

Do not write product code. Do not write a feature-folder specification.

## When to use

- When initializing or setting up a project in Cursor
- When the user asks to generate `.cursorrules` or `.cursorignore`
- When token consumption in Cursor is high and context needs optimization

If the request is a different job (new product, a defect, implement, review, test, refactor, MVP, or pack install), name that skill and stop. Do not start it.

## Outputs

- `.cursorignore` at the project root, from [assets/cursorignore.md](assets/cursorignore.md).
- Rules from [assets/cursorrules.md](assets/cursorrules.md). If `.cursor/rules/` already exists and `.cursorrules` does not, write `.cursor/rules/project.mdc` with the template body plus this frontmatter:

```yaml
---
description: Project stack, conventions, and edit guardrails for Cursor.
alwaysApply: true
---
```

Otherwise write `.cursorrules` at the project root. Do not write both rule files.

## How (mandatory order)

1. Announce `Using skill: cursor-setup`.
2. **Analyze project context.** Inspect existing project structure, dependencies (`package.json`, `requirements.txt`, `pyproject.toml`, `Cargo.toml`, `go.mod`, and the same kind of manifest when one is present), frameworks, and coding standards. Identify build output folders, log directories, coverage reports, large assets, and generated files. Name a stack fact only when a file you opened supports it. Otherwise write `unknown`.
3. **Generate `.cursorignore`.** Create `.cursorignore` in the project root to exclude noisy and irrelevant files from being indexed or scanned by Cursor. Always include the standard exclusions in the template:
   - Dependency directories (`node_modules/`, `vendor/`, `.venv/`, `venv/`)
   - Build artifacts (`dist/`, `build/`, `.next/`, `.out/`, `target/`)
   - Caches and logs (`.cache/`, `*.log`, `__pycache__/`, `.pytest_cache/`)
   - Lockfiles and large asset dumps (`package-lock.json`, `pnpm-lock.yaml`, `yarn.lock`, `*.svg`, `*.png`, `*.mp4`)
   - Test coverage reports (`coverage/`, `.coverage`)
   Replace `{{PROJECT_PATHS}}` with one path per line for directories you actually found, or delete the `Project-specific` heading and that placeholder when there are none. If `.cursorignore` already exists, keep its lines and add any missing standard or project lines. Do not delete existing entries.
4. **Generate `.cursorrules`.** Create a compact, highly structured rules file. Keep it concise to minimize per-prompt token overhead. Fill only these sections:
   - **Tech Stack & Environment:** High-level frameworks, language versions, and strict settings.
   - **Architecture & Conventions:** Folder conventions, state management, API patterns.
   - **Code Style & Guardrails:** Specific do's and don'ts grounded in this repo (for example strict typing when the repo uses it, no legacy import style the repo already forbids, prefer modular components when the UI is component-based).
   - **Token & File Operations:** Instruct the agent to confirm before creating new files and focus edits strictly on specified files.
   If the rules file already exists, keep its project rules and add any missing section. Do not delete existing rules.
5. **Check** both files against every line of `Before you finish`. Fix what fails, then check again.
6. **Review and confirm.** Present the rules file and `.cursorignore` briefly. State the paths. `.cursorignore` is at the project root. The rules file is `.cursorrules` at the project root, or `.cursor/rules/project.mdc` when that is the file this skill wrote.

## Before you finish

- [ ] `Using skill: cursor-setup` was announced.
- [ ] `.cursorignore` is at the project root and contains every standard exclusion in the template.
- [ ] Rules are either `.cursorrules` at the project root or `.cursor/rules/project.mdc`, not both.
- [ ] Rules include `## Tech Stack & Environment`, `## Architecture & Conventions`, `## Code Style & Guardrails`, and `## Token & File Operations`.
- [ ] Token & File Operations tells the agent to confirm before creating new files and to focus edits strictly on specified files.
- [ ] Stack and convention lines match files you opened, or say `unknown`. No invented framework, version, or folder.
- [ ] Project-specific ignore lines are paths you found. No guessed dump directories.
- [ ] No `{{placeholder}}` left in either file.
- [ ] No icons or emojis.
- [ ] Product source, manifests, and tests are unchanged.
- [ ] No `what-to-build.md` or other feature-folder write-up.

## Do not

1. Start another skill unless the operator named it.
2. Edit product source, add dependencies, or reformat the tree.
3. Invent a feature, a fix, or a review while setting up Cursor.
4. Omit a standard exclusion because this repo does not use that tool.
5. Put secrets in either file.
