#include <stdio.h>
#include <stdlib.h>
#include <string.h>
//#include "define.h"
#include "arbre.h"
#include "table_region.h"
#include "mon_allocation.h"
#include <math.h>


void initialisation_table_region(tab_region* table_reg){
  int i=0;

  table_reg->courant=0;
  while(i<TAILLE_TABLE_REGION){
    
    table_reg->taille[i] = 1;
    table_reg->nis[i] = 0;
    table_reg->p_arbre[i] = arbre_vide();
    i++;
  };

}

void ajouter_region(int taille,int nis,arbre p_arbre,tab_region* tab_reg){
  
  if(tab_reg->courant<TAILLE_TABLE_REGION){
     tab_reg->courant+=1;
    tab_reg->taille[tab_reg->courant] = taille;
    tab_reg->nis[tab_reg->courant] = nis;
    tab_reg->p_arbre[tab_reg->courant] = p_arbre;
  
  }
}

void afficher_table_region(tab_region *tab_reg){
  int j,i=0;
  int decalage=0;
  int taille;
  fprintf(stdout, "|------------|--------------|-----------|\n");
  fprintf(stdout, "|   taille   |      NIS     |   arbre   |\n");
  fprintf(stdout, "|------------|--------------|-----------|\n");
 
  while (i<TAILLE_TABLE_REGION && i< tab_reg->courant){
    /*Affichage taille*/
     fprintf(stdout,"|");
     //taille=(int)log10(tab_reg->taille[i])+1;
      taille=1;
    decalage=12/(taille/2);
    for(j=0;j<decalage;j++){
      fprintf(stdout," ");
    }
    fprintf(stdout,"%d",tab_reg->taille[i]);
    for(j=0;j<12-decalage-1;j++){
      fprintf(stdout," ");
    }  
    fprintf(stdout,"|");
    /*Affichage nis*/
   
    //taille=(int)log10(tab_reg->nis[i])+1;
   taille=1;
    decalage=12/(taille/2);
    for(j=0;j<decalage;j++){
      fprintf(stdout," ");
    }
    fprintf(stdout,"%d",tab_reg->nis[i]);
    for(j=0;j<12-decalage+1;j++){
      fprintf(stdout," ");
    }  
   

    /*Affichage arbre*/
    fprintf(stdout,"|");
    if(est_vide(tab_reg->p_arbre[i])){

	taille=4;
	  }
      else{
	taille=12;
      }
      decalage=12/(taille/2);
      for(j=0;j<decalage;j++){
	fprintf(stdout," ");
      }
      fprintf(stdout,"%p",tab_reg->p_arbre[i]);
      for(j=0;j<taille-decalage;j++){
	fprintf(stdout," ");
	
      }
       fprintf(stdout,"|\n");
    i++;
  }
   fprintf(stdout, "|------------|--------------|-----------|\n");
}

int main(){

  tab_region tab_reg;
  arbre a=arbre_vide();arbre b=arbre_vide();
  initialisation_table_region(&tab_reg);
    ajouter_region( 1, 3,a,&tab_reg);
  ajouter_region( 4, 2,b,&tab_reg);
  afficher_table_region(&tab_reg);

}
