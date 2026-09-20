---
title: "Root map"
type: root-map
status: living
created: 2026-09-14
updated: 2026-09-14
---

# Root map

**Purpose:** The first file in every session: which store holds which kind of knowledge, and where to go next. Open the index of one store, then only the pages you need.

## Stores

| Store | Path | What it holds | Use it for |
|---|---|---|---|
| Sotarena project wiki | [projects/sotarena/wiki/index.md](projects/sotarena/wiki/index.md) | Compiled knowledge about Sotarena S.L. (fictional): people, suppliers, products, documents | Any question about the company |
| Canonical facts | [projects/sotarena/wiki/FACTS.md](projects/sotarena/wiki/FACTS.md) | One value per fact, with winning source, date and owner | Numbers, dates, prices, names in roles; read before answering |
| Inbox | [sources/inbox/](sources/inbox/) | Raw documents not yet ingested | Input for `/wiki-ingest` |
| Originals | [projects/sotarena/wiki/_originals/](projects/sotarena/wiki/_originals/) | Ingested documents, unchanged | Verifying a quote, nothing else |

## Out of scope for answers

- [company/COMPANY.md](company/COMPANY.md) describes the fictional scenario for humans. Do not use it to answer questions, to ingest or to lint.
- [docs/](docs/) holds the agenda, the demo script and prepared fallback outputs. It is not knowledge.

## Routes

- **Question about Sotarena:** project index, then FACTS.md, then one to three detail pages. Cite page paths and source IDs.
- **New document:** `/wiki-ingest sources/inbox/<file>.md`
- **Health check:** `/wiki-lint`
- **Rules for working here:** [CLAUDE.md](CLAUDE.md)
