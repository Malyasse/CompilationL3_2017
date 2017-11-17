#ifndef MON_H_ALLOCATION
#define MON_H_ALLOCATION

/***************************
 *fonction : void erreur(char* arguments ,...)
 ** signale l'erreur en cas de probleme d'allocation de la fonction allocation_memoire

 **************************/
void erreur(char* arguments ,...);

/***************************
 *fonction : void * allocation_memoire(size_t nombre_objet,size_t taille)
 ** Alloule de la memoire de nombre_objet*taille ( taille est le type )
 ** Renvoie un pointeur vers cette allocation
 **************************/
void * allocation_memoire(size_t nombre_objet,size_t taille);
#endif
