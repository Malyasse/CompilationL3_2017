#include <stdio.h>
#include <stdlib.h>
#include "./mon_allocation.h"
#include "arbre.h"




int est_vide(arbre a){/*Carreteros Laetitia*/
  if(a==NULL){
    return 1;
  }
  return 0;
}


arbre arbre_vide(){/*Carreteros Laetitia*/
  return NULL;

}


arbre creer_noeud(int nouveau_type_noeud,int num_lexico){/*Carreteros Laetitia*/
  arbre nouveau_arbre=allocation_memoire(1,(sizeof(type_arbre)));
  nouveau_arbre->frere=NULL;
  nouveau_arbre->fils=NULL;
  nouveau_arbre->type_noeud=nouveau_type_noeud;
  nouveau_arbre->num_lexico=num_lexico;
  return nouveau_arbre;
 }


arbre concat_pere_frere(arbre arbre_pere,arbre arbre_frere){/*Carreteros Laetitia*/
  arbre_pere->frere=arbre_frere;
  return arbre_pere;
}


arbre concat_pere_fils(arbre arbre_pere,arbre arbre_fils){/*Carreteros Laetitia*/
  arbre_pere->fils=arbre_fils;
  return arbre_pere;

}

  void afficher_arbre_bis(arbre a,int i){/*Carreteros Laetitia*/
  int j=0;
  while(j!=i){
    fprintf(stdout,"    ");
    j++;
  }
  if(est_vide(a)==1){
    fprintf(stdout,"NULL \n");
  }
  else{
    fprintf(stdout,"||%d||    \n",a->type_noeud);
    if(est_vide(a->frere)==1){
      j=0;
      while(j!=i+1){
	fprintf(stdout,"   ");
	j++;
      }
      fprintf(stdout,"NULL ");
    }
    else{
      //fprintf(stdout,"|%c ,",a->filsgauche->caractere);
      afficher_arbre_bis(a->frere,i+1);
      
    }
    
    if(est_vide(a->fils)==1){
      j=0;
      while(j!=i+1){
	fprintf(stdout,"   ");
	j++;
      }
      fprintf(stdout,"NULL ");
    }
    else{
      //fprintf(stdout,"%c |\n\n",a->filsdroit->caractere);
      afficher_arbre_bis(a->fils,i+1);
    
    }
    fprintf(stdout,"\n");
  }


}


void afficher_arbre(arbre a){/*Carreteros Laetitia*/

  int i=0;
  afficher_arbre_bis( a, i);
   
}


