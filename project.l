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

"akeraios" {ret_print( "Data type"); return AKER; } 
"pragmatikos" {ret_print( "Data type"); return PRAG; } 
"leksh" {ret_print( "Data type"); return LEKSH; } 
"grapse" {ret_print( "Keyword"); return GRAPSE; }
"diabase" {ret_print( "Keyword"); return DIABASE; }
"epestrepse" {ret_print( "Keyword"); return EPESTREPSE; }

"kyrio_meros" {ret_print( "Kyrio meros"); return KYRIO_MEROS; }

"oso" {ret_print( "Loop type"); return OSO; } 
"gia" {ret_print( "Loop type"); return GIA; } 
"an" {ret_print( "Loop type"); return AN; } 
"alliws" {ret_print( "Loop type"); return ALLIWS; } 




"+"  {ret_print( "Arithmetic operator"); return '+'; } 
"-"  {ret_print( "Arithmetic operator"); return '-'; } 
"*"  {ret_print( "Arithmetic operator"); return '*'; } 
"/"  {ret_print( "Arithmetic operator"); return '/'; } 

"("  {ret_print( "Punctuation"); return '('; } 
")"  {ret_print( "Punctuation"); return ')'; } 
"{"  {ret_print( "Punctuation"); return '{'; } 
"}"  {ret_print( "Punctuation"); return '}'; } 

","  {ret_print( "Comma"); return ','; } 
";"  {ret_print( "Semicolon"); return ';'; } 
"="  {ret_print( "Assignment operator"); return '='; } 

"<"  {ret_print( "Comparison operator"); return '<'; } 
">"  {ret_print( "Comparison operator"); return '>'; } 
"<="  {ret_print( "Comparison operator"); return LEQ; } 
">="  {ret_print( "Comparison operator"); return GEQ; }
"=="  {ret_print( "Comparison operator"); return EQ; } 
"!="  {ret_print( "Comparison operator"); return NEQ; } 

{digit}+ {yylval = atoi(yytext); ret_print("Digit"); return NUMBER;} 
[ \t\n]+ {}
. printf( "Unrecognized character: %s\n", yytext);
%%
//\"([^\"\n]|\\.)*\" { yylval.str = strdup(yytext); ret_print("LEKSH"); return LEKSH; }
//"#"  {ret_print( "Include"); return INC; } 
//"lib"  {ret_print( "Libraries"); return LIB; } 

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
