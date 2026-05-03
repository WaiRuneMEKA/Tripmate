#!/usr/bin/env bash
# Launch tmux session with 4 worker panes (B C D E) in 2x2 grid
# Instance A stays in Cursor — this script only spawns the workers
#
# Layout:
#   +----------+----------+
#   | pane 0   | pane 1   |
#   |   B      |   C      |
#   +----------+----------+
#   | pane 2   | pane 3   |
#   |   D      |   E      |
#   +----------+----------+
set -e

SESSION="tripmate"
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

if ! command -v tmux >/dev/null 2>&1; then
  echo "tmux not installed. Run: sudo apt install tmux" >&2
  exit 1
fi

if ! command -v claude >/dev/null 2>&1; then
  echo "claude CLI not installed. Install with: npm install -g @anthropic-ai/claude-code" >&2
  exit 1
fi

if tmux has-session -t "$SESSION" 2>/dev/null; then
  echo "Attaching to existing session '$SESSION'..."
  tmux attach -t "$SESSION"
  exit 0
fi

cd "$PROJECT_DIR"

CLAUDE_CMD='claude --dangerously-skip-permissions'

# pane 0 (top-left = B)
tmux new-session -d -s "$SESSION" -n workers "$CLAUDE_CMD"
# pane 1 (top-right = C)
tmux split-window -h -t "$SESSION:0.0" "$CLAUDE_CMD"
# pane 2 (bottom-left = D) — split pane 0 vertically
tmux split-window -v -t "$SESSION:0.0" "$CLAUDE_CMD"
# pane 3 (bottom-right = E) — split pane 1 vertically
tmux split-window -v -t "$SESSION:0.1" "$CLAUDE_CMD"

tmux select-layout -t "$SESSION:0" tiled
tmux select-pane -t "$SESSION:0.0"

tmux set -t "$SESSION" status-left "#[bold]Tripmate B|C|D|E #[default]"
tmux set -t "$SESSION" mouse on

tmux attach -t "$SESSION"
