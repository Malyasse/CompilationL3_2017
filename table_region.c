#include <stdio.h>
#include <stdlib.h>
#include <string.h>


#include "arbre.h"
#include "table_region.h"
#include "mon_allocation.h"
#include <math.h>





void initialisation_table_region(tab_region* table_reg){
  int i = 0;

  table_reg->courant = 0;
  while(i<TAILLE_TABLE_REGION){
    
    table_reg->taille[i] = 0;
    table_reg->nis[i] = 0;
    table_reg->p_arbre[i] = arbre_vide();
    i++;
    
  }

}

void ajouter_region(int taille, int nis, arbre p_arbre, tab_region* tab_reg){
  fprintf(stderr, "%d\n", tab_reg->courant);
  
  if(tab_reg->courant < TAILLE_TABLE_REGION){
   
    tab_reg->taille[tab_reg->courant] = taille;
    tab_reg->nis[tab_reg->courant] = nis;
    tab_reg->p_arbre[tab_reg->courant] = p_arbre;
    tab_reg->courant += 1;
    
  }
  
  
}


void set_arbre_region(arbre a, tab_region *tab_region, int num_region){

  tab_region->p_arbre[num_region] = a;

}


void set_taille_region(int taille, tab_region *tab_region, int num_region){

  tab_region->taille[num_region] = taille;

}


void afficher_table_region(tab_region *tab_reg){
    int i = 0;
    int j;
    int taille;



    fprintf(stdout, "Affichage de la table des regions\n\n");
    
    
    fprintf(stdout, "|------------|------------|-------------|-------------------|\n");
    fprintf(stdout, "|   indice   |   taille   |     NIS     |       arbre       |\n");
    fprintf(stdout, "|------------|------------|-------------|-------------------|\n");
 
    while (i< tab_reg->courant){     //&& i<TAILLE_TABLE_REGION
    
        fprintf(stdout,"|     %d", i);
       
        if (i == 0){
            taille = 1;
        }else if (i > 0){
            taille = (int) log10(i)+1;
        }else{
            taille = 2;
        }
       
        for (j=0; j < 7-taille; j++)
            fprintf(stdout," ");
           
           
        fprintf(stdout,"|     %d", tab_reg->taille[i]);
        
        if (tab_reg->taille[i] == 0){
            taille = 1;
        }else if (tab_reg->taille[i] > 0){
            taille = (int) log10(tab_reg->taille[i])+1;
        }else{
            taille = 2;
        }
       
        for (j=0; j < 7-taille; j++)
            fprintf(stdout," ");
            
           
        fprintf(stdout,"|      %d", tab_reg->nis[i]);
       
        if (tab_reg->nis[i] == 0){
            taille = 1;
        }else if (tab_reg->nis[i] > 0){
            taille = (int) log10(tab_reg->nis[i])+1;
        }else{
            taille = 2;
        }
       
        for (j=0; j < 7-taille; j++)
            fprintf(stdout," ");
            
           
        fprintf(stdout,"|   %p", tab_reg->p_arbre[i]);
       
        if (tab_reg->p_arbre[i] == NULL){
            taille = 5;
        }else{
            taille = (int) log10((long) tab_reg->p_arbre[i])+1;
        }
       
        for (j=0; j < 16-taille; j++)
            fprintf(stdout," ");
            
        fprintf(stdout,"|\n");
        fprintf(stdout, "|------------|------------|-------------|-------------------|\n");
        
        
        i++;
    
    }
    
    
    fprintf(stdout, "|------------|------------|-------------|-------------------|\n\n\n");
    
    
}




