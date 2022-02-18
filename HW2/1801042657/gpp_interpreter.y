%{
	#include <stdio.h>
	#include <stdlib.h>
	#include "gpp_vector.h"
	#include "gpp_table.h"
%}

%union{
	int value;
	char id[32];
	void* values;
}

%start INPUT

%token  KW_AND KW_OR KW_NOT KW_EQUAL KW_LESS KW_NIL KW_LIST
		KW_APPEND KW_CONCAT KW_SET KW_DEFFUN KW_FOR KW_IF KW_EXIT
		KW_LOAD KW_DISP KW_TRUE KW_FALSE OP_PLUS OP_MINUS OP_DIV
		OP_MULT OP_OP OP_CP OP_DBLMULT OP_OC OP_CC OP_COMMA COMMENT
%token <value> VALUE
%token <id> IDENTIFIER
%token <str> STRING

%type <value> INPUT
%type <value> EXPI
%type <value> EXPB
%type <values> EXPLISTI
%type <values> LISTVALUE
%type <values> VALUES

%%
INPUT:
	EXPI { printf("Syntax OK.\nResult: %d\n", $1); }
	|
	INPUT EXPI { printf("Syntax OK.\nResult: %d\n", $2); }
	|
	EXPLISTI { printf("Syntax OK.\nResult: "); display_vector($1); }
	|
	INPUT EXPLISTI { printf("Syntax OK.\nResult: "); display_vector($2); }
	|
	EXPB { printf("Syntax OK.\nResult: %s\n", $1 ? "TRUE" : "FALSE"); }
	|
	INPUT EXPB { printf("Syntax OK.\nResult: %s\n", $2 ? "TRUE" : "FALSE"); }
	|
	OP_OP KW_EXIT OP_CP { return(0); }
    |
    INPUT OP_OP KW_EXIT OP_CP { return(0); }
	;

EXPI:
	OP_OP OP_PLUS EXPI EXPI OP_CP {$$ = $3 + $4;}
	|
	OP_OP OP_MINUS EXPI EXPI OP_CP {$$ = $3 - $4;}
	|
	OP_OP OP_MULT EXPI EXPI OP_CP {$$ = $3 * $4;}
	|
	OP_OP OP_DIV EXPI EXPI OP_CP {$$ = $3 / $4;}
	|
	OP_OP OP_DBLMULT EXPI EXPI OP_CP {$$ = 1; for (int i = 0; i < $4; i++) $$ *= $3;}
	|
	VALUE {$$ = $1;}
	|
	IDENTIFIER { Input* input = get_Table($1); if(input == NULL) $$ = 1; else $$ = input->val; }
	|
	OP_OP KW_SET IDENTIFIER EXPI OP_CP { $$ = $4; set_Table($3, $4); }
	|
	OP_OP KW_IF EXPB EXPI OP_CP { $$ = $3 == 1 ? $4 : 0; }
	|
	OP_OP KW_IF EXPB EXPI EXPI OP_CP { $$ = $3 == 1 ? $4 : $5; }
	|
	OP_OP KW_DISP EXPI OP_CP { $$ = $3; }
	;

EXPB:
	KW_TRUE { $$ = 1; }
	|
	KW_FALSE { $$ = 0; }
	|
	OP_OP KW_AND EXPB EXPB OP_CP { $$ = $3 && $4; }
	|
	OP_OP KW_OR EXPB EXPB OP_CP { $$ = $3 || $4; }
	|
	OP_OP KW_NOT EXPB OP_CP { $$ = !$3;}
	|
	OP_OP KW_EQUAL EXPB EXPB OP_CP { if($3 == $4) $$ = 1; else $$ = 0; }
	|
	OP_OP KW_EQUAL EXPI EXPI OP_CP { if($3 == $4) $$ = 1; else $$ = 0; }
	|
	OP_OP KW_LESS EXPI EXPI OP_CP { if($3 < $4) $$ = 1; else $$ = 0;}
    |
	OP_OP KW_DISP EXPB OP_CP {$$ = $3; }
	;

EXPLISTI:
	LISTVALUE { $$ = $1; }
	|
	OP_OP KW_DISP EXPLISTI OP_CP {$$ = $3; }
	|
	OP_OP KW_CONCAT EXPLISTI EXPLISTI OP_CP { $$ = concat_vector($3, $4); }
	|
	OP_OP KW_APPEND EXPI EXPLISTI OP_CP { $$ = append_to_vector($4, $3); }
	;

LISTVALUE:
	KW_NIL { $$ = NULL; }
	|
	OP_OP KW_LIST OP_CP { $$ = NULL; }
    |
	OP_OP OP_CP { $$ = generate_vector();}
	|
	OP_OP VALUES OP_CP { $$ = $2; }
	|
	OP_OP KW_LIST VALUES OP_CP { $$ = $3; }
	;

VALUES:
	VALUE { $$ = add_input_to_vector(NULL, $1); }
	|
	VALUES VALUE { $$ = add_input_to_vector($1, $2); };

%%

void yyerror(char* error){
	printf("SYNTAX_ERROR Expression not recognized\n");
}

void main(int argc, char* argv[]){

	FILE* fp = open_input_file(argc,argv);
	generate_Table();

	if(fp)
		begin_parse(fp);

	deallocate_Table();

}
