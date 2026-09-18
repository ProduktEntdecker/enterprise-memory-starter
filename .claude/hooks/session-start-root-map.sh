#!/usr/bin/env bash
# SessionStart hook: print root-map.md so every session starts with the map.
#
# Claude Code adds the plain stdout of a SessionStart hook to Claude's context.
# The hook never blocks a session and always exits 0.

set -u

# The hook input (JSON on stdin) is not needed. Drain it when it is piped.
if [ ! -t 0 ]; then
  cat >/dev/null
fi

project_dir="${CLAUDE_PROJECT_DIR:-}"
if [ -z "$project_dir" ]; then
  project_dir="$(cd "$(dirname "$0")/../.." && pwd)"
fi
root_map="${project_dir%/}/root-map.md"

if [ -r "$root_map" ]; then
  printf '%s\n\n' "Root map of this repository, loaded by the SessionStart hook. Start here: open the index of one store, then only the pages you need. The rules are in CLAUDE.md."
  cat "$root_map"
else
  printf '%s\n' "SessionStart hook: root-map.md not found in ${project_dir}. Read CLAUDE.md for orientation."
fi

exit 0
