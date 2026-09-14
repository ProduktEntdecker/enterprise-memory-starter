---
name: wiki-lint
description: Health-check a wiki and write a dated report without changing any content. Finds contradictions between pages or against FACTS.md, duplicate entities with near-identical names, stale facts superseded by newer dated sources, orphan pages, missing index entries and broken links. Writes <wiki>/outputs/lint-YYYY-MM-DD.md and never silently fixes. Use when the user says "lint", "health check", "check the wiki", or before a decision relies on the wiki.
argument-hint: "[wiki path, default projects/sotarena/wiki]"
---

# wiki-lint

Report what is wrong with a wiki. Change nothing until the user names the findings to resolve.

Scope: `$ARGUMENTS`. If it is empty, use `projects/sotarena/wiki`.

## Step 0: What to read

- Read `index.md`, `FACTS.md` and `log.md` of the wiki.
- Then read every page in `entities/`, `summaries/` and `meetings/`, in parallel batches. The example wiki is small. For more than about 200 pages, go folder by folder and keep notes.
- Open `_originals/` only to verify a quoted value. Do not read the files in `sources/inbox/` (only list their names), `company/COMPANY.md` or `docs/`: they are not part of the wiki.

## Step 1: Mechanical candidates

Run `python3 scripts/check_links.py --lint <wiki>`. It prints candidates for broken links, missing index entries, orphan pages and near-duplicate entity names, and lists the inbox. Verify every candidate by reading the pages before you report it. Without Python, do the same by hand: list `entities/`, compare the names without hyphens, accents, plural endings and legal forms, and grep for inbound links.

## Step 2: Duplicate entities

For every candidate pair (similar normalised names, the same register ID, or the same role or service):

- Read both pages. Confirm that they describe the same real-world thing: same service or role, same topic, compatible facts.
- The finding lists both pages, the sources behind each spelling and every place that uses each spelling, including FACTS.md rows.
- Suggested resolution: merge into the page with the official name (register entry, legal form, ID), add the other spelling to `aliases`, repoint the links. Deleting the other page needs explicit approval.

## Step 3: Contradictions

For every FACTS.md row:

1. Search the wiki for the same subject, with synonyms (for a lead time: "lead time", "delivery time", "weeks").
2. Collect every stated value with page, source ID and source date.
3. If a value differs from FACTS.md, decide between contradiction and stale fact (step 4). It is a **contradiction** when the differing source is not from the owner of the fact and does not explicitly replace the canonical statement.

Also compare entity pages with each other for facts that are not in FACTS.md.

Suggested resolution for a contradiction: keep the canonical value unless the owner decides otherwise, name the owner role from FACTS.md, and say what has to happen outside the wiki, for example correcting a statement made to a customer. **Never resolve a contradiction by date alone.**

## Step 4: Stale facts

A FACTS.md row or an entity statement is **stale** when a newer dated source that is authoritative for that fact states a different value: the source comes from the owner, or it explicitly replaces the older statement (a succession announcement, a new price list, a new register status).

Also look in `log.md` and in the FACTS.md check tables of summary pages for claims marked "not checked" and for proposals that were never applied.

Suggested resolution: update the FACTS.md row with the new value, winning source and source date; move the old value to the history table; mark the old statement on entity pages as former, with its end date.

## Step 5: Structure

- **Orphan page:** a page in `entities/`, `summaries/` or `meetings/` without inbound links, except from `index.md` and `log.md`.
- **Missing index entry:** a page that `index.md` does not link.
- **Broken link:** a relative link to a file that does not exist.

## Step 6: Severity

- **High:** a wrong or disputed value is in FACTS.md, or can reach a customer, a board pack or a contract.
- **Medium:** two versions coexist in the wiki, but FACTS.md is right.
- **Low:** structure only.

## Step 7: Write the report

Path: `<wiki>/outputs/lint-YYYY-MM-DD.md` with today's date. If that file exists, append `-2`, `-3`.

```markdown
---
title: "Lint report YYYY-MM-DD"
type: output
status: draft
scope: <wiki path>
created: YYYY-MM-DD
updated: YYYY-MM-DD
---

# Lint report YYYY-MM-DD

> Up: [<wiki name> index](../index.md)

**Purpose:** Findings of the wiki health check on YYYY-MM-DD. Nothing was changed; every finding needs a decision.

## Summary

| Check | Findings |
|---|---|
| Contradictions | n |
| Duplicate entities | n |
| Stale facts | n |
| Orphan pages | n |
| Missing index entries | n |
| Broken links | n |

## Findings

### 1. <Kind>: <subject>

- **Severity:** High, Medium or Low, with one reason
- **Where:** relative links to the pages, plus FACTS.md row numbers
- **Evidence:** every value with page, source ID and source date
- **Why it matters:** one or two sentences
- **Suggested resolution:** the concrete change, plus anything that must happen outside the wiki
- **Decision by:** owner role from FACTS.md

## Checks without findings

- <check>: none.

## Notes

- Inbox: <n> files not yet ingested (<names>).
- This report changed no page. Reply with the finding numbers to resolve.
```

Then add the report to `index.md` (Links down under Outputs, count in Rollup) and append to `log.md`:

```text
## [YYYY-MM-DD] lint | <n> findings

- Report: [outputs/lint-YYYY-MM-DD.md](outputs/lint-YYYY-MM-DD.md)
- Findings: <kind and subject, one per line>
- No content changed.
```

## Step 8: Report to the user

One line per finding (number, kind, subject, severity), the report path, and the question "Which findings should I resolve?". Stop there.

## Step 9: Resolve, only after the user names findings

- Apply exactly the suggested resolution of the named findings, nothing else.
- FACTS.md: new value, new winning source and source date; the old value moves to the history table.
- Merges: keep one page, add the aliases, repoint every link. Ask before deleting the other page.
- Log every resolution with a reference to the report: `## [YYYY-MM-DD] resolve | lint-YYYY-MM-DD finding <n>`.
- Run `python3 scripts/check_links.py` afterwards.

## Rules

- Never silently fix. The report comes first; decisions come from a human.
- Newest is not automatically right. The owner of a fact decides a contradiction.
- Report only what you verified. Mark uncertain findings as "Needs review".
- Plain English, relative links, ISO dates, no em-dash character.
