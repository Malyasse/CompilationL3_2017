%{
#include "y.tab.h"
  #include <stdio.h>
  #include <stdlib.h>
%}


%%
\+ {return (PLUS);}
- {return (MOINS);}
x {return (MULT);}
\/ {return (DIV);}
\( {return (PO);}
\) {return (PF);}
0|[1-9][0-9]*   {yylval=atoi(yytext);return (ENTIER); }
%%


