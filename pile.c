#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include "pile.h"
#include "mon_allocation.h"
/*
void libere_mem(void * *pt)
{
if((*pt)!=NULL)
free(*pt); 
*pt=NULL; 
}*/


Pile creer_pile_vide(){
  return NULL;
}

int est_pile_vide(Pile p){
  if(p==NULL){
    return 1;
  }
  return 0;
}

Pile empile(Pile p,int element){
  Pile s=(Pile)allocation_memoire(1,sizeof(cellule_struct));
  s->suivant=p;
  s->donnee=element;
  return s;
}

Pile depile(Pile p){
  Pile s = creer_pile_vide();

  if (!est_pile_vide(p))
    s = p->suivant;
    /* libere_mem(&p);*/
  
  return s;
}

int premier_element_pile(Pile p){
  if(est_pile_vide(p)){
    exit(-1);
  }
  return p->donnee;
}

void affiche_pile(Pile p){

  while(p!=NULL){
    fprintf(stdout,"%d \n",premier_element_pile(p));
    p=p->suivant;
  }
}
