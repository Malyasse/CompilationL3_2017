

typedef struct cellule{
  int donnee;
  struct cellule * suivant;
}cellule_struct;

typedef cellule_struct * Pile;

/*
  fonction: Pile* creer_pile_vide();
  **Cree une pile vide
 */
Pile* creer_pile_vide();

/*
  fonction: int est_pile_vide(Pile p);
  ** Retourne vrai si la pile passer en parametre est vide ,faux sinon
 */
int est_pile_vide(Pile p);

/*
  fonction: Pile empile(Pile p,int element);
  ** Ajoute un element en sommet de pile
 */
Pile empile(Pile p,int element);

/*
  fonction: Pile depile(Pile p);
  ** Eleve le premier element en sommet de pile
 */
Pile depile(Pile p);

/*
  fonction: int premier_element_pile(Pile p);
  ** Renvoie le premier element d'une pile
 */
int premier_element_pile(Pile p);

/*
  fonction: void affiche_pile(Pile p);
  ** Affiche le contenu de la pile passer en parametre
 */
void affiche_pile(Pile p);
