#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PASS=true

# --- Expected counts ---
EXPECTED_AGENTS=49
EXPECTED_SKILLS=72
EXPECTED_HOOKS=12
EXPECTED_RULES=11
EXPECTED_TEMPLATES=38

fail() {
  echo "FAIL: $1"
  PASS=false
}

# --- Inventory counts ---
AGENTS=$(find "$REPO_ROOT/.claude/agents" -maxdepth 1 -name "*.md" | wc -l | tr -d ' ')
SKILLS=$(find "$REPO_ROOT/.claude/skills" -mindepth 1 -maxdepth 1 -type d | wc -l | tr -d ' ')
HOOKS=$(find "$REPO_ROOT/.claude/hooks" -maxdepth 1 -type f | wc -l | tr -d ' ')
RULES=$(find "$REPO_ROOT/.claude/rules" -maxdepth 1 -type f | wc -l | tr -d ' ')
TEMPLATES=$(find "$REPO_ROOT/.claude/docs/templates" -type f | wc -l | tr -d ' ')

echo "Inventory counts:"
echo "  agents:    $AGENTS (expected $EXPECTED_AGENTS)"
echo "  skills:    $SKILLS (expected $EXPECTED_SKILLS)"
echo "  hooks:     $HOOKS (expected $EXPECTED_HOOKS)"
echo "  rules:     $RULES (expected $EXPECTED_RULES)"
echo "  templates: $TEMPLATES (expected $EXPECTED_TEMPLATES)"

[ "$AGENTS" -eq "$EXPECTED_AGENTS" ]    || fail "agents: found $AGENTS, expected $EXPECTED_AGENTS"
[ "$SKILLS" -eq "$EXPECTED_SKILLS" ]    || fail "skills: found $SKILLS, expected $EXPECTED_SKILLS"
[ "$HOOKS" -eq "$EXPECTED_HOOKS" ]      || fail "hooks: found $HOOKS, expected $EXPECTED_HOOKS"
[ "$RULES" -eq "$EXPECTED_RULES" ]      || fail "rules: found $RULES, expected $EXPECTED_RULES"
[ "$TEMPLATES" -eq "$EXPECTED_TEMPLATES" ] || fail "templates: found $TEMPLATES, expected $EXPECTED_TEMPLATES"

# --- Public doc consistency checks ---
check_count_in_doc() {
  local label="$1"
  local file="$2"
  local pattern="$3"
  if ! grep -qE "$pattern" "$file" 2>/dev/null; then
    fail "$label count not found in $file (pattern: $pattern)"
  fi
}

echo ""
echo "Checking public doc consistency..."

check_count_in_doc "agents=49"    "$REPO_ROOT/README.md"                        "49"
check_count_in_doc "skills=72"    "$REPO_ROOT/README.md"                        "72"
check_count_in_doc "hooks=12"     "$REPO_ROOT/README.md"                        "12"
check_count_in_doc "rules=11"     "$REPO_ROOT/README.md"                        "11"
check_count_in_doc "templates=38" "$REPO_ROOT/README.md"                        "38"
check_count_in_doc "agents=49"    "$REPO_ROOT/docs/REPO-FACTS.md"               "49"
check_count_in_doc "skills=72"    "$REPO_ROOT/docs/REPO-FACTS.md"               "72"
check_count_in_doc "templates=38" "$REPO_ROOT/docs/REPO-FACTS.md"               "38"
check_count_in_doc "skills=72"    "$REPO_ROOT/.claude/docs/skills-reference.md" "72"

# --- Final result ---
echo ""
if [ "$PASS" = true ]; then
  echo "All checks passed. Inventory and public docs are consistent."
  exit 0
else
  echo "One or more checks failed. See output above."
  exit 1
fi
