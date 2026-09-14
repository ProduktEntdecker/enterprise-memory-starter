---
name: wiki-query
description: Answer a question from the LLM wiki with progressive loading (root map, then index, then FACTS.md and a few detail pages) and cite the pages and source IDs used. Says clearly when the wiki does not know. Use for questions about the company in the wiki, for example "what is our lead time", "who is the Quality Manager", "what do we know about supplier X".
argument-hint: "<question>"
---

# wiki-query

Answer from the wiki, not from memory, and show the path you took.

Question: `$ARGUMENTS`

## Step 1: Map

The root map is in context from the SessionStart hook; otherwise read `root-map.md`. Pick the store for the question. Questions about the company go to the project wiki.

## Step 2: Index

Read the `index.md` of that store. Use the rollup and the link lines to choose candidate pages. Do not open whole folders.

## Step 3: Facts first

For numbers, dates, prices, lead times and names in roles, read `FACTS.md` before any other page. The FACTS.md value is the answer.

## Step 4: Detail pages

Open only the pages you need, usually one to three. Open an original in `_originals/` only to verify a quote.

## Step 5: Answer

```text
Answer: <one or two sentences with the value>

Path: root-map.md -> <index> -> FACTS.md row <n> -> <pages>
Sources: <page path> (<source ID>, <source date>), ...
Caveats: <conflicts, draft pages, open lint findings, or none>
```

- If a page disagrees with FACTS.md, give the FACTS.md value, mention the conflict and suggest `/wiki-lint`.
- If the wiki does not contain the answer, say so and name the kind of source that would answer it. Do not fill gaps from general knowledge, `company/COMPANY.md` or `docs/`.
- If the answer is worth keeping, for example a comparison or an analysis, offer to file it as `outputs/<slug>.md` and to add it to the index and the log. Ask first.

## Rules

- Cite every value. No citation, no value.
- Read as little as possible, but never skip FACTS.md for a fact question.
- Plain English, no em-dash character.
