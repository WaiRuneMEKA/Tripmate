#!/usr/bin/env bash
# SessionStart hook — inject session_id and instance role into context
set -euo pipefail

input=$(cat)
[ -z "$input" ] && exit 0

session_id=$(printf '%s' "$input" | jq -r '.session_id // empty' 2>/dev/null || true)
[ -z "$session_id" ] && exit 0

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
registry="$script_dir/../registry.json"

instance=""
if [ -f "$registry" ]; then
    instance=$(jq -r --arg sid "$session_id" '.[$sid] // empty' "$registry" 2>/dev/null || true)
fi

if [ -n "$instance" ]; then
    context="[Multi-instance] You are registered as instance $instance. Your inbox is .claude/inbox/$instance.md — messages from sibling instances will be auto-injected at the end of each turn via the Stop hook."
else
    context="[Multi-instance setup needed]
Session ID: $session_id

This session is not yet registered. The user runs three Claude Code instances (A/B/C) in parallel — see CLAUDE_INSTANCES.md.

When the user tells you which instance you are (e.g. \"you are A\", \"register as B\", \"นายชื่อ A\"), run this command via the Bash tool to register yourself:

  bash .claude/scripts/register.sh -s $session_id -i <A|B|C>

After registration, the inbox at .claude/inbox/<X>.md will route messages to you via the Stop hook."
fi

jq -nc --arg ctx "$context" '{
  hookSpecificOutput: {
    hookEventName: "SessionStart",
    additionalContext: $ctx
  }
}'
exit 0
