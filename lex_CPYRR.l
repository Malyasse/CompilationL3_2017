%{
  #include <stdio.h>
  #include <stdlib.h>
  
  #include "y.tab.h"
  #include "table_lexicographique.h"
  #include "table_declaration.h"
  
  int i;
  int nb_ligne = 1;
  int caractere = 0;
  
  int table_hashcode[TAILLE_TAB_HASH_CODE];
  tab_lexico tab_lex;
  
%}


%%
\n {caractere = 0; nb_ligne += 1;}
[ \t]+ {caractere += yyleng;}

\+\+ {caractere += yyleng;  return (INCREMENT);}
-- {caractere += yyleng;   return (DECREMENT);}
\+ {caractere += yyleng;  return (PLUS);}
- {caractere += yyleng;   return (MOINS);}
\* {caractere += yyleng;  return (MULT);}
\/ {caractere += yyleng; return (DIV);}
\<\= {caractere += yyleng;  return (CHEVRON_INF_EGALE);}
\>\= {caractere += yyleng;  return (CHEVRON_SUP_EGALE);}
\<  {caractere += yyleng;   return (CHEVRON_INF);}
\> {caractere += yyleng;    return (CHEVRON_SUP);}
\= {caractere += yyleng;    return (EGALE);}
\!\= {caractere += yyleng;  return (DIFF);}
\( {caractere += yyleng;    return (PARENTHESE_OUVRANTE);}
\) {caractere += yyleng;    return (PARENTHESE_FERMANTE);}
\[ {caractere += yyleng;    return (CROCHET_OUVRANT);}
\] {caractere += yyleng;    return (CROCHET_FERMANT);}
\: {caractere += yyleng;    return (DEUX_POINTS);}
\; {caractere += yyleng;    return (POINT_VIRGULE);}
\, {caractere += yyleng;    return (VIRGULE);}
\. {caractere += yyleng;    return (POINT);}
\.\. {caractere += yyleng;  return (POINT_POINT);}
\{ {caractere += yyleng;    return (DEBUT);}
\} {caractere += yyleng;    return (FIN);}
\:\= {caractere += yyleng;  return (OPAFF);}
\%  {caractere += yyleng;   return (MODULO);}
Cpyrr {caractere += yyleng; init_hashcode(table_hashcode); initialisation_tab_lex(TAILLE_TAB_LEXICO, &tab_lex);   return (PROG);}
type {caractere += yyleng; return (TYPE);}
fstruct {caractere += yyleng;   return (FSTRUCT);}
struct {caractere += yyleng;   return (STRUCT);}
and {caractere += yyleng;   return (ET);} 
do {caractere += yyleng;    return (FAIRE);}
while {caractere += yyleng; return (TANT_QUE);}
if {caractere += yyleng;    return (SI);}
then {caractere += yyleng;  return (ALORS);}
else {caractere += yyleng;  return (SINON);}
or {caractere += yyleng;    return (OU);}
not {caractere += yyleng;   return (NON);}
int {caractere += yyleng; yylval=TYPE_B; return (ENTIER);}
double {caractere += yyleng; yylval=TYPE_B; return (REEL);}
bool {caractere += yyleng; yylval=TYPE_B; return (BOOLEEN);}
char {caractere += yyleng; yylval=TYPE_B;  return (CARACTERE);}
string {caractere += yyleng; yylval=TYPE_B;  return (CHAINE);}
procedure {caractere += yyleng; yylval=PROC;  return (PROCEDURE);}
function {caractere += yyleng; yylval=FUN;  return (FONCTION);}
return {caractere += yyleng;  return (RETOURNE);}
var {caractere += yyleng;  return (VARIABLE);}
of  {caractere += yyleng;  return (DE);}
array {caractere += yyleng; return (TABLEAU);}
void {caractere += yyleng; return (VIDE);}
read {caractere += yyleng; return (LIRE);}
write {caractere += yyleng; return (ECRIRE);}
true|false {caractere += yyleng; yylval=inserer_lexeme(yytext, &tab_lex, table_hashcode); return (CSTE_BOOL);}
\'[^']\' {caractere += yyleng; yylval=yytext[0]; return (CSTE_CARACTERE);}
\"[^"]*\" {caractere += yyleng; yylval=inserer_lexeme(yytext, &tab_lex, table_hashcode); return (CSTE_CHAINE);}
\/\*([^\"\*]|\*+[^\"\*\/]|\*+\"[^\"]*\"|\"[^\"]*\")*\*+\/ { ;}
[a-z_][a-zA-Z0-9_]* {caractere += yyleng; yylval=inserer_lexeme(yytext, &tab_lex, table_hashcode); return (IDF);}
0|[1-9][0-9]* {caractere += yyleng; yylval=atoi(yytext); return (CSTE_ENTIERE);}
0|[1-9][0-9]*\.[0-9]+ {caractere += yyleng; yylval=inserer_lexeme(yytext, &tab_lex, table_hashcode); return (CSTE_REEL);}
. { ;}
%%



int yywrap(){

    afficher_table_hashcode(table_hashcode);
    afficher_table_lexicographique(&tab_lex, 100);
    
    return 1;

}


