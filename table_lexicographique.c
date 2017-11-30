#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

#include "table_lexicographique.h"






int chainecmp(char* ch1, char* ch2){     // remplace strcmp qui ne fonctionne pas
    int i = 0;

    while (ch1[i] == '\0' && ch2[i] == '\0'){
        
        if (ch1[i] == ch2[i]){
            i ++;
            continue;
        }
        
        if (ch1[i] < ch2[i]){
            return -1;
        }
        
        return 1;
    
    }


    if (ch1[i] == '\0' && ch2[i] == '\0'){
        return 0;
    }
    
    if (ch1[i] == '\0'){
        return -1;
    }
    
    if (ch1[i] == '\0'){
        return 1;
    }


    return -1;

}


int fonction_hashcode(char* lexeme){   /*Duraj Bastien*/   /* definir les criteres pour la table de hashcode et redefinir la fonction de hashcode */

    return strlen(lexeme);

}


void init_hashcode(int* table_hashcode){
    int i;
    
    for (i = 0; i < TAILLE_TAB_HASH_CODE; i++){
        table_hashcode[i] = -1;
    }


}


int inserer_lexeme(char* lexeme, tab_lexico* tab_lex, int tab_hash_code[TAILLE_TAB_HASH_CODE]){   /*Duraj Bastien*/
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
   
   suivant = premier;
   
   do{
       precedent = suivant;
       suivant = indice_lexeme_suivant(precedent, tab_lex);    /* recupere le lexeme suivant du premier lexeme si le premier existe*/
   }while (suivant != -1 && chainecmp(lexeme, tab_lex->lexeme[precedent]) != 0);    /* on change le suivant et on redefinie le precedent tant qu'il existe un lexeme de meme hashcode */
      
      
   if (suivant == -1){
       if (chainecmp(lexeme, tab_lex->lexeme[suivant]) == 0){
           return suivant;
       }else{
           indice_nouveau_lexeme = ajouter_lexeme(lexeme, tab_lex);   /* on ajoute le lexeme a la suite dans le tableau */
           definir_lexeme_suivant(indice_nouveau_lexeme, precedent, tab_lex);   /* changer le champ suivant du lexeme precedent */
   
           return indice_nouveau_lexeme;   /* retourner l'indice */
       }
   }else{
       return precedent;
   }
   
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
 
       tab_lex->longueur = (int*)malloc(taille * sizeof(int));   /*Allouement memoire du champ longueur de la structure passer en parametre*/
       tab_lex->lexeme = (char**)malloc(taille * sizeof(char*));   /*Allouement memoire du champ lexeme de la structure passer en parametre*/
       tab_lex->suivant = (int*)malloc(taille * sizeof(char));   /*Allouement memoire du champ suivant de la structure passer en parametre*/
       
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
        
        if(nouveau >TAILLE_TAB_LEXICO){  /*Si on a pas atteint la fin du tableau on ne fais rien*/
             fprintf(stderr,"Echec de l'insertion du lexeme %s , fin du tableau atteint.\n",lexeme);
             return -1;
        }
        
        tab_lex->longueur[nouveau] = strlen(lexeme); /*Ajout de la longueur du nouveau lexeme*/
        tab_lex->lexeme[nouveau] = strdup(lexeme);  /*Ajout du nouveau lexeme*/
        tab_lex->suivant[nouveau] = -1;  /*Initialisation de suivant a -1*/
        
       
        tab_lex->dernier = nouveau + 1;  /*On incremente dernier pour le lexeme suivant*/
        
        return nouveau;
}


int indice_lexeme_suivant(int numero_lex, tab_lexico* tab_lex){  /*Carreteros Laetitia*/
     
     return tab_lex->suivant[numero_lex];   /*retourne l'indice du lexeme suivant de la table lexicographique par rapport a un indice donner*/
     
}


void definir_lexeme_suivant(int indice_nouveau_lex, int num_lexeme, tab_lexico* tab_lex){   /*Carreteros Laetitia*/
    
    tab_lex->suivant[num_lexeme] = indice_nouveau_lex;    /*Change la valeur suivant d'un lexeme*/
    
}


void afficher_table_lexicographique(tab_lexico* tab_lex, int taille){
   int i;
   int j;
   int decalage;
   int n1, n2, n3;
   
   if (taille == -1)
      taille = tab_lex->dernier;


   fprintf(stdout, "Affichage de la table lexicographique\n\n");
   
   fprintf(stdout, "|------------|--------------|-----------|---------------------------------------------------------------------------------------------------|\n");
   fprintf(stdout, "|   indice   |   longueur   |  suivant  |                                            lexeme                                                 |\n");
   fprintf(stdout, "|------------|--------------|-----------|---------------------------------------------------------------------------------------------------|\n");
   
   for (i=0; i<taille; i++){ 
   
       if (i != 0)
           n1 = 11 - (int) (log10(i)+1);
       else
           n1 = 11 - 1;
           
       if (tab_lex->longueur[i] > 0)
           n2 = 13 - (int) (log10(tab_lex->longueur[i])+1);
       else
           n2 = 13 - 1;
           
       if (tab_lex->suivant[i] > 0)
           n3 = 10 - (int) (log10(tab_lex->suivant[i])+1);
       else if (tab_lex->suivant[i] == -1)
           n3 = 10 - 2;
       else
           n3 = 10 - 1;
   
       if (tab_lex->lexeme[i] == NULL){
           decalage = 92;
       }else{
           decalage = 98 - tab_lex->longueur[i];
       }

       fprintf(stdout, "| %d", i);
       
       for (j = 0; j < n1; j++){
           fprintf(stdout, " ");
       }
       
       fprintf(stdout, "| %d", tab_lex->longueur[i]);
       
       for (j = 0; j < n2; j++){
           fprintf(stdout, " ");
       }
       
       fprintf(stdout, "| %d", tab_lex->suivant[i]);
       
       for (j = 0; j < n3; j++){
           fprintf(stdout, " ");
       }
       
       fprintf(stdout, "| %s", tab_lex->lexeme[i]);
       
       for (j = 0; j < decalage; j++){
           fprintf(stdout, " ");
       }
       
       fprintf(stdout, "|\n");
       
       fprintf(stdout, "|------------|--------------|-----------|---------------------------------------------------------------------------------------------------|\n");
   }
   
   fprintf(stdout, "\n\n\n");

}


void afficher_table_hashcode(int* hashcode){
    int i, j;
    int n1, n2;

    fprintf(stdout, "Affichage de la table de hashage\n\n");
    
    fprintf(stdout, "|--------------|--------------------|\n");
    fprintf(stdout, "|   hashcode   |   premier lexeme   |\n");
    fprintf(stdout, "|--------------|--------------------|\n");


    for (i=0; i<TAILLE_TAB_HASH_CODE; i++){
   
       if (i > 0)
           n1 = 13 - (int) (log10(i)+1);
       else
           n1 = 13 - 1;
           
       if (hashcode[i] > 0)
           n2 = 19 - (int) (log10(hashcode[i])+1);
       else if (hashcode[i] == -1)
           n2 = 19 - 2;
       else
           n2 = 19 - 1;
   
       fprintf(stdout, "| %d", i);
       
       for (j = 0; j < n1; j++){
           fprintf(stdout, " ");
       }
       
       fprintf(stdout, "| %d", hashcode[i]);
       
       for (j = 0; j < n2; j++){
           fprintf(stdout, " ");
       }
       
       fprintf(stdout, "|\n");
       
       fprintf(stdout, "|--------------|--------------------|\n");
   }
   
   fprintf(stdout, "\n\n\n");
   
}






