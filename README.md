# lexical-and-syntax-analyzer

Compile & run:
flex project.l
bison -d project.y
gcc -o a.out project.tab.c lex.yy.c
./a.out
 
