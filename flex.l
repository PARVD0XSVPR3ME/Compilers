%{
#include <stdbool.h>
#include "y.tab.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#define STYLE 0
#define STYLEID 1
#define IS_EXPROWCOUNT 0
#define IS_EXPCOLCOUNT 1

typedef struct {
  char **array;
  size_t used;
  size_t size;
} Array;

void initialize_array(Array *a,int  size);
void free_array(Array *a);
void insert_array(Array *a, char *str);
void remove_spaces(char* source);
void yyerror (char *s);
int styleid_error=0;
Array ssid;
int counter = 1 ;
int flag;
int row_num=0;
int col_num=0;
int exprowcount_num=0;
int expcolcount_num=0;
int exprowcount_exist=0;
int expcolcount_exist=0;
int flag_2;
char * datatype;
%}
%option noyywrap
%option yylineno
quote \"
boolean (True|False|true|false|0|1)
ws [ \t\r\n]
whitespaces [ \t\r\n]+
positive_int [1-9]([0-9])*
str [^\"<&/\\?*\[\]:]*
id_str [^\"<&/\\?*\[\]:]*


data_type (Number|DateTime|Boolean|String)
%x comments
%x inside_boolean
%x inside_pos_int
%x inside_str
%x inside_id_str
%x inside_data_type
%x inside_data_tag
%x inside_data_content
%x comments_ins
%%

"<"{whitespaces}?"ss:Workbook"  {char* src = strdup(yytext);  remove_spaces(src);printf("%s",src); return BEGIN_WORKBOOK;}
"<"{whitespaces}?"ss:Worksheet" {char* src = strdup(yytext);  remove_spaces(src);printf("\n\t%s",src); return BEGIN_WORKSHEET;}
"<"{whitespaces}?"ss:Styles"    {char* src = strdup(yytext);  remove_spaces(src);printf("\n\t%s",src); return BEGIN_STYLES;}
"<"{whitespaces}?"ss:Style"     {char* src = strdup(yytext);  remove_spaces(src);printf("\n\t\t%s",src); return BEGIN_STYLE;}
"<"{whitespaces}?"ss:Table"     {char* src = strdup(yytext);  remove_spaces(src);printf("\n\t\t%s",src); return BEGIN_TABLE;}
"<"{whitespaces}?"ss:Column"    {char* src = strdup(yytext);  remove_spaces(src);printf("\n\t\t\t%s",src);col_num++; return BEGIN_COLUMN; }
"<"{whitespaces}?"ss:Row"       {char* src = strdup(yytext);  remove_spaces(src);printf("\n\t\t\t%s",src);row_num++; return BEGIN_ROW; }
"<"{whitespaces}?"ss:Cell"      {char* src = strdup(yytext);  remove_spaces(src);printf("\n\t\t\t\t%s",src); return BEGIN_CELL;}
"<"{whitespaces}?"ss:Data"      {char* src = strdup(yytext);  remove_spaces(src);printf("\n\t\t\t\t\t%s",src); return BEGIN_DATA;}
"</"{whitespaces}?"ss:Workbook"  {char* src = strdup(yytext);  remove_spaces(src);printf("\n%s",src); return END_WORKBOOK;}
"</"{whitespaces}?"ss:Worksheet" {char* src = strdup(yytext);  remove_spaces(src);printf("\n\t%s",src); return END_WORKSHEET;}
"</"{whitespaces}?"ss:Styles"    {char* src = strdup(yytext);  remove_spaces(src);printf("\n\t%s",src); return END_STYLES;}
"</"{whitespaces}?"ss:Style"     {char* src = strdup(yytext);  remove_spaces(src);printf("%s",src); return END_STYLE;}
"</"{whitespaces}?"ss:Table"     {char* src = strdup(yytext);  remove_spaces(src);printf("\n\t\t%s",src);

if (exprowcount_exist) {
  if (exprowcount_num != row_num) {
    fprintf(stdout, "\n\n---- ERROR FOUND. ss:ExpandedRowCount VALUE MUST AGREE WITH THE NUMBER OF ROWS ----");
    return *yytext;
  }
}
if (expcolcount_exist) {
  if (expcolcount_num != col_num) {
    fprintf(stdout, "\n\n---- ERROR FOUND. ss:ExpandedColumnCount VALUE MUST AGREE WITH THE NUMBER OF COLUMNS ----");
    return *yytext;
  }
}
row_num=0;col_num=0;exprowcount_num=0;expcolcount_num=0;exprowcount_exist=0;expcolcount_exist=0;
return END_TABLE;
}
"</"{whitespaces}?"ss:Row"       {char* src = strdup(yytext);  remove_spaces(src);printf("\n\t\t\t%s",src); return END_ROW;}
"</"{whitespaces}?"ss:Cell"      {char* src = strdup(yytext);  remove_spaces(src);printf("\n\t\t\t\t%s",src); return END_CELL;}
"ss:Data"      {printf("%s",yytext); return DATA;}
">"            {printf("%s",yytext); return CLOSETAG;}
"/>"           {printf("%s",yytext); return SELFCLOSINGTAG;}
"ss:ID"{whitespaces}?"="{whitespaces}?{quote} {flag = STYLE ;BEGIN(inside_id_str);
char* src = strdup(yytext);  remove_spaces(src);printf(" %s",src); return ID_EQUALS_QUOTE;}
"ss:Name"{whitespaces}?"="{whitespaces}?{quote} {BEGIN(inside_str);
char* src = strdup(yytext);  remove_spaces(src);printf(" %s",src); return NAME_EQUALS_QUOTE;}
"ss:Protected"{whitespaces}?"="{whitespaces}?{quote}/{boolean} {BEGIN(inside_boolean);
char* src = strdup(yytext);  remove_spaces(src);printf(" %s",src); return PROTECTED_EQUALS_QUOTE;}
"ss:StyleID"{whitespaces}?"="{whitespaces}?{quote}/{id_str} {flag = STYLEID ; BEGIN(inside_id_str);
char* src = strdup(yytext);  remove_spaces(src);printf(" %s",src); return STYLEID_EQUALS_QUOTE;}
"ss:Hidden"{whitespaces}?"="{whitespaces}?{quote}/{boolean} {BEGIN(inside_boolean);
char* src = strdup(yytext);  remove_spaces(src);printf(" %s",src); return HIDDEN_EQUALS_QUOTE;}
"ss:ExpandedRowCount"{whitespaces}?"="{whitespaces}?{quote}/{positive_int} {exprowcount_exist = 1;flag_2 = IS_EXPROWCOUNT;BEGIN(inside_pos_int);
char* src = strdup(yytext);  remove_spaces(src);printf(" %s",src); return EXPANDEDROWCOUNT_EQUALS_QUOTE;}
"ss:ExpandedColumnCount"{whitespaces}?"="{whitespaces}?{quote}/{positive_int} {expcolcount_exist = 1;flag_2 = IS_EXPCOLCOUNT; BEGIN(inside_pos_int);
char* src = strdup(yytext);  remove_spaces(src);printf(" %s",src); return EXPANDEDCOLUMNCOUNT_EQUALS_QUOTE;}
"ss:Width"{whitespaces}?"="{whitespaces}?{quote}/{positive_int} {BEGIN(inside_pos_int);
char* src = strdup(yytext);  remove_spaces(src);printf(" %s",src); return WIDTH_EQUALS_QUOTE;}
"ss:Height"{whitespaces}?"="{whitespaces}?{quote}/{positive_int} {BEGIN(inside_pos_int);
char* src = strdup(yytext);  remove_spaces(src);printf(" %s",src); return HEIGHT_EQUALS_QUOTE;}
"ss:MergeAcross"{whitespaces}?"="{whitespaces}?{quote}/{positive_int} {BEGIN(inside_pos_int);
char* src = strdup(yytext);  remove_spaces(src);printf(" %s",src); return MERGEACROSS_EQUALS_QUOTE;}
"ss:MergeDown"{whitespaces}?"="{whitespaces}?{quote}/{positive_int} {BEGIN(inside_pos_int);
char* src = strdup(yytext);  remove_spaces(src);printf(" %s",src); return MERGEDOWN_EQUALS_QUOTE;}
"ss:Type"{whitespaces}?"="{whitespaces}?{quote}/{data_type} {BEGIN(inside_data_type);
char* src = strdup(yytext);  remove_spaces(src);printf(" %s",src); return TYPE_EQUALS_QUOTE;}

"<!--" {BEGIN(comments); printf("%s",yytext);
return OPEN_COMMMENTS;}
<comments>([^-]|-[^-])* {
      printf("%s",yytext);
      yylval.str = strdup(yytext);
      return COMMENTS;
}
<comments>"--" { return *yytext; }
<comments>"-->" {BEGIN(INITIAL);
  printf("%s",yytext);
return CLOSE_COMMMENTS; }

<inside_id_str>{id_str} {
      if (flag == STYLE ) {
        if (counter == 1) {

          initialize_array(&ssid,strlen(strdup(yytext)));
          insert_array(&ssid,strdup(yytext));
          counter++;
        }
        else {
          int equals = 0;
          for (int i =0;i<ssid.size;i++) {
            if (!strcmp(ssid.array[i],strdup(yytext))) {
              equals = 1;
            }
          }
          if (!equals) {
            insert_array(&ssid,strdup(yytext));
          } else {
            fprintf(stdout, "\n\n---- ERROR FOUND. ss:ID VALUE MUST BE UNIQUE ----");
            free_array(&ssid);
            return *yytext;
          }
        }
      }
      else if(flag == STYLEID) {
        int equals1 = 0;
        for (int i =0;i<ssid.size;i++) {
          if (!strcmp(ssid.array[i],strdup(yytext))) {
            equals1 = 1;
          }
        }
        if (!equals1) {
          fprintf(stdout, "\n\n---- ERROR FOUND. ss:ID WITH ss:StyleID VALUE NOT FOUND ----");
          free_array(&ssid);
          return *yytext;
        }


      }
      printf("%s",yytext);
      yylval.str = strdup(yytext);
      return ID_STRING;
}
<inside_id_str>[<&/\\?*\[\]:] { return *yytext; }
<inside_id_str>{quote} {BEGIN(INITIAL);printf("%s",yytext);
return QUOTE;}

<inside_str>{str} {
      printf("%s",yytext);
      yylval.str = strdup(yytext);
      return STRING;
}
<inside_str>[<&/\\?*\[\]:] { return *yytext; }
<inside_str>{quote} {BEGIN(INITIAL);printf("%s",yytext);
return QUOTE;  }

<inside_boolean>{boolean}/{quote} {
      printf("%s",yytext);
      yylval.boolean = strdup(yytext);
      return BOOLEAN;
}
<inside_boolean>{quote} {BEGIN(INITIAL);printf("%s",yytext);
return QUOTE; }

<inside_pos_int>{positive_int}/{quote} {
      if (flag_2 == IS_EXPROWCOUNT) {
        exprowcount_num = atoi(strdup(yytext));

      }
      else if (flag_2 == IS_EXPCOLCOUNT) {
        expcolcount_num = atoi(strdup(yytext));
      }

      printf("%s",yytext);
      yylval.num = atoi(strdup(yytext));
      return POSITIVE_INT;
}
<inside_pos_int>{quote} {BEGIN(INITIAL);printf("%s",yytext);
return QUOTE;  }

<inside_data_type>{data_type}/{quote} {
      printf("%s",yytext);
      datatype = strdup(yytext);
      yylval.str = strdup(yytext);
      return DATA_TYPE;
}
<inside_data_type>{quote} {BEGIN(inside_data_tag);printf("%s",yytext);
return QUOTE; }

<inside_data_tag>{whitespaces}?">" { BEGIN(inside_data_content);printf("%s",yytext);
      return CLOSETAG;
}
<inside_data_tag>[^> \t\r\n] {  return *yytext;
}

<inside_data_content>"<!--" {BEGIN(comments_ins);printf("%s",yytext);
return OPEN_COMMMENTS;}
<comments_ins>([^-]|-[^-])* {
      printf("%s",yytext);
      yylval.str = strdup(yytext);
      return COMMENTS;
}
<comments_ins>"--" { return *yytext; }
<comments_ins>"-->" {BEGIN(inside_data_content);printf("%s",yytext);   return CLOSE_COMMMENTS; }

<inside_data_content>{str} {
      printf("%s",yytext);
      yylval.str = strdup(yytext);
      return DATA_TEXT;
}
<inside_data_content>"</" {BEGIN(INITIAL);printf("%s",yytext);
return ENDOPENTAG; }

{ws}   				;
. { return *yytext;}

%%
void initialize_array(Array *a,int  size) {
  a->array = malloc(sizeof(char*));
  a->used = 0;
  a->size = 1;
  a->array[a->used] = malloc((size+1) * sizeof(char));
}

void insert_array(Array *a, char *str) {
  if (a->used == a->size) {
    a->size +=1;
    a->array = realloc(a->array, a->size * sizeof(char*));
    a->array[a->used] = malloc((strlen(str)+1) * sizeof(char));
  }
    a->array[a->used++] = str;
}

void free_array(Array *a) {
  free(a->array);
  a->array = NULL;
  a->used = a->size = 0;
}

void remove_spaces(char* source)
{
  char* i = source;
  char* j = source;
  while(*j != 0)
  {
    *i = *j++;
    if(!isspace(*i))
      i++;
  }
  *i = 0;
}
