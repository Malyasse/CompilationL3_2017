#include <stdio.h>
#include <stdlib.h>
#include <math.h>



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
    int i = 0;
    int j;
    int taille;


    fprintf(stdout, "Affichage de la table des declarations\n\n");
    
    fprintf(stdout, "|----------------|------------------|----------------------|---------------------------|-------------------------|---------------------|\n");
    fprintf(stdout, "|                                                     ZONE PRIMAIRE                                                                    |\n");
    fprintf(stdout, "|----------------|------------------|----------------------|---------------------------|-------------------------|---------------------|\n");
    fprintf(stdout, "|     indice     |      Nature      |        Region        |        Description        |        Execution        |       Suivant       |\n");
    fprintf(stdout, "|----------------|------------------|----------------------|---------------------------|-------------------------|---------------------|\n");
 
 
    while (i < TAILLE_TABLE_DECLARATION){   //table->dernier
    
       fprintf(stdout,"|        %d", i);
       
       if (i == 0){
           taille = 1;
       }else if (i > 0){
           taille = (int) log10(i)+1;
       }else{
           taille = 2;
       }
       
       for (j=0; j < 8-taille; j++)
           fprintf(stdout," ");
           
           
       fprintf(stdout,"|       %d", table->nature[i]);
       
       if (table->nature[i] == 0){
           taille = 1;
       }else if (table->nature[i] > 0){
           taille = (int) log10(table->nature[i])+1;
       }else{
           taille = 2;
       }
       
       for (j=0; j < 11-taille; j++)
           fprintf(stdout," ");
           
           
       fprintf(stdout,"|          %d", table->region[i]);
       
       if (table->region[i] == 0){
           taille = 1;
       }else if (table->region[i] > 0){
           taille = (int) log10(table->region[i])+1;
       }else{
           taille = 2;
       }
       
       for (j=0; j < 12-taille; j++)
           fprintf(stdout," ");
           
           
       fprintf(stdout,"|              %d", table->description[i]);
       
       if (table->description[i] == 0){
           taille = 1;
       }else if (table->description[i] > 0){
           taille = (int) log10(table->description[i])+1;
       }else{
           taille = 2;
       }
       
       for (j=0; j < 13-taille; j++)
           fprintf(stdout," ");
           
           
       fprintf(stdout,"|             %d", table->execution[i]);
       
       if (table->execution[i] == 0){
           taille = 1;
       }else if (table->execution[i] > 0){
           taille = (int) log10(table->execution[i])+1;
       }else{
           taille = 2;
       }
       
       for (j=0; j < 12-taille; j++)
           fprintf(stdout," ");
           
           
       fprintf(stdout,"|          %d", table->suivant[i]);
       
       if (table->suivant[i] == 0){
           taille = 1;
       }else if (table->suivant[i] > 0){
           taille = (int) log10(table->suivant[i])+1;
       }else{
           taille = 2;
       }
       
       for (j=0; j < 11-taille; j++)
           fprintf(stdout," ");
    
       fprintf(stdout,"|\n");
       fprintf(stdout, "|----------------|------------------|----------------------|---------------------------|-------------------------|---------------------|\n");
       
       
       i++;
    }
    
    
    fprintf(stdout, "|                                                  ZONE DE DEBORDEMENT                                                                 |\n");
    fprintf(stdout, "|----------------|------------------|----------------------|---------------------------|-------------------------|---------------------|\n");


    i = TAILLE_TABLE_DECLARATION;
    while (i < table->dernier_debordement){       //TAILLE_TABLE_DECLARATION+TAILLE_ZONE_DEBORDEMENT
    
       fprintf(stdout,"|        %d", i);
       
       if (i == 0){
           taille = 1;
       }else if (i > 0){
           taille = (int) log10(i)+1;
       }else{
           taille = 2;
       }
       
       for (j=0; j < 8-taille; j++)
           fprintf(stdout," ");
           
           
       fprintf(stdout,"|       %d", table->nature[i]);
       
       if (table->nature[i] == 0){
           taille = 1;
       }else if (table->nature[i] > 0){
           taille = (int) log10(table->nature[i])+1;
       }else{
           taille = 2;
       }
       
       for (j=0; j < 11-taille; j++)
           fprintf(stdout," ");
           
           
       fprintf(stdout,"|          %d", table->region[i]);
       
       if (table->region[i] == 0){
           taille = 1;
       }else if (table->region[i] > 0){
           taille = (int) log10(table->region[i])+1;
       }else{
           taille = 2;
       }
       
       for (j=0; j < 12-taille; j++)
           fprintf(stdout," ");
           
           
       fprintf(stdout,"|              %d", table->description[i]);
       
       if (table->description[i] == 0){
           taille = 1;
       }else if (table->description[i] > 0){
           taille = (int) log10(table->description[i])+1;
       }else{
           taille = 2;
       }
       
       for (j=0; j < 13-taille; j++)
           fprintf(stdout," ");
           
           
       fprintf(stdout,"|             %d", table->execution[i]);
       
       if (table->execution[i] == 0){
           taille = 1;
       }else if (table->execution[i] > 0){
           taille = (int) log10(table->execution[i])+1;
       }else{
           taille = 2;
       }
       
       for (j=0; j < 12-taille; j++)
           fprintf(stdout," ");
           
           
       fprintf(stdout,"|          %d", table->suivant[i]);
       
       if (table->suivant[i] == 0){
           taille = 1;
       }else if (table->suivant[i] > 0){
           taille = (int) log10(table->suivant[i])+1;
       }else{
           taille = 2;
       }
       
       for (j=0; j < 11-taille; j++)
           fprintf(stdout," ");
    
       fprintf(stdout,"|\n");
       fprintf(stdout, "|----------------|------------------|----------------------|---------------------------|-------------------------|---------------------|\n");
       
       
       i++;
    }
    
    
    fprintf(stdout, "|----------------|------------------|----------------------|---------------------------|-------------------------|---------------------|\n\n\n");


}




