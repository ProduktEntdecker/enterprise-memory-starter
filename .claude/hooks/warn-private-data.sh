#!/usr/bin/env bash
# PreToolUse hook for Write, Edit and MultiEdit.
#
# Warns, never blocks, when new content for a wiki page contains patterns of
# private data: e-mail addresses, IBANs, phone numbers, API keys and secrets.
# Scope: wiki/** and projects/*/wiki/** inside the project directory.
#
# On a hit it prints JSON with two fields and exits 0:
#   systemMessage                         the warning, shown to the user
#   hookSpecificOutput.additionalContext  the same warning, for Claude
# It sets no permissionDecision, so the normal permission flow continues.
#
# Needs jq or python3 to read the hook input; without both it stays silent.
# PRIVACY_HOOK_PARSER=python3 forces the python3 code path (used by the tests).
# Regular expressions are POSIX ERE with bracket classes, so they work with
# BSD grep on macOS and GNU grep on Linux.

set -u

input="$(cat)"

parser="${PRIVACY_HOOK_PARSER:-}"
if [ -z "$parser" ]; then
  if command -v jq >/dev/null 2>&1; then
    parser="jq"
  elif command -v python3 >/dev/null 2>&1; then
    parser="python3"
  else
    exit 0
  fi
fi

# field NAME: print file_path, cwd or content (all new text) from the input.
field() {
  if [ "$parser" = "jq" ]; then
    case "$1" in
      file_path) printf '%s' "$input" | jq -r '.tool_input.file_path // empty' 2>/dev/null ;;
      cwd) printf '%s' "$input" | jq -r '.cwd // empty' 2>/dev/null ;;
      content)
        printf '%s' "$input" | jq -r '
          [ .tool_input.content, .tool_input.new_string, ((.tool_input.edits // [])[] | .new_string?) ]
          | map(select(type == "string")) | join("\n")' 2>/dev/null
        ;;
    esac
  else
    printf '%s' "$input" | python3 -c '
import json
import sys

try:
    data = json.load(sys.stdin)
except ValueError:
    sys.exit(0)
if not isinstance(data, dict):
    sys.exit(0)
tool_input = data.get("tool_input")
if not isinstance(tool_input, dict):
    tool_input = {}
name = sys.argv[1]
if name == "file_path":
    value = tool_input.get("file_path")
elif name == "cwd":
    value = data.get("cwd")
else:
    parts = [tool_input.get("content"), tool_input.get("new_string")]
    edits = tool_input.get("edits")
    if isinstance(edits, list):
        parts += [edit.get("new_string") for edit in edits if isinstance(edit, dict)]
    value = "\n".join(part for part in parts if isinstance(part, str))
sys.stdout.write(value if isinstance(value, str) else "")
' "$1" 2>/dev/null
  fi
}

file_path="$(field file_path)"
[ -n "$file_path" ] || exit 0

project_dir="${CLAUDE_PROJECT_DIR:-}"
[ -n "$project_dir" ] || project_dir="$(field cwd)"
project_dir="${project_dir%/}"

rel_path="$file_path"
if [ -n "$project_dir" ]; then
  case "$file_path" in
    "$project_dir"/*) rel_path="${file_path#"$project_dir"/}" ;;
  esac
fi
rel_path="${rel_path#./}"

case "$rel_path" in
  /*) exit 0 ;;
  wiki/* | projects/*/wiki/*) ;;
  *) exit 0 ;;
esac

content="$(field content)"
[ -n "$content" ] || exit 0

findings=""

# scan LABEL CASE REGEX: CASE is "i" (ignore case) or "s" (case-sensitive).
scan() {
  local label="$1" case_flag="$2" regex="$3" matches count sample
  if [ "$case_flag" = "i" ]; then
    matches="$(printf '%s\n' "$content" | LC_ALL=C grep -Eio -e "$regex" 2>/dev/null)"
  else
    matches="$(printf '%s\n' "$content" | LC_ALL=C grep -Eo -e "$regex" 2>/dev/null)"
  fi
  [ -n "$matches" ] || return 0
  count="$(printf '%s\n' "$matches" | wc -l | tr -d '[:space:]')"
  sample="$(printf '%s\n' "$matches" | head -n 1 | sed -e 's/^[^[:alnum:]+-]*//' | cut -c1-6)"
  findings="${findings}- ${label}: ${count} match(es), the first starts with \"${sample}...\""$'\n'
}

scan "E-mail address" s '[[:alnum:]._%+-]+@[[:alnum:]-]+([.][[:alnum:]-]+)*[.][[:alpha:]]{2,}'
scan "IBAN" s '(^|[^[:alnum:]])[A-Z]{2}[0-9]{2}( ?[A-Z0-9]{4}){2,7}( ?[A-Z0-9]{1,4})?'
scan "Phone number" s '[+][0-9]{2,3}[ ./()-]*[0-9]([ ./()-]*[0-9]){7,}'
scan "Phone number after a label" i '(^|[^[:alpha:]])(phone|tel|telephone|mobile|cell)[.:]?[[:space:]]*[0-9(][0-9 ./()-]{7,}'
scan "API key or token" s '(sk-ant-[[:alnum:]_-]{20,}|(^|[^[:alnum:]])sk-[[:alnum:]_-]{20,}|AKIA[0-9A-Z]{16}|gh[pousr]_[[:alnum:]]{36}|github_pat_[[:alnum:]_]{22,}|glpat-[[:alnum:]_-]{20,}|xox[abprs]-[[:alnum:]-]{10,}|AIza[[:alnum:]_-]{35}|-----BEGIN [A-Z ]*PRIVATE KEY-----)'
scan "Secret assignment" i '(api[_-]?key|secret|token|password)[^[:alnum:][:space:]]?[[:space:]]*[:=][[:space:]]*[^[:alnum:][:space:]]?[[:alnum:]_./+-]{16,}'

[ -n "$findings" ] || exit 0

message="Privacy check (warning, not blocking): the new content for ${rel_path} contains possible private data.
${findings}Wiki pages name people by name and role only, without contact details, bank details or keys. Remove the data unless it is fictional test data or a deliberate exception."

if [ "$parser" = "jq" ]; then
  jq -n --arg msg "$message" \
    '{systemMessage: $msg, hookSpecificOutput: {hookEventName: "PreToolUse", additionalContext: $msg}}'
else
  python3 -c '
import json
import sys

message = sys.argv[1]
print(json.dumps({
    "systemMessage": message,
    "hookSpecificOutput": {"hookEventName": "PreToolUse", "additionalContext": message},
}))
' "$message"
fi

exit 0
