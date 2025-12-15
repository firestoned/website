# Firestoned Documentation Architecture Plan

**Status:** Proposed
**Date:** 2025-12-14
**Author:** Architecture Planning
**Decision:** Migration from Hugo to Zola with Multi-Site Subdomain Architecture

---

## Executive Summary

This document proposes migrating the Firestoned documentation ecosystem from Hugo to Zola (a Rust-based static site generator) with a **multi-site subdomain architecture**. Each project will maintain its own independent documentation site on a dedicated subdomain, unified by a lightweight main landing page with cross-site search powered by Pagefind.

**Key Decision Points:**
- ✅ Pure Rust toolchain (Zola + Pagefind)
- ✅ Independent project documentation sites
- ✅ Subdomain-based architecture
- ✅ Unified search across all sites
- ✅ Optimized for multi-repository structure

---

## Background & Context

### Current State

The Firestoned ecosystem consists of **7 separate GitHub repositories** under https://github.com/firestoned:

**Python Projects:**
- `firestone/` - API specification generator (120 markdown pages, 62% complete)
- `firestone-lib/` - Shared library
- `forevd/` - Authentication proxy

**Rust Projects:**
- `bindy/` - Kubernetes DNS operator (94 pages in mdBook)
- `bindcar/` - BIND9 REST API sidecar
- `zonewarden/` - Service-to-DNS sync controller

**Website:**
- `website/` - Planned Hugo-based unified documentation site

### Original Hugo Plan

The initial plan was to use **Hugo with content mounts**:
- One unified site at `firestoned.io`
- Each project's docs in `PROJECT/docs/hugo/`
- Hugo mounts content from each repo via `module.toml`
- Single build process combining all documentation

**Current Progress:**
- 74 of 119 firestone pages complete
- Hugo site structure established
- Auto-documentation generation working (`crddoc`, `pdoc`)
- Docsy theme configured

### Why Change?

**Primary Driver:** Project owner strongly prefers Rust over Go (Hugo is written in Go)

**Secondary Considerations:**
1. **Multi-repository reality:** Projects are in separate repos, not a monorepo
2. **Independent development:** Each project team needs documentation autonomy
3. **Build performance:** Rebuilding entire site for single-project changes is inefficient
4. **Deployment complexity:** Hugo content mounts require all repos available at build time

---

## Proposed Architecture

### Architecture Overview

```
┌─────────────────────────────────────────────────────────┐
│                   firestoned.io                         │
│              (Main Landing Site - Zola)                 │
│                                                         │
│  • Project overview and features                       │
│  • Getting started guide                               │
│  • Unified Pagefind search across all subdomains       │
│  • Links to project-specific documentation             │
└─────────────────────────────────────────────────────────┘
                           │
        ┌──────────────────┼──────────────────┐
        │                  │                  │
        ▼                  ▼                  ▼
┌──────────────┐  ┌──────────────┐  ┌──────────────┐
│    bindy     │  │  firestone   │  │   bindcar    │
│.firestoned.io│  │.firestoned.io│  │.firestoned.io│
│              │  │              │  │              │
│ Independent  │  │ Independent  │  │ Independent  │
│ Zola Site    │  │ Zola Site    │  │ Zola Site    │
│ (94 pages)   │  │ (120 pages)  │  │ (docs)       │
└──────────────┘  └──────────────┘  └──────────────┘
        │                  │                  │
        └──────────────────┴──────────────────┘
                           │
                  Pagefind indexes
                  (cross-site search)
```

### Site Structure

#### Main Site: `firestoned.io`

**Repository:** `firestoned/website`
**Purpose:** Marketing landing page and unified search

```
firestoned.io/
├── /                    # Landing page with hero section
├── /docs/               # High-level overview
│   ├── getting-started/ # Quick start guide
│   └── architecture/    # Ecosystem architecture
└── /search/             # Unified Pagefind search UI
```

**Content:**
- Project overview cards (firestone, bindy, bindcar, etc.)
- Quick start guide for the ecosystem
- Architecture diagrams
- **Pagefind multi-site search** querying all subdomains
- Links to project-specific documentation

**Build:** Lightweight Zola site (~5-10 pages)

#### Project Sites: Subdomains

Each project maintains its own **independent Zola site** in its repository:

##### `bindy.firestoned.io`
- **Repository:** `firestoned/bindy`
- **Location:** `bindy/docs/site/`
- **Content:** 94 pages (migrated from mdBook)
- **Auto-gen:** CRD API docs via `crddoc` binary
- **Features:** Full API reference, guides, examples

##### `firestone.firestoned.io`
- **Repository:** `firestoned/firestone`
- **Location:** `firestone/docs/site/`
- **Content:** 120 pages (migrated from Hugo)
- **Auto-gen:** Python API docs via `pdoc`
- **Features:** Resource schema docs, generation guides

##### `bindcar.firestoned.io`
- **Repository:** `firestoned/bindcar`
- **Location:** `bindcar/docs/site/`
- **Content:** REST API documentation
- **Auto-gen:** OpenAPI specs

##### Additional Subdomains
- `forevd.firestoned.io` - Authentication proxy docs
- `zonewarden.firestoned.io` - Service sync docs
- `firestone-lib.firestoned.io` - Library API reference (optional)

---

## Technology Stack

### Zola Static Site Generator

**Website:** https://www.getzola.org/
**GitHub:** https://github.com/getzola/zola
**Language:** Rust

**Why Zola:**

1. **Pure Rust Implementation**
   - Satisfies project owner's preference for Rust over Go
   - Single binary with zero dependencies
   - No npm/node_modules complexity

2. **Performance**
   - Average site builds in <1 second
   - Includes Sass/SCSS compilation
   - Built-in syntax highlighting
   - Minimal resource usage

3. **Feature Completeness**
   - Tera templating engine (similar to Jinja2)
   - Built-in shortcodes for custom components
   - Multi-language support
   - Automatic RSS/Atom feeds
   - Built-in table of contents generation
   - Mermaid diagram support

4. **Hugo Feature Parity**
   - Sections and taxonomies
   - YAML/TOML frontmatter
   - Custom templates and layouts
   - Asset pipeline (Sass, images)
   - Similar directory structure

5. **Maintenance**
   - Actively maintained (latest release: 2024)
   - Strong community support
   - Excellent documentation
   - Used in production by many projects

**Zola vs Hugo Comparison:**

| Feature | Hugo | Zola |
|---------|------|------|
| Language | Go | Rust ✅ |
| Build Speed | Very Fast | Very Fast |
| Single Binary | ✅ | ✅ |
| Templates | Go templates | Tera templates |
| Sass Support | ✅ | ✅ |
| Content Mounts | ✅ | ❌ (use symlinks) |
| Shortcodes | ✅ | ✅ |
| Themes | Many available | Growing ecosystem |
| Learning Curve | Medium | Medium |

### Pagefind Multi-Site Search

**Website:** https://pagefind.app/
**GitHub:** https://github.com/CloudCannon/pagefind
**Language:** Rust

**Why Pagefind:**

1. **Rust-Based** - Aligns with project technology preferences

2. **Multi-Site Search Built-in**
   - Designed specifically for searching across multiple sites/subdomains
   - Client-side search (no backend required)
   - Merges indexes from multiple sources in real-time

3. **Static & Serverless**
   - Generates search index at build time
   - No search server required
   - Works entirely in the browser

4. **Performance**
   - Low bandwidth usage (~1-2KB initial load)
   - Lazy-loads index segments on demand
   - Fast search results (<50ms typical)

5. **Developer Experience**
   - Simple CLI: `pagefind --source public`
   - Easy JavaScript integration
   - Works with any static site generator

**Multi-Site Configuration Example:**

```javascript
// On firestoned.io main site
new PagefindUI({
  element: "#search",
  mergeIndex: [
    {
      bundlePath: "https://bindy.firestoned.io/pagefind/",
      customFilters: { project: "bindy" }
    },
    {
      bundlePath: "https://firestone.firestoned.io/pagefind/",
      customFilters: { project: "firestone" }
    },
    {
      bundlePath: "https://bindcar.firestoned.io/pagefind/",
      customFilters: { project: "bindcar" }
    },
    {
      bundlePath: "https://forevd.firestoned.io/pagefind/",
      customFilters: { project: "forevd" }
    }
  ]
});
```

**User Experience:**
1. User types query in search box on `firestoned.io`
2. Pagefind queries all subdomain indexes in parallel
3. Results merge and display with project badges
4. Clicking result navigates to project subdomain

**Requirements:**
- Each subdomain must set CORS headers to allow main site access
- Each project builds Pagefind index during deployment

---

## Benefits Analysis

### 1. Pure Rust Toolchain ✅

**Current (Hugo):** Go-based toolchain
**Proposed (Zola + Pagefind):** 100% Rust

**Impact:**
- Aligns with project owner's technology preferences
- Leverages Rust's safety guarantees
- Single-language toolchain for infrastructure projects
- Easier for Rust developers to contribute to docs

### 2. Repository Independence ✅

**Current:** Content mounts require all repos at build time
**Proposed:** Each repo self-contained

**Benefits:**
- Each project team owns their documentation completely
- No cross-repository dependencies
- Easier contribution workflow (clone one repo, edit docs, PR)
- Clear ownership boundaries

**Example Workflow:**
```bash
# Developer wants to improve bindy docs
git clone https://github.com/firestoned/bindy
cd bindy/docs/site
zola serve              # Test locally
# Edit documentation
git commit && git push  # Triggers bindy docs deployment only
```

### 3. Build Performance ✅

**Current:** Rebuild entire unified site for any change
**Proposed:** Rebuild only changed project

**Performance Comparison:**

| Change | Hugo (Unified) | Zola (Multi-Site) |
|--------|----------------|-------------------|
| Update bindy docs | Build all 300+ pages | Build 94 bindy pages only |
| Update firestone docs | Build all 300+ pages | Build 120 firestone pages only |
| Update main landing | Build all 300+ pages | Build 5-10 pages only |

**CI Time Savings:**
- Hugo unified site: ~30-60 seconds full build
- Zola single project: ~5-10 seconds per project
- **Path-based triggers:** Only rebuild what changed

**CI Configuration Example:**
```yaml
# .github/workflows/deploy-bindy.yml
on:
  push:
    paths:
      - 'bindy/docs/**'  # Only trigger on bindy docs changes
```

### 4. Deployment Flexibility ✅

**Current:** Single deployment target
**Proposed:** Independent deployments per project

**Capabilities:**

| Capability | Hugo (Unified) | Zola (Multi-Site) |
|------------|----------------|-------------------|
| Deploy single project | ❌ Must deploy all | ✅ Independent |
| Rollback single project | ❌ Rollback all | ✅ Independent |
| Different hosting | ❌ One host | ✅ Per-project choice |
| Version independently | ❌ Coupled | ✅ Per-project tags |

**Example Use Cases:**
- Bindy docs on `v1.0.0`, Firestone on `v2.3.1` - no conflict
- Rollback Firestone docs without affecting Bindy
- Use different hosting providers per project if needed

### 5. Unified Search Experience ✅

**Challenge:** Separate sites could fragment search
**Solution:** Pagefind multi-site search

**User Benefits:**
- Single search box on main site finds content across all projects
- Results show which project contains the match
- Filter by project if desired
- Fast, client-side search (no backend)

**Technical Benefits:**
- No search server infrastructure needed
- No API key management (Algolia/etc.)
- Privacy-friendly (searches happen in browser)
- Works offline after initial page load

### 6. Content Organization ✅

**Current:** All content in one repo's structure
**Proposed:** Content co-located with code

**File Structure Per Project:**

```
bindy/
├── src/                  # Rust source code
├── examples/             # YAML examples
├── docs/
│   ├── site/             # Zola documentation site
│   │   ├── content/
│   │   ├── templates/
│   │   ├── config.toml
│   │   └── sass/
│   └── hugo/             # (deprecated, remove after migration)
├── Makefile
└── README.md
```

**Benefits:**
- Documentation versioned with code
- PRs include both code and doc changes
- No synchronization issues between repos
- Clear what docs apply to what code version

### 7. Auto-Generated Documentation ✅

**Compatibility:** All existing auto-generation works with Zola

**Bindy:**
```bash
# Generate CRD API docs (Rust → Markdown)
cargo run --bin crddoc > docs/site/content/reference/api.md
zola build
```

**Firestone:**
```bash
# Generate Python API docs (Python → Markdown)
pdoc firestone --output-format markdown > docs/site/content/api/reference.md
zola build
```

**Integration:**
- Same `crddoc` and `pdoc` tools work unchanged
- Output markdown files to Zola content directories
- Build process includes auto-generated docs automatically

### 8. Development Workflow ✅

**Simplified Local Development:**

```bash
# Work on bindy docs
cd bindy/docs/site
zola serve              # Live reload at localhost:1111

# Work on firestone docs (separate terminal)
cd firestone/docs/site
zola serve --port 1112  # Live reload at localhost:1112

# Work on main site
cd website
zola serve --port 1113  # Live reload at localhost:1113
```

**No complex setup:**
- No git submodules
- No content mount configuration
- No monorepo tooling
- Each site runs independently

### 9. Team Autonomy ✅

**Multi-Team Benefit:**

If different teams own different projects:

- **Bindy Team:** Full control over `bindy.firestoned.io`
  - Update docs without coordinating with other teams
  - Deploy on their schedule
  - Customize theme if desired

- **Firestone Team:** Full control over `firestone.firestoned.io`
  - Independent documentation decisions
  - Own deployment pipeline
  - Own versioning strategy

**Central Coordination:** Only on main `firestoned.io` landing page

### 10. Scalability ✅

**Future Growth:**

Adding new projects is trivial:

1. Create Zola site in new repo: `newproject/docs/site/`
2. Add subdomain: `newproject.firestoned.io`
3. Add to Pagefind config on main site
4. Deploy

**No impact on existing projects** - fully decoupled.

---

## Implementation Details

### Directory Structure

#### Website Repository (`firestoned/website`)

```
website/
├── config.toml           # Zola configuration
├── content/
│   ├── _index.md         # Landing page
│   ├── docs/
│   │   ├── _index.md     # Docs overview
│   │   └── architecture/ # Ecosystem architecture
│   └── search.md         # Unified search page
├── templates/
│   ├── index.html        # Landing page template
│   ├── base.html         # Base template
│   └── search.html       # Search page template
├── sass/
│   └── main.scss         # Styles
├── static/
│   ├── images/
│   └── hero-background.svg
└── themes/
    └── firestoned/       # Custom theme
```

#### Project Repository Example (`firestoned/bindy`)

```
bindy/
├── src/                  # Rust source
├── docs/
│   └── site/             # Zola site
│       ├── config.toml
│       ├── content/
│       │   ├── _index.md
│       │   ├── introduction/
│       │   ├── installation/
│       │   ├── guides/
│       │   ├── concepts/
│       │   ├── reference/
│       │   │   └── api.md    # Auto-generated
│       │   └── operations/
│       ├── templates/
│       │   ├── base.html
│       │   ├── section.html
│       │   └── page.html
│       ├── sass/
│       │   └── main.scss
│       └── static/
├── examples/
├── Makefile
└── README.md
```

### Build Process

#### Project Site Build (e.g., Bindy)

```makefile
# bindy/Makefile

.PHONY: docs docs-serve docs-build

docs-build:
	@echo "Generating CRD API documentation..."
	@cargo run --bin crddoc > docs/site/content/reference/api.md
	@echo "Building Zola site..."
	@cd docs/site && zola build
	@echo "Generating search index..."
	@pagefind --source docs/site/public

docs-serve:
	@cargo run --bin crddoc > docs/site/content/reference/api.md
	@cd docs/site && zola serve

docs: docs-build
```

#### Main Site Build

```makefile
# website/Makefile

.PHONY: build serve

build:
	@echo "Building main site..."
	@zola build
	@echo "Site built to public/"

serve:
	@zola serve --port 1313
```

### CI/CD Configuration

#### Project Deployment (Bindy Example)

```yaml
# .github/workflows/deploy-bindy-docs.yml
name: Deploy Bindy Documentation

on:
  push:
    branches: [main]
    paths:
      - 'docs/**'
      - 'src/crd.rs'  # Trigger on CRD changes
  workflow_dispatch:

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Setup Rust
        uses: actions-rs/toolchain@v1
        with:
          toolchain: stable

      - name: Generate CRD API docs
        run: cargo run --bin crddoc > docs/site/content/reference/api.md

      - name: Setup Zola
        uses: taiki-e/install-action@v2
        with:
          tool: zola@0.18.0

      - name: Build Zola site
        run: cd docs/site && zola build

      - name: Setup Pagefind
        uses: taiki-e/install-action@v2
        with:
          tool: pagefind@1.0.4

      - name: Generate search index
        run: pagefind --source docs/site/public

      - name: Deploy to Cloudflare Pages
        uses: cloudflare/pages-action@v1
        with:
          apiToken: ${{ secrets.CLOUDFLARE_API_TOKEN }}
          accountId: ${{ secrets.CLOUDFLARE_ACCOUNT_ID }}
          projectName: bindy-docs
          directory: docs/site/public
```

#### Main Site Deployment

```yaml
# website/.github/workflows/deploy.yml
name: Deploy Main Site

on:
  push:
    branches: [main]
  workflow_dispatch:

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Setup Zola
        uses: taiki-e/install-action@v2
        with:
          tool: zola@0.18.0

      - name: Build site
        run: zola build

      - name: Deploy to Cloudflare Pages
        uses: cloudflare/pages-action@v1
        with:
          apiToken: ${{ secrets.CLOUDFLARE_API_TOKEN }}
          accountId: ${{ secrets.CLOUDFLARE_ACCOUNT_ID }}
          projectName: firestoned-main
          directory: public
```

### DNS Configuration

**DNS Provider:** Cloudflare (recommended) or any DNS provider

```
# DNS Records (Cloudflare)

firestoned.io           CNAME  firestoned-main.pages.dev
bindy                   CNAME  bindy-docs.pages.dev
firestone               CNAME  firestone-docs.pages.dev
bindcar                 CNAME  bindcar-docs.pages.dev
forevd                  CNAME  forevd-docs.pages.dev
zonewarden              CNAME  zonewarden-docs.pages.dev
```

### CORS Configuration

**Required for Pagefind multi-site search:**

Each subdomain must allow the main site to fetch search indexes.

**Cloudflare Pages (`_headers` file in each project):**

```
# bindy/docs/site/static/_headers
/pagefind/*
  Access-Control-Allow-Origin: https://firestoned.io
  Access-Control-Allow-Methods: GET, OPTIONS
  Access-Control-Allow-Headers: Content-Type
```

**Netlify (`netlify.toml` in each project):**

```toml
# bindy/docs/site/netlify.toml
[[headers]]
  for = "/pagefind/*"
  [headers.values]
    Access-Control-Allow-Origin = "https://firestoned.io"
```

### Search Configuration

**Main Site Pagefind Integration:**

```html
<!-- website/templates/search.html -->
<!DOCTYPE html>
<html>
<head>
  <link href="/pagefind/pagefind-ui.css" rel="stylesheet">
  <script src="/pagefind/pagefind-ui.js"></script>
</head>
<body>
  <div id="search"></div>

  <script>
    window.addEventListener('DOMContentLoaded', (event) => {
      new PagefindUI({
        element: "#search",
        showImages: false,
        mergeIndex: [
          {
            bundlePath: "https://bindy.firestoned.io/pagefind/",
            customFilters: {
              project: "Bindy"
            }
          },
          {
            bundlePath: "https://firestone.firestoned.io/pagefind/",
            customFilters: {
              project: "Firestone"
            }
          },
          {
            bundlePath: "https://bindcar.firestoned.io/pagefind/",
            customFilters: {
              project: "Bindcar"
            }
          },
          {
            bundlePath: "https://forevd.firestoned.io/pagefind/",
            customFilters: {
              project: "Forevd"
            }
          }
        ]
      });
    });
  </script>
</body>
</html>
```

**Project Badge in Search Results:**

Pagefind will automatically show which project each result comes from, allowing users to filter by project.

---

## Migration Plan

### Phase 0: Proof of Concept (1 day)

**Goal:** Validate architecture with minimal example

**Tasks:**
1. Create basic Zola site for main landing page
2. Create basic Zola site for one project (bindy)
3. Implement Pagefind multi-site search
4. Test CORS configuration
5. Verify auto-generated docs integration

**Deliverables:**
- Working demo at `localhost:1313` (main site)
- Working demo at `localhost:1111` (bindy subdomain)
- Unified search finding bindy content from main site

**Success Criteria:**
- [ ] Search on main site finds bindy documentation
- [ ] Auto-generated CRD docs appear in bindy site
- [ ] Build time < 5 seconds per site
- [ ] Owner approves Rust toolchain

### Phase 1: Main Site Migration (2 days)

**Goal:** Convert Hugo landing page to Zola

**Tasks:**
1. Create Zola project structure for website repo
2. Convert landing page hero section to Tera template
3. Convert project cards section to Tera template
4. Port CSS/SCSS styling
5. Implement navigation
6. Add Pagefind UI (multi-site config ready)
7. Set up CI/CD deployment

**Deliverables:**
- `firestoned.io` live on Zola
- Pagefind search UI (empty indexes initially)
- CI/CD pipeline deploying to Cloudflare Pages

**Success Criteria:**
- [ ] Landing page matches current Hugo design
- [ ] Mobile responsive
- [ ] Deployment automated via GitHub Actions

### Phase 2: Bindy Documentation Migration (2 days)

**Goal:** Migrate 94 pages from mdBook to Zola

**Tasks:**
1. Create Zola site structure in `bindy/docs/site/`
2. Convert mdBook `SUMMARY.md` to Zola sections
3. Migrate 94 markdown pages
4. Update internal links
5. Port custom CSS theme
6. Integrate `crddoc` auto-generation
7. Add Pagefind index generation
8. Configure CORS headers
9. Set up CI/CD deployment to `bindy.firestoned.io`

**Deliverables:**
- `bindy.firestoned.io` live with all content
- Search index generated and accessible
- Auto-generated CRD API docs

**Success Criteria:**
- [ ] All 94 pages migrated
- [ ] Navigation works correctly
- [ ] Search on main site finds bindy content
- [ ] Auto-generated docs update on CRD changes

### Phase 3: Firestone Documentation Migration (2 days)

**Goal:** Migrate 120 pages from Hugo to Zola

**Tasks:**
1. Create Zola site structure in `firestone/docs/site/`
2. Migrate 120 markdown pages
3. Convert any Hugo shortcodes to Zola equivalents
4. Update frontmatter (minimal changes)
5. Integrate `pdoc` auto-generation
6. Add Pagefind index generation
7. Configure CORS headers
8. Set up CI/CD deployment to `firestone.firestoned.io`

**Deliverables:**
- `firestone.firestoned.io` live with all content
- Search index generated and accessible
- Auto-generated Python API docs

**Success Criteria:**
- [ ] All 120 pages migrated
- [ ] No broken internal links
- [ ] Search on main site finds firestone content
- [ ] Auto-generated docs work

### Phase 4: Remaining Projects (2 days)

**Goal:** Create documentation sites for bindcar, forevd, zonewarden

**Tasks:**
1. Create Zola sites for each remaining project
2. Port existing documentation (or create new)
3. Add Pagefind indexes
4. Configure CORS
5. Set up CI/CD for each
6. Add to main site Pagefind config

**Deliverables:**
- `bindcar.firestoned.io` live
- `forevd.firestoned.io` live
- `zonewarden.firestoned.io` live (architecture docs)
- All indexed by main site search

**Success Criteria:**
- [ ] All subdomains operational
- [ ] Unified search finds content across all sites

### Phase 5: Testing & Polish (1 day)

**Goal:** Comprehensive testing and refinement

**Tasks:**
1. Cross-browser testing (Chrome, Firefox, Safari, Edge)
2. Mobile responsiveness testing
3. Search accuracy testing
4. Performance testing (Lighthouse scores)
5. Link validation across all sites
6. Documentation for maintainers
7. Update README files

**Deliverables:**
- Test report
- Maintainer documentation
- Updated README files in all repos

**Success Criteria:**
- [ ] Lighthouse score > 90 for all sites
- [ ] No broken links
- [ ] Search finds relevant results
- [ ] Documentation complete

### Phase 6: Deployment & Cutover (0.5 days)

**Goal:** Go live with new architecture

**Tasks:**
1. Update DNS records
2. Verify all subdomains resolve
3. Test production search functionality
4. Monitor for issues
5. Archive old Hugo site

**Deliverables:**
- Live production sites on all domains/subdomains
- DNS propagated globally
- Hugo site archived

**Success Criteria:**
- [ ] All sites accessible at production URLs
- [ ] Search works in production
- [ ] No 404 errors
- [ ] Old Hugo site safely archived

### Total Effort Estimate

**Optimistic:** 9-10 days (72-80 hours)
**Realistic:** 10-12 days (80-96 hours)
**Conservative:** 12-15 days (96-120 hours)

**Assumptions:**
- Developer familiar with static site generators
- Time for Zola learning curve included
- No major unforeseen technical issues
- Design matches existing Hugo site (no redesign)

---

## Risk Analysis

### Technical Risks

#### Risk 1: CORS Issues with Pagefind

**Likelihood:** Medium
**Impact:** High
**Mitigation:**
- Test CORS thoroughly in Phase 0 proof of concept
- Document CORS configuration clearly
- Use Cloudflare Pages (excellent CORS support)
- Fallback: Same-origin search (less ideal UX)

#### Risk 2: Search Performance with Many Sites

**Likelihood:** Low
**Impact:** Medium
**Mitigation:**
- Pagefind is designed for this use case
- Lazy-loads indexes (doesn't fetch all upfront)
- Monitor bundle sizes during migration
- Optimize search indexes if needed

#### Risk 3: Content Migration Issues

**Likelihood:** Medium
**Impact:** Medium
**Mitigation:**
- Phase 0 validates migration process
- No Hugo shortcodes detected in firestone docs (already checked)
- mdBook → Zola well-documented process
- Automated link checking tools

#### Risk 4: Auto-Generated Docs Integration

**Likelihood:** Low
**Impact:** High
**Mitigation:**
- Auto-gen tools output markdown (format-agnostic)
- Test in Phase 0 proof of concept
- Both `crddoc` and `pdoc` tested and working

### Project Risks

#### Risk 5: Effort Underestimation

**Likelihood:** Medium
**Impact:** Medium
**Mitigation:**
- Conservative 12-15 day estimate included
- Phased approach allows early problem detection
- Phase 0 validates assumptions

#### Risk 6: Owner Rejects Rust Tooling

**Likelihood:** Low
**Impact:** High
**Mitigation:**
- Owner specifically requested Rust preference
- Proof of concept demonstrates benefits
- Clear benefits articulated in this document

#### Risk 7: Hugo Site Already 62% Complete

**Likelihood:** N/A (fact)
**Impact:** Medium
**Mitigation:**
- Firestone content migrates easily (no shortcodes)
- Hugo frontmatter compatible with Zola
- Time investment recoverable via future efficiency gains

### Operational Risks

#### Risk 8: Multiple Deployment Pipelines

**Likelihood:** Low
**Impact:** Low
**Mitigation:**
- CI/CD templates reusable across projects
- Path-based triggers prevent unnecessary builds
- Cloudflare Pages handles multi-project well

#### Risk 9: DNS/SSL Certificate Issues

**Likelihood:** Low
**Impact:** Medium
**Mitigation:**
- Use Cloudflare for DNS (excellent wildcard support)
- Automatic SSL via Cloudflare or Let's Encrypt
- Test DNS configuration in staging first

---

## Alternatives Considered

### Alternative 1: Keep Hugo (Status Quo)

**Pros:**
- ✅ Already started (62% firestone docs complete)
- ✅ Content mounts work well
- ✅ Mature ecosystem with many themes
- ✅ No migration effort

**Cons:**
- ❌ Written in Go (owner preference against)
- ❌ Unified site couples all projects
- ❌ Rebuilds entire site for single project change
- ❌ Content mount complexity with separate repos

**Decision:** Rejected due to owner's strong Rust preference

### Alternative 2: mdBook for Everything

**Pros:**
- ✅ Written in Rust
- ✅ Bindy already uses it
- ✅ Simple and fast

**Cons:**
- ❌ Book-style only (no landing pages)
- ❌ Cannot create marketing-style homepage
- ❌ Limited theming capabilities
- ❌ Not designed for multi-project sites

**Decision:** Rejected - insufficient features for main site

### Alternative 3: Single Unified Zola Site

**Architecture:** One Zola site with content from all repos

**Pros:**
- ✅ Rust-based (owner preference)
- ✅ Single search index (simpler)
- ✅ Unified navigation

**Cons:**
- ❌ Requires git submodules or content copying
- ❌ Rebuilds all documentation for any change
- ❌ Couples all projects together
- ❌ Complex CI/CD coordination

**Decision:** Rejected - multi-site approach offers better separation

### Alternative 4: Hybrid Hugo + mdBook

**Architecture:** Keep Hugo for main site, mdBook for projects

**Pros:**
- ✅ Minimal migration (already using both)
- ✅ Leverages existing work

**Cons:**
- ❌ Still uses Go (Hugo)
- ❌ Inconsistent user experience (different styles)
- ❌ Two toolchains to maintain
- ❌ mdBook cannot create main landing page

**Decision:** Rejected - doesn't solve Go preference issue

### Alternative 5: External Search Service (Algolia)

**Architecture:** Zola sites + Algolia for search

**Pros:**
- ✅ Powerful search features
- ✅ Hosted service (no infrastructure)
- ✅ Good documentation

**Cons:**
- ❌ Not Rust-based
- ❌ Costs money (paid tiers)
- ❌ Requires API key management
- ❌ Privacy concerns (external service)
- ❌ Vendor lock-in

**Decision:** Rejected - Pagefind offers same multi-site capability for free in Rust

---

## Success Metrics

### Performance Targets

| Metric | Target | Measurement |
|--------|--------|-------------|
| Main site build time | < 5 seconds | CI logs |
| Project site build time | < 10 seconds | CI logs |
| Search result latency | < 100ms | Browser DevTools |
| Lighthouse Performance | > 90 | Lighthouse CI |
| Lighthouse Accessibility | > 95 | Lighthouse CI |
| Page load time (3G) | < 3 seconds | WebPageTest |

### User Experience Targets

| Metric | Target | Measurement |
|--------|--------|-------------|
| Search accuracy | > 85% relevant results | Manual testing |
| Mobile usability | 100% responsive | Browser testing |
| Cross-browser support | Chrome, Firefox, Safari, Edge | Manual testing |
| Broken links | 0 | Automated link checker |

### Development Efficiency Targets

| Metric | Before (Hugo) | After (Zola) |
|--------|---------------|--------------|
| Full site rebuild | 30-60s all projects | 5-10s single project |
| Local dev setup | Clone all repos | Clone one repo |
| Deploy single project | Deploy all projects | Deploy one project |
| Documentation updates | Coordinate across repos | Update one repo |

---

## Conclusion & Recommendation

### Summary

The proposed **Zola + Pagefind multi-site architecture** offers:

1. ✅ **Pure Rust toolchain** satisfying owner's technology preferences
2. ✅ **Independent project sites** with clear ownership boundaries
3. ✅ **Unified search experience** via Pagefind multi-site
4. ✅ **Build performance** through path-based CI triggers
5. ✅ **Repository independence** for separate GitHub repos
6. ✅ **Deployment flexibility** with per-project control
7. ✅ **Auto-documentation support** via existing tools
8. ✅ **Scalability** for future project additions

### Recommendation

**Proceed with Zola migration using multi-site subdomain architecture.**

**Rationale:**
- Aligns with project owner's Rust preference (primary requirement)
- Better architectural fit for separate repositories
- Improved build performance and team autonomy
- Unified search via Pagefind solves discoverability
- Minimal risk with phased migration approach
- Total effort (10-15 days) justified by long-term benefits

### Next Steps

1. **Get owner approval** on this architecture document
2. **Execute Phase 0** proof of concept (1 day)
3. **Review POC** with stakeholders
4. **Proceed with migration** if approved
5. **Establish success metrics** and monitoring

---

## References

### Technology Documentation

- **Zola Official Documentation:** https://www.getzola.org/documentation/
- **Zola GitHub Repository:** https://github.com/getzola/zola
- **Pagefind Official Documentation:** https://pagefind.app/docs/
- **Pagefind Multi-Site Guide:** https://pagefind.app/docs/multisite/
- **Pagefind GitHub Repository:** https://github.com/CloudCannon/pagefind

### Comparison & Analysis

- **Rust Static Site Generators Comparison:** https://blog.logrocket.com/top-3-rust-static-site-generators-and-when-to-use-them/
- **Zola vs Hugo vs mdBook:** https://www.somethingsblog.com/2024/10/19/rust-static-site-generators-top-3-options-use-cases/
- **Static Site Search with Pagefind:** https://www.control-escape.com/web/static-site-search/
- **Sentry Global Search (Multi-Site Example):** https://github.com/getsentry/sentry-global-search

### Deployment & Hosting

- **Cloudflare Pages Documentation:** https://developers.cloudflare.com/pages/
- **Cloudflare Pages Zola Guide:** https://developers.cloudflare.com/pages/framework-guides/deploy-a-zola-site/
- **Netlify Monorepo Documentation:** https://docs.netlify.com/build/configure-builds/monorepos/
- **Vercel Monorepo to Subdomains:** https://dev.to/jdtjenkins/how-to-deploy-a-monorepo-to-different-subdomains-on-vercel-2chn

### Architecture Patterns

- **Multi-Domain Static Search:** https://blog.alightservices.com/2025/04/unifying-search-across-domains.html
- **Monorepo Multi-Site Deployment:** https://docs.digitalocean.com/products/app-platform/how-to/deploy-from-monorepo/
- **Static Site Deployment Best Practices:** https://kamsar.net/index.php/2020/08/Deploying-multiple-Netlify-sites-from-one-Git-repository/

---

## Appendix A: Hugo → Zola Migration Checklist

### Content Migration

- [ ] Convert frontmatter from `---` to `+++` (or keep YAML)
- [ ] Update date formats if needed
- [ ] Convert Hugo shortcodes to Zola shortcodes
- [ ] Update internal links (mostly compatible)
- [ ] Verify image paths
- [ ] Check for Hugo-specific template variables

### Configuration Migration

- [ ] Convert `config.toml` to Zola format
- [ ] Set `base_url` correctly
- [ ] Configure taxonomies (tags, categories)
- [ ] Set up redirects if needed
- [ ] Configure RSS/Atom feeds

### Template Migration

- [ ] Convert Go templates to Tera templates
- [ ] Update template variable syntax
- [ ] Port template functions
- [ ] Test responsive design
- [ ] Verify mobile navigation

### Asset Migration

- [ ] Port SCSS/Sass files (same syntax)
- [ ] Update asset paths
- [ ] Optimize images
- [ ] Verify font loading

### Build & Deployment

- [ ] Set up CI/CD pipeline
- [ ] Configure deployment target
- [ ] Test build process locally
- [ ] Verify environment variables
- [ ] Set up monitoring/alerts

---

## Appendix B: Zola Configuration Examples

### Main Site Config (`website/config.toml`)

```toml
base_url = "https://firestoned.io"
title = "Firestoned"
description = "API-driven DNS infrastructure management"

compile_sass = true
minify_html = true
build_search_index = false  # Using Pagefind instead

[markdown]
highlight_code = true
highlight_theme = "base16-ocean-dark"
external_links_target_blank = true
smart_punctuation = true

[extra]
github_url = "https://github.com/firestoned"
```

### Project Site Config (`bindy/docs/site/config.toml`)

```toml
base_url = "https://bindy.firestoned.io"
title = "Bindy - DNS Operator for Kubernetes"
description = "Kubernetes controller for managing BIND9 DNS infrastructure"

compile_sass = true
minify_html = true
build_search_index = false  # Using Pagefind

[markdown]
highlight_code = true
highlight_theme = "base16-ocean-dark"

[extra]
project_name = "bindy"
github_repo = "https://github.com/firestoned/bindy"
docs_version = "v1.0.0"
```

---

## Appendix C: Tera Template Examples

### Base Template (`templates/base.html`)

```html
<!DOCTYPE html>
<html lang="{% block lang %}en{% endblock %}">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>{% block title %}{{ config.title }}{% endblock %}</title>
  <meta name="description" content="{% block description %}{{ config.description }}{% endblock %}">
  <link rel="stylesheet" href="{{ get_url(path='main.css') }}">
  {% block extra_head %}{% endblock %}
</head>
<body>
  <nav>
    <a href="{{ get_url(path='/') }}">{{ config.title }}</a>
    {% block nav %}{% endblock %}
  </nav>

  <main>
    {% block content %}{% endblock %}
  </main>

  <footer>
    <p>&copy; 2025 Firestoned. Licensed under MIT.</p>
  </footer>

  {% block extra_js %}{% endblock %}
</body>
</html>
```

### Landing Page Template (`templates/index.html`)

```html
{% extends "base.html" %}

{% block content %}
<section class="hero">
  <h1>{{ section.title }}</h1>
  <p class="lead">API-driven infrastructure management for Kubernetes</p>
  <div class="cta-buttons">
    <a href="/docs/" class="btn btn-primary">Get Started</a>
    <a href="{{ config.extra.github_url }}" class="btn btn-secondary">GitHub</a>
  </div>
</section>

<section class="projects">
  <h2>Projects</h2>
  <div class="project-grid">
    <div class="project-card">
      <h3>🔥 firestone</h3>
      <p>Generate OpenAPI/AsyncAPI specs and CLI tools from JSON Schema</p>
      <a href="https://firestone.firestoned.io">Learn more →</a>
    </div>

    <div class="project-card">
      <h3>🏗️ bindy</h3>
      <p>Kubernetes operator managing BIND9 DNS through CRDs</p>
      <a href="https://bindy.firestoned.io">Learn more →</a>
    </div>

    <div class="project-card">
      <h3>🚗 bindcar</h3>
      <p>REST API sidecar for BIND9 zone management</p>
      <a href="https://bindcar.firestoned.io">Learn more →</a>
    </div>
  </div>
</section>
{% endblock %}
```

---

**Document Version:** 1.0
**Last Updated:** 2025-12-14
**Status:** Proposed - Awaiting Approval
