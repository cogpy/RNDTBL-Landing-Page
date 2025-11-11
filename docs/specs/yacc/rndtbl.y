/*
 * RNDTBL Query Language Parser (Yacc/Bison)
 * 
 * Parser grammar for the RNDTBL graph query language.
 * Compile with: bison -d rndtbl.y
 * 
 * This creates a bottom-up LALR parser for RNDTBL queries.
 */

%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Forward declarations */
void yyerror(const char *s);
int yylex(void);

/* Abstract Syntax Tree node types */
typedef enum {
    NODE_QUERY,
    NODE_MATCH,
    NODE_CREATE,
    NODE_RETURN,
    NODE_WHERE,
    NODE_PATTERN,
    NODE_NODE,
    NODE_RELATIONSHIP,
    NODE_PROPERTY,
    NODE_EXPRESSION,
    NODE_LITERAL,
    NODE_IDENTIFIER
} NodeType;

/* AST node structure */
typedef struct ASTNode {
    NodeType type;
    char *value;
    struct ASTNode **children;
    int child_count;
} ASTNode;

/* Global root of AST */
ASTNode *ast_root = NULL;

/* Function prototypes */
ASTNode* create_node(NodeType type, char *value);
ASTNode* add_child(ASTNode *parent, ASTNode *child);
void free_ast(ASTNode *node);
void print_ast(ASTNode *node, int depth);

%}

/* Union for semantic values */
%union {
    char *string;
    int integer;
    double floating;
    struct ASTNode *node;
}

/* Token declarations */
%token <string> IDENTIFIER STRING
%token <integer> INTEGER
%token <floating> FLOAT

/* Keywords */
%token MATCH CREATE MERGE DELETE SET REMOVE RETURN
%token WHERE ORDER BY LIMIT SKIP AS
%token AND OR NOT IN
%token CONTAINS STARTS ENDS WITH
%token DISTINCT DETACH
%token CASE WHEN THEN ELSE END
%token TRUE_TOKEN FALSE_TOKEN NULL_TOKEN

/* Function keywords */
%token COUNT SUM AVG MIN MAX
%token SIZE LENGTH TYPE_FUNC ID_FUNC
%token NOW TIMESTAMP_FUNC
%token NODES RELATIONSHIPS PATH

/* Operators */
%token EQ NE LT LE GT GE
%token ARROW_LEFT ARROW_RIGHT

/* Non-terminals with types */
%type <node> query statement statement_list
%type <node> match_statement create_statement merge_statement delete_statement
%type <node> set_statement remove_statement return_statement
%type <node> pattern pattern_part pattern_element pattern_chain
%type <node> node_pattern relationship_pattern
%type <node> where_clause return_clause order_by_clause limit_clause skip_clause
%type <node> expression or_expr and_expr not_expr comparison_expr
%type <node> add_expr multiply_expr unary_expr primary_expr
%type <node> literal function_call property_lookup
%type <node> node_labels relationship_types properties property_list
%type <node> expression_list return_item_list return_item
%type <node> sort_item_list sort_item
%type <node> set_item_list set_item
%type <node> remove_item_list remove_item

/* Operator precedence (lowest to highest) */
%left OR
%left AND
%right NOT
%left EQ NE LT LE GT GE IN CONTAINS STARTS ENDS
%left '+' '-'
%left '*' '/' '%'
%right '^'
%right UMINUS UPLUS

/* Start symbol */
%start query

%%

/* ========================================================================== */
/* Query Structure */
/* ========================================================================== */

query
    : statement_list
        { 
            ast_root = create_node(NODE_QUERY, "query");
            ast_root = add_child(ast_root, $1);
            $$ = ast_root;
        }
    ;

statement_list
    : statement
        { $$ = $1; }
    | statement_list ';' statement
        {
            $$ = create_node(NODE_QUERY, "statements");
            $$ = add_child($$, $1);
            $$ = add_child($$, $3);
        }
    ;

statement
    : match_statement
        { $$ = $1; }
    | create_statement
        { $$ = $1; }
    | merge_statement
        { $$ = $1; }
    | delete_statement
        { $$ = $1; }
    | set_statement
        { $$ = $1; }
    | remove_statement
        { $$ = $1; }
    | return_statement
        { $$ = $1; }
    ;

/* ========================================================================== */
/* MATCH Statement */
/* ========================================================================== */

match_statement
    : MATCH pattern where_clause return_clause
        {
            $$ = create_node(NODE_MATCH, "MATCH");
            $$ = add_child($$, $2);
            if ($3) $$ = add_child($$, $3);
            if ($4) $$ = add_child($$, $4);
        }
    | MATCH pattern where_clause
        {
            $$ = create_node(NODE_MATCH, "MATCH");
            $$ = add_child($$, $2);
            if ($3) $$ = add_child($$, $3);
        }
    | MATCH pattern return_clause
        {
            $$ = create_node(NODE_MATCH, "MATCH");
            $$ = add_child($$, $2);
            if ($3) $$ = add_child($$, $3);
        }
    | MATCH pattern
        {
            $$ = create_node(NODE_MATCH, "MATCH");
            $$ = add_child($$, $2);
        }
    ;

/* ========================================================================== */
/* CREATE Statement */
/* ========================================================================== */

create_statement
    : CREATE pattern
        {
            $$ = create_node(NODE_CREATE, "CREATE");
            $$ = add_child($$, $2);
        }
    ;

/* ========================================================================== */
/* MERGE Statement */
/* ========================================================================== */

merge_statement
    : MERGE pattern
        {
            $$ = create_node(NODE_QUERY, "MERGE");
            $$ = add_child($$, $2);
        }
    ;

/* ========================================================================== */
/* DELETE Statement */
/* ========================================================================== */

delete_statement
    : DELETE expression_list
        {
            $$ = create_node(NODE_QUERY, "DELETE");
            $$ = add_child($$, $2);
        }
    | DELETE DETACH expression_list
        {
            $$ = create_node(NODE_QUERY, "DELETE DETACH");
            $$ = add_child($$, $3);
        }
    ;

/* ========================================================================== */
/* SET Statement */
/* ========================================================================== */

set_statement
    : SET set_item_list
        {
            $$ = create_node(NODE_QUERY, "SET");
            $$ = add_child($$, $2);
        }
    ;

set_item_list
    : set_item
        { $$ = $1; }
    | set_item_list ',' set_item
        {
            $$ = create_node(NODE_QUERY, "set_items");
            $$ = add_child($$, $1);
            $$ = add_child($$, $3);
        }
    ;

set_item
    : IDENTIFIER '.' IDENTIFIER '=' expression
        {
            $$ = create_node(NODE_QUERY, "set_property");
            $$ = add_child($$, create_node(NODE_IDENTIFIER, $1));
            $$ = add_child($$, create_node(NODE_IDENTIFIER, $3));
            $$ = add_child($$, $5);
        }
    ;

/* ========================================================================== */
/* REMOVE Statement */
/* ========================================================================== */

remove_statement
    : REMOVE remove_item_list
        {
            $$ = create_node(NODE_QUERY, "REMOVE");
            $$ = add_child($$, $2);
        }
    ;

remove_item_list
    : remove_item
        { $$ = $1; }
    | remove_item_list ',' remove_item
        {
            $$ = create_node(NODE_QUERY, "remove_items");
            $$ = add_child($$, $1);
            $$ = add_child($$, $3);
        }
    ;

remove_item
    : IDENTIFIER '.' IDENTIFIER
        {
            $$ = create_node(NODE_QUERY, "remove_property");
            $$ = add_child($$, create_node(NODE_IDENTIFIER, $1));
            $$ = add_child($$, create_node(NODE_IDENTIFIER, $3));
        }
    ;

/* ========================================================================== */
/* RETURN Statement */
/* ========================================================================== */

return_statement
    : RETURN return_item_list order_by_clause limit_clause skip_clause
        {
            $$ = create_node(NODE_RETURN, "RETURN");
            $$ = add_child($$, $2);
            if ($3) $$ = add_child($$, $3);
            if ($4) $$ = add_child($$, $4);
            if ($5) $$ = add_child($$, $5);
        }
    | RETURN return_item_list
        {
            $$ = create_node(NODE_RETURN, "RETURN");
            $$ = add_child($$, $2);
        }
    | RETURN DISTINCT return_item_list
        {
            $$ = create_node(NODE_RETURN, "RETURN DISTINCT");
            $$ = add_child($$, $3);
        }
    ;

return_clause
    : return_statement
        { $$ = $1; }
    ;

return_item_list
    : return_item
        { $$ = $1; }
    | return_item_list ',' return_item
        {
            $$ = create_node(NODE_QUERY, "return_items");
            $$ = add_child($$, $1);
            $$ = add_child($$, $3);
        }
    ;

return_item
    : expression
        { $$ = $1; }
    | expression AS IDENTIFIER
        {
            $$ = create_node(NODE_QUERY, "return_as");
            $$ = add_child($$, $1);
            $$ = add_child($$, create_node(NODE_IDENTIFIER, $3));
        }
    | '*'
        { $$ = create_node(NODE_QUERY, "*"); }
    ;

/* ========================================================================== */
/* Clauses */
/* ========================================================================== */

where_clause
    : /* empty */
        { $$ = NULL; }
    | WHERE expression
        {
            $$ = create_node(NODE_WHERE, "WHERE");
            $$ = add_child($$, $2);
        }
    ;

order_by_clause
    : /* empty */
        { $$ = NULL; }
    | ORDER BY sort_item_list
        {
            $$ = create_node(NODE_QUERY, "ORDER BY");
            $$ = add_child($$, $3);
        }
    ;

sort_item_list
    : sort_item
        { $$ = $1; }
    | sort_item_list ',' sort_item
        {
            $$ = create_node(NODE_QUERY, "sort_items");
            $$ = add_child($$, $1);
            $$ = add_child($$, $3);
        }
    ;

sort_item
    : expression
        { $$ = $1; }
    | expression AS
        {
            $$ = create_node(NODE_QUERY, "sort_asc");
            $$ = add_child($$, $1);
        }
    ;

limit_clause
    : /* empty */
        { $$ = NULL; }
    | LIMIT INTEGER
        {
            char buffer[32];
            sprintf(buffer, "%d", $2);
            $$ = create_node(NODE_QUERY, "LIMIT");
            $$ = add_child($$, create_node(NODE_LITERAL, buffer));
        }
    ;

skip_clause
    : /* empty */
        { $$ = NULL; }
    | SKIP INTEGER
        {
            char buffer[32];
            sprintf(buffer, "%d", $2);
            $$ = create_node(NODE_QUERY, "SKIP");
            $$ = add_child($$, create_node(NODE_LITERAL, buffer));
        }
    ;

/* ========================================================================== */
/* Patterns */
/* ========================================================================== */

pattern
    : pattern_part
        { $$ = $1; }
    | pattern ',' pattern_part
        {
            $$ = create_node(NODE_PATTERN, "pattern");
            $$ = add_child($$, $1);
            $$ = add_child($$, $3);
        }
    ;

pattern_part
    : pattern_element
        { $$ = $1; }
    | IDENTIFIER '=' pattern_element
        {
            $$ = create_node(NODE_PATTERN, "named_pattern");
            $$ = add_child($$, create_node(NODE_IDENTIFIER, $1));
            $$ = add_child($$, $3);
        }
    ;

pattern_element
    : node_pattern
        { $$ = $1; }
    | node_pattern pattern_chain
        {
            $$ = create_node(NODE_PATTERN, "chain");
            $$ = add_child($$, $1);
            $$ = add_child($$, $2);
        }
    ;

pattern_chain
    : relationship_pattern node_pattern
        {
            $$ = create_node(NODE_PATTERN, "rel_chain");
            $$ = add_child($$, $1);
            $$ = add_child($$, $2);
        }
    | pattern_chain relationship_pattern node_pattern
        {
            $$ = create_node(NODE_PATTERN, "chain");
            $$ = add_child($$, $1);
            $$ = add_child($$, $2);
            $$ = add_child($$, $3);
        }
    ;

node_pattern
    : '(' ')'
        { $$ = create_node(NODE_NODE, "node"); }
    | '(' IDENTIFIER ')'
        {
            $$ = create_node(NODE_NODE, "node");
            $$ = add_child($$, create_node(NODE_IDENTIFIER, $2));
        }
    | '(' IDENTIFIER node_labels ')'
        {
            $$ = create_node(NODE_NODE, "node");
            $$ = add_child($$, create_node(NODE_IDENTIFIER, $2));
            $$ = add_child($$, $3);
        }
    | '(' IDENTIFIER node_labels properties ')'
        {
            $$ = create_node(NODE_NODE, "node");
            $$ = add_child($$, create_node(NODE_IDENTIFIER, $2));
            $$ = add_child($$, $3);
            $$ = add_child($$, $4);
        }
    | '(' IDENTIFIER properties ')'
        {
            $$ = create_node(NODE_NODE, "node");
            $$ = add_child($$, create_node(NODE_IDENTIFIER, $2));
            $$ = add_child($$, $3);
        }
    ;

node_labels
    : ':' IDENTIFIER
        {
            $$ = create_node(NODE_QUERY, "label");
            $$ = add_child($$, create_node(NODE_IDENTIFIER, $2));
        }
    | node_labels ':' IDENTIFIER
        {
            $$ = create_node(NODE_QUERY, "labels");
            $$ = add_child($$, $1);
            $$ = add_child($$, create_node(NODE_IDENTIFIER, $3));
        }
    ;

relationship_pattern
    : '-' '[' ']' ARROW_RIGHT
        { $$ = create_node(NODE_RELATIONSHIP, "rel_right"); }
    | ARROW_LEFT '[' ']' '-'
        { $$ = create_node(NODE_RELATIONSHIP, "rel_left"); }
    | '-' '[' IDENTIFIER ']' ARROW_RIGHT
        {
            $$ = create_node(NODE_RELATIONSHIP, "rel_right");
            $$ = add_child($$, create_node(NODE_IDENTIFIER, $3));
        }
    | ARROW_LEFT '[' IDENTIFIER ']' '-'
        {
            $$ = create_node(NODE_RELATIONSHIP, "rel_left");
            $$ = add_child($$, create_node(NODE_IDENTIFIER, $3));
        }
    | '-' '[' IDENTIFIER relationship_types ']' ARROW_RIGHT
        {
            $$ = create_node(NODE_RELATIONSHIP, "rel_right");
            $$ = add_child($$, create_node(NODE_IDENTIFIER, $3));
            $$ = add_child($$, $4);
        }
    ;

relationship_types
    : ':' IDENTIFIER
        {
            $$ = create_node(NODE_QUERY, "rel_type");
            $$ = add_child($$, create_node(NODE_IDENTIFIER, $2));
        }
    | relationship_types ':' IDENTIFIER
        {
            $$ = create_node(NODE_QUERY, "rel_types");
            $$ = add_child($$, $1);
            $$ = add_child($$, create_node(NODE_IDENTIFIER, $3));
        }
    ;

properties
    : '{' '}'
        { $$ = create_node(NODE_PROPERTY, "props"); }
    | '{' property_list '}'
        {
            $$ = create_node(NODE_PROPERTY, "props");
            $$ = add_child($$, $2);
        }
    ;

property_list
    : IDENTIFIER ':' expression
        {
            $$ = create_node(NODE_PROPERTY, "prop");
            $$ = add_child($$, create_node(NODE_IDENTIFIER, $1));
            $$ = add_child($$, $3);
        }
    | property_list ',' IDENTIFIER ':' expression
        {
            $$ = create_node(NODE_PROPERTY, "props");
            $$ = add_child($$, $1);
            ASTNode *prop = create_node(NODE_PROPERTY, "prop");
            prop = add_child(prop, create_node(NODE_IDENTIFIER, $3));
            prop = add_child(prop, $5);
            $$ = add_child($$, prop);
        }
    ;

/* ========================================================================== */
/* Expressions */
/* ========================================================================== */

expression
    : or_expr
        { $$ = $1; }
    ;

or_expr
    : and_expr
        { $$ = $1; }
    | or_expr OR and_expr
        {
            $$ = create_node(NODE_EXPRESSION, "OR");
            $$ = add_child($$, $1);
            $$ = add_child($$, $3);
        }
    ;

and_expr
    : not_expr
        { $$ = $1; }
    | and_expr AND not_expr
        {
            $$ = create_node(NODE_EXPRESSION, "AND");
            $$ = add_child($$, $1);
            $$ = add_child($$, $3);
        }
    ;

not_expr
    : comparison_expr
        { $$ = $1; }
    | NOT comparison_expr
        {
            $$ = create_node(NODE_EXPRESSION, "NOT");
            $$ = add_child($$, $2);
        }
    ;

comparison_expr
    : add_expr
        { $$ = $1; }
    | add_expr EQ add_expr
        {
            $$ = create_node(NODE_EXPRESSION, "=");
            $$ = add_child($$, $1);
            $$ = add_child($$, $3);
        }
    | add_expr NE add_expr
        {
            $$ = create_node(NODE_EXPRESSION, "<>");
            $$ = add_child($$, $1);
            $$ = add_child($$, $3);
        }
    | add_expr LT add_expr
        {
            $$ = create_node(NODE_EXPRESSION, "<");
            $$ = add_child($$, $1);
            $$ = add_child($$, $3);
        }
    | add_expr LE add_expr
        {
            $$ = create_node(NODE_EXPRESSION, "<=");
            $$ = add_child($$, $1);
            $$ = add_child($$, $3);
        }
    | add_expr GT add_expr
        {
            $$ = create_node(NODE_EXPRESSION, ">");
            $$ = add_child($$, $1);
            $$ = add_child($$, $3);
        }
    | add_expr GE add_expr
        {
            $$ = create_node(NODE_EXPRESSION, ">=");
            $$ = add_child($$, $1);
            $$ = add_child($$, $3);
        }
    | add_expr IN add_expr
        {
            $$ = create_node(NODE_EXPRESSION, "IN");
            $$ = add_child($$, $1);
            $$ = add_child($$, $3);
        }
    ;

add_expr
    : multiply_expr
        { $$ = $1; }
    | add_expr '+' multiply_expr
        {
            $$ = create_node(NODE_EXPRESSION, "+");
            $$ = add_child($$, $1);
            $$ = add_child($$, $3);
        }
    | add_expr '-' multiply_expr
        {
            $$ = create_node(NODE_EXPRESSION, "-");
            $$ = add_child($$, $1);
            $$ = add_child($$, $3);
        }
    ;

multiply_expr
    : unary_expr
        { $$ = $1; }
    | multiply_expr '*' unary_expr
        {
            $$ = create_node(NODE_EXPRESSION, "*");
            $$ = add_child($$, $1);
            $$ = add_child($$, $3);
        }
    | multiply_expr '/' unary_expr
        {
            $$ = create_node(NODE_EXPRESSION, "/");
            $$ = add_child($$, $1);
            $$ = add_child($$, $3);
        }
    | multiply_expr '%' unary_expr
        {
            $$ = create_node(NODE_EXPRESSION, "%");
            $$ = add_child($$, $1);
            $$ = add_child($$, $3);
        }
    ;

unary_expr
    : primary_expr
        { $$ = $1; }
    | '+' primary_expr %prec UPLUS
        { $$ = $2; }
    | '-' primary_expr %prec UMINUS
        {
            $$ = create_node(NODE_EXPRESSION, "NEGATE");
            $$ = add_child($$, $2);
        }
    ;

primary_expr
    : literal
        { $$ = $1; }
    | IDENTIFIER
        { $$ = create_node(NODE_IDENTIFIER, $1); }
    | property_lookup
        { $$ = $1; }
    | function_call
        { $$ = $1; }
    | '(' expression ')'
        { $$ = $2; }
    ;

property_lookup
    : IDENTIFIER '.' IDENTIFIER
        {
            $$ = create_node(NODE_QUERY, "property_lookup");
            $$ = add_child($$, create_node(NODE_IDENTIFIER, $1));
            $$ = add_child($$, create_node(NODE_IDENTIFIER, $3));
        }
    ;

function_call
    : IDENTIFIER '(' ')'
        {
            $$ = create_node(NODE_QUERY, "function_call");
            $$ = add_child($$, create_node(NODE_IDENTIFIER, $1));
        }
    | IDENTIFIER '(' expression_list ')'
        {
            $$ = create_node(NODE_QUERY, "function_call");
            $$ = add_child($$, create_node(NODE_IDENTIFIER, $1));
            $$ = add_child($$, $3);
        }
    ;

expression_list
    : expression
        { $$ = $1; }
    | expression_list ',' expression
        {
            $$ = create_node(NODE_QUERY, "expr_list");
            $$ = add_child($$, $1);
            $$ = add_child($$, $3);
        }
    ;

literal
    : STRING
        { $$ = create_node(NODE_LITERAL, $1); }
    | INTEGER
        {
            char buffer[32];
            sprintf(buffer, "%d", $1);
            $$ = create_node(NODE_LITERAL, buffer);
        }
    | FLOAT
        {
            char buffer[32];
            sprintf(buffer, "%f", $1);
            $$ = create_node(NODE_LITERAL, buffer);
        }
    | TRUE_TOKEN
        { $$ = create_node(NODE_LITERAL, "true"); }
    | FALSE_TOKEN
        { $$ = create_node(NODE_LITERAL, "false"); }
    | NULL_TOKEN
        { $$ = create_node(NODE_LITERAL, "null"); }
    ;

%%

/* ========================================================================== */
/* C Code Section */
/* ========================================================================== */

void yyerror(const char *s) {
    fprintf(stderr, "Parse error: %s\n", s);
}

ASTNode* create_node(NodeType type, char *value) {
    ASTNode *node = (ASTNode*)malloc(sizeof(ASTNode));
    node->type = type;
    node->value = value ? strdup(value) : NULL;
    node->children = NULL;
    node->child_count = 0;
    return node;
}

ASTNode* add_child(ASTNode *parent, ASTNode *child) {
    if (!parent || !child) return parent;
    
    parent->children = realloc(parent->children, 
                               sizeof(ASTNode*) * (parent->child_count + 1));
    parent->children[parent->child_count] = child;
    parent->child_count++;
    return parent;
}

void free_ast(ASTNode *node) {
    if (!node) return;
    
    for (int i = 0; i < node->child_count; i++) {
        free_ast(node->children[i]);
    }
    free(node->children);
    free(node->value);
    free(node);
}

void print_ast(ASTNode *node, int depth) {
    if (!node) return;
    
    for (int i = 0; i < depth; i++) printf("  ");
    printf("%s", node->value ? node->value : "?");
    printf("\n");
    
    for (int i = 0; i < node->child_count; i++) {
        print_ast(node->children[i], depth + 1);
    }
}

int main(void) {
    printf("RNDTBL Query Language Parser\n");
    printf("Enter queries (Ctrl+D to end):\n\n");
    
    if (yyparse() == 0) {
        printf("\n=== Abstract Syntax Tree ===\n");
        print_ast(ast_root, 0);
        free_ast(ast_root);
        return 0;
    }
    return 1;
}
