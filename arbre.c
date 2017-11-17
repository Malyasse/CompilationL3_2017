#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#include "./mon_allocation.h"
#include "arbre.h"




int est_vide(arbre a){  /*Carreteros Laetitia*/
  if(a==NULL){
    return 1;
  }
  return 0;
}


arbre arbre_vide(){  /*Carreteros Laetitia*/
  return NULL;

}


arbre creer_noeud(int nouveau_type_noeud,int num_lexico){   /*Carreteros Laetitia*/
  arbre nouveau_arbre=allocation_memoire(1,(sizeof(type_arbre)));
   
  nouveau_arbre->frere=arbre_vide();
  nouveau_arbre->fils=arbre_vide();
  nouveau_arbre->type_noeud=nouveau_type_noeud;
  nouveau_arbre->num_lexico=num_lexico;
  
   //fprintf(stderr,"T %d \n" , nouveau_arbre->type_noeud );
  return nouveau_arbre;
 }


arbre concat_pere_frere(arbre arbre_pere,arbre arbre_frere){/*Carreteros Laetitia*/
  
  if(!est_vide(arbre_pere)){
      arbre_pere->frere=arbre_frere;
      //fprintf(stderr,"Test 5 %d  %d \n" , arbre_pere->type_noeud , arbre_frere->type_noeud);
   }
  return arbre_pere;
}


arbre concat_pere_fils(arbre arbre_pere,arbre arbre_fils){/*Carreteros Laetitia*/
  
  if(!est_vide(arbre_pere)){
      arbre_pere->fils=arbre_fils;
  }
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


void afficher_arbre(arbre a){  /*Carreteros Laetitia*/

  int i=0;
  afficher_arbre_bis( a, i);
   
}





/********** Ensemble de fonction permettant d'afficher un arbre de maniere horizontale dans le terminale ***********/


 int somme_tiret(int prof){    /* Duraj Bastien */
    int i;
    int somme = 0;

    for (i=0;i<prof;i++){
        somme += (3*pow(2,i));
    }

    return somme;

 }


 char** initialisation_buffer(int max_prof, int taille_ligne){    /* Duraj Bastien */
    int i,j;

    char** buffer = (char**) malloc(sizeof(char*)*max_prof*2);
    if (buffer == NULL){
        fprintf(stderr,"ErrMemory::afficher_arbre_horizontal()::Allocation_echouer_buffer\n");
        exit(-1);
    }

    for (i = 0;i<max_prof*2;i++){
        buffer[i] = (char*) malloc(sizeof(char)*(taille_ligne+1));
        if (buffer[i] == NULL){
            fprintf(stderr,"ErrMemory::afficher_arbre_horizontal()::Allocation_echouer_ligne_buffer\n");
            exit(-1);
        }
    }

    for (i = 0;i<max_prof*2;i++){
        for (j = 0;j<taille_ligne;j++){
            buffer[i][j] = ' ';
        }
        buffer[i][j] = '\0';
    }

    return buffer;

 }


 void rempli_buffer(arbre* tab_a, int nombre_noeud, int prof_actuel, int prof_max, int cacher, char** buffer){    /* Duraj Bastien */
    int i,j;
    int nombre_tiret = 3*pow(2,(prof_max-prof_actuel));
    int decalage = 0;

    arbre* next_tab = NULL;


    if (prof_actuel < prof_max){
        for (i=0;i<nombre_noeud;i++){
            decalage = 0;
            if (i%2 == 0){
                if (tab_a[i] != NULL || !cacher){
                    for (j=0;j<nombre_tiret;j++){
                        buffer[prof_actuel*2-1][somme_tiret(prof_max-prof_actuel)/2+(i*nombre_tiret)+j] = '-';
                    }
                }
                decalage = -1;
            }
            if (tab_a[i] == NULL){
                if (decalage == -1){
                    decalage --;
                }
                if (!cacher){
                    buffer[prof_actuel*2][somme_tiret(prof_max-prof_actuel)/2+i*nombre_tiret+decalage] = '.';
                    buffer[prof_actuel*2][somme_tiret(prof_max-prof_actuel)/2+i*nombre_tiret+decalage+1] = '.';
                }
            }else{
                if (tab_a[i]->type_noeud > 9){
                    if (decalage == -1){
                        decalage --;
                    }
                    buffer[prof_actuel*2][somme_tiret(prof_max-prof_actuel)/2+i*nombre_tiret+decalage] = tab_a[i]->type_noeud/10 + '0';
                    buffer[prof_actuel*2][somme_tiret(prof_max-prof_actuel)/2+i*nombre_tiret+decalage+1] = tab_a[i]->type_noeud%10 + '0';
                }else{
                    buffer[prof_actuel*2][somme_tiret(prof_max-prof_actuel)/2+i*nombre_tiret+decalage] = tab_a[i]->type_noeud + '0';
                }
            }
        }

        next_tab = (arbre*) malloc(sizeof(arbre)*nombre_noeud*2);
        if (next_tab == NULL){
            fprintf(stderr,"ErrMemory::rempli_buffer()::Allocation_echouer_next_tab\n");
            exit(-1);
        }

        for (i=0;i<nombre_noeud;i++){
            if (tab_a[i] != NULL){
                next_tab[i*2] = tab_a[i]->fils;
                next_tab[i*2+1] = tab_a[i]->frere;
            }else{
                next_tab[i*2] = arbre_vide();
                next_tab[i*2+1] = arbre_vide();
            }
        }

        free(tab_a);
        tab_a = NULL;

        return rempli_buffer(next_tab,nombre_noeud*2,prof_actuel+1,prof_max,cacher,buffer);
    }

    free(tab_a);
    tab_a = NULL;

 }


 void afficher_arbre_horizontal(arbre a, int max_prof, int cacher, FILE* mon_flux){    /* Duraj Bastien */
    int taille_ligne = somme_tiret(max_prof);
    int i;

    char** buffer = initialisation_buffer(max_prof,taille_ligne);
    arbre* next_tab = NULL;


    if (a == NULL){
        if (max_prof > 0){
            if (!cacher){
                buffer[0][taille_ligne/2] = '.';
                buffer[0][taille_ligne/2+1] = '.';
            }
        }
    }else{
        if (max_prof == 1){
            if (a->type_noeud > 9){
                buffer[0][taille_ligne/2] = a->type_noeud/10 + '0';
                buffer[0][taille_ligne/2+1] = a->type_noeud%10 + '0';
            }else{
                buffer[0][taille_ligne/2] = a->type_noeud + '0';
            }
        }

        if (max_prof > 1){
            if (a->type_noeud > 9){
                buffer[0][taille_ligne/2] = a->type_noeud/10 + '0';
                buffer[0][taille_ligne/2+1] = a->type_noeud%10 + '0';
            }else{
                buffer[0][taille_ligne/2] = a->type_noeud + '0';
            }

            next_tab = (arbre*) malloc(sizeof(arbre)*2);
            if (next_tab == NULL){
                fprintf(stderr,"ErrMemory::rempli_buffer()::Allocation_echouer_next_tab\n");
                exit(-1);
            }

            next_tab[0] = a->fils;
            next_tab[1] = a->frere;

            rempli_buffer(next_tab,2,1,max_prof,cacher,buffer);
        }
    }

    // Affichage du buffer contenant les donnees de l arbre dans la sortie specifier
    for (i=0;i<max_prof*2;i++){
        fprintf(mon_flux,"%s\n",buffer[i]);
    }

 }
 
 










