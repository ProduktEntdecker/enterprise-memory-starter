#!/usr/bin/env python3
"""Link and structure checks for this LLM wiki starter kit.

Usage:
  python3 scripts/check_links.py              validate the whole repository
  python3 scripts/check_links.py --lint WIKI  structural lint candidates for one wiki

Validation mode exits 1 on any error:
  - a relative markdown link does not resolve, or a link is absolute
  - a [[wikilink]] is used (this repo uses relative markdown links)
  - root-map.md or a wiki index.md misses a part of the node contract
  - a page of a wiki is not linked from that wiki's index.md
  - a page in entities/, summaries/ or meetings/ is an orphan
  - a text file contains the em-dash character (U+2014)

Lint mode always exits 0 (2 on a wrong path). It prints candidates for the
wiki-lint skill: broken links, missing index entries, orphan pages,
near-duplicate entity names and files waiting in sources/inbox/. The skill
verifies every candidate before it reports it.

Links inside fenced code blocks and inline code are ignored. Standard library
only; Python 3.8 or newer.
"""

import argparse
import difflib
import os
import re
import sys
import unicodedata
from pathlib import Path
from urllib.parse import unquote

ROOT = Path(__file__).resolve().parent.parent
SKIP_DIRS = {".git", "node_modules", ".venv", "__pycache__"}
BINARY_SUFFIXES = {".pdf", ".png", ".jpg", ".jpeg", ".gif", ".ico", ".zip", ".woff", ".woff2"}
EM_DASH = chr(0x2014)
CONTENT_FOLDERS = ("entities", "summaries", "meetings")
LEGAL_FORMS = {"sl", "sa", "srl", "lda", "gmbh", "ag", "bv", "ltd", "inc", "llc", "spa", "sas", "sarl", "plc"}

LINK_RE = re.compile(r"\]\(\s*<?([^()\s<>]+)>?(?:\s+\"[^\"]*\")?\s*\)")
WIKILINK_RE = re.compile(r"\[\[[^\]\n]+\]\]")
INLINE_CODE_RE = re.compile(r"`[^`\n]*`")
FENCE_RE = re.compile(r"^\s*(`{3,}|~{3,})")
SCHEME_RE = re.compile(r"^[A-Za-z][A-Za-z0-9+.-]*:")


def rel(path):
    try:
        return Path(path).resolve().relative_to(ROOT).as_posix()
    except ValueError:
        return str(path)


def read_text(path):
    return Path(path).read_text(encoding="utf-8")


def walk_files():
    for dirpath, dirnames, filenames in os.walk(ROOT):
        rel_dir = Path(dirpath).relative_to(ROOT).as_posix()
        dirnames[:] = sorted(
            d for d in dirnames
            if d not in SKIP_DIRS and not (rel_dir == ".claude" and d == "worktrees")
        )
        for name in sorted(filenames):
            yield Path(dirpath) / name


def prose_lines(text):
    """Yield (line_number, line) without fenced code blocks and inline code."""
    fence = None
    for number, line in enumerate(text.splitlines(), start=1):
        stripped = line.strip()
        if fence is None:
            match = FENCE_RE.match(line)
            if match:
                fence = match.group(1)
                continue
            yield number, INLINE_CODE_RE.sub("", line)
        elif stripped and set(stripped) == {fence[0]} and len(stripped) >= len(fence):
            fence = None


def links_in(path):
    for number, line in prose_lines(read_text(path)):
        for match in LINK_RE.finditer(line):
            yield number, match.group(1)


def resolve_link(source, target):
    """Return the resolved local path of a link, or None for external links and anchors."""
    if SCHEME_RE.match(target) or target.startswith("#"):
        return None
    clean = unquote(target.split("#", 1)[0].split("?", 1)[0])
    if not clean:
        return None
    return (Path(source).parent / clean).resolve()


def link_targets(path):
    targets = set()
    for _, target in links_in(path):
        if target.startswith("/"):
            continue
        dest = resolve_link(path, target)
        if dest is not None:
            targets.add(dest)
    return targets


def frontmatter(text):
    if not text.startswith("---\n"):
        return {}
    end = text.find("\n---", 4)
    if end == -1:
        return {}
    data = {}
    for line in text[4:end].splitlines():
        if ":" in line and not line.startswith((" ", "-", "#")):
            key, _, value = line.partition(":")
            data[key.strip()] = value.strip()
    return data


def unquote_value(value):
    return value.strip().strip('"').strip("'")


def parse_list(value):
    value = value.strip()
    if value.startswith("[") and value.endswith("]"):
        value = value[1:-1]
    return [unquote_value(item) for item in value.split(",") if unquote_value(item)]


def section(text, heading):
    match = re.search(r"^" + re.escape(heading) + r"[ \t]*$", text, re.M)
    if not match:
        return None
    rest = text[match.end():]
    following = re.search(r"^## (?!#)", rest, re.M)
    return rest[: following.start()] if following else rest


def contract_errors(path, is_root_map):
    text = "\n".join(line for _, line in prose_lines(read_text(path)))
    errors = []
    if not is_root_map and not re.search(r"^> Up: .*\]\(", text, re.M):
        errors.append("node contract: missing breadcrumb line '> Up: [parent](path)'")
    if not re.search(r"^\*\*Purpose:\*\* +\S", text, re.M):
        errors.append("node contract: missing '**Purpose:**' sentence")
    required = ["## Stores"] if is_root_map else ["## Rollup", "## Links down", "## Raw stores"]
    for heading in required:
        body = section(text, heading)
        if body is None:
            errors.append("node contract: missing section '%s'" % heading)
        elif heading in ("## Links down", "## Stores") and not LINK_RE.search(body):
            errors.append("node contract: section '%s' has no links" % heading)
    return errors


def wiki_roots():
    roots = []
    if (ROOT / "wiki" / "index.md").is_file():
        roots.append(ROOT / "wiki")
    projects = ROOT / "projects"
    if projects.is_dir():
        for project in sorted(projects.iterdir()):
            if (project / "wiki" / "index.md").is_file():
                roots.append(project / "wiki")
    return roots


def wiki_pages(wiki):
    pages = []
    for path in sorted(wiki.rglob("*.md")):
        parts = path.relative_to(wiki).parts
        if parts == ("index.md",) or parts[0] == "_originals" or any(p.startswith(".") for p in parts):
            continue
        pages.append(path)
    return pages


def structure_findings(wiki):
    """Return (pages missing from index.md, orphan pages) for one wiki."""
    indexed = link_targets(wiki / "index.md")
    pages = wiki_pages(wiki)
    missing = [page for page in pages if page.resolve() not in indexed]
    inbound = {page.resolve(): 0 for page in pages}
    for page in pages:
        parts = page.relative_to(wiki).parts
        if parts in (("log.md",),):
            continue
        for dest in link_targets(page):
            if dest in inbound and dest != page.resolve():
                inbound[dest] += 1
    orphans = [
        page for page in pages
        if page.relative_to(wiki).parts[0] in CONTENT_FOLDERS and inbound[page.resolve()] == 0
    ]
    return missing, orphans


def name_key(name):
    text = unicodedata.normalize("NFKD", name)
    text = "".join(c for c in text if not unicodedata.combining(c)).lower().replace(".", "")
    tokens = [t for t in re.split(r"[^a-z0-9]+", text) if t and t not in LEGAL_FORMS]
    tokens = [t[:-1] if len(t) > 3 and t.endswith("s") else t for t in tokens]
    return "".join(tokens)


def duplicate_candidates(wiki):
    folder = wiki / "entities"
    entities = sorted(folder.glob("*.md")) if folder.is_dir() else []
    labels = {}
    titles = {}
    for page in entities:
        meta = frontmatter(read_text(page))
        title = unquote_value(meta.get("title", "")) or page.stem
        titles[page] = title
        names = {page.stem.replace("-", " "), title}
        names.update(parse_list(meta.get("aliases", "")))
        labels[page] = {name_key(n) for n in names if name_key(n)}
    found = []
    for i, first in enumerate(entities):
        for second in entities[i + 1:]:
            shared = labels[first] & labels[second]
            if shared:
                found.append((first, second, "same normalised name '%s'" % sorted(shared)[0]))
                continue
            best = 0.0
            for a in labels[first]:
                for b in labels[second]:
                    if min(len(a), len(b)) >= 6:
                        best = max(best, difflib.SequenceMatcher(None, a, b).ratio())
            if best >= 0.9:
                found.append((first, second, "similar normalised names (ratio %.2f)" % best))
    return [(a, b, titles[a], titles[b], why) for a, b, why in found]


def em_dash_errors():
    errors = []
    for path in walk_files():
        if path.suffix.lower() in BINARY_SUFFIXES:
            continue
        try:
            text = path.read_text(encoding="utf-8")
        except (UnicodeDecodeError, OSError):
            continue
        for number, line in enumerate(text.splitlines(), start=1):
            if EM_DASH in line:
                errors.append("%s:%d: em-dash character (U+2014)" % (rel(path), number))
    return errors


def validate():
    errors = []
    markdown = [path for path in walk_files() if path.suffix == ".md"]
    link_count = 0
    for path in markdown:
        for number, line in prose_lines(read_text(path)):
            for match in WIKILINK_RE.finditer(line):
                errors.append("%s:%d: wikilink %s, use a relative markdown link" % (rel(path), number, match.group(0)))
            for match in LINK_RE.finditer(line):
                target = match.group(1)
                if target.startswith("/"):
                    errors.append("%s:%d: absolute link '%s', use a relative link" % (rel(path), number, target))
                    continue
                dest = resolve_link(path, target)
                if dest is None:
                    continue
                link_count += 1
                if not dest.exists():
                    errors.append("%s:%d: broken link '%s'" % (rel(path), number, target))

    root_map = ROOT / "root-map.md"
    if root_map.is_file():
        errors += ["root-map.md: %s" % e for e in contract_errors(root_map, True)]
    else:
        errors.append("root-map.md: missing")

    roots = wiki_roots()
    for wiki in roots:
        index = wiki / "index.md"
        errors += ["%s: %s" % (rel(index), e) for e in contract_errors(index, False)]
        missing, orphans = structure_findings(wiki)
        errors += ["%s: not linked from %s" % (rel(p), rel(index)) for p in missing]
        errors += ["%s: orphan page, no inbound link except index.md and log.md" % rel(p) for p in orphans]

    errors += em_dash_errors()

    print("check_links: %d markdown files, %d local links, %d wikis (%s)" % (
        len(markdown), link_count, len(roots), ", ".join(rel(w) for w in roots)))
    if errors:
        print("%d error(s):" % len(errors))
        for error in errors:
            print("  " + error)
        return 1
    print("OK: links resolve, node contracts complete, every page indexed, no orphans, no em-dash")
    return 0


def lint(wiki_arg):
    wiki = Path(wiki_arg)
    if not wiki.is_absolute():
        wiki = Path.cwd() / wiki if (Path.cwd() / wiki).is_dir() else ROOT / wiki
    wiki = wiki.resolve()
    if not (wiki / "index.md").is_file():
        print("check_links --lint: no index.md in %s" % wiki)
        return 2

    broken = []
    for page in sorted(wiki.rglob("*.md")):
        if "_originals" in page.relative_to(wiki).parts:
            continue
        for number, target in links_in(page):
            dest = None if target.startswith("/") else resolve_link(page, target)
            if target.startswith("/") or (dest is not None and not dest.exists()):
                broken.append("%s:%d: %s" % (rel(page), number, target))
    missing, orphans = structure_findings(wiki)
    duplicates = duplicate_candidates(wiki)
    inbox_dir = ROOT / "sources" / "inbox"
    inbox = sorted(p.name for p in inbox_dir.glob("*.md")) if inbox_dir.is_dir() else []

    print("Structural lint candidates for %s" % rel(wiki))
    print("Verify every candidate by reading the pages before reporting it.")
    print()
    print("Broken links (%d)" % len(broken))
    for item in broken:
        print("  - " + item)
    print("Missing index entries (%d)" % len(missing))
    for page in missing:
        print("  - " + rel(page))
    print("Orphan pages (%d)" % len(orphans))
    for page in orphans:
        print("  - " + rel(page))
    print("Near-duplicate entity names (%d)" % len(duplicates))
    for first, second, first_title, second_title, why in duplicates:
        print('  - %s "%s" <-> %s "%s": %s' % (rel(first), first_title, rel(second), second_title, why))
    print("Inbox, not yet ingested (%d)" % len(inbox))
    for name in inbox:
        print("  - sources/inbox/" + name)
    print()
    print("Semantic checks (contradictions, stale facts) are not covered here: compare FACTS.md with the pages.")
    return 0


def main():
    parser = argparse.ArgumentParser(description="Link and structure checks for the LLM wiki starter kit.")
    parser.add_argument("--lint", metavar="WIKI", help="print structural lint candidates for one wiki folder")
    args = parser.parse_args()
    if args.lint:
        return lint(args.lint)
    return validate()


if __name__ == "__main__":
    sys.exit(main())
