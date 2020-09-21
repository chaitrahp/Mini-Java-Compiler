%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	#include "y.tab.h"


	int line = 1;
	extern int scope;
	extern void yyerror(const char *);  
	extern struct node * checksym(char *);
%}

letter [A-Za-z_]
digit [0-9]
alpha_numeric [a-zA-Z_0-9]
ws  [ \t\v\f]

%%
[\n]		{ fprintf(yyout, "%s", yytext); line++;	}
\/\/.* ;
\/\*(.*\n)*.*\*\/ ;

int			{ fprintf(yyout, "%s", yytext);  yylval.ival=0; return(INT); 	}
float		{ fprintf(yyout, "%s", yytext);  yylval.ival=1; return(FLOAT); }
String		{ fprintf(yyout, "%s", yytext); return(STRING); }
char		{ fprintf(yyout, "%s", yytext);  yylval.ival=2; return(CHAR); }
void		{ fprintf(yyout, "%s", yytext);  yylval.ival=3; return(VOID); }
boolean		{ fprintf(yyout, "%s", yytext); return(BOOLEAN); }
^"import".+		{ fprintf(yyout, "%s", yytext);  return IMPORT; }
^"class".+		{ fprintf(yyout, "%s", yytext);  return CLASS; }
main		{ fprintf(yyout, "%s", yytext);  return MAIN; }
for			{ fprintf(yyout, "%s", yytext);  return FOR; }
while		{ fprintf(yyout, "%s", yytext);  return WHILE; }
if			{ fprintf(yyout, "%s", yytext);  return IF; }
else			{ fprintf(yyout, "%s", yytext);  return ELSE; }
System 		{ fprintf(yyout, "%s", yytext);	 return SYSTEM; }
out 		{ fprintf(yyout, "%s", yytext);	 return OUT; }
println 		{ fprintf(yyout, "%s", yytext);	 return PRINT;}
public			{ fprintf(yyout, "%s", yytext);  return PUBLIC; }
private			{ fprintf(yyout, "%s", yytext);  return PRIVATE; }
protected			{ fprintf(yyout, "%s", yytext);  return PROTECTED; }
static			{ fprintf(yyout, "%s", yytext);  return STATIC; }
{letter}{alpha_numeric}*	{	fprintf(yyout, "%s", yytext);  
									yylval.ptr = checksym(yytext); 
									return IDENTIFIER;
								}
{digit}+\.{digit}+	{	fprintf(yyout, "%s", yytext);   
									yylval.fval=atof(yytext);
									return FLOAT_LITERAL;
								}  		
{digit}+	{	fprintf(yyout, "%s", yytext);  
									yylval.ival=atoi(yytext);
									return INTEGER_LITERAL;
								}

"'"."'"		{	fprintf(yyout, "%s", yytext);
									yylval.cval= yytext[1];
									return CHARACTER_LITERAL; 
								}
		/*[{digit}+\,]*{digit} {return ARRAY_LIST;}*/	

\".*\"	{fprintf(yyout, "%s", yytext);  return STRING_LITERAL; }
"+="		{fprintf(yyout, "%s", yytext);  return(ADD_ASSIGN); }
"-="		{fprintf(yyout, "%s", yytext);  return(SUB_ASSIGN); }
"*="		{fprintf(yyout, "%s", yytext);  return(MUL_ASSIGN); }
"/="		{fprintf(yyout, "%s", yytext);  return(DIV_ASSIGN); }
"%="		{fprintf(yyout, "%s", yytext);  return(MOD_ASSIGN); }
"++"		{fprintf(yyout, "%s", yytext);  return(INC_OP); }
"--"		{fprintf(yyout, "%s", yytext);  return(DEC_OP); }
"<="		{fprintf(yyout, "%s", yytext);  return(LE_OP); }
">="		{fprintf(yyout, "%s", yytext);  return(GE_OP); }
"=="		{fprintf(yyout, "%s", yytext);  return(EQ_OP); }
"!="		{fprintf(yyout, "%s", yytext);  return(NE_OP); }
";"			{fprintf(yyout, "%s", yytext);  return(';'); }
"{"			{fprintf(yyout, "%s", yytext);  scope++; return('{'); }
"}"			{fprintf(yyout, "%s", yytext); return('}'); }
","			{fprintf(yyout, "%s", yytext);  return(','); }
":"			{fprintf(yyout, "%s", yytext);  return(':'); }
"="			{fprintf(yyout, "%s", yytext);  return('='); }
"("			{fprintf(yyout, "%s", yytext);  return('('); }
")"			{fprintf(yyout, "%s", yytext);  return(')'); }
("["|"<:")	{fprintf(yyout, "%s", yytext);  return('['); }
("]"|":>")	{fprintf(yyout, "%s", yytext);  return(']'); }
"."			{fprintf(yyout, "%s", yytext);  return('.'); }
"&"			{fprintf(yyout, "%s", yytext);  return('&'); }
"!"			{fprintf(yyout, "%s", yytext);  return('!'); }
"~"			{fprintf(yyout, "%s", yytext);  return('~'); }
"-"			{fprintf(yyout, "%s", yytext);  return('-'); }
"+"			{fprintf(yyout, "%s", yytext);  return('+'); }
"*"			{fprintf(yyout, "%s", yytext);  return('*'); }
"/"			{fprintf(yyout, "%s", yytext);  return('/'); }
"%"			{fprintf(yyout, "%s", yytext);  return('%'); }
"<"			{fprintf(yyout, "%s", yytext);  return('<'); }
">"			{fprintf(yyout, "%s", yytext);  return('>'); }
"^"			{fprintf(yyout, "%s", yytext);  return('^'); }
"|"			{fprintf(yyout, "%s", yytext);  return('|'); }
"?"			{fprintf(yyout, "%s", yytext);  return('?'); }
({digit}+\,)*{digit} {fprintf(yyout, "%s", yytext);  return ARRAY_LIST;}
{ws}+		{fprintf(yyout, "%s", yytext);}

.			{ printf("No Match, Invalid Expression %s\n", yytext); return yytext[0];}

%%

