# Phase 8: GitHub Pages Deployment (Week 10)

**Status:** Not Started
**Owner:** TBD
**Duration:** 1 week
**Depends On:** Phase 7 (Polish)

---

## Goal

Deploy the Hugo site to GitHub Pages with custom DNS (firestoned.io).

---

## Tasks

### 1. Create GitHub Actions Workflow

Create `.github/workflows/docs.yaml`:

```yaml
name: Documentation

on:
  push:
    branches: [main]
    paths:
      - 'website/**'
      - '*/docs/**'
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

      - name: Setup Rust
        uses: dtolnay/rust-toolchain@stable

      - name: Cache Rust
        uses: Swatinem/rust-cache@v2

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

      - name: Prepare documentation
        run: |
          cd website
          make prepare-all

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

---

### 2. Configure GitHub Pages

#### 2.1 Enable GitHub Pages

1. Go to repository settings
2. Navigate to "Pages"
3. Source: "GitHub Actions"
4. Save

#### 2.2 Add Custom Domain

Create `website/static/CNAME`:

```
firestoned.io
```

---

### 3. Configure DNS

#### 3.1 DNS Records

Add the following records to your DNS provider:

**For apex domain (firestoned.io):**

```
Type    Name    Value
A       @       185.199.108.153
A       @       185.199.109.153
A       @       185.199.110.153
A       @       185.199.111.153
```

**For www subdomain:**

```
Type    Name    Value
CNAME   www     firestoned.github.io
```

#### 3.2 Verify DNS Propagation

```bash
# Check A records
dig firestoned.io A +short

# Check CNAME
dig www.firestoned.io CNAME +short

# Check propagation
dig firestoned.io @8.8.8.8 +short
```

Wait for DNS propagation (can take up to 48 hours, usually much faster).

---

### 4. Enable HTTPS

1. Go to repository settings → Pages
2. Wait for DNS check to pass
3. Check "Enforce HTTPS"
4. GitHub automatically provisions Let's Encrypt certificate

---

### 5. Test Deployment

#### 5.1 Trigger Workflow

Push to main branch:

```bash
git add .github/workflows/docs.yaml website/
git commit -m "Add GitHub Pages deployment"
git push origin main
```

#### 5.2 Monitor Build

- Go to Actions tab
- Watch "Documentation" workflow
- Verify build succeeds
- Verify deployment completes

#### 5.3 Test Site

Visit `https://firestoned.io` and verify:

- [ ] Site loads
- [ ] HTTPS works (green padlock)
- [ ] All projects accessible
- [ ] Search works
- [ ] API docs accessible
- [ ] Images load
- [ ] CSS/JS load
- [ ] No console errors

#### 5.4 Test URLs

```bash
# Test main pages
curl -I https://firestoned.io
curl -I https://firestoned.io/docs/
curl -I https://firestoned.io/docs/bindy/
curl -I https://firestoned.io/docs/bindcar/
curl -I https://firestoned.io/docs/zonewarden/
curl -I https://firestoned.io/docs/firestone/
curl -I https://firestoned.io/docs/forevd/

# Test API docs
curl -I https://firestoned.io/api/bindy/rustdoc/
curl -I https://firestoned.io/api/bindcar/openapi/openapi.json

# All should return 200 OK
```

---

### 6. Performance Testing

#### 6.1 Lighthouse Audit

```bash
lighthouse https://firestoned.io --view
```

Targets:
- Performance: >90
- Accessibility: >90
- Best Practices: >90
- SEO: >90

#### 6.2 PageSpeed Insights

Visit: https://pagespeed.web.dev/
Enter: https://firestoned.io
Verify both mobile and desktop scores >90

---

### 7. Configure Redirects (Optional)

If needed, create `website/static/_redirects` (Netlify format):

```
# Redirect old URLs
/docs/bindy/old-page  /docs/bindy/new-page  301
```

---

### 8. Set Up Monitoring

#### 8.1 Add Status Badge to README

```markdown
[![Docs Status](https://github.com/firestoned/firestoned/actions/workflows/docs.yaml/badge.svg)](https://github.com/firestoned/firestoned/actions/workflows/docs.yaml)
```

#### 8.2 Google Search Console

1. Visit https://search.google.com/search-console
2. Add property: firestoned.io
3. Verify ownership (via DNS or HTML file)
4. Submit sitemap: https://firestoned.io/sitemap.xml

#### 8.3 Google Analytics (Optional)

Add to `params.toml`:

```toml
[params.analytics]
  google_analytics_id = "G-XXXXXXXXXX"
```

---

### 9. Documentation

#### 9.1 Update Project READMEs

Update all project READMEs to link to new docs:

```markdown
## Documentation

Full documentation available at: https://firestoned.io/docs/bindy/

- [Installation](https://firestoned.io/docs/bindy/installation/)
- [Quick Start](https://firestoned.io/docs/bindy/installation/quickstart/)
- [API Reference](https://firestoned.io/docs/bindy/reference/api/)
```

#### 9.2 Add Badges

```markdown
[![Documentation](https://img.shields.io/badge/docs-firestoned.io-blue)](https://firestoned.io)
```

---

## Success Criteria

- [ ] Site deploys on push to main
- [ ] Custom domain (firestoned.io) works
- [ ] HTTPS enabled and working
- [ ] All URLs functional (no 404s)
- [ ] Search works
- [ ] API docs accessible
- [ ] Performance >90 (Lighthouse)
- [ ] Accessibility >90 (Lighthouse)
- [ ] DNS propagated globally
- [ ] Monitoring configured

---

## Troubleshooting

### Build Fails

Check GitHub Actions logs for errors:
- Hugo version correct?
- Node.js dependencies installed?
- Rust compilation errors?

### DNS Not Working

- Verify DNS records correct
- Wait for propagation (24-48 hours max)
- Check with `dig firestoned.io @8.8.8.8`

### HTTPS Not Available

- Verify DNS working first
- Wait for certificate provisioning (can take hours)
- Check GitHub Pages settings

### 404 Errors

- Check `baseURL` in config.toml matches domain
- Verify CNAME file exists in static/
- Check GitHub Pages configuration

---

## Next Phase

**[Phase 9: mdBook Deprecation →](phase-9-mdbook-deprecation.md)**
