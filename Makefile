CC=gcc


all: compilateur_CPYRR clean

compilateur_CPYRR: y.tab.c lex.yy.o
	$(CC) -o exp1 y.tab.c lex.yy.o -ly -ll
y.tab.c:
	yacc -v -d grammaire_CPYRR.y
lex.yy.o:lex.yy.c
	$(CC) -c lex.yy.c
lex.yy.c:
	lex lex_CPYRR.l
clean:
	rm -f *.o *~ y.output y.tab.h lex.yy.c y.tab.c


