all: clean app
	@echo ''

app: app.cpp
	g++ -static -o app app.cpp

clean:
	@if [ -f app ]; then rm app; fi

install: all
	@echo 'Are you kidding??'
