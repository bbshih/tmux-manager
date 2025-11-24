#!/bin/bash
# Tmux Manager Installer

set -e

MANAGER_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "╔═══════════════════════════════════════════════╗"
echo "║   Installing Tmux Manager                     ║"
echo "╚═══════════════════════════════════════════════╝"
echo ""

# 1. Copy tmux config
echo "→ Installing tmux config..."
cp "$MANAGER_DIR/.tmux.conf" ~/.tmux.conf
echo "  ✓ ~/.tmux.conf"

# 2. Make scripts executable
echo "→ Making scripts executable..."
chmod +x "$MANAGER_DIR"/scripts/* "$MANAGER_DIR"/sessions/*
echo "  ✓ All scripts"

# 3. Add to PATH
SHELL_RC=""
if [ -f ~/.zshrc ]; then
    SHELL_RC=~/.zshrc
elif [ -f ~/.bashrc ]; then
    SHELL_RC=~/.bashrc
fi

if [ -n "$SHELL_RC" ]; then
    if ! grep -q "tmux-manager/scripts" "$SHELL_RC"; then
        echo "→ Adding to PATH in $SHELL_RC..."
        echo "" >> "$SHELL_RC"
        echo "# Tmux Manager" >> "$SHELL_RC"
        echo "export PATH=\"\$HOME/tmux-manager/scripts:\$PATH\"" >> "$SHELL_RC"
        echo "  ✓ PATH updated"
    else
        echo "  ✓ PATH already configured"
    fi
fi

# 4. Reload tmux if running
if tmux info &> /dev/null; then
    echo "→ Reloading tmux config..."
    tmux source ~/.tmux.conf
    echo "  ✓ Config reloaded"
fi

echo ""
echo "╔═══════════════════════════════════════════════╗"
echo "║   Installation Complete!                      ║"
echo "╠═══════════════════════════════════════════════╣"
echo "║                                               ║"
echo "║  CONFIGURE:                                  ║"
echo "║    Edit $MANAGER_DIR/config.sh"
echo "║    Set your project paths                     ║"
echo "║                                               ║"
echo "║  QUICK START:                                ║"
if [ -n "$SHELL_RC" ]; then
echo "║    source $SHELL_RC"
fi
echo "║    tm start      # Launch all sessions        ║"
echo "║    tm hub        # Attach to hub              ║"
echo "║                                               ║"
echo "║  COMMANDS:                                   ║"
echo "║    tm help       - Show all commands          ║"
echo "║    tm list       - List active sessions       ║"
echo "║                                               ║"
echo "╚═══════════════════════════════════════════════╝"
echo ""
