#ifndef _GPP_VECTOR_H_
#define _GPP_VECTOR_H_

extern FILE* yyin;			
extern int yyparse();		

typedef struct{
	int* seq;
	int size;
	int capacity;
}Vector;


void begin_parse(FILE* fp){

	yyin = fp;
	yyparse();
}


FILE* open_input_file(int argc, char* argv[]){

	FILE* fp;

	if(argc == 1){
		fp = stdin;
	}

	else if(!(fp = fopen(argv[1], "r"))){
		printf("Error! File is not found.\n");	
	}

	return fp;
}


void* generate_vector(){

	Vector* v = (Vector*) malloc (sizeof(Vector));

	v->size = 0;
	v->capacity = 1;
	v->seq = (int*) malloc (sizeof(int));

	return v;
}


void increase_capacity(void* vect){

	Vector* v = vect;

	v->capacity *= 2;
	v->seq = (int*) realloc (v->seq, sizeof(int) * v->capacity);
}


void* add_input_to_vector(void* vect, int input){

	if(vect == NULL){
		vect = generate_vector();
	}

	Vector* v = vect;

	if(v->size == v->capacity){
		increase_capacity(v);
	}

	v->seq[v->size] = input;
	(v->size) += 1;

	return v;
}


void* concat_vector(void* vec1, void* vec2){

	Vector* v = generate_vector();

	if(vec1 != NULL)
	{
		Vector* v1 = vec1;
		for(int j = 0 ; j < v1->size ; ++j){
			add_input_to_vector(v, v1->seq[j]);
		}
	}

	if(vec2 != NULL)
	{
		Vector* v2 = vec2;
		for(int k = 0 ; k < v2->size ; ++k){
			add_input_to_vector(v, v2->seq[k]);
		}
	}
	return v;
}


void* append_to_vector(void* vect, int input){

	Vector* v = generate_vector();
	Vector* v_2 = vect;

	add_input_to_vector(v, input);

	if(v_2){
		for(int j = 0 ; j < v_2->size ; ++j){
			add_input_to_vector(v, v_2->seq[j]);
		}
	}
	return v;
}


void display_vector(void* vect){

	if(vect == NULL)
	{
		printf("NULL\n");
		return;
	}

	Vector* v = (Vector*)vect;

	if(v->size == 0)
	{
		printf("()\n");
		return;
	}

	printf("(");
	for(int i=0 ; i < v->size ; ++i)
	{
		printf("%d", v->seq[i]);
		if(i < (v->size - 1))
			printf(" ");
	}
	printf(")\n");

}


#endif