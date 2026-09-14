# Speaker notes: Second Brain for Claude: LLM Wiki vs RAG

Claude Community House Barcelona, Monday 21 September 2026, 11:00 to 12:00, Auditorium. Intermediate level. Speaker: Florian Steiner, Claude Community Ambassador Munich.

Timeline (matches the approved agenda): 11:00 map problem (5) · 11:05 RAG, what it does well and where it loses context (10) · 11:15 the LLM wiki pattern (15) · 11:30 live demo (15) · 11:45 when to use which, starter repo (5) · 11:50 Q&A (10).

Sources for every claim below are listed in SOURCES.md. "Own observation" marks statements without an external source.

---

## Slide 1: Title (11:00)
- Welcome. Quick show of hands: who has watched Claude miss something that was sitting in their own files?
- Promise for the hour: when an LLM wiki fits, when RAG fits, how the two work together, and a starter repo to take home.
- Housekeeping: live demo at 11:30, questions from 11:50.

## Slide 2: The anecdote (11:01)
- I asked my assistant to prepare a client meeting. Ten minutes of searches, then: nothing useful found.
- Everything was there: a folder of notes, several recorded meetings, even the answer to the exact point it flagged as unclear.
- Own observation. No client names on stage.

## Slide 3: Not a memory problem, a map problem (11:03)
- The reflex is "bigger model" or "better memory feature". The real gap: nothing told the agent where that kind of knowledge lives.
- Anthropic describes context as a finite resource with an attention budget. So the goal is to curate context, not to pour everything in.
- Same session, I created a duplicate contact record myself, because I could not see across the silos either. A design failure, not a discipline failure (own observation).
- Bridge: the industry default answer to "give the agent the right context" is RAG. Let us be fair to it first.

## Slide 4: What RAG does well (11:05)
- Large corpora: once the material is far larger than the context window, retrieval is the practical route (Anthropic, Contextual Retrieval).
- Unknown questions: retrieval happens at question time, so nobody has to predict the questions. The RAPTOR abstract names long-tail knowledge as a strength of retrieval-augmented models.
- Fresh documents: update the index instead of retraining. Lewis et al. framed updating world knowledge and provenance as open problems for purely parametric models.

## Slide 5: Where RAG loses context (11:08)
- Chunk boundaries: Anthropic's own example, a chunk that says revenue grew by 3% without naming the company or the quarter. Their Contextual Retrieval fix cut top-20 retrieval failures by 49%, and by 67% with reranking. The problem is real, and partly fixable.
- No canonical fact: similarity ranking does not know which document is authoritative or current (own observation).
- Contradictions side by side: Wang et al. (COLM 2025) show conflicting evidence stays hard; Llama 3.3 70B reached only 32.6 exact match on their RAMDocs set.
- None of this makes RAG wrong. It means someone has to curate the knowledge somewhere.

## Slide 6: RAPTOR, summaries on top of retrieval (11:11)
- Say it precisely: RAPTOR itself embeds, clusters and summarises chunks into a tree. It is a retrieval method, not an alternative to vectors.
- Result: retrieval with recursive summaries beat traditional retrieval-augmented models; with GPT-4, 20 points absolute accuracy over the previous best on QuALITY.
- Takeaway: summarised hierarchy on top of retrieval helps. It is not evidence that hierarchy beats vector search.
- Bridge: the LLM wiki takes the summarising idea and does it once, at ingest time, in plain Markdown.

## Slide 7: Retrieve every time, or compile once (11:15)
- Karpathy's gist: with RAG the model rediscovers knowledge on every question and nothing accumulates; the wiki is a persistent, compounding artifact.
- The real difference is when the work happens: at question time or at ingest time.
- Two loops make it compound: lint keeps it honest, good answers get filed back as new pages.
- Next: the four moves. Root map, fact sheet, ingest, lint.

## Slide 8: Move 1, root map (11:18)
- One short file, loaded at session start. Pointers and one-line summaries, never the content itself.
- Mirrors Anthropic's just-in-time pattern: keep lightweight identifiers, load details at runtime. Claude Code loads CLAUDE.md files at launch and files in subdirectories on demand.
- My setup, described generically: the root map routes to separate stores; each project has its own wiki with a canonical fact sheet; meetings and customer status stay in their own tools (own observation).
- Rule of thumb: if the map grows into an essay, it has stopped being a map.

## Slide 9: Move 2, canonical fact sheet (11:21)
- Decide on purpose where each kind of fact lives. Other pages link to it, they never copy it.
- Every value carries a source and a date, so a stale value becomes visible.
- This is the missing piece from slide 5: an explicit answer to "which value is canonical".
- Own observation. The example values are fictional.

## Slide 10: Move 3, ingest (11:24)
- A new source goes into sources/inbox/ and is never edited; after ingest the original moves to _originals/. The LLM writes a summary page, updates entity and concept pages, the fact sheet, the index and the log.
- Karpathy's gist: a single source might touch 10 to 15 wiki pages.
- His own research wiki (X post, 2 April 2026): about 100 articles and 400K words, navigated through index files and summaries rather than a RAG stack.
- Trade-off to name: ingest spends tokens up front instead of at every question (own observation).

## Slide 11: Move 4, lint (11:27)
- Karpathy's lint list: contradictions between pages, stale claims that newer sources superseded, orphan pages, plus missing concept pages and cross-references.
- I add duplicates: the same person or thing under two spellings (own addition).
- The honest risk: LLM-written pages look authoritative. Without lint, a wrong fact gets filed back and cited again (own observation).
- Next: all four moves, live.

## Slide 12: Live demo, step 1: ingest (11:30)
- Introduce Sotarena S.L.: a fictional example company with synthetic data from the starter repo.
- S06 (the Talaverna call note) already waits in sources/inbox/: run /wiki-ingest on it.
- Show the diff: which pages changed, the new log entry, how many pages one source touched.
- If the live demo fails: jump to slide 17.

## Slide 13: Live demo, step 2: lint (11:35)
- Run lint on the Sotarena S.L. wiki.
- Walk through the three findings: a contradiction, a duplicate, a stale fact.
- Ask the room which value they would trust before revealing the sources.
- Fallback: slide 18.

## Slide 14: Live demo, step 3: fact sheet (11:40)
- Open the Sotarena S.L. fact sheet: the winning value, its source file and date, and the value it replaces.
- Resolved once, in one place; every other page links here.
- Only if time allows: ask one question and file the answer back.
- Fallback: slide 19. Hard stop at 11:45.

## Slide 15: When to use which (11:45)
- Small corpus first: Anthropic's own guidance says that below about 200K tokens (about 500 pages) you can put the whole knowledge base in the prompt, no RAG needed.
- LLM wiki for curated, recurring knowledge where one canonical value matters. RAG for large corpora, unforeseen questions, fresh documents.
- They complement each other: root map on top, wiki in the middle, retrieval over raw sources as the fallback. Recurring answers move up into the wiki (own observation).
- Anthropic describes Claude Code as exactly such a hybrid: CLAUDE.md up front, glob and grep just in time.

## Slide 16: Starter repo and Q&A (11:48, Q&A 11:50 to 12:00)
- Scan the QR: the starter repo with the fictional company, root map, fact sheet, ingest and lint.
- Before 11:00: check that the repository is public, as promised on the slide.
- Likely questions: several people editing one wiki and merge conflicts; permissions; ingest cost at scale; when to add embeddings.
- Close: an official Claude Community event, supported by Anthropic. Thank the Community House team.

## Slides 17 to 19: Fallback screenshots (only if the live demo breaks)
- Use instead of slides 12 to 14, same talking points and timing.
- Frames stay empty ([SCREENSHOT]) until the starter repo exists; then add one screenshot per demo step.
- Slide 17: ingest diff. Slide 18: lint report with the three findings. Slide 19: fact sheet with the winning value and source.
