# Speaker notes: Second Brain for Claude: Why It Forgets Your Company, and How to Fix It in a Folder

Claude Community House Barcelona, Monday 21 September 2026, 11:00 to 12:00, Auditorium. Intermediate level. Speaker: Florian Steiner, Claude Community Ambassador Munich.

Timeline: 11:00 map problem (5) · 11:05 the LLM wiki pattern (17) · 11:22 live demo (19) · 11:41 what to take home, credits, repo (5) · 11:46 Q&A (14).

This talk is about the wiki. Retrieval appears twice in the main flow, as the left half of the pipeline on slide 4 and as the bottom layer on slide 12, each in one line. The detail, what retrieval is good at and where it loses context, sits on backup slide 15 and is only shown if someone asks.

Sources for every claim below are listed in SOURCES.md. "Own observation" marks statements without an external source.

---

## Slide 1: Title (11:00)
- Handzeichen: wer hat Claude etwas übersehen sehen, das in den eigenen Dateien lag?
- Versprechen: warum der Agent das Aufgeschriebene nicht findet, die vier Moves, Starter-Repo zum Mitnehmen
- Demo 11:22, Fragen ab 11:46

## Slide 2: The anecdote (11:01)
- Mein CxO-Agent kannte mein Geburtsdatum nicht
- Steht als eine Zeile in `identity.md`, founder-Ordner, seit Monaten
- Er hat nicht schlecht gesucht, er kannte den Ordner nicht
- Datum selbst nicht nennen, keine Kundennamen

## Slide 3: Not a memory problem, a map problem (11:03)
- Reflex: größeres Modell, mehr Memory. Trifft es nicht
- Kontext ist endlich, jeder Token kostet Aufmerksamkeit (Anthropic)
- Also kuratieren, nicht alles reinschütten
- Ich selbst habe in derselben Session eine Dublette angelegt: Designfehler, nicht Disziplinfehler
- Brücke: wann passiert die Arbeit, bei jeder Frage oder einmal beim Ingest? Das ist der ganze Unterschied

## Slide 4: Retrieve every time, or compile once (11:05)
- Karpathy: bei RAG entdeckt das Modell alles bei jeder Frage neu, nichts wächst
- Das Wiki ist ein bleibendes Artefakt, das mit jeder Quelle dichter wird
- Der Unterschied ist das Wann: Fragezeit oder Ingest-Zeit
- Zwei Schleifen: Lint hält es ehrlich, gute Antworten wandern als neue Seite zurück
- Ehrlich sagen: RAG habe ich selbst nie produktiv aufgesetzt, nur im Kurs
- Was für mich zählt: keine Chunking-Strategie, ich kann jede Seite lesen, Obsidian ist die Oberfläche, ein Nachmittag Aufwand
- Jetzt die vier Moves

## Slide 5: Move 1, root map (11:09)
- Eine kurze Datei, lädt beim Sessionstart
- Nur Zeiger und Einzeiler, nie der Inhalt selbst
- Genau das Just-in-time-Muster von Anthropic, so lädt Claude Code auch CLAUDE.md
- Mein Setup generisch: Root-Map zeigt auf Stores, je Projekt ein Wiki mit Faktenblatt
- Meetings und Kundenstatus bleiben bewusst in ihren eigenen Werkzeugen, nicht alles wandert ins Wiki
- Regel: wird die Karte ein Aufsatz, ist sie keine Karte mehr

## Slide 6: Move 2, canonical fact sheet (11:13)
- Bewusst entscheiden, wo welche Art Fakt wohnt
- Andere Seiten verlinken hierher, sie kopieren nie
- Jeder Wert mit Quelle und Datum, damit Veraltetes sichtbar wird
- Die vier Zeilen sind echt, aus meinem Faktenblatt zu dieser Veranstaltung
- Die durchgestrichene Zeile ist der Venue-Name aus der frühen Planung, der nicht mehr gilt
- Deshalb kann ich die Raumnummer noch richtig sagen, während sie sich zweimal geändert hat

## Slide 7: Move 3, ingest (11:16)
- Quelle nach `sources/inbox/`, wird nie editiert, Original danach nach `_originals/`
- Das LLM schreibt Summary, Entities, Faktenblatt, Index und Log
- Eine Quelle berührt 10 bis 15 Seiten
- Karpathys eigenes Wiki: rund 100 Artikel, 400K Wörter, navigiert über Indexseiten
- S06 liegt noch in der Inbox, genau die Quelle lesen wir gleich live ein
- Trade-off ehrlich nennen: Tokens einmal vorn statt bei jeder Frage

## Slide 8: Move 4, lint (11:19)
- Karpathys Liste: Widersprüche, veraltete Behauptungen, Waisen
- Dubletten habe ich ergänzt: dieselbe Sache in zwei Schreibweisen
- Ehrliches Risiko: LLM-Seiten sehen autoritativ aus
- Ohne Lint wird ein falscher Fakt zurückgeschrieben und wieder zitiert
- Der Lint ist ein Skill im Repo, keine Magie, er darf nichts stillschweigend reparieren
- Jetzt live

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
- Slide 16: the ingest summary, with the lead-time conflict highlighted. A real screenshot from the rehearsal can replace the text block later.
- Slide 17: the lint report with the three findings. A real screenshot from the rehearsal can replace the text block later.
- Slide 18: the fact sheet rows after the resolution, with the superseded value in the history table. A real screenshot from the rehearsal can replace the text block later.
