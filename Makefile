CC=gcc


all: compilateur_CPYRR clean

compilateur_CPYRR: y.tab.c lex.yy.o
	$(CC) -Wall -o compilateur_CPYRR y.tab.c lex.yy.o -ly -ll
y.tab.c:
	yacc  -v -d grammaire_CPYRR.y -Wconflicts-rr
lex.yy.o:lex.yy.c
	$(CC) -c lex.yy.c
lex.yy.c:
	lex lex_CPYRR.l
clean:
	rm -f *.o *~ y.output y.tab.h lex.yy.c y.tab.c 


