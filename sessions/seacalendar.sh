#!/bin/bash
# SeaCalendar tmux session

SESSION="seacal"
PROJECT_DIR="${PROJECT_SEACALENDAR:-/opt/seacalendar}"

if tmux has-session -t $SESSION 2>/dev/null; then
    tmux attach -t $SESSION
    exit 0
fi

cd "$PROJECT_DIR"

tmux new-session -d -s $SESSION -n services
tmux send-keys -t $SESSION:0 'clear && echo "=== SeaCalendar Services ===" && echo "" && echo "Start dev server: npm run dev" && echo "Build: npm run build" && echo "Test: npm test" && echo ""' C-m

tmux new-window -t $SESSION:1 -n database
tmux split-window -v -t $SESSION:1
tmux send-keys -t $SESSION:1.0 "cd $PROJECT_DIR && echo 'Prisma Studio: npm run db:studio'" C-m
tmux send-keys -t $SESSION:1.1 "cd $PROJECT_DIR && echo 'DB commands: db:migrate:dev, db:seed, db:reset'" C-m

tmux new-window -t $SESSION:2 -n git
tmux send-keys -t $SESSION:2 "cd $PROJECT_DIR && clear && git status" C-m

tmux new-window -t $SESSION:3 -n test
tmux split-window -v -t $SESSION:3
tmux send-keys -t $SESSION:3.0 "cd $PROJECT_DIR && echo 'Unit tests: npm test'" C-m
tmux send-keys -t $SESSION:3.1 "cd $PROJECT_DIR && echo 'E2E tests: npm run test:e2e'" C-m

tmux new-window -t $SESSION:4 -n logs
tmux send-keys -t $SESSION:4 "cd $PROJECT_DIR && echo 'Monitor logs here...'" C-m

tmux select-window -t $SESSION:0
tmux attach -t $SESSION
