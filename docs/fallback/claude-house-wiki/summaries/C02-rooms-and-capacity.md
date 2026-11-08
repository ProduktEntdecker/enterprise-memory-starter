---
title: "C02 Rooms and capacity"
type: summary
status: draft
source_id: C02
source_type: backoffice export
author: "Read from the planning backoffice"
source_date: 2026-09-19
created: 2026-09-20
updated: 2026-09-20
---

# C02 Rooms and capacity

> Up: [Claude House wiki index](../index.md)

## TL;DR

Seat counts read from the planning backoffice on 2026-09-19: Workshops area 96, Room 1 14, Room 2 16, Room 3 20, Room 4 25, Auditorium 100. An earlier list from 2026-08-22 gave different numbers and is no longer valid. The rooftop carries no seat count and is marked as running 16:00 to 18:00, which contradicts the programme page C01.

## Key points

| Room | Seats | Note |
|---|---|---|
| [Workshops area](../entities/workshops-area.md) (cafeteria) | 96 | Ground floor, also used for drop-in sessions |
| Room 1 | 14 | |
| Room 2 | 16 | |
| Room 3 | 20 | |
| [Room 4](../entities/room-4.md) | 25 | Raised from 20 earlier in September |
| [Auditorium](../entities/auditorium.md) | 100 | Level minus one, seated |
| [Rooftop](../entities/rooftop.md) | n/a | Only 16:00 to 18:00, special activations |

- The list of 2026-08-22 is explicitly superseded: cafeteria 120, Room 1 and Room 2 twelve each, Room 3 fifteen, Room 4 twenty, Auditorium 100.
- Room 4 grew from 20 to 25 seats, the cafeteria shrank from 120 to 96.

## Entities

- [Workshops area](../entities/workshops-area.md), [Auditorium](../entities/auditorium.md), [Room 4](../entities/room-4.md), [Rooftop](../entities/rooftop.md).

## FACTS.md check

| Claim | Value in source | FACTS.md before ingest | Result | Decision |
|---|---|---|---|---|
| Capacity, Workshops area | 96 | not present | new | added as row 9, old value 120 to history |
| Capacity, Room 1 | 14 | not present | new | added as row 10, old value 12 to history |
| Capacity, Room 2 | 16 | not present | new | added as row 11, old value 12 to history |
| Capacity, Room 3 | 20 | not present | new | added as row 12, old value 15 to history |
| Capacity, Room 4 | 25 | not present | new | added as row 13, old value 20 to history |
| Capacity, Auditorium | 100 | not present | new | added as row 14, unchanged since 2026-08-22 |
| Rooftop hours | only 16:00 to 18:00 | row 8: from 18:00 (C01, 2026-09-13) | conflict | row 8 marked "needs decision", both values kept |

## Conflict with C01

The programme page says the rooftop programme runs **from 18:00** and is handled by a separate organiser. The backoffice says the rooftop is available **only 16:00 to 18:00**. C02 is six days newer, but it is authoritative for seat counts, not for a programme that the house does not run. Neither source replaces the other explicitly, so row 8 stays open until an organiser decides.

## Open questions

- Who owns the rooftop slot, and which of the two time windows is the one guests will see?
- The export names no person or role as the owner of the seat counts, only the backoffice system. Rows 9 to 14 therefore carry the owner "unassigned".
- Rooms 1, 2 and 3 have seats but no sessions in the programme extract C01.

## Source

- Original: [_originals/C02-rooms-and-capacity.md](../_originals/C02-rooms-and-capacity.md)
- Backoffice export, read on 2026-09-19.
