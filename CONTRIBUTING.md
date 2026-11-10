# Contributing

Maintainer rules for this starter kit. They apply when you change the kit itself: content, skills, hooks, scripts. How Claude works inside the wiki is described in [CLAUDE.md](CLAUDE.md).

## Project

- **Purpose:** A starter kit for a plain-markdown LLM wiki that Claude reads like a well-kept filing cabinet: root map, canonical fact sheet, ingest and lint.
- **Session:** "Second Brain for Claude: Why It Forgets Your Company, and How to Fix It in a Folder", Claude Community House Barcelona, Monday 21 September 2026, 11:00 to 12:00, Auditorium
- **Visibility:** public. Every commit, issue and pull request can be read by anyone, so the content rules below apply to all of them.

## Structure

```text
README.md                 overview, quickstart, LLM wiki vs RAG
CLAUDE.md                 schema: how Claude works in the wiki
CONTRIBUTING.md           maintainer rules (this file)
LICENSE                   MIT license
root-map.md               router over all stores, printed at session start
company/COMPANY.md        fictional company profile (scenario, not a wiki source)
sources/inbox/            raw documents waiting for ingest
projects/sotarena/wiki/   project wiki: FACTS.md, index, log, entities, meetings, summaries, outputs, _originals
examples/claude-house/    three sources for the /wiki-init cold start, no wiki
docs/fallback/            outputs of earlier runs, to compare a run against
.claude/settings.json     hook wiring and one permission rule
.claude/skills/           wiki-init, wiki-ingest, wiki-lint, wiki-query
.claude/hooks/            SessionStart root map, PreToolUse privacy warning, tests
scripts/check_links.py    link, node-contract and structure checks
scripts/hooks/            pre-commit secret scan and its test
.github/workflows/        claude.yml: mention responder, a stage of the review fallback
.coderabbit.yaml          CodeRabbit review configuration
.gitignore                secrets, editor files, .claude/worktrees/
```

## Content rules

- English for everything participants see.
- No em-dash characters (U+2014). Use commas, colons or parentheses instead.
- No secrets, no client data, no real names of participants or customers.
- Plain markdown only: no vector database, no build step.
- The seeded sources and the pre-seeded wiki contain three deliberate findings (a contradiction, a duplicate, a stale fact). Do not fix them in `sources/`, in `_originals/` or in the wiki pages; they are the demo. The design is documented in the prepared outputs in `docs/fallback/`.
- Every fact you add must match `company/COMPANY.md`. Do not add facts to a source: each new fact can create a lint finding that nobody planned. The three planted findings are the documented exception, they are meant to disagree: the wiki keeps the old Quality Manager, S06 keeps the four-week lead time, and the powder coater appears under two names.

## Git workflow

Issue, branch, pull request, CodeRabbit review, squash merge. Never commit directly to `main`.

Every session works in its own worktree; the main checkout stays on `main`:

```bash
git worktree add -b feat/<NR>-<short> .claude/worktrees/<NR>-<short> origin/main
```

One worktree, one branch, one issue. Put `Closes #<NR>` in the pull request body and remove the worktree after the merge (`git worktree remove <path>`).

## Security

- Secrets live in `.env` (ignored by git) or 1Password, never in the repository.
- `scripts/hooks/pre-commit` scans staged files for secrets. Install it once per clone:
  `cp scripts/hooks/pre-commit .git/hooks/pre-commit && chmod +x .git/hooks/pre-commit`

## Checks before a pull request

```bash
python3 scripts/check_links.py
bash .claude/hooks/tests/run-tests.sh
shellcheck -S warning .claude/hooks/*.sh .claude/hooks/tests/run-tests.sh
```
