# Sources: Second Brain for Claude: Why It Forgets Your Company, and How to Fix It in a Folder

Sources 1 to 8 retrieved and checked on 14 September 2026. Slide numbers refer to slides.html and slides.pdf: 22 pages, of which 1 to 17 are the main run and 18 to 22 are backup and fallback.

## Cited sources

| # | Source | URL | Retrieved | Used on | What it supports |
|---|---|---|---|---|---|
| 1 | Karpathy, A. (2026, 4 April). llm-wiki.md. GitHub gist. | https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f | 2026-09-14 | Slides 4, 7, 8; notes 4, 7, 8 | RAG rediscovers knowledge on every question and nothing accumulates; the wiki as "a persistent, compounding artifact"; three layers (raw sources, wiki, schema); ingest: a single source might touch 10 to 15 wiki pages; lint looks for contradictions, stale claims, orphan pages, missing concept pages and cross-references; good answers filed back; index works at moderate scale (about 100 sources, hundreds of pages). |
| 2 | Karpathy, A. (2026, 2 April). LLM Knowledge Bases. Post on X. | https://x.com/karpathy/status/2039805659525644595 | 2026-09-14 | Slide 8; note 8 | His research wiki: about 100 articles and about 400K words, handled through auto-maintained index files and summaries instead of RAG. Verification note: x.com returns HTTP 402 to automated fetchers; the post text for this status ID was read through the public mirror https://api.fxtwitter.com/karpathy/status/2039805659525644595 on 2026-09-14. The link opens normally in a browser. |
| 3 | Anthropic (2025, 29 September). Effective context engineering for AI agents. | https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents | 2026-09-14 | Slides 3, 5, 12; notes 3, 5, 12 | Context as a finite resource with an attention budget; "just in time" strategies with lightweight identifiers (file paths, stored queries, links); Claude Code as a hybrid: CLAUDE.md up front, glob and grep just in time. |
| 4 | Anthropic (2024, 19 September). Introducing Contextual Retrieval. | https://www.anthropic.com/news/contextual-retrieval | 2026-09-14 | Slides 12, 15; notes 12, 15 | Traditional RAG removes context when encoding chunks (revenue-grew-by-3% example); Contextual Retrieval cuts top-20 retrieval failures by 49%, 67% with reranking; below about 200,000 tokens (about 500 pages) include the whole knowledge base in the prompt, no RAG needed; RAG as the route for larger knowledge bases. |
| 5 | Anthropic. Claude Code docs: How Claude remembers your project. | https://code.claude.com/docs/en/memory | 2026-09-14 | Slide 6; note 6 | CLAUDE.md files above the working directory load at launch; CLAUDE.md files in subdirectories load on demand when Claude reads files there. |
| 6 | Lewis, P., et al. (2020). Retrieval-Augmented Generation for Knowledge-Intensive NLP Tasks. NeurIPS 2020. arXiv:2005.11401. | https://arxiv.org/abs/2005.11401 | 2026-09-14 | Slide 19; note 19 | RAG combines parametric memory with a non-parametric retrieval index; provenance and updating world knowledge are open problems for parametric-only models. |
| 7 | Sarthi, P., Abdullah, S., Tuli, A., Khanna, S., Goldie, A., Manning, C. D. (2024). RAPTOR: Recursive Abstractive Processing for Tree-Organized Retrieval. arXiv:2401.18059. | https://arxiv.org/abs/2401.18059 | 2026-09-14 | Slide 19; note 19 | Retrieval-augmented models adapt to changes in world state and include long-tail knowledge; RAPTOR recursively embeds, clusters and summarises chunks into a tree and retrieves across levels; beats traditional retrieval-augmented LMs; with GPT-4, +20% absolute accuracy over the previous best on QuALITY. Venue "ICLR 2024" appears in older notes but is not shown on the arXiv page, so the deck cites arXiv 2024. |
| 8 | Wang, H., Prasad, A., Stengel-Eskin, E., Bansal, M. (2025). Retrieval-Augmented Generation with Conflicting Evidence. COLM 2025. arXiv:2504.13079. | https://arxiv.org/abs/2504.13079 | 2026-09-14 | Slide 19; note 19 | RAG systems must handle conflicting information from several sources; the RAMDocs dataset stays hard for RAG baselines (Llama 3.3 70B Instruct: 32.60 exact match). |

## Correction applied: RAPTOR

RAPTOR builds its tree with embeddings and clustering, so it is itself a retrieval method. The deck presents it only as evidence that **summarised hierarchy on top of retrieval helps**, never as evidence that hierarchy beats vector search. Wording on backup slide 15:

> RAPTOR: +20 points on QuALITY with GPT-4. Evidence for summaries, not for hierarchy over vector search.

## Correction applied: Karpathy numbers and quotes

Every Karpathy number and quote in the deck has a working link (sources 1 and 2):

- Slide 5: quote "A persistent, compounding artifact." (gist)
- Slide 8: "10 to 15 wiki pages a single source might touch." (gist) and "Karpathy's own research wiki: about 100 articles and 400K words, navigated through index files and summaries." (X post, text verified through the mirror named above)
- Slide 9: lint checks for contradictions, stale claims and orphans (gist)

## Statements marked as own observation

| Slide | Statement |
|---|---|
| 2 | The speaker introduction and the claim that everything shown is in the public repository. |
| 3 | The ten-minute search that came back empty although the notes existed in a folder the assistant did not know about. |
| 4 | The framing "not a memory problem, a map problem" (findability). In the note for this slide: the duplicate contact record created in the same session. |
| 6 | The store layout: a root map routing to separate stores, per-project wikis with a canonical fact sheet, meetings and customer status in their own tools (simplified, generic). In the note for this slide: "if the map grows into an essay, it has stopped being a map". |
| 7 | The canonical fact sheet pattern (one home per fact, other pages link instead of copying, every value with source and date). The four rows shown are real, taken from the speaker's own fact sheet for this event; the struck row is a superseded venue name from early planning. |
| 8 | In the note for this slide: ingest spends tokens up front instead of at every question. |
| 9 | Duplicates as a lint check (own addition to Karpathy's list); a wrong fact that is not linted gets filed back and cited again. |
| 10 | The four skills (wiki-init, wiki-ingest, wiki-lint, wiki-query) are own work built on Karpathy's described pattern. |
| 11 | The four lint rules, quoted from the skill file in this repository. |
| 12, 20 | The init demo runs on three extracts from the public programme and the planning backoffice of this event. The full prepared result is `docs/fallback/claude-house-wiki/`. |
| 13 to 15, 21 to 23 | Demo content runs on Sotarena S.L., a fictional example company with synthetic data. |
| 16 | The layering (root map, LLM wiki, retrieval over raw sources as fallback) and the two flows (promote recurring answers into the wiki, fall back to retrieval when no page exists). |
| 19 | "No canonical fact": similarity ranking does not know which document is authoritative or current (last year's price list ranks as high as this year's). |

## Claims from the preparation notes that were dropped

| Claim | Where it came from | Why dropped |
|---|---|---|
| Hierarchical summary trees beat vector search (citing RAPTOR) | Earlier wiki index notes and a blog draft | Misreads RAPTOR, which uses embeddings itself. Replaced by the corrected statement above. |
| "Curse of dimensionality" below about 500 sources | Blog draft and index notes | No source found. |
| Ingest costs about $2 to $5 per source with a frontier model | Third-party breakdown without a URL | No verifiable source. |
| Add hybrid BM25 plus vector search from about 300 sources | Own planning note | No source; not needed for the argument. |
| "Latency 0 ms" for a wiki | Earlier comparison table | Misleading; not used. |
| "Anthropic LLM Wiki Pattern" as a source | Blog draft source list | Unclear what it refers to; not used. |

