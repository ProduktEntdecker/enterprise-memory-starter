# Speaker notes: Second Brain for Claude: Why It Forgets Your Company, and How to Fix It in a Folder

Claude Community House Barcelona, Monday 21 September 2026, 11:00 to 12:00, Auditorium. Intermediate level. Speaker: Florian Steiner, Claude Community Ambassador Munich.

Timeline: 11:00 opening and the map problem (8) · 11:08 the pattern and the four moves (14) · 11:22 what we built on top (6) · 11:28 live demo (18) · 11:46 what to take home and links (6) · 11:52 Q&A (8).

This talk is about the wiki. RAG is named on slide 5 and compared in one line on slide 16. The detail, what retrieval is good at and where it loses context, sits on backup slide 19 and is only shown if someone asks.

Sources for every claim below are listed in SOURCES.md. "Own observation" marks statements without an external source.

---

## Slide 1: Title (11:00)
- Short. The title does the work.
- One sentence on what the next hour holds: a problem, four moves, a live demo, a repository to take home.

## Slide 2: Who is talking (11:01)
- Name, city, what I do: Claude Code for small and mid-sized companies, and teaching it.
- The certifications in one line, not a list.
- The important sentence: **everything in this talk is in one public repository**, open right now. Slides, the four skills, the example wiki, the demo script, and the prepared results in case the demo breaks.
- Ask them to scan now, not at the end. People who follow along ask better questions.

## Slide 3: The anecdote (11:03)
- My own agent did not know my date of birth, although it is one line in `identity.md` in the folder I keep about myself.
- It had never been told that folder exists. It did not search badly. It searched in the wrong place.
- Keep it short and personal. This is the hook, not the argument.

## Slide 4: Not a memory problem, a map problem (11:05)
- The reflex: a bigger model, more memory. That misses it.
- Context is finite and every token costs attention (Anthropic). So curate, do not pour everything in.
- Own observation: in the same session I created a duplicate contact record. A design fault, not a discipline fault.
- Bridge to the next slide: when does the work happen, at every question or once at ingest? That is the whole difference.

## Slide 5: Retrieve every time, or compile once (11:08)
- Karpathy: with RAG the model rediscovers knowledge at every question and nothing accumulates. The wiki is a persistent, compounding artifact.
- Name RAG plainly here. Being vague about it costs more credibility than naming it.
- Be honest: I have never run RAG in production, only in a course. What I compare is the shape of the two pipelines, not my war stories.
- What decides it for me: no chunking strategy to tune, I can read every page myself, Obsidian is the interface, an afternoon of work, no vector store to operate.
- Two loops make it compound: lint keeps it honest, good answers get filed back as new pages.

## Slide 6: Move 1, root map (11:11)
- One short file, loaded at session start. Pointers and one-line summaries, never the content itself.
- Mirrors Anthropic's just-in-time pattern: keep lightweight identifiers, load details at runtime. Claude Code loads CLAUDE.md at launch and files in subdirectories on demand.
- My setup, described generically: the root map routes to separate stores, each project has its own wiki with a canonical fact sheet.
- Meetings and customer status stay in their own tools on purpose. Not everything belongs in the wiki.
- Rule of thumb: if the map grows into an essay, it has stopped being a map.

## Slide 7: Move 2, canonical fact sheet (11:14)
- Decide on purpose where each kind of fact lives. Other pages link to it, they never copy it.
- Every value carries a source and a date, so a stale value becomes visible.
- **These four rows are real**, taken from the fact sheet I keep for this event.
- The struck row is the venue name from early planning that no longer applies.
- That is why I can still tell you the right room number, while it changed twice.

## Slide 8: Move 3, ingest (11:17)
- A new source goes into `sources/inbox/` and is never edited. After ingest the original moves to `_originals/`.
- The model writes the summary page, updates entity pages, the fact sheet, the index and the log.
- Karpathy's gist: a single source might touch 10 to 15 wiki pages.
- His own research wiki: about 100 articles and 400K words, navigated through index files and summaries.
- S06 is still sitting in the inbox. That exact source is the one we run live in a moment.
- Trade-off to name: ingest spends tokens up front instead of at every question.

## Slide 9: Move 4, lint (11:20)
- Karpathy's lint list: contradictions between pages, stale claims superseded by newer sources, orphan pages, missing cross-references.
- I add duplicates: the same person or thing under two spellings.
- The honest risk: model-written pages look authoritative. Without lint, a wrong fact gets filed back and cited again.
- Next: these four moves are not theory here, they are four commands.

## Slide 10: What we built on top of Karpathy (11:22)
- Karpathy described the pattern. The contribution here is that it runs: four skills, `/wiki-init`, `/wiki-ingest`, `/wiki-lint`, `/wiki-query`.
- Go left to right, one sentence each. Do not read the cards out.
- `/wiki-init` is the one nobody expects: a folder of documents becomes a wiki, sources ingested oldest first so the history reads correctly.
- `/wiki-ingest` proposes changes to the fact sheet and waits. It never overwrites a canonical value on its own.
- `/wiki-lint` reports and changes nothing until a human names a finding.
- `/wiki-query` answers from the wiki with citations, and offers to file a good answer back.
- The punchline: four markdown files in `.claude/skills/`. Clone the repo, and they are in your slash menu. No install, no service, no key.

## Slide 11: The lint up close (11:25)
- This is the slide people remember, because it is about trust, not about features.
- Never silently fix. The report comes first, a human names the finding, the resolution is logged.
- Newest is not automatically right. A newer source wins only if it owns the fact or explicitly replaces the older one.
- Report only what you verified. A script proposes candidates, every one is checked by reading the pages.
- Every finding has an owner. A finding without an owner is itself a finding.
- Two parts in the repo: the skill file is the procedure, `scripts/check_links.py` does the mechanical pass.
- While building this talk the script contradicted my own draft report. I corrected the report, not the script. Tell that story if there is time.

## Slide 12: Live demo, step 0: init (11:28)
- Switch to the terminal. Show the folder first: three documents about **this event**, no wiki.
- Run `/wiki-init examples/claude-house`.
- **It stops and asks.** First comes a block with the source count, the date range and the expected number of pages, then `Start?`. Nothing is written until you answer. Say `yes` and narrate the pause: it approves the whole run, not each page. Do not stand there waiting for it to write by itself.
- Narrate while it runs: sources oldest first, the fact sheet built from the claims found, two supersessions recorded because the source declares them.
- The point to land: it finds what it does not know. Two rows come back marked "needs decision". The second one is the one to read out: 96 seats plus 20 percent is 115.2, and no source says how to round it, so it does not round. Two of the three rooms divide evenly. Only the third one reveals that somebody would have had to decide.
- If it fails or runs long: jump to slide 20. The full result is also a folder, `docs/fallback/claude-house-wiki/`, openable in the editor.
- Hard stop at 11:32.

## Slide 13: Live demo, step 1: ingest (11:32)
- Switch to Sotarena S.L., a fictional example company. This wiki has been running since August, so it is what the small one becomes.
- S06, the Talaverna call note, already waits in `sources/inbox/`. Run `/wiki-ingest` on it.
- Show the diff: which pages changed, the new log entry, how many pages one source touched.
- The conflict is the moment: S06 says four weeks, the fact sheet says six. Ingest proposes, it does not decide.
- Approve the two Talaverna rows only. Leave the lead time alone.
- Fallback: slide 21.

## Slide 14: Live demo, step 2: lint (11:37)
- Run `/wiki-lint` on the Sotarena wiki.
- Walk the three findings: a contradiction, a duplicate, a stale fact.
- Ask the room which value they would trust, before revealing the sources. Most will say the newer one. That is the trap.
- The newer source is a sales call, not the operations owner, and it does not replace anything. Six weeks stands.
- Fallback: slide 22.

## Slide 15: Live demo, step 3: fact sheet (11:42)
- Resolve the stale Quality Manager finding only. One approval, one change, one log entry.
- Open the fact sheet: the winning value, its source and date, and the value it replaces in the history table.
- Resolved once, in one place. Every other page links here.
- Fallback: slide 23. Hard stop at 11:46.

## Slide 16: When to use which (11:46)
- Small corpus first: Anthropic's guidance says below about 200K tokens (roughly 500 pages) the whole knowledge base fits in the prompt, no RAG needed.
- LLM wiki for curated, recurring knowledge where one canonical value matters. RAG for large corpora, unforeseen questions, fresh documents.
- They complement each other: root map on top, wiki in the middle, retrieval over raw sources as the fallback. Recurring answers move up into the wiki.
- Anthropic describes Claude Code as exactly such a hybrid: CLAUDE.md up front, glob and grep just in time.


## Slide 17: Take it with you (11:51)
- Three codes: the repo, what I do, and where to say hello.
- The repo is the one that matters. The other two are for whoever wants to continue the conversation.
- Before 11:00: check that the repository is public, as the slide claims.
- Likely questions: several people editing one wiki and merge conflicts; permissions; ingest cost at scale; when to add embeddings; how this differs from a plain Obsidian vault.
- Close: an independent community resource. Thank the house team.

## Slide 19: Backup, why not just retrieval? (only on request)

Not part of the talk. Show it when someone asks how this compares to retrieval, then go back.

- Retrieval is strong where this pattern is weak: corpora far past the context window, questions nobody predicted, a new file indexed in seconds.
- Three things it gets wrong: chunk boundaries (a chunk that says revenue grew by 3% without naming company or quarter), no canonical fact (similarity ranking does not know which document is authoritative), contradictions side by side (Wang et al., COLM 2025: Llama 3.3 70B reached 32.6 exact match on RAMDocs).
- The fourth row is the practical side: no chunking strategy to tune, files I can read, Obsidian as the interface, running in an afternoon.
- If they push on hierarchy: RAPTOR embeds, clusters and summarises into a tree and reports +20 points on QuALITY with GPT-4. Evidence that summaries help, not that hierarchy beats vector search.
- End on: the two are not exclusive. Compile what matters, retrieve the rest.

## Slides 20 to 23: Fallback output (only if the live demo breaks)
- Use instead of slides 12 to 15, same talking points and timing.
- Each frame holds real prepared output from `docs/fallback/`, shortened to the decisive lines. Not a placeholder.
- Slide 20: the init result. The full wiki is also a folder, `docs/fallback/claude-house-wiki/`, so it can be opened in the editor and browsed page by page.
- Slide 21: the ingest summary, with the lead-time conflict highlighted.
- Slide 22: the lint report with the three findings.
- Slide 23: the fact sheet rows after the resolution, with the superseded value in the history table.
- A live demo is allowed to fail. Say so lightly, switch, and keep the timing.
