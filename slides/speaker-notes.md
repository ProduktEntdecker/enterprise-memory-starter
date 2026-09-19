# Speaker notes: Second Brain for Claude: Why It Forgets Your Company, and How to Fix It in a Folder

Claude Community House Barcelona, Monday 21 September 2026, 11:00 to 12:00, Auditorium. Intermediate level. Speaker: Florian Steiner, Claude Community Ambassador Munich.

Timeline: 11:00 map problem (5) · 11:05 the LLM wiki pattern (17) · 11:22 live demo (19) · 11:41 what to take home, credits, repo (5) · 11:46 Q&A (14).

This talk is about the wiki, not about retrieval. The retrieval comparison sits on one backup slide at the end and is only shown if someone asks.

Sources for every claim below are listed in SOURCES.md. "Own observation" marks statements without an external source.

---

## Slide 1: Title (11:00)
- Welcome. Quick show of hands: who has watched Claude miss something that was sitting in their own files?
- Promise for the hour: when an LLM wiki fits, when RAG fits, how the two work together, and a starter repo to take home.
- Housekeeping: live demo at 11:22, questions from 11:46.

## Slide 2: The anecdote (11:01)
- I asked my assistant to prepare a client meeting. Ten minutes of searches, then: nothing useful found.
- Everything was there: a folder of notes, several recorded meetings, even the answer to the exact point it flagged as unclear.
- Own observation. No client names on stage.

## Slide 3: Not a memory problem, a map problem (11:03)
- The reflex is "bigger model" or "better memory feature". The real gap: nothing told the agent where that kind of knowledge lives.
- Anthropic describes context as a finite resource with an attention budget. So the goal is to curate context, not to pour everything in.
- Same session, I created a duplicate contact record myself, because I could not see across the silos either. A design failure, not a discipline failure (own observation).
- Bridge: the industry default answer to "give the agent the right context" is RAG. Let us be fair to it first.

## Slide 4: Retrieve every time, or compile once (11:05)
- Karpathy's gist: with RAG the model rediscovers knowledge on every question and nothing accumulates; the wiki is a persistent, compounding artifact.
- The real difference is when the work happens: at question time or at ingest time.
- Two loops make it compound: lint keeps it honest, good answers get filed back as new pages.
- Next: the four moves. Root map, fact sheet, ingest, lint.

## Slide 5: Move 1, root map (11:09)
- One short file, loaded at session start. Pointers and one-line summaries, never the content itself.
- Mirrors Anthropic's just-in-time pattern: keep lightweight identifiers, load details at runtime. Claude Code loads CLAUDE.md files at launch and files in subdirectories on demand.
- My setup, described generically: the root map routes to separate stores; each project has its own wiki with a canonical fact sheet; meetings and customer status stay in their own tools (own observation).
- Rule of thumb: if the map grows into an essay, it has stopped being a map.

## Slide 6: Move 2, canonical fact sheet (11:13)
- Decide on purpose where each kind of fact lives. Other pages link to it, they never copy it.
- Every value carries a source and a date, so a stale value becomes visible.
- This is the missing piece from slide 5: an explicit answer to "which value is canonical".
- Own observation. The example values are fictional.

## Slide 7: Move 3, ingest (11:16)
- A new source goes into sources/inbox/ and is never edited; after ingest the original moves to _originals/. The LLM writes a summary page, updates entity and concept pages, the fact sheet, the index and the log.
- Karpathy's gist: a single source might touch 10 to 15 wiki pages.
- His own research wiki (X post, 2 April 2026): about 100 articles and 400K words, navigated through index files and summaries rather than a RAG stack.
- Trade-off to name: ingest spends tokens up front instead of at every question (own observation).

## Slide 8: Move 4, lint (11:19)
- Karpathy's lint list: contradictions between pages, stale claims that newer sources superseded, orphan pages, plus missing concept pages and cross-references.
- I add duplicates: the same person or thing under two spellings (own addition).
- The honest risk: LLM-written pages look authoritative. Without lint, a wrong fact gets filed back and cited again (own observation).
- Next: all four moves, live.

## Slide 9: Live demo, step 1: ingest (11:22)
- Introduce Sotarena S.L.: a fictional example company with synthetic data from the starter repo.
- S06 (the Talaverna call note) already waits in sources/inbox/: run /wiki-ingest on it.
- Show the diff: which pages changed, the new log entry, how many pages one source touched.
- If the live demo fails: jump to slide 16.

## Slide 10: Live demo, step 2: lint (11:28)
- Run lint on the Sotarena S.L. wiki.
- Walk through the three findings: a contradiction, a duplicate, a stale fact.
- Ask the room which value they would trust before revealing the sources.
- Fallback: slide 17.

## Slide 11: Live demo, step 3: fact sheet (11:35)
- Open the Sotarena S.L. fact sheet: the winning value, its source file and date, and the value it replaces.
- Resolved once, in one place; every other page links here.
- Only if time allows: ask one question and file the answer back.
- Fallback: slide 18. Hard stop at 11:41.

## Slide 12: When to use which (11:41)
- Small corpus first: Anthropic's own guidance says that below about 200K tokens (about 500 pages) you can put the whole knowledge base in the prompt, no RAG needed.
- LLM wiki for curated, recurring knowledge where one canonical value matters. RAG for large corpora, unforeseen questions, fresh documents.
- They complement each other: root map on top, wiki in the middle, retrieval over raw sources as the fallback. Recurring answers move up into the wiki (own observation).
- Anthropic describes Claude Code as exactly such a hybrid: CLAUDE.md up front, glob and grep just in time.

## Slide 13: API credits (11:44)
- "Before the questions: 50 dollars in Claude API credits, and the link takes the first 34 of you."
- Walk the three steps out loud while they scan. Most people miss step 2 and it is the one that fails.
- **Say it twice:** the Organization ID from `console.anthropic.com`, not the Claude.ai account ID. A wrong ID is rejected, each person can claim only once, and Anthropic's credit team cannot correct a bad submission.
- API only. If someone asks whether this pays for their Claude.ai subscription: no.
- 34 redemptions available. If the room is fuller than that, say so honestly and take names afterwards so the Community team can adjust the cap.
- **The number 34 lives in two places:** this section and the badge on slide 13 (`slides/slides.html`, the line ending in "34 available"). If the Community team raises the cap, change both and re-export the PDF, otherwise the room hears one number and reads another.
- The QR is generated locally before the session and is deliberately not in the repository, so the offer cannot be drained by anyone crawling GitHub. Run:
  `qrencode -t SVG -o slides/qr-credits.svg -l H -s 8 -m 2 "<offer link from the Community team>"`
  In the committed PDF this slide shows a placeholder instead of the code. Present from `slides-with-credits.pdf` or from the HTML.
- Source: Claude Community Team, mail of 18 September 2026.

## Slide 14: Starter repo and Q&A (11:46, Q&A right after)
- Scan the QR: the starter repo with the fictional company, root map, fact sheet, ingest and lint.
- Before 11:00: check that the repository is public, as promised on the slide.
- Likely questions: several people editing one wiki and merge conflicts; permissions; ingest cost at scale; when to add embeddings.
- Close: the repository is an independent community resource. Thank the Community House team.

The credit-offer QR on slide 13 loads `qr-credits.svg`, which is not in the repository. Without it the slide falls back to `qr-credits-placeholder.svg`, so presenting from the HTML never shows a broken image. Generate the real code locally before the session.

## Slide 15: Backup, why not just retrieval? (only on request)

Not part of the talk. Show it when someone asks how this compares to retrieval, then go back.

- Retrieval is strong where this pattern is weak: corpora far past the context window, questions nobody predicted, a new file indexed in seconds.
- Three things it gets wrong: chunk boundaries (Anthropic's own example, a chunk that says revenue grew by 3% without naming company or quarter), no canonical fact (similarity ranking does not know which document is authoritative), contradictions side by side (Wang et al., COLM 2025: Llama 3.3 70B reached 32.6 exact match on RAMDocs).
- If they push on hierarchy: RAPTOR embeds, clusters and summarises into a tree and reports +20 points on QuALITY with GPT-4. That is evidence that summaries help, not that hierarchy beats vector search.
- The honest answer, and the one to end on: the two are not exclusive. Compile what matters, retrieve the rest.

## Slides 16 to 18: Fallback output (only if the live demo breaks)
- Use instead of slides 9 to 11, same talking points and timing.
- Each frame holds the real prepared output from `docs/fallback/`, shortened to the decisive lines, not a placeholder.
- Slide 18: the ingest summary, with the lead-time conflict highlighted. A real screenshot from the rehearsal can replace the text block later.
- Slide 19: the lint report with the three findings. A real screenshot from the rehearsal can replace the text block later.
- Slide 20: the fact sheet rows after the resolution, with the superseded value in the history table. A real screenshot from the rehearsal can replace the text block later.
