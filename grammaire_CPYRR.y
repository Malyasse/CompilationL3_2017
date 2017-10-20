
%{
#include <stdio.h>
#include <stdlib.h>
    
    extern char* yytext;
    extern int nb_ligne =1;
    %}


%token IDF 

%token OPAFF POINT_VIRGULE DEUX_POINTS CROCHET_OUVRANT CROCHET_FERMANT VIRGULE POINT PARENTHESE_OUVRANTE PARENTHESE_FERMANTE

%token PLUS MOINS MULT DIV CHEVRON_INF CHEVRON_SUP ET OU NON EGALE DIFF

%token CSTE_REEL CSTE_ENTIERE CSTE_BOOL

%token ENTIER REEL BOOLEEN CARACTERE CHAINE 

%token VARIABLE PROCEDURE FONCTION RETOURNE VIDE TANT_QUE SI ALORS SINON FAIRE STRUCT FSTRUCT  DEBUT FIN PROG TABLEAU DE TYPE

%%
programme             : PROG corps
;

corps                 : liste_declarations liste_instructions
                      | liste_instructions
;

liste_declarations    : declaration POINT_VIRGULE
                      | liste_declarations declaration POINT_VIRGULE
;

liste_instructions    : DEBUT suite_liste_inst FIN
;

suite_liste_inst      : VIDE
                      | instruction
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

liste_champs          : un_champ POINT_VIRGULE
                      | liste_champs un_champ POINT_VIRGULE
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

declaration_fonction  : FONCTION IDF liste_parametres RETOURNE type_simple DEUX_POINTS corps
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
                      |  PARENTHESE_OUVRANTE liste_args PARENTHESE_FERMANTE
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

variable              : IDF
                      | IDF CROCHET_OUVRANT liste_expressions_arithmetique CROCHET_FERMANT

;
liste_expressions_arithmetique : expression_arithmetique
                               | liste_expressions_arithmetique  VIRGULE expression_arithmetique
;
expression            :expression_arithmetique
                      |expression_booleen
                   
;
expression_arithmetique: e
;

e                      : e PLUS e1  
                       | e MOINS e1 
                       | e1
;

e1                     : e1 MULT e2 
                       | e1 DIV e2 
                       | e2   
;

e2                     : CSTE_ENTIERE
                       | CSTE_REEL
                       | PARENTHESE_OUVRANTE e PARENTHESE_FERMANTE  
;

expression_booleen:    expression_booleen CHEVRON_INF expression_final
                       | expression_booleen CHEVRON_INF EGALE expression_final
                       | expression_booleen CHEVRON_SUP  expression_final
                       | expression_booleen CHEVRON_SUP EGALE  expression_final
                       | expression_booleen EGALE  expression_final
                       | expression_booleen DIFF  expression_final              
                      
                       | expression_booleen OU expression_final
                       | expression_booleen NON expression_final
                       | expression_final
              
;
expression_booleen_1: expression_booleen ET expression_final
;
expression_booleen_2: PARENTHESE_OUVRANTE expression_booleen PARENTHESE_FERMANTE
;
expression_final :     expression_arithmetique
                       | CSTE_BOOL
;
%%



int yyerror(){
    fprintf(stderr,"Erreur de syntaxe ligne %d\n",nb_ligne);
}
