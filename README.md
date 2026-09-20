# Second Brain for Claude: LLM Wiki Starter

Materials for the session **"Second Brain for Claude: Why It Forgets Your Company, and How to Fix It in a Folder"** at the Claude Community House, Barcelona, Monday 21 September 2026, 11:00 to 12:00, Auditorium. Presented by Florian Steiner, Claude Community Ambassador Munich.

## What this is

A working LLM wiki in plain markdown for a fictional company, Sotarena S.L., that you open in Claude Code and use right away. Claude reads a small root map first, keeps one canonical value per fact, and maintains the wiki with skills: ingest turns a raw document into cited pages, lint reports contradictions, duplicates and stale facts without silently fixing them. There is no vector database and no build step, only folders, markdown files, a CLAUDE.md, four skills and two hooks.

## Quickstart (10 minutes)

**You need:** Claude Code, git, bash, and `jq` or `python3` for the hooks and the link checker. macOS or Linux; on Windows use WSL.

**1. Clone and open (1 minute)**

```bash
git clone https://github.com/ProduktEntdecker/enterprise-memory-starter.git
cd enterprise-memory-starter
claude
```

Trust the folder when Claude Code asks: the hooks in `.claude/settings.json` only run in trusted folders. The SessionStart hook loads `root-map.md` into the session.

**2. Ask a question (2 minutes)**

```text
What is Sotarena's standard lead time for stock colours, and who owns that number? Cite the pages you used.
```

Expect 6 weeks from order confirmation, owned by the Head of Operations, from FACTS.md row 1 (source S04). Watch the path: root map, project index, FACTS.md.

**3. Ingest a document (3 minutes)**

```text
/wiki-ingest sources/inbox/S06-talaverna-call-note.md
```

Expect a new page in `projects/sotarena/wiki/meetings/`, a new Talaverna Hotels entity, index and log entries, and a FACTS.md proposal. The call note says 4 weeks; Claude flags that as a conflict with FACTS.md instead of changing the fact. Approve only the rows you agree with.

**4. Lint the wiki (4 minutes)**

```text
/wiki-lint
```

Expect a report in `projects/sotarena/wiki/outputs/lint-<date>.md` with three findings: the lead-time contradiction, a duplicate supplier entity and a stale Quality Manager fact. Nothing changes until you say which findings to resolve.

**Next steps:** ingest `sources/inbox/S07-kornhagen-complaint.md`, try `/wiki-query who decides on the air freight for the delayed rope?`, or resolve a lint finding ("resolve finding 3").

## Start a wiki of your own

The four skills also cover the cold start. `examples/claude-house/sources/` holds three
public documents about the event this repository was built for, and no wiki:

```
/wiki-init examples/claude-house
```

It ingests the sources oldest first, builds `FACTS.md` from the claims it finds, records
the two capacity changes the sources declare themselves, and marks one row "needs
decision" because a source says a number exists without naming it. Then it lints.

The finished result is committed at `docs/fallback/claude-house-wiki/`, so you can compare
your run against it, or browse it without running anything.

**Start over:** these commands discard your local changes in the wiki folders.

```bash
git restore -- projects sources wiki root-map.md
git clean -fd -- projects sources wiki
```

## Folder map

```text
root-map.md                 router over all stores, printed at session start
CLAUDE.md                   schema: how Claude works in this wiki
CONTRIBUTING.md             rules for changing the kit
company/COMPANY.md          the fictional company (scenario for humans, not a wiki source)
sources/inbox/              raw documents waiting for ingest
wiki/                       global wiki: canonical fact, ingest, lint, LLM wiki vs RAG, ...
projects/sotarena/wiki/     project wiki
  index.md                  node: rollup, links down, source register
  FACTS.md                  canonical facts: fact, value, winning source, date, owner
  log.md                    append-only log of ingests and lint runs
  entities/                 people, organisations, products
  summaries/                one page per ingested document
  meetings/                 call notes and meeting minutes
  outputs/                  lint reports and filed answers
  _originals/               ingested raw documents, unchanged
.claude/skills/             wiki-init, wiki-ingest, wiki-lint, wiki-query
.claude/hooks/              SessionStart root map, PreToolUse privacy warning, tests
.claude/settings.json       hook wiring
scripts/check_links.py      link, node-contract and structure checks
docs/                       agenda, demo script, prepared fallback outputs
```

## LLM wiki vs RAG in one table

| | LLM wiki | RAG |
|---|---|---|
| Core idea | Compile knowledge once into cited pages and keep them current | Retrieve matching chunks at every question |
| Fits best | Curated, recurring knowledge: roles, prices, lead times, decisions, customers, suppliers | Large, long-tail corpora: all e-mails, tickets, manuals, contracts |
| Conflicting sources | Flagged at ingest, reported by lint, decided by the owner of the fact | Both versions can come back; ranking decides |
| One entity, two spellings | Merged into one page with an alias | Two unrelated chunks |
| Review and audit | Markdown in git, diffs a human can read | Index and embeddings are not human-readable |
| Main risk | Error compounding: a wrong page gets cited and looks confirmed | Confident but wrong answers from outdated or badly split chunks |
| How they combine | The compiled layer and router for recurring questions | The fallback for the long tail; good results get ingested into the wiki |

More detail is in the talk deck, which is not part of this repository.

## Prepared outputs

- [docs/fallback/](docs/fallback/): what a correct ingest and lint run produces, so the result can be read without running anything.

## For maintainers

Rules for changing the kit are in [CONTRIBUTING.md](CONTRIBUTING.md). Checks:

```bash
python3 scripts/check_links.py
bash .claude/hooks/tests/run-tests.sh
```

## Disclaimer

An independent community resource, built for the Claude Community House Barcelona.

Sotarena S.L. is fictional. Any resemblance to real companies or persons is coincidental.

## License

MIT, see [LICENSE](LICENSE). Clone it, fork it, put your own company in it, use it with clients. The example company and the prepared outputs are part of that.
