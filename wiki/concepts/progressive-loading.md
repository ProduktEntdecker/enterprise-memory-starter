---
title: "Progressive loading"
type: concept
status: reviewed
created: 2026-09-14
updated: 2026-09-14
---

# Progressive loading

> Up: [Global wiki index](../index.md)

**In one sentence:** Load the smallest useful map first and open detail pages only when a question needs them, so the context window holds the relevant knowledge instead of everything.

## The three steps

1. **Root map**, loaded into every session by the SessionStart hook: which store answers this kind of question?
2. **Index** of that store: which pages, judging by their one-line rollups?
3. **Detail pages:** FACTS.md for numbers, dates, prices and names in roles, then one to three pages for context. Originals only to verify a quote.

## Why

- **Context is a budget.** Anthropic describes context as a finite resource and recommends loading data just in time through lightweight identifiers such as file paths.
- **Small maps age slowly.** A root map of pointers stays correct while the pages behind it change.
- **Citations come for free.** Every step names a file that the answer can cite.

## Signs it is not working

- Claude opens whole folders to be safe: the index rollups are too vague.
- Answers cite the scenario description or the docs folder: the root map does not mark them as out of scope clearly enough.
- The same question loads different pages each time: FACTS.md is missing a row.

## References

- Anthropic, "Effective context engineering for AI agents", September 2025: https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents

## Related

- [Node contract](node-contract.md), [LLM wiki vs RAG](llm-wiki-vs-rag.md)
