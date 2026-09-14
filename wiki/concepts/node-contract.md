---
title: "Node contract"
type: concept
status: reviewed
created: 2026-09-14
updated: 2026-09-14
---

# Node contract

> Up: [Global wiki index](../index.md)

**In one sentence:** Every index.md is a node with five parts (breadcrumb up, one-sentence purpose, rollup of its children, links down, pointer to the raw stores), so that a human or an agent can enter anywhere and find the way.

## The five parts

| Part | Form in this repo | Question it answers |
|---|---|---|
| 1. Breadcrumb up | A line starting with `> Up:` and a link to the parent | Where am I, and how do I get back? |
| 2. Purpose | A line starting with `**Purpose:**` and one sentence | Is this the right node for my question? |
| 3. Rollup | A `## Rollup` section, one line per child folder or file | Can I decide without opening the children? |
| 4. Links down | A `## Links down` section that links every page | Is every page findable without search? |
| 5. Raw stores | A `## Raw stores` section | Where are the unprocessed originals? |

The [root map](../../root-map.md) is the top node: it has no breadcrumb and lists stores instead of pages.

## Why a contract

- **Agents navigate by convention.** Fixed headings let Claude find the next step without reading the whole file.
- **Rollups age.** When a page changes, its line in the rollup changes too. Ingest updates both.
- **Checks need structure.** `python3 scripts/check_links.py` fails when an index misses a part, a page is not linked from its index, or a link does not resolve.

## Examples

- [Global wiki index](../index.md)
- [Sotarena project wiki index](../../projects/sotarena/wiki/index.md)

## Related

- [Progressive loading](progressive-loading.md)
