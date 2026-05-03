#!/usr/bin/env bash
# Stop hook — pull pending message from this instance's inbox and inject it
set -euo pipefail

input=$(cat)
[ -z "$input" ] && exit 0

session_id=$(printf '%s' "$input" | jq -r '.session_id // empty' 2>/dev/null || true)
[ -z "$session_id" ] && exit 0

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
registry="$script_dir/../registry.json"

[ ! -f "$registry" ] && exit 0

instance=$(jq -r --arg sid "$session_id" '.[$sid] // empty' "$registry" 2>/dev/null || true)
[ -z "$instance" ] && exit 0

inbox="$script_dir/../inbox/$instance.md"
[ ! -f "$inbox" ] && exit 0

content=$(cat "$inbox")
[ -z "$(printf '%s' "$content" | tr -d '[:space:]')" ] && exit 0

rm -f "$inbox"

reason="📬 ข้อความใหม่ (instance ${instance}):

${content}

ทำตามคำสั่งข้างบน"

jq -nc --arg reason "$reason" '{decision:"block", reason:$reason}'
exit 0
