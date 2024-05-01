%{
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#define YYSTYPE double

 void yyerror(const char *msg){
fprintf(stderr, "%s\n", msg);
}

int my_fun();
int yylex();

%}

%token NUMBER
%token NEQ LEQ GEQ EQ
%token AKER PRAG LEKSH
%left '+' '-'
%left '*' '/'
%left '<' '>'
%left NEQ LEQ GEQ EQ
%right UMINUS

%%
lines : lines expr '\n' {printf("%g\n", $2);}
      | lines '\n'
      | 
      ;

expr : expr '+' expr {$$= $1 + $3;}
     | expr '-' expr {$$= $1 - $3;}
     | expr '*' expr {$$= $1 * $3;}
     | expr '/' expr  { if ($3==0) yyerror("divide by zero"); else $$ = $1 / $3; }
     | expr '<' expr {$$= $1 < $3;}
     | expr '>' expr {$$= $1 > $3;}
     | expr NEQ expr {$$= $1 != $3;}
     | expr EQ expr {$$= $1 == $3;}
     | expr LEQ expr {$$= $1 <= $3;}
     | expr GEQ expr {$$= $1 >= $3;}
     | '(' expr ')' {$$= $2;}
     | '-' expr %prec UMINUS {$$= -$2;}
     | NUMBER
     ;
%%

int my_fun() {
    int c;
    while ( ( c=getchar() ) ==' ');
    if ( (c=='.') || (isdigit(c)) ) {
    ungetc(c, stdin);
    scanf("%lf", &yylval);
    return NUMBER;
    }
return c;
}

int main(){
    yyparse();
	return 0;
}


