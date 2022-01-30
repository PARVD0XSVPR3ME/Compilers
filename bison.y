%{
#include <stdbool.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

void yyerror(char *);
extern int yylineno;
extern int yylex();
extern char* yytext;
extern FILE *yyin;
extern FILE *yyout;
bool error_found = 0;

%}
%union {
  int num;
  char *str;
  bool boolean;
}

%token DATA ENDOPENTAG CLOSETAG  BEGIN_WORKBOOK BEGIN_WORKSHEET BEGIN_STYLES BEGIN_STYLE BEGIN_TABLE BEGIN_COLUMN BEGIN_ROW BEGIN_CELL BEGIN_DATA
%token END_WORKBOOK END_WORKSHEET END_STYLES END_STYLE END_TABLE END_ROW END_CELL
%token SELFCLOSINGTAG ID_EQUALS_QUOTE NAME_EQUALS_QUOTE PROTECTED_EQUALS_QUOTE STYLEID_EQUALS_QUOTE
%token HIDDEN_EQUALS_QUOTE EXPANDEDROWCOUNT_EQUALS_QUOTE EXPANDEDCOLUMNCOUNT_EQUALS_QUOTE
%token WIDTH_EQUALS_QUOTE HEIGHT_EQUALS_QUOTE MERGEACROSS_EQUALS_QUOTE MERGEDOWN_EQUALS_QUOTE
%token TYPE_EQUALS_QUOTE OPEN_COMMMENTS CLOSE_COMMMENTS QUOTE
%token <str> COMMENTS  ID_STRING  STRING DATA_TYPE DATA_TEXT
%token <num> POSITIVE_INT
%token <boolean> BOOLEAN
%locations
%%
workbook : BEGIN_WORKBOOK CLOSETAG styles  worksheet  END_WORKBOOK CLOSETAG |
comments BEGIN_WORKBOOK CLOSETAG  styles  worksheet  END_WORKBOOK CLOSETAG |
BEGIN_WORKBOOK CLOSETAG  styles  worksheet  END_WORKBOOK CLOSETAG comments |
comments BEGIN_WORKBOOK CLOSETAG  styles  worksheet  END_WORKBOOK CLOSETAG comments |
BEGIN_WORKBOOK CLOSETAG comments styles  worksheet  END_WORKBOOK CLOSETAG |
comments BEGIN_WORKBOOK CLOSETAG comments  styles  worksheet  END_WORKBOOK CLOSETAG |
BEGIN_WORKBOOK CLOSETAG comments styles  worksheet  END_WORKBOOK CLOSETAG comments |
comments BEGIN_WORKBOOK CLOSETAG comments styles  worksheet  END_WORKBOOK CLOSETAG comments
styles : /*empty*/ |
styles BEGIN_STYLES CLOSETAG  style  END_STYLES CLOSETAG comments |
styles BEGIN_STYLES CLOSETAG  style  END_STYLES CLOSETAG |
styles BEGIN_STYLES CLOSETAG  style comments END_STYLES CLOSETAG comments |
styles BEGIN_STYLES CLOSETAG  style comments END_STYLES CLOSETAG
style : /*empty*/  |
style BEGIN_STYLE ID_EQUALS_QUOTE ID_STRING QUOTE CLOSETAG  END_STYLE CLOSETAG |
style comments BEGIN_STYLE ID_EQUALS_QUOTE ID_STRING QUOTE CLOSETAG  END_STYLE CLOSETAG |
style BEGIN_STYLE ID_EQUALS_QUOTE ID_STRING QUOTE CLOSETAG comments  END_STYLE CLOSETAG |
style comments BEGIN_STYLE ID_EQUALS_QUOTE ID_STRING QUOTE CLOSETAG comments END_STYLE CLOSETAG
worksheet : worksheet_cont |
worksheet worksheet_cont
worksheet_cont : BEGIN_WORKSHEET worksheet_attr CLOSETAG table END_WORKSHEET CLOSETAG  |
BEGIN_WORKSHEET worksheet_attr CLOSETAG table END_WORKSHEET CLOSETAG comments  |
BEGIN_WORKSHEET worksheet_attr CLOSETAG comments table END_WORKSHEET CLOSETAG |
BEGIN_WORKSHEET worksheet_attr CLOSETAG comments table END_WORKSHEET CLOSETAG comments
worksheet_attr : name protected | protected name | name
name : NAME_EQUALS_QUOTE STRING QUOTE
protected : PROTECTED_EQUALS_QUOTE BOOLEAN QUOTE
table : /*empty*/  |  table  BEGIN_TABLE table_attr CLOSETAG table_elements END_TABLE CLOSETAG  |
table  BEGIN_TABLE table_attr CLOSETAG table_elements END_TABLE CLOSETAG comments  |
table  BEGIN_TABLE table_attr CLOSETAG comments table_elements END_TABLE CLOSETAG   |
table  BEGIN_TABLE table_attr CLOSETAG comments table_elements END_TABLE CLOSETAG comments
table_attr : /*empty*/   | expcolcount  | exprowcount  | styleid  | expcolcount exprowcount  | exprowcount expcolcount  |
expcolcount styleid | styleid expcolcount  | exprowcount styleid  | styleid exprowcount  | expcolcount exprowcount styleid  |
expcolcount styleid exprowcount  | exprowcount expcolcount styleid  | exprowcount styleid expcolcount  |
styleid exprowcount expcolcount  | styleid expcolcount exprowcount
expcolcount : EXPANDEDCOLUMNCOUNT_EQUALS_QUOTE POSITIVE_INT QUOTE
exprowcount : EXPANDEDROWCOUNT_EQUALS_QUOTE POSITIVE_INT QUOTE
styleid : STYLEID_EQUALS_QUOTE ID_STRING QUOTE
table_elements : /*empty*/  |column | row | column row
column : BEGIN_COLUMN column_attr SELFCLOSINGTAG | column BEGIN_COLUMN column_attr SELFCLOSINGTAG |
BEGIN_COLUMN column_attr SELFCLOSINGTAG comments | column BEGIN_COLUMN column_attr SELFCLOSINGTAG comments
column_attr : /*empty*/  | hidden | width | styleid | hidden width | width hidden |
hidden styleid | styleid hidden | width styleid | styleid width | hidden width styleid |
hidden styleid width | width hidden styleid | width styleid hidden |
styleid width hidden | styleid hidden width
hidden : HIDDEN_EQUALS_QUOTE BOOLEAN QUOTE
width : WIDTH_EQUALS_QUOTE POSITIVE_INT QUOTE
row : BEGIN_ROW row_attr CLOSETAG cell END_ROW CLOSETAG | row BEGIN_ROW row_attr CLOSETAG cell END_ROW CLOSETAG |
BEGIN_ROW row_attr CLOSETAG cell END_ROW CLOSETAG comments | row BEGIN_ROW row_attr CLOSETAG cell END_ROW CLOSETAG comments |
BEGIN_ROW row_attr CLOSETAG comments cell END_ROW CLOSETAG | row BEGIN_ROW row_attr CLOSETAG comments cell END_ROW CLOSETAG |
BEGIN_ROW row_attr CLOSETAG comments cell END_ROW CLOSETAG comments | row BEGIN_ROW row_attr CLOSETAG comments cell END_ROW CLOSETAG comments
row_attr : /*empty*/ | hidden | height | styleid | hidden height | height hidden |
hidden styleid | styleid hidden | height styleid | styleid height | hidden height styleid |
hidden styleid height | height hidden styleid | height styleid hidden |
styleid height hidden | styleid hidden height
height : HEIGHT_EQUALS_QUOTE POSITIVE_INT QUOTE
cell : /*empty*/ | cell BEGIN_CELL cell_attr CLOSETAG data END_CELL CLOSETAG |
cell BEGIN_CELL cell_attr CLOSETAG data END_CELL CLOSETAG comments |
cell BEGIN_CELL cell_attr CLOSETAG comments data END_CELL CLOSETAG |
cell BEGIN_CELL cell_attr CLOSETAG comments data END_CELL CLOSETAG comments
cell_attr : /*empty*/ | mergedown | mergeacross | styleid | mergedown mergeacross | mergeacross mergedown |
mergedown styleid | styleid mergedown | mergeacross styleid | styleid mergeacross | mergedown mergeacross styleid |
mergedown styleid mergeacross | mergeacross mergedown styleid | mergeacross styleid mergedown |
styleid mergeacross mergedown | styleid mergedown mergeacross
mergedown : MERGEDOWN_EQUALS_QUOTE POSITIVE_INT QUOTE
mergeacross : MERGEACROSS_EQUALS_QUOTE POSITIVE_INT QUOTE
data : /*empty*/ | data BEGIN_DATA TYPE_EQUALS_QUOTE DATA_TYPE QUOTE CLOSETAG DATA_TEXT ENDOPENTAG DATA CLOSETAG |
data BEGIN_DATA TYPE_EQUALS_QUOTE DATA_TYPE QUOTE CLOSETAG DATA_TEXT ENDOPENTAG DATA CLOSETAG comments |
data BEGIN_DATA TYPE_EQUALS_QUOTE DATA_TYPE QUOTE CLOSETAG comments DATA_TEXT ENDOPENTAG DATA CLOSETAG |
data BEGIN_DATA TYPE_EQUALS_QUOTE DATA_TYPE QUOTE CLOSETAG DATA_TEXT comments ENDOPENTAG DATA CLOSETAG |
data BEGIN_DATA TYPE_EQUALS_QUOTE DATA_TYPE QUOTE CLOSETAG comments DATA_TEXT comments ENDOPENTAG DATA CLOSETAG |
data BEGIN_DATA TYPE_EQUALS_QUOTE DATA_TYPE QUOTE CLOSETAG comments DATA_TEXT ENDOPENTAG DATA CLOSETAG comments |
data BEGIN_DATA TYPE_EQUALS_QUOTE DATA_TYPE QUOTE CLOSETAG DATA_TEXT comments ENDOPENTAG DATA CLOSETAG comments |
data BEGIN_DATA TYPE_EQUALS_QUOTE DATA_TYPE QUOTE CLOSETAG comments DATA_TEXT comments ENDOPENTAG DATA CLOSETAG comments
comments : OPEN_COMMMENTS COMMENTS CLOSE_COMMMENTS |
comments OPEN_COMMMENTS COMMENTS CLOSE_COMMMENTS
%%

void yyerror(char *s) {
    error_found = 1;
    fprintf(stdout, "\n\n---- STOPPED. PARSING WAS UNSUCCESSFUL. FOUND ERROR AT LINE #%d. %s ----\n\n",yylineno, s);
    
}

int main (int argc, char **argv)
{
  ++argv; --argc;
  if ( argc > 0 )
        yyin = fopen( argv[0], "r" );
  else
        yyin = stdin;

  yyparse ();
  if(!error_found) {
	     printf("\n\n---- PARSING SUCCESSFULLY COMPLETED. THE PROGRAM IS VALID. ----\n\n");
  }
  return 0;
}
