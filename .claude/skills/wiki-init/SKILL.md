---
name: wiki-init
description: Turn a folder of documents into a new LLM wiki. Creates the folder structure, ingests every source in date order, builds FACTS.md from the claims found, writes index.md and log.md, and registers the new wiki in root-map.md. Ends with a lint so the first report exists from day one. Use when the user says "start a wiki", "init a wiki", "make a wiki from this folder", or points at a folder of documents that has no wiki yet.
argument-hint: "<folder with sources, e.g. examples/claude-house>"
---

# wiki-init

A folder of documents becomes a wiki that answers questions with citations. This
runs once per project. Afterwards, new sources go through `wiki-ingest`.

Folder: `$ARGUMENTS`. If it is empty, ask which folder to start from.

## Step 0: Look before you build

1. Check that `<folder>/wiki/` does not exist. If it does, stop and say so: this is
   a job for `wiki-ingest`, not for init. Never overwrite an existing wiki.
2. List the source files. Accept markdown, plain text and CSV. Say how many you found.
3. Read the frontmatter of each one only, not the bodies: `source_id`, `title`,
   `type`, `author`, `date`. Files without a `source_id` get one now, in date
   order, with the prefix the user chooses (default: the first letter of the
   project name, then a running number).

## Step 1: Agree the shape before writing anything

Report back in one block and wait:

```
Wiki for <project>: <n> sources found, <date range>.
Proposed structure: entities/, summaries/, meetings/, outputs/, _originals/
Expected pages: about <n * 3> to <n * 4>
Language: <detected>
Start?
```

Do not create a single file before the user answers. For more than 12 sources, say
how long it will take and offer to start with the newest five.

## Step 2: Build the skeleton

```
<folder>/
  wiki/
    index.md
    log.md
    FACTS.md
    entities/
    summaries/
    meetings/
    outputs/
    _originals/
  sources/
    inbox/
```

## Step 3: Ingest in date order, oldest first

Run the `wiki-ingest` steps for each source, from the oldest to the newest. Order
matters: a later source that supersedes an earlier one must arrive later, so that
the history in FACTS.md reads correctly.

Differences from a normal ingest:

- **Do not ask for approval per source.** The user approved the whole run in step 1.
  Collect every conflict instead and present them together in step 5.
- **A conflict never stops the run.** Record both values with their sources and move on.
- Keep the source files where they are. Move them to `_originals/` only at the end,
  once every source has been read.

## Step 4: Build FACTS.md from what was found

One row per fact that is stated as a value: numbers, dates, prices, capacities,
names in roles, rules. Each row carries the winning source, the source date and an
owner role.

Where two sources disagree, the row takes the value of the source that is
authoritative for that fact, and the other value goes into the history table with
its date. Where it is unclear which one is authoritative, the row is marked
`needs decision` and the finding goes into step 5.

Do not invent an owner. If no source names one, write `unassigned` and list it in
step 5.

## Step 5: Report, then lint

Report:

```
Wiki created: <folder>/wiki
Pages: <n> summaries, <n> entities, <n> meetings
FACTS.md: <n> rows, <n> marked "needs decision", <n> without an owner
Conflicts found during ingest: <list, one line each>
```

Then run `wiki-lint` on the new wiki, so the first health report exists from day
one. A fresh wiki usually has orphans and missing owners. That is normal and is
exactly what the report is for.

## Step 6: Register it

Add the new wiki to `root-map.md`: one line, what it covers, where it lives. A wiki
the root map does not know about will not be found at question time.

## Rules

- Never overwrite an existing wiki.
- Never invent a value, a source or an owner. Missing is a finding, not a gap to fill.
- Sources are never edited, only moved.
- Plain English, relative links, ISO dates, no em-dash character.
