#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#include "table_type.h"





void initialisation_table_type(table_type* tab_type){
    int i;
    
    for (i = 0; i<TAILLE_TABLE_TYPE; i++){    // initialise le champ a -1
        tab_type->tab[i] = -1;
    }
    
    tab_type->dernier = 0;   // position la prochaine insertion a 0

}

/*
void insere_type(table_type* tab_type, int num_lex, int taille, int* taille_argument){
     int i;
     int dernier = tab_type->dernier;
     
     if (dernier+taille+2 >= TAILLE_TABLE_TYPE){
         fprintf(stderr, "Il n'y a plus de place dans la table de representation des types pour l'insertion de votre nouveau type\n");
         return ;
     }

     tab_type->tab[dernier] = taille;
     tab_type->tab[dernier] = num_lex;
     dernier += 2;
     for (i = dernier; i<dernier+taille; i++){
         tab_type->tab[i] = taille_argument[i-dernier];
     }

     tab_type->dernier += taille+2;

}*/
 void insere_type(int element , table_type* tab_type){/*Carreteros Laetitia*/
 	int dernier=tab_type->dernier;
 	
 	if(dernier - 1 >TAILLE_TABLE_TYPE){
 		fprintf(stderr,"Ajout impossible taille maximum atteint\n");
 		exit(-1);
 	}
 	
 	tab_type->tab[dernier] = element;
 	tab_type->dernier++;
 }

void insere_dimension ( int nombre , int emplacement , table_type * tab_type){/*Carreteros Laetitia*/
	if(emplacement>TAILLE_TABLE_TYPE){
		fprintf(stderr,"Ajout impossible , erreur indice \n");
		exit(-1);
	}
	tab_type->tab[emplacement]=nombre;
}

void afficher_table_type(table_type *tab_type){        /*Duraj Bastien*/
    int i = 0;
    int j;
    int taille;


    fprintf(stdout, "Affichage de la table de representation des types\n\n");
    
    fprintf(stdout, "|------------|-----------------|\n");
    fprintf(stdout, "|   indice   |      Valeur     |\n");
    fprintf(stdout, "|------------|-----------------|\n");
 
 
    while (i < tab_type->dernier){   //TAILLE_TABLE_TYPE
    
       fprintf(stdout,"|     %d", i);
       
       if (i == 0){
           taille = 1;
       }else if (i > 0){
           taille = (int) log10(i)+1;
       }else{
           taille = 2;
       }
       
       for (j=0; j < 7-taille; j++)
           fprintf(stdout," ");
           
       fprintf(stdout,"|       %d", tab_type->tab[i]);
       
       if (tab_type->tab[i] == 0){
           taille = 1;
       }else if (tab_type->tab[i] > 0){
           taille = (int) log10(tab_type->tab[i])+1;
       }else{
           taille = 2;
       }
       
       for (j=0; j < 10-taille; j++)
           fprintf(stdout," ");
    
       fprintf(stdout,"|\n");
       fprintf(stdout, "|------------|-----------------|\n");
       
       i++;
    }
    
    
    fprintf(stdout, "|------------|-----------------|\n\n\n");


}


