#!/bin/bash
# Claude Code session template

NUM=${1:-1}
MAX=${MAX_CLAUDE_SESSIONS:-4}

if [ "$NUM" -lt 1 ] || [ "$NUM" -gt "$MAX" ]; then
    echo "Usage: $0 [1-$MAX]"
    exit 1
fi

SESSION="claude-$NUM"

if tmux has-session -t $SESSION 2>/dev/null; then
    tmux attach -t $SESSION
    exit 0
fi

# Default to seacalendar for sessions 1-2, wishlist for 3-4
if [ "$NUM" -le 2 ]; then
    START_DIR="${PROJECT_SEACALENDAR:-/opt/seacalendar}"
    PROJECT="SeaCalendar"
else
    START_DIR="${PROJECT_WISHLIST:-/opt/wishlist}"
    PROJECT="Wishlist"
fi

tmux new-session -d -s $SESSION -n claude
cd "$START_DIR"

tmux send-keys -t $SESSION:0 "cd $START_DIR" C-m
tmux send-keys -t $SESSION:0 'clear' C-m
tmux send-keys -t $SESSION:0 "echo \"╔═══════════════════════════════════════════════╗\"" C-m
tmux send-keys -t $SESSION:0 "echo \"║   Claude Code Session #$NUM - $PROJECT   ║\"" C-m
tmux send-keys -t $SESSION:0 "echo \"╚═══════════════════════════════════════════════╝\"" C-m
tmux send-keys -t $SESSION:0 'echo ""' C-m
tmux send-keys -t $SESSION:0 'echo "Start Claude Code: claude"' C-m
tmux send-keys -t $SESSION:0 'echo ""' C-m
tmux send-keys -t $SESSION:0 "echo 'Switch projects:'" C-m
tmux send-keys -t $SESSION:0 "echo '  cd ${PROJECT_SEACALENDAR:-/opt/seacalendar}'" C-m
tmux send-keys -t $SESSION:0 "echo '  cd ${PROJECT_WISHLIST:-/opt/wishlist}'" C-m
tmux send-keys -t $SESSION:0 'echo ""' C-m

tmux attach -t $SESSION
