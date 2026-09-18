---
title: "Ingest"
type: concept
status: reviewed
created: 2026-09-14
updated: 2026-09-14
---

# Ingest

> Up: [Global wiki index](../index.md)

**In one sentence:** Ingest turns one raw document into cited wiki knowledge (a summary page, updated entity pages, index and log entries, and proposals for the fact sheet) while the original stays unchanged.

## The flow

1. Put the document into `sources/inbox/` as a markdown file.
2. Run `/wiki-ingest sources/inbox/<file>.md`.
3. Claude reads the source completely, then the target index, FACTS.md and the end of the log.
4. Claude writes one page: `summaries/` for documents, `meetings/` for call notes and meeting minutes. Sections: TL;DR, key points, entities, FACTS.md check, open questions, source.
5. Claude searches for existing entity pages before it creates new ones, and updates what it finds.
6. Claude proposes FACTS.md changes as a table and waits for approval.
7. Claude updates index.md and log.md and moves the original to `_originals/`.

## Rules

- **Raw sources are immutable.** The page records what the source says, even when it is wrong. Conflicts are marked, not corrected.
- **One source touches many pages.** That is the point: knowledge is compiled once, not rediscovered at every question.
- **Search before creating.** Names vary with hyphens, accents and legal suffixes.
- **Propose, do not decide.** FACTS.md changes need a human yes.

## Pitfalls

- **Batch ingest without reconciliation.** Ingesting many documents at once is fast. If nobody compares each one against the fact sheet, superseded values survive.
- **Duplicate entities.** Two spellings of one supplier look different to a file system and identical to a buyer.
- **Error compounding.** A wrong summary gets cited by later pages and starts to look confirmed. Pages stay `draft` until a human reviews them.

## Related

- Skill: [wiki-ingest](../../.claude/skills/wiki-ingest/SKILL.md)
- [Canonical fact](canonical-fact.md), [Lint](lint.md)
