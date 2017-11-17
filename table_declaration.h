#ifndef INCLUDED_DECLARATION_H
#define INCLUDED_DECLARATION_H

#include "define.h"



/********************************
Structure : table_declaration
Auteur : Duraj Bastien

********************************/

typedef struct {
    int nature[TAILLE_TABLE_DECLARATION+TAILLE_ZONE_DEBORDEMENT];    // le type de la declaration
    int region[TAILLE_TABLE_DECLARATION+TAILLE_ZONE_DEBORDEMENT];   // le numero de la region 
    int description[TAILLE_TABLE_DECLARATION+TAILLE_ZONE_DEBORDEMENT];   // indice vers la table de representation des types
    int execution[TAILLE_TABLE_DECLARATION+TAILLE_ZONE_DEBORDEMENT];   // donner a utiliser lors de l'interpretaton
    int suivant[TAILLE_TABLE_DECLARATION+TAILLE_ZONE_DEBORDEMENT];   // chaine les declarations de meme numero lexicographique
    
    int dernier_debordement;   // permet de facilement inserer une nouvelle declaration dans la zone de debordement
} table_declaration;


/********************************
Fonction :void initialisation_table_declaration(table_declaration* table);
Auteur : Duraj Bastien

*input
**table: adresse d'une table des declarations non initialise 

********************************/

void initialisation_table_declaration(table_declaration* table);


/********************************
Fonction : void inserer_declaration(table_declaration* table, int num_lex, int nature, int region, int description, int execution);
Auteur : Duraj Bastien

*input
**table: adresse d'une table des declarations initialise
**num_lex: numero lexicographique de la declaration a inserer
**nature: type de la decaration
**region: bloc d'instruction ou la declaration a eu lieu
**description: indice vers la table de representation des types
**execution: donnee pour la machine vitruelle

********************************/

void inserer_declaration(table_declaration* table, int num_lex, int nature, int region, int description, int execution);


/********************************
Fonction :int recupere_type(table_declaration* table, int num_lex);
Auteur : Duraj Bastien

*input
**table: adresse d'une table des declarations remplit
**num_lex: numero lexicographique de la declaration dont on veut recuperer le type

********************************/

int recupere_type(table_declaration* table, int num_lex);


/********************************
Fonction :void afficher_table_declaration(table_declaration* table);
Auteur : Duraj Bastien

*input
**table: adresse d'une table des declarations remplit a afficher dans le terminal

********************************/

void afficher_table_declaration(table_declaration* table);


#endif
