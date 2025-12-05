# Phase 5: bindcar Migration (Week 7)

**Status:** Not Started
**Owner:** TBD
**Duration:** 1 week
**Depends On:** Phase 4 (forevd)

---

## Goal

Migrate bindcar's 49-page mdBook site to Hugo, similar to bindy migration process.

---

## Tasks

Follow similar process to Phase 1 (bindy migration):

### 1. Create Hugo Directory Structure

```bash
cd /home/brad/firestoned/bindcar/docs
mkdir -p hugo/{getting-started,user-guide,operations,advanced,developer-guide,reference}
```

### 2. Migrate mdBook Content

- Copy 49 markdown files from `src/` to `hugo/`
- Add front matter to each file
- Update internal links
- Convert mdBook syntax to Hugo

### 3. Create Swagger UI Shortcode

Create `website/layouts/shortcodes/swagger-ui.html`:

```html
{{- $src := .Get "src" -}}
<div id="swagger-ui-{{ .Ordinal }}"></div>
<link rel="stylesheet" href="https://unpkg.com/swagger-ui-dist@5/swagger-ui.css">
<script src="https://unpkg.com/swagger-ui-dist@5/swagger-ui-bundle.js"></script>
<script>
window.addEventListener('load', function() {
  SwaggerUIBundle({
    url: "{{ $src }}",
    dom_id: '#swagger-ui-{{ .Ordinal }}',
    deepLinking: true,
    presets: [
      SwaggerUIBundle.presets.apis,
      SwaggerUIBundle.SwaggerUIStandalonePreset
    ],
  });
});
</script>
```

### 4. Integrate OpenAPI Documentation

Create `reference/openapi.md`:

```markdown
---
title: "OpenAPI Specification"
weight: 10
---

# OpenAPI Specification

Interactive API documentation for bindcar REST API.

{{< swagger-ui src="/api/bindcar/openapi/openapi.json" >}}

## Download Specification

- [OpenAPI JSON](/api/bindcar/openapi/openapi.json)
- [OpenAPI YAML](/api/bindcar/openapi/openapi.yaml)
```

### 5. Add Makefile Target

Edit `bindcar/Makefile`:

```makefile
docs-hugo-prepare: ## Prepare Hugo content
	@echo "Preparing bindcar documentation for Hugo..."
	@echo "Building rustdoc..."
	@cargo doc --no-deps --all-features
	@echo "Generating OpenAPI spec..."
	@$(MAKE) --no-print-directory docs-openapi
	@mkdir -p ../website/static/api/bindcar/openapi
	@cp docs/target/openapi.json ../website/static/api/bindcar/openapi/
	@echo "Hugo preparation complete"
```

### 6. Set Up Content Mounts

```toml
# Mount bindcar
[[mounts]]
  source = "../bindcar/docs/hugo"
  target = "content/docs/bindcar"

[[mounts]]
  source = "../bindcar/target/doc"
  target = "static/api/bindcar/rustdoc"
```

---

## Success Criteria

- [ ] All 49 pages migrated
- [ ] OpenAPI spec accessible via Swagger UI
- [ ] Rustdoc integrated
- [ ] Navigation functional
- [ ] Search works
- [ ] mdBook site preserved

---

## Next Phase

**[Phase 6: Remaining Projects →](phase-6-remaining-projects.md)**
