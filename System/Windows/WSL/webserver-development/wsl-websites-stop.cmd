@echo off

wsl -d Ubuntu -e bash -c "cd '/mnt/c/Users/Username/Desktop/projects/website_www'; ./start.sh down"

wsl -d Ubuntu -e bash -c "cd ~/projects/global; ./start.sh down"

timeout 5
