%{
    int Oc_Cc = 0;
%}

%%

[aA][nN][dD]                    { printf("KW_AND\n"); }
[oO][rR]                        { printf("KW_OR\n"); }
[nN][oO][tT]                    { printf("KW_NOT\n"); }
[eE][qQ][uU][aA][lL]            { printf("KW_EQUAL\n"); }
[lL][eE][sS][sS]	            { printf("KW_LESS\n"); }
[nN][iI][lL]		            { printf("KW_NIL\n"); }
[lL][iI][sS][tT]	            { printf("KW_LIST\n"); }
[aA][pP][pP][eE][nN][dD]        { printf("KW_APPEND\n"); }
[cC][oO][nN][cC][aA][tT]        { printf("KW_CONCAT\n"); }
[sS][eE][tT]                    { printf("KW_SET\n"); }
[dD][eE][fF][fF][uU][nN]        { printf("KW_DEFFUN\n"); }
[fF][oO][rR]	                { printf("KW_FOR\n"); }
[iI][fF]                        { printf("KW_IF\n"); }
[eE][xX][iI][tT]                { printf("KW_EXIT\n"); }
[lL][oO][aA][dD]                { printf("KW_LOAD\n"); }
[dD][iI][sS][pP]                { printf("KW_DISP\n"); }
[tT][rR][uU][eE]                { printf("KW_TRUE\n"); }
[fF][aA][lL][sS][eE]            { printf("KW_FALSE\n"); }

[+]                             { printf("OP_PLUS\n"); }
[-]                             { printf("OP_MINUS\n"); }
[/]                             { printf("OP_DIV\n"); }
[/][/]                          { printf("OP_DIV2\n"); }
[*]                             { printf("OP_MULT\n"); }
[(]                             { printf("OP_OP\n"); }
[)]                             { printf("OP_CP\n"); }
[*][*]                          { printf("OP_DBLMULT\n"); }
["]                             {
                                  (Oc_Cc % 2 == 0) ? printf("OP_OC\n") : printf("OP_CC\n");
                                  Oc_Cc += 1;
			                    }
[,]                             { printf("OP_COMMA\n"); }

[;;](.*)                        { printf("COMMENT\n"); }
(0)|([1-9][0-9]*)               { printf("VALUE\n"); }
[a-zA-Z][a-zA-Z0-9]*            { printf("IDENTIFIER\n"); }

[ \t\r\n]                       {}

([0-9][0-9a-zA-Z]+)|.           {
                                  printf("SYNTAX_ERROR %s cannot be tokenized!\n",yytext);
                                  exit(EXIT_FAILURE);
                                }

%%

int yywrap() {}

void main(int argc, char *argv[])
{
    if(argc > 1) {
        yyin = fopen(argv[1], "r");
        yyrestart(yyin);
        while(!feof(yyin)) {
            yylex();
        }
        fclose(yyin);
    }
    yyin = stdin;
    yyrestart(yyin);
    while(1) {
        yylex();
    }
}
