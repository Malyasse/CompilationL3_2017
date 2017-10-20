%{
#include "y.tab.h"
  #include <stdio.h>
  #include <stdlib.h>
%}

DEBUT FIN PROG POINT_VIRGULE TYPE IDF DEUX_POINTS STRUCT FSTRUCT TABLEAU DE CROCHET_OUVRANT CROCHET_FERMANT VIRGULE POINT ENTIER REEL BOOLEEN CARACTERE CHAINE CSTE_ENTIERE VARIABLE PROCEDURE FONCTION RETOURNE VIDE TANT_QUE OPAFF SI ALORS SINON FAIRE PARENTHESE_OUVRANTE PARENTHESE_FERMANTE CSTE_REEL CSTE_BOOL CHEVRON_INF CHEVRON_SUP ET OU NON EGALE DIFF

%%
\+ {return (PLUS);}
- {return (MOINS);}
\* {return (MULT);}
\/ {return (DIV);}
\< {return (CHEVRON_INF);}
\> {return (CHEVRON_SUP);}
and {return (ET);}
or {return (OU);}
not {return (NON);}
\= {return (EGALE);}
\!\= {return (DIFF);}
\( {return (PARENTHESE_OUVRANTE);}
\) {return (PARENTHESE_FERMANTE);}
\[ {return (CROCHET_OUVRANT);}
\] {return (CROCHET_FERMANT);}
\: {return (DEUX_POINTS);}
\; {return (POINT_VIRGULE);}
\, {return (VIRGULE);}
\. {return (POINT);}
int {return (ENTIER);}
double {return (REEL);}
bool {return (BOOLEEN);}
char {return (CARACTERE);}
string {return (CHAINE);}
\{ {return (DEBUT);}
\} {return (FIN);}
Cpyrr {return (PROG);}
var {return (VARIABLE);}
struct {return (STRUCT);}
array {return (TABLEAU);}
\:\= {return (OPAFF);}
procedure {return (PROCEDURE);}
fonction {return (FONCTION);}
return {return (RETOURNE);}
[a-z_][a-zA-Z0-9_]*   {return (IDF);}
0|[1-9][0-9]*   {return (CSTE_ENTIERE);}
0|[1-9][0-9]*.[0-9][0-9]*   {return (CSTE_REEL);}
true|false   {return (CSTE_BOOL);}
%%


