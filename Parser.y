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

/* Variables for error handling and saving */
int error_count=0; 
int flag_err_type=0; // 0: Token Error (YYTEXT) || 1: String Error (STRBUF)
int scope=0;
int pos_number=0;
int flag=0;  //flag gia to token ean einai swsto to android
int valueflag=0;
char* strint;

int found_match = 0; // Bandera para indicar si se encontró una coincidencia
/*Specific Functions*/
void yyerror(const char *message);
%}

%error-verbose
%define parse.error custom_error_handling_function

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


%token <strval> T_EPSILON

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
%type alfabeto alfabetoatr estado estadoatr inicial final atributofin transciones transatr epsilon
%start programa 
%%
//%type <strval> uno dos
//automata_afn atr atrfn
programa: T_AUTOMATA_AFN_OP alfabeto estado inicial final transciones T_AUTOMATA_AFN_END
            | alfabeto estado inicial final transciones;

alfabeto: T_ALFABETO_OP alfabetoatr T_ALFABETO_END;
 

/*T_ALFABETO { tokens_T_ALFABETO[num_tokens_T_ALFABETO++] = strdup("a");
            tokens_T_ALFABETO[num_tokens_T_ALFABETO++] = strdup("b");
            } automata_afn element T_END_ALFABETO
            | T_ALFABETO {
            tokens_T_ALFABETO[num_tokens_T_ALFABETO++] = strdup("a");
            tokens_T_ALFABETO[num_tokens_T_ALFABETO++] = strdup("b");
            } automata_afn element T_END_ALFABETO;*/

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
/*t_alfabeto0 = strdup($1);
t_alfabeto1 = strdup($2);*/


epsilon: T_EPSILON {tokens_epsilon[num_tokens_epsilon++] = strdup("&");};
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
                           /* char concatenated_values[100]; 
                            sprintf(concatenated_values, "%d,%s,%d", atoi($1), $3, atoi($5));

                            int error_line = lineno;

                             if (strcmp($3, t_alfabeto0) != 0 && strcmp($3, t_alfabeto1) != 0)
                                {
                                    char error_message[100];
                                    sprintf(error_message, "Un caracter en la l�nea %d no coincide con los valores %s o %s que se introdujeron en ALFABETO encontrado %s", error_line, t_alfabeto0, t_alfabeto1, $3);
                                    yyerror(error_message);
                                }
                            
                            tokens_transicional[num_tokens_transicional++] = strdup(concatenated_values);*/
                            char concatenated_values[100]; 
                            sprintf(concatenated_values, "%d,%s,%d", atoi($1), $3, atoi($5));

                            int error_line = lineno;
                            //arreglar el if, ya que al hacer la comparacion si uno de los valores no concuerda pero si 
                            //esta en el vocabulario, enviara mensaje de error de todas formas
                            /*for (int i=0; i< sizeof(tokens_alfabetos); i++){
                                if(strcmp($3, tokens_alfabetos[i]) != 0 ||  strcmp($3, tokens_epsilon[0])){
                                    char error_message[100];
                                    sprintf(error_message, "Un caracter en la l�nea %d no coincide con los valores %s o %s que se introdujeron en ALFABETO encontrado %s", error_line, t_alfabeto0, t_alfabeto1, $3);
                                    yyerror(error_message);
                                }else{
                                    tokens_transicional[num_tokens_transicional++] = strdup(concatenated_values);
                                }
                            }*/
                            if (strcmp($3, tokens_alfabetos[0]) != 0 && strcmp($3, tokens_alfabetos[1]) != 0 && strcmp($3, tokens_alfabetos[2]) != 0 && strcmp($3, tokens_alfabetos[3]) != 0 ){
                                char error_message[100];
                                sprintf(error_message, "One CHARACTER at line %d does not match values %s, %s, %s or %s that were entered in ALFABETO found %s ", error_line, tokens_alfabetos[0], tokens_alfabetos[1],tokens_alfabetos[2],tokens_alfabetos[3], $3);
                                yyerror(error_message);
                            }else{
                                tokens_transicional[num_tokens_transicional++] = strdup(concatenated_values);
                            }
                         } 
                         | T_INT T_COMMA  T_EPSILON  T_COMMA  T_INT {
                            char concatenated_values[100]; 
                            sprintf(concatenated_values, "%d,%s,%d", atoi($1), $3, atoi($5));

                            int error_line = lineno;

                            if (strcmp($3, tokens_epsilon[0]) != 0){
                                char error_message[100];
                                sprintf(error_message, "One CHARACTER at line %d does not match values %s that were entered in ALFABETO found %s ", error_line, tokens_epsilon[0], $3);
                                yyerror(error_message);
                            }else{
                                tokens_transicional[num_tokens_transicional++] = strdup(concatenated_values);
                            }
                         } 
                          | %empty;
                          /*
                         T_INT T_COMMA T_EPSILON T_COMMA  T_INT
                         {
                            char concatenated_values[100]; 
                            sprintf(concatenated_values, "%d,%s,%d", atoi($7), $9, atoi($11));

                            tokens_transicional[num_tokens_transicional++] = strdup(concatenated_values);
                         }

                         T_INT T_COMMA  T_STRING T_COMMA  T_INT
                         {
                            char concatenated_values[100]; 
                            sprintf(concatenated_values, "%d,%s,%d", atoi($13), $15, atoi($17));

                             int error_line = lineno;

                             if (strcmp($15, t_alfabeto0) != 0 && strcmp($15, t_alfabeto1) != 0)
                                {
                                    char error_message[100];
                                    sprintf(error_message, "Un caracter en la l�nea %d no coincide con los valores %s o %s que se introdujeron en ALFABETO encontrado %s", error_line, t_alfabeto0, t_alfabeto1, $14);
                                    yyerror(error_message);
                                }

                            tokens_transicional[num_tokens_transicional++] = strdup(concatenated_values);
                         }
                          
                         T_INT T_COMMA  T_STRING T_COMMA  T_INT
                         {
                            char concatenated_values[100]; 
                            sprintf(concatenated_values, "%d,%s,%d", atoi($19), $21, atoi($23));

                             int error_line = lineno;

                             if (strcmp($21, t_alfabeto0) != 0 && strcmp($21, t_alfabeto1) != 0)
                                {
                                    char error_message[100];
                                    sprintf(error_message, "Un caracter en la l�nea %d no coincide con los valores %s o %s que se introdujeron en ALFABETO encontrado %s", error_line, t_alfabeto0, t_alfabeto1, $20);
                                    yyerror(error_message);
                                }
                                tokens_transicional[num_tokens_transicional++] = strdup(concatenated_values);
                         }
                          
                         T_INT T_COMMA  T_STRING T_COMMA  T_INT
                         {
                            char concatenated_values[100]; 
                            sprintf(concatenated_values, "%d,%s,%d", atoi($25), $27, atoi($29));

                             int error_line = lineno;

                             if (strcmp($27, t_alfabeto0) != 0 && strcmp($27, t_alfabeto1) != 0)
                                {
                                    char error_message[100];
                                    sprintf(error_message, "Un caracter en la l�nea %d no coincide con los valores %s o %s que se introdujeron en ALFABETO encontrado %s", error_line, t_alfabeto0, t_alfabeto1, $26);
                                    yyerror(error_message);
                                }
                                tokens_transicional[num_tokens_transicional++] = strdup(concatenated_values);
                         }
                        
                         T_INT T_COMMA  T_STRING T_COMMA  T_INT
                         {
                            char concatenated_values[100]; 
                            sprintf(concatenated_values, "%d,%s,%d", atoi($31), $33, atoi($35));

                             int error_line = lineno;

                             if (strcmp($33, t_alfabeto0) != 0 && strcmp($33, t_alfabeto1) != 0)
                                {
                                    char error_message[100];
                                    sprintf(error_message, "Un caracter en la l�nea %d no coincide con los valores %s o %s que se introdujeron en ALFABETO encontrado %s", error_line, t_alfabeto0, t_alfabeto1, $32);
                                    yyerror(error_message);
                                }
                                tokens_transicional[num_tokens_transicional++] = strdup(concatenated_values);
                         };*/

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

int main(int argc, char *argv[]){
    int token;

    /*Διάβασμα του αρχείου*/


    if(argc > 1){
        yyin = fopen(argv[1], "r");
        if (yyin == NULL){
            perror ("Error opening file"); 
            return -1;
        }
    }

    /*Κάνε συνατικτική ανάλυση*/
    yyparse();


   if(error_count > 0){
        printf("Syntax Analysis failed due to %d errors\n", error_count);
      }
        
   else{
        printf("Syntax Analysis completed successfully.\n");
      }

    return 0;
    yyrestart(yyin);
    fclose(yyin);
}


void yyerror(const char *message)
{
    /* error_count++;
    
    if(flag_err_type==0){
        printf("-> ERROR at line %d caused by %s : %s\n", lineno, yytext, message);
    }else if(flag_err_type==1){
        *str_buf_ptr = '\0'; 
        printf("-> ERROR at line %d near \"%s\": %s\n", lineno, str_buf, message);
    }

    flag_err_type = 0; 
    if(MAX_ERRORS <= 0) return;
    if(error_count == MAX_ERRORS){
        printf("Max errors (%d) detected. ABORTING...\n", MAX_ERRORS);
        exit(1);
    }*/
    error_count++;

    // Abre el archivo en modo de escritura (creándolo si no existe).
    if (vitacora_errores_file == NULL) {
        vitacora_errores_file = fopen("vitacora_errores.html", "a");
        if (vitacora_errores_file == NULL) {
            perror("Error al abrir el archivo vitacora_errores.html");
            exit(-1);
        }
    }

    // Escribe el error en el archivo.
    if (flag_err_type == 0) {
        fprintf(vitacora_errores_file, "-> ERROR at line %d caused by %s : %s\n", lineno, message);
        printf("-> ERROR at line %d caused by %s : %s\n", lineno, message);
    } else if (flag_err_type == 1) {
        *str_buf_ptr = '\0'; 
       // fprintf(vitacora_errores_file,"-> ERROR at line %d near "%s": %s\n", lineno, str_buf, message);
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
