#ifndef TAB_REG_H
#define TAB_REG_H
#define TAILLE_TABLE_REGION 300


 /**********

Structure : table_regions
Auteur : Carreteros Laetitia


 ***********/
struct tab_region{
  int taille[TAILLE_TABLE_REGION];
  int nis[TAILLE_TABLE_REGION];//Niveau d'imbracation static
  arbre p_arbre[TAILLE_TABLE_REGION];
  int courant;

};

typedef struct tab_region tab_region;

/********************************
Fonction :void initialisation_table_region(table_region tab_reg);
Auteur : Carreteros Laetitia

*input
** 

********************************/
void initialisation_table_region(tab_region* table_reg);

/********************************
Fonction :void ajouter_region(int taille,int nis,arbre p_arbre);
Auteur : Carreteros Laetitia

*input
** 

********************************/
void ajouter_region(int taille,int nis,arbre p_arbre,tab_region* tab_reg);


#endif
