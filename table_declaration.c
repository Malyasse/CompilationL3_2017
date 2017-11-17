#include <stdio.h>
#include <stdlib.h>

#include "table_declaration.h"




void initialisation_table_declaration(table_declaration* table){   /*Duraj Bastien*/
    int i;
    
    for (i=0; i<TAILLE_TABLE_DECLARATION+TAILLE_ZONE_DEBORDEMENT; i++){   /* pour chaque entree de la table on initialise les valeurs a 0 sauf pour le champ suivant a -1 */
        table->nature[i] = 0;
        table->region[i] = 0;
        table->description[i] = 0;
        table->execution[i] = 0;
        table->suivant[i] = -1;   
    }
    
    table->dernier_debordement = TAILLE_ZONE_DEBORDEMENT;   /* fixe l'indice du premier element disponible pour le debordement a la fin de la zone primaire */

}


void ajouter_declaration(table_declaration* table, int num_lex, int nature, int region, int description, int execution){   /*Duraj Bastien*/
    
    table->nature[num_lex] = nature;    /* rempli les champs de la nouvelle declaration dans la table primaire */
    table->region[num_lex] = region;
    table->description[num_lex] = description;
    table->execution[num_lex] = execution;
    table->suivant[num_lex] = -1;   /* pas encore de suivant */

}


int ajouter_debordement(table_declaration* table, int nature, int region, int description, int execution){    /*Duraj Bastien*/

    if (table->dernier_debordement < TAILLE_TABLE_DECLARATION+TAILLE_ZONE_DEBORDEMENT){  /* verifie que la partie debordement ne soit pas rempli */
        table->nature[table->dernier_debordement] = nature;   /* rempli les champs a la suite des autres declarations de la zone de debordement */
        table->region[table->dernier_debordement] = region;
        table->description[table->dernier_debordement] = description;
        table->execution[table->dernier_debordement] = execution;
        table->suivant[table->dernier_debordement] = -1;
        
        table->dernier_debordement ++;  /* defini le prochaine emplacement pour l'insertion */
        return table->dernier_debordement-1  /* retourne l'indice de la declaration */;
    }else{
        fprintf(stdout, "Plus de place dans la partie debordement de la table des declarations.\n");  /* message si zone pleine */
        return -1;   /* l'indice du suivant sera donc toujours de -1 */
    }

}


void inserer_declaration(table_declaration* table, int num_lex, int nature, int region, int description, int execution){    /*Duraj Bastien*/
     int indice;
     int i;

     if (table->nature[num_lex] != 0){   // verifie si le champ est utilise
         indice = ajouter_debordement(table, nature, region, description, execution);  // si oui ajoute la declaration dans la zone de debordement
         
         i = num_lex;  // cherche la derniere declaration de meme num_lex et change le champ suivant pour les chaines les declarations
         while(table->suivant[i] != -1)
             i = table->suivant[i];
         table->suivant[i] = indice;
     }else{
         ajouter_declaration(table, num_lex, nature, region, description, execution);  // si tout va bien on ajoute la declaration a l'indice num_lex de la zone primaire
     }

}


int recupere_type(table_declaration* table, int num_lex){    /*Duraj Bastien*/

    return table->nature[num_lex];   // retourne la nature de la declaration de numero num_lex

}


void afficher_table_declaration(table_declaration* table){   /*Duraj Bastien*/


}




