%{
int yylineno;
%}

alpha [A-Za-z_]
digit [0-9]


%%
[ \t] ;
\n	{yylineno++;}
\/\/.* ;
\/\*(.*\n)*.*\*\/ ;
"{"	{scope_start(); return '{';}
"}"	{scope_end(); return '}';}
";"	     {   return(';'); }
","	     {   return(','); }
":"	     {   return(':'); }
"="	     {   return('='); }
"("	     {   return('('); }
")"	     {   return(')'); }
("[") 	     {   return('['); }
("]")        {   return(']'); }
"."	     {   return('.'); }
"&"	     {   return('&'); }
"!"	     {   return('!'); }
"~"	     {   return('~'); }
"-"	     {   return('-'); }
"+"	     {   return('+'); }
"*"	     {   return('*'); }
"/"	     {   return('/'); }
"%"	     {   return('%'); }
"<"	     {   return('<'); }
">"	     {   return('>'); }
"^"	     {   return('^'); }
"|"	     {   return('|'); }
"?"	     {   return('?'); }
int	{yylval.ival = INT; return INT;}
char {yylval.ival = CHAR; return CHAR;}
float	{yylval.ival = FLOAT; return FLOAT;}
void	{yylval.ival = VOID; return VOID;}
else	{return ELSE;}
do	return DO;
if	return IF;
^"import".+		{ return IMPORT; }
^"class".+		{return CLASS; }
main		{ return MAIN; }
while	return WHILE;
for	return FOR;
println return PRINT;
System return SYSTEM;
private return PRIVATE;
public return PUBLIC;
protected return PROTECTED;
static return STATIC;
out return OUT;
String return STR;


{alpha}({alpha}|{digit})* {yylval.str=strdup(yytext); return ID;}
{digit}*	{yylval.str=strdup(yytext);return NUM;}
{digit}+\.{digit}+ 	{yylval.str=strdup(yytext); return REAL;}
({digit}+\,)*{digit} {return ARRAY_LIST;}
"<="		return LE;
"++" 		return INC;
"--"		return DEC;
">="		return GE;
"=="		return EQ;
"!="		return NEQ;
"&&"		return AND;
"||"		return OR;


\".*\"	return STRING;
.	return yytext[0];
%%
