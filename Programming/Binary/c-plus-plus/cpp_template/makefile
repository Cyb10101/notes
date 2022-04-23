all: clean app app.exe
	@echo "\033[0;32mTask 'all' is done!\033[0m"
	@echo ''

app: app.cpp
	@echo "\033[0;32mCompile for Linux...\033[0m"
	g++ -static -std=c++17 -o app app.cpp

app.exe: app.cpp
	@if [ -f app ]; then echo "\033[0;32mCompile for Windows...\033[0m"; fi
	if [ -f app ]; then x86_64-w64-mingw32-g++ -static -std=c++17 -o app.exe app.cpp; fi

clean:
	@echo "\033[0;33mCleanup files...\033[0m"
	@if [ -f app ]; then rm app; fi
	@if [ -f app.exe ]; then rm app.exe; fi

install: all
	@echo "\033[0;31mInstall application...\033[0m"
	@echo "Disabled! Use: sudo install app /usr/local/bin/app"
