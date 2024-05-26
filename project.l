%option caseless

%{
#include <stdio.h>
#include "project.tab.h" 
void ret_print();
void yyerror();
%}

%x COMMENT2
digit [0-9]


%%
"(*" BEGIN(COMMENT2);
<COMMENT2>[^)*\n]+
<COMMENT2>\n
<COMMENT2><<EOF>> yyerror("EOF in comment");
<COMMENT2>"*)" BEGIN(INITIAL);
<COMMENT2>[*)]

"akeraios" { ret_print(); return AKER; } 
"pragmatikos" { ret_print(); return PRAG; } 
"leksh" { ret_print(); return LEKSH; } 
"grapse" { ret_print(); return GRAPSE; }
"diabase" { ret_print(); return DIABASE; }
"epestrepse" { ret_print(); return EPESTREPSE; }

"kyrio_meros()" { ret_print(); return KYRIO_MEROS; }

"oso" { ret_print(); return OSO; } 
"gia" { ret_print(); return GIA; } 
"an" { ret_print(); return AN; } 
"alliws" { ret_print(); return ALLIWS; } 

"#"  {ret_print(); return INC; } 
"lib"  {ret_print(); return LIB; } 


"+"  { ret_print(); return '+'; } 
"-"  { ret_print(); return '-'; } 
"*"  { ret_print(); return '*'; } 
"/"  { ret_print(); return '/'; } 

"("  { ret_print(); return '('; } 
")"  { ret_print(); return ')'; } 
"{"  { ret_print(); return LBRACE; } 
"}"  { ret_print(); return RBRACE; } 

","  { ret_print(); return ','; } 
";"  { ret_print(); return SEMI; } 
"="  { ret_print(); return '='; } 

"<"  { ret_print(); return '<'; } 
">"  { ret_print(); return '>'; } 
"<="  { ret_print(); return LEQ; } 
">="  { ret_print(); return GEQ; }
"=="  { ret_print(); return EQ; } 
"!="  { ret_print(); return NEQ; } 

{digit}+ {yylval = atoi(yytext); ret_print(); return NUMBER;} 
[a-zA-Z][a-zA-Z0-9]*	{ ret_print(); return SYMBOL; }
\"[^\"]*\"  { ret_print(); return MESSAGE; }
[ \t\n]+ {}

%%

void ret_print(){
printf("%s\t\n", yytext);
fprintf(yyout,"%s\t\n", yytext);
}

int yywrap() {
    yylex();
    return 0; 
}
