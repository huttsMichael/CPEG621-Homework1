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
%token INC DEC
%left '+' '-' // Specify left associativity for addition and subtraction
%left '*' '/' // Specify left associativity for multiplication and division
%right INC DEC // Specify left associativity for multiplication and division
%type <d> exp // Specify types of non-terminal symbols
%start cal // Specify starting symbol for parsing

%%
cal : exp '\n'
    { printf("=%d\n", $1); }
    | cal exp '\n'
    { printf("=%d\n", $2); }
    ;


exp:
	NUMBER
	| exp '+' exp { $$ = $1 + $3; }
	| exp '-' exp { $$ = $1 - $3; }
	| exp '*' exp { $$ = $1 * $3; }
	| exp '/' exp { $$ = $1 / $3; }
	| exp INC { $$ = $1 + 1; }
	| exp DEC { $$ = $1 - 1; }
	| '(' exp ')' { $$ = $2; }
	;

%%
int main() {
    yyparse();
    return 0;
}
