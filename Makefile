default: 
	bison -d -y bison.y
	flex flex.l
	gcc -c y.tab.c lex.yy.c
	gcc y.tab.o lex.yy.o -o parser

