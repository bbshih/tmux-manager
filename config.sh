#!/bin/bash
# Tmux Manager Configuration
# Edit this file to add your projects

# Project paths
export PROJECT_SEACALENDAR="/opt/seacalendar"
export PROJECT_WISHLIST="/opt/wishlist"

# Add more projects here:
# export PROJECT_MYAPP="/opt/myapp"

# Session configuration
export MAX_CLAUDE_SESSIONS=4

# Hub configuration (disabled by default for better VPS performance)
# Set to true to enable resource monitoring (increases CPU/memory usage)
export HUB_SHOW_HTOP=false
export HUB_SHOW_DOCKER=false
