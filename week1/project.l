%option caseless

%{
#include <stdio.h>
#include "project.tab.h" 
void ret_print(char *token_type);
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

"akeraios" { return AKER; } ret_print( "Data type");
"pragmatikos" { return PRAG; } ret_print( "Data type");
"leksh" { return LEKSH; } ret_print( "Data type");

"+"  { return '+'; } ret_print( "Arithmetic operator");
"-"  { return '-'; } ret_print( "Arithmetic operator");
"*"  { return '*'; } ret_print( "Arithmetic operator");
"/"  { return '/'; } ret_print( "Arithmetic operator");
"("  { return '('; } ret_print( "Arithmetic operator");
")"  { return ')'; } ret_print( "Arithmetic operator");

"<"  { return '<'; } ret_print( "Comparison operator");
">"  { return '>'; } ret_print( "Comparison operator");
"<="  { return LEQ; } ret_print( "Comparison operator");
">="  { return GEQ; } ret_print( "Comparison operator");
"=="  { return EQ; } ret_print( "Comparison operator");
"!="  { return NEQ; } ret_print( "Comparison operator");
{digit}+ {yylval = atoi(yytext); return NUMBER;} ret_print("Digit");
. printf( "Unrecognized character: %s\n", yytext);
%%

void ret_print(char *token_type){
printf("%s\t%s\n", yytext, token_type);
fprintf(yyout,"%s\t%s\n", yytext, token_type);
}

int yywrap() {
    //yyin= fopen("wll.txt", "r");
    //yyout= fopen("wll_analysis.txt","w");
    yylex();
    //fclose(yyin);
    //fclose(yyout);
    return 0; 
}
