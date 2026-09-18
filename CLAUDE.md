# CLAUDE.md

How Claude works in this repository: a plain-markdown LLM wiki for the fictional company Sotarena S.L. This file is the schema of the wiki. Rules for changing the starter kit itself are in [CONTRIBUTING.md](CONTRIBUTING.md).

## Start of every session

1. The SessionStart hook prints [root-map.md](root-map.md) into your context. If you do not see it, read `root-map.md` first.
2. Pick one store from the root map. Do not scan the whole repository.

## Progressive loading

- Root map, then the `index.md` of one store, then only the pages you need.
- For numbers, dates, prices, lead times and names in roles, read `FACTS.md` before any other page.
- Open files in `_originals/` only to verify a quote.
- `company/COMPANY.md` and `docs/` are not knowledge sources. Do not use them to answer, ingest or lint. COMPANY.md describes the scenario for humans; docs/ holds the talk material and prepared outputs.

## Canonical facts

- **One canonical value per fact**, in `projects/<project>/wiki/FACTS.md`, with winning source, source date and owner.
- **Never overwrite a fact without a newer dated source.** That source must also be authoritative (from the owner of the fact, or explicitly replacing the older statement), and the user must approve the change. Newest alone is not enough.
- If a page and FACTS.md disagree, use the FACTS.md value, mention the conflict and suggest `/wiki-lint`.
- Old values move to the history table in FACTS.md. Nothing is silently overwritten.

## Answering questions

- Answer from the wiki, not from general knowledge.
- Cite every value with page path, source ID and source date, for example "FACTS.md row 1 (S04, 2026-08-03)".
- If the wiki does not know, say so and name the kind of source that would answer the question.

## Operations

| Task | Command | Skill |
|---|---|---|
| Add a document | `/wiki-ingest sources/inbox/<file>.md` | [wiki-ingest](.claude/skills/wiki-ingest/SKILL.md) |
| Health check | `/wiki-lint` | [wiki-lint](.claude/skills/wiki-lint/SKILL.md) |
| Answer with citations | `/wiki-query <question>` | [wiki-query](.claude/skills/wiki-query/SKILL.md) |

Plain language works too, for example "ingest the Talaverna call note".

## Ground rules

- **Raw sources are immutable.** Never edit files in `sources/inbox/` or `_originals/`. Ingest moves a file from the inbox to `_originals/` unchanged; that is not a deletion.
- **Ask before deleting** any file, and before merging or renaming pages.
- **Never silently fix.** Ingest proposes FACTS.md changes, lint writes a report, the user decides.
- **Stay in scope.** Problems you were not asked about get one line in your answer and a pointer to `/wiki-lint`.
- **Privacy:** no e-mail addresses, phone numbers, bank details or API keys in wiki pages. Name people by name and role. The PreToolUse hook warns when such data is about to be written.

## Page conventions

- **Project wiki folders:** `summaries/` one page per document, `meetings/` call notes and minutes, `entities/` people, organisations and products, `outputs/` generated reports, `_originals/` ingested raw documents, plus `FACTS.md`, `index.md` and `log.md`.
- **File names:** lowercase ASCII with hyphens (`garbi.md` for Garbí). Summary and meeting pages keep the file name of their source (`S04-capacity-and-lead-times.md`).
- **Frontmatter** on every page: `title`, `type` (index, log, canonical, summary, meeting, entity, output, concept), `status` (draft, reviewed, living), `created`, `updated`. Summary and meeting pages add `source_id`, `source_type`, `author`, `source_date`. Entity pages add `kind`, `aliases`, `sources`.
- **Breadcrumb** below the title: `> Up: [parent](relative path)`.
- **Links:** relative markdown links only, no wikilinks, so they work on GitHub, in editors and in `scripts/check_links.py`.
- **Dates:** `YYYY-MM-DD` in wiki pages. Quotes keep the format of the source. A source that carries only a month stays month-only in `source_date` (`YYYY-MM`), and a source without any date uses `unknown`. Never invent a day.
- **Source IDs:** S01, S02 and so on. The next free ID is the highest one in the source register or the inbox, plus one.
- **Every index.md follows the node contract:** `> Up:` breadcrumb, `**Purpose:**` sentence, `## Rollup`, `## Links down`, `## Raw stores`. See [node contract](wiki/concepts/node-contract.md).
- **log.md** is append-only. Entries start with `## [YYYY-MM-DD] operation | subject`.
- **Style:** plain English, short sentences, no em-dash character.

## Checks

- `python3 scripts/check_links.py`: links, node contract, index coverage, orphans, em-dash.
- `python3 scripts/check_links.py --lint projects/sotarena/wiki`: structural candidates for lint.
- `bash .claude/hooks/tests/run-tests.sh`: hook tests.
