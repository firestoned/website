# Phase 7: Cross-Project Content & Polish (Week 9)

**Status:** Not Started
**Owner:** TBD
**Duration:** 1 week
**Depends On:** Phase 6 (Remaining Projects)

---

## Goal

Add ecosystem-level documentation, cross-project tutorials, and polish the entire site.

---

## Tasks

### 1. Ecosystem Documentation

#### 1.1 System Architecture

Create `website/content/docs/architecture.md`:

```markdown
---
title: "System Architecture"
weight: 5
---

# Firestoned Ecosystem Architecture

{{< mermaid >}}
graph TB
    subgraph "API Layer (Python)"
        FS[firestone<br/>Spec Generator]
        FV[forevd<br/>Auth Proxy]
    end

    subgraph "DNS Layer (Rust)"
        BC[bindcar<br/>REST API]
        BD[bindy<br/>K8s Operator]
        ZW[zonewarden<br/>Service Sync]
    end

    FS --> |generates| OAS[OpenAPI Specs]
    OAS --> |protects| FV

    ZW --> |calls| BD
    BD --> |uses| BC
    BC --> |controls| BIND9[BIND9]

    K8s[Kubernetes] --> BD
    K8s --> ZW

    style FS fill:#0066cc,color:#fff
    style BD fill:#ff6b35,color:#fff
{{< /mermaid >}}

## Components

### API Specification Layer
- **firestone** generates API specs from schemas
- **forevd** protects those APIs with auth

### DNS Infrastructure Layer
- **bindy** manages DNS as Kubernetes CRDs
- **bindcar** provides REST API to BIND9
- **zonewarden** auto-registers services to DNS

## Integration Patterns

### Pattern 1: API-First Development
1. Define resource with firestone
2. Generate OpenAPI spec
3. Protect with forevd
4. Deploy to Kubernetes

### Pattern 2: Kubernetes-Native DNS
1. Deploy bindy operator
2. Define DNS zones as CRDs
3. Label namespaces for zonewarden
4. Services auto-register in DNS
```

#### 1.2 Deployment Topologies

Document common deployment patterns:
- Single cluster
- Multi-cluster with service mesh
- Hybrid cloud
- On-premises

#### 1.3 When to Use What

Create decision trees for choosing components.

---

### 2. Multi-Project Tutorials

#### 2.1 Tutorial: Deploy DNS Cluster and Expose Services

```markdown
---
title: "Deploy DNS Cluster"
weight: 10
---

# Tutorial: Deploy Complete DNS Infrastructure

This tutorial walks through:
1. Deploying bindy operator
2. Creating a DNS cluster
3. Deploying a service
4. Auto-registering with zonewarden

## Prerequisites
- Kubernetes cluster
- kubectl access
- 30 minutes

## Step 1: Install bindy
... (detailed steps)

## Step 2: Create DNS Cluster
... (detailed steps)

## Step 3: Deploy zonewarden
... (detailed steps)

## Step 4: Deploy Sample Application
... (detailed steps)

## Step 5: Verify DNS Resolution
... (detailed steps)
```

#### 2.2 Tutorial: Build and Protect an API

Tutorial using firestone + forevd together.

---

### 3. Landing Page Enhancement

#### 3.1 Add Project Cards with Icons

Enhance `content/_index.md` with:
- Project logos/icons
- Key features per project
- Quick links
- Getting started CTAs

#### 3.2 Add Features Section

```markdown
{{< blocks/section >}}
<div class="col-12">
  <h2 class="text-center pb-3">Why Firestoned?</h2>
</div>

<div class="col-lg-4">
  <h3>🎯 Resource-First Design</h3>
  <p>Define your data model once, generate everything else.</p>
</div>

<div class="col-lg-4">
  <h3>☁️ Cloud-Native</h3>
  <p>Built for Kubernetes with GitOps in mind.</p>
</div>

<div class="col-lg-4">
  <h3>🔒 Security Built-In</h3>
  <p>Auth, DNSSEC, mTLS - security at every layer.</p>
</div>
{{< /blocks/section >}}
```

---

### 4. Custom Branding

#### 4.1 Create Custom SCSS

`website/assets/scss/_variables_project.scss`:

```scss
// Firestoned brand colors
$primary: #0066cc;
$secondary: #333333;
$success: #28a745;
$info: #17a2b8;
$warning: #ffc107;
$danger: #dc3545;

// Fonts
$font-family-base: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
$font-family-monospace: SFMono-Regular, Menlo, Monaco, Consolas, "Liberation Mono", "Courier New", monospace;

// Docsy overrides
$td-sidebar-tree-root-color: $primary;
$td-sidebar-link-color: #333;
```

`website/assets/scss/_styles_project.scss`:

```scss
// Custom styles
.project-card {
  border: 1px solid #e1e4e8;
  border-radius: 6px;
  padding: 20px;
  margin-bottom: 20px;
  transition: box-shadow 0.3s;

  &:hover {
    box-shadow: 0 4px 12px rgba(0,0,0,0.1);
  }
}

// Code blocks
pre {
  border-radius: 6px;
  border: 1px solid #e1e4e8;
}
```

#### 4.2 Add Logo

Place logo in `website/static/images/logo.svg` and update params.toml:

```toml
[ui]
  navbar_logo = true

[ui.navbar_logo]
  url = "/images/logo.svg"
```

---

### 5. Blog Infrastructure

```bash
mkdir -p website/content/blog
```

Create first blog post announcing the documentation site.

---

### 6. Community Pages

```bash
mkdir -p website/content/community
```

Create:
- Contributing guide
- Code of conduct
- Support channels
- Roadmap

---

### 7. SEO Optimization

#### 7.1 Add Descriptions

Ensure all pages have meaningful descriptions in front matter.

#### 7.2 Add OpenGraph Tags

Update `params.toml`:

```toml
[social]
  twitter = "firestoned"

[params.opengraph]
  images = ["/images/og-image.png"]
```

#### 7.3 Create Sitemap

Hugo generates automatically, verify `enableRobotsTXT = true` in config.

---

### 8. Accessibility Audit

Run Lighthouse audit:

```bash
npm install -g lighthouse
hugo server &
lighthouse http://localhost:1313 --view
```

Fix issues:
- Image alt text
- Heading hierarchy
- Color contrast
- Keyboard navigation

---

### 9. Performance Optimization

- Minify assets (already in production config)
- Optimize images
- Enable caching headers
- Test page load times

---

## Success Criteria

- [ ] Ecosystem architecture documented
- [ ] Multi-project tutorials complete
- [ ] Landing page polished and branded
- [ ] Blog infrastructure ready
- [ ] Community pages created
- [ ] SEO optimized
- [ ] Accessibility audit passes (>90 score)
- [ ] Performance audit passes (>90 score)

---

## Next Phase

**[Phase 8: GitHub Pages Deployment →](phase-8-deployment.md)**
