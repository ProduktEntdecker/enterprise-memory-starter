---
title: "Claude House wiki"
type: index
status: living
created: 2026-09-20
updated: 2026-11-11
---

# Claude House wiki

> Up: [Root map](../../../root-map.md)

**Purpose:** Compiled, cited knowledge about the Claude Community House Barcelona, 21 to 24 September 2026: what runs when, which room holds how many people, and which rules a session host has to follow.

**Read first:** [FACTS.md](FACTS.md) holds one canonical value per fact. The pages below explain and cite; FACTS.md decides.

## Rollup

- **FACTS.md:** 20 canonical facts: dates, venue, room capacities, ticket rule, host process, API credits. One row is marked "needs decision", seven rows have no owner.
- **summaries/ (3):** one page per ingested document: programme extract, host rules, room capacities.
- **meetings/ (0):** call notes and minutes. None ingested yet.
- **entities/ (5):** the house itself and four rooms named in the sources.
- **outputs/ (1):** generated reports. Lint report of 2026-09-20 with 5 findings, none resolved.
- **log.md:** append-only record of the init run, the first lint and a rebuild on 2026-09-20, plus two entries for this committed copy: what changed when it was committed, and what a later review found.

## Links down

### Canonical and log

- [FACTS.md](FACTS.md): canonical fact sheet with winning source, date and owner per fact.
- [log.md](log.md): chronological log of ingests and lint runs.

### Summaries

- [C01 Programme extract](summaries/C01-programme-extract.md): dates, venue, sixteen ambassadors, Monday and Wednesday sessions, QR entry.
- [C02 Rooms and capacity](summaries/C02-rooms-and-capacity.md): seat counts of 2026-09-19 and the superseded list of 2026-08-22.
- [C03 Rules for session hosts](summaries/C03-house-rules.md): slot process, event page requirements, ticket cap, API credits.

### Meetings

None yet.

### Entities

Organisations:

- [Claude Community House Barcelona](entities/claude-community-house-barcelona.md): the house and its organisers.

Places:

- [Auditorium](entities/auditorium.md): 100 seats, level minus one.
- [Workshops area](entities/workshops-area.md): cafeteria, 96 seats, drop-in sessions.
- [Room 4](entities/room-4.md): 25 seats, raised from 20 in September.
- [Rooftop](entities/rooftop.md): separate organiser, hours contested.

### Outputs

- [Lint report 2026-09-20](outputs/lint-2026-09-20.md): 5 findings, 2 of them High: rooftop hours contested, ticket caps derived from superseded capacities.

## Raw stores

- **Inbox:** `examples/claude-house/sources/inbox/` holds documents that are not ingested yet. Run `/wiki-ingest <file>`. The run creates this folder, so a fresh clone does not have it.
- **Originals:** [_originals/](_originals/) holds every ingested document, unchanged. Never edit these files.

### Source register

| ID | Title | Type | Author | Source date | Ingested | Page | Original |
|---|---|---|---|---|---|---|---|
| C01 | Claude Community House Barcelona: public programme, extract | Programme page | House organisers | 2026-09-13 | 2026-09-20 | [summary](summaries/C01-programme-extract.md) | [original](_originals/C01-programme-extract.md) |
| C02 | Room list with seat counts | Backoffice export | Read from the planning backoffice | 2026-09-19 | 2026-09-20 | [summary](summaries/C02-rooms-and-capacity.md) | [original](_originals/C02-rooms-and-capacity.md) |
| C03 | Rules for session hosts | Organiser note | House organisers | 2026-09-13 | 2026-09-20 | [summary](summaries/C03-house-rules.md) | [original](_originals/C03-house-rules.md) |

The next free source ID is the highest ID in this register or in the inbox, plus one.
