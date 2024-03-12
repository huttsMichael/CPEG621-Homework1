%{
#include <stdio.h>
#include <ctype.h>
#include <math.h>

int lineNum = 1;
void yyerror(char *ps, ...) {
    printf("%s\n", ps);
}

int sym[26];
int equals_flag = 0;

%}

%union {
    int d;
}

%token <d> NUMBER VAR
%token '(' ')' INC DEC POW
%left '='
%left '+' '-'
%left '*' '/'
%right POW
%right INC DEC
%type <d> exp
%start cal

%%

cal: 
    exp '\n' { 
        if (equals_flag) {
            printf("=%d\n", sym[$1]);
            equals_flag = 0;
        } else {
            printf("=%d\n", $1);
        }
    }
    | cal exp '\n' { 
        if (equals_flag) {
            printf("=%d\n", sym[$2]);
            equals_flag = 0;
        } else {
            printf("=%d\n", $2);
        }
    }
    ;


exp:
    NUMBER
    | VAR { $$ = sym[$1]; }
    | '=' VAR exp {
        if (equals_flag) {
            sym[$2] = sym[$3];
        } else {
            sym[$2] = $3;
        }
        equals_flag = 1;
    }
    | '+' exp exp { $$ = $2 + $3; }
    | '-' exp exp { $$ = $2 - $3; }
    | '*' exp exp { $$ = $2 * $3; }
    | '/' exp exp { $$ = $2 / $3; }
    | POW exp exp { $$ = (int)pow($2, $3); }
    | INC exp { $$ = $2 + 1; }
    | DEC exp { $$ = $2 - 1; }
    | '(' exp ')' { $$ = $2; }
    ;

%%
int main() {
    yyparse();
    return 0;
}
