---
title: "Lint"
type: concept
status: reviewed
created: 2026-09-14
updated: 2026-09-14
---

# Lint

> Up: [Global wiki index](../index.md)

**In one sentence:** Lint is the periodic health check of a wiki: it reports contradictions, duplicate entities, stale facts, orphan pages and missing index entries in a dated report, and it changes nothing until a human decides.

## What lint checks

| Check | Question | Typical cause |
|---|---|---|
| Contradiction | Do two pages, or a page and FACTS.md, state different values for the same fact? | A statement from someone who does not own the fact |
| Duplicate entity | Do two entity pages describe the same real-world thing? | Different spellings in different sources |
| Stale fact | Has a newer, authoritative source replaced a value that is still in use? | Nobody reconciled the fact sheet after an ingest |
| Orphan page | Is a page linked from nowhere except the index? | A page created and never connected |
| Missing index entry | Is a page missing from index.md? | Manual edits outside ingest |
| Broken link | Does a link point to a file that does not exist? | Renames and merges |

## Why lint never fixes silently

- **Resolution needs a decision owner.** For a contradiction the owner of the fact decides, not the date.
- **Silent fixes destroy the audit trail.** The report and the log keep it.
- **Lint can be wrong.** A report can be reviewed; an overwritten fact cannot.

## Mechanical and semantic checks

Links, index coverage, orphans and similar entity names are mechanical: `python3 scripts/check_links.py --lint <wiki>` lists candidates in milliseconds. Contradictions and stale facts are semantic: Claude reads FACTS.md and the pages and compares values, dates and owners. The [wiki-lint skill](../../.claude/skills/wiki-lint/SKILL.md) combines both and verifies every candidate before it reports it.

## Triage

- **Real or noise?** Every living wiki has some findings. Read the evidence, not only the headline.
- **Severity:** high when a wrong value can reach a customer, a board pack or a contract.
- **Who decides?** The owner column of FACTS.md names the role.

## How often

After every batch ingest, before a decision that relies on the wiki, and at least weekly for a wiki in daily use.

## Related

- [Canonical fact](canonical-fact.md), [Ingest](ingest.md), [Node contract](node-contract.md)
