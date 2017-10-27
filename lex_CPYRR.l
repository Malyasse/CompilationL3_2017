%{
  #include "y.tab.h"
  #include <stdio.h>
  #include <stdlib.h>

  int nb_ligne = 1;
  int caractere = 0;
%}


%%
\n {caractere = 0; nb_ligne += 1;}
[ \t]+ {caractere += yyleng;}

\+\+ {caractere += yyleng; return (INCREMENT);}
-- {caractere += yyleng; return (DECREMENT);}
\+ {caractere += yyleng; return (PLUS);}
- {caractere += yyleng; return (MOINS);}
\* {caractere += yyleng; return (MULT);}
\/ {caractere += yyleng; return (DIV);}
\<\= {caractere += yyleng; return (CHEVRON_INF_EGALE);}
\>\= {caractere += yyleng; return (CHEVRON_SUP_EGALE);}
\<  {caractere += yyleng; return (CHEVRON_INF);}
\> {caractere += yyleng; return (CHEVRON_SUP);}
\= {caractere += yyleng; return (EGALE);}
\!\= {caractere += yyleng; return (DIFF);}
\( {caractere += yyleng; return (PARENTHESE_OUVRANTE);}
\) {caractere += yyleng; return (PARENTHESE_FERMANTE);}
\[ {caractere += yyleng; return (CROCHET_OUVRANT);}
\] {caractere += yyleng; return (CROCHET_FERMANT);}
\: {caractere += yyleng; return (DEUX_POINTS);}
\; {caractere += yyleng; return (POINT_VIRGULE);}
\, {caractere += yyleng; return (VIRGULE);}
\. {caractere += yyleng; return (POINT);}
\{ {caractere += yyleng; return (DEBUT);}
\} {caractere += yyleng; return (FIN);}
\:\= {caractere += yyleng; return (OPAFF);}
\%  {caractere += yyleng; return (MODULO);}
type {caractere += yyleng; return (TYPE);}
fstruct {caractere += yyleng; return (FSTRUCT);}
struct {caractere += yyleng; return (STRUCT);}
true|false {caractere += yyleng; return (CSTE_BOOL);}
and {caractere += yyleng; return (ET);} 
do {caractere += yyleng; return (FAIRE);}
while {caractere += yyleng; return (TANT_QUE);}
if {caractere += yyleng; return (SI);}
then {caractere += yyleng; return (ALORS);}
else {caractere += yyleng; return (SINON);}
or {caractere += yyleng; return (OU);}
not {caractere += yyleng; return (NON);}
int {caractere += yyleng; return (ENTIER);}
double {caractere += yyleng; return (REEL);}
bool {caractere += yyleng; return (BOOLEEN);}
char {caractere += yyleng; return (CARACTERE);}
string {caractere += yyleng; return (CHAINE);}
procedure {caractere += yyleng; return (PROCEDURE);}
function {caractere += yyleng; return (FONCTION);}
return {caractere += yyleng; return (RETOURNE);}
Cpyrr {caractere += yyleng; return (PROG);}
var {caractere += yyleng; return (VARIABLE);}
of  {caractere += yyleng; return (DE);}
array {caractere += yyleng; return (TABLEAU);}
void {caractere += yyleng; return (VIDE);}
read {caractere += yyleng; return (LIRE);}
write {caractere += yyleng; return (ECRIRE);}
\'[^']\' {caractere += yyleng; return (CSTE_CARACTERE);}
\"[^"]*\" {caractere += yyleng; return (CSTE_CHAINE);}
\/\*([^\"\*]|\*+[^\"\*\/]|\*+\"[^\"]*\"|\"[^\"]*\")*\*+\/ { ;}
[a-z_][a-zA-Z0-9_]* {caractere += yyleng; return (IDF);}
0|[1-9][0-9]* {caractere += yyleng; return (CSTE_ENTIERE);}
0|[1-9][0-9]*\.[0-9]+ {caractere += yyleng; return (CSTE_REEL);}
. { ;}
%%

/*int yywrap(){

}*/


