
%{
    #include <stdio.h>
    #include <stdlib.h>
    
    #include "arbre.h"
    #include "table_lexicographique.h"
    #include "table_declaration.h"
    #include "table_region.h"
    #include "table_type.h"
    #include "pile.h"
    #include "y.tab.h"
    #include "grammaire_CPYRR.h"
  
    int region = 0;
    int decalage = 0;
    int taille_region = 0;
    int dernier;
    int nature = 0;
    int declaration_en_cours;
    int dimension_tableau;
    int compteur_elements;
    int appel_en_cours;
    int nombre_arguments = 0 ;
    int indice_lexeme = 0  ;
    int retour_arg_valide;
    int resultat_expression;
    int expression_bool=0;
    int future_type=0;
    int condition_t; //Permet de savoir si on est dans une condition if , while ,tant que
    table_declaration table_declare;
    tab_region tab_reg;
    table_type tab_type;
	Pile pile;
    
    extern char* yytext;
    extern int nb_ligne;
    extern int caractere;
    extern int table_hashcode[TAILLE_TAB_HASH_CODE];
    extern tab_lexico tab_lex;
	
	
    int yylex();
    int yyerror();
    
   
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


%type<type2> nom_type type_simple
%type<type1> suite_liste_inst instruction liste_instructions corps programme
%type<type1> affectation condition tant_que appel liste_variables suite_ecriture format resultat_retourne 
%type<type1> expression variable liste_expression un_arg liste_args liste_arguments suite_variable1 expression_1 expression_2 expression_3 expression_4 expression_5 expression_6  
%type<type1> operateur1 operateur2 operateur3 operateur4 operateur_unaire


%%
programme             : PROG  corps    {$$ = $2; pile = depile(pile); afficher_arbre_horizontal($2, 6, 1, stdout); /*afficher_arbre($3);*/}
;

corps                 :  {pile = empile(pile, region); $$ = arbre_vide(); ajouter_region(0, sous_sommet(pile), arbre_vide(), &tab_reg); region ++; pile = depile(pile);}
                      | {pile = empile(pile, region); ajouter_region(0, sous_sommet(pile), NULL, &tab_reg); region ++; } liste_declarations {set_taille_region(taille_region, &tab_reg, sous_sommet(pile)); taille_region = 0;}   liste_instructions {$$ = $4; set_arbre_region($4, &tab_reg, premier_element_pile(pile)); pile = depile(pile);}
                      | liste_instructions  {$$ = $1; pile = empile(pile, region); ajouter_region(0, sous_sommet(pile), NULL, &tab_reg); region ++; set_arbre_region($1, &tab_reg, premier_element_pile(pile)); pile = depile(pile);}
;

liste_declarations    : declaration POINT_VIRGULE {fprintf(stderr,"ici \n");}
                      | liste_declarations declaration POINT_VIRGULE {fprintf(stderr,"ici2 \n");}
;

liste_instructions    : DEBUT suite_liste_inst FIN {$$ = $2;}
;

suite_liste_inst      : VIDE {$$ = creer_noeud(A_VIDE, -1);}
                      | instruction POINT_VIRGULE { $$ = concat_pere_fils(creer_noeud(A_LISTE,-1), $1);}
                      | suite_liste_inst instruction POINT_VIRGULE { $$ = concat_pere_fils(creer_noeud(A_LISTE, -1 ), concat_pere_frere($1, $2));}
;

declaration           : declaration_type {fprintf(stderr,"ici 4 \n");}
                      | declaration_variable {fprintf(stderr,"ici5 \n");}
                      | declaration_procedure{fprintf(stderr,"ici 6\n");}
                      | declaration_fonction {fprintf(stderr,"ici 7\n");}
;

declaration_type      : TYPE IDF DEUX_POINTS { compteur_elements = 0 ;dernier = tab_type.dernier ; tab_type.dernier +=1; declaration_en_cours =1; } suite_declaration_type  {inserer_declaration(&table_declare, $2, nature, premier_element_pile(pile), dernier, /*taille d'une valeure de ce type*/ 0); nature = 0;}
;

suite_declaration_type : STRUCT {nature = TYPE_S;} liste_champs FSTRUCT {insere_dimension ( compteur_elements , dernier ,&tab_type); declaration_en_cours = 0;}
                       | TABLEAU {nature = TYPE_T;} dimension {insere_dimension ( compteur_elements , dernier ,&tab_type);} DE nom_type {insere_type($6 ,&tab_type); declaration_en_cours = 0;}
;

dimension             : CROCHET_OUVRANT liste_dimensions CROCHET_FERMANT
;
    
liste_dimensions      : une_dimension
                      | liste_dimensions VIRGULE une_dimension
;

une_dimension         : CSTE_ENTIERE POINT_POINT CSTE_ENTIERE  { if(declaration_en_cours ==1 ){insere_type($1 ,&tab_type); insere_type($3 ,&tab_type); compteur_elements++; }} // expression POINT_POINT expression changer
;

liste_champs          : un_champ POINT_VIRGULE
                      | liste_champs un_champ POINT_VIRGULE
;

un_champ              : IDF DEUX_POINTS nom_type {insere_type($1 ,&tab_type); if (declaration_en_cours == 1) {insere_type($3 ,&tab_type); compteur_elements++;} }
;

nom_type              : type_simple    {$$ = $1;}
                      | IDF    {$$ = $1;}
;

type_simple           : ENTIER        {$$ = $1;}
                      | REEL          {$$ = $1;}
                      | BOOLEEN       {$$ = $1;}
                      | CARACTERE     {$$ = $1;}
                      | CHAINE CROCHET_OUVRANT expression CROCHET_FERMANT  {$$ = $1;}
;

declaration_variable  : VARIABLE IDF DEUX_POINTS nom_type   {/* verifie_type($4);*/ inserer_declaration(&table_declare, $2, VAR, premier_element_pile(pile), $4,/*deplacement a l'execution*/ 0); taille_region += 1;}   // assoc($4),    / taille_region += taille_type(assoc($4))
;

declaration_procedure : PROCEDURE IDF /*Pas oublier declaration type faire lien avec dernier pour inserer description*/{ compteur_elements = 0 ;dernier = tab_type.dernier ; tab_type.dernier +=1; declaration_en_cours =1;} liste_parametres DEUX_POINTS  {insere_dimension ( compteur_elements , dernier ,&tab_type); inserer_declaration(&table_declare, $2, PROC, premier_element_pile(pile), dernier, region); declaration_en_cours = 0;} corps   //insere le nombre de parametre ( va par pere lexeme + type)
;

declaration_fonction  : FONCTION IDF { compteur_elements = 0 ;dernier = tab_type.dernier ; tab_type.dernier +=1; declaration_en_cours =1;} liste_parametres RETOURNE type_simple /*valeur de retour inserer auto */DEUX_POINTS  {insere_dimension ( compteur_elements , dernier ,&tab_type);  insere_type($6 ,&tab_type); inserer_declaration(&table_declare, $2, FUN, premier_element_pile(pile), dernier, region); declaration_en_cours = 0;}  corps
;

liste_parametres      :
                      | PARENTHESE_OUVRANTE liste_param PARENTHESE_FERMANTE
                      ;

liste_param           : un_param   {}
                      | liste_param POINT_VIRGULE un_param    //{inserer_declaration(&table_declare, $2, PROC, premier_element_pile(pile), dernier, region);}
;

un_param              : IDF DEUX_POINTS type_simple { if(declaration_en_cours == 1){ insere_type($1 ,&tab_type); compteur_elements++; insere_type($3 ,&tab_type); inserer_declaration(&table_declare, $1, VAR, region, $3, /* taille du type a l'execution  ,REGION+1 ?*/ 0);} }
;

instruction           : affectation  { $$ = $1;}
                      | condition  {$$ = $1;}
                      | tant_que  {$$ = $1;}
                      | appel  {$$ = $1;}
                      | LIRE PARENTHESE_OUVRANTE liste_variables PARENTHESE_FERMANTE   {$$ = concat_pere_fils(creer_noeud(A_LIRE, $1), $3);}
                      | ECRIRE PARENTHESE_OUVRANTE format suite_ecriture PARENTHESE_FERMANTE  {$$ = concat_pere_fils(creer_noeud(A_ECRIRE, $1), concat_pere_frere($3, $4));}
                      | VIDE   {$$ = creer_noeud(A_VIDE, -1);}
                      | RETOURNE resultat_retourne  {$$ = concat_pere_fils(creer_noeud(A_RETOURNE, $1), $2);} 
;

format                : CSTE_CHAINE    {$$ = creer_noeud(A_CST_CHAINE, $1);} 
;

suite_ecriture        :        {$$ = arbre_vide();}
                      | VIRGULE variable suite_ecriture  {$$ = concat_pere_frere($2, $3);}
                      ;

resultat_retourne     :      {$$ = arbre_vide();}
                      | expression  {$$ = $1;}
                      ;

appel                 : IDF {appel_en_cours = 1 ;  nombre_arguments = 0 ; indice_lexeme = association_de_noms( $1) ;} liste_arguments   /* verifie_type($1); */ {$$ = concat_pere_fils(creer_noeud(A_IDF,$1), $3);}  //Mettre PROCEDURE liste_arguments || FONCTION liste_arguments ???
;

liste_arguments       : PARENTHESE_OUVRANTE VIDE PARENTHESE_FERMANTE     {$$ = creer_noeud(A_VIDE, -1);}
                      | PARENTHESE_OUVRANTE liste_args PARENTHESE_FERMANTE  {$$ = $2;}
;

liste_args            : un_arg       {$$ = $1;}
                      | liste_args VIRGULE un_arg    {$$ = concat_pere_frere($1, $3);}
;

un_arg                : expression      {if(appel_en_cours == 1 ){ nombre_arguments++;retour_arg_valide=verifier_arguments(indice_lexeme,nombre_arguments, $1 ,&resultat_expression) ;   } $$ = $1;}
;

condition             : SI  expression
                        ALORS liste_instructions 
                        SINON liste_instructions  {$$ = concat_pere_fils(creer_noeud(A_ITE,-1), concat_pere_frere($2, concat_pere_frere($4,$6)));}
                       | SI expression 
                        ALORS liste_instructions {$$ = concat_pere_fils(creer_noeud(A_ITE, -1), concat_pere_frere($2,$4));}
;

tant_que              : TANT_QUE  expression FAIRE liste_instructions   {$$ = concat_pere_fils(creer_noeud(A_TANT_QUE, -1), concat_pere_frere($2,$4));}
;

affectation           : variable OPAFF expression  {$$ = concat_pere_fils(creer_noeud(A_OPAFF,-1),concat_pere_frere($1,$3));}
;

liste_variables       : variable      {$$ = $1;}
                      | liste_variables VIRGULE variable     {$$ = concat_pere_frere($1, $3);} 
;


variable              : IDF      {$$ = creer_noeud(A_IDF, $1);}
                      | IDF CROCHET_OUVRANT {dimension_tableau = 1;} liste_expression CROCHET_FERMANT suite_variable1 {dimension_tableau = 0 ;$$ = concat_pere_fils(creer_noeud(A_IDF, $1),concat_pere_frere($4,$6 ));} //verifier_arguments
                      | IDF POINT variable   {$$ = concat_pere_fils(creer_noeud(A_IDF, $1),concat_pere_fils(creer_noeud(A_POINT, -1), $3) );}
                      ;


suite_variable1       :      {$$ = arbre_vide();}
                      | POINT variable   {$$ = concat_pere_fils(creer_noeud(A_POINT, -1), $2);}
;  


liste_expression      : expression  {$$ = $1;  if(dimension_tableau == 1 ){ nombre_arguments++;retour_arg_valide=verifier_arguments(indice_lexeme,nombre_arguments, $1 ,&resultat_expression) ;}} // Si liste_expression de tableau element ++
                      | liste_expression VIRGULE expression    {$$ = concat_pere_frere($1, $3);}
;


expression            : expression OU expression_1    {$$ = concat_pere_fils(creer_noeud(A_OU,-1),concat_pere_frere($1,$3));}
                      | operateur_unaire expression_1        {$$ = concat_pere_fils($1, $2);}
                      | expression_1   {$$ = $1 ;}
;

expression_1          : expression_1 ET expression_2   {$$ = concat_pere_fils(creer_noeud(A_ET,-1),concat_pere_frere($1,$3));}
		              | expression_2    {$$ = $1 ;}
;

expression_2          : expression_2 operateur1 expression_3   {$$ = concat_pere_fils($2,concat_pere_frere($1,$3));}
		              | expression_3   {$$ = $1 ;}
;

expression_3          : expression_3 operateur2 expression_4  {$$ = concat_pere_fils($2,concat_pere_frere($1,$3));}
                      | CSTE_BOOL   {$$ =creer_noeud(A_CST_BOOL,$1);}
		              | expression_4   {$$ = $1 ;}
;

expression_4          : expression_4 operateur3 expression_5   {$$ = concat_pere_fils($2,concat_pere_frere($1,$3));}
		              | expression_5   {$$ = $1 ;}
;

expression_5          : expression_5 operateur4 expression_6  {$$ = concat_pere_fils($2,concat_pere_frere($1,$3));}
		              | expression_6 {$$ = $1 ;}
;

expression_6          : CSTE_ENTIERE  {$$ =creer_noeud(A_CSTE,$1);}
                      | CSTE_REEL   {$$ = creer_noeud(A_CSTR,$1);}
                      | CSTE_CHAINE  {$$ =creer_noeud(A_CST_CHAINE,$1);}
                      | CSTE_CARACTERE  {$$ =creer_noeud(A_CST_CARAC,$1);}
		              | PARENTHESE_OUVRANTE expression PARENTHESE_FERMANTE   {$$ = $2;}
                      | variable   { $$ = $1;}
                      | appel   { $$ = $1;}
;

operateur1             : EGALE    {$$ =creer_noeud(A_EGALE,-1);}
                       | DIFF     {$$ =creer_noeud(A_DIFF,-1);}
;

operateur2             : CHEVRON_INF_EGALE    {$$ =creer_noeud(A_INF_EGALE,-1);}
| CHEVRON_SUP_EGALE    {$$ =creer_noeud(A_SUP_EGALE,-1);}
                       | CHEVRON_INF    { $$ =creer_noeud(A_INF,-1);}
                       | CHEVRON_SUP     { $$ =creer_noeud(A_SUP,-1);}
;

operateur3             : PLUS   {$$ =creer_noeud(A_PLUS,-1);}
                       | MOINS   {$$ =creer_noeud(A_MOINS,-1);}
;

operateur4             : MULT   {$$ =creer_noeud(A_MULT,-1);}
                       | DIV     {$$ =creer_noeud(A_DIV,-1);}
                       | MODULO {$$ =creer_noeud(A_MODULO,-1);}
;

operateur_unaire         : INCREMENT      {$$ =creer_noeud(A_INCREMENT,-1);}
                         | DECREMENT      {$$ =creer_noeud(A_DECREMENT,-1);} 
                         | NON        {$$ =creer_noeud(A_NON,-1);}
			             ;
			  
%%




int association_de_noms(int numero_lexico ){/*Carreteros Laetitia*/
  int region_haute = premier_element_pile(pile);
  int indice= numero_lexico;
  do { 
    if(table_declare.region[indice] == region_haute){
      return indice;
    }
    indice = table_declare.suivant[indice];
  }while(indice != -1);
  fprintf(stderr,"Erreur , variable non déclaré ligne %d caractere %d \n",nb_ligne, caractere);
  return -1;
}

int verifier_arguments(int indice_lexeme_appel,int nombre_arguments, arbre arbre_expression , int* erreur){/*Carreteros Laetitia*//*Renvoie valeur de l'expression calculer a partir de l'arbre*/
 int valide , nature_expression , nombre_arguments_origine , valeur_expression;
 int indice_debut_description;
 int borne_inf, borne_sup;
 int i=0; 
 
 nombre_arguments_origine = tab_type.tab[table_declare.description[indice_lexeme_appel]];
 indice_debut_description = table_declare.description[indice_lexeme_appel];
switch(table_declare.nature[indice_lexeme_appel]){
	case PROC: 

	    /**Quand le nombre d'arguments est supérieur **/
		if(nombre_arguments_origine < nombre_arguments){
   			 fprintf(stderr,"procedure %s Nombre arguments dépasser : <procedure> ", tab_lex.lexeme[indice_lexeme_appel]);//nom procedure
   			 indice_debut_description += 2; //modifier quand machien virituelle mise TODO
   			 for(i=0;i<nombre_arguments_origine;i++){
			 fprintf(stderr ," type <%s> ",tab_lex.lexeme[tab_type.tab[indice_debut_description]]);  //	fprintf(stderr ," type <%s> ",tab_lex.lexeme[indice_debut_description]);
   			 	indice_debut_description += 2; 
   			 }
   			 fprintf(stderr ,";\n");
    	     *erreur = -1;
   			 return -1;
         }else{
         /** Verifier argument**/
         	valeur_expression = analyse_expression(arbre_expression,erreur,&nature_expression);
            if(nature_expression != tab_type.tab[indice_debut_description+ 2*nombre_arguments]){//ajouter 1 pour machine virtuelle
         		fprintf(stderr ," procedure %s argument %d incorrect type <%s> attendu ligne %d caractere %d \n",tab_lex.lexeme[indice_lexeme_appel],nombre_arguments,tab_lex.lexeme[tab_type.tab[indice_debut_description + 2* nombre_arguments]], nb_ligne , caractere);
         		*erreur = -1;
         		return -1;
             }
             return 0;  
         }
   
		break;
	case FUN:

	    if(nombre_arguments_origine < nombre_arguments){
   			 fprintf(stderr,"fonction %s Nombre arguments dépasser : <function> ", tab_lex.lexeme[indice_lexeme_appel]);//nom fonction
   			 indice_debut_description += 2; 
   			 for(i=0;i<nombre_arguments_origine;i++){
   			 	fprintf(stderr ," type <%s> ",tab_lex.lexeme[indice_debut_description]);
   			 	indice_debut_description += 2; 
   			 }
   			 fprintf(stderr ,"return <%s> ;\n" ,tab_lex.lexeme[indice_debut_description+1]) ;
    	     *erreur = -1;
   			 return -1;
         }else{
        	 valeur_expression = analyse_expression(arbre_expression,erreur,&nature_expression);
          	 if(nature_expression != tab_type.tab[indice_debut_description + 2*nombre_arguments]){//ajouter 1 pour machine virtuelle
         		fprintf(stderr ," %d fonction %s argument %d incorrect type <%s> attendu ligne %d caractere %d \n",indice_lexeme_appel,tab_lex.lexeme[indice_lexeme_appel],nombre_arguments,tab_lex.lexeme[tab_type.tab[indice_debut_description + 2* nombre_arguments]] , nb_ligne , caractere);/*Quand surcharge revoir pour afficher nom lexeme*/
         		*erreur = -1;
         		return -1;
             }
             return 0; 
         }
		break;
	case TYPE_S:
		break;
	case TYPE_T:
		if(nombre_arguments_origine < nombre_arguments){
			 fprintf(stderr,"Erreur ligne %d ,Tableau %s <type> hors dimension : <tableau> ", nb_ligne,tab_lex.lexeme[indice_lexeme_appel] );  
	     	 indice_debut_description += 2; 
			 for(i=0;i<nombre_arguments_origine;i++){
   			 	fprintf(stderr ," [%d .. %d]> ",tab_type.tab[indice_debut_description],tab_type.tab[indice_debut_description+1]);  
   			 	indice_debut_description +=2;			 	
   			 }
   			 *erreur = -1;
         		return -1;
		}
		else{
			valeur_expression = analyse_expression(arbre_expression,erreur,&nature_expression);
		    if(nature_expression != E_INT){
		    	fprintf(stderr,"Erreur  ligne %d Tableau %s dimension  = entier , ici reçu nature : %s " , nb_ligne,tab_lex.lexeme[indice_lexeme_appel],tab_lex.lexeme[nature_expression]  )
		    	;*erreur = -1; fprintf(stderr ,";\n");
   			    return -1;
		    }else{
		    	borne_inf=tab_type.tab[indice_debut_description+2*nombre_arguments];
		    	borne_sup=tab_type.tab[indice_debut_description+(2*nombre_arguments)+1];
		    	
		        if(valeur_expression < borne_inf || valeur_expression > borne_sup){
		        
		        	fprintf(stderr,"Erreur de borne ligne %d Tableau %s [%d .. %d]",nb_ligne , tab_lex.lexeme[indice_lexeme_appel],borne_inf , borne_sup);
		        }
		         return 0; 	    
		    }
		}
		
		break;
	default:
		fprintf(stderr,"Autre cas gérer dans verifier arguments\n"); return 0; 

   }
   return 0;


}

void verifier_nbr_arguments_suffisant(){

}

int analyse_expression(arbre a, int* erreur, int* nature){     /* Duraj Bastien */
    int r1, r2;
    int n = 0;
    int n1;
    
    
    if (est_vide(a)){    // ne devrait jamais arriver
    	return 0;
    }
    
    
    switch (a->type_noeud){
    
    case A_PLUS:
        r1 = analyse_expression(a->fils, erreur, &n);
        
        n1 = n;
        r2 = analyse_expression(a->frere, erreur, &n);
        if (n != n1){
            *erreur = CONFLIT_TYPE;
            return -1;
        }
    
    	return r1 + r2;      // reste a verifier si les types sont non evaluables
        
    case A_MOINS:
        r1 = analyse_expression(a->fils, erreur, &n);
        
        n1 = n;
        r2 = analyse_expression(a->frere, erreur, &n);
        if (n != n1){
            *erreur = CONFLIT_TYPE;
            return -1;
        }
    
    	return r1 - r2;     // reste a verifier si les types sont non evaluables
        
    case A_MULT:
        r1 = analyse_expression(a->fils, erreur, &n);
        
        n1 = n;
        r2 = analyse_expression(a->frere , erreur, &n);
        if (n != n1){
            *erreur = CONFLIT_TYPE;
            return -1;
        }
        
        return r1*r2;     // reste a verifier si les types sont non evaluables
        
    case A_MODULO:
        r1 = analyse_expression(a->fils, erreur, &n);
        
        n1 = n;
        r2 = analyse_expression(a->frere , erreur, &n);
        
        if (n1 == n){
            if ((r2) != 0)
        	    return r1%r2;     // reste a verifier si les types sont non evaluables
        	else{
        	    if (*erreur == ERREUR_VIDE)
        	        *erreur = DIV_ZERO;
        	    return 0;
        	}
    	}else{
            *erreur = CONFLIT_TYPE;
            return -1;
    	}
        
    case A_DIV:
        r1 = analyse_expression(a->fils, erreur, &n);
        
        n1 = n;
        r2 = analyse_expression(a->frere , erreur, &n);
        
        if (n1 == n){
            if ((r2) != 0)
        	    return r1/r2;     // reste a verifier si les types sont non evaluables
        	else{
        	    if (*erreur == ERREUR_VIDE)
        	        *erreur = DIV_ZERO;
        	    return 0;
        	}
    	}else{
            *erreur = CONFLIT_TYPE;
            return -1;
    	}
        
    case A_INF:
        r1 = analyse_expression(a->fils, erreur, &n);
        /*if (*erreur != ERREUR_VIDE)
             return -1;*/
        n1 = n;
        r2 = analyse_expression(a->frere , erreur, &n);
        /*if (*erreur != ERREUR_VIDE)
            return -1;*/
            
        if (n != n1)
            *erreur = CONFLIT_TYPE;
        
        *nature = E_BOOL;
        return a->num_lexico;
        
    case A_INF_EGALE:
        r1 = analyse_expression(a->fils, erreur, &n);
        /*if (*erreur != ERREUR_VIDE)
             return -1;*/
        n1 = n;
        r2 = analyse_expression(a->frere , erreur, &n);
        /*if (*erreur != ERREUR_VIDE)
            return -1;*/
            
        if (n != n1)
            *erreur = CONFLIT_TYPE;
        
        *nature = E_BOOL;
        return a->num_lexico;
        
    case A_SUP:
        r1 = analyse_expression(a->fils, erreur, &n);
        /*if (*erreur != ERREUR_VIDE)
             return -1;*/
        n1 = n;
        r2 = analyse_expression(a->frere , erreur, &n);
        /*if (*erreur != ERREUR_VIDE)
            return -1;*/
            
        if (n != n1)
            *erreur = CONFLIT_TYPE;
        
        *nature = E_BOOL;
        return a->num_lexico;
        
    case A_SUP_EGALE:
        r1 = analyse_expression(a->fils, erreur, &n);
        /*if (*erreur != ERREUR_VIDE)
             return -1;*/
        n1 = n;
        r2 = analyse_expression(a->frere , erreur, &n);
        /*if (*erreur != ERREUR_VIDE)
            return -1;*/
            
        if (n != n1)
            *erreur = CONFLIT_TYPE;
        
        *nature = E_BOOL;
        return a->num_lexico;
        
    case A_DIFF:
        r1 = analyse_expression(a->fils, erreur, &n);
        /*if (*erreur != ERREUR_VIDE)
             return -1;*/
        n1 = n;
        r2 = analyse_expression(a->frere , erreur, &n);
        /*if (*erreur != ERREUR_VIDE)
            return -1;*/
            
        if (n != n1)
            *erreur = CONFLIT_TYPE;
        
        *nature = E_BOOL;
        return a->num_lexico;
        
    case A_EGALE:
        r1 = analyse_expression(a->fils, erreur, &n);
        /*if (*erreur != ERREUR_VIDE)
             return -1;*/
        n1 = n;
        r2 = analyse_expression(a->frere , erreur, &n);
        /*if (*erreur != ERREUR_VIDE)
            return -1;*/
            
        if (n != n1)
            *erreur = CONFLIT_TYPE;
        
        *nature = E_BOOL;
        return a->num_lexico;
        
    case A_CSTE:
        *erreur = EVAL; 
        *nature = E_INT;      // remplacer par la valeur de la table des daclarations
        return a->num_lexico;
        
    case A_CSTR:
        *erreur = NON_EVAL;
        *nature = E_REEL;         // remplacer par la valeur de la table des daclarations
        return a->num_lexico;
        
    case A_CST_CHAINE:
        *erreur = NON_EVAL;
        *nature = E_CHAINE;       // remplacer par la valeur de la table des daclarations
        return a->num_lexico;
        
    case A_CST_BOOL:
        *erreur = NON_EVAL;
        *nature = E_BOOL;         // remplacer par la valeur de la table des daclarations
        return a->num_lexico;
        
    case A_CST_CARAC:
        *erreur = NON_EVAL;
        *nature = E_CARAC;      // remplacer par la valeur de la table des daclarations
        return a->num_lexico;
        
    case A_IDF:
        *erreur = NON_EVAL;
        *nature = E_INT;    // recupere le type du lexeme recupere_type(association_noms(a->num_lex))
        return a->num_lexico;
        
    default:
        *erreur = NOEUD_INCONNU;
        return -1;
    
    }
 }
int main(){

  init_hashcode(table_hashcode);
  initialisation_tab_lex(TAILLE_TAB_LEXICO, &tab_lex, table_hashcode);
  initialisation_table_declaration(&table_declare);
  initialisation_table_region(&tab_reg);
  initialisation_table_type(&tab_type);
  
  yyparse();

  //afficher_table_hashcode(table_hashcode);
  afficher_table_lexicographique(&tab_lex, -1);
  afficher_table_type(&tab_type);
  afficher_table_declaration(&table_declare, 25);
 // afficher_table_region(&tab_reg);
  exit(0);

}
int yyerror(){
    fprintf(stderr,"Erreur de syntaxe a la ligne %d pres du caractere %d \n", nb_ligne, caractere);
    return 0;
}

/*int verification_arguments_fonction(table_declaration tabl_dec,){


}*/








