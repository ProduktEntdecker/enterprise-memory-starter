# CLAUDE.md

Guidance for Claude Code in this repository.

## Project

- **Purpose:** A starter kit for a plain-markdown LLM wiki that Claude reads like a well-kept filing cabinet: root map, canonical fact sheet, ingest and lint.
- **Session:** "Second Brain for Claude: LLM Wiki vs RAG", Claude Community House Barcelona, Monday 21 September 2026, 11:00 to 12:00, Auditorium
- **Visibility:** private. It becomes public only after Florian explicitly approves it, shortly before the session.

## Structure

```text
README.md          overview, quick start, LLM wiki vs RAG
docs/agenda.html   session agenda with timeline (print to PDF)
docs/agenda.pdf    exported agenda
company/           fictional example company (planned)
sources/           raw source documents to ingest (planned)
wiki/              root map, canonical fact sheet, entities, concepts (planned)
.claude/skills/    ingest and lint skills (planned)
scripts/hooks/     pre-commit secret scan
```

## Content rules

- English for everything participants see.
- No em-dash characters (U+2014). Use commas, colons or parentheses instead.
- No secrets, no client data, no real names of participants or customers.
- Plain markdown only: no vector database, no build step.
- The seeded sources contain three deliberate findings (a contradiction, a duplicate, a stale fact). Do not fix them in `sources/`; they are the demo.

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
