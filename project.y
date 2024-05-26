%{
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define YYSTYPE double
extern FILE *yyin, *yyout;

void print_token(const char *token, const char *message) {
    printf("%s %s\n\n", token, message);
    fprintf(yyout, "%s %s\n\n", token, message);
}

void yyerror(const char *msg){
    fprintf(stderr, "%s\n", msg);
}

int my_fun();
int yylex();

%}

%token NUMBER SEMI SYMBOL
%token NEQ LEQ GEQ EQ
%token AKER PRAG LEKSH
%token OSO GIA AN ALLIWS
%token KYRIO_MEROS GRAPSE DIABASE EPESTREPSE
%token INC LIB
%token LBRACE RBRACE MESSAGE

%start program
%right '='
%left '+' '-'
%left '*' '/'
%left '<' '>'
%left NEQ LEQ GEQ EQ
%right UMINUS

%%

program: main
       | library main 
       ;

main : KYRIO_MEROS LBRACE stmt_list RBRACE { print_token("kyrio_meros", "Syntax ok");} 
     ;

stmt_list : stmt SEMI {print_token("; Semicolon", "Syntax ok"); }
          | stmt_list stmt SEMI {print_token("; Semicolon", "Syntax ok"); }
          | loops
          | stmt_list loops
          ;

library : INC LIB { print_token("libraries", "Syntax ok");} 
        ;     

condition : expr '<' expr {$$ = $1 < $3; print_token("< Comparison operator", "Syntax ok");}
          | expr '>' expr {$$ = $1 > $3; print_token("> Comparison operator", "Syntax ok");}
          | expr NEQ expr {$$ = $1 != $3; print_token("!= Comparison operator", "Syntax ok");}
          | expr EQ expr {$$ = $1 == $3; print_token("== Comparison operator", "Syntax ok");}
          | expr LEQ expr {$$ = $1 <= $3; print_token("<= Comparison operator", "Syntax ok");}
          | expr GEQ expr {$$ = $1 >= $3; print_token(">= Comparison operator", "Syntax ok");}
          ;

expr : expr '+' expr {$$ = $1 + $3; print_token("+ Arithmetic operator", "Syntax ok");}
     | expr '-' expr {$$ = $1 - $3; print_token("- Arithmetic operator", "Syntax ok");}
     | expr '*' expr {$$ = $1 * $3; print_token("* Arithmetic operator", "Syntax ok");}
     | expr '/' expr  {$$ = $1 / $3; print_token("/ Arithmetic operator", "Syntax ok");}
     | expr '=' expr {$$ = $3; print_token("= Arithmetic operator", "Syntax ok");}
     | '(' expr ')' {$$ = $2; print_token("() Punctuation", "Syntax ok");}
     | '-' expr %prec UMINUS {$$ = -$2; print_token("UMINUS", "Syntax ok");}
     | NUMBER { $$ = $1; print_token("number", "Syntax ok"); }
     | SYMBOL { $$ = 0; print_token("symbol", "Syntax ok"); }
     ;

stmt : AKER var_list {print_token("akeraios Data type", "Syntax ok");} 
     | PRAG var_list {print_token("pragmatikos Data type", "Syntax ok");} 
     | LEKSH var_list { print_token("leksh Data type", "Syntax ok"); }
     | DIABASE '(' var_list ')' { print_token("diabase Keyword", "Syntax ok");}
     | GRAPSE '(' var_list ')' { print_token("grapse Keyword", "Syntax ok");}
     | GRAPSE '(' MESSAGE ')' { print_token("grapse message Keyword", "Syntax ok");}
     | EPESTREPSE expr { print_token("epestrepse Keyword", "Syntax ok");}
     | expr
     ;

loops: OSO '(' condition ')' LBRACE stmt_list RBRACE {print_token("OSO Loop type", "Syntax ok");}
     | AN '(' condition ')' LBRACE stmt_list RBRACE ALLIWS LBRACE stmt_list RBRACE {print_token("AN Loop type", "Syntax ok");}
     | GIA '(' expr SEMI condition SEMI expr ')' LBRACE stmt_list RBRACE {print_token("GIA Loop type", "Syntax ok");}

var_list : expr
         | var_list ',' expr { print_token(", Comma", "Syntax ok"); }
         ;

%%

int my_fun() {
    int c;
    while ((c = getchar()) == ' ');
    if ((c == '.') || (isdigit(c))) {
        ungetc(c, stdin);
        scanf("%lf", &yylval);
        return NUMBER;
    } else if (isalpha(c)) {
        ungetc(c, stdin);
        scanf("%*c");
        yylval = 0;
        return SYMBOL;
    }
    return c;
}

int main() {
    yyin = fopen("wll4.txt", "r");
    yyout = fopen("wll_analysis.txt", "w");
    yyparse();
    fclose(yyin); 
    fclose(yyout); 
    return 0;
}
