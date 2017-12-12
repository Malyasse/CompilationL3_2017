#ifndef INCLUDED_GRAMMAIRE_H
#define INCLUDED_GRAMMAIRE_H
int association_de_noms(int numero_lexico );/*Carreteros Laetitia*/

int verifier_arguments(int indice_lexeme,int nombre_arguments, arbre arbre_expression , int *resultat_expression);/*Carreteros Laetitia*/

void verifier_nbr_arguments_suffisant();/*Carreteros Laetitia*/

int analyse_expression(arbre a, int* erreur, int* nature);/*Duraj Bastien*/

#endif
