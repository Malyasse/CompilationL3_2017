#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "table_lexicographique.h"




int fonction_hashcode(char* lexeme){   /*Duraj Bastien*/   /* definir les criteres pour la table de hashcode et redefinir la fonction de hashcode */
    int i;
    int somme = 0;
    
    for (i = 0; i < strlen(lexeme); i++){
        somme += lexeme[i];
    }

    return somme % TAILLE_TAB_HASH_CODE;

}


int insere_lexeme(char* lexeme, tab_lexico* tab_lex, int tab_hash_code[TAILLE_TAB_HASH_CODE]){   /*Duraj Bastien*/
   int suivant;
   int premier;   /* numero du lexeme contenu dans la table de hashcode*/
   int precedent;   /* numero du lexeme precedent le lexeme courant */
   int indice_nouveau_lexeme;     /* contiendra l'indice du lexeme a ajouter dans la table */
   int numero_hash_code = fonction_hashcode(lexeme);   /* recupere le numero du hashcode du lexeme a inserer */
   
   premier = tab_hash_code[numero_hash_code];   /* recupere le premier lexeme de meme hashcode que le lexeme a inserer*/
   
   if (premier == -1){   /* si premier n'existe pas alors on definie le lexeme a inserer comme etant premier*/
   
       indice_nouveau_lexeme = ajouter_lexeme(lexeme, tab_lex);  /* ajoute le lexeme a la suite des autres lexemes dans le tableau */
       tab_hash_code[numero_hash_code] = indice_nouveau_lexeme;    /* definit le premier lexeme de hashcode "numero_hash_code" */
       
       return indice_nouveau_lexeme;   /* retourne l'indice du lexeme */
   }
   
   suivant = indice_lexeme_suivant(premier, tab_lex);    /* recupere le lexeme suivant du premier lexeme si le premier existe*/
   
   while (suivant != -1){    /* on change le suivant et on redefinie le predecent tant qu'il existe un lexeme de meme hashcode */
       precedent = suivant;
       suivant = indice_lexeme_suivant(precedent, tab_lex);
   }
   
   
   indice_nouveau_lexeme = ajouter_lexeme(lexeme, tab_lex);   /* on ajoute le lexeme a la suite dans le tableau */
   definir_lexeme_suivant(indice_nouveau_lexeme, precedent, tab_lex);   /* changer le champ suivant du lexeme precedent */
   
   
   return indice_nouveau_lexeme;   /* retourner l'indice */

}


char* lexeme(int numero_lexico, tab_lexico tab_lex){   /*Duraj Bastien*/

   if (numero_lexico < TAILLE_TAB_LEXICO){    /* si le numero a un lexeme alors on renvoie le lexeme sinon on renvoie NULL*/
       return tab_lex.lexeme[numero_lexico];
   }else{
       return NULL;
   }
   
}


void  initialisation_tab_lex(int taille , tab_lexico* tab_lex){  /*Carreteros Laetitia*/
       int i;
 
       tab_lex->longueur = (int*)malloc(taille * sizeof(int)); /*Allouement memoire du champ longueur de la structure passer en parametre*/
       tab_lex->lexeme = (char**)malloc(taille * sizeof(char*));/*Allouement memoire du champ lexeme de la structure passer en parametre*/
       tab_lex->suivant = (int*)malloc(taille * sizeof(char));/*Allouement memoire du champ suivant de la structure passer en parametre*/
       
       if (tab_lex->longueur == NULL || tab_lex->lexeme == NULL || tab_lex->suivant == NULL){
            fprintf(stderr,"Echec de malloc() lors de l'initialisation de la table lexicographique.\n");
       }
       
       for(i=0; i<taille; i++){
           tab_lex->lexeme[i] = NULL;     // tab_lex.lexeme[i]=(char*)malloc(100 * sizeof(char));
       }
       
       tab_lex->dernier = 0; //Initialisation de l'indice ou va être inserer le premier lexeme
}


int ajouter_lexeme(char* lexeme, tab_lexico* tab_lex){  /*Carreteros Laetitia*/
        int nouveau = tab_lex->dernier;
         if(nouveau >TAILLE_TAB_LEXICO){/*Si on a pas atteint la fin du tableau on ne fais rien*/
             fprintf(stderr,"Echec de l'insertion du lexeme %s , fin du tableau atteint.\n",lexeme);
            return -1;
        }
        tab_lex->longueur[nouveau] = strlen(lexeme); /*Ajout de la longueur du nouveau lexeme*/
        tab_lex->lexeme[nouveau] = strdup(lexeme);/*Ajout du nouveau lexeme*/
        tab_lex->suivant[nouveau] = -1;/*Initialisation de suivant a -1*/
        
       
        tab_lex->dernier = nouveau+1;/*On incremente dernier pour le lexeme suivant*/
        
        return nouveau;
}


int indice_lexeme_suivant(int numero_lex, tab_lexico* tab_lex){  /*Carreteros Laetitia*/
     
     return tab_lex->suivant[numero_lex];/*retourne l'indice du lexeme suivant de la table lexicographique par rapport a un indice donner*/
     
}


void definir_lexeme_suivant(int indice_nouveau_lex, int num_lexeme, tab_lexico* tab_lex){   /*Carreteros Laetitia*/
    
    tab_lex->suivant[num_lexeme] = indice_nouveau_lex; /*Change la valeur suivant d'un lexeme*/
    
}



