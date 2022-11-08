/*
 * A programmer's apology and warning
 *
 * Sorry (tm Canada :-)) for the appalling condition of the code below.
 *
 * The people who worked on this repo did NOT write this code. Well, OK, we DID
 * write this comment. We refer to code beyond this comment. The code below was
 * generated by the bison or flex code generators.
 *
 * WARNING: We do NOT recommend that you modify the generated code even though
 * it is digitally odoriferous and has a gleety appearance. Beautification of
 * this code, no matter how disagreeable it may seem, is unwise as such
 * modifications tend to be practically impossible to maintain. Even if this
 * Flying Spaghetti Monster style code tempts you to tweak it, doing so might
 * produce visions and nightmares of Cthulhu-like tentacles grabbing at the very
 * logic of your mind, pulling it down into a hideous maelstrom of code
 * maintenance cacophony.
 *
 * OK, it might not give you nightmares but why take the risk? The point is
 * don't work on this file! Instead work on the bison and flex related source
 * files. See the Makefile for details on how this file was generated. See also
 * run_bison.sh and run_flex.sh.
 *
 * Now some might be tempted to point out this code is in support of the
 * International Obfuscated C Code Contest (IOCCC) and that objecting to the
 * output of Bison and Flex borders on programming sanctimoniousness. At first
 * glance, this incongruence is unsustainable. In response we opine that one of
 * the fundamental undertones of the IOCCC is the promotion of good programming
 * through irony by awarding highly obfuscated C code. So, if it helps, we
 * suggest you view this apology in a satirical light, even if you are humour
 * impaired. Nevertheless, we still recommend you to eschew modifying the code
 * below.
 *
 * Thanks in advance for your understanding, and sorry (tm Canada :-)).
 *
 * Of course, on the other hand, the fact the scanner and parser are for JSON
 * might suggest that we shouldn't have to apologise because the JSON spec is
 * objectionable and so are the generated scanner and parser so this apology
 * might very well be superfluous. If one were to then ignore the fact that
 * bison and flex do not care what they are parsing this same person could
 * argue, obviously by some perverted logical fallacies, that bison and flex did
 * their job well. Well, OK they probably DID do their job well but in an
 * objectionable way. :-)
 *
 * P.S. In 2022 April 04, when this comment was initially formed, none of the
 *	people working on this repo were Canadian. But some of them have
 *	several	good friends who live in, or are from Canada. Those friends
 *	say sorry in a fun and friendly way, so we honour those friends
 *	accordingly.
 */
#line 1 "jparse.tab.h"
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

#ifndef YY_YY_JPARSE_TAB_H_INCLUDED
# define YY_YY_JPARSE_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif
/* "%code requires" blocks.  */
#line 73 "jparse.y"

    #if !defined(YYLTYPE_IS_DECLARED)
    struct YYLTYPE
    {
	int first_line;
	int first_column;
	int last_line;
	int last_column;
	char const *filename;
    };
    typedef struct YYLTYPE YYLTYPE;
    #define YYLTYPE_IS_DECLARED 1
    #define YYLLOC_DEFAULT(Current, Rhs, N)                             \
    do                                                                  \
      if (N)                                                            \
        {                                                               \
          (Current).first_line   = YYRHSLOC (Rhs, 1).first_line;        \
          (Current).first_column = YYRHSLOC (Rhs, 1).first_column;      \
          (Current).last_line    = YYRHSLOC (Rhs, N).last_line;         \
          (Current).last_column  = YYRHSLOC (Rhs, N).last_column;       \
	  (Current).filename     = YYRHSLOC (Rhs, 1).filename;		\
        }                                                               \
      else                                                              \
        { /* empty RHS */                                               \
          (Current).first_line   = (Current).last_line   =              \
            YYRHSLOC (Rhs, 0).last_line;                                \
          (Current).first_column = (Current).last_column =              \
            YYRHSLOC (Rhs, 0).last_column;                              \
	  (Current).filename = NULL;					\
        }                                                               \
    while (0)
    #endif
    typedef void * yyscan_t;

#line 84 "jparse.tab.h"

/* Token kinds.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    YYEMPTY = -2,
    YYEOF = 0,                     /* "end of file"  */
    YYerror = 256,                 /* error  */
    YYUNDEF = 257,                 /* "invalid token"  */
    JSON_OPEN_BRACE = 258,         /* "{"  */
    JSON_CLOSE_BRACE = 259,        /* "}"  */
    JSON_OPEN_BRACKET = 260,       /* "["  */
    JSON_CLOSE_BRACKET = 261,      /* "]"  */
    JSON_COMMA = 262,              /* ","  */
    JSON_COLON = 263,              /* ":"  */
    JSON_NULL = 264,               /* "null"  */
    JSON_TRUE = 265,               /* "true"  */
    JSON_FALSE = 266,              /* "false"  */
    JSON_STRING = 267,             /* JSON_STRING  */
    JSON_NUMBER = 268,             /* JSON_NUMBER  */
    token = 269                    /* token  */
  };
  typedef enum yytokentype yytoken_kind_t;
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef struct json * YYSTYPE;
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




int yyparse (struct json **tree, yyscan_t scanner);


#endif /* !YY_YY_JPARSE_TAB_H_INCLUDED  */
