%{
#include <stdio.h>
#include <stdlib.h>
#include "symbolTable.c"
extern FILE *yyout;
int g_addr = 100;
int i=1,lnum1=0;
int stack[100],index1=0,end[100],arr[10],ct,c,b,fl,top=0,label[20],label_num=0,ltop=0;
char st1[100][10];
char temp_count[2]="0";
int plist[100],flist[100],k=-1,errc=0,j=0;
char temp[2]="t";
char null[2]=" ";
void yyerror(char *s);
int printline();
extern int yylineno;
void scope_start()
{
	
	stack[index1]=i;
	i++;
	index1++;
	return;
}
void scope_end()
{
	index1--;
	end[stack[index1]]=1;
	stack[index1]=0;
	return;
}
void if1()
{
	label_num++;
	strcpy(temp,"t");
	strcat(temp,temp_count);
	//printf("\n%s = %s\n",temp,st1[top]);
	fprintf(yyout,"%s = %s\n",temp,st1[top]);
 	//printf("\nifnot %s go to L%d\n",temp,label_num);
	fprintf(yyout,"ifFalse %s goto L%d\n",temp,label_num);
	temp_count[0]++;
	label[++ltop]=label_num;

}
void if2()
{
	label_num++;
	//printf("\ngo to L%d\n",label_num);
	//printf("\nL%d: \n",label[ltop--]);
	fprintf(yyout,"goto L%d\n",label_num);
	fprintf(yyout,"L%d: ",label[ltop--]);
	label[++ltop]=label_num;
}
void if3()
{
	//printf("\nL%d:\n",label[ltop--]);
	fprintf(yyout,"L%d:",label[ltop--]);
}
void while1()
{
	label_num++;
	label[++ltop]=label_num;
	//printf("\nL%d:\n",label_num);
	fprintf(yyout,"L%d:",label_num);
}
void while2()
{
	label_num++;
	strcpy(temp,"t");
	strcat(temp,temp_count);
	//printf("\n%s = %s\n",temp,st1[top--]);
 	//printf("\nifnot %s go to L%d\n",temp,label_num);
	fprintf(yyout,"%s = %s\n",temp,st1[top--]);
 	fprintf(yyout,"ifFalse %s goto L%d\n",temp,label_num);
	temp_count[0]++;
	label[++ltop]=label_num;
}
void while3()
{
	int y=label[ltop--];
	//printf("\ngo to L%d\n",label[ltop--]);
	//printf("\nL%d:\n",y);
	fprintf(yyout,"goto L%d\n",label[ltop--]);
	fprintf(yyout,"L%d:",y);
}
void dowhile1()
{
	label_num++;
	label[++ltop]=label_num;
	//printf("\nL%d:\n",label_num);
	fprintf(yyout,"L%d:",label_num);
}
void dowhile2()
{
 	//printf("\nifnot %s go to L%d\n",st1[top--],label[ltop--]);
	fprintf(yyout,"ifFalse %s L%d\n",st1[top--],label[ltop--]);
}
void for1()
{
	label_num++;
	label[++ltop]=label_num;
	//printf("\nL%d:\n",label_num);
	fprintf(yyout,"L%d:",label_num);
}
void for2()
{
	label_num++;
	strcpy(temp,"t");
	strcat(temp,temp_count);
	//printf("\n%s = %s\n",temp,st1[top--]);
 	//printf("\nifnot %s go to L%d\n",temp,label_num);
	fprintf(yyout,"%s = %s\n",temp,st1[top--]);
 	fprintf(yyout,"ifFalse %s goto L%d\n",temp,label_num);
	temp_count[0]++;
	label[++ltop]=label_num;
	label_num++;
	//printf("\ngo to L%d\n",label_num);
	fprintf(yyout,"goto L%d\n",label_num);
	label[++ltop]=label_num;
	label_num++;
	//printf("\nL%d:\n",label_num);
	fprintf(yyout,"L%d:",label_num);
	label[++ltop]=label_num;
}
void for3()
{
	//printf("\ngo to L%d\n",label[ltop-3]);
	//printf("\nL%d:\n",label[ltop-1]);
	fprintf(yyout,"goto L%d\n",label[ltop-3]);
	fprintf(yyout,"L%d:",label[ltop-1]);
}
void for4()
{
	//printf("\ngo to L%d\n",label[ltop]);
	//printf("\nL%d:\n",label[ltop-2]);
	fprintf(yyout,"goto L%d\n",label[ltop]);
	fprintf(yyout,"L%d:",label[ltop-2]);
	ltop-=4;
}
void push(char *a)
{
	strcpy(st1[++top],a);
}
void array1()
{
	strcpy(temp,"t");
	strcat(temp,temp_count);
	//printf("\n%s = %s\n",temp,st1[top]);
	fprintf(yyout,"%s = %s\n",temp,st1[top]);
	strcpy(st1[top],temp);
	temp_count[0]++;
	strcpy(temp,"t");
	strcat(temp,temp_count);
	//printf("%s = %s [ %s ] \n",temp,st1[top-1],st1[top]);
	fprintf(yyout,"%s = %s [ %s ] \n",temp,st1[top-1],st1[top]);
	top--;
	strcpy(st1[top],temp);
	temp_count[0]++;
}
void codegen()
{
	strcpy(temp,"t");
	strcat(temp,temp_count);
	//printf("\n%s = %s %s %s\n",temp,st1[top-2],st1[top-1],st1[top]);
	fprintf(yyout,"%s = %s %s %s\n",temp,st1[top-2],st1[top-1],st1[top]);
	top-=2;
	strcpy(st1[top],temp);
	temp_count[0]++;
}
void codegen_umin()
{
	strcpy(temp,"t");
	strcat(temp,temp_count);
	//printf("\n%s = -%s\n",temp,st1[top]);
	fprintf(yyout,"%s = -%s\n",temp,st1[top]);
	top--;
	strcpy(st1[top],temp);
	temp_count[0]++;
}
void codegen_assign()
{
	//printf("\n%s = %s\n",st1[top-2],st1[top]);
	fprintf(yyout,"%s = %s\n",st1[top-2],st1[top]);
	top-=2;
}
%}

%token<ival> INT FLOAT VOID CHAR
%token<str> ID NUM REAL
%token WHILE IF LE STRING PRINT DO ARRAY ARRAY_LIST ELSE FUNCTION  FOR GE EQ NE INC DEC AND OR PRIVATE PUBLIC PROTECTED STATIC STR SYSTEM MAIN IMPORT CLASS OUT
%left LE GE EQ NEQ AND OR '<' '>'
%right '='
%right UMINUS
%left '+' '-'
%left '*' '/'
%type<str> assignment assignment1 consttype '=' '+' '-' '*' '/' E T F
%type<ival> Type
%union {
		int ival;
		char *str;
	}
%%

start : Function start
	| program start
	| Declaration start
	|
	;

program : IMPORT program 
	| CLASS '{'	 main '}'
	;
main
	: PUBLIC STATIC VOID MAIN '(' A ')' CompoundStmt
	;
A	:	STR ID '['']'
	| 	STR '['']' ID
	|	STR '.''.''.' 
	;

Function : Type ID '('')'  CompoundStmt {
	if(strcmp($2,"main")!=0)
	{
		printf("goto F%d\n",lnum1);
	}
	if ($1!=returntype_func(ct))
	{
		printf("\nError : Type mismatch : Line %d\n",printline());
	}

	
	else
	{
		insert($2,FUNCTION);
		insert($2,$1);
		g_addr+=4;
	}
	}
	| Type ID '(' parameter_list ')' CompoundStmt  {
	if ($1!=returntype_func(ct))
	{
		printf("\nError : Type mismatch : Line %d\n",printline()); errc++;
	}

	
	else
	{
		insert($2,FUNCTION);
		insert($2,$1);
		for(j=0;j<=k;j++)
		{insertp($2,plist[j]);}
					k=-1;
	}
	}
	;

parameter_list : parameter_list ',' parameter
	               | parameter
	               ;

parameter : Type ID {plist[++k]=$1;insert($2,$1);insertscope($2,i);}
	          ;

Type : INT
	| FLOAT
	| VOID
	| CHAR
	;

CompoundStmt : '{' StmtList '}'
	;

StmtList : StmtList stmt
	|
	;

stmt : Declaration
	| if
	| ID '(' ')' ';'
	| while
	| dowhile
	| for
	| ';'
	| SYSTEM '.' OUT '.' PRINT '(' STRING ')' ';'
	| CompoundStmt
	;

dowhile : DO {dowhile1();} CompoundStmt WHILE '(' E ')' {dowhile2();} ';'
	;

for	: FOR '(' E {for1();} ';' E {for2();}';' E {for3();} ')' CompoundStmt {for4();}
	;

if : 	 IF '(' E ')' {if1();} CompoundStmt {if2();} else
	;

else : ELSE CompoundStmt {if3();}
	|
	;

while : WHILE {while1();}'(' E ')' {while2();} CompoundStmt {while3();}
	;

assignment : ID '=' consttype
	| ID '+' assignment
	| ID ',' assignment
	| consttype ',' assignment
	| ID 
	| consttype
	;

assignment1 : ID {push($1);} '=' {strcpy(st1[++top],"=");} E {codegen_assign();}
	{
		int sct=returnscope($1,stack[index1-1]);
		int type=returntype($1,sct);
		if((!(strspn($5,"0123456789")==strlen($5))) && type==258 && fl==0)
			printf("\nError : Type Mismatch : Line %d\n",printline());
		if(!lookup($1))
		{
			int currscope=stack[index1-1];
			int scope=returnscope($1,currscope);
			if((scope<=currscope && end[scope]==0) && !(scope==0))
			{
				check_scope_update($1,$5,currscope);
			}
		}
		}

	| ID ',' assignment1    {
					if(lookup($1))
						printf("\nUndeclared Variable %s : Line %d\n",$1,printline());
				}
	| consttype ',' assignment1
	| ID  {
		if(lookup($1))
			printf("\nUndeclared Variable %s : Line %d\n",$1,printline());
		}
	| consttype
	;


consttype : NUM
	| REAL
	;

Declaration : Type ID {push($2);} '=' {strcpy(st1[++top],"=");} E {codegen_assign();} ';'
	{
		if( (!(strspn($6,"0123456789")==strlen($6))) && $1==258 && (fl==0))
		{
			printf("\nError : Type Mismatch : Line %d\n",printline());
			fl=1;
		}
		if(!lookup($2))
		{
			int currscope=stack[index1-1];
			int previous_scope=returnscope($2,currscope);
			if(currscope==previous_scope)
				printf("\nError : Redeclaration of %s : Line %d\n",$2,printline());
			else
			{
				insert_dup($2,$1,currscope);
				check_scope_update($2,$6,stack[index1-1]);
				int sg=returnscope($2,stack[index1-1]);
				g_addr+=4;
			}
		}
		else
		{
			int scope=stack[index1-1];
			insert($2,$1);
			insertscope($2,scope);
			check_scope_update($2,$6,stack[index1-1]);
			g_addr+=4;
		}
	}

	| assignment1 ';'  {
				if(!lookup($1))
				{
					int currscope=stack[index1-1];
					int scope=returnscope($1,currscope);
					if(!(scope<=currscope && end[scope]==0) || scope==0)
						printf("\nError : Variable %s out of scope : Line %d\n",$1,printline());
				}
				else
					printf("\nError : Undeclared Variable %s : Line %d\n",$1,printline());
				}

		| Type ID '[' assignment ']' ';' {
			int itype;
			if(!(strspn($4,"0123456789")==strlen($4))) { itype=259; } else itype = 258;
			if(itype!=258)
			{ printf("\nError : Array index must be of type int : Line %d\n",printline());errc++;}
			if(atoi($4)<=0)
			{ printf("\nError : Array index must be of type int > 0 : Line %d\n",printline());errc++;}
			if(!lookup($2))
			{
				int currscope=stack[top-1];
				int previous_scope=returnscope($2,currscope);
				if(currscope==previous_scope)
				{printf("\nError : Redeclaration of %s : Line %d\n",$2,printline());errc++;}
				else
				{
					insert_dup($2,ARRAY,currscope);
				insert_by_scope($2,$1,currscope);	
					if (itype==258) {insert_index($2,$4);}
				}
			}
			else
			{
				int scope=stack[top-1];
				insert($2,ARRAY);
				insert($2,$1);
				insertscope($2,scope);
				if (itype==258) {insert_index($2,$4);}
			}
		}

	| ID '[' assignment1 ']' ';'
	
	| error
	;

array : ID {push($1);}'[' E ']' 
	;

E : E '+'{strcpy(st1[++top],"+");} T{codegen();}
   | E '-'{strcpy(st1[++top],"-");} T{codegen();}
   | T
   | ID {push($1);} LE {strcpy(st1[++top],"<=");} E {codegen();}
   | ID {push($1);} GE {strcpy(st1[++top],">=");} E {codegen();}
   | ID {push($1);} EQ {strcpy(st1[++top],"==");} E {codegen();}
   | ID {push($1);} NEQ {strcpy(st1[++top],"!=");} E {codegen();}
   | ID {push($1);} AND {strcpy(st1[++top],"&&");} E {codegen();}
   | ID {push($1);} OR {strcpy(st1[++top],"||");} E {codegen();}
   | ID {push($1);} '<' {strcpy(st1[++top],"<");} E {codegen();}
   | ID {push($1);} '>' {strcpy(st1[++top],">");} E {codegen();}
   | ID {push($1);} '=' {strcpy(st1[++top],"=");} E {codegen_assign();}
	| ID {push($1);} INC {strcpy(st1[++top],"++");}  {codegen_assign();}
| ID {push($1);} DEC {strcpy(st1[++top],"--");}  {codegen_assign();}
   | array {array1();}
   ;
T : T '*'{strcpy(st1[++top],"*");} F{codegen();}
   | T '/'{strcpy(st1[++top],"/");} F{codegen();}
   | F
   ;
F : '(' E ')' {$$=$2;}
   | '-'{strcpy(st1[++top],"-");} F{codegen_umin();} %prec UMINUS
   | ID {push($1);fl=1;}
   | consttype {push($1);}
   ;

%%
#include "lex.yy.c"
#include<ctype.h>


int main(int argc, char *argv[])
{
	yyin =fopen(argv[1],"r");
	yyout = fopen("output.txt","w");
	//fprintf(yyout,"start\n");
	yyparse();
	if(!yyparse())
	{
		//fprintf(yyout,"stop\n");
		printf("\nParsing done\n");
		print();
	}
	else
	{
		printf("Error\n");
	}
	fclose(yyin);
	fclose(yyout);
	return 0;
}

void yyerror(char *s)
{
	printf("\nLine %d : %s %s\n",yylineno,s,yytext);
}
int printline()
{
	return yylineno;
}
