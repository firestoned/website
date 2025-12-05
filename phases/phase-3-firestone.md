# Phase 3: firestone Documentation (Week 5)

**Status:** Not Started
**Owner:** TBD
**Duration:** 1 week
**Depends On:** Phase 2 (zonewarden)

---

## Goal

Create comprehensive firestone documentation from README and examples, focusing on the resource-based API generation workflow.

---

## Tasks

### 1. Create Hugo Directory Structure

```bash
cd /home/brad/firestoned/firestone
mkdir -p docs/hugo/{installation,concepts,guides,examples,reference}
```

---

### 2. Create Overview Page

`_index.md`:

```markdown
---
title: "firestone"
linkTitle: "firestone"
weight: 40
description: >
  API specification generator from JSON Schema resource definitions
---

# firestone

firestone allows you to build OpenAPI, AsyncAPI, and gRPC specifications based on JSON Schema resource files.

## The Resource-Based Approach

**Philosophy**: Use JSON Schema to define your resources, then auto-generate APIs from those resources.

**Benefits**:
- Focus on your data model, not API boilerplate
- Consistent API design across projects
- Auto-generate clients, servers, and CLIs
- JSON Schema validation built-in

## What firestone Generates

- **OpenAPI 3.x** specifications
- **AsyncAPI** specifications (WebSocket support)
- **Python Click CLIs** for CRUD operations
- **gRPC** definitions (planned)

## Quick Example

Define a resource:
\`\`\`yaml
name: book
schema:
  type: array
  key:
    name: book_id
    schema:
      type: string
  items:
    type: object
    properties:
      title:
        type: string
      author:
        type: string
\`\`\`

Generate OpenAPI:
```bash
firestone generate --resources book.yaml openapi
```

[Get Started →](installation/)
```

---

### 3. Installation Guide

`installation/_index.md`:

```markdown
---
title: "Installation"
weight: 10
---

# Installing firestone

## Using pip

```bash
pip install firestoned
```

> **Note**: The package is `firestoned` (with 'd'), not `firestone`.
> This is because `firestone` was already taken on PyPI.

## Using Poetry

For new projects:
```bash
poetry init
poetry add firestoned
```

For existing projects:
```bash
poetry add firestoned
```

## Verify Installation

```bash
firestone --version
```

## Next Steps

- [Learn core concepts](../concepts/)
- [Follow the quick start](../guides/quickstart/)
```

---

### 4. Concepts Documentation

`concepts/_index.md`:

```markdown
---
title: "Concepts"
weight: 20
---

# Core Concepts

## Resource Schema

A resource schema defines:
1. **Data structure** - JSON Schema for your resource
2. **API behavior** - Which HTTP methods to expose
3. **Metadata** - Name, version, descriptions

## Resource-Based APIs

Instead of writing:
- OpenAPI paths manually
- Request/response schemas repeatedly
- Validation logic for each endpoint

You write:
- **One resource schema**
- firestone generates everything else

## Generation Outputs

### OpenAPI
- REST API specification
- Full CRUD operations
- Validation schemas
- Security definitions

### AsyncAPI
- WebSocket events
- Pub/sub patterns
- Real-time updates

### CLI
- Python Click-based tools
- CRUD commands
- Client SDK integration
```

`concepts/resource-schema.md`:

```markdown
---
title: "Resource Schema"
weight: 10
---

# Resource Schema Structure

## Metadata Section

\`\`\`yaml
name: addressbook          # API path: /addressbook
description: An addressbook resource
version: 1.0               # API version
version_in_path: false     # URL: /addressbook (not /v1.0/addressbook)
\`\`\`

## Methods Configuration

\`\`\`yaml
methods:
  resource:       # Collection endpoints (/addressbook)
    - get         # List all
    - post        # Create new
  instance:       # Item endpoints (/addressbook/{id})
    - get         # Get one
    - put         # Update
    - delete      # Delete
\`\`\`

## Schema Definition

\`\`\`yaml
schema:
  type: array
  key:
    name: address_key
    schema:
      type: string
  items:
    type: object
    properties:
      street:
        type: string
      city:
        type: string
    required:
      - street
      - city
\`\`\`
```

---

### 5. Guides

`guides/quickstart.md`:

```markdown
---
title: "Quick Start"
weight: 10
---

# Quick Start Guide

## Step 1: Define a Resource

Create `book.yaml`:

\`\`\`yaml
name: book
description: A book resource
version: 1.0
methods:
  resource: [get, post]
  instance: [get, put, delete]
schema:
  type: array
  key:
    name: book_id
    schema:
      type: string
  items:
    type: object
    properties:
      title:
        type: string
      author:
        type: string
      isbn:
        type: string
    required:
      - title
      - author
\`\`\`

## Step 2: Generate OpenAPI

```bash
firestone generate \
    --title 'Book API' \
    --description 'API for managing books' \
    --resources book.yaml \
    openapi > openapi.yaml
```

## Step 3: View with Swagger UI

```bash
firestone generate \
    --title 'Book API' \
    --resources book.yaml \
    openapi \
    --ui-server
```

Navigate to `http://127.0.0.1:5000/apidocs`

## Step 4: Generate Client Code

```bash
openapi-generator generate \
    -i openapi.yaml \
    -g python \
    -o client/
```

## Step 5: Generate CLI

```bash
firestone generate \
    --title 'Book CLI' \
    --resources book.yaml \
    cli \
    --pkg book_api \
    --client-pkg book_api.client > cli.py
```
```

`guides/generating-openapi.md`, `guides/generating-cli.md`, `guides/schema-reference.md`, etc.

---

### 6. Examples

`examples/addressbook.md`:

```markdown
---
title: "Addressbook Example"
weight: 10
---

# Addressbook Example

Complete working example demonstrating:
- Resource definition
- Embedded resources
- Query parameters
- OpenAPI generation
- Client generation
- CLI generation

## Resource Definition

Full example from `examples/addressbook/addressbook.yaml`:

\`\`\`yaml
name: addressbook
description: An example of an addressbook resource
version: 1.0
version_in_path: false

default_query_params:
  - name: limit
    description: Limit the number of responses
    in: query
    schema:
      type: integer
  - name: offset
    description: The offset to start returning resources
    in: query
    schema:
      type: integer

methods:
  resource: [get, post]
  instance: [delete, get, put]

schema:
  type: array
  key:
    name: address_key
    schema:
      type: string
  items:
    type: object
    properties:
      person:
        description: Person living at this address
        schema:
          $ref: "person.yaml#/schema"
      addrtype:
        type: string
        enum: [work, home]
      street:
        type: string
      city:
        type: string
      state:
        type: string
      country:
        type: string
    required:
      - addrtype
      - street
      - city
      - state
      - country
\`\`\`

## Generate OpenAPI

```bash
firestone generate \
    --title 'Addressbook API' \
    --resources examples/addressbook/addressbook.yaml,examples/addressbook/person.yaml \
    openapi > openapi.yaml
```

## View Full Example

The complete example with all files is in the repository:
[examples/addressbook/](https://github.com/firestoned/firestoned/tree/main/firestone/examples/addressbook)
```

---

### 7. Set Up Content Mount

```toml
# Mount firestone
[[mounts]]
  source = "../firestone/docs/hugo"
  target = "content/docs/firestone"
```

---

## Success Criteria

- [ ] Complete firestone documentation
- [ ] Examples well-documented
- [ ] Clear getting started path
- [ ] Resource schema reference complete
- [ ] Generation workflows documented
- [ ] Integration with openapi-generator documented

---

## Next Phase

**[Phase 4: forevd Documentation →](phase-4-forevd.md)**
