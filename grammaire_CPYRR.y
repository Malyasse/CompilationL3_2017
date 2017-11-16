
%{
#include <stdio.h>
#include <stdlib.h>

#include "arbre.h"
#include "table_lexicographique.h"
#include "table_declaration.h"

    arbre arbre_instruction;
    
    extern char* yytext;
    extern int nb_ligne;
    extern int caractere;
    extern int table_hashcode[TAILLE_TAB_HASH_CODE];
    extern tab_lexico tab_lex;

    int yylex();
    int yyerror();
    
    %union{
       typedef struct struct_arbre{
            int type_noeud;
            int num_lexico;
            struct struct_arbre *frere;
            struct struct_arbre *fils;
       }* arbre;
       
       
       int entier;
  }
   
    %}


%token<entier> IDF 

%token<entier> POINT_VIRGULE DEUX_POINTS CROCHET_OUVRANT CROCHET_FERMANT VIRGULE POINT PARENTHESE_OUVRANTE PARENTHESE_FERMANTE  POINT_POINT

%token<entier>  OPAFF PLUS MOINS MULT DIV MODULO CHEVRON_INF_EGALE CHEVRON_SUP_EGALE CHEVRON_INF CHEVRON_SUP ET OU NON EGALE DIFF INCREMENT DECREMENT LIRE ECRIRE

%token<entier> CSTE_REEL CSTE_ENTIERE CSTE_BOOL CSTE_CHAINE CSTE_CARACTERE

%token<entier> ENTIER REEL BOOLEEN CARACTERE CHAINE 

%token<entier> VARIABLE PROCEDURE FONCTION RETOURNE VIDE TANT_QUE SI ALORS SINON FAIRE STRUCT FSTRUCT  DEBUT FIN PROG TABLEAU DE TYPE


%type<arbre> suite_liste_inst instruction liste_instructions programme corps 
%type<arbre> affectation condition tant_que appel liste_variables suite_ecriture format resultat_retourne 
%type<arbre> expression variable liste_expression un_arg liste_args liste_arguments

%%
programme             : PROG corps {$$ = $2; arbre_instruction = $$;}
;

corps                 : VIDE {$$ = arbre_vide();}
                      | liste_declarations liste_instructions {$$ = $2;}
                      | liste_instructions {$$ = $1;}
;

liste_declarations    : declaration POINT_VIRGULE
                      | liste_declarations declaration POINT_VIRGULE
;

liste_instructions    : DEBUT suite_liste_inst FIN {$$ = $2;}     //empiler region
;

suite_liste_inst      : VIDE {$$ = arbre_vide();}
                      | instruction POINT_VIRGULE {$$ = $1;}
                      | suite_liste_inst instruction POINT_VIRGULE {$$ = concat_pere_frere($1, $2);}
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
;

dimension             : CROCHET_OUVRANT liste_dimensions CROCHET_FERMANT
;
    
liste_dimensions      : une_dimension
                      | liste_dimensions VIRGULE une_dimension
;

une_dimension         : expression POINT_POINT expression 
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
                      | CHAINE CROCHET_OUVRANT expression CROCHET_FERMANT
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

instruction           : affectation   {$$ = $1;}
                      | condition   {$$ = $1;}
                      | tant_que   {$$ = $1;}
                      | appel   {$$ = $1;}
                      | LIRE PARENTHESE_OUVRANTE liste_variables PARENTHESE_FERMANTE   {$$ = concat_pere_fils(creer_noeud($1, 10), $3);}
                      | ECRIRE PARENTHESE_OUVRANTE format suite_ecriture PARENTHESE_FERMANTE   {$$ = concat_pere_fils(creer_noeud($1, 11), concat_pere_frere($3, $4));}
                      | VIDE   {$$ = arbre_vide();}
                      | RETOURNE resultat_retourne  {$$ = concat_pere_fils(creer_noeud($1, 16), $2);} 
;

format                : CSTE_CHAINE    {$$ = creer_noeud($1, 12);} 
;

suite_ecriture        :        {$$ = arbre_vide();}
                      | VIRGULE variable suite_ecriture   {$$ = concat_pere_frere($2, $3);}
		      ;

resultat_retourne     :      {$$ = arbre_vide();}
                      | expression    {$$ = $1;}
                      ;

appel                 : IDF liste_arguments   {$$ = concat_pere_fils(creer_noeud($1, 13), $2);}
;

liste_arguments       : PARENTHESE_OUVRANTE VIDE PARENTHESE_FERMANTE      {$$ = arbre_vide();}
                      | PARENTHESE_OUVRANTE liste_args PARENTHESE_FERMANTE    {$$ = $2;}
;

liste_args            : un_arg        {$$ = $1;}
                      | liste_args VIRGULE un_arg    {$$ = concat_pere_frere($1, $3);}
;

un_arg                : expression       {$$ = $1;}
;

condition             : SI expression  
                        ALORS liste_instructions 
                        SINON liste_instructions  {$$ = concat_pere_fils(creer_noeud($1, 14), concat_pere_frere($2, concat_pere_fils(creer_noeud($3, 15), concat_pere_frere($4, concat_pere_fils(creer_noeud($5, 16), $6)))));}
                      | SI expression  
                        ALORS liste_instructions {$$ = concat_pere_fils(creer_noeud($1, 14), concat_pere_frere($2, concat_pere_fils(creer_noeud($3, 15), $4)));}
;

tant_que              : TANT_QUE expression FAIRE liste_instructions    {$$ = concat_pere_fils(creer_noeud($1, 18), concat_pere_frere($2, concat_pere_fils(creer_noeud($3, 19), $4)));}
;

affectation           : variable OPAFF expression   {$$ = concat_pere_frere($1, concat_pere_fils(creer_noeud($2, 20), $3));}
;

liste_variables       : variable      {$$ = $1;}
                      | liste_variables VIRGULE variable     {$$ = concat_pere_frere($1, $3);}     // inverser?
;


variable              : IDF      {$$ = $1;}
                      | IDF CROCHET_OUVRANT liste_expression CROCHET_FERMANT suite_variable1    //  {$$ = concat_pere_fils(creer_noeud(21, $1), );}
                      | IDF POINT variable
                      ;


suite_variable1       :  
                      | POINT variable 
;  


liste_expression      : expression 
                      | liste_expression VIRGULE expression
;


expression            : expression OU expression_1;
                      | expression_1
;

expression_1          : expression_1 ET expression_2  
		      | expression_2
;

expression_2          : expression_2 operateur1 expression_3  
		      | expression_3
;

expression_3          : expression_3 operateur2 expression_4
                      | CSTE_CHAINE
                      | CSTE_CARACTERE
                      | CSTE_BOOL
		      | expression_4
;

expression_4          : expression_4 operateur3 expression_5  
		      | expression_5
;

expression_5          : expression_5 operateur4 expression_6  
		      | expression_6
;

expression_6          : CSTE_ENTIERE
                      | CSTE_REEL
		      | PARENTHESE_OUVRANTE expression PARENTHESE_FERMANTE
                      | variable
                      | appel
	                // | IDF operateur_unaire
;

operateur1             : EGALE
                       | DIFF
;

operateur2             : CHEVRON_INF_EGALE
                       | CHEVRON_SUP_EGALE
                       | CHEVRON_INF
                       | CHEVRON_SUP
;

operateur3             : PLUS
                       | MOINS
;

operateur4             : MULT
                       | DIV
                       | MODULO
;

/*expression_unaire         :// decrement et increment prefixer possible mais... a voir
                           IDF INCREMENT
                          | IDF DECREMENT
                          | NON expression
			  ;*/


/*expression_chaine         : expression_chaine PLUS chaine
                          | chaine
;

chaine                    : CSTE_CHAINE
			  | IDF
;
*/
%%



int main(){

    init_hashcode(table_hashcode); 
    initialisation_tab_lex(TAILLE_TAB_LEXICO, &tab_lex);  
    
    yyparse();
    
    
    afficher_table_hashcode(table_hashcode);
    afficher_table_lexicographique(&tab_lex, 100);
    afficher_arbre_horizontal(arbre_instruction, 6, 0, stdout);
    
    exit(0);

}


int yyerror(){
    fprintf(stderr,"Erreur de syntaxe a la ligne %d pres du caractere %d \n", nb_ligne, caractere);
    return 0;
}


