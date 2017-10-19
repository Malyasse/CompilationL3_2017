%{
  #include <stdio.h>
  #include <stdlib.h>

  extern char * yytext;
  %}

%token PLUS MOINS MULT DIV ENTIER PO PF

%%
ee: e   {printf(" = %d\n",$1);}
  ;
e : e PLUS e1   {printf("+"); $$=$1+$3;}
  | e MOINS e1  {printf("-"); $$=$1-$3;}
  | e1
  ;
e1 : e1 MULT e2  {printf("x"); $$=$1*$3;}
   | e1 DIV e2  {printf("/"); $$=$1/$3;}
   | e2       {$$=$1;}
   ;
e2 : ENTIER      {printf("%d",$1);$$=$1;}
   | PO e PF      {$$=$2;}
   ;
%%

int yyerror(){
  fprintf(stderr,"Erreur\n");
}
