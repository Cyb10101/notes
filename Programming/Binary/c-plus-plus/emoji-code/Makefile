all: clean emoji-code
	@echo ''

emoji-code: emoji-code.cpp
	cat emoji-code.cpp | perl convert-emoji.pl > emoji-code_bin.cpp
	g++ -finput-charset=UTF-8 -fextended-identifiers -o emoji-code emoji-code_bin.cpp
	@rm emoji-code_bin.cpp

clean:
	@rm -f emoji-code emoji-code_bin.cpp

install: all
	@echo Are you kidding'??'
