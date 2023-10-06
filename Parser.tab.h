/* A Bison parser, made by GNU Bison 3.8.2.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2021 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <https://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* DO NOT RELY ON FEATURES THAT ARE NOT DOCUMENTED in the manual,
   especially those whose name start with YY_ or yy_.  They are
   private implementation details that can be changed or removed.  */

#ifndef YY_YY_PARSER_TAB_H_INCLUDED
# define YY_YY_PARSER_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token kinds.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    YYEMPTY = -2,
    T_EOF = 0,                     /* "end of file"  */
    YYerror = 256,                 /* error  */
    YYUNDEF = 257,                 /* "invalid token"  */
    T_AUTOMATA_AFN_OP = 258,       /* T_AUTOMATA_AFN_OP  */
    T_AUTOMATA_AFN_END = 259,      /* T_AUTOMATA_AFN_END  */
    T_ALFABETO_OP = 260,           /* T_ALFABETO_OP  */
    T_ALFABETO_END = 261,          /* T_ALFABETO_END  */
    T_ESTADO_OP = 262,             /* T_ESTADO_OP  */
    T_ESTADO_END = 263,            /* T_ESTADO_END  */
    T_INICIAL_OP = 264,            /* T_INICIAL_OP  */
    T_INICIAL_END = 265,           /* T_INICIAL_END  */
    T_FINAL_OP = 266,              /* T_FINAL_OP  */
    T_FINAL_END = 267,             /* T_FINAL_END  */
    T_TRANSICIONES_OP = 268,       /* T_TRANSICIONES_OP  */
    T_TRANSICIONES_END = 269,      /* T_TRANSICIONES_END  */
    T_INT = 270,                   /* T_INT  */
    T_END_TAG = 271,               /* T_END_TAG  */
    T_EPSILON = 272,               /* "&"  */
    T_COMMENT_OPEN = 273,          /* T_COMMENT_OPEN  */
    T_COMMENT_CLOSE = 274,         /* T_COMMENT_CLOSE  */
    T_STRING = 275,                /* T_STRING  */
    T_STRING_SINGLE_QUOTE = 276,   /* T_STRING_SINGLE_QUOTE  */
    T_POSITIVE_INTEGER = 277,      /* T_POSITIVE_INTEGER  */
    T_SLASH_END_TAG = 278,         /* T_SLASH_END_TAG  */
    T_STRING_DQ_SPACE = 279,       /* T_STRING_DQ_SPACE  */
    T_DOT = 280,                   /* T_DOT  */
    T_COMMA = 282,                 /* T_COMMA  */
    T_ASSIGN = 284,                /* T_ASSIGN  */
    T_COLON = 286,                 /* ":"  */
    T_LBRACK = 287,                /* T_LBRACK  */
    T_RBRACK = 289,                /* T_RBRACK  */
    T_SLASH = 291,                 /* "/"  */
    T_EXCLAMATION = 292,           /* "!"  */
    T_DASH = 293,                  /* "-"  */
    T_LBRACES = 294,               /* "{"  */
    T_RBRACES = 295,               /* "}"  */
    T_AT = 296,                    /* T_AT  */
    T_QUESTION_MARK = 298,         /* "?"  */
    T_UNDERSCORE = 299,            /* "_"  */
    T_HASH = 300,                  /* "#"  */
    T_SQUOTES = 301                /* "'"  */
  };
  typedef enum yytokentype yytoken_kind_t;
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 52 "Parser.y"

   int intval;
   float floatval;
   char charval;
   char *strval;

#line 111 "Parser.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;


int yyparse (void);


#endif /* !YY_YY_PARSER_TAB_H_INCLUDED  */
