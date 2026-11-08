---
title: "Claude House wiki log"
type: log
status: living
created: 2026-09-20
updated: 2026-11-08
---

# Claude House wiki log

> Up: [Claude House wiki index](index.md)

**Purpose:** Append-only record of what happened to this wiki and when. New entries go at the bottom. Every entry starts with `## [YYYY-MM-DD] operation | subject`, so `grep "^## \[" log.md | tail -5` lists the last five.

## [2026-09-20] init | Claude House wiki created

- Folders created: entities/, meetings/, summaries/, outputs/, _originals/, and sources/inbox/ next to the wiki.
- FACTS.md, index.md and log.md created.
- Three sources ingested in one batch, oldest first, approved as a whole run.

## [2026-09-20] ingest | C01 Programme extract

- Page: [summaries/C01-programme-extract.md](summaries/C01-programme-extract.md)
- Entities created: Claude Community House Barcelona, Auditorium, Workshops area, Room 4, Rooftop.
- FACTS.md: 8 facts added (rows 1 to 8): dates, venue, floors, ambassadors, status, entry, rooftop ownership, rooftop hours.

## [2026-09-20] ingest | C03 Rules for session hosts

- Page: [summaries/C03-house-rules.md](summaries/C03-house-rules.md)
- Entities updated: Claude Community House Barcelona.
- FACTS.md: 6 facts added (rows 15 to 20): ticket cap, slot claiming, event page requirements, sessions per ambassador, API credit value and redemption.

## [2026-09-20] ingest | C02 Rooms and capacity

- Page: [summaries/C02-rooms-and-capacity.md](summaries/C02-rooms-and-capacity.md)
- Entities updated: Auditorium, Workshops area, Room 4, Rooftop.
- FACTS.md: 6 capacity facts added (rows 9 to 14). 5 superseded values from the room list of 2026-08-22 moved to the history table.
- Conflict: rooftop hours against C01. Row 8 marked "needs decision", both values kept.

## [2026-09-20] lint | 5 findings

- Report: [outputs/lint-2026-09-20.md](outputs/lint-2026-09-20.md)
- Findings: contradiction, rooftop hours (High); stale fact, ticket caps from superseded capacities (High); 7 FACTS.md rows without an owner (Medium); gap, number of API credit redemptions (Medium); gap, the three co-host organisers are not named (Low).
- No content changed.

## [2026-09-20] rebuild | wiki recreated after a repository reset

- The working tree was reset and cleaned while the session was running, which removed this wiki and returned the three sources to `examples/claude-house/sources/`.
- All 12 pages were rewritten from the same three sources, with the same facts, the same conflict and the same lint report.
- No source was edited. The originals were moved to `_originals/` again.

## [2026-11-08] maintenance | copy committed as one possible result

- This wiki was copied from `examples/claude-house/wiki/` to `docs/fallback/claude-house-wiki/` as one possible result of `/wiki-init examples/claude-house`.
- Left out `entities/house-organisers.md`. It was not part of this run: the entries above list five entities, and the page cited row numbers that do not match this FACTS.md.
- index.md: the inbox is named as a path, not linked, because the run creates that folder and a fresh clone does not have it.
- Lint report: the count of pages linked from index.md corrected from 9 to 11.
- No fact, source or finding changed.
