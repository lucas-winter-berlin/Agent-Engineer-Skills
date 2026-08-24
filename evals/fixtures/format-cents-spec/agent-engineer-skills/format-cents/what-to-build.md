# Format cents helper

- Feature: `format-cents`
- Status: ready-for-developer
- Date: 2026-08-24
- Kind: library

`feature-developer` implements this file and nothing else.

## Problem

- Who: the Node helpers in `src/` (no new user role)
- What is wrong or missing: order totals are stored as integer cents but shown as a raw number
- Why it matters: the orders page and `homeSummary` should print money as dollars

## Questions and decisions

| Q | Asked because a wrong guess would... | Answer | Spec |
| --- | --- | --- | --- |
| Where does the helper live? | Put it on a page or in a new package | `src/money.js` next to the other helpers | Add `formatCents` in `src/money.js` and re-export it from `src/index.js` |
| What is the input? | Parse strings or floats | Integer cents only | `formatCents(cents)` takes a finite number of integer cents |
| What is the output? | Locale or currency codes | US dollar string | Return a dollar string with two fraction digits, for example 1234 -> $12.34 and 0 -> $0.00 |
| Who sees it? | Add auth | Existing signed-in customer path only | Do not add routes, pages, or auth. Callers are existing `src/` helpers |
| Invalid input? | Silent `NaN` | Throw | If `cents` is not a finite number, throw `TypeError` with message `cents must be a finite number` |
| Leave / cancel | N/A for a pure function | locked-default | No in-progress work. A throw is the only no-path |

## In scope

- `formatCents(cents)` in `src/money.js`
- Re-export from `src/index.js`
- Use `formatCents` when `src/orders.js` or `public/orders.html` displays a total (at least one call site)

## Out of scope (do not implement)

- CSV or other file export -- reject
- New pages, routes, or buttons -- reject
- New npm dependencies, test frameworks, or CI -- reject
- Multi-currency or locale formatting -- reject

## Behavior

- When `formatCents` is called with a finite number of cents, it returns a string starting with `$` and exactly two digits after the decimal point.
- When `formatCents` is called with a non-finite value, it throws `TypeError`.
- Entry points in / out: public function `formatCents` in `src/money.js` (in). No new HTTP routes, CLI commands, jobs, or pages (out).
- Leave / cancel / switch: none. This is a synchronous helper with no in-progress work.
- Failure: throw `TypeError` with message `cents must be a finite number`. Nothing is written.

## Done when

```text
Given a finite number 1234
When formatCents(1234) is called
Then the return value is the string $12.34

Given a finite number 0
When formatCents(0) is called
Then the return value is the string $0.00

Given a non-finite value such as NaN
When formatCents(NaN) is called
Then it throws TypeError with message cents must be a finite number
```

## Do not

- Add invoice CSV export, email, PDF, or a download button
- Add a test framework, CI workflow, or new npm package
