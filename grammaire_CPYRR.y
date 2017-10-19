
%{
#include <stdio.h>
#include <stdlib.h>
    
    extern char* yytext;
    %}


%token DEBUT FIN PROG POINT_VIRGULE TYPE IDF DEUX_POINTS STRUCT FSTRUCT TABLEAU DE CROCHET_OUVRANT CROCHET_FERMANT VIRGULE POINT ENTIER REEL BOOLEEN CARACTERE CHAINE CSTE_ENTIERE VARIABLE PROCEDURE FONCTION RETOURNE VIDE TANT_QUE OPAFF SI ALORS SINON FAIRE PARENTHESE_OUVRANTE PARENTHESE_FERMANTE


%%
programme             : PROG corps
;

corps                 : liste_declarations liste_instructions
                      | liste_instructions
;

liste_declarations    : declaration 
                      | liste_declarations POINT_VIRGULE declaration
;

liste_instructions    : DEBUT suite_liste_inst FIN
;

suite_liste_inst      : instruction
                      | suite_liste_inst POINT_VIRGULE instruction
;

declaration           : declaration_type
                      | declaration_variable
                      | declaration_procedure
                      | declaration_fonction
;

declaration_type      : TYPE IDF DEUX_POINTS suite_declaration_type
;

suite_declaration_type : STRUCT liste_champs FSTRUCT
                       | TABLEAU dimension DE nom_type

dimension             : CROCHET_OUVRANT liste_dimensions CROCHET_FERMANT
;
    
liste_dimensions      : une_dimension
                      | liste_dimensions VIRGULE une_dimension
;

une_dimension         : expression POINT POINT expression
;

liste_champs          : un_champ
                      | liste_champs POINT_VIRGULE un_champ
;

un_champ              : IDF DEUX_POINTS nom_type
;

nom_type              : type_simple
                      | IDF
;

type_simple           : ENTIER
                      | REEL
                      | BOOLEEN
                      | CARACTERE
                      | CHAINE CROCHET_OUVRANT CSTE_ENTIERE CROCHET_FERMANT
;

declaration_variable  : VARIABLE IDF DEUX_POINTS nom_type
;

declaration_procedure : PROCEDURE IDF liste_parametres corps
;

declaration_fonction  : FONCTION IDF liste_parametres RETOURNE type_simple corps
;

liste_parametres      :
                      | PARENTHESE_OUVRANTE liste_param PARENTHESE_FERMANTE
                      ;

liste_param           : un_param
                      | liste_param POINT_VIRGULE un_param
;

un_param              : IDF DEUX_POINTS type_simple
;

instruction           : affectation
                      | condition
                      | tant_que
                      | appel
                      | VIDE
                      | RETOURNE resultat_retourne
;

resultat_retourne     :
                      | expression
                      ;

appel                 : IDF liste_arguments
;

liste_arguments       :
                      :  PARENTHESE_OUVRANTE liste_args PARENTHESE_FERMANTE
;

liste_args            : un_arg
                      | liste_args VIRGULE un_arg
;

un_arg                : expression
;

condition             : SI expression
                         ALORS liste_instructions
                         SINON liste_instructions
;

tant_que              : TANT_QUE expression FAIRE liste_instructions
;

affectation           : variable OPAFF expression
;

variable              : description des formes possibles des variables
;

expression            : description des formes possibles des expressions
;
%%



int yyerror(){
    fprintf(stderr,"Erreur\n");
}