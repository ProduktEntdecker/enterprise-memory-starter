---
title: "Canonical fact"
type: concept
status: reviewed
created: 2026-09-14
updated: 2026-09-14
---

# Canonical fact

> Up: [Global wiki index](../index.md)

**In one sentence:** A canonical fact is the single value an organisation agrees to use for a number, date, price or name in a role, stored once with its winning source, source date and owner.

## Why it matters

Knowledge drifts. A price list, a sales call note and an operations memo can each state a different value for the same thing. People and agents that take the most similar or the newest text repeat whichever version they found first. A fact sheet ends that: every answer, quote and slide takes the value from one place.

## Anatomy of a row

| Column | Meaning |
|---|---|
| Fact | Short name of the subject, stable over time |
| Value | The value to use, with unit |
| Winning source | Source ID, linked to its summary page |
| Source date | ISO date of the winning source |
| Owner | The role that decides when sources disagree |

The fact sheet of the example project is [FACTS.md](../../projects/sotarena/wiki/FACTS.md).

## How a value may change

A value changes only when all three conditions hold:

1. **Newer:** a source with a later date states a different value.
2. **Authoritative:** that source comes from the owner of the fact, or it explicitly replaces the older statement (a succession announcement, a new price list).
3. **Approved:** a human says yes. Ingest proposes, lint reports, nobody overwrites silently.

The old value moves to the history table, with the date it stopped being valid.

## Contradiction or stale fact?

| Situation | Kind | What to do |
|---|---|---|
| A newer source from the owner, or one that explicitly replaces the old statement, states a different value | Stale fact | Propose the update; keep the old value in the history table |
| A newer source that is not from the owner and does not replace the old statement states a different value | Contradiction | Keep the canonical value, flag the conflict, let the owner decide |
| A source states the same value | Confirmation | Nothing to change |

**Newest is not always right.** A sales note that quotes a shorter lead time does not change the lead time that operations sets.

## Pitfalls

- **One real-world thing, two pages.** A supplier written with and without a hyphen, or with and without its legal form, splits its facts across two entity pages. Lint looks for near-identical names.
- **Facts without an owner** turn every conflict into a debate.
- **A fact sheet nobody reads first** is decoration. The rules in [CLAUDE.md](../../CLAUDE.md) make Claude read it before answering.

## Related

- [Ingest](ingest.md), [Lint](lint.md), [Progressive loading](progressive-loading.md)
