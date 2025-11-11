# Plan9 Namespace Model for RNDTBL: Distributed Cognition

## Introduction

Plan9 from Bell Labs introduced a revolutionary concept: representing all resources as files in a hierarchical namespace. This document explores how RNDTBL can project its graph-based collaborative knowledge system onto Plan9-inspired namespaces to enable distributed cognition.

## Core Concept: Everything is a File

In Plan9, every resource—processes, networks, devices—is exposed through a file-like interface. RNDTBL can adopt this philosophy to create a unified, distributed cognitive architecture.

## RNDTBL Namespace Structure

### Root Namespace Layout

```
/rndtbl/
├── graph/           # Graph structure as filesystem
│   ├── nodes/       # All nodes
│   ├── edges/       # All edges
│   ├── topics/      # Topic organization
│   └── queries/     # Query interface
├── users/           # User data and presence
│   ├── online/      # Currently active users
│   ├── profiles/    # User profiles
│   └── sessions/    # Active sessions
├── sync/            # Synchronization interface
│   ├── incoming/    # Incoming changes
│   ├── outgoing/    # Outgoing changes
│   └── conflicts/   # Conflict resolution
├── services/        # System services
│   ├── search/      # Search interface
│   ├── analytics/   # Analytics data
│   └── export/      # Export services
└── meta/            # System metadata
    ├── version
    ├── config
    └── stats
```

### Graph Namespace Detail

```
/rndtbl/graph/nodes/
├── <node-id>/
│   ├── data         # Node content (read/write)
│   ├── meta         # Metadata (created, modified, author)
│   ├── edges        # List of connected edges
│   ├── links/       # Directory of linked nodes
│   │   ├── in/      # Incoming connections
│   │   └── out/     # Outgoing connections
│   └── history/     # Version history
│       ├── 0
│       ├── 1
│       └── ...
```

### Example Node File

```bash
# Read node content
$ cat /rndtbl/graph/nodes/node-123/data
{
  "id": "node-123",
  "title": "Climate Change Solutions",
  "content": "Discussion of various approaches...",
  "type": "topic"
}

# Read metadata
$ cat /rndtbl/graph/nodes/node-123/meta
created: 2025-10-15T10:30:00Z
modified: 2025-10-27T14:00:00Z
author: user-456
contributors: user-456, user-789
version: 5

# List connected nodes
$ ls /rndtbl/graph/nodes/node-123/links/out/
node-124  node-125  node-130
```

## Distributed Cognition Model

### Concept: Cognitive Processes as Filesystem Operations

Distributed cognition views thinking as distributed across:
1. **Individuals**: Different users
2. **Artifacts**: The graph structure, notes, projects
3. **Environment**: The entire RNDTBL system

By modeling RNDTBL as a namespace, cognitive operations become filesystem operations.

### Cognitive Operations as File Operations

| Cognitive Action | Filesystem Operation | Example |
|-----------------|---------------------|---------|
| Read/Learn | `cat`, `read()` | `cat /rndtbl/graph/nodes/node-123/data` |
| Create Idea | `echo`, `write()` | `echo '{"title":"New Idea"}' > /rndtbl/graph/nodes/new` |
| Connect Ideas | `ln` (link) | `ln -s /rndtbl/graph/nodes/node-123 /rndtbl/graph/nodes/node-124/links/out/` |
| Search Knowledge | `grep`, `find` | `grep -r "ecology" /rndtbl/graph/nodes/` |
| Collaborate | `watch`, `inotify` | `watch -n 1 cat /rndtbl/users/online` |
| Synchronize | `rsync`, `cp` | `rsync -av /rndtbl/sync/incoming/ /rndtbl/graph/` |

## Neocities as Plan9 Namespace

### Concept: Projecting Neocities onto RNDTBL Namespace

Neocities can be viewed as a remote namespace that RNDTBL projects onto its own namespace structure.

```
/rndtbl/
├── remotes/
│   └── neocities/
│       └── <username>/
│           ├── index.html
│           ├── graph/
│           │   └── data.json
│           └── topics/
│               └── *.html
```

### Mounting Neocities Sites

```bash
# Mount a Neocities site
$ mount -t rndtbl-neocities \
  -o user=myusername,key=API_KEY \
  neocities /rndtbl/remotes/neocities/myusername

# Now you can read/write directly
$ cat /rndtbl/remotes/neocities/myusername/index.html

# Sync RNDTBL graph to Neocities
$ cp -r /rndtbl/export/static/* /rndtbl/remotes/neocities/myusername/
```

### Bidirectional Sync

```bash
# Watch for local changes and push to Neocities
$ rndtbl-sync --watch /rndtbl/graph \
  --target /rndtbl/remotes/neocities/myusername

# Pull updates from Neocities
$ rndtbl-sync --pull /rndtbl/remotes/neocities/myusername \
  --target /rndtbl/graph/imported
```

## Distributed Architecture

### Federation via Union Mounts

Multiple RNDTBL instances can be unified into a single namespace:

```bash
# Union mount multiple RNDTBL instances
$ mount -t rndtbl-union \
  /local/rndtbl \
  /remote1/rndtbl \
  /remote2/rndtbl \
  /rndtbl

# Now all three namespaces appear as one
$ ls /rndtbl/graph/nodes/
# Shows nodes from all three sources
```

### Namespace Composition

```
/rndtbl/                    # Root namespace
├── local/                  # Local instance
│   └── graph/
├── peers/                  # Federated peers
│   ├── peer-1.example.com/
│   │   └── graph/
│   └── peer-2.example.com/
│       └── graph/
└── composed/               # Union view
    └── graph/              # All graphs merged
```

## Implementation: 9P Protocol

### Using 9P for Network Access

The Plan9 File Protocol (9P) enables network-transparent file access. RNDTBL can implement a 9P server to expose its namespace over the network.

```typescript
// 9P Server for RNDTBL
class RNDTBLFileServer {
  private graph: Graph;
  
  // Handle 9P file operations
  async read(fid: number, offset: number, count: number): Promise<Buffer> {
    const file = this.fidToFile.get(fid);
    if (file.path.startsWith('/graph/nodes/')) {
      const nodeId = this.extractNodeId(file.path);
      const node = await this.graph.getNode(nodeId);
      return Buffer.from(JSON.stringify(node));
    }
    // ... handle other paths
  }
  
  async write(fid: number, offset: number, data: Buffer): Promise<number> {
    const file = this.fidToFile.get(fid);
    if (file.path.startsWith('/graph/nodes/')) {
      const nodeId = this.extractNodeId(file.path);
      const nodeData = JSON.parse(data.toString());
      await this.graph.updateNode(nodeId, nodeData);
      return data.length;
    }
    // ... handle other paths
  }
  
  // Other 9P operations: open, close, stat, walk, create, remove
}
```

### Mounting Remote RNDTBL Instances

```bash
# Mount a remote RNDTBL instance via 9P
$ 9mount 'tcp!rndtbl.example.com!564' /n/remote-rndtbl

# Access remote graph
$ ls /n/remote-rndtbl/graph/nodes/

# Create node on remote instance
$ echo '{"title":"Remote Idea"}' > /n/remote-rndtbl/graph/nodes/new
```

## Distributed Cognition Patterns

### Pattern 1: Shared Working Memory

Multiple users access the same namespace, creating a shared cognitive workspace:

```bash
# User A creates an idea
$ echo '{"title":"Solar Panels"}' > /rndtbl/graph/nodes/idea-solar

# User B reads and extends it
$ cat /rndtbl/graph/nodes/idea-solar/data
$ echo '{"title":"Installation Guide"}' > /rndtbl/graph/nodes/idea-solar-install
$ ln -s /rndtbl/graph/nodes/idea-solar-install \
       /rndtbl/graph/nodes/idea-solar/links/out/
```

### Pattern 2: Cognitive Offloading

Store complex information in the filesystem rather than remembering it:

```bash
# Store research findings
$ echo "Biodiversity increases resilience" > /rndtbl/graph/nodes/research-123/data

# Query when needed
$ grep -r "resilience" /rndtbl/graph/nodes/
```

### Pattern 3: Distributed Problem Solving

Break down problems across multiple nodes and users:

```bash
# Create problem space
$ mkdir -p /rndtbl/graph/topics/climate-change/{causes,solutions,implementation}

# Different users contribute to different aspects
$ echo "CO2 emissions" > /rndtbl/graph/topics/climate-change/causes/node-1
$ echo "Renewable energy" > /rndtbl/graph/topics/climate-change/solutions/node-1
```

### Pattern 4: Situated Cognition

Context-aware namespaces based on user location or role:

```bash
# Per-user view
$ ls /rndtbl/users/self/workspace/
# Shows user's current working nodes

# Topic-specific view
$ cd /rndtbl/topics/ecology/
$ ls
# Only shows nodes related to ecology
```

## FUSE Implementation

For practical deployment on Linux/macOS, implement RNDTBL as a FUSE filesystem:

```typescript
import { Fuse } from 'fuse-native';

class RNDTBLFilesystem {
  private fuse: any;
  private graph: Graph;
  
  mount(mountpoint: string): void {
    this.fuse = new Fuse(mountpoint, {
      readdir: this.readdir.bind(this),
      getattr: this.getattr.bind(this),
      open: this.open.bind(this),
      read: this.read.bind(this),
      write: this.write.bind(this),
      create: this.create.bind(this),
      unlink: this.unlink.bind(this),
      mkdir: this.mkdir.bind(this),
      rmdir: this.rmdir.bind(this),
    });
    
    this.fuse.mount();
  }
  
  private async readdir(path: string, cb: Function): Promise<void> {
    if (path === '/') {
      cb(0, ['graph', 'users', 'sync', 'services', 'meta']);
    } else if (path === '/graph') {
      cb(0, ['nodes', 'edges', 'topics', 'queries']);
    } else if (path === '/graph/nodes') {
      const nodes = await this.graph.getAllNodes();
      cb(0, nodes.map(n => n.id));
    }
    // ... handle other paths
  }
  
  private async read(path: string, fd: number, buf: Buffer, 
                     len: number, pos: number, cb: Function): Promise<void> {
    const match = path.match(/^\/graph\/nodes\/([^\/]+)\/data$/);
    if (match) {
      const nodeId = match[1];
      const node = await this.graph.getNode(nodeId);
      const data = JSON.stringify(node, null, 2);
      const chunk = data.slice(pos, pos + len);
      buf.write(chunk);
      cb(chunk.length);
    }
    // ... handle other paths
  }
}

// Usage
const fs = new RNDTBLFilesystem();
fs.mount('/mnt/rndtbl');
```

## Benefits for Distributed Cognition

1. **Unified Interface**: All cognitive operations use familiar filesystem commands
2. **Tool Integration**: Existing Unix tools work with RNDTBL (grep, find, awk, etc.)
3. **Network Transparency**: Remote resources appear local via 9P or FUSE
4. **Composability**: Namespaces can be combined, filtered, and transformed
5. **Scriptability**: Easy to automate workflows with shell scripts
6. **Observability**: Changes can be monitored with inotify/fsnotify
7. **Caching**: Filesystem cache improves performance
8. **Permissions**: Standard filesystem permissions provide access control

## Neocities + Plan9 Integration

### Combined Model

```
/rndtbl/
├── local/           # Local RNDTBL instance
│   └── graph/
├── peers/           # Federated RNDTBL peers
│   ├── peer-1/graph/
│   └── peer-2/graph/
├── static/          # Static site generation
│   └── neocities/
│       ├── source/      # Generated files
│       └── deployed/    # Currently deployed
└── remotes/
    └── neocities/   # Mounted Neocities sites
        ├── mysite/
        └── community/   # Other users' sites
```

### Workflow Example

```bash
# 1. Create content in RNDTBL
$ echo '{"title":"New Ecology Project"}' > /rndtbl/local/graph/nodes/eco-123/data

# 2. Generate static site
$ rndtbl-export /rndtbl/local/graph /rndtbl/static/neocities/source

# 3. Sync to Neocities
$ rsync -av /rndtbl/static/neocities/source/ /rndtbl/remotes/neocities/mysite/

# 4. Verify deployment
$ curl https://mysite.neocities.org/topics/eco-123.html
```

## Future Research Directions

1. **Cognitive Load Measurement**: Track filesystem operations to measure cognitive effort
2. **Collaborative Attention**: Visualize what files/nodes users are currently accessing
3. **Knowledge Crystallization**: Identify stable vs. rapidly changing parts of the namespace
4. **Emergence Detection**: Detect emergent patterns in graph topology via filesystem metadata
5. **Namespace Optimization**: Reorganize namespace based on access patterns
6. **Cross-Instance Learning**: ML models that learn from access patterns across instances

## Related Reading

- Plan9 from Bell Labs papers
- "Distributed Cognition" by Edwin Hutchins
- 9P Protocol specification
- FUSE documentation
- Namespace composition in distributed systems

## Implementation Roadmap

### Phase 1: Local Filesystem (Months 1-2)
- [ ] Implement FUSE filesystem for local RNDTBL
- [ ] Map graph operations to file operations
- [ ] Create query interface
- [ ] Build synchronization mechanisms

### Phase 2: Network Protocol (Months 3-4)
- [ ] Implement 9P server
- [ ] Create client mount utilities
- [ ] Test network performance
- [ ] Optimize caching

### Phase 3: Federation (Months 5-6)
- [ ] Implement union mounts
- [ ] Create peer discovery
- [ ] Build conflict resolution
- [ ] Test distributed scenarios

### Phase 4: Neocities Integration (Months 7-8)
- [ ] Mount Neocities sites
- [ ] Implement sync protocols
- [ ] Create export pipelines
- [ ] Build monitoring tools

## Conclusion

By projecting RNDTBL onto a Plan9-inspired namespace, we create a powerful model for distributed cognition. Users interact with collective knowledge using familiar filesystem operations, while the system transparently handles distribution, synchronization, and collaboration. The integration with Neocities becomes a natural extension of this model, where static sites are just another mountpoint in the global namespace.

This approach transforms collaborative problem-solving from an abstract concept into concrete, manipulable filesystem operations—making distributed cognition tangible and accessible.

---

*Last Updated: 2025-10-27*
