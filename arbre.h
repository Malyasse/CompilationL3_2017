#ifndef ARBRE_H
#define ARBRE_H


 typedef struct struct_arbre{/*Carreteros Laetitia*/
    int type_noeud;
    int num_lexico;
    struct struct_arbre *frere;
    struct struct_arbre *fils;
  }type_arbre;

typedef type_arbre* arbre;
 /*******************
Fonction :arbre  arbre_vide():Creer un arbre vide
Auteur :Carreteros Laetitia

  ******************/
 arbre arbre_vide();

 /*******************
Fonction :arbre creer_noeud(int nouveau_noeud):creer un nouveau noeud 
Auteur :Carreteros Laetitia

 ********************/
arbre creer_noeud(int nouveau_type_noeud,int num_lexico);

 /*******************
Fonction :arbre concat_pere_frere(arbre arbre_pere,arbre arbre_frere) : Ajoute un frere a un arbre_pere
Auteur :Carreteros Laetitia

  ******************/
arbre concat_pere_frere(arbre arbre_pere,arbre arbre_frere);

 /*******************
Fonction :arbre concat_pere_fils(arbre arbre_pere,arbre arbre_fils) : Ajoute un fils a un arbre_pere
Auteur :Carreteros Laetitia

  ******************/
arbre concat_pere_fils(arbre arbre_pere,arbre arbre_fils);

void afficher_arbre_bis(arbre a,int i);
void afficher_arbre(arbre a);
#endif
