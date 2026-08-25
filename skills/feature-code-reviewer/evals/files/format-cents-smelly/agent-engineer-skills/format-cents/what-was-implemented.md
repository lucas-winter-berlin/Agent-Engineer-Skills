# What was implemented

- Feature: `format-cents`
- Status: implemented
- Branch: `cursor/format-cents`
- Base branch: `main`
- Commit: `PLACEHOLDER`
- Built from: `agent-engineer-skills/format-cents/what-to-build.md`
- Date: 2026-08-24

## What I did

- Added a cents formatter and used it on the orders list.

## Why

- The specification required a helper next to the existing `src/` modules.

## Where

| Path | Change |
| --- | --- |
| src/money.js | create -- cents formatter |
| src/index.js | modify -- re-export |
| src/orders.js | modify -- format totals |

## How to try it

- From repo root: `node -e "console.log(require('./src/money').x(1234))"`

## Tests

- Command run: none in this repo
- Result: not-run, no test runner
- Already failing before this change: none

## Followed what-to-build

- Followed: yes
- Stopped to ask: none
- Did not implement (walls): CSV export, new pages, new packages
