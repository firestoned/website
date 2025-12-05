# Hugo + Docsy Documentation Website - Implementation Plan

> **Quick Links:** [Phase 0](phases/phase-0-foundation.md) | [Phase 1](phases/phase-1-bindy-migration.md) | [Phase 2](phases/phase-2-zonewarden.md) | [Phase 3](phases/phase-3-firestone.md) | [Phase 4](phases/phase-4-forevd.md) | [Phase 5](phases/phase-5-bindcar.md) | [Phase 6](phases/phase-6-remaining-projects.md) | [Phase 7](phases/phase-7-polish.md) | [Phase 8](phases/phase-8-deployment.md) | [Phase 9](phases/phase-9-mdbook-deprecation.md)

---

## Project Overview

Create a unified documentation website for the firestoned ecosystem using Hugo + Docsy theme, while keeping documentation with source code in each project's `docs/` directory.

**Goals:**
- Unified documentation experience across all firestoned projects
- Keep documentation with source code (each project owns its docs)
- Phased migration from existing mdBook sites
- Deploy to GitHub Pages with custom DNS (firestoned.io)
- Cloud-native standard (Hugo + Docsy, like FluxCD)

**Priority Order:** bindy → zonewarden → firestone → forevd → other projects

**Timeline:** 11 weeks (Phases 0-9)

---

## Architecture Summary

### Hybrid Structure

```
firestoned/ (monorepo)
├── website/                    # Main Hugo site (landing page, shared content)
│   ├── config/                 # Hugo configuration
│   ├── content/                # Shared content
│   ├── layouts/                # Custom shortcodes
│   └── Makefile                # Build orchestration
│
├── bindy/docs/hugo/            # bindy content (mounted to website)
├── bindcar/docs/hugo/          # bindcar content (mounted)
├── zonewarden/docs/hugo/       # zonewarden content (mounted)
├── firestone/docs/hugo/        # firestone content (mounted)
└── forevd/docs/hugo/           # forevd content (mounted)
```

### How It Works

**Hugo Content Mounts** pull documentation from each project without duplication:

```toml
# website/config/_default/module.toml
[[mounts]]
  source = "../bindy/docs/hugo"
  target = "content/docs/bindy"
```

**Result:**
- Each project keeps docs in `PROJECT/docs/hugo/`
- Hugo combines all into single site at firestoned.io
- No content duplication
- Projects maintain ownership

---

## Implementation Phases

### **[Phase 0: Foundation](phases/phase-0-foundation.md)** (Week 1)

**Goal:** Set up Hugo infrastructure in `website/` directory

**Key Deliverables:**
- Hugo site initialized with Docsy theme
- Configuration files created
- Makefile for build automation
- Landing page
- Local development environment working

**Success Criteria:** `hugo server` runs without errors

---

### **[Phase 1: bindy Migration](phases/phase-1-bindy-migration.md)** (Weeks 2-3)

**Goal:** Migrate bindy's 94-page mdBook site to Hugo

**Key Deliverables:**
- Complete Hugo directory structure
- All 94 pages with front matter
- Content mount configured
- Auto-generated CRD documentation
- Rustdoc integration
- Mermaid diagrams converted

**Success Criteria:** All pages accessible, search works, mdBook site preserved

---

### **[Phase 2: zonewarden](phases/phase-2-zonewarden.md)** (Week 4)

**Goal:** Create zonewarden documentation from README and architecture diagrams

**Key Deliverables:**
- Hugo directory structure
- Architecture diagram in Mermaid
- Installation and configuration guides
- Usage examples
- ServiceDNSConfig CRD documentation

**Success Criteria:** Complete documentation section integrated with main site

---

### **[Phase 3: firestone](phases/phase-3-firestone.md)** (Week 5)

**Goal:** Create firestone documentation from README and examples

**Key Deliverables:**
- Installation guide
- Concepts documentation
- Quick start guide
- Schema reference
- Example walkthroughs

**Success Criteria:** Clear getting started path, examples well-documented

---

### **[Phase 4: forevd](phases/phase-4-forevd.md)** (Week 6)

**Goal:** Create forevd documentation from README and config examples

**Key Deliverables:**
- Overview and installation
- Configuration documentation (OIDC, LDAP, mTLS)
- Deployment guides (Kubernetes, Docker)
- Authorization patterns

**Success Criteria:** All auth methods documented, deployment patterns clear

---

### **[Phase 5: bindcar](phases/phase-5-bindcar.md)** (Week 7)

**Goal:** Migrate bindcar's 49-page mdBook site to Hugo

**Key Deliverables:**
- All 49 pages migrated
- OpenAPI spec with Swagger UI
- Rustdoc integration
- Swagger UI shortcode created

**Success Criteria:** Full API documentation accessible interactively

---

### **[Phase 6: Remaining Projects](phases/phase-6-remaining-projects.md)** (Week 8)

**Goal:** Complete firestone-lib and openapi-examples documentation

**Key Deliverables:**
- firestone-lib basic documentation
- Python API docs (optional)
- openapi-examples overview
- Example documentation

**Success Criteria:** All projects have documentation, cross-linking complete

---

### **[Phase 7: Cross-Project Content & Polish](phases/phase-7-polish.md)** (Week 9)

**Goal:** Add ecosystem documentation and polish entire site

**Key Deliverables:**
- System architecture overview
- Integration patterns
- Multi-project tutorials
- Custom branding (SCSS)
- Landing page enhancement
- Blog infrastructure
- SEO optimization

**Success Criteria:** Accessibility >90, Performance >90, ecosystem clear

---

### **[Phase 8: GitHub Pages Deployment](phases/phase-8-deployment.md)** (Week 10)

**Goal:** Deploy to GitHub Pages with custom DNS

**Key Deliverables:**
- GitHub Actions workflow
- DNS configuration
- HTTPS enabled
- Monitoring configured
- Project READMEs updated

**Success Criteria:** Site live at firestoned.io with HTTPS

---

### **[Phase 9: mdBook Deprecation](phases/phase-9-mdbook-deprecation.md)** (Week 11)

**Goal:** Complete migration from mdBook to Hugo

**Key Deliverables:**
- Deprecation notices added
- READMEs updated
- CI/CD updated
- Migration announced
- Cleanup complete

**Success Criteria:** Hugo site is primary documentation

---

## URL Structure

```
https://firestoned.io/                      # Landing page
https://firestoned.io/docs/                 # Documentation home
https://firestoned.io/docs/bindy/           # bindy docs
https://firestoned.io/docs/bindcar/         # bindcar docs
https://firestoned.io/docs/zonewarden/      # zonewarden docs
https://firestoned.io/docs/firestone/       # firestone docs
https://firestoned.io/docs/forevd/          # forevd docs
https://firestoned.io/api/bindy/rustdoc/    # bindy API
https://firestoned.io/api/bindcar/openapi/  # bindcar API
https://firestoned.io/blog/                 # Blog
```

---

## Key Technologies

- **Hugo** (v0.120.0+) - Static site generator
- **Docsy** - Documentation theme
- **Hugo Modules** - Theme management
- **GitHub Actions** - CI/CD
- **GitHub Pages** - Hosting
- **Mermaid** - Diagrams
- **Swagger UI** - API documentation

---

## Success Metrics

### Technical
- Build time < 60 seconds
- Page load time < 2 seconds
- Search response < 500ms
- Lighthouse score > 90
- Zero broken links

### User Experience
- Clear navigation to all projects
- Search finds relevant content
- Mobile experience excellent
- Feedback positive

---

## Getting Started

1. **Review this plan** with your team
2. **Assign owners** to each phase
3. **Start Phase 0** (Foundation)
4. **Follow phases sequentially** (each depends on previous)
5. **Test thoroughly** after each phase

---

## Phase Details

Each phase has a detailed implementation document:

- **[Phase 0: Foundation](phases/phase-0-foundation.md)** - Hugo setup
- **[Phase 1: bindy Migration](phases/phase-1-bindy-migration.md)** - 94-page migration
- **[Phase 2: zonewarden](phases/phase-2-zonewarden.md)** - Architecture docs
- **[Phase 3: firestone](phases/phase-3-firestone.md)** - API generator docs
- **[Phase 4: forevd](phases/phase-4-forevd.md)** - Auth proxy docs
- **[Phase 5: bindcar](phases/phase-5-bindcar.md)** - 49-page migration
- **[Phase 6: Remaining Projects](phases/phase-6-remaining-projects.md)** - Lib & examples
- **[Phase 7: Cross-Project Content](phases/phase-7-polish.md)** - Polish & tutorials
- **[Phase 8: Deployment](phases/phase-8-deployment.md)** - GitHub Pages
- **[Phase 9: Deprecation](phases/phase-9-mdbook-deprecation.md)** - Complete migration

---

## Questions or Issues?

- Open an issue on GitHub
- Review the [detailed phase documents](phases/)
- Check the [architecture overview](#architecture-summary)

---

**Last Updated:** 2025-12-04
**Document Version:** 2.0 (Refactored into phases)
