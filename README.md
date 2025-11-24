# Tmux Manager

Universal tmux session manager for multi-project remote development. Optimized for mobile (iPhone) and desktop (MacBook) workflows via SSH/Tailscale.

## Features

- **Multi-Project Support**: Manage multiple projects from one interface
- **Session Persistence**: Sessions survive disconnects and reboots
- **Mobile-Friendly**: Optimized keyboard shortcuts for Termius/mobile terminals
- **Quick Switching**: Jump between sessions with `Ctrl+A` + number
- **Project-Agnostic**: Easy to add new projects via config file
- **Claude Code Integration**: Pre-configured Claude Code sessions per project

## Quick Start

```bash
# 1. Install
cd ~/tmux-manager
./install.sh

# 2. Configure your projects
nano config.sh

# 3. Reload shell
source ~/.bashrc  # or ~/.zshrc

# 4. Launch all sessions
tm start

# 5. Attach to hub
tm hub
```

## Project Structure

```
tmux-manager/
├── config.sh           # Project paths and settings
├── .tmux.conf          # Tmux configuration
├── install.sh          # One-command installer
├── scripts/
│   ├── tm              # Main command interface
│   ├── tmux-hub.sh     # Control center session
│   └── tmux-launch-all.sh  # Batch session launcher
├── sessions/
│   ├── seacalendar.sh  # SeaCalendar dev session
│   ├── wishlist.sh     # Wishlist dev session
│   └── claude.sh       # Claude Code sessions
└── README.md
```

## Configuration

Edit `config.sh` to set your project paths:

```bash
# Project paths
export PROJECT_SEACALENDAR="/opt/seacalendar"
export PROJECT_WISHLIST="/opt/wishlist"
export PROJECT_MYAPP="/path/to/myapp"

# Session settings
export MAX_CLAUDE_SESSIONS=4
export HUB_SHOW_HTOP=true
export HUB_SHOW_DOCKER=true
```

## Commands

### Launch Sessions
```bash
tm start        # Launch all sessions at once
tm hub          # Control center (monitoring + navigation)
tm seacal       # SeaCalendar development
tm wishlist     # Wishlist development
tm claude 1     # Claude Code session #1
tm claude 2     # Claude Code session #2
```

### Manage Sessions
```bash
tm list         # List all active sessions
tm kill NAME    # Kill specific session
tm kill all     # Kill all sessions
```

## Keyboard Shortcuts

### Switch Sessions (inside tmux)
- `Ctrl+A` then `0` = Hub
- `Ctrl+A` then `1` = SeaCalendar
- `Ctrl+A` then `2` = Wishlist
- `Ctrl+A` then `3` = Claude #1
- `Ctrl+A` then `4` = Claude #2

### Switch Windows (no prefix needed!)
- `Option+1` through `Option+5` = Jump to window 1-5
- (Alt+1-5 on non-Mac keyboards)

### Split Panes
- `Ctrl+A` then `|` = Split vertical
- `Ctrl+A` then `-` = Split horizontal

### Navigation
- `Option+Arrow` = Switch panes (no prefix)
- `Ctrl+A` then `H/J/K/L` = Resize panes

### Essential
- `Ctrl+A` then `D` = Detach (session keeps running)
- `Ctrl+A` then `[` = Scroll mode (press `q` to exit)
- `Ctrl+A` then `R` = Reload config

## Workflows

### iPhone (Termius) - Single Terminal

```bash
# 1. SSH via Tailscale
ssh user@server

# 2. Launch everything (only needed once)
tm start

# 3. Attach to hub
tm hub

# 4. Switch sessions
Ctrl+A then 0-4

# 5. Detach when done (keeps running)
Ctrl+A then D

# 6. Reconnect later
ssh user@server && tm hub
```

### MacBook - Multi-Terminal

**Terminal 1:**
```bash
tm hub
```

**Terminal 2:**
```bash
tm seacal
```

**Terminal 3:**
```bash
tm claude 1
```

**Terminal 4:**
```bash
tm claude 2
```

## Adding New Projects

### 1. Add to config.sh
```bash
export PROJECT_MYAPP="/path/to/myapp"
```

### 2. Create session script
```bash
cp sessions/seacalendar.sh sessions/myapp.sh
# Edit myapp.sh to customize
```

### 3. Update tm script
```bash
nano scripts/tm
# Add case for myapp
```

### 4. Update launch-all.sh (optional)
```bash
nano scripts/tmux-launch-all.sh
# Add start_detached "myapp" "$SESSION_DIR/myapp.sh"
```

## Terminal Compatibility

**✅ Recommended:**
- iTerm2 (Mac)
- Terminal.app (Mac built-in)
- Ghostty (fast, native)
- Termius (iPhone/remote)

**⚠️ Issues:**
- Warp (conflicts with tmux)
- VS Code terminal (keybinding conflicts)

## Troubleshooting

**Sessions not switching:**
```bash
# Reload config
tmux source ~/.tmux.conf
# Or: Ctrl+A then R
```

**Alt/Option key not working:**
- Termius: Settings → Keyboard → Enable "Option as Meta"
- iTerm2: Preferences → Profiles → Keys → Left/Right Option as Esc+

**Config not loading:**
```bash
# Check PATH
echo $PATH | grep tmux-manager

# Reload shell
source ~/.bashrc
```

**Orphaned sessions:**
```bash
# List all
tm list

# Kill specific
tm kill session-name

# Kill all and restart
tm kill all
tm start
```

## License

MIT

## Contributing

Add your project sessions to `sessions/` directory and submit a PR!
