
%{
#include <stdio.h>
#include <stdlib.h>
    
    extern char* yytext;
    extern int nb_ligne;
    %}


%token IDF 

%token OPAFF POINT_VIRGULE DEUX_POINTS CROCHET_OUVRANT CROCHET_FERMANT VIRGULE POINT PARENTHESE_OUVRANTE PARENTHESE_FERMANTE

%token PLUS MOINS MULT DIV CHEVRON_INF CHEVRON_SUP ET OU NON EGALE DIFF INCREMENT DECREMENT

%token CSTE_REEL CSTE_ENTIERE CSTE_BOOL CSTE_CHAINE

%token ENTIER REEL BOOLEEN CARACTERE CHAINE 

%token VARIABLE PROCEDURE FONCTION RETOURNE VIDE TANT_QUE SI ALORS SINON FAIRE STRUCT FSTRUCT  DEBUT FIN PROG TABLEAU DE TYPE




%%
programme             : PROG corps
;

corps                 : VIDE
                      | liste_declarations liste_instructions
                      | liste_instructions
;

liste_declarations    : declaration POINT_VIRGULE
                      | liste_declarations declaration POINT_VIRGULE
;

liste_instructions    : DEBUT suite_liste_inst FIN
;

suite_liste_inst      : VIDE
                      | instruction POINT_VIRGULE
                      | suite_liste_inst instruction POINT_VIRGULE
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

une_dimension         : expression_entiere POINT POINT expression_entiere
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

condition             : SI expression_booleen
                         ALORS liste_instructions
                         SINON liste_instructions
;

tant_que              : TANT_QUE expression_booleen FAIRE liste_instructions
;

affectation           : variable OPAFF expression
;

variable              : IDF
                      | IDF CROCHET_OUVRANT liste_expressions_entiere CROCHET_FERMANT

;

//expression            : expression_arithmetique
//                     | expression_booleen
//; 

liste_expressions_entiere       : expression_entiere
                                | liste_expressions_entiere  VIRGULE expression_entiere
;


expression             : expression_chaine
                       | expression_booleen
                       | expression_reel
;

expression_booleen     : expression_booleen OU expression_booleen_1
                       | expression_booleen_1
;

expression_booleen_1   :  expression_booleen_1 ET expression_booleen_2
                       | expression_booleen_2
;

expression_booleen_2   :  expression_booleen_2 EGALE  expression_booleen_3
                       | expression_booleen_2 DIFF  expression_booleen_3
                       | expression_booleen_3
;

expression_booleen_3   : expression_booleen_3 CHEVRON_INF EGALE expression_booleen_4
                       | expression_booleen_3 CHEVRON_SUP EGALE  expression_booleen_4
                       | expression_booleen_3 CHEVRON_INF expression_booleen_4
                       | expression_booleen_3 CHEVRON_SUP  expression_booleen_4
                       | expression_booleen_4
;
                     

expression_booleen_4   : expression_booleen_4 NON expression_booleen_5
                       | expression_booleen_5
;

expression_booleen_5   :// PARENTHESE_OUVRANTE expression_booleen PARENTHESE_FERMANTE
                        expression_entiere  
                       | CSTE_BOOL
;


expression_entiere        : expression_entiere PLUS expression_entiere_1  
                          | expression_entiere MOINS expression_entiere_1
		          | expression_entiere_1
;

expression_entiere_1      : expression_entiere_1 MULT expression_entiere_2
                          | expression_entiere_1 DIV expression_entiere_2
                          | expression_entiere_2
;
expression_entiere_2      : expression_entiere_2 INCREMENT
                          | expression_entiere_2 DECREMENT
                          | expression_entiere_3 
 ;

expression_entiere_3      : CSTE_ENTIERE
		          | IDF
		          | PARENTHESE_OUVRANTE expression_booleen PARENTHESE_FERMANTE  
;


expression_reel           : expression_reel PLUS expression_reel_1  
                          | expression_reel MOINS expression_reel_1
		          | expression_reel_1
;

expression_reel_1         : expression_reel_1 MULT expression_reel_2
                          | expression_reel_1 DIV expression_reel_2
                          | expression_reel_2
;
expression_reel_2         : expression_reel_2 INCREMENT
                          | expression_reel_2 DECREMENT
                          | expression_reel_3 
 ;

expression_reel_3         : //CSTE_ENTIERE
		          CSTE_REEL
			    //| IDF
		          | PARENTHESE_OUVRANTE expression_reel PARENTHESE_FERMANTE  
;

expression_chaine         : expression_chaine PLUS chaine
                          | chaine
;

chaine                    : CSTE_CHAINE
			    // | IDF
;

%%



int yyerror(){
    fprintf(stderr,"Erreur de syntaxe ligne %d\n",nb_ligne);
}


