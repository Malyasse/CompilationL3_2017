#ifndef TAB_LEX_H
#define TAB_LEX_H

#include "define.h"

struct tab_lexico{
    int* longueur;   /* tableau contenant les longueurs de chaque lexeme */
    char** lexeme;     /* tableau de chaine contenant chaque lexeme */
    int* suivant;    /* tableau contenant l'indice du lexeme suivant de meme hashcode de chaque lexeme */
    int dernier;       /* indice du dernier lexeme inserer */
};

typedef struct tab_lexico tab_lexico;

/********************************
Fonction :void initialisation_tab_lex(int taille, tab_lexico* tab_lex)
Auteur :Carreteros Laetitia

********************************/
void initialisation_tab_lex(int taille , tab_lexico* tab_lex, int tab_hash_code[TAILLE_TAB_HASH_CODE]);


/********************************
Fonction : int fonction_hashcode(char* lexeme);
Auteur : Duraj Bastien

********************************/
int fonction_hashcode(char* lexeme);


/********************************
Fonction : void init_hashcode(int* table_hashcode)
Auteur : Duraj Bastien

********************************/
void init_hashcode(int* table_hashcode);


/********************************
Fonction : int ajouter_lexeme(char* lexeme, tab_lexico tab_lex) : permet d'ajouter un lexeme dans la table lexicographique
Auteur :Carreteros Laetitia

*input
** char* lexeme : le lexeme a ajouter a la table lexicographique tab_lex
** tab_lexico tab_lex: table lexicographique ou va etre ajouter le lexeme

*output
** entier : retour l'indice d'insertion du lexeme dans tab_lex


********************************/
int ajouter_lexeme(char* lexeme, tab_lexico* tab_lex);


/********************************
Fonction :int indice_lexeme_suivant(int numero_lex,tab_lexico tab_lex) : permet de renvoyer l'indice du lexeme suivant par rapport a un indice donner en parametre
Auteur :Carreteros Laetitia

*input
** entier numero_lex : indice du lexeme dont on veut connaitre l'indice du suivant
** tab_lexico tab_lex : la table lexicographique contenant les lexemes

*output
** entier: numero du lexeme suivant numero_lex

********************************/
int indice_lexeme_suivant(int numero_lex,tab_lexico* tab_lex);


/********************************
Fonction :void definir_lexeme_suivant(int indice_nouveau_lex, int num_lexeme, tab_lexico tab_lex) : permet de redefinir le suivant d'un lexeme donner en parametre
Auteur :Carreteros Laetitia

*input
** entier indice_nouveau_lex : nouvelle valeur du suivant
** entier num_lexeme : indice du lexeme a modifier le suivant
** tab_lexico tab_lex : table lexicographique a modifier

*output
** void

********************************/
void definir_lexeme_suivant(int indice_nouveau_lex, int num_lexeme, tab_lexico* tab_lex);


/********************************
Fonction :int insere_lexeme(char* lexeme, tab_lexico* tab_lex, int tab_hash_code[TAILLE_TAB_HASH_CODE]) : permet d'inserer un lexeme dans la table lexicographique
Auteur :Duraj Bastien

*input
**  char* lexeme : nouveau lexeme a inserer dans la table lexicographique
**  tab_lexico* tab_lex : table lexicographique a modifier
**  entier tab_hash_code[TAILLE_TAB_HASH_CODE] : tableau contenant les hashCode

*output
** entier : renvoie l'indice ou a ete inserer le lexeme

********************************/
int inserer_lexeme(char* lexeme, tab_lexico* tab_lex, int tab_hash_code[TAILLE_TAB_HASH_CODE]);


/********************************
Fonction: char* lexeme(int numero_lexico, tab_lexico tab_lex) : permet de renvoyer le lexeme a un indice donner dans la table lexicographique
Auteur: Duraj Bastien

*input
**  entier numero_lexico : indice du lexeme a recupere dans tab_lex
**  tab_lexico tab_lex : table lexicographique ou on trouve le lexeme

*output
** char* lexeme : lexeme renvoyer

********************************/
char* lexeme(int numero_lexico, tab_lexico tab_lex);


/********************************
Fonction: void afficher_table_lexicographique(tab_lexico tab_lex, int taille) : permet d'afficher la table lexicographique sous forme de tableau dans le terminal
Auteur: Duraj Bastien

*input
**  tab_lexico tab_lex : table lexicographique a afficher
**  entier taille : taille de la table lexicographique utilise

********************************/
void afficher_table_lexicographique(tab_lexico* tab_lex, int taille);


/********************************
Fonction: void afficher_table_hashcode(int* hashcode) : permet d'afficher la table de hashcode sous forme de tableau dans le terminal
Auteur: Duraj Bastien

*input
**  int* hascode : table de hashcode a afficher

********************************/
void afficher_table_hashcode(int* hashcode);



#endif
