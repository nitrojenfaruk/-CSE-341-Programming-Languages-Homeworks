all:
	yacc -o gpp_interpreter.c -d gpp_interpreter.y
	flex -o gpp_lexer.c gpp_lexer.l
	cc gpp_lexer.c gpp_interpreter.c -o part1
clean:
	rm gpp_lexer.out