# RNDTBL Grammar Specifications

This directory contains grammar specifications for the RNDTBL query language in multiple formats.

## Files

### ANTLR G4 Grammar
- **File**: `RNDTBL.g4`
- **Description**: Complete lexer and parser grammar for ANTLR4
- **Usage**: Generate parsers for Java, JavaScript, Python, C++, etc.
- **Compile**:
  ```bash
  antlr4 RNDTBL.g4
  javac RNDTBL*.java
  ```

### Yacc/Bison Parser Grammar
- **File**: `../yacc/rndtbl.y`
- **Description**: Bottom-up LALR parser specification
- **Usage**: Generate C parsers with Bison
- **Compile**:
  ```bash
  bison -d rndtbl.y
  gcc -c rndtbl.tab.c
  ```

### Lex/Flex Lexer Grammar
- **File**: `../lex/rndtbl.l`
- **Description**: Lexical analyzer specification
- **Usage**: Generate C lexical analyzers with Flex
- **Compile**:
  ```bash
  flex rndtbl.l
  gcc -c lex.yy.c
  ```

### Complete Parser Build
```bash
# Build complete parser with Bison and Flex
flex ../lex/rndtbl.l
bison -d ../yacc/rndtbl.y
gcc -o rndtbl-parser lex.yy.c rndtbl.tab.c -lfl
```

## Query Language Overview

The RNDTBL query language is inspired by Cypher (Neo4j) and designed for querying and manipulating graph structures.

### Basic Syntax

**Match nodes:**
```cypher
MATCH (n:Topic) RETURN n
```

**Match relationships:**
```cypher
MATCH (n)-[r:RELATES_TO]->(m) RETURN n, r, m
```

**Filter with WHERE:**
```cypher
MATCH (n:Topic) 
WHERE n.author = "user-123" 
RETURN n
```

**Create nodes:**
```cypher
CREATE (n:Topic {title: "Climate Change", content: "Discussion"})
```

**Create relationships:**
```cypher
MATCH (a:Topic), (b:Topic)
WHERE a.id = "topic-1" AND b.id = "topic-2"
CREATE (a)-[r:RELATES_TO]->(b)
```

**Variable-length paths:**
```cypher
MATCH path = (n)-[*1..3]->(m)
RETURN path
```

**Aggregation:**
```cypher
MATCH (n:Topic)
RETURN n.author, COUNT(n) as topics
ORDER BY topics DESC
```

## Language Features

### Node Patterns
- `()` - Anonymous node
- `(n)` - Named node
- `(n:Label)` - Node with label
- `(n:Label {prop: value})` - Node with properties

### Relationship Patterns
- `-[]->` - Directed relationship (right)
- `<-[]-` - Directed relationship (left)
- `-[]-` - Undirected relationship
- `-[r:TYPE]->` - Typed relationship
- `-[*1..5]->` - Variable-length path

### Expressions
- Arithmetic: `+`, `-`, `*`, `/`, `%`, `^`
- Comparison: `=`, `<>`, `<`, `<=`, `>`, `>=`
- Logical: `AND`, `OR`, `NOT`
- String: `CONTAINS`, `STARTS WITH`, `ENDS WITH`
- Collections: `IN`, `[]`

### Functions
- Aggregates: `COUNT`, `SUM`, `AVG`, `MIN`, `MAX`
- String: `SIZE`, `LENGTH`
- Graph: `NODES`, `RELATIONSHIPS`, `PATH`
- Utility: `ID`, `TYPE`, `NOW`, `TIMESTAMP`

### Clauses
- `MATCH` - Pattern matching
- `WHERE` - Filtering
- `RETURN` - Result projection
- `CREATE` - Create nodes/relationships
- `DELETE` - Remove nodes/relationships
- `SET` - Update properties
- `REMOVE` - Remove properties/labels
- `ORDER BY` - Sorting
- `LIMIT` - Result limit
- `SKIP` - Result offset

## Grammar Structure

### ANTLR4 Grammar Organization
1. **Parser Rules** (lowercase)
   - Start with `query`
   - Hierarchical rule structure
   - Left-recursive rules supported

2. **Lexer Rules** (UPPERCASE)
   - Keywords
   - Operators
   - Literals
   - Identifiers

### Yacc/Bison Grammar Organization
1. **Tokens** (`%token`)
   - Terminal symbols
   - Keywords and operators

2. **Non-terminals** (`%type`)
   - Syntax tree node types
   - Expression types

3. **Productions**
   - Grammar rules with actions
   - AST construction

### Lex/Flex Lexer Organization
1. **Definitions**
   - Character classes
   - Pattern macros

2. **Rules**
   - Token patterns
   - Actions to return tokens

3. **User Code**
   - Helper functions
   - Initialization

## Extending the Grammar

### Adding New Keywords
1. ANTLR: Add to lexer section
2. Yacc: Add `%token` declaration
3. Lex: Add pattern rule

### Adding New Operators
1. ANTLR: Add to expression rules
2. Yacc: Add precedence declaration (`%left`, `%right`)
3. Lex: Add operator pattern

### Adding New Functions
1. ANTLR: Add to `functionName` rule
2. Yacc: Add to function_call production
3. No lexer changes needed if using `IDENTIFIER`

## Testing

### Test Queries
See `../examples/queries/` for test cases:
- `basic.rql` - Simple queries
- `patterns.rql` - Complex patterns
- `aggregations.rql` - Aggregate functions
- `paths.rql` - Path queries

### Parser Testing
```bash
# Test with ANTLR
echo "MATCH (n) RETURN n" | grun RNDTBL query -tree

# Test with Bison/Flex
echo "MATCH (n) RETURN n" | ./rndtbl-parser
```

## Related Documentation

- [Z++ Specifications](../zpp/README.md)
- [Development Roadmap](../../ROADMAP.md)
- [Query Language Tutorial](../../tutorials/QUERY_LANGUAGE.md)

## References

- [ANTLR4 Documentation](https://github.com/antlr/antlr4/blob/master/doc/index.md)
- [Bison Manual](https://www.gnu.org/software/bison/manual/)
- [Flex Manual](https://github.com/westes/flex/blob/master/doc/flex.texi)
- [Cypher Query Language](https://neo4j.com/docs/cypher-manual/current/)

---

*Last Updated: 2025-10-27*
