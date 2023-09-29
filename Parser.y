%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "token.h"
#include <stdbool.h>

/** Extern from Flex **/
extern int lineno, 
           line_init;

extern char str_buf[256];    
extern char* str_buf_ptr;

/*Flex and bison*/
  extern int yylex();
  extern char *yytext;
  extern FILE *yyin;

extern void yyterminate();

/* Variables for error handling and saving */
int error_count=0; 
int flag_err_type=0; // 0: Token Error (YYTEXT) || 1: String Error (STRBUF)
int scope=0;
int pos_number=0;
int flag=0;  //flag gia to token ean einai swsto to android
int valueflag=0;
char* strint;

void yyerror(const char *message);

}%

%define parse.error verbose

%union{
   int intval;
   float floatval;
   char charval;
   char *strval;
}

/*token*/
%token<strval> T_Automata_AFN_OP
%token<strval> T_Automata_AFN_END
%token<strval> T_alfabeto_OP
%token<strval> T_alfabeto_END
%token<strval> T_Estado_OP
%token<strval> T_Estado_END
%token<strval> T_Inicial_OP
%token<strval> T_Inicial_END
%token<strval> T_Final_OP
%token<strval> T_Final_END
%token<strval> T_Transiciones_OP
%token<strval> T_Transiciones_END
%token<strval> T_END_TAG

%token<strval> T_Vacio

%token<strval> T_COMMENT_OPEN
%token<strval> T_COMMENT_CLOSE

%token<strval> T_STRING
%token<strval> T_STRING_SINGLE_QUOTE
%token<strval> T_POSITIVE_INTEGER
%token<strval> T_SLASH_END_TAG
%token<strval> T_STRING_DQ_SPACE

/*Other tokens*/
%left  <strval> T_DOT                      "."
%left  <strval> T_COMMA                    ","
%right <strval> T_ASSIGN                   "="
%token <strval> T_COLON                    ":"
%left  <strval> T_LBRACK                   "["
%left  <strval> T_RBRACK                   "]"
%token <strval> T_SLASH                    "/"
%token <strval> T_EXCLAMATION              "!"
%token <strval> T_DASH                     "-"
%token <strval> T_LBRACES                  "{"
%token <strval> T_RBRACES                  "}"
%left  <strval> T_AT                       "@"
%token <strval> T_QUESTION_MARK            "?"
%token <strval> T_UNDERSCORE               "_"
%token <strval> T_HASH                     "#"
%token <strval> T_SQUOTES                  "'"

/*EOF*/
%token <strval> T_EOF          0           "end of file"

