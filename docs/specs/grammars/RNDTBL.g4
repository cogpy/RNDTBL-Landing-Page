/*
 * RNDTBL Query Language Grammar (ANTLR4)
 * 
 * This grammar defines a query language for searching and traversing
 * the RNDTBL knowledge graph.
 * 
 * Examples:
 *   MATCH (n:Topic {title: "Climate Change"}) RETURN n
 *   MATCH (n)-[r:RELATES_TO]->(m) WHERE n.author = "user-123" RETURN n, r, m
 *   MATCH path = (n)-[*1..3]->(m) RETURN path
 *   CREATE (n:Topic {title: "New Topic", content: "Content here"})
 *   MERGE (n:Topic {id: "topic-123"}) SET n.updated = NOW()
 */

grammar RNDTBL;

// ============================================================================
// Parser Rules
// ============================================================================

// Top-level query
query
    : statement (';' statement)* ';'? EOF
    ;

statement
    : matchStatement
    | createStatement
    | mergeStatement
    | deleteStatement
    | setStatement
    | removeStatement
    | returnStatement
    ;

// MATCH statement - query nodes and relationships
matchStatement
    : MATCH pattern whereClause? returnClause?
    ;

// CREATE statement - create new nodes and relationships
createStatement
    : CREATE pattern
    ;

// MERGE statement - match or create
mergeStatement
    : MERGE pattern onCreateClause? onMatchClause?
    ;

// DELETE statement - remove nodes and relationships
deleteStatement
    : DELETE DETACH? expression (',' expression)*
    ;

// SET statement - update properties
setStatement
    : SET setItem (',' setItem)*
    ;

setItem
    : variable '.' propertyName '=' expression
    | variable '=' expression
    | variable '+=' expression
    ;

// REMOVE statement - remove properties or labels
removeStatement
    : REMOVE removeItem (',' removeItem)*
    ;

removeItem
    : variable '.' propertyName
    | variable ':' nodeLabel
    ;

// RETURN statement - specify what to return
returnStatement
    : RETURN DISTINCT? returnItem (',' returnItem)* orderByClause? limitClause? skipClause?
    ;

returnItem
    : expression (AS variable)?
    | '*'
    ;

// WHERE clause - filter results
whereClause
    : WHERE expression
    ;

// ORDER BY clause
orderByClause
    : ORDER BY sortItem (',' sortItem)*
    ;

sortItem
    : expression (ASC | DESC)?
    ;

// LIMIT clause
limitClause
    : LIMIT INTEGER
    ;

// SKIP clause
skipClause
    : SKIP INTEGER
    ;

// ON CREATE clause
onCreateClause
    : ON CREATE setStatement
    ;

// ON MATCH clause
onMatchClause
    : ON MATCH setStatement
    ;

// Pattern - describes graph patterns to match or create
pattern
    : patternPart (',' patternPart)*
    ;

patternPart
    : variable? '=' patternElement  // Named pattern
    | patternElement                 // Anonymous pattern
    ;

patternElement
    : nodePattern patternChain*
    | '(' patternElement ')'
    ;

patternChain
    : relationshipPattern nodePattern
    ;

// Node pattern: (variable:Label {prop: value})
nodePattern
    : '(' variable? nodeLabels? properties? ')'
    ;

nodeLabels
    : (':' nodeLabel)+
    ;

nodeLabel
    : IDENTIFIER
    ;

// Relationship pattern: -[variable:TYPE {props}]->
relationshipPattern
    : leftArrow? '[' variable? relationshipTypes? rangeLiteral? properties? ']' rightArrow?
    | leftArrow? '[' variable? relationshipTypes? rangeLiteral? properties? ']' rightArrow?
    ;

leftArrow
    : '<-'
    ;

rightArrow
    : '->'
    ;

relationshipTypes
    : (':' relationshipType)+
    ;

relationshipType
    : IDENTIFIER
    ;

// Range for variable-length paths: [*1..5]
rangeLiteral
    : '*' (INTEGER? '..' INTEGER?)?
    | '*' INTEGER
    ;

// Properties: {key: value, key2: value2}
properties
    : '{' propertyKeyValue (',' propertyKeyValue)* '}'
    | '{' '}'
    ;

propertyKeyValue
    : propertyName ':' expression
    ;

propertyName
    : IDENTIFIER
    ;

// Expressions
expression
    : orExpression
    ;

orExpression
    : andExpression (OR andExpression)*
    ;

andExpression
    : notExpression (AND notExpression)*
    ;

notExpression
    : NOT? comparisonExpression
    ;

comparisonExpression
    : addExpression (comparisonOperator addExpression)?
    ;

comparisonOperator
    : '=' | '<>' | '!=' | '<' | '<=' | '>' | '>='
    | IN | CONTAINS | STARTS WITH | ENDS WITH
    ;

addExpression
    : multiplyExpression (('+' | '-') multiplyExpression)*
    ;

multiplyExpression
    : powerExpression (('*' | '/' | '%') powerExpression)*
    ;

powerExpression
    : unaryExpression ('^' unaryExpression)*
    ;

unaryExpression
    : ('+' | '-')? primaryExpression
    ;

primaryExpression
    : literal
    | variable
    | functionCall
    | propertyLookup
    | listExpression
    | mapExpression
    | '(' expression ')'
    | caseExpression
    ;

// Property lookup: node.property
propertyLookup
    : primaryExpression '.' propertyName
    ;

// Function call: function(arg1, arg2)
functionCall
    : functionName '(' (expression (',' expression)*)? ')'
    ;

functionName
    : IDENTIFIER
    | COUNT | SUM | AVG | MIN | MAX
    | COLLECT | DISTINCT
    | SIZE | LENGTH | TYPE
    | ID | LABELS | KEYS | PROPERTIES
    | NOW | TIMESTAMP
    | NODES | RELATIONSHIPS | PATH
    ;

// List expression: [1, 2, 3]
listExpression
    : '[' (expression (',' expression)*)? ']'
    ;

// Map expression: {key: value}
mapExpression
    : '{' (propertyKeyValue (',' propertyKeyValue)*)? '}'
    ;

// CASE expression
caseExpression
    : CASE expression? caseAlternative+ (ELSE expression)? END
    ;

caseAlternative
    : WHEN expression THEN expression
    ;

// Variables
variable
    : IDENTIFIER
    ;

// Literals
literal
    : STRING
    | INTEGER
    | FLOAT
    | BOOLEAN
    | NULL
    ;

// ============================================================================
// Lexer Rules
// ============================================================================

// Keywords (case-insensitive)
MATCH       : M A T C H ;
CREATE      : C R E A T E ;
MERGE       : M E R G E ;
DELETE      : D E L E T E ;
DETACH      : D E T A C H ;
SET         : S E T ;
REMOVE      : R E M O V E ;
RETURN      : R E T U R N ;
WITH        : W I T H ;
WHERE       : W H E R E ;
ORDER       : O R D E R ;
BY          : B Y ;
LIMIT       : L I M I T ;
SKIP        : S K I P ;
AS          : A S ;
ASC         : A S C ;
DESC        : D E S C ;
ON          : O N ;
DISTINCT    : D I S T I N C T ;

// Logical operators
AND         : A N D ;
OR          : O R ;
NOT         : N O T ;
IN          : I N ;

// String operators
CONTAINS    : C O N T A I N S ;
STARTS      : S T A R T S ;
ENDS        : E N D S ;
WITH        : W I T H ;

// Aggregate functions
COUNT       : C O U N T ;
SUM         : S U M ;
AVG         : A V G ;
MIN         : M I N ;
MAX         : M A X ;
COLLECT     : C O L L E C T ;

// Utility functions
SIZE        : S I Z E ;
LENGTH      : L E N G T H ;
TYPE        : T Y P E ;
ID          : I D ;
LABELS      : L A B E L S ;
KEYS        : K E Y S ;
PROPERTIES  : P R O P E R T I E S ;
NOW         : N O W ;
TIMESTAMP   : T I M E S T A M P ;
NODES       : N O D E S ;
RELATIONSHIPS : R E L A T I O N S H I P S ;
PATH        : P A T H ;

// CASE
CASE        : C A S E ;
WHEN        : W H E N ;
THEN        : T H E N ;
ELSE        : E L S E ;
END         : E N D ;

// Literals
NULL        : N U L L ;
BOOLEAN     : T R U E | F A L S E ;

// Identifiers
IDENTIFIER  : [a-zA-Z_][a-zA-Z0-9_]* ;

// Numbers
INTEGER     : [0-9]+ ;
FLOAT       : [0-9]+ '.' [0-9]+ ([eE] [+-]? [0-9]+)? ;

// Strings
STRING      : '"' (~["\\\r\n] | '\\' .)* '"'
            | '\'' (~['\\\r\n] | '\\' .)* '\''
            ;

// Whitespace and comments
WS          : [ \t\r\n]+ -> skip ;
LINE_COMMENT : '//' ~[\r\n]* -> skip ;
BLOCK_COMMENT : '/*' .*? '*/' -> skip ;

// Case-insensitive fragments
fragment A : [aA] ;
fragment B : [bB] ;
fragment C : [cC] ;
fragment D : [dD] ;
fragment E : [eE] ;
fragment F : [fF] ;
fragment G : [gG] ;
fragment H : [hH] ;
fragment I : [iI] ;
fragment J : [jJ] ;
fragment K : [kK] ;
fragment L : [lL] ;
fragment M : [mM] ;
fragment N : [nN] ;
fragment O : [oO] ;
fragment P : [pP] ;
fragment Q : [qQ] ;
fragment R : [rR] ;
fragment S : [sS] ;
fragment T : [tT] ;
fragment U : [uU] ;
fragment V : [vV] ;
fragment W : [wW] ;
fragment X : [xX] ;
fragment Y : [yY] ;
fragment Z : [zZ] ;
