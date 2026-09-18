---
title: "LLM wiki vs RAG"
type: concept
status: reviewed
created: 2026-09-14
updated: 2026-09-14
---

# LLM wiki vs RAG

> Up: [Global wiki index](../index.md)

**In one sentence:** RAG retrieves text fragments at question time; an LLM wiki compiles knowledge once into cited, interlinked pages and keeps them current, so the synthesis already exists when the question comes.

## The difference is timing

- **RAG** (retrieval-augmented generation) indexes raw documents, usually as embedded chunks. At question time it searches, passes the best matching chunks to the model and generates an answer. Every question starts again from raw material.
- **LLM wiki**, the pattern Andrej Karpathy describes, has the model read each source once, write summary and entity pages, flag contradictions and keep an index and a log. At question time the model reads a small map, an index and a few pages.

## Comparison

| Dimension | LLM wiki | RAG |
|---|---|---|
| When the knowledge work happens | At ingest, once per source | At every question |
| What accumulates | Pages, links, flagged conflicts, canonical facts | Nothing between questions |
| Conflicting sources | Flagged at ingest, reported by lint, decided by an owner | Both versions can be retrieved; the answer depends on ranking |
| Two spellings of one entity | Merged into one page with an alias after lint | Separate chunks that nothing connects |
| Work at question time | No extra retrieval step: read map, index and pages | Search and rank, then read chunks |
| Scale | Works well at moderate scale (about 100 sources, hundreds of pages, per Karpathy); beyond that, project wikis and a search tool | Large corpora, with indexing infrastructure |
| Review and versioning | Plain markdown in git, diffs a human can read | Index and embeddings are not human-readable; re-index when the embedding model changes |
| Setup | A folder, a CLAUDE.md, a few skills | Chunking, embedding, a vector store, ranking, evaluation |
| Main risk | Error compounding: a wrong page gets cited and looks confirmed | Confident but wrong answers from outdated or badly split chunks |
| Quality assurance | Citations, draft or reviewed status, lint | Retrieval metrics and answer faithfulness |

## When each fits

**An LLM wiki fits when**

- the knowledge is curated and recurring: roles, prices, lead times, decisions, customers, suppliers;
- a fact must have exactly one value and an owner;
- you need an audit trail a human can read;
- the corpus is small to medium, or splits naturally into project wikis.

**Retrieval fits when**

- the corpus is large and long-tail: every e-mail, ticket, manual or contract;
- questions are open and semantic, and the answer is a passage you want to quote;
- the material changes faster than anyone could compile it.

**Neither fits when** the answer lives in structured data (query the ERP or the database) or is an exact string (use full-text search).

## How they combine

1. **The wiki is the compiled layer.** The root map, the indexes and FACTS.md answer recurring questions and route everything else.
2. **Retrieval is the fallback for the long tail.** Raw stores stay searchable, and the wiki points to them.
3. **Retrieval feeds ingest.** When a search surfaces something that matters, ingest it and it becomes a page.
4. **Answers compound.** A valuable answer is filed back into the wiki as an output page.

## Example from the Sotarena wiki

- A sales call note says the standard lead time is 4 weeks, the operations memo says 6 weeks. A similarity search for "lead time" returns both chunks. The wiki keeps one value with an owner in FACTS.md and reports the conflict.
- One powder coater appears under two spellings in two documents. Retrieval returns two unrelated chunks; an entity check catches the duplicate.

## References

- Andrej Karpathy, "LLM Wiki", gist, April 2026: https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f
- Anthropic, "Effective context engineering for AI agents", September 2025: https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents

## Related

- [Progressive loading](progressive-loading.md), [Canonical fact](canonical-fact.md), [Lint](lint.md)
