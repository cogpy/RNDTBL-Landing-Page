# RNDTBL Landing Page

Landing page for the RNDTBL (Roundtable) platform - a collaborative research tool that visualizes dialogue and knowledge as an interactive network graph.

## About RNDTBL

RNDTBL is designed to assist groups in performing in-depth collaborative research aimed at resolving world problems through easy-to-understand, step-by-step DIY ecological engineering projects.

### Key Features
- **Network Graph Visualization**: Ideas displayed as interconnected nodes
- **Equal Voice Architecture**: All participants have equal standing
- **Decentralized Accountability**: Transparent contributions without traditional moderation
- **Collaborative Research Tools**: Built-in features for group research
- **DIY Project Creation**: Tools for ecological engineering projects

## 📚 Documentation

Comprehensive documentation is available in the [`docs/`](./docs/) directory:

- **[Development Roadmap](./docs/ROADMAP.md)** - Complete 30-month development plan
- **[Neocities Integration](./docs/NEOCITIES_INTEGRATION.md)** - Deploy to static hosting
- **[Plan9 Namespace Model](./docs/PLAN9_MODEL.md)** - Distributed cognition architecture
- **[Deployment Guide](./docs/DEPLOYMENT.md)** - Multi-tier deployment strategies
- **[Formal Specifications](./docs/specs/zpp/)** - Z++ mathematical specifications
- **[Query Language Grammar](./docs/specs/grammars/)** - ANTLR, Yacc, and Lex grammars

## Getting Started

### Run the Landing Page

1. Install dependencies:
   ```bash
   npm install
   ```

2. Start development server:
   ```bash
   npm run dev
   ```

3. Build for production:
   ```bash
   npm run build
   ```

### Explore the Documentation

```bash
# Read the documentation
cd docs
cat README.md

# View formal specifications
cd specs/zpp
cat GRAPH.zpp

# Check grammar specifications
cd ../grammars
cat RNDTBL.g4
```

## Technology Stack

- **Frontend**: React, TypeScript, Tailwind CSS
- **Build Tool**: Vite
- **Icons**: Lucide React
- **Routing**: React Router

## Project Structure

```
.
├── src/                    # React application source
│   ├── App.tsx            # Main component
│   ├── AppRouter.tsx      # Routing configuration
│   └── index.tsx          # Entry point
├── docs/                   # Comprehensive documentation
│   ├── ROADMAP.md         # Development roadmap
│   ├── NEOCITIES_INTEGRATION.md
│   ├── PLAN9_MODEL.md
│   ├── DEPLOYMENT.md
│   └── specs/             # Formal specifications
│       ├── zpp/           # Z++ specifications
│       ├── grammars/      # ANTLR grammar
│       ├── yacc/          # Yacc parser
│       └── lex/           # Lex lexer
├── index.html
├── package.json
└── vite.config.ts
```

## Contributing

We welcome contributions! Areas where you can help:

- **Documentation**: Improve clarity, add examples
- **Specifications**: Review formal specs, suggest improvements
- **Design**: Enhance UI/UX of the landing page
- **Features**: Propose new features for the platform

## Philosophy

> "Communication and collaboration can transform the world"

RNDTBL embodies the belief that technology should serve Nature, not control it. The platform is designed to facilitate:

- **Equal participation** in problem-solving
- **Transparent accountability** without hierarchy
- **Constructive dialogue** across diverse viewpoints
- **Practical solutions** to ecological challenges

## License

MIT License - See LICENSE file for details

## Links

- **Landing Page**: This repository
- **Platform Development**: See [ROADMAP.md](./docs/ROADMAP.md)
- **Neocities Site**: [letslearntogether.neocities.org/RNDTBL](https://letslearntogether.neocities.org/RNDTBL)

---

*This landing page was initially generated using [Magic Patterns](https://magicpatterns.com) and enhanced with comprehensive documentation and specifications.*
