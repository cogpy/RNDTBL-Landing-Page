# Neocities Integration Strategy

## Overview

Neocities is a free web hosting platform that embraces the spirit of the early web - simple, creative, and community-driven. Integrating RNDTBL with Neocities allows users to easily publish their collaborative research and projects as static websites, making knowledge accessible to anyone with a web browser.

## Integration Architecture

### Model: Static Site Generation + API Gateway

```
┌─────────────────┐
│  RNDTBL Graph   │
│   Database      │
└────────┬────────┘
         │
         ▼
┌─────────────────┐      ┌──────────────┐
│  Static Site    │─────▶│  Neocities   │
│   Generator     │      │   Hosting    │
└────────┬────────┘      └──────────────┘
         │
         ▼
┌─────────────────┐
│  Generated      │
│  HTML/CSS/JS    │
└─────────────────┘
```

## Integration Approaches

### Approach 1: Export-Based Integration (Simplest)

**Workflow:**
1. User selects a topic or project in RNDTBL
2. Click "Export to Neocities" button
3. System generates static HTML/CSS/JS from graph data
4. User manually uploads to Neocities via web interface or WebDAV

**Advantages:**
- No API keys required
- Complete user control
- Works with free Neocities accounts
- No ongoing synchronization needed

**Implementation:**
```typescript
interface NeocitiesExport {
  generateStaticSite(graphData: GraphData): StaticSite;
  createIndexPage(nodes: Node[]): string;
  createGraphVisualization(nodes: Node[], edges: Edge[]): string;
  bundleAssets(): Asset[];
}
```

### Approach 2: API-Based Synchronization (Advanced)

**Requirements:**
- Neocities Supporter account ($5/month) for API access
- User provides API key

**Workflow:**
1. User authorizes RNDTBL to access their Neocities site
2. RNDTBL automatically syncs changes
3. Updates pushed on-demand or scheduled basis

**API Integration:**
```typescript
interface NeocitiesAPI {
  apiKey: string;
  siteName: string;
  
  uploadFile(path: string, content: string): Promise<void>;
  deleteFile(path: string): Promise<void>;
  listFiles(): Promise<FileList>;
}

class NeocitiesSyncManager {
  async syncGraph(graph: Graph): Promise<void> {
    const files = this.generateStaticFiles(graph);
    for (const file of files) {
      await this.api.uploadFile(file.path, file.content);
    }
  }
}
```

### Approach 3: Git-Based Integration (Hybrid)

**Workflow:**
1. RNDTBL exports to Git repository
2. GitHub Actions or CI/CD builds static site
3. Deploy to Neocities using neocities-deploy CLI tool

**Advantages:**
- Version control for all changes
- Automated deployment pipeline
- Works with existing Git workflows
- Can integrate with other platforms

**Example GitHub Action:**
```yaml
name: Deploy to Neocities
on:
  push:
    branches: [main]
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Build RNDTBL site
        run: npm run build:neocities
      - name: Deploy to Neocities
        uses: bcomnes/deploy-to-neocities@v1
        with:
          api_token: ${{ secrets.NEOCITIES_API_TOKEN }}
          site_dir: dist
```

## Static Site Generation

### File Structure

```
neocities-export/
├── index.html              # Main landing page
├── graph.html              # Interactive graph viewer
├── topics/
│   ├── topic-1.html
│   ├── topic-2.html
│   └── ...
├── projects/
│   ├── project-1.html
│   └── ...
├── assets/
│   ├── css/
│   │   ├── main.css
│   │   └── graph.css
│   ├── js/
│   │   ├── graph-viewer.js
│   │   └── navigation.js
│   └── data/
│       └── graph-data.json
└── about.html
```

### Features for Static Sites

1. **Interactive Graph Visualization**
   - Client-side D3.js or Cytoscape.js rendering
   - Graph data embedded as JSON
   - Pan, zoom, and click interactions
   - No server required

2. **Navigation**
   - Topic index with search
   - Breadcrumb navigation
   - Related nodes sidebar
   - Tag-based filtering

3. **Responsive Design**
   - Mobile-friendly layouts
   - Progressive enhancement
   - Minimal JavaScript dependencies
   - Fast load times

4. **Accessibility**
   - Semantic HTML
   - ARIA labels
   - Keyboard navigation
   - Screen reader support

### Graph Data Serialization

```javascript
// Embedded in HTML as JSON
const graphData = {
  nodes: [
    {
      id: "node-1",
      label: "Climate Change",
      type: "topic",
      description: "Discussion about climate change solutions",
      connections: ["node-2", "node-5"]
    },
    // ... more nodes
  ],
  edges: [
    {
      source: "node-1",
      target: "node-2",
      type: "relates-to"
    },
    // ... more edges
  ]
};
```

## Neocities-Specific Optimizations

### File Size Limits
- Neocities free: 1GB storage
- Individual files: Reasonable sizes (<10MB)
- Optimize images and assets
- Minify HTML/CSS/JS

### No Server-Side Processing
- All logic in client-side JavaScript
- Use static JSON data files
- Implement client-side search
- Pre-render all pages

### Community Features
- Link to other Neocities sites
- Add "Made with RNDTBL" badge
- Include Neocities follow button
- Support for comments via external services (Disqus, etc.)

## Implementation Plan

### Phase 1: Basic Export (Week 1-2)
- [ ] Create static site generator
- [ ] Implement basic HTML templates
- [ ] Export single topics as pages
- [ ] Generate downloadable ZIP file

### Phase 2: Enhanced Visualization (Week 3-4)
- [ ] Integrate graph visualization library
- [ ] Create interactive graph viewer
- [ ] Implement navigation between nodes
- [ ] Add search functionality

### Phase 3: API Integration (Week 5-6)
- [ ] Implement Neocities API client
- [ ] Create authentication flow
- [ ] Build automatic sync mechanism
- [ ] Add update scheduling

### Phase 4: Git Workflow (Week 7-8)
- [ ] Create Git export functionality
- [ ] Document GitHub Actions setup
- [ ] Build CI/CD templates
- [ ] Create deployment documentation

## User Documentation

### Quick Start Guide

1. **Export Your First Site**
   ```
   1. Open a topic in RNDTBL
   2. Click "Export" → "Neocities Format"
   3. Download the ZIP file
   4. Log into Neocities
   5. Upload files to your site
   ```

2. **Customize Your Site**
   - Edit CSS files for styling
   - Modify HTML templates
   - Add custom JavaScript
   - Include images and media

3. **Keep It Updated**
   - Re-export when content changes
   - Use API sync for automatic updates
   - Set up Git workflow for version control

### Best Practices

- Keep graph data size reasonable (<1MB JSON)
- Optimize images before upload
- Test on mobile devices
- Validate HTML/CSS
- Use semantic markup
- Include meta tags for sharing

## Example Integration Code

```typescript
// RNDTBL to Neocities Exporter
class RNDTBLNeocitiesExporter {
  async export(graph: Graph, options: ExportOptions): Promise<StaticSite> {
    const site = new StaticSite();
    
    // Generate index page
    site.addFile('index.html', this.generateIndex(graph));
    
    // Generate graph viewer
    site.addFile('graph.html', this.generateGraphViewer(graph));
    
    // Generate individual topic pages
    for (const node of graph.nodes) {
      const path = `topics/${node.id}.html`;
      site.addFile(path, this.generateNodePage(node, graph));
    }
    
    // Add assets
    site.addFile('assets/js/graph-viewer.js', this.getGraphViewerScript());
    site.addFile('assets/css/main.css', this.getMainStyles());
    site.addFile('assets/data/graph.json', JSON.stringify(graph));
    
    return site;
  }
  
  private generateIndex(graph: Graph): string {
    return `
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>${graph.name} - RNDTBL</title>
  <link rel="stylesheet" href="assets/css/main.css">
</head>
<body>
  <header>
    <h1>${graph.name}</h1>
    <nav>
      <a href="graph.html">View Graph</a>
      <a href="about.html">About</a>
    </nav>
  </header>
  
  <main>
    <section class="topics">
      ${graph.nodes.map(node => `
        <article>
          <h2><a href="topics/${node.id}.html">${node.label}</a></h2>
          <p>${node.description}</p>
        </article>
      `).join('')}
    </section>
  </main>
  
  <footer>
    <p>Generated by <a href="https://rndtbl.org">RNDTBL</a></p>
    <p>Hosted on <a href="https://neocities.org">Neocities</a></p>
  </footer>
</body>
</html>
    `;
  }
}
```

## Benefits of Neocities Integration

1. **Accessibility**: Free, easy-to-use hosting for everyone
2. **Preservation**: Static sites are durable and archivable
3. **Performance**: Fast load times, no database queries
4. **Simplicity**: No server maintenance required
5. **Community**: Tap into Neocities' creative community
6. **Ownership**: Users fully control their content
7. **Offline**: Downloaded sites work without internet

## Future Enhancements

- [ ] WebDAV support for automatic uploads
- [ ] RSS feed generation for updates
- [ ] Integration with Internet Archive
- [ ] Multi-language support
- [ ] Custom themes and templates
- [ ] Collaborative editing annotations
- [ ] Version comparison views
- [ ] Analytics and metrics dashboard

## Related Documentation

- [Deployment Architecture](./DEPLOYMENT.md)
- [Plan9 Namespace Model](./PLAN9_MODEL.md)
- [Static Site Generator Specs](./specs/zpp/STATIC_GENERATOR.zpp)

---

*Last Updated: 2025-10-27*
