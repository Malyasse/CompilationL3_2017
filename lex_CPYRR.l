%{
#include "y.tab.h"
  #include <stdio.h>
  #include <stdlib.h>
%}


%%
\+     {return (PLUS);}
-      {return (MOINS);}
x      {return (MULT);}
\/     {return (DIV);}
\(     {return (PO);}
\)     {return (PF);}
0|[1-9][0-9]*   {return (CSTE_ENTIERE);}
[     {return CROCHET_OUVRANT;}
]     {return CROCHET_FERMANT;}}
,     {return VIRGULE;}
\{     {return DEBUT;}
\}     {return FIN;}
\;    {return POINT_VIRGULE;}
[a-z][a-zA-Z0-9]*   {return IDF;}
:     {return DEUX_POINTS;}
%%


