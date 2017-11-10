CC=gcc


all: compilateur_CPYRR clean

compilateur_CPYRR: y.tab.c lex.yy.o table_lexicographique.o arbre.o mon_allocation.o
	$(CC) -Wall -o compilateur_CPYRR y.tab.c lex.yy.o table_lexicographique.o arbre.o mon_allocation.o -ly -ll -lm

y.tab.c:
	yacc  -v -d grammaire_CPYRR.y -Wconflicts-rr

lex.yy.o: lex.yy.c 
	$(CC) -Wall -c lex.yy.c

table_lexicographique.o:  table_lexicographique.c  table_lexicographique.h
	$(CC) -Wall -c table_lexicographique.c

lex.yy.c:
	lex lex_CPYRR.l

arbre.o: arbre.c arbre.h
	$(CC) -Wall  -c arbre.c 

mon_allocation.o: mon_allocation.c mon_allocation.h
	$(CC) -Wall -c mon_allocation.c
clean:
	rm -f *.o *~ y.output y.tab.h lex.yy.c y.tab.c 


