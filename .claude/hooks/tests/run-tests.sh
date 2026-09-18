#!/usr/bin/env bash
# Tests for the hooks in .claude/hooks/.
#
# Usage: bash .claude/hooks/tests/run-tests.sh
# Needs bash plus jq or python3. Exits 0 when every test passes.
#
# The fixtures in fixtures/ are hook inputs with placeholders. The private-data
# samples are assembled here at runtime, so the fixture files stay clean for
# secret and PII scanners such as scripts/hooks/pre-commit.

set -u

tests_dir="$(cd "$(dirname "$0")" && pwd)"
root="$(cd "$tests_dir/../../.." && pwd)"
hooks_dir="$root/.claude/hooks"
fixtures_dir="$tests_dir/fixtures"

at="@"
sample_email="jordi.vidal${at}sotarena.example"
sample_iban="ES12 3456 7890 ""1234 5678 9012"
sample_phone="+34 93 000 00 00"
sample_key="sk-ant-api03-$(printf 'A%.0s' {1..32})"
sample_secret="api""_key = $(printf 'x%.0s' {1..24})"

if command -v jq >/dev/null 2>&1; then
  json_tool="jq"
elif command -v python3 >/dev/null 2>&1; then
  json_tool="python3"
else
  echo "run-tests: needs jq or python3" >&2
  exit 2
fi

passed=0
failed=0
out=""
code=0

tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

ok() {
  passed=$((passed + 1))
  printf 'PASS  %s\n' "$1"
}

not_ok() {
  failed=$((failed + 1))
  printf 'FAIL  %s\n      %s\n' "$1" "$2"
}

# render FILE: print a fixture with its placeholders replaced.
render() {
  local text
  text="$(cat "$1")"
  text="${text//__ROOT__/$root}"
  text="${text//__EMAIL__/$sample_email}"
  text="${text//__IBAN__/$sample_iban}"
  text="${text//__PHONE__/$sample_phone}"
  text="${text//__APIKEY__/$sample_key}"
  text="${text//__SECRET__/$sample_secret}"
  printf '%s' "$text"
}

# run_hook HOOK INPUT_FILE PROJECT_DIR PARSER: sets the globals out and code.
run_hook() {
  local hook="$1" input_file="$2" project="$3" parser="$4" input
  case "$input_file" in
    *.json) input="$(render "$input_file")" ;;
    *) input="$(cat "$input_file")" ;;
  esac
  out="$(printf '%s' "$input" | CLAUDE_PROJECT_DIR="$project" PRIVACY_HOOK_PARSER="$parser" bash "$hooks_dir/$hook" 2>/dev/null)"
  code=$?
}

# is_warning OUTPUT NEEDLE: valid warning JSON that mentions NEEDLE and never blocks.
is_warning() {
  if [ "$json_tool" = "jq" ]; then
    printf '%s' "$1" | jq -e --arg needle "$2" '
      (.systemMessage | type == "string" and contains($needle))
      and .hookSpecificOutput.hookEventName == "PreToolUse"
      and (.hookSpecificOutput.additionalContext | type == "string" and length > 0)
      and ((.hookSpecificOutput | has("permissionDecision")) | not)
      and (has("decision") | not)' >/dev/null 2>&1
  else
    printf '%s' "$1" | python3 -c '
import json
import sys

try:
    data = json.load(sys.stdin)
except ValueError:
    sys.exit(1)
specific = data.get("hookSpecificOutput") or {}
valid = (
    sys.argv[1] in (data.get("systemMessage") or "")
    and specific.get("hookEventName") == "PreToolUse"
    and bool(specific.get("additionalContext"))
    and "permissionDecision" not in specific
    and "decision" not in data
)
sys.exit(0 if valid else 1)
' "$2"
  fi
}

# expect_silent NAME HOOK FIXTURE [PARSER]
expect_silent() {
  run_hook "$2" "$fixtures_dir/$3" "$root" "${4:-}"
  if [ "$code" -eq 0 ] && [ -z "$out" ]; then
    ok "$1"
  else
    not_ok "$1" "expected exit 0 and no output, got exit $code and: $out"
  fi
}

# expect_warning NAME HOOK FIXTURE PARSER NEEDLE...
expect_warning() {
  local name="$1" hook="$2" fixture="$3" parser="$4" needle missing=""
  shift 4
  run_hook "$hook" "$fixtures_dir/$fixture" "$root" "$parser"
  if [ "$code" -ne 0 ]; then
    not_ok "$name" "expected exit 0, got $code"
    return
  fi
  for needle in "$@"; do
    is_warning "$out" "$needle" || missing="$missing [$needle]"
  done
  if [ -z "$missing" ]; then
    ok "$name"
  else
    not_ok "$name" "no valid non-blocking warning for:$missing; output: $out"
  fi
}

# expect_no_value NAME HOOK FIXTURE PARSER CATEGORY VALUE...: a valid warning
# that names CATEGORY (label plus count) and repeats none of the VALUEs. Guards
# the rule that the hook reports what kind of data it found and how often, never
# the matching text, so private data does not travel into the context, the
# terminal and the logs. The failure message deliberately does not print the
# output, because that would leak the value it just caught.
expect_no_value() {
  local name="$1" hook="$2" fixture="$3" parser="$4" category="$5" value leaked=""
  shift 5
  run_hook "$hook" "$fixtures_dir/$fixture" "$root" "$parser"
  if [ "$code" -ne 0 ]; then
    not_ok "$name" "expected exit 0, got $code"
    return
  fi
  if ! is_warning "$out" "$category"; then
    not_ok "$name" "no valid non-blocking warning for [$category]"
    return
  fi
  for value in "$@"; do
    case "$out" in
      *"$value"*) leaked="yes" ;;
    esac
  done
  if [ -z "$leaked" ]; then
    ok "$name"
  else
    not_ok "$name" "the warning repeats the detected value (output withheld on purpose)"
  fi
}

# expect_contains NAME HOOK FIXTURE PROJECT_DIR NEEDLE
expect_contains() {
  run_hook "$2" "$fixtures_dir/$3" "$4" ""
  case "$out" in
    *"$5"*)
      if [ "$code" -eq 0 ]; then ok "$1"; else not_ok "$1" "expected exit 0, got $code"; fi
      ;;
    *) not_ok "$1" "output does not contain '$5' (exit $code)" ;;
  esac
}

echo "Hook tests in $root"
echo

# 1. Wiring in .claude/settings.json
settings="$root/.claude/settings.json"
settings_wired() {
  if [ "$json_tool" = "jq" ]; then
    jq -e '
      ([.hooks.SessionStart[].hooks[].command] | any(contains("session-start-root-map.sh")))
      and ([.hooks.PreToolUse[] | select(.matcher | test("Write") and test("Edit")) | .hooks[].command]
           | any(contains("warn-private-data.sh")))' "$settings" >/dev/null 2>&1
  else
    python3 -c '
import json
import sys

settings = json.load(open(sys.argv[1], encoding="utf-8"))
hooks = settings["hooks"]
start = any("session-start-root-map.sh" in h["command"] for e in hooks["SessionStart"] for h in e["hooks"])
pre = any(
    "warn-private-data.sh" in h["command"]
    for e in hooks["PreToolUse"]
    if "Write" in e.get("matcher", "") and "Edit" in e.get("matcher", "")
    for h in e["hooks"]
)
sys.exit(0 if start and pre else 1)
' "$settings" >/dev/null 2>&1
  fi
}
if settings_wired; then
  ok "settings.json parses and wires SessionStart and PreToolUse (Write|Edit)"
else
  not_ok "settings.json parses and wires SessionStart and PreToolUse (Write|Edit)" "check $settings"
fi

# 2. SessionStart
expect_contains "SessionStart prints the root map" \
  session-start-root-map.sh session-start-startup.json "$root" "# Root map"
expect_contains "SessionStart prints the loading hint" \
  session-start-root-map.sh session-start-startup.json "$root" "loaded by the SessionStart hook"
expect_contains "SessionStart without root-map.md prints a notice and exits 0" \
  session-start-root-map.sh session-start-startup.json "$tmp_dir" "root-map.md not found"

# 3. PreToolUse: warnings inside wiki folders
expect_warning "Write to project wiki with an e-mail address warns" \
  warn-private-data.sh pretool-write-project-wiki-email.json "" "E-mail address"
expect_warning "Edit in project wiki with an IBAN warns" \
  warn-private-data.sh pretool-edit-project-wiki-iban.json "" "IBAN"
expect_warning "Write to global wiki with an international phone number warns" \
  warn-private-data.sh pretool-write-wiki-phone.json "" "Phone number"
expect_warning "Write to global wiki with a labelled phone number warns" \
  warn-private-data.sh pretool-write-wiki-phone-labelled.json "" "Phone number after a label"
expect_warning "Write to global wiki with an API key warns" \
  warn-private-data.sh pretool-write-wiki-apikey.json "" "API key or token"
expect_warning "Write to global wiki with a secret assignment warns" \
  warn-private-data.sh pretool-write-wiki-secret-assignment.json "" "Secret assignment"
expect_warning "MultiEdit with e-mail and API key warns about both" \
  warn-private-data.sh pretool-multiedit-wiki-mixed.json "" "E-mail address" "API key or token"
expect_warning "Relative file path inside a project wiki warns" \
  warn-private-data.sh pretool-write-relative-path-email.json "" "E-mail address"
expect_warning "python3 parser path warns too" \
  warn-private-data.sh pretool-write-project-wiki-email.json python3 "E-mail address"

# 3b. PreToolUse: the warning never repeats the value it found
expect_no_value "E-mail warning names category and count, not the address" \
  warn-private-data.sh pretool-write-project-wiki-email.json "" "E-mail address: 1 match(es)" \
  "$sample_email" "${sample_email%%@*}" "${sample_email:0:6}"
expect_no_value "API key warning names category and count, not the key" \
  warn-private-data.sh pretool-write-wiki-apikey.json "" "API key or token: 1 match(es)" \
  "$sample_key" "${sample_key:0:6}"
expect_no_value "python3 parser path keeps the value out of the warning too" \
  warn-private-data.sh pretool-write-project-wiki-email.json python3 "E-mail address: 1 match(es)" \
  "$sample_email" "${sample_email:0:6}"

# 4. PreToolUse: silence
expect_silent "Realistic wiki content (IDs, prices, dates, ISO numbers) stays silent" \
  warn-private-data.sh pretool-write-wiki-clean.json
expect_silent "python3 parser path stays silent on clean content" \
  warn-private-data.sh pretool-write-wiki-clean.json python3
expect_silent "Write outside the wiki (docs/) stays silent" \
  warn-private-data.sh pretool-write-docs-email.json
expect_silent "Write to sources/inbox/ stays silent (raw sources are not wiki pages)" \
  warn-private-data.sh pretool-write-inbox-email.json
expect_silent "Absolute path to another project's wiki stays silent" \
  warn-private-data.sh pretool-write-other-project-wiki-email.json
expect_silent "Malformed hook input exits 0 without output" \
  warn-private-data.sh malformed-input.txt

# 5. No false positives on the real wiki pages and the prepared outputs
false_positives=""
checked=0
while IFS= read -r page; do
  [ -n "$page" ] || continue
  target="$root/projects/sotarena/wiki/summaries/fp-check.md"
  if [ "$json_tool" = "jq" ]; then
    jq -n --arg path "$target" --arg cwd "$root" --rawfile body "$page" \
      '{hook_event_name: "PreToolUse", cwd: $cwd, tool_name: "Write", tool_input: {file_path: $path, content: $body}}' \
      >"$tmp_dir/fp.txt"
  else
    python3 -c '
import json
import sys

body = open(sys.argv[3], encoding="utf-8").read()
print(json.dumps({"hook_event_name": "PreToolUse", "cwd": sys.argv[2], "tool_name": "Write",
                  "tool_input": {"file_path": sys.argv[1], "content": body}}))
' "$target" "$root" "$page" >"$tmp_dir/fp.txt"
  fi
  run_hook warn-private-data.sh "$tmp_dir/fp.txt" "$root" ""
  checked=$((checked + 1))
  if [ -n "$out" ] || [ "$code" -ne 0 ]; then
    false_positives="$false_positives ${page#"$root"/}"
  fi
done <<EOF
$(find "$root/wiki" "$root/projects" "$root/docs/fallback" "$root/root-map.md" -name '*.md' -type f | sort)
EOF
if [ -z "$false_positives" ] && [ "$checked" -gt 0 ]; then
  ok "No false positives on $checked existing wiki pages and prepared outputs"
else
  not_ok "No false positives on existing wiki pages" "warnings for:$false_positives (checked $checked)"
fi

echo
printf '%d passed, %d failed\n' "$passed" "$failed"
[ "$failed" -eq 0 ]
