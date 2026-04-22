#!/usr/bin/env bash
# .claude/lib/project_state.sh
# Shared helpers for reading project state from canonical config files.
# Source this file; do not execute it directly.

# get_engine [repo_root]
# Reads the engine value from .claude/docs/technical-preferences.md.
# Uses the dashed markdown format:  - **Engine**: <value>
# Prints the engine string, or empty string if not set / not configured.
# Sets ENGINE_CONFIGURED=true if a non-placeholder value was found.
get_engine() {
  local root="${1:-.}"
  local prefs="$root/.claude/docs/technical-preferences.md"
  ENGINE_CONFIGURED=false

  if [ ! -f "$prefs" ]; then
    return
  fi

  local engine_line
  engine_line=$(grep -m1 '^- \*\*Engine\*\*:' "$prefs" 2>/dev/null || true)

  if [ -z "$engine_line" ]; then
    return
  fi

  local value
  value=$(echo "$engine_line" | sed 's/^- \*\*Engine\*\*:[[:space:]]*//')

  if [ -n "$value" ] && ! echo "$value" | grep -q "TO BE CONFIGURED"; then
    echo "$value"
    ENGINE_CONFIGURED=true
  fi
}
