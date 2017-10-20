%{
  #include "y.tab.h"
  #include <stdio.h>
  #include <stdlib.h>
  #include <string.h>
  
  int nb_ligne = 1;
  int caractere = 0;
%}


%%
\n {caractere = 0; nb_ligne += 1;}
[ \t]+ {caractere += strlen(yytext);}

\+\+ {caractere += strlen(yytext); return (INCREMENT);}
-- {caractere += strlen(yytext); return (DECREMENT);}
\+ {caractere += strlen(yytext); return (PLUS);}
- {caractere += strlen(yytext); return (MOINS);}
\* {caractere += strlen(yytext); return (MULT);}
\/ {caractere += strlen(yytext); return (DIV);}
\<  {caractere += strlen(yytext); return (CHEVRON_INF);}
\> {caractere += strlen(yytext); return (CHEVRON_SUP);}
\= {caractere += strlen(yytext); return (EGALE);}
\!\= {caractere += strlen(yytext); return (DIFF);}
\( {caractere += strlen(yytext); return (PARENTHESE_OUVRANTE);}
\) {caractere += strlen(yytext); return (PARENTHESE_FERMANTE);}
\[ {caractere += strlen(yytext); return (CROCHET_OUVRANT);}
\] {caractere += strlen(yytext); return (CROCHET_FERMANT);}
\: {caractere += strlen(yytext); return (DEUX_POINTS);}
\; {caractere += strlen(yytext); return (POINT_VIRGULE);}
\, {caractere += strlen(yytext); return (VIRGULE);}
\. {caractere += strlen(yytext); return (POINT);}
\{ {caractere += strlen(yytext); return (DEBUT);}
\} {caractere += strlen(yytext); return (FIN);}
\:\= {caractere += strlen(yytext); return (OPAFF);}
true|false {caractere += strlen(yytext); return (CSTE_BOOL);}
and {caractere += strlen(yytext); return (ET);}
or {caractere += strlen(yytext); return (OU);}
not {caractere += strlen(yytext); return (NON);}
int {caractere += strlen(yytext); return (ENTIER);}
double {caractere += strlen(yytext); return (REEL);}
bool {caractere += strlen(yytext); return (BOOLEEN);}
char {caractere += strlen(yytext); return (CARACTERE);}
string {caractere += strlen(yytext); return (CHAINE);}
procedure {caractere += strlen(yytext); return (PROCEDURE);}
fonction {caractere += strlen(yytext); return (FONCTION);}
return {caractere += strlen(yytext); return (RETOURNE);}
Cpyrr {caractere += strlen(yytext); return (PROG);}
var {caractere += strlen(yytext); return (VARIABLE);}
struct {caractere += strlen(yytext); return (STRUCT);}
array {caractere += strlen(yytext); return (TABLEAU);}
if {caractere += strlen(yytext); return (SI);}
then {caractere += strlen(yytext); return (ALORS);}
else {caractere += strlen(yytext); return (SINON);}
void {caractere += strlen(yytext); return (VIDE);}
\/\*([^\"\*]|\*+[^\"\*\/]|\*+\"[^\"]*\"|\"[^\"]*\")*\*+\/ { ;}
[a-z_][a-zA-Z0-9_]* {caractere += strlen(yytext); return (IDF);}
0|[1-9][0-9]* {caractere += strlen(yytext); return (CSTE_ENTIERE);}
0|[1-9][0-9]*\.[0-9]+ {caractere += strlen(yytext); return (CSTE_REEL);}
%%


