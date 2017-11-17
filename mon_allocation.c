#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>

void erreur(char* arguments ,...){
  va_list liste;
  va_start(liste,arguments);
  fprintf(stderr,"Erreur - ");
  vfprintf(stderr,arguments,liste);
  va_end(liste);
  exit(EXIT_FAILURE);

}


void * allocation_memoire(size_t nombre_objet,size_t taille){
  void * pt;

  pt=malloc(nombre_objet * taille);
  if(pt==NULL){
    erreur("Impossible d'allouer mémoire %d ,%d",nombre_objet,taille);
  }
  return pt;
  
}
