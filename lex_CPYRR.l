%{
  #include <stdio.h>
  #include <stdlib.h>
  
  #include "y.tab.h"
  #include "table_lexicographique.h"
  
  
  int i;
  int nb_ligne = 1;
  int caractere = 0;
  
  int table_hashcode[TAILLE_TAB_HASH_CODE];
  tab_lexico tab_lex;
  
%}


%%
\n {caractere = 0; nb_ligne += 1;}
[ \t]+ {caractere += yyleng;}

\+\+ {caractere += yyleng; inserer_lexeme(yytext, &tab_lex, table_hashcode); return (INCREMENT);}
-- {caractere += yyleng; inserer_lexeme(yytext, &tab_lex, table_hashcode); return (DECREMENT);}
\+ {caractere += yyleng; inserer_lexeme(yytext, &tab_lex, table_hashcode); return (PLUS);}
- {caractere += yyleng; inserer_lexeme(yytext, &tab_lex, table_hashcode); return (MOINS);}
\* {caractere += yyleng; inserer_lexeme(yytext, &tab_lex, table_hashcode); return (MULT);}
\/ {caractere += yyleng; inserer_lexeme(yytext, &tab_lex, table_hashcode); return (DIV);}
\<\= {caractere += yyleng; inserer_lexeme(yytext, &tab_lex, table_hashcode); return (CHEVRON_INF_EGALE);}
\>\= {caractere += yyleng; inserer_lexeme(yytext, &tab_lex, table_hashcode); return (CHEVRON_SUP_EGALE);}
\<  {caractere += yyleng; inserer_lexeme(yytext, &tab_lex, table_hashcode); return (CHEVRON_INF);}
\> {caractere += yyleng; inserer_lexeme(yytext, &tab_lex, table_hashcode); return (CHEVRON_SUP);}
\= {caractere += yyleng; inserer_lexeme(yytext, &tab_lex, table_hashcode); return (EGALE);}
\!\= {caractere += yyleng; inserer_lexeme(yytext, &tab_lex, table_hashcode); return (DIFF);}
\( {caractere += yyleng; inserer_lexeme(yytext, &tab_lex, table_hashcode); return (PARENTHESE_OUVRANTE);}
\) {caractere += yyleng; inserer_lexeme(yytext, &tab_lex, table_hashcode); return (PARENTHESE_FERMANTE);}
\[ {caractere += yyleng; inserer_lexeme(yytext, &tab_lex, table_hashcode); return (CROCHET_OUVRANT);}
\] {caractere += yyleng; inserer_lexeme(yytext, &tab_lex, table_hashcode); return (CROCHET_FERMANT);}
\: {caractere += yyleng; inserer_lexeme(yytext, &tab_lex, table_hashcode); return (DEUX_POINTS);}
\; {caractere += yyleng; inserer_lexeme(yytext, &tab_lex, table_hashcode); return (POINT_VIRGULE);}
\, {caractere += yyleng; inserer_lexeme(yytext, &tab_lex, table_hashcode); return (VIRGULE);}
\. {caractere += yyleng; inserer_lexeme(yytext, &tab_lex, table_hashcode); return (POINT);}
\{ {caractere += yyleng; inserer_lexeme(yytext, &tab_lex, table_hashcode); return (DEBUT);}
\} {caractere += yyleng; inserer_lexeme(yytext, &tab_lex, table_hashcode); return (FIN);}
\:\= {caractere += yyleng; inserer_lexeme(yytext, &tab_lex, table_hashcode); return (OPAFF);}
\%  {caractere += yyleng; inserer_lexeme(yytext, &tab_lex, table_hashcode); return (MODULO);}
Cpyrr {caractere += yyleng; init_hashcode(table_hashcode); initialisation_tab_lex(TAILLE_TAB_LEXICO, &tab_lex); inserer_lexeme(yytext, &tab_lex, table_hashcode); return (PROG);}
type {caractere += yyleng; inserer_lexeme(yytext, &tab_lex, table_hashcode); return (TYPE);}
fstruct {caractere += yyleng; inserer_lexeme(yytext, &tab_lex, table_hashcode); return (FSTRUCT);}
struct {caractere += yyleng; inserer_lexeme(yytext, &tab_lex, table_hashcode); return (STRUCT);}
true|false {caractere += yyleng; inserer_lexeme(yytext, &tab_lex, table_hashcode); return (CSTE_BOOL);}
and {caractere += yyleng; inserer_lexeme(yytext, &tab_lex, table_hashcode); return (ET);} 
do {caractere += yyleng; inserer_lexeme(yytext, &tab_lex, table_hashcode); return (FAIRE);}
while {caractere += yyleng; inserer_lexeme(yytext, &tab_lex, table_hashcode); return (TANT_QUE);}
if {caractere += yyleng; inserer_lexeme(yytext, &tab_lex, table_hashcode); return (SI);}
then {caractere += yyleng; inserer_lexeme(yytext, &tab_lex, table_hashcode); return (ALORS);}
else {caractere += yyleng; inserer_lexeme(yytext, &tab_lex, table_hashcode); return (SINON);}
or {caractere += yyleng; inserer_lexeme(yytext, &tab_lex, table_hashcode); return (OU);}
not {caractere += yyleng; inserer_lexeme(yytext, &tab_lex, table_hashcode); return (NON);}
int {caractere += yyleng; inserer_lexeme(yytext, &tab_lex, table_hashcode); return (ENTIER);}
double {caractere += yyleng; inserer_lexeme(yytext, &tab_lex, table_hashcode); return (REEL);}
bool {caractere += yyleng; inserer_lexeme(yytext, &tab_lex, table_hashcode); return (BOOLEEN);}
char {caractere += yyleng; inserer_lexeme(yytext, &tab_lex, table_hashcode); return (CARACTERE);}
string {caractere += yyleng; inserer_lexeme(yytext, &tab_lex, table_hashcode); return (CHAINE);}
procedure {caractere += yyleng; inserer_lexeme(yytext, &tab_lex, table_hashcode); return (PROCEDURE);}
function {caractere += yyleng; inserer_lexeme(yytext, &tab_lex, table_hashcode); return (FONCTION);}
return {caractere += yyleng; inserer_lexeme(yytext, &tab_lex, table_hashcode); return (RETOURNE);}
var {caractere += yyleng; inserer_lexeme(yytext, &tab_lex, table_hashcode); return (VARIABLE);}
of  {caractere += yyleng; inserer_lexeme(yytext, &tab_lex, table_hashcode); return (DE);}
array {caractere += yyleng; inserer_lexeme(yytext, &tab_lex, table_hashcode); return (TABLEAU);}
void {caractere += yyleng; inserer_lexeme(yytext, &tab_lex, table_hashcode); return (VIDE);}
read {caractere += yyleng; inserer_lexeme(yytext, &tab_lex, table_hashcode); return (LIRE);}
write {caractere += yyleng; inserer_lexeme(yytext, &tab_lex, table_hashcode); return (ECRIRE);}
\'[^']\' {caractere += yyleng; inserer_lexeme(yytext, &tab_lex, table_hashcode); return (CSTE_CARACTERE);}
\"[^"]*\" {caractere += yyleng; inserer_lexeme(yytext, &tab_lex, table_hashcode); return (CSTE_CHAINE);}
\/\*([^\"\*]|\*+[^\"\*\/]|\*+\"[^\"]*\"|\"[^\"]*\")*\*+\/ { ;}
[a-z_][a-zA-Z0-9_]* {caractere += yyleng; inserer_lexeme(yytext, &tab_lex, table_hashcode); return (IDF);}
0|[1-9][0-9]* {caractere += yyleng; inserer_lexeme(yytext, &tab_lex, table_hashcode); return (CSTE_ENTIERE);}
0|[1-9][0-9]*\.[0-9]+ {caractere += yyleng; inserer_lexeme(yytext, &tab_lex, table_hashcode); return (CSTE_REEL);}
. { ;}
%%

int yywrap(){

    afficher_table_hashcode(table_hashcode);
    afficher_table_lexicographique(&tab_lex, 500);
    
    return 1;

}


