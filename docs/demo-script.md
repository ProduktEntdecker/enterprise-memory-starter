# Demo script: ingest, then lint

Run sheet for the live demo in "Second Brain for Claude: Why It Forgets Your Company, and How to Fix It in a Folder", Claude Community House Barcelona, Monday 21 September 2026, 11:00. Goal: the audience watches one document being ingested and a lint run that reports a contradiction, a duplicate and a stale fact, and understands why each one matters.

## 1. Design: what is pre-seeded, what happens live

| Source | Title | Source date | State before the demo | Role in the demo |
|---|---|---|---|---|
| S01 | Board memo Q2 2026 | 2026-07-09 | ingested | background facts |
| S02 | Garbí stackable armchair: product sheet | 2026-03 | ingested | background facts |
| S03 | Price list 2026 | 2026-01-12 | ingested | background facts |
| S04 | Capacity and lead times after summer | 2026-08-03 | ingested | canonical lead time of 6 weeks; spelling "Color-Vall Coating" |
| S05 | Delivery update PO-26-1184 | 2026-09-18 | ingested | background facts |
| S06 | Call with Talaverna Hotels | 2026-09-10 | **inbox** | **live ingest**: brings the 4-week statement |
| S07 | Complaint: Mistral lounge chairs | 2026-09-19 | inbox | exercise for participants after the talk |
| S08 | Organisation chart 2026 | 2026-01-15 | ingested | Quality Manager Jaume Rius in FACTS.md |
| S09 | Change in Quality Management | 2026-05-28 | ingested | successor Irene Casado, never reconciled with FACTS.md |
| S10 | Approved supplier list | 2026-09-01 | ingested | spelling "Colorvall Coatings S.L." |

### Where the three findings come from

| # | Kind | How it is built | Why lint finds it reliably | Correct resolution |
|---|---|---|---|---|
| F1 | Contradiction | **Live.** S06 says "standard lead time is 4 weeks". FACTS.md row 1 says 6 weeks, winning source S04, owner Head of Operations. | The ingest skill records claims as stated and marks the lead time as "conflict" in the FACTS.md check table of the new page. Lint compares every FACTS.md row with every page. | Keep 6 weeks. S06 is newer but not from the owner and does not replace S04. Never resolve by date. Correct the statement to the customer. |
| F2 | Duplicate | **Pre-seeded.** The S04 ingest created `entities/color-vall-coating.md`, the S10 ingest created `entities/colorvall-coatings-sl.md`. FACTS.md rows 3 and 23 use both names. | Both files sit side by side in `entities/`. `check_links.py --lint` reports them with the same normalised name `colorvallcoating`. | Merge into Colorvall Coatings S.L. (SUP-0417) with the alias "Color-Vall Coating". |
| F3 | Stale fact | **Pre-seeded.** FACTS.md row 9 and `entities/jaume-rius.md` still name Jaume Rius (S08, 2026-01-15). S09 was ingested in the same batch, but its FACTS.md check says "not checked". | S09 is newer, comes from HR (the owner of role facts) and says explicitly that it replaces the organisation chart entry. The Irene Casado page states the succession. | Irene Casado since 2026-06-01 (S09). Jaume Rius becomes former Quality Manager until 2026-05-31. |

**Story for the audience:** the wiki was started in August 2026 with a batch ingest of older documents and has grown since. Nobody has linted it yet. That is normal.

**Why S06 is the live source:** it is newer than the canonical source and still wrong. That is the lesson a retrieval pipeline cannot learn by itself: newest is not always right, the owner decides. S06 also adds a fact of its own (the Talaverna order), so the audience sees one source lose one fact and win another.

**Why the other two findings are pre-seeded:** a single live ingest cannot create a duplicate and a stale fact without also tempting Claude to fix them during ingest. Pre-seeding makes lint the step that finds them, which is the point of the demo.

## 2. Before the session

- [ ] Fresh clone in a short path, for example `~/stage/enterprise-memory-starter`. Do not demo from a checkout with local changes.
- [ ] `python3 scripts/check_links.py` prints OK and `bash .claude/hooks/tests/run-tests.sh` reports 0 failed.
- [ ] `python3 scripts/check_links.py --lint projects/sotarena/wiki` shows one near-duplicate pair and two inbox files.
- [ ] Start `claude` in the folder once, trust it, and check that `/wiki-ingest`, `/wiki-lint` and `/wiki-query` appear in the slash menu. Quit and start again, so the demo session begins clean.
- [ ] Use the model you rehearsed with. Large terminal font, window wide enough for tables.
- [ ] Switch to accept-edits mode (Shift+Tab) before the ingest, so that page writes do not prompt. Only `python3 scripts/check_links.py` is pre-approved in `.claude/settings.json`; anything else still asks, so the ingest stops once for a permission prompt when it moves the source out of the inbox. Approve it and narrate it: raw sources move, they are never edited.
- [ ] **`examples/claude-house/wiki/` must not exist.** wiki-init refuses to overwrite an existing wiki, so a leftover from the rehearsal kills part A. Check with `ls examples/claude-house`.
- [ ] Open `docs/fallback/S06-talaverna-call-note.md`, `docs/fallback/lint-2026-09-21.md` and the folder `docs/fallback/claude-house-wiki/` in editor tabs, ready to switch.
- [ ] Rehearse once end to end and write the real durations into the run sheet.
- [ ] Reset after the rehearsal:

```bash
git restore -- projects sources wiki root-map.md
git clean -fd -- projects sources wiki examples
git status
```

`git status` must report a clean working tree. The cleanup must include
`examples`, otherwise the wiki created during the rehearsal stays behind and
part A cannot run again.

## 3. Run sheet (18 minutes, 11:28 to 11:46)

Two wikis in one demo. The small one is created from scratch, the large one has been
running since August. Say that out loud when you switch, or the room will think the
first wiki grew in four minutes.

### Part A: init, from nothing (slide 12, from 11:28)

| Clock | Step | Type exactly | Say | Expected | Rehearsed |
|---|---|---|---|---|---|
| 11:28 | Show the folder | `ls examples/claude-house/sources` | "Three public documents about this event. The programme, the room list, the rules for hosts. No wiki." | Three files, C01 to C03 | |
| 11:29 | Init | `/wiki-init examples/claude-house` | "One command. It reads oldest first, so the history comes out in the right order." | See 4.0 | |
| 11:30 | Confirm | `yes` | "It asks before it writes. Three sources, nine to twelve pages, and nothing on disk yet. The pause is the point: I approve the run, not each page." | Skeleton created, then the pages appear one by one | |
| 11:31 | Read the result | open `FACTS.md` | "Two capacities changed and the source says so itself, so both land in the history table. And two rows it refuses to fill. The second one is the interesting one: 96 seats plus 20 percent is 115.2, and no source says how to round it. So it does not round." | 12 rows, 2 marked needs decision, 3 without an owner | |

**The line to land in part A:** a wiki that admits what it does not know is worth more
than one that guesses. Then switch.

### Part B: a wiki that has run for a month (slides 13 to 15, from 11:32)

| Clock | Slide | Step | Type exactly | Say | Expected | Rehearsed |
|---|---|---|---|---|---|---|
| 11:32 | 13 | Orientation | nothing, show the file tree | "Same structure, one month older. A hook loads the root map at session start." | Tree with `root-map.md`, `projects/sotarena/wiki/`, `sources/inbox/` | |
| 11:33 | 13 | Question | `What is Sotarena's standard lead time for stock colours, and who owns that number? Cite the pages you used.` | "Watch the path: map, index, facts. No search index, no chunks." | 6 weeks from order confirmation; FACTS.md row 1; S04, 2026-08-03; owner Head of Operations | |
| 11:34 | 13 | Ingest | `/wiki-ingest sources/inbox/S06-talaverna-call-note.md` | "A sales call note from last week, newer than the operations memo. What does the wiki do with it?" | See 4.1 | |
| 11:36 | 13 | Approve | `Apply the two Talaverna rows only. Do not change the lead time.` | "Ingest proposes, I decide. The lead time stays until its owner decides." | FACTS.md rows 27 and 28 added, row 1 unchanged | |
| 11:37 | 14 | Lint | `/wiki-lint` | "The health check. Lint reports; it never fixes silently." | See 4.2 | |
| 11:39 | 14 | Walk the report | open the report file | F1: "Newest is not right, the owner decides." F2: "Only an entity check catches this; retrieval returns two separate chunks." F3: "An explicit succession note makes date-based supersession safe." | Report with three findings | |
| 11:42 | 15 | Resolve one | `Resolve the stale Quality Manager finding only.` | "One approval, one change, and it is logged." | FACTS.md row 9 becomes Irene Casado (S09), the old value moves to the history table, log entry added | |
| 11:44 | 15 | Fact sheet | open `FACTS.md` | "Resolved once, in one place. Every other page links here." | Winning value with source and date, old value in the history table | |
| 11:45 | 15 | Close | nothing | "Everything you saw is in the repo. Clone it and run the same four steps." | Hand over to slide 16 at 11:46 | |

**Why clock times and not offsets:** the slides carry `data-minute` and the speaker
notes carry the same times. A second system of offsets meant the two drifted apart,
which a review caught. One value per fact applies to this run sheet too.

**Short on time, in this order:** drop the question at 11:33, then the resolve step at
11:42, then part A entirely. Ingest and lint alone fit into eleven minutes.

**A live demo is allowed to fail.** Say so lightly, switch to the fallback slide, keep
the timing. Slide 20 covers part A, slides 21 to 23 cover part B, and the full init
result is a folder you can open and browse: `docs/fallback/claude-house-wiki/`.

## 4. Expected output

### 4.0 Init of examples/claude-house

```
Wiki for claude-house: 3 sources found, 2026-09-13 to 2026-09-19.
Proposed structure: entities/, summaries/, meetings/, outputs/, _originals/
Expected pages: about 9 to 12
Start?
```

After confirmation:

```
Wiki created: examples/claude-house/wiki
Pages: 3 summaries, 4 entities
FACTS.md: 12 rows, 2 marked "needs decision", 3 without an owner
Supersessions recorded: 2
   Room 4 capacity      20 -> 25 seats
   Workshops area      120 -> 96 seats
Needs decision: how to round a derived ticket cap (96 plus 20 percent is 115.2)
                how many API credit redemptions the link accepts
Then: lint, 3 findings. Nothing changed.
```

The exact wording will differ. What must appear: the two supersessions, the two rows
marked "needs decision", and the fact that nothing was invented to fill them.
The rounding row is the one to point at: two of the three rooms divide evenly,
so only the third one reveals that somebody would have had to decide.

### 4.1 Ingest of S06

The wording differs between runs. These elements must be there:

```text
Ingest: S06 Call with Talaverna Hotels
-> Page: projects/sotarena/wiki/meetings/S06-talaverna-call-note.md
-> Entities: created Talaverna Hotels, Andreu Font; updated Garbí
-> FACTS.md proposals:
   add       Talaverna Palma rooftop: 60 Garbí sets, opening 2026-10-30 (S06, 2026-09-10)
   add       Talaverna Hotels revenue 2025: EUR 1.9 million (S06, 2026-09-10)
   conflict  Standard lead time: S06 says 4 weeks; FACTS.md row 1 says 6 weeks (S04, owner Head of Operations). No change.
-> Index and log updated; original moved to projects/sotarena/wiki/_originals/S06-talaverna-call-note.md
```

Prepared page: [fallback/S06-talaverna-call-note.md](fallback/S06-talaverna-call-note.md).

**Acceptable variations:** the page lands in `summaries/` instead of `meetings/`; Beatriz Lozano gets her own entity page; only one of the two "add" proposals; Claude mentions the Colorvall spellings as "noticed, not caused by this source".

**Not acceptable:** FACTS.md row 1 changes to 4 weeks. If that happens, say "Stop. That is exactly the mistake: the newest source is not the owner," and run `git checkout -- projects/sotarena/wiki/FACTS.md`.

### 4.2 Lint

```text
Report: projects/sotarena/wiki/outputs/lint-2026-09-21.md
1. Contradiction (High): standard lead time 6 weeks (FACTS.md row 1, S04) vs 4 weeks (S06 call note)
2. Duplicate entity (Medium): Color-Vall Coating vs Colorvall Coatings S.L. (SUP-0417)
3. Stale fact (High): Quality Manager Jaume Rius (S08) superseded by Irene Casado from 2026-06-01 (S09)
Orphans 0, missing index entries 0, broken links 0. Inbox: 1 file (S07).
Which findings should I resolve?
```

Order, numbering and severity can differ. Prepared report: [fallback/lint-2026-09-21.md](fallback/lint-2026-09-21.md).

## 5. If Claude finds something extra

First sentence, whatever it is: "Good. A linter is a reviewer, not an oracle. Let's triage: planted, real, or noise?"

| Extra finding | What it is | What to say |
|---|---|---|
| S07 still in the inbox | True, informational | "That one is your homework." |
| Air freight confirmation for PO-26-1184 due 2026-09-21, 16:00 | True, and it is today | "The wiki knows a deadline is today. Lint is not a task manager, but that is a great question for a query." |
| Quote to Talaverna was due 2026-09-14, no record of it | True open question | "Exactly what the page lists as an open question. The wiki knows what it does not know." |
| Jaume Rius and Irene Casado both "Quality Manager", also reported as a contradiction | Same issue as F3 | "Same finding seen twice. It is stale rather than contradictory, because S09 explicitly replaces the old entry." |
| Gross margin 31.8% vs 34.0% | Different periods (H1 2026 vs 2025) | "Different periods. A good reviewer checks the dates." |
| Warranty known only for the Garbí armchair; job titles such as "Sales" or "Design" look vague | Data gaps | "Gaps, not errors. The next source fills them." |
| A fact that appears in no wiki page | Claude used knowledge from outside the wiki | "Where does that come from? Cite it." Good moment for the citation rule |
| F1 labelled "stale" and resolved towards 4 weeks | Wrong | "This is the key point: newest is not right. Operations owns the lead time." Show the prepared report |

## 6. If something goes wrong

| Problem | Fix on stage |
|---|---|
| Slash command not found | Plain language: "Use the wiki-ingest skill on sources/inbox/S06-talaverna-call-note.md" |
| Root map not in context (hook did not run) | "Read root-map.md first." Afterwards check that the folder is trusted |
| Claude edits FACTS.md without asking | "Stop. Show me the diff." Then `git checkout -- projects/sotarena/wiki/FACTS.md` |
| A run takes longer than 4 minutes | Switch to the prepared files in `docs/fallback/` and narrate |
| The privacy hook shows a warning | Read it out: "That is the second hook. It warns, it does not block." |
| Network or model outage | Walk through `docs/fallback/` and the concept pages: [canonical fact](../wiki/concepts/canonical-fact.md), [ingest](../wiki/concepts/ingest.md), [lint](../wiki/concepts/lint.md) |

## 7. After the demo

Leave the stage clone as it is to show the diff in the Q&A (`git status`, `git diff projects/sotarena/wiki/FACTS.md`), then reset it with the commands in section 2.
