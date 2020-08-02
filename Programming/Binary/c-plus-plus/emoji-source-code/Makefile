all: clean emoji-source-code
	@echo ''

emoji-source-code: emoji-source-code.cpp
	cat emoji-source-code.cpp | perl convert-emoji.pl > emoji-source-code_bin.cpp
	g++ -finput-charset=UTF-8 -fextended-identifiers -o emoji-source-code emoji-source-code_bin.cpp
	@rm emoji-source-code_bin.cpp

clean:
	@rm -f emoji-source-code emoji-source-code_bin.cpp

install: all
	@echo Are you kidding'??'
