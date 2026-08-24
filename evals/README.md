# Evals

Two loops. Trigger evals ask whether a skill **loads**. Quality evals ask whether it **does the job** after you edit `SKILL.md`.

Train/validation splits belong only to trigger evals. Do not reuse them for quality evals.

## Trigger evals

A skill only helps if it loads. The `description` in `SKILL.md` is the only thing an agent sees before deciding, so these evals measure one thing: **does each skill trigger on the prompts it should, and stay quiet on the ones it should not.**

The four `feature-builder` skills share almost all their vocabulary (feature, spec, build, review, test, verify), which makes them each other's worst near-misses. `mvp-specifier` adds a fifth set, because the line between "a new thing" and "a feature in an existing thing" is exactly where it and `feature-specifier` steal each other's prompts. That is what these query sets are built to catch.

## Layout

| Path | What |
| --- | --- |
| `queries/<skill>.json` | 20 labelled prompts for one skill |
| `run-trigger-eval.ps1` | Runner. Reports a trigger rate per query |

Each query carries `should_trigger` and a fixed `split`:

- **train** (12 per skill) drives your edits.
- **validation** (8 per skill) is held back. Only look at it to check that an edit generalised.

Keep the split fixed across iterations, or you lose the ability to tell improvement from overfitting.

## Running

The runner needs an agent command, because how you invoke an agent and see which skills it loaded differs by client. The contract is two lines:

1. Read the prompt from the `AES_EVAL_QUERY` environment variable.
2. Print the agent's transcript, including loaded skills, to stdout.

Detection is a substring match for the skill name in that output, so the command has to print enough for the name to appear.

```powershell
cd evals

./run-trigger-eval.ps1 `
    -QueriesFile ./queries/feature-tester.json `
    -AgentCommand 'cursor-agent -p $env:AES_EVAL_QUERY' `
    -Split train `
    -OutFile ./results/feature-tester-train.json
```

Wrap `-AgentCommand` in single quotes so `$env:AES_EVAL_QUERY` is expanded when the runner invokes it, not when you type it. Verify the command on its own once before running 60 invocations through it.

If your client emits structured output, pipe it through a filter that prints the skill names, for example a `jq` expression over a JSON transcript. Anything that puts the skill name on stdout when the skill loads will work.

## Reading the result

The runner prints a pass rate plus two counts that tell you which way to edit:

- **Missed triggers** are should-trigger queries that did not fire. The description is too narrow. Broaden the scope, or add context about when the skill applies.
- **False triggers** are should-not-trigger queries that fired. The description is too broad. Sharpen the boundary against the adjacent skill.

## The loop

1. Run **train** and **validation**. Train guides the edits; validation is the honest score.
2. Look only at train failures. Keep validation results out of the editing process.
3. Rewrite the `description`. Address the general category a failure represents, not the specific words in it, or you will overfit to these twenty prompts. Stay under the 1024-character limit.
4. Repeat. Five iterations is usually enough. If nothing is improving, try a structurally different description rather than another tweak.
5. Pick the iteration with the best **validation** pass rate. That is often not the last one you wrote.

If results stay bad across several structurally different descriptions, suspect the queries rather than the description: too easy, too hard, or mislabelled.

## Adding queries

Aim for prompts where the skill would help but the connection is not obvious. If a query already asks for exactly what the skill does, any reasonable description passes it and you have learned nothing.

Good negatives are near-misses that share keywords but need a different skill. `review the product requirements` is a useful negative for `feature-code-reviewer`; `what is the weather` is not.

Mix formal and casual phrasing, include typos and abbreviations, and add realistic context such as file paths, ticket references, and backstory. Real prompts are messier than test prompts.

After changing a description, sanity-check it with 5 to 10 fresh prompts that were never part of the optimisation. Those give you an honest read on whether it generalises.

## Quality evals

After you edit a `SKILL.md`, run the quality runner. It executes realistic prompts in an isolated fixture and grades `Before you finish` checks. The default baseline is the previous skill snapshot (`old_skill`), not an unguided agent.

Layout follows [evaluating-skills](https://agentskills.io/skill-creation/evaluating-skills): `evals.json` lives in the skill folder; run output goes under `evals/workspaces/<skill>/iteration-N/`.

| Path | What |
| --- | --- |
| `skills/<family>/<id>/evals/evals.json` | Cases: prompt, expected output, fixture, optional replies, checks |
| `skills/<family>/<id>/evals/files/` | Skill-local overlays copied onto the fixture (planted code) |
| `evals/fixtures/` | Shared toy apps (`toy-web`, `greenfield`) and shared overlays (`format-cents-spec`) |
| `evals/run-quality-eval.ps1` | Runner and grader |
| `evals/workspaces/` | Gitignored run output |

Each eval directory contains `with_skill/` and, when a baseline exists, `old_skill/`, with `outputs/`, `timing.json`, and `grading.json`. The iteration folder also has `benchmark.json`.

### Running

```powershell
cd evals

# Schema and overlay paths only (no agent)
./run-quality-eval.ps1 -Skill all -ValidateOnly

# After editing SKILL.md (working tree dirty vs HEAD)
./run-quality-eval.ps1 -Skill feature-specifier

# After the edit is already committed
./run-quality-eval.ps1 -Skill feature-specifier -BaselineCommit HEAD~1

# Current skill only, no comparison
./run-quality-eval.ps1 -Skill feature-developer -SkipBaseline
```

`-Skill all` runs every skill. `-EvalName fuzzy-csv-export-ask` runs one case. The runner calls `cursor-agent -p --force --trust --workspace <fixture>`. It does not install a CI job.

### Reading benchmark.json

`run_summary.with_skill.pass_rate.mean` is the current skill. `old_skill` is the snapshot. `delta.pass_rate` is current minus baseline. The script exits non-zero if any `with_skill` **must** check failed, or if the current mean pass rate is worse than the baseline.

`total_tokens` is filled only when the agent JSON exposes it; otherwise it is null. Wall-clock time is always recorded.

### Adding cases

Start with 2-3 prompts per skill. Vary phrasing. Include one edge (refuse the wrong sibling skill, missing spec, no test runner). Checks should be things a script can fail: file exists, Status/Verdict enum, template headings, no emoji, no `concept.md`, git branch rules. Do not copy skill `evals/` folders into a consuming app.
