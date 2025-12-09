# Phase 0: Foundation (Week 1)

**Status:** Not Started
**Owner:** TBD
**Duration:** 1 week

---

## Goal

Set up Hugo infrastructure in the `website/` directory with Docsy theme and basic configuration.

---

## Prerequisites

- Hugo Extended (v0.120.0+) installed
- Go (1.21+) installed
- Node.js (18+) installed for PostCSS

---

## Tasks

### 1. Initialize Hugo Site

```bash
cd /home/brad/firestoned
hugo new site website --force  # --force because directory exists
cd website
```

**Expected Output:** Hugo creates basic directory structure

---

### 2. Initialize Hugo Modules and Add Docsy Theme

```bash
hugo mod init github.com/firestoned/firestoned
hugo mod get github.com/google/docsy@latest
```

**Expected Output:**
- `go.mod` file created
- Docsy theme downloaded

---

### 3. Create Configuration Structure

Create the following directory and files:

```bash
mkdir -p config/_default
mkdir -p config/production
```

#### 3.1 Create `config/_default/config.toml`

```toml
baseURL = "https://firestoned.io/"
title = "Firestoned"
description = "API-driven DNS infrastructure management"
contentDir = "content"
defaultContentLanguage = "en"
enableRobotsTXT = true
enableGitInfo = true

# Language settings
[languages]
  [languages.en]
    languageName = "English"
    weight = 1

[markup]
  [markup.goldmark]
    [markup.goldmark.renderer]
      unsafe = true  # Allow HTML in markdown
  [markup.highlight]
    style = "monokai"
    lineNos = false

[outputs]
  home = ["HTML", "RSS", "JSON"]
  section = ["HTML", "RSS"]

[taxonomies]
  tag = "tags"
  category = "categories"
```

#### 3.2 Create `config/_default/module.toml`

```toml
[[imports]]
  path = "github.com/google/docsy"
  disable = false

# Mount website's own content (required)
[[mounts]]
  source = "content"
  target = "content"

[[mounts]]
  source = "static"
  target = "static"

[[mounts]]
  source = "layouts"
  target = "layouts"

[[mounts]]
  source = "assets"
  target = "assets"

# Project mounts will be added in later phases
# Example (to be added in Phase 1):
# [[mounts]]
#   source = "../bindy/docs/hugo"
#   target = "content/docs/bindy"
```

#### 3.3 Create `config/_default/params.toml`

```toml
# Site colors (Firestoned branding)
primary = "#0066cc"
secondary = "#333333"

# GitHub repo
github_repo = "https://github.com/firestoned/firestoned"
github_project_repo = "https://github.com/firestoned/firestoned"
github_branch = "main"

# Enable offline search
offlineSearch = true
offlineSearchMaxResults = 25

# Footer
copyright = "The Firestoned Authors"
privacy_policy = ""

# User interface
[ui]
  navbar_logo = true
  sidebar_menu_compact = true
  sidebar_search_disable = false
  breadcrumb_disable = false
  sidebar_menu_foldable = true
  sidebar_cache_limit = 10

# Links (GitHub, etc.)
[links]
  [[links.user]]
    name = "GitHub"
    url = "https://github.com/firestoned"
    icon = "fab fa-github"
    desc = "Firestoned on GitHub"
```

#### 3.4 Create `config/_default/menus.toml`

```toml
# Top menu
[[main]]
  name = "Documentation"
  weight = 10
  url = "/docs/"

[[main]]
  name = "Blog"
  weight = 20
  url = "/blog/"

[[main]]
  name = "Community"
  weight = 30
  url = "/community/"

[[main]]
  name = "GitHub"
  weight = 40
  url = "https://github.com/firestoned"
  pre = "<i class='fab fa-github'></i>"
```

#### 3.5 Create `config/production/config.toml`

```toml
# Production-specific settings
[minify]
  disableCSS = false
  disableHTML = false
  disableJS = false
  disableJSON = false
  disableSVG = false
  disableXML = false
```

---

### 4. Install Node.js Dependencies

Create `package.json`:

```json
{
  "name": "firestoned-docs",
  "version": "1.0.0",
  "description": "Firestoned documentation site",
  "scripts": {
    "serve": "hugo server",
    "build": "hugo --minify"
  },
  "devDependencies": {
    "autoprefixer": "^10.4.14",
    "postcss": "^8.4.24",
    "postcss-cli": "^10.1.0"
  }
}
```

Install dependencies:

```bash
npm install
```

---

### 5. Create Directory Structure

```bash
mkdir -p content/docs
mkdir -p content/blog
mkdir -p content/community
mkdir -p layouts/shortcodes
mkdir -p static/images
mkdir -p static/api
mkdir -p assets/scss
```

---

### 6. Create Landing Page

Create `content/_index.md`:

```markdown
---
title: "Firestoned"
linkTitle: "Home"
---

{{< blocks/cover title="Firestoned" image_anchor="top" height="full" >}}
<div class="mx-auto">
  <p class="lead mt-5">API-driven DNS infrastructure management for Kubernetes</p>
  <a class="btn btn-lg btn-primary me-3 mb-4" href="/docs/">
    Get Started <i class="fas fa-arrow-alt-circle-right ms-2"></i>
  </a>
  <a class="btn btn-lg btn-secondary me-3 mb-4" href="https://github.com/firestoned">
    GitHub <i class="fab fa-github ms-2"></i>
  </a>
</div>
{{< /blocks/cover >}}

{{< blocks/section >}}
<div class="col-12">
  <h2 class="text-center pb-3">What is Firestoned?</h2>
  <p class="text-center">
    Firestoned is an integrated ecosystem for API-driven DNS infrastructure management,
    combining API specification generation with Kubernetes-native DNS control.
  </p>
</div>
{{< /blocks/section >}}

{{< blocks/section >}}
<div class="col-lg-4 mb-5">
  <div class="h-100">
    <h3>bindy</h3>
    <p>Kubernetes operator for managing BIND9 DNS via Custom Resource Definitions</p>
    <a href="/docs/bindy/">Learn more →</a>
  </div>
</div>

<div class="col-lg-4 mb-5">
  <div class="h-100">
    <h3>bindcar</h3>
    <p>REST API sidecar for BIND9 zone management via RNDC</p>
    <a href="/docs/bindcar/">Learn more →</a>
  </div>
</div>

<div class="col-lg-4 mb-5">
  <div class="h-100">
    <h3>zonewarden</h3>
    <p>Kubernetes controller for automatic service-to-DNS synchronization</p>
    <a href="/docs/zonewarden/">Learn more →</a>
  </div>
</div>

<div class="col-lg-4 mb-5">
  <div class="h-100">
    <h3>firestone</h3>
    <p>API specification generator from JSON Schema resource definitions</p>
    <a href="/docs/firestone/">Learn more →</a>
  </div>
</div>

<div class="col-lg-4 mb-5">
  <div class="h-100">
    <h3>forevd</h3>
    <p>Authentication and authorization proxy with mTLS, OIDC, and LDAP support</p>
    <a href="/docs/forevd/">Learn more →</a>
  </div>
</div>
{{< /blocks/section >}}
```

---

### 7. Create Documentation Home Page

Create `content/docs/_index.md`:

```markdown
---
title: "Documentation"
linkTitle: "Documentation"
menu:
  main:
    weight: 10
---

# Firestoned Documentation

Welcome to the Firestoned ecosystem documentation.

## Projects

- **[bindy](/docs/bindy/)** - Kubernetes BIND9 operator
- **[bindcar](/docs/bindcar/)** - BIND9 REST API sidecar
- **[zonewarden](/docs/zonewarden/)** - Service-to-DNS sync controller
- **[firestone](/docs/firestone/)** - API specification generator
- **[forevd](/docs/forevd/)** - Authentication/authorization proxy

## Getting Started

Choose a project above to get started, or read our [ecosystem overview](/docs/getting-started/).
```

---

### 8. Create Makefile

Create `Makefile`:

```makefile
.PHONY: help build serve clean prepare-all install

HUGO := hugo
HUGO_ENV ?= development
NPM := npm

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | \
	  awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

install: ## Install Node.js dependencies
	$(NPM) install

prepare-all: ## Prepare all project documentation
	@echo "No projects mounted yet - this will be populated in future phases"
	# Future: @cd ../bindy && make docs-hugo-prepare

build: prepare-all ## Build Hugo site
	@echo "Building Hugo site for $(HUGO_ENV)..."
	@$(HUGO) --environment $(HUGO_ENV) --minify

serve: prepare-all ## Serve Hugo site locally
	@echo "Starting Hugo server..."
	@$(HUGO) server --buildDrafts --environment $(HUGO_ENV)

clean: ## Clean build artifacts
	@echo "Cleaning build artifacts..."
	@rm -rf public/ resources/ .hugo_build.lock

test: build ## Test the build
	@echo "Build successful!"
	@ls -lh public/
```

---

### 9. Create .gitignore

Create `.gitignore`:

```
# Hugo
public/
resources/
.hugo_build.lock

# Node
node_modules/
package-lock.json

# OS
.DS_Store
Thumbs.db

# IDE
.vscode/
.idea/
*.swp
*.swo
```

---

### 10. Test Hugo Server

```bash
hugo server
```

**Expected Output:**
```
Start building sites …
...
Web Server is available at http://localhost:1313/ (bind address 127.0.0.1)
```

Open browser to `http://localhost:1313/` and verify:
- Landing page loads
- Docsy theme is applied
- Navigation menu shows "Documentation", "Blog", "Community"
- Project cards are visible

---

### 11. Add Artwork Assets

#### 11.1 Generate Artwork

Use the artwork generation prompt (see README) to create:
- Logo (SVG)
- Favicon (SVG + PNG)
- Hero background (optional)
- Social preview image

#### 11.2 Add Logo

Save logo as `website/static/images/logo.svg` and update `params.toml`:

```toml
# Add to [ui] section
[ui]
  navbar_logo = true
  navbar_logo_path = "/images/logo.svg"
```

#### 11.3 Add Favicon

```bash
# Save favicon files
cp favicon.svg website/static/favicon.svg
cp favicon-32x32.png website/static/favicon-32x32.png
```

Create `website/layouts/partials/favicons.html`:

```html
<link rel="icon" type="image/svg+xml" href="/favicon.svg">
<link rel="icon" type="image/png" sizes="32x32" href="/favicon-32x32.png">
```

#### 11.4 Add Social Preview

Save as `website/static/images/social-preview.png` and add to `params.toml`:

```toml
[params]
  images = ["/images/social-preview.png"]
```

---

### 12. Configure GitHub Pages Deployment

#### 12.1 Create GitHub Actions Workflow

Create `.github/workflows/docs.yaml`:

```yaml
name: Documentation

on:
  push:
    branches: [main]
    paths:
      - 'website/**'
      - '.github/workflows/docs.yaml'
  workflow_dispatch:

permissions:
  contents: read
  pages: write
  id-token: write

concurrency:
  group: "pages"
  cancel-in-progress: false

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4
        with:
          submodules: recursive
          fetch-depth: 0

      - name: Setup Hugo
        uses: peaceiris/actions-hugo@v2
        with:
          hugo-version: "0.120.0"
          extended: true

      - name: Setup Go
        uses: actions/setup-go@v4
        with:
          go-version: "1.21"

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: "18"
          cache: "npm"
          cache-dependency-path: website/package-lock.json

      - name: Install Node.js dependencies
        run: |
          cd website
          npm ci

      - name: Build Hugo site
        run: |
          cd website
          hugo --minify --environment production

      - name: Upload artifact
        uses: actions/upload-pages-artifact@v3
        with:
          path: website/public

  deploy:
    needs: build
    if: github.ref == 'refs/heads/main'
    runs-on: ubuntu-latest
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    steps:
      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v4
```

#### 12.2 Add CNAME File (Optional - for custom domain)

If using custom domain `firestoned.io`, create `website/static/CNAME`:

```
firestoned.io
```

Skip this if using GitHub Pages default URL (`username.github.io/firestoned`).

#### 12.3 Update baseURL for GitHub Pages

If NOT using custom domain, update `config/_default/config.toml`:

```toml
# For GitHub Pages at username.github.io/firestoned
baseURL = "https://username.github.io/firestoned/"

# OR for custom domain
baseURL = "https://firestoned.io/"
```

---

### 13. Deploy to GitHub Pages

#### 13.1 Enable GitHub Pages

1. Push changes to GitHub:
   ```bash
   git add .
   git commit -m "Phase 0: Hugo site foundation with GitHub Pages"
   git push origin main
   ```

2. Go to repository Settings → Pages
3. Source: Select "GitHub Actions"
4. Save

#### 13.2 Trigger Deployment

The workflow will automatically run on push. Monitor at:
- GitHub Actions tab → "Documentation" workflow

#### 13.3 Verify Deployment

After workflow completes, visit:
- GitHub Pages URL: `https://username.github.io/firestoned/`
- OR custom domain: `https://firestoned.io/`

Check:
- [ ] Landing page loads
- [ ] Logo appears in navbar
- [ ] Navigation works
- [ ] Project cards visible
- [ ] No console errors

---

### 14. Configure Custom Domain (Optional)

If using `firestoned.io`, add DNS records:

**A Records:**
```
Type    Name    Value
A       @       185.199.108.153
A       @       185.199.109.153
A       @       185.199.110.153
A       @       185.199.111.153
```

**CNAME Record:**
```
Type    Name    Value
CNAME   www     username.github.io
```

Then in GitHub Settings → Pages:
- Custom domain: `firestoned.io`
- Wait for DNS check to pass
- Enable "Enforce HTTPS"

---

## Success Criteria

- [x] Hugo server runs without errors
- [x] Landing page renders with Docsy theme
- [x] Navigation menu functional
- [x] Makefile targets work (`make help`, `make serve`, `make build`, `make clean`)
- [x] Configuration files in place
- [x] Directory structure created
- [x] Node.js dependencies installed
- [x] .gitignore configured
- [x] Logo and favicon added
- [x] GitHub Actions workflow configured
- [x] Site deployed to GitHub Pages
- [x] Public URL accessible

---

## Deliverables

1. ✅ Hugo site initialized in `website/`
2. ✅ Docsy theme integrated via Hugo modules
3. ✅ Configuration files created
4. ✅ Landing page with project overview
5. ✅ Makefile for build automation
6. ✅ Working local development environment
7. ✅ Logo and branding assets
8. ✅ GitHub Pages deployment
9. ✅ Live website at public URL

---

## Next Phase

**[Phase 1: bindy Migration →](phase-1-bindy-migration.md)**

Migrate bindy's 94-page mdBook site to Hugo.

---

## Troubleshooting

### Hugo module errors

If you see "module not found" errors:
```bash
hugo mod tidy
hugo mod get -u
```

### PostCSS errors

If you see PostCSS errors during build:
```bash
npm install
```

### Port already in use

If port 1313 is in use:
```bash
hugo server -p 1314
```
