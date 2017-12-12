#ifndef TABLE_TYPE_H
#define TABLE_TYPE_H

#define TAILLE_TABLE_TYPE 500


typedef struct table_type{
    int tab[TAILLE_TABLE_TYPE];
    int dernier;
} table_type;




void initialisation_table_type(table_type* tab_type);

/********************************
Fonction : void initialisation_table_type(table_type* tab_type);
Auteur : Duraj Bastien

*input
** tab_type: table de representation des types a initialiser

********************************/


/*void insere_type(table_type* tab_type, int num_lex, int taille, int* taille_argument);*/

/********************************
Fonction : void insere_type(table_type* tab_type, int num_lex, int taille, int* taille_argument);
Auteur : Duraj Bastien

*input
** tab_type: table de representation dans laquelle inserer les donnees
** num_lex: le numero lexical du nouveau type
** taille: le nombre de champs ou d'argument a mettre dans la table
** taille_argument: tableau contenant la nature et la taille de chaque argument ou champ

********************************/

 void insere_type(int element , table_type* tab_type);
 /********************************
Fonction : void insere_type(int element , table_type* tab_type);
Auteur : Carreteros Laetitia

*input
** tab_type: table de representation dans laquelle inserer les donnees
** element : entier a inserer dans la table , peux etre l'indice d'un lexeme, type lexeme , type de retour

********************************/
void insere_dimension ( int nombre , int emplacement , table_type * tab_type);
/********************************
Fonction : void insere_dimension(( int nombre , int emplacement , table_type * tab_type)
Auteur : Carreteros Laetitia

*input
** tab_type: table de representation dans laquelle inserer les donnees
** nombre : entier a inserer dans la table , le nombre de champs dans une structure ,le nombre de parametres dans une fonction/Procedure , nombre de dimension d'un tableau

********************************/
void afficher_table_type(table_type *tab_type);

/********************************
Fonction : void afficher_table_type(table_type *tab_type);
Auteur : Duraj Bastien

*input
** tab_type: table de representation des types a afficher

********************************/

#endif
