%option stack 8bit noyywrap yylineno

%{

#include <iostream>
#include <vector>
#include <string>

#include <stdio.h>

static std::vector<std::string> hrefs;


inline void yyerror(const char *msg) { std::cout << msg << std::endl; }

%}

SPACE   [ \t\n]
CAR     [A-Za-z0-9()_\-;#\\<>=+!*\:\"\'\.\{\}]

%%

{SPACE}|{CAR}    ;

.            { char a = *yytext; std::cout << "Fizeste merda "; printf("char: %c %d", a,a);}

%%

int main() {
  yylex();
  return 0;
}
