---
name: wiki-ingest
description: Ingest one raw source into the LLM wiki. Reads a document (usually from sources/inbox/), writes a Karpathy-style page with TL;DR, key points and open questions, files it into summaries/ or meetings/, creates or updates entity pages, proposes FACTS.md changes with their source and waits for approval, updates index.md and log.md, and moves the original to _originals/. Use when the user says "ingest", "add this to the wiki", "file this document", or points at a file in sources/inbox/.
argument-hint: "<path, e.g. sources/inbox/S06-talaverna-call-note.md>"
---

# wiki-ingest

Turn one raw source into cited wiki knowledge. Compile it once, keep the original untouched, and never change a canonical fact without approval.

Input: `$ARGUMENTS`. If it is empty, list the files in `sources/inbox/` and ask which one to ingest.

## Step 0: Orient with progressive loading

1. The root map is in context from the SessionStart hook. If it is not, read `root-map.md`.
2. Pick the target wiki. Knowledge about the company goes to `projects/<project>/wiki/` (in this repo `projects/sotarena/wiki/`). Knowledge about the method goes to `wiki/`.
3. Read the target `index.md`, `FACTS.md` and the last entries of `log.md`. Do not open other pages yet.
4. Never use `company/COMPANY.md` or `docs/` as knowledge sources.

## Step 1: Read the source

- Read the whole file. Take the metadata from its frontmatter: `source_id`, `title`, `type`, `author`, `date`.
- No `source_id`? Assign the next free ID: the highest ID in the index source register or in the inbox, plus one. Tell the user.
- Write dates in wiki pages as `YYYY-MM-DD`. Quotes keep the source's format.

## Step 2: Extract

Make a working list:

- **Claims:** every number, date, price, lead time, name in a role, decision and deadline. Keep each value exactly as the source states it, even if you believe it is wrong.
- **Entities:** people, organisations, products.
- **Next steps and open points.**

## Step 3: Write the page

- **Folder:** `meetings/` for call notes, meeting minutes and transcripts; `summaries/` for every other document.
- **File name:** the same as the source file, for example `S06-talaverna-call-note.md`.
- **Frontmatter:** `title` ("<ID> <title>"), `type` (`summary` or `meeting`), `status: draft`, `source_id`, `source_type`, `author`, `source_date`, `created`, `updated`.
- **Sections, in this order:**
  1. `# <ID> <title>`, then the breadcrumb `> Up: [<wiki name> index](../index.md)`.
  2. `## TL;DR`: two or three sentences someone can act on. Name conflicts here if there are any.
  3. `## Key points`: bullets with the values as the source states them.
  4. `## Notable quotes`: optional, at most two short quotes that matter, for example a promise made to a customer.
  5. `## Entities`: relative links to the entity pages, marked "(new)" or "(updated)".
  6. `## FACTS.md check`: a table `Claim | Value in source | FACTS.md before ingest | Result | Decision`. Result is one of `new`, `matches`, `conflict`, `supersedes`.
  7. `## Conflicts`: only if there are any. What disagrees with what, and which owner decides.
  8. `## Open questions`: what the source leaves open.
  9. `## Source`: a relative link to the original in `_originals/`, plus one line with type, author and date.

## Step 4: Entities

Before you create any entity page, search:

1. List `entities/` and read the entity lines in `index.md`.
2. Grep the wiki for the name and its variants: with and without hyphens, spaces and accents, singular and plural, with and without the legal form (S.L., S.A., S.r.l., Lda., GmbH, B.V.).
3. Grep for the role, the service or an ID, for example a supplier ID.

Then:

- **Match found:** update that page. Add facts with source ID and date, add the source link, update `updated`.
- **Not sure it is the same entity:** create no second page and merge nothing. Report the candidate and ask.
- **No match:** create a page with frontmatter (`title`, `type: entity`, `kind` as `person`, `organisation` or `product`, `status: draft`, `aliases`, `sources`, `created`, `updated`), the breadcrumb, a one-line description, `## Facts` (every bullet ends with source ID and date), `## Related facts` (FACTS.md rows, if any) and `## Sources` (links to summary or meeting pages).
- **People outside the organisation**, such as customer or supplier contacts: record name and role on the organisation page. No contact details.

## Step 5: FACTS.md proposal

Never edit FACTS.md without approval. For every claim that is a canonical fact, decide:

| Situation | Proposal |
|---|---|
| The fact is not in FACTS.md | **add** a row with value, source ID, source date and owner |
| Same value | **none**; optionally note that the source confirms the row |
| Different value; the source is newer **and** authoritative (from the owner of the fact, or it explicitly replaces the older statement) | **update**; the old value moves to the history table |
| Different value; the source is older, or it is not from the owner and does not explicitly replace the older statement | **conflict, no change**; record it in the page's Conflicts section and recommend `/wiki-lint` |

Newest is not automatically right. The Owner column decides.

Show the proposal as a table and ask: "Apply which rows?" Apply only what the user approves. Record the decision in the FACTS.md check table of the page and in the log.

## Step 6: Index and log

- `index.md`: add the page and every new entity to Links down, update the counts and lines in Rollup, add a row to the source register, update `updated`. Keep all five parts of the node contract.
- `log.md`: append at the bottom:

```text
## [YYYY-MM-DD] ingest | <ID> <title>

- Page: [<folder>/<file>](<folder>/<file>)
- Entities created: <names>. Updated: <names>.
- FACTS.md: <proposals, and what the user approved>
- Conflicts: <one line each, or "none">
```

## Step 7: Archive the original

Move the source file unchanged from `sources/inbox/` to `<wiki>/_originals/` with the same file name, using `mv`. Moving is part of ingest and is not a deletion. Never edit the original.

## Step 8: Check

If `python3` is available, run `python3 scripts/check_links.py` and fix any broken link, missing index entry or orphan you introduced. Leave everything else to lint.

## Step 9: Report

```text
Ingest: <ID> <title>
-> Page: <path>
-> Entities: created <names>; updated <names>
-> FACTS.md: <n> proposals (add, update, conflict), applied: <rows or none>
-> Conflicts: <one line each, or none>
-> Index and log updated; original moved to <path>
-> Noticed but not caused by this source: <one line, or none>. Run /wiki-lint.
```

## Rules

- Raw sources are immutable. Record what they say, mark conflicts, never correct the source.
- Do not fix problems that this source did not cause. Mention them in one line and suggest `/wiki-lint`.
- Privacy: no e-mail addresses, phone numbers, bank details or keys in wiki pages. Name people by name and role. The PreToolUse hook warns when something slips through.
- Relative markdown links only, ISO dates, plain English, no em-dash character.
- Ask before deleting, merging or renaming any page.
