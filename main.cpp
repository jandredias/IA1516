%option stack 8bit noyywrap yylineno

%{

#include <iostream>
#include <vector>
#include <string>

#include <stdio.h>

static std::vector<std::string> hrefs;

int linha = 0;
inline void yyerror(const char *msg) { std::cout << msg << std::endl; }

%}

SPACE   [ \t]
CAR     [A-Za-z0-9()_\-\;\#\\<>=+!*\:\"\'\.\{\}\|\,\.]

%%

{SPACE}|{CAR}    ;
\n           { linha++; }
.            { char a = *yytext; std::cout << "Fizeste merda na linha " << linha << " "; printf("char: %c %d", a,a); std::cout << std::endl; }

%%

int main() {
  yylex();
  return 0;
}
