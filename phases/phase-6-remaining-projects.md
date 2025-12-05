# Phase 6: Remaining Projects (Week 8)

**Status:** Not Started
**Owner:** TBD
**Duration:** 1 week
**Depends On:** Phase 5 (bindcar)

---

## Goal

Complete documentation for firestone-lib and openapi-examples.

---

## Tasks

### 1. firestone-lib Documentation

Currently has minimal README. Create:

#### 1.1 Directory Structure

```bash
cd /home/brad/firestoned/firestone-lib
mkdir -p docs/hugo/{installation,api,usage}
```

#### 1.2 Overview

```markdown
---
title: "firestone-lib"
linkTitle: "firestone-lib"
weight: 60
---

# firestone-lib

Core library providing shared functionality for firestone and other projects.

## What It Provides

- Schema validation utilities
- Specification generation helpers
- JSON Schema handling
- Reusable components

## Used By

- **firestone** - API spec generator
- **forevd** - Auth proxy (for config processing)

## Installation

```bash
pip install firestone-lib
```

Or with Poetry:

```bash
poetry add firestone-lib
```
```

#### 1.3 API Documentation

If using Sphinx, generate Python API docs:

```bash
cd firestone-lib
pip install sphinx sphinx-rtd-theme
sphinx-quickstart docs
# Configure autodoc
sphinx-build -b html docs/source docs/build/html
```

Copy to website:

```bash
cp -r docs/build/html ../website/static/api/python/firestone-lib/
```

#### 1.4 Content Mount

```toml
[[mounts]]
  source = "../firestone-lib/docs/hugo"
  target = "content/docs/firestone-lib"

[[mounts]]
  source = "../website/static/api/python/firestone-lib"
  target = "static/api/python/firestone-lib"
```

---

### 2. openapi-examples Documentation

#### 2.1 Directory Structure

```bash
cd /home/brad/firestoned/openapi-examples
mkdir -p docs/hugo/{fastapi,rust}
```

#### 2.2 Overview

```markdown
---
title: "OpenAPI Examples"
linkTitle: "Examples"
weight: 70
---

# OpenAPI Code Generation Examples

Real-world examples showing how to use firestone-generated OpenAPI specs.

## Examples

### FastAPI Server (Python)
[View Example →](fastapi/)

Complete FastAPI implementation:
- Generated models
- CRUD endpoints
- Docker deployment
- Tests

### Rust Server & Client
[View Example →](rust/)

Rust implementation showing:
- Server with Actix-web
- Client implementation
- Generated types
```

#### 2.3 Example Documentation

Document each example with:
- What it demonstrates
- How to run it
- How it was generated
- Integration with firestone

---

## Success Criteria

- [ ] firestone-lib has basic documentation
- [ ] Python API docs generated (optional)
- [ ] openapi-examples documented
- [ ] All examples have README and instructions
- [ ] Cross-linking complete

---

## Next Phase

**[Phase 7: Cross-Project Content & Polish →](phase-7-polish.md)**
