#!/bin/bash
# Hub - Control center for all tmux sessions

SESSION="hub"
MANAGER_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Load config
if [ -f "$MANAGER_DIR/config.sh" ]; then
    source "$MANAGER_DIR/config.sh"
fi

SEACAL_DIR="${PROJECT_SEACALENDAR:-/opt/seacalendar}"
WISHLIST_DIR="${PROJECT_WISHLIST:-/opt/wishlist}"

if tmux has-session -t $SESSION 2>/dev/null; then
    tmux attach -t $SESSION
    exit 0
fi

cd /opt

tmux new-session -d -s $SESSION -n dashboard

tmux send-keys -t $SESSION:0 'clear' C-m
tmux send-keys -t $SESSION:0 'cat << "EOF"
╔═══════════════════════════════════════════════════════════╗
║        🌊 TMUX SESSION MANAGER - CONTROL HUB 🎁           ║
╠═══════════════════════════════════════════════════════════╣
║                                                           ║
║  QUICK NAVIGATION (no prefix needed):                    ║
║    Alt+1, Alt+2, Alt+3 = Switch windows                  ║
║                                                           ║
║  SESSION SHORTCUTS (Ctrl+A then number):                 ║
║    0 = Hub (this)                                        ║
║    1 = SeaCalendar Dev                                   ║
║    2 = Wishlist Dev                                      ║
║    3 = Claude #1                                         ║
║    4 = Claude #2                                         ║
║                                                           ║
║  START SESSIONS:                                         ║
║    tm seacal    - SeaCalendar dev environment            ║
║    tm wishlist  - Wishlist dev environment               ║
║    tm claude N  - Start Claude session N (1-4)           ║
║    tm list      - List all sessions                      ║
║                                                           ║
║  TMUX BASICS:                                            ║
║    Ctrl+A then D - Detach (keeps running)                ║
║    Ctrl+A then [ - Scroll mode (q to exit)               ║
║    Ctrl+A then R - Reload config                         ║
║    Ctrl+A then | - Split vertical                        ║
║    Ctrl+A then - - Split horizontal                      ║
║                                                           ║
╚═══════════════════════════════════════════════════════════╝
EOF
' C-m

tmux new-window -t $SESSION:1 -n projects
tmux split-window -h -t $SESSION:1

tmux send-keys -t $SESSION:1.0 "cd $SEACAL_DIR" C-m
tmux send-keys -t $SESSION:1.0 'echo "=== SEACALENDAR ===" && git status -sb && echo && echo "Recent commits:" && git log --oneline -5' C-m

tmux send-keys -t $SESSION:1.1 "cd $WISHLIST_DIR" C-m
tmux send-keys -t $SESSION:1.1 'echo "=== WISHLIST ===" && git status -sb && echo && echo "Recent commits:" && git log --oneline -5' C-m

if [ "${HUB_SHOW_HTOP:-true}" = "true" ] || [ "${HUB_SHOW_DOCKER:-true}" = "true" ]; then
    tmux new-window -t $SESSION:2 -n monitor
    tmux split-window -v -t $SESSION:2

    if [ "${HUB_SHOW_HTOP:-true}" = "true" ]; then
        tmux send-keys -t $SESSION:2.0 'htop' C-m
    fi

    if [ "${HUB_SHOW_DOCKER:-true}" = "true" ]; then
        tmux send-keys -t $SESSION:2.1 'watch -n 3 "docker ps --format \"table {{.Names}}\t{{.Status}}\t{{.Ports}}\" 2>/dev/null || echo \"No containers running\""' C-m
    fi
fi

tmux new-window -t $SESSION:3 -n term
tmux send-keys -t $SESSION:3 "cd $SEACAL_DIR" C-m

tmux select-window -t $SESSION:0
tmux attach -t $SESSION
