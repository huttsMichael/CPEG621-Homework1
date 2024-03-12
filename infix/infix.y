%{
#include <stdio.h>
#include <ctype.h>
int lineNum = 1; // Initialize line number
void yyerror(char *ps, ...) { /* need this to avoid link problem */
	printf("%s\n", ps); // Print parsing error message
}
%}

%union {
int d; // Union type for semantic value
}

// need to choose token type from union above
%token <d> NUMBER // Define token type for numbers
%token '(' ')' // Define token types for '(' and ')'
%left '+' '-' // Specify left associativity for addition and subtraction
%left '*' '/' // Specify left associativity for multiplication and division
%type <d> exp factor sub div term // Specify types of non-terminal symbols
%start cal // Specify starting symbol for parsing

%%
cal : exp '\n'
    { printf("=%d\n", $1); }
    | cal exp '\n'
    { printf("=%d\n", $2); }
    ;


exp : exp '+' factor
    { $$ = $1 + $3; }
    | factor
    { $$ = $1; }
    ;

factor : factor '*' sub
	{ $$ = $1 * $3; }
	| sub
	{ $$ = $1; }
	;

sub : sub '-' div
    { $$ = $1 - $3; }
    | div
    { $$ = $1; }
    ;

div : div '/' term
    { $$ = $1 / $3; }
    | term
    { $$ = $1; }
    ;

term : NUMBER
    { $$ = $1; }
    | '(' exp ')'
    { $$ = $2; }
    ;

%%
int main() {
    yyparse();
    return 0;
}
