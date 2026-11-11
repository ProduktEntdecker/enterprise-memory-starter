---
title: "Claude House wiki log"
type: log
status: living
created: 2026-09-20
updated: 2026-11-11
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

## [2026-11-11] review | gaps found after the run, left as the run wrote them

- A review of this copy found four places where the run reads more into the sources than they say, or leaves a step out. The pages stay as the run wrote them: this copy shows what one run produces, mistakes included.
  - [summaries/C01-programme-extract.md](summaries/C01-programme-extract.md), TL;DR: says the ambassadors run the programme on the lower two floors and the rooftop. C01 says the rooftop programme from 18:00 has a separate organiser, which FACTS.md row 7 records correctly.
  - [FACTS.md](FACTS.md) row 15: room capacity plus 20 percent is not a whole number for every room (Room 1: 16.8). No source says how to round, and the run did not flag it.
  - FACTS.md row 16: after requesting the event page, C03 also has the host send the link back. The row leaves that step out.
  - [Lint report](outputs/lint-2026-09-20.md), finding 2: states that Room 4 sessions are under-sold and cafeteria sessions over-sold. The sources give the formula and the capacities, not the cap or the sales of any event page, so this is a risk to check, not an observed fact.
- Lint report, notes: the line on `check_links.py` now says it describes the check at the time of the run. Since 2026-11-08 the global check also covers this copy.
