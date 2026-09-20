> **PREPARED OUTPUT, not a live result.** This is the page that a correct run of `/wiki-ingest sources/inbox/S06-talaverna-call-note.md` writes to `projects/sotarena/wiki/meetings/S06-talaverna-call-note.md`, prepared as a stage fallback. Paths are shown as code because they are relative to that location.

# S06 Call with Talaverna Hotels

> Up: Sotarena wiki index (`../index.md`)

## TL;DR

Talaverna Hotels needs 60 Garbí sets for the new rooftop bar at its Palma hotel, which opens on 2026-10-30. In the call on 2026-09-10, Andreu Font told the customer that the standard lead time is 4 weeks; FACTS.md row 1 says 6 weeks from order confirmation (S04, owner Head of Operations). The quote was due by 2026-09-14.

## Key points

- Contact: Beatriz Lozano, Director of Purchasing, Talaverna Hotels.
- Talaverna runs 14 hotels; revenue with Sotarena in 2025 was EUR 1.9 million.
- The new rooftop bar at the Palma hotel opens on 2026-10-30.
- Talaverna needs 60 Garbí sets, each set 1 table and 2 armchairs.
- Andreu Font told the customer: "standard lead time is 4 weeks".
- Next step in the note: send the quote by 2026-09-14.

## Notable quotes

> "standard lead time is 4 weeks"

## Entities

- Talaverna Hotels (new): `../entities/talaverna-hotels.md`
- Andreu Font, Key Account Manager Iberia, author (new): `../entities/andreu-font.md`
- Garbí (updated): `../entities/garbi.md`

## FACTS.md check

| Claim | Value in source | FACTS.md before ingest | Result | Decision |
|---|---|---|---|---|
| Standard lead time, stock colours | 4 weeks, stated to the customer | row 1: 6 weeks from order confirmation (S04, 2026-08-03, owner Head of Operations) | conflict | no change: S06 is newer, but not from the owner and does not replace S04 |
| Talaverna Palma rooftop | 60 Garbí sets (1 table and 2 armchairs each), opening 2026-10-30 | not present | new | added as row 27 (approved) |
| Talaverna Hotels revenue 2025 | EUR 1.9 million | not present | new | added as row 28 (approved) |

## Conflicts

- **Standard lead time:** 4 weeks (S06, 2026-09-10) against 6 weeks (FACTS.md row 1, S04, 2026-08-03). The Head of Operations owns this fact. Not resolved here; run `/wiki-lint`.

## Open questions

- Was the quote sent by 2026-09-14, and which lead time does it state?
- With 6 weeks from order confirmation, what is the latest order date for delivery before the opening on 2026-10-30?

## Source

- Original: `../_originals/S06-talaverna-call-note.md`
- Sales call note (CRM) by Andreu Font, Key Account Manager Iberia, dated 2026-09-10.

## Frontmatter of the real page

```yaml
title: "S06 Call with Talaverna Hotels"
type: meeting
status: draft
source_id: S06
source_type: sales call note (CRM)
author: "Andreu Font, Key Account Manager Iberia"
source_date: 2026-09-10
created: 2026-09-21
updated: 2026-09-21
```
