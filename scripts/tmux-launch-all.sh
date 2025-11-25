#!/bin/bash
# Launch all tmux sessions at once

echo "╔═══════════════════════════════════════════════╗"
echo "║   Launching All Tmux Sessions                 ║"
echo "╚═══════════════════════════════════════════════╝"
echo ""

MANAGER_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SCRIPT_DIR="$MANAGER_DIR/scripts"
SESSION_DIR="$MANAGER_DIR/sessions"

# Load config
if [ -f "$MANAGER_DIR/config.sh" ]; then
    source "$MANAGER_DIR/config.sh"
fi

MAX=${MAX_CLAUDE_SESSIONS:-4}

start_detached() {
    local name=$1
    local script=$2

    if tmux has-session -t "$name" 2>/dev/null; then
        echo "  ⏭  $name (already running)"
    else
        echo "  ▶  Starting $name..."
        TMUX= "$script" &>/dev/null &
        # Reduced sleep from 2s to 0.5s for faster startup
        sleep 0.5
        if tmux has-session -t "$name" 2>/dev/null; then
            echo "  ✓  $name ready"
        else
            echo "  ✗  $name failed"
        fi
    fi
}

start_detached "hub" "$SCRIPT_DIR/tmux-hub.sh"
start_detached "seacal" "$SESSION_DIR/seacalendar.sh"
start_detached "wishlist" "$SESSION_DIR/wishlist.sh"
start_detached "claude-1" "$SESSION_DIR/claude.sh 1"
start_detached "claude-2" "$SESSION_DIR/claude.sh 2"

echo ""
echo "╔═══════════════════════════════════════════════╗"
echo "║   All Sessions Running!                       ║"
echo "╠═══════════════════════════════════════════════╣
║                                                           ║
║  ATTACH TO A SESSION:                        ║
║    tm hub       - Control center              ║
║    tm seacal    - SeaCalendar dev             ║
║    tm wishlist  - Wishlist dev                ║
║    tm claude 1  - Claude Code #1              ║
║    tm claude 2  - Claude Code #2              ║
║                                                           ║
║  SWITCH SESSIONS (inside tmux):              ║
║    Ctrl+A then 0 = Hub                        ║
║    Ctrl+A then 1 = SeaCalendar                ║
║    Ctrl+A then 2 = Wishlist                   ║
║    Ctrl+A then 3 = Claude #1                  ║
║    Ctrl+A then 4 = Claude #2                  ║
║                                                           ║
║  DETACH: Ctrl+A then D                        ║
║                                                           ║
╚═══════════════════════════════════════════════════════════╝"
echo ""
echo "Run: tm hub"
