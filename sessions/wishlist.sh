#!/bin/bash
# Wishlist tmux session

SESSION="wishlist"
PROJECT_DIR="${PROJECT_WISHLIST:-/opt/wishlist}"

if tmux has-session -t $SESSION 2>/dev/null; then
    tmux attach -t $SESSION
    exit 0
fi

cd "$PROJECT_DIR"

tmux new-session -d -s $SESSION -n backend
tmux send-keys -t $SESSION:0 "cd $PROJECT_DIR/backend" C-m
tmux send-keys -t $SESSION:0 'clear && echo "=== Backend ===" && echo "" && echo "Start dev server: npm run dev" && echo "Build: npm run build" && echo ""' C-m

tmux new-window -t $SESSION:1 -n frontend
tmux send-keys -t $SESSION:1 "cd $PROJECT_DIR/frontend" C-m
tmux send-keys -t $SESSION:1 'clear && echo "=== Frontend ===" && echo "" && echo "Start dev server: npm run dev" && echo "Build: npm run build" && echo ""' C-m

tmux new-window -t $SESSION:2 -n database
tmux send-keys -t $SESSION:2 "cd $PROJECT_DIR" C-m
tmux send-keys -t $SESSION:2 'echo "Docker compose: docker-compose up -d"' C-m
tmux send-keys -t $SESSION:2 'echo "DB status:" && docker ps | grep wishlist || echo "Not running"' C-m

tmux new-window -t $SESSION:3 -n git
tmux send-keys -t $SESSION:3 "cd $PROJECT_DIR && clear && git status" C-m

tmux new-window -t $SESSION:4 -n test
tmux split-window -h -t $SESSION:4
tmux send-keys -t $SESSION:4.0 "cd $PROJECT_DIR/backend && echo 'Backend tests: npm test'" C-m
tmux send-keys -t $SESSION:4.1 "cd $PROJECT_DIR/frontend && echo 'Frontend tests: npm test'" C-m

tmux select-window -t $SESSION:0
tmux attach -t $SESSION
