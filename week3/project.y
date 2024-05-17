%{
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define YYSTYPE double
extern FILE *yyin, *yyout;

void print_token(const char *token, const char *message) {
fprintf(yyout, "%s %s\n", token, message);
}

void yyerror(const char *msg){
fprintf(stderr, "%s\n", msg);
}

int my_fun();
int yylex();

%}

%token NUMBER
%token NEQ LEQ GEQ EQ
%token AKER PRAG LEKSH
%token OSO GIA AN ALLIWS
%token KYRIO_MEROS GRAPSE DIABASE EPESTREPSE
//%token INC LIB


%start input
%right '='
%left '+' '-'
%left '*' '/'
%left '<' '>'
//%left '<' '>' '='
%left NEQ LEQ GEQ EQ
//%left AKER PRAG 
//%left OSO GIA AN ALLIWS
//%left KYRIO_MEROS GRAPSE DIABASE EPESTREPSE
%right UMINUS


%%

input: 
     | input '\n'
     //| library '\n'
     | main '\n'
     | input '\n' main '\n'
     //| library '\n' main '\n'
     ;

main : KYRIO_MEROS '(' ')' '{' stmt_list '}' { print_token("kyrio_meros", "Syntax ok");} 
     ;


stmt_list : stmt//loops
          //| stmt_list loops
          //| expr ';'
          | stmt_list ';' stmt
          //| keywords ';'
          //| stmt_list
          ;

/*
library : INC LIB { print_token("libraries", "Syntax ok");} 
        ;
*/

 /* loops : oso_loop
//     | gia_loop
      | an_loop
      ;

oso_loop : OSO '(' condition ')' '{' stmt_list ';' '}' {print_token("OSO", "Syntax ok");}
         ;
an_loop : AN '(' condition ')' '{' stmt_list ';' '}' ALLIWS '{' stmt_list ';' '}' {print_token("AN", "Syntax ok");}
        ; 
gia_loop : GIA '(' "int i=0" ';' condition ';' expr ')' '{' stmt_list ';' '}' {print_token("GIA", "Syntax ok");}
         ; */

condition : expr '<' expr {$$= $1 < $3; print_token("<", "Syntax ok");}
          | expr '>' expr {$$= $1 > $3; print_token(">", "Syntax ok");}
          | expr NEQ expr {$$= $1 != $3; print_token("!=", "Syntax ok");}
          | expr EQ expr {$$= $1 == $3; print_token("==", "Syntax ok");}
          | expr LEQ expr {$$= $1 <= $3; print_token("<=", "Syntax ok");}
          | expr GEQ expr {$$= $1 >= $3; print_token(">=", "Syntax ok");}
          ;

expr : expr '+' expr {$$= $1 + $3; print_token("+", "Syntax ok");}
     | expr '-' expr {$$= $1 - $3; print_token("-", "Syntax ok");}
     | expr '*' expr {$$= $1 * $3; print_token("*", "Syntax ok");}
     | expr '/' expr  { if ($3==0) yyerror("divide by zero"); else $$ = $1 / $3; print_token("/", "Syntax ok");}
     | expr '=' expr {$$= $3; print_token("=", "Syntax ok");}
     | '(' expr ')' {$$= $2; print_token("()", "Syntax ok");}
     | '-' expr %prec UMINUS {$$= -$2; print_token(" ", "Syntax ok");}
     | NUMBER 
     //| expr
     | GRAPSE '(' var_list ')' { print_token("grapse", "Syntax ok");}
     ;

stmt : AKER var_list {$$ = (int)$2; print_token("akeraios", "Syntax ok");} 
     | PRAG var_list {$$ = (float)$2; print_token("pragmatikos", "Syntax ok");} 
     //| GRAPSE '(''"' var_list '"'')' { print_token("grapse", "Syntax ok");}
     | DIABASE '(' var_list ')' { print_token("diabase", "Syntax ok");}
     | EPESTREPSE expr ';' { print_token("epestrepse", "Syntax ok");}
     | OSO '(' condition ')' '{' stmt_list ';' '}' {print_token("OSO", "Syntax ok");}
     | AN '(' condition ')' '{' stmt_list ';' '}' ALLIWS '{' stmt_list ';' '}' {print_token("AN", "Syntax ok");}
     | GIA '(' expr ';' condition ';' expr ')' '{' stmt_list ';' '}' {print_token("GIA", "Syntax ok");}
     | expr
     ;

var_list : expr {print_token(" ", "Syntax ok"); }
         | expr ',' var_list {print_token(",", "Syntax ok"); }
         //| '"' var_list {print_token("'", "Syntax ok"); }
         | ';' {print_token(";", "Syntax ok"); }
         ;


/* keywords : GRAPSE '(' expr ')' { print_token("grapse", "Syntax ok");}
         | DIABASE '(' var_list ')' { print_token("diabase", "Syntax ok");}
         | EPESTREPSE '0' { print_token("epestrepse", "Syntax ok");}
         ; */


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

int main() {
    yyin= fopen("wll1 kyr_mer.txt", "r");
    yyout= fopen("wll_analysis.txt", "w");
    //printf("hello");
    yyparse();
    fclose(yyin); 
    fclose(yyout); 
    return 0;
}


