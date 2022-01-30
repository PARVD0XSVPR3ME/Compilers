/* A Bison parser, made by GNU Bison 3.2.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

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

/* Undocumented macros, especially those whose name start with YY_,
   are private implementation details.  Do not rely on them.  */

#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    DATA = 258,
    ENDOPENTAG = 259,
    CLOSETAG = 260,
    BEGIN_WORKBOOK = 261,
    BEGIN_WORKSHEET = 262,
    BEGIN_STYLES = 263,
    BEGIN_STYLE = 264,
    BEGIN_TABLE = 265,
    BEGIN_COLUMN = 266,
    BEGIN_ROW = 267,
    BEGIN_CELL = 268,
    BEGIN_DATA = 269,
    END_WORKBOOK = 270,
    END_WORKSHEET = 271,
    END_STYLES = 272,
    END_STYLE = 273,
    END_TABLE = 274,
    END_ROW = 275,
    END_CELL = 276,
    SELFCLOSINGTAG = 277,
    ID_EQUALS_QUOTE = 278,
    NAME_EQUALS_QUOTE = 279,
    PROTECTED_EQUALS_QUOTE = 280,
    STYLEID_EQUALS_QUOTE = 281,
    HIDDEN_EQUALS_QUOTE = 282,
    EXPANDEDROWCOUNT_EQUALS_QUOTE = 283,
    EXPANDEDCOLUMNCOUNT_EQUALS_QUOTE = 284,
    WIDTH_EQUALS_QUOTE = 285,
    HEIGHT_EQUALS_QUOTE = 286,
    MERGEACROSS_EQUALS_QUOTE = 287,
    MERGEDOWN_EQUALS_QUOTE = 288,
    TYPE_EQUALS_QUOTE = 289,
    OPEN_COMMMENTS = 290,
    CLOSE_COMMMENTS = 291,
    QUOTE = 292,
    COMMENTS = 293,
    ID_STRING = 294,
    STRING = 295,
    DATA_TYPE = 296,
    DATA_TEXT = 297,
    POSITIVE_INT = 298,
    BOOLEAN = 299
  };
#endif
/* Tokens.  */
#define DATA 258
#define ENDOPENTAG 259
#define CLOSETAG 260
#define BEGIN_WORKBOOK 261
#define BEGIN_WORKSHEET 262
#define BEGIN_STYLES 263
#define BEGIN_STYLE 264
#define BEGIN_TABLE 265
#define BEGIN_COLUMN 266
#define BEGIN_ROW 267
#define BEGIN_CELL 268
#define BEGIN_DATA 269
#define END_WORKBOOK 270
#define END_WORKSHEET 271
#define END_STYLES 272
#define END_STYLE 273
#define END_TABLE 274
#define END_ROW 275
#define END_CELL 276
#define SELFCLOSINGTAG 277
#define ID_EQUALS_QUOTE 278
#define NAME_EQUALS_QUOTE 279
#define PROTECTED_EQUALS_QUOTE 280
#define STYLEID_EQUALS_QUOTE 281
#define HIDDEN_EQUALS_QUOTE 282
#define EXPANDEDROWCOUNT_EQUALS_QUOTE 283
#define EXPANDEDCOLUMNCOUNT_EQUALS_QUOTE 284
#define WIDTH_EQUALS_QUOTE 285
#define HEIGHT_EQUALS_QUOTE 286
#define MERGEACROSS_EQUALS_QUOTE 287
#define MERGEDOWN_EQUALS_QUOTE 288
#define TYPE_EQUALS_QUOTE 289
#define OPEN_COMMMENTS 290
#define CLOSE_COMMMENTS 291
#define QUOTE 292
#define COMMENTS 293
#define ID_STRING 294
#define STRING 295
#define DATA_TYPE 296
#define DATA_TEXT 297
#define POSITIVE_INT 298
#define BOOLEAN 299

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 16 "bison.y" /* yacc.c:1906  */

  int num;
  char *str;
  bool boolean;

#line 151 "y.tab.h" /* yacc.c:1906  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif

/* Location type.  */
#if ! defined YYLTYPE && ! defined YYLTYPE_IS_DECLARED
typedef struct YYLTYPE YYLTYPE;
struct YYLTYPE
{
  int first_line;
  int first_column;
  int last_line;
  int last_column;
};
# define YYLTYPE_IS_DECLARED 1
# define YYLTYPE_IS_TRIVIAL 1
#endif


extern YYSTYPE yylval;
extern YYLTYPE yylloc;
int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
