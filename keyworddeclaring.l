%{
#include <stdio.h>
%}

IDENTIFIER    [a-zA-Z_][a-zA-Z0-9_]*
VSTRING       \`([^`\$]|(\$\{[a-zA-Z_][a-zA-Z0-9_]*\}))*\`
STRING        \"[^\"]*\"
FLOAT         [0-9]+\.[0-9]+n
FLOAT_WITHOUT_N [0-9]+\.[0-9]+
INTEGER       [0-9]+
OPERATOR      [-+*/=<>!&|]
DELIMITER     [,\(\)\[\]\{\}\\;\.]
SLC           "//".*
MLC           "/*"([^*]|\*+[^*/])*\*+"/"

%%

[ \t\n]+

{SLC}             { printf("slComment   -> %s\n", yytext); }
{MLC}             { printf("mlComment   -> %s\n", yytext); }
"ingredient"      { printf("VARIABLE    -> %s\n", yytext); }
"fixed"           { printf("CONST       -> %s\n", yytext); }
"fun"             { printf("FUNCTION    -> %s\n", yytext); }
"really"          { printf("IF          -> %s\n", yytext); }
"notReal"         { printf("ELSE_IF     -> %s\n", yytext); }
"real"            { printf("ELSE        -> %s\n", yytext); }
"go"              { printf("FOR         -> %s\n", yytext); }
"asLongAs"        { printf("WHILE       -> %s\n", yytext); }
"goBack"          { printf("RETURN      -> %s\n", yytext); }
"show"            { printf("PRINT       -> %s\n", yytext); }
"ok"              { printf("TRUE        -> %s\n", yytext); }
"notOkay"         { printf("FALSE       -> %s\n", yytext); }
"cluster"         { printf("ARRAY       -> %s\n", yytext); }
"end"             { printf("BREAK       -> %s\n", yytext); }
"goOn"            { printf("CONTINUE    -> %s\n", yytext); }
"involve"         { printf("INCLUDE     -> %s\n", yytext); }
"cls"             { printf("CLASS       -> %s\n", yytext); }
"extn"            { printf("EXTENDS     -> %s\n", yytext); }
"hold"            { printf("CATCH       -> %s\n", yytext); }
"testing"         { printf("TRY         -> %s\n", yytext); }
"yay"             { printf("SUCCESS     -> %s\n", yytext); }
"ssh"             { printf("PRIVATE     -> %s\n", yytext); }
"forAll"          { printf("PUBLIC      -> %s\n", yytext); }
"imp"             { printf("MAIN        -> %s\n", yytext); }
"variety"         { printf("EXCEPTION   -> %s\n", yytext); }
"scan"            { printf("SCANF       -> %s\n", yytext); }
{FLOAT}           { printf("pointVal    -> %s\n", yytext); }
{INTEGER}         { printf("INTEGER     -> %s\n", yytext); }
{STRING}          { printf("talk        -> %s\n", yytext); }
{VSTRING}         { printf("vtalk       -> %s\n", yytext); }
{IDENTIFIER}      { printf("IDENTIFIER  -> %s\n", yytext); }
{OPERATOR}        { printf("ops         -> %s\n", yytext); }
{DELIMITER}       { printf("DELIMITER   -> %s\n", yytext); }
.                 { printf("ERROR: UNKNOWN KEYWORD -> %s\n", yytext); }

%%

int yywrap() {
    return 1;
}

int main(int argc, char **argv) {
    if (argc < 2) {
        printf("Usage: %s <input-file>\n", argv[0]);
        return 1;
    }
    FILE *file = fopen(argv[1], "r");
    if (!file) {
        perror(argv[1]);
        return 1;
    }

    char outfile[256];
    snprintf(outfile, sizeof(outfile), "%s.out", argv[1]);
    freopen(outfile, "w", stdout);

    yyin = file;
    yylex();

    fclose(file);
    fclose(stdout);

    return 0;
}
