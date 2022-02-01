# Principles Of Programming Languages & Compilers

This repository contains the course project for the **Principles Of Programming Languages & Compilers**
university course for the academic period of 2018-2019 done by <a
href="https://github.com/PARVD0XSVPR3ME">Panagiotis Charalampopoulos</a>.

It's an implementation of a parser for a **subgroup of the Microsoft Excel XML format** using the **Flex**
lexical analyzer generator and the **GNU Bison** parser generator.

## Backus–Naur form (BNF)

```
<workbook> ::= BEGIN_WORKBOOK CLOSETAG <styles> <worksheet> END_WORKBOOK CLOSETAG
   | <comments> BEGIN_WORKBOOK CLOSETAG <styles> <worksheet> END_WORKBOOK CLOSETAG
   | BEGIN_WORKBOOK CLOSETAG <styles> <worksheet> END_WORKBOOK CLOSETAG <comments>
   | <comments> BEGIN_WORKBOOK CLOSETAG <styles> <worksheet> END_WORKBOOK CLOSETAG <comments>
   | BEGIN_WORKBOOK CLOSETAG <comments> <styles> <worksheet> END_WORKBOOK CLOSETAG
   | <comments> BEGIN_WORKBOOK CLOSETAG <comments> <styles> <worksheet> END_WORKBOOK CLOSETAG
   | BEGIN_WORKBOOK CLOSETAG <comments> <styles> <worksheet> END_WORKBOOK CLOSETAG <comments>
   | <comments> BEGIN_WORKBOOK CLOSETAG <comments> <styles> <worksheet> END_WORKBOOK CLOSETAG <comments>
<styles> ::= /*empty*/
| <styles> BEGIN_STYLES CLOSETAG <style> END_STYLES CLOSETAG <comments>
| <styles> BEGIN_STYLES CLOSETAG <style> END_STYLES CLOSETAG
| <styles> BEGIN_STYLES CLOSETAG <style> <comments> END_STYLES CLOSETAG
<comments>
| <styles> BEGIN_STYLES CLOSETAG <style> <comments> END_STYLES CLOSETAG
<style> ::= /*empty*/
| <style> BEGIN_STYLE ID_EQUALS_QUOTE ID_STRING QUOTE CLOSETAG END_STYLE
CLOSETAG
| <style> <comments> BEGIN_STYLE ID_EQUALS_QUOTE ID_STRING QUOTE CLOSETAG
END_STYLE CLOSETAG
| <style> BEGIN_STYLE ID_EQUALS_QUOTE ID_STRING QUOTE CLOSETAG <comments>
END_STYLE CLOSETAG
| <style> <comments> BEGIN_STYLE ID_EQUALS_QUOTE ID_STRING QUOTE CLOSETAG
<comments> END_STYLE CLOSETAG
<worksheet> ::= <worksheet_cont>
| <worksheet> <worksheet_cont>
<worksheet_cont> ::= BEGIN_WORKSHEET <worksheet_attr> CLOSETAG <table>
END_WORKSHEET CLOSETAG
| BEGIN_WORKSHEET <worksheet_attr> CLOSETAG <table> END_WORKSHEET
CLOSETAG <comments>
| BEGIN_WORKSHEET <worksheet_attr> CLOSETAG <comments> <table>
END_WORKSHEET CLOSETAG
| BEGIN_WORKSHEET <worksheet_attr> CLOSETAG <comments> <table>
END_WORKSHEET CLOSETAG <comments>
<worksheet_attr> ::= <name> <protected>
| <protected> <name>
| <name>
<name> ::= NAME_EQUALS_QUOTE STRING QUOTE
<protected> ::= PROTECTED_EQUALS_QUOTE BOOLEAN QUOTE
<table> ::= /*empty*/
| <table> BEGIN_TABLE <table_attr> CLOSETAG <table_elements> END_TABLE CLOSETAG
| <table> BEGIN_TABLE <table_attr> CLOSETAG <table_elements> END_TABLE CLOSETAG
<comments>
| <table> BEGIN_TABLE <table_attr> CLOSETAG <comments> <table_elements> END_TABLE
CLOSETAG
| <table> BEGIN_TABLE <table_attr> CLOSETAG <comments> <table_elements> END_TABLE
CLOSETAG <comments>
<table_attr> ::= /*empty*/
| <expcolcount>
| <exprowcount>
| <styleid>
| <expcolcount> <exprowcount>
| <exprowcount> <expcolcount>
| <expcolcount> <styleid>
| <styleid> <expcolcount>
| <exprowcount> <styleid>
| <styleid> <exprowcount>
| <expcolcount> <exprowcount> <styleid>
| <expcolcount> <styleid> <exprowcount>
| <exprowcount> <expcolcount> <styleid>
| <exprowcount> <styleid> <expcolcount>
| <styleid> <exprowcount> <expcolcount>
| <styleid> <expcolcount> <exprowcount>
<expcolcount> ::= EXPANDEDCOLUMNCOUNT_EQUALS_QUOTE POSITIVE_INT QUOTE
<exprowcount> ::= EXPANDEDROWCOUNT_EQUALS_QUOTE POSITIVE_INT QUOTE
<styleid> ::= STYLEID_EQUALS_QUOTE ID_STRING QUOTE
<table_elements> ::= /*empty*/
| <column>
| <row>
| <column> <row>
<column> ::= BEGIN_COLUMN <column_attr> SELFCLOSINGTAG
| <column> BEGIN_COLUMN <column_attr> SELFCLOSINGTAG
| BEGIN_COLUMN <column_attr> SELFCLOSINGTAG <comments>
| <column> BEGIN_COLUMN <column_attr> SELFCLOSINGTAG <comments>
<column_attr> ::= /*empty*/
| <hidden>
| <width>
| <styleid>
| <hidden> <width>
| <width> <hidden>
| <hidden> <styleid>
| <styleid> <hidden>
| <width> <styleid>
| <styleid> <width>
| <hidden> <width> <styleid>
| <hidden> <styleid> <width>
| <width> <hidden> <styleid>
| <width> <styleid> <hidden>
| <styleid> <width> <hidden>
| <styleid> <hidden> <width>
<hidden> ::= HIDDEN_EQUALS_QUOTE BOOLEAN QUOTE
<width> ::= WIDTH_EQUALS_QUOTE POSITIVE_INT QUOTE
<row> ::= BEGIN_ROW <row_attr> CLOSETAG <cell> END_ROW CLOSETAG
| <row> BEGIN_ROW <row_attr> CLOSETAG <cell> END_ROW CLOSETAG
| BEGIN_ROW <row_attr> CLOSETAG <cell> END_ROW CLOSETAG <comments>
| <row> BEGIN_ROW <row_attr> CLOSETAG <cell> END_ROW CLOSETAG <comments>
| BEGIN_ROW <row_attr> CLOSETAG <comments> <cell> END_ROW CLOSETAG
| <row> BEGIN_ROW <row_attr> CLOSETAG <comments> <cell> END_ROW CLOSETAG
| BEGIN_ROW <row_attr> CLOSETAG <comments> <cell> END_ROW CLOSETAG <comments>
| <row> BEGIN_ROW <row_attr> CLOSETAG <comments> <cell> END_ROW CLOSETAG
<comments>
<row_attr> ::= /*empty*/
| <hidden>
| <height>
| <styleid>
| <hidden> <height>
| <height> <hidden>
| <hidden> <styleid>
| <styleid> <hidden>
| <height> <styleid>
| <styleid> <height>
| <hidden> <height> <styleid>
| <hidden> <styleid> <height>
| <height> <hidden> <styleid>
| <height> <styleid> <hidden>
| <styleid> <height> <hidden>
| <styleid> <hidden> <height>
<height> ::= HEIGHT_EQUALS_QUOTE POSITIVE_INT QUOTE
<cell> ::= /*empty*/
| <cell> BEGIN_CELL <cell_attr> CLOSETAG <data> END_CELL CLOSETAG
| <cell> BEGIN_CELL <cell_attr> CLOSETAG <data> END_CELL CLOSETAG <comments>
| <cell> BEGIN_CELL <cell_attr> CLOSETAG <comments> <data> END_CELL CLOSETAG
| <cell> BEGIN_CELL <cell_attr> CLOSETAG <comments> <data> END_CELL CLOSETAG
<comments>
<cell_attr> ::= /*empty*/
| <mergedown>
| <mergeacross>
| <styleid>
| <mergedown> <mergeacross>
| <mergeacross> <mergedown>
| <mergedown> <styleid>
| <styleid> <mergedown>
| <mergeacross> <styleid>
| <styleid> <mergeacross>
| <mergedown> <mergeacross> <styleid>
| <mergedown> <styleid> <mergeacross>
| <mergeacross> <mergedown> <styleid>
| <mergeacross> <styleid> <mergedown>
| <styleid> <mergeacross> <mergedown>
| <styleid> <mergedown> <mergeacross>
<mergedown> ::= MERGEDOWN_EQUALS_QUOTE POSITIVE_INT QUOTE
<mergeacross> ::= MERGEACROSS_EQUALS_QUOTE POSITIVE_INT QUOTE
<data> ::= /*empty*/
| <data> BEGIN_DATA TYPE_EQUALS_QUOTE DATA_TYPE QUOTE CLOSETAG DATA_TEXT
ENDOPENTAG DATA CLOSETAG
| <data> BEGIN_DATA TYPE_EQUALS_QUOTE DATA_TYPE QUOTE CLOSETAG DATA_TEXT
ENDOPENTAG DATA CLOSETAG <comments>
| <data> BEGIN_DATA TYPE_EQUALS_QUOTE DATA_TYPE QUOTE CLOSETAG <comments>
DATA_TEXT ENDOPENTAG DATA CLOSETAG
| <data> BEGIN_DATA TYPE_EQUALS_QUOTE DATA_TYPE QUOTE CLOSETAG DATA_TEXT
<comments> ENDOPENTAG DATA CLOSETAG
| <data> BEGIN_DATA TYPE_EQUALS_QUOTE DATA_TYPE QUOTE CLOSETAG <comments>
DATA_TEXT <comments> ENDOPENTAG DATA CLOSETAG
| <data> BEGIN_DATA TYPE_EQUALS_QUOTE DATA_TYPE QUOTE CLOSETAG <comments>
DATA_TEXT ENDOPENTAG DATA CLOSETAG <comments>
| <data> BEGIN_DATA TYPE_EQUALS_QUOTE DATA_TYPE QUOTE CLOSETAG DATA_TEXT
<comments> ENDOPENTAG DATA CLOSETAG <comments>
| <data> BEGIN_DATA TYPE_EQUALS_QUOTE DATA_TYPE QUOTE CLOSETAG <comments>
DATA_TEXT <comments> ENDOPENTAG DATA CLOSETAG <comments>
<comments> ::= OPEN_COMMMENTS COMMENTS CLOSE_COMMMENTS
| <comments> OPEN_COMMMENTS COMMENTS CLOSE_COMMMENTS
```


## Compilation Instructions
A `Makefile` is included so assuming `gcc` is installed you can simply run `make` inside this repo to generate
the `parser` executable.

## Usage

`./parser <input_file>`

![](img/2022.02.01-02.58.43.screenshot.png)
![](img/2022.02.01-02.59.46.screenshot.png)
![](img/2022.02.01-03.00.21.screenshot.png)
![](img/2022.02.01-03.00.44.screenshot.png)
![](img/2022.02.01-03.01.53.screenshot.png)
![](img/2022.02.01-03.02.41.screenshot.png)
![](img/2022.02.01-03.03.13.screenshot.png)
![](img/2022.02.01-03.04.21.screenshot.png)
![](img/2022.02.01-03.04.41.screenshot.png)
![](img/2022.02.01-03.04.56.screenshot.png)
![](img/2022.02.01-03.05.23.screenshot.png)

# License
All files except `s` are licensed under the
[AGPL-3.0](https://www.gnu.org/licenses/agpl-3.0.en.html) license.

Copyright © <a href="https://github.com/PARVD0XSVPR3ME">Panagiotis Charalampopoulos</a>
