#ifndef _GPP_TABLE_H_
#define _GPP_TABLE_H_

#include <stdlib.h>
#include <string.h>

int yylex();
void yyerror(char* s);

typedef struct{
	int val;
	char id[32];
}Input;

typedef struct{
	int size;
	int capacity;
	Input* input;
}PreTable;

PreTable* Table;

void generate_Table(){

	Table = (PreTable*) malloc (sizeof(PreTable));
	
	(*Table).capacity = 1;
	(*Table).size = 0;

	(*Table).input = (Input*) malloc (sizeof(Input));
}

void change_Table(){

	(*Table).capacity *= 2;
	(*Table).input = (Input*) realloc ((*Table).input, sizeof(Input) * (*Table).capacity);
}

int find_If_Exist(char* identifier){

	for(int j = 0 ; j < (*Table).size ; ++j){
		if(strcmp((*Table).input[j].id, identifier) == 0){
			return j;
		}
	}
	return -1;
}

void set_Table(char* identifier, int value){

	int x;

	if((x = find_If_Exist(identifier)) != -1){
		(*Table).input[x].val = value;
		return;
	}

	if((*Table).size == (*Table).capacity){
		change_Table();
	}

	strcpy((*Table).input[(*Table).size].id, identifier);

	(*Table).input[(*Table).size].val = value;
	
	((*Table).size) += 1;
}

Input* get_Table(char* identifier){

	int x;

	if((x = find_If_Exist(identifier)) == -1){
		return NULL;
	}
	return &(*Table).input[x];
}

void deallocate_Table(){

	if(Table != NULL)
	{
		if((*Table).input != NULL){
			free((*Table).input);
		}
		free(Table);
	}
}

#endif