#!/usr/bin/env bash
# Register a session_id to an instance label (A/B/C)
set -euo pipefail

session_id=""
instance=""

while [ $# -gt 0 ]; do
    case "$1" in
        -s|--session-id) session_id="${2:-}"; shift 2;;
        -i|--instance) instance="${2:-}"; shift 2;;
        -h|--help)
            echo "Usage: register.sh -s <session-id> -i <A|B|C>"
            exit 0
            ;;
        *) echo "Unknown arg: $1" >&2; exit 1;;
    esac
done

if [ -z "$session_id" ] || [ -z "$instance" ]; then
    echo "Usage: register.sh -s <session-id> -i <A|B|C>" >&2
    exit 1
fi

if [[ ! "$instance" =~ ^[ABC]$ ]]; then
    echo "Instance must be A, B, or C (got: $instance)" >&2
    exit 1
fi

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
registry="$script_dir/../registry.json"

[ ! -f "$registry" ] && echo '{}' > "$registry"

tmp=$(mktemp)
jq --arg sid "$session_id" --arg inst "$instance" '
  with_entries(select(.value != $inst)) + {($sid): $inst}
' "$registry" > "$tmp" && mv "$tmp" "$registry"

echo "Registered session $session_id as instance $instance"
exit 0
