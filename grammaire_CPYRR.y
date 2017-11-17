
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
    table_declaration table_declar;
    
   
    %}
    
    
    %union{
       arbre type1;
       int type2;
    }



%token<type2> IDF 

%token<type2> POINT_VIRGULE DEUX_POINTS CROCHET_OUVRANT CROCHET_FERMANT VIRGULE POINT PARENTHESE_OUVRANTE PARENTHESE_FERMANTE  POINT_POINT

%token<type2>  OPAFF PLUS MOINS MULT DIV MODULO CHEVRON_INF_EGALE CHEVRON_SUP_EGALE CHEVRON_INF CHEVRON_SUP ET OU NON EGALE DIFF INCREMENT DECREMENT LIRE ECRIRE

%token<type2> CSTE_REEL CSTE_ENTIERE CSTE_BOOL CSTE_CHAINE CSTE_CARACTERE

%token<type2> ENTIER REEL BOOLEEN CARACTERE CHAINE 

%token<type2> VARIABLE PROCEDURE FONCTION RETOURNE VIDE TANT_QUE SI ALORS SINON FAIRE STRUCT FSTRUCT  DEBUT FIN PROG TABLEAU DE TYPE


%type<type1> suite_liste_inst instruction liste_instructions programme corps 
%type<type1> affectation condition tant_que appel liste_variables suite_ecriture format resultat_retourne 
%type<type1> expression variable liste_expression un_arg liste_args liste_arguments suite_variable1 expression_1 expression_2 expression_3 expression_4 expression_5 expression_6  
%type<type1> operateur1 operateur2 operateur3 operateur4


%%
programme             : PROG corps {$$ = $2; arbre_instruction = $$; }
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

declaration_variable  : VARIABLE IDF DEUX_POINTS nom_type    // {inserer_declaration();}
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
                      | LIRE PARENTHESE_OUVRANTE liste_variables PARENTHESE_FERMANTE   {$$ = concat_pere_fils(creer_noeud(A_LIRE, $1), $3);}
                      | ECRIRE PARENTHESE_OUVRANTE format suite_ecriture PARENTHESE_FERMANTE   {$$ = concat_pere_fils(creer_noeud(A_ECRIRE, $1), concat_pere_frere($3, $4));}
                      | VIDE   {$$ = arbre_vide();}
                      | RETOURNE resultat_retourne  {$$ = concat_pere_fils(creer_noeud(A_RETOURNE, $1), $2);} 
;

format                : CSTE_CHAINE    {$$ = creer_noeud(A_CST_CHAINE, $1);} 
;

suite_ecriture        :        {$$ = arbre_vide();}
                      | VIRGULE variable suite_ecriture   {$$ = concat_pere_frere($2, $3);}
		      ;

resultat_retourne     :      {$$ = arbre_vide();}
                      | expression    {$$ = $1;}
                      ;

appel                 : IDF liste_arguments   {$$ = concat_pere_fils(creer_noeud(A_IDF,$1), $2);}  //Mettre PROCEDURE liste_arguments || FONCTION liste_arguments ???
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
                        SINON liste_instructions  {$$ = concat_pere_fils(creer_noeud(A_ITE,-1), concat_pere_frere($2, concat_pere_frere($4,$6)));}
                      | SI expression  
                        ALORS liste_instructions {$$ = concat_pere_fils(creer_noeud(A_ITE, -1), concat_pere_frere($2,$4));}
;

tant_que              : TANT_QUE expression FAIRE liste_instructions    {$$ = concat_pere_fils(creer_noeud(A_TANT_QUE, -1), concat_pere_frere($2,$4));}
;

affectation           : variable OPAFF expression  {$$ = concat_pere_fils(creer_noeud(A_OPAFF,-1),concat_pere_frere($1,$3));}
;

liste_variables       : variable      {$$ = $1;}
                      | liste_variables VIRGULE variable     {$$ = concat_pere_frere($1, $3);} 
;


variable              : IDF      {$$ = creer_noeud(A_IDF, $1);}      // n'arrive pas a construire l'arbre quand un idf est dans une expression: erreur de segmentation
                      | IDF CROCHET_OUVRANT liste_expression CROCHET_FERMANT suite_variable1  {$$ = concat_pere_fils(creer_noeud(A_IDF, $1),concat_pere_frere($3,$5 ));}
                      | IDF POINT variable   {$$ = concat_pere_fils(creer_noeud(A_IDF, $1),concat_pere_fils(creer_noeud(A_POINT, -1), $3) );}
                      ;


suite_variable1       :      {$$ = arbre_vide();}
                      | POINT variable   {$$ = concat_pere_fils(creer_noeud(A_POINT, -1), $2);}
;  


liste_expression      : expression   {$$ = $1;}
                      | liste_expression VIRGULE expression    {$$ = concat_pere_frere($1, $3);}
;


expression            : expression OU expression_1    {$$ = concat_pere_fils(creer_noeud(A_OU,-1),concat_pere_frere($1,$3));}
                      | expression_1 {$$ = $1 ; }
;

expression_1          : expression_1 ET expression_2   {$$ = concat_pere_fils(creer_noeud(A_ET,-1),concat_pere_frere($1,$3));}
		              | expression_2 {$$ = $1 ;}
;

expression_2          : expression_2 operateur1 expression_3  {$$ = concat_pere_fils($2,concat_pere_frere($1,$3));}
		              | expression_3 {$$ = $1 ;}
;

expression_3          : expression_3 operateur2 expression_4 {$$ = concat_pere_fils($2,concat_pere_frere($1,$3));}
                      | CSTE_CHAINE {$$ =creer_noeud(A_CST_CHAINE,$1);}
                      | CSTE_CARACTERE {$$ =creer_noeud(A_CST_CARAC,$1);}
                      | CSTE_BOOL {$$ =creer_noeud(A_CST_BOOL,$1);}
		              | expression_4 {$$ = $1 ;}
;

expression_4          : expression_4 operateur3 expression_5   {$$ = concat_pere_fils($2,concat_pere_frere($1,$3));}
		              | expression_5 {$$ = $1 ;}
;

expression_5          : expression_5 operateur4 expression_6  {$$ = concat_pere_fils($2,concat_pere_frere($1,$3));}
		              | expression_6 {$$ = $1 ;}
;

expression_6          : CSTE_ENTIERE {$$ =creer_noeud(A_CSTE,$1);}
                      | CSTE_REEL {$$ = creer_noeud(A_CSTR,$1);}
		              | PARENTHESE_OUVRANTE expression PARENTHESE_FERMANTE {$$ = $2;}
                      | variable { $$ = $1;}
                      | appel { $$ = $1;}
	                // | IDF operateur_unaire
;

operateur1             : EGALE {$$ =creer_noeud(A_EGALE,-1);}
                       | DIFF  {$$ =creer_noeud(A_DIFF,-1);}
;

operateur2             : CHEVRON_INF_EGALE {$$ =creer_noeud(A_INF_EGALE,-1);}
                       | CHEVRON_SUP_EGALE {$$ =creer_noeud(A_SUP_EGALE,-1);}
                       | CHEVRON_INF {$$ =creer_noeud(A_INF,-1);}
                       | CHEVRON_SUP {$$ =creer_noeud(A_SUP,-1);}
;

operateur3             : PLUS {$$ =creer_noeud(A_PLUS,-1);}
                       | MOINS {$$ =creer_noeud(A_MOINS,-1);}
;

operateur4             : MULT {$$ =creer_noeud(A_MULT,-1);}
                       | DIV {$$ =creer_noeud(A_DIV,-1);}
                       | MODULO {$$ =creer_noeud(A_MODULO,-1);}
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
    initialisation_table_declaration(&table_declar);
    arbre_instruction = arbre_vide();
    
    yyparse();
    
    
    //afficher_table_hashcode(table_hashcode);
    //afficher_table_lexicographique(&tab_lex, 100);
    afficher_arbre_horizontal(arbre_instruction, 6, 0, stdout);
    
    exit(0);

}


int yyerror(){
    fprintf(stderr,"Erreur de syntaxe a la ligne %d pres du caractere %d \n", nb_ligne, caractere);
    return 0;
}


