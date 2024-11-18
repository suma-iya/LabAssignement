%{
#include <stdio.h>
#include <string.h>

int keyword_count = 0;
int identifier_count = 0;
int integer_count = 0;
int float_count = 0;
int string_count = 0;
int vstring_count = 0;
int operator_count = 0;
int delimiter_count = 0;
int sl_comment_count = 0;
int ml_comment_count = 0;
int error_count = 0;

const char* keywords[] = {
    "ingredient", "fixed", "fun", "really", "notReal", "real",
    "go", "asLongAs", "goBack", "show", "ok", "notOkay", "cluster",
    "end", "goOn", "involve", "cls", "extn", "hold", "testing",
    "yay", "ssh", "forAll", "imp", "variety", "scan"
};
#define NUM_KEYWORDS (sizeof(keywords) / sizeof(keywords[0]))

int is_keyword(const char* word) {
    for (int i = 0; i < NUM_KEYWORDS; ++i) {
        if (strcmp(word, keywords[i]) == 0) {
            return 1;
        }
    }
    return 0;
}
%}

IDENTIFIER    [a-zA-Z_][a-zA-Z0-9_]*
VSTRING       \`([^`\$]|(\$\{[a-zA-Z_][a-zA-Z0-9_]*\}))*\`
STRING        \"[^\"]*\"
FLOAT         [0-9]+\.[0-9]+
INTEGER       [0-9]+
OPERATOR      [-+*/=<>!&|]
DELIMITER     [,\(\)\[\]\{\}\\;\.]
SLC           "//".*
MLC           "/\\*([^*]|\\*+[^*/])*\\*+/"

%%

[ \t\n]+           // Skip whitespace
{SLC}              { sl_comment_count++; }
{MLC}              { ml_comment_count++; }
{FLOAT}            { float_count++; }
{INTEGER}          { integer_count++; }
{STRING}           { string_count++; }
{VSTRING}          { vstring_count++; }
{OPERATOR}         { operator_count++; }
{DELIMITER}        { delimiter_count++; }
{IDENTIFIER}       {
                      if (is_keyword(yytext)) {
                          keyword_count++;
                      } else {
                          identifier_count++;
                      }
                   }
.                  { error_count++; }

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

    yyin = file;
    yylex();
    fclose(file);

    printf("Keywords: %d\n", keyword_count);
    printf("Identifiers: %d\n", identifier_count);
    printf("Integers: %d\n", integer_count);
    printf("Floats: %d\n", float_count);
    printf("Strings: %d\n", string_count);
    printf("VStrings: %d\n", vstring_count);
    printf("Operators: %d\n", operator_count);
    printf("Delimiters: %d\n", delimiter_count);
    printf("Single-line Comments: %d\n", sl_comment_count);
    printf("Multi-line Comments: %d\n", ml_comment_count);
    printf("Errors: %d\n", error_count);

    return 0;
}
