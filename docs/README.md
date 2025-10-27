# RNDTBL Platform Documentation

Welcome to the comprehensive documentation for the RNDTBL (Roundtable) platform - a collaborative research and knowledge management system based on network graph visualization.

## 📚 Documentation Overview

### Core Documents

#### [Development Roadmap](./ROADMAP.md)
**The master plan for RNDTBL development**
- 5 development phases over 30 months
- Detailed feature breakdowns
- Technical architecture decisions
- Success metrics and risk management
- Timeline with deliverables

**Start here if you want to understand**: The vision, scope, and implementation plan for RNDTBL.

#### [Neocities Integration](./NEOCITIES_INTEGRATION.md)
**How RNDTBL integrates with Neocities and static hosting**
- Static site generation from graph data
- API-based synchronization
- Git-based deployment workflows
- Best practices for static exports

**Start here if you want to**: Deploy RNDTBL content to Neocities or other static hosting platforms.

#### [Plan9 Namespace Model](./PLAN9_MODEL.md)
**Distributed cognition through filesystem abstraction**
- Plan9-inspired namespace design
- Everything-is-a-file philosophy
- 9P protocol implementation
- Federation via union mounts
- Cognitive operations as file operations

**Start here if you want to**: Understand the theoretical foundation for distributed RNDTBL instances.

#### [Deployment Architecture](./DEPLOYMENT.md)
**Complete deployment guide for all scales**
- Static deployment (Neocities, GitHub Pages)
- Client-server deployment (VPS, cloud)
- Federated deployment (distributed network)
- Docker Compose configurations
- Security and monitoring

**Start here if you want to**: Deploy RNDTBL in any environment.

### Formal Specifications

#### [Z++ Specifications](./specs/zpp/)
**Mathematical specifications of RNDTBL components**

Files:
- `CORE_TYPES.zpp` - Basic types, metadata, validation
- `GRAPH.zpp` - Graph data structures and algorithms
- `SYNC.zpp` - CRDT-based synchronization
- `NAMESPACE.zpp` - Plan9 namespace model

**Use these for**: Rigorous understanding of system behavior, implementing compatible systems, formal verification.

#### [ANTLR Grammar](./specs/grammars/RNDTBL.g4)
**Complete query language grammar**
- Cypher-inspired graph query language
- Parser and lexer rules combined
- Generate parsers for any language (Java, JS, Python, C++)

**Use this for**: Building query parsers, IDE syntax highlighting, query validation.

#### [Yacc Parser](./specs/yacc/rndtbl.y)
**Bottom-up LALR parser specification**
- Bison-compatible grammar
- AST construction
- C implementation

**Use this for**: Building C-based query parsers, embedding in native applications.

#### [Lex Lexer](./specs/lex/rndtbl.l)
**Lexical analyzer specification**
- Flex-compatible tokenizer
- Handles strings, comments, keywords
- Error reporting

**Use this for**: Tokenizing RNDTBL queries in C applications.

## 🚀 Quick Start Guides

### For Users
1. Read [ROADMAP.md](./ROADMAP.md) sections:
   - "Vision & Mission"
   - "Core Principles"
   - "What Features Will RNDTBL Have?"

### For Developers
1. Read [ROADMAP.md](./ROADMAP.md) - "Technical Architecture"
2. Review [Z++ Specifications](./specs/zpp/README.md)
3. Examine [ANTLR Grammar](./specs/grammars/README.md)
4. Study [Deployment Architecture](./DEPLOYMENT.md)

### For System Architects
1. Read [ROADMAP.md](./ROADMAP.md) - Complete document
2. Study [PLAN9_MODEL.md](./PLAN9_MODEL.md)
3. Review [DEPLOYMENT.md](./DEPLOYMENT.md)
4. Examine formal specifications in [specs/zpp/](./specs/zpp/)

### For Content Creators
1. Read [NEOCITIES_INTEGRATION.md](./NEOCITIES_INTEGRATION.md)
2. Review static site generation features
3. Understand export workflows

## 🎯 Key Concepts

### Network Graph
RNDTBL represents knowledge as nodes (ideas, topics, projects) connected by edges (relationships). This creates a living map of collective understanding.

### Distributed Cognition
The Plan9 namespace model treats the entire RNDTBL system as a filesystem, making cognitive operations (reading, writing, connecting ideas) into filesystem operations (cat, echo, ln).

### Egalitarian Design
All users have equal voice. The network topology is designed to show multiple viewpoints in parallel without hierarchy.

### Static Export
Any RNDTBL graph can be exported as a static website, making knowledge accessible without requiring server infrastructure.

### Federation
Multiple RNDTBL instances can federate, creating a distributed network of knowledge with local ownership and global accessibility.

## 📖 Documentation Structure

```
docs/
├── README.md (this file)
├── ROADMAP.md (master development plan)
├── NEOCITIES_INTEGRATION.md (static hosting guide)
├── PLAN9_MODEL.md (namespace design)
├── DEPLOYMENT.md (deployment guide)
└── specs/
    ├── zpp/
    │   ├── README.md
    │   ├── CORE_TYPES.zpp
    │   ├── GRAPH.zpp
    │   ├── SYNC.zpp
    │   └── NAMESPACE.zpp
    ├── grammars/
    │   ├── README.md
    │   └── RNDTBL.g4
    ├── yacc/
    │   └── rndtbl.y
    └── lex/
        └── rndtbl.l
```

## 🔗 External Resources

### Related Technologies
- **Neo4j**: Graph database used by RNDTBL
- **Cypher**: Query language that inspired RNDTBL's query syntax
- **Plan9**: Operating system that inspired the namespace model
- **CRDT**: Conflict-free replicated data types for synchronization
- **Neocities**: Free static hosting platform

### Academic Foundations
- **Distributed Cognition** (Edwin Hutchins)
- **Network Theory** (Albert-László Barabási)
- **Graph Theory** (Leonhard Euler)
- **Collaborative Knowledge Management**

### Similar Projects
- Roam Research (commercial)
- Obsidian (commercial/free)
- Logseq (open source)
- Athens Research (open source)
- TiddlyWiki (open source)

**RNDTBL's Uniqueness**: 
- Truly egalitarian (no hierarchy)
- Network graph visualization as primary interface
- Plan9-inspired distributed architecture
- Static export to Neocities
- Open source with formal specifications

## 🛠️ Building Tools Based on These Specs

### Parser Generator
```bash
# Using ANTLR
antlr4 RNDTBL.g4
javac RNDTBL*.java

# Using Bison/Flex
flex rndtbl.l
bison -d rndtbl.y
gcc -o rndtbl-parser lex.yy.c rndtbl.tab.c
```

### Query Language Examples
```cypher
// Find all topics related to climate change
MATCH (n:Topic)-[r:RELATES_TO]->(m:Topic {title: "Climate Change"})
RETURN n, r, m

// Find shortest path between two topics
MATCH path = shortestPath((a:Topic {id: "topic-1"})-[*..10]-(b:Topic {id: "topic-2"}))
RETURN path

// Create new topic with relationships
CREATE (n:Topic {title: "Solar Panels", content: "Renewable energy solution"})
MATCH (m:Topic {title: "Climate Change"})
CREATE (n)-[r:IMPLEMENTS]->(m)
```

### Namespace Access
```bash
# Mount RNDTBL namespace
rndtbl mount /rndtbl

# Read a node
cat /rndtbl/graph/nodes/node-123/data

# Create a node
echo '{"title":"New Idea"}' > /rndtbl/graph/nodes/new

# Link two nodes
ln -s /rndtbl/graph/nodes/node-123 /rndtbl/graph/nodes/node-456/links/out/
```

## 🤝 Contributing

This documentation is a living resource. Contributions welcome:

1. **Clarifications**: Help make concepts clearer
2. **Examples**: Add practical examples
3. **Corrections**: Fix errors or outdated information
4. **Extensions**: Propose new specifications or features

### Documentation Standards
- Use Markdown for all documentation
- Include practical examples
- Keep formal specifications rigorous but readable
- Cross-reference related documents
- Update timestamps when making changes

## 📅 Version History

- **v1.0** (2025-10-27): Initial comprehensive documentation release
  - Development roadmap
  - Formal specifications (Z++)
  - Grammar specifications (ANTLR, Yacc, Lex)
  - Integration and deployment guides

## 📧 Contact & Community

- **Issues**: GitHub Issues for bugs and feature requests
- **Discussions**: GitHub Discussions for ideas and questions
- **Contributing**: See CONTRIBUTING.md in repository root

## 📄 License

Documentation: CC BY-SA 4.0
Code/Specifications: MIT License (see repository root)

---

*"Communication and collaboration can transform the world"*

**Last Updated**: 2025-10-27
**Version**: 1.0
**Maintainers**: RNDTBL Development Team
