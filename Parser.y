%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "token.h"
#include <stdbool.h>

extern int lineno, line_init;

extern char str_buf[256];    
extern char* str_buf_ptr;

char* tokens_alfabetos[100];
int num_tokens_alfabetos = 0;
char* tokens_estados[100];
int num_tokens_estados = 0;
char* tokens_inicial[100];
int num_tokens_inicial = 0;
char* tokens_final[100]; 
int num_tokens_final = 0;
char tokens_transicional[100]; 
int num_tokens_transicional = 0; 
char tokens_afn[100]; 
int num_tokens_afn = 0; 
char* tokens_epsilon[1]; 
int num_tokens_epsilon = 0; 
FILE *vitacora_errores_file = NULL;

extern int yylex();
extern char *yytext;
extern FILE *yyin;

extern void yyterminate();


int error_count=0; 
int flag_err_type=0; 
int scope=0;
int pos_number=0;
int flag=0;  
int valueflag=0;
char* strint;

int found_match = 0; 
//%error-verbose
void yyerror(const char *message);
%}


%define parse.error verbose

%union{
   int intval;
   float floatval;
   char charval;
   char *strval;
}

/*token*/
%token <strval> T_AUTOMATA_AFN_OP
%token <strval> T_AUTOMATA_AFN_END
%token <strval> T_ALFABETO_OP
%token <strval> T_ALFABETO_END
%token <strval> T_ESTADO_OP
%token <strval> T_ESTADO_END
%token <strval> T_INICIAL_OP
%token <strval> T_INICIAL_END
%token <strval> T_FINAL_OP
%token <strval> T_FINAL_END
%token <strval> T_TRANSICIONES_OP
%token <strval> T_TRANSICIONES_END
%token <strval> T_INT
%token <strval> T_END_TAG


%token <strval> T_EPSILON    "&"

%token <strval> T_COMMENT_OPEN
%token <strval> T_COMMENT_CLOSE

%token <strval> T_STRING
%token <strval> T_STRING_SINGLE_QUOTE
%token <strval> T_POSITIVE_INTEGER
%token <strval> T_SLASH_END_TAG
%token <strval> T_STRING_DQ_SPACE

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



/*Non-Terminal*/
%type alfabeto alfabetoatr estado estadoatr inicial final atributofin transciones transatr 
%start programa 
%%
//epsilon
programa: T_AUTOMATA_AFN_OP alfabeto estado inicial final transciones T_AUTOMATA_AFN_END
            | alfabeto estado inicial final transciones;

alfabeto: T_ALFABETO_OP alfabetoatr T_ALFABETO_END;
 

alfabetoatr: T_STRING T_STRING {
            tokens_alfabetos[num_tokens_alfabetos++] = strdup($1);
            tokens_alfabetos[num_tokens_alfabetos++] = strdup($2);
        }
        | T_STRING T_STRING T_STRING T_STRING {
            tokens_alfabetos[num_tokens_alfabetos++] = strdup($1);
            tokens_alfabetos[num_tokens_alfabetos++] = strdup($2);
            tokens_alfabetos[num_tokens_alfabetos++] = strdup($3);
            tokens_alfabetos[num_tokens_alfabetos++] = strdup($4);
        }
        | T_STRING T_STRING T_STRING  {
            tokens_alfabetos[num_tokens_alfabetos++] = strdup($1);
            tokens_alfabetos[num_tokens_alfabetos++] = strdup($2);
            tokens_alfabetos[num_tokens_alfabetos++] = strdup($3);
        };




estado:     T_ESTADO_OP estadoatr T_ESTADO_END;

estadoatr: T_INT T_INT {
            tokens_estados[num_tokens_estados++] = strdup($1);
            tokens_estados[num_tokens_estados++] = strdup($2);
        }
        | T_INT T_INT T_INT T_INT {
            tokens_estados[num_tokens_estados++] = strdup($1);
            tokens_estados[num_tokens_estados++] = strdup($2);
            tokens_estados[num_tokens_estados++] = strdup($3);
            tokens_estados[num_tokens_estados++] = strdup($4);
        }
        | T_INT T_INT T_INT {
            tokens_estados[num_tokens_estados++] = strdup($1);
            tokens_estados[num_tokens_estados++] = strdup($2);
            tokens_estados[num_tokens_estados++] = strdup($3);
        };

        inicial:          T_INICIAL_OP T_INT T_INICIAL_END {
                    tokens_inicial[num_tokens_inicial++] = strdup($2);
                };

        final:             T_FINAL_OP atributofin T_FINAL_END;

        atributofin: T_INT {
                    tokens_final[num_tokens_final++] = strdup($1);
                }
                | T_INT T_INT {
                    tokens_final[num_tokens_final++] = strdup($1);
                    tokens_final[num_tokens_final++] = strdup($2);
                }
                |T_INT T_INT T_INT{
                    tokens_final[num_tokens_final++] = strdup($1);
                    tokens_final[num_tokens_final++] = strdup($2);
                    tokens_final[num_tokens_final++] = strdup($3);
                };

                transciones:         T_TRANSICIONES_OP transatr T_TRANSICIONES_END;

                transatr: T_INT T_COMMA  T_STRING  T_COMMA  T_INT 
                         {

                            char concatenated_values[100]; 
                            sprintf(concatenated_values, "%d,%s,%d", atoi($1), $3, atoi($5));

                            int error_line = lineno;

                            if (strcmp($3, tokens_alfabetos[0]) != 0 && strcmp($3, tokens_alfabetos[1]) != 0 && strcmp($3, tokens_alfabetos[2]) != 0 && strcmp($3, tokens_alfabetos[3]) != 0 ){
                                char error_message[100];
                                sprintf(error_message, "One CHARACTER at line %d does not match values %s, %s, %s or %s that were entered in ALFABETO found %s ", error_line, tokens_alfabetos[0], tokens_alfabetos[1],tokens_alfabetos[2],tokens_alfabetos[3], $3);
                                yyerror(error_message);
                            }else{
                                tokens_transicional[num_tokens_transicional++] = strdup(concatenated_values);
                            }
                         } transatr
                         | T_INT T_COMMA  T_EPSILON  T_COMMA  T_INT {
                            char concatenated_values[100]; 
                            sprintf(concatenated_values, "%d,%s,%d", atoi($1), $3, atoi($5));

                            int error_line = lineno;

                          //  if (strcmp($3, tokens_epsilon[0]) != 0){
                         //       char error_message[100];
                           //     sprintf(error_message, "One CHARACTER at line %d does not match values %s that were entered in ALFABETO found %s ", error_line, tokens_epsilon[0], $3);
                         //       yyerror(error_message);
                           // }else{
                                tokens_transicional[num_tokens_transicional++] = strdup(concatenated_values);
                           // }
                         } transatr;
                          
//epsilon: T_EPSILON {tokens_epsilon[num_tokens_epsilon++] = strdup("&");};

                         comment:                 T_COMMENT_OPEN T_STRING T_COMMENT_CLOSE
                          ;

content:                  element
                        | element content
                        ;

contentempty:            element
                        | element content
                        | %empty
                        ;

element:                  estado element
                        | inicial element
                        | final element             
                        |%empty
                        ;  

%%

int main(int argc, char *argv[]) {
    int choice;
    int token;


    if (argc > 1) {
        yyin = fopen(argv[1], "r");
        if (yyin == NULL) {
            perror("Error opening file");
            return -1;
        }
    }
yyparse();
    /*do {
        printf("Seleccione una opción:\n");
        printf("1. Analizar el archivo\n");
        printf("2. Salir\n");

        scanf("%d", &choice);

        switch (choice) {
            case 1:

                

                if (error_count > 0) {
                    printf("El análisis sintáctico falló debido a %d errores\n", error_count);
                } else {
                    printf("El análisis sintáctico se completó con éxito.\n");
                }
                break;

            case 2:
                printf("Saliendo del programa.\n");
                break;

            default:
                printf("Opción no válida. Intente de nuevo.\n");
                break;
        }
    } while (choice != 2);*/

    if (yyin != NULL) {
        fclose(yyin);
    }

    return 0;
}


void yyerror(const char *message)
{
    error_count++;


    if (vitacora_errores_file == NULL) {
        vitacora_errores_file = fopen("vitacora_errores.html", "a");
        if (vitacora_errores_file == NULL) {
            perror("Error al abrir el archivo vitacora_errores.html");
            exit(-1);
        }
    }


    if (flag_err_type == 0) {
        fprintf(vitacora_errores_file, "-> ERROR at line %d caused by %s : %s\n", lineno, message);
        printf("-> ERROR at line %d caused by %s : %s\n", lineno, message);
    } else if (flag_err_type == 1) {
        *str_buf_ptr = '\0'; 

        printf("-> ERROR at line %d near %s : %s\n", lineno, str_buf, message);
    }

    flag_err_type = 0;
    if (MAX_ERRORS > 0 && error_count == MAX_ERRORS) {
        printf("Max errors (%d) detected. ABORTING...\n", MAX_ERRORS);
        fclose(vitacora_errores_file);
        exit(-1);
    }
    fflush(vitacora_errores_file);
}
