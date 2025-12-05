# Phase 4: forevd Documentation (Week 6)

**Status:** Not Started
**Owner:** TBD
**Duration:** 1 week
**Depends On:** Phase 3 (firestone)

---

## Goal

Create comprehensive forevd documentation from README and config examples, focusing on authentication/authorization patterns.

---

## Tasks

### 1. Create Hugo Directory Structure

```bash
cd /home/brad/firestoned/forevd
mkdir -p docs/hugo/{installation,configuration,deployment,guides,examples}
```

---

### 2. Create Overview

`_index.md`:

```markdown
---
title: "forevd"
linkTitle: "forevd"
weight: 50
description: >
  Authentication and authorization proxy with mTLS, OIDC, and LDAP support
---

# forevd

forevd is a forward and reverse proxy that delivers authentication and authorization as a sidecar, eliminating the need to add auth into your application code.

## Why forevd?

**Problem**: Every application needs authentication and authorization, but implementing it correctly is complex and error-prone.

**Solution**: forevd handles auth as infrastructure, not application code.

## Supported Auth Methods

- **mTLS** - Mutual TLS certificate validation
- **OIDC** - OpenID Connect (Auth0, Okta, etc.)
- **LDAP** - LDAP group authorization
- **Static Users** - Whitelist-based access

## Architecture Pattern: Sidecar

forevd runs alongside your application:

\`\`\`
┌─────────────────────┐
│   Your Application  │  (No auth code!)
│    (port 8081)      │
└─────────────────────┘
          ↑
          │
┌─────────────────────┐
│      forevd         │  (Handles all auth)
│    (port 8080)      │
└─────────────────────┘
          ↑
          │
    Client Requests
\`\`\`

## Quick Example

```yaml
# Protect /api with mTLS
forevd \
    --listen 0.0.0.0:8080 \
    --backend http://localhost:8081 \
    --location /api \
    --mtls require \
    --ca-cert ca.pem \
    --cert server.crt \
    --cert-key server.key
```

[Get Started →](installation/)
```

---

### 3. Configuration Documentation

`configuration/oidc.md`:

```markdown
---
title: "OIDC Configuration"
weight: 20
---

# OIDC Configuration

## Basic Setup

\`\`\`yaml
ProviderMetadataUrl: "https://your-provider.auth0.com/.well-known/openid-configuration"
RedirectURI: "https://your-app.example.com/redirect_uri"
ClientId: "{{ OIDC_CLIENT_ID }}"
ClientSecret: "{{ OIDC_CLIENT_SECRET }}"
Scope: '"openid profile email"'
PKCEMethod: S256
RemoteUserClaim: email
\`\`\`

## Environment Variable Injection

Use Jinja2 templates:

```bash
export OIDC_CLIENT_ID=your_client_id
export OIDC_CLIENT_SECRET=your_secret
forevd --oidc @etc/oidc.yaml ...
```

## Providers

### Auth0

\`\`\`yaml
ProviderMetadataUrl: "https://YOUR_DOMAIN.auth0.com/.well-known/openid-configuration"
ClientId: "{{ AUTH0_CLIENT_ID }}"
ClientSecret: "{{ AUTH0_CLIENT_SECRET }}"
\`\`\`

### Okta

\`\`\`yaml
ProviderMetadataUrl: "https://YOUR_DOMAIN.okta.com/.well-known/openid-configuration"
ClientId: "{{ OKTA_CLIENT_ID }}"
ClientSecret: "{{ OKTA_CLIENT_SECRET }}"
\`\`\`
```

`configuration/ldap.md`:

```markdown
---
title: "LDAP Configuration"
weight: 30
---

# LDAP Configuration

## Global LDAP Settings

\`\`\`yaml
SharedCacheSize: 500000
CacheEntries: 1024
CacheTTL: 600
OpCacheEntries: 1024
OpCacheTTL: 600
\`\`\`

## Location-Level LDAP

\`\`\`yaml
- path: /
  authz:
    ldap:
      url: "ldaps://ldap.example.com/DC=example,DC=com"
      bind-dn: "CN=binduser,DC=example,DC=com"
      bind-pw: "{{ LDAP_PASSWORD }}"
      groups:
        - "CN=admins,OU=groups,DC=example,DC=com"
        - "CN=developers,OU=groups,DC=example,DC=com"
\`\`\`
```

`configuration/locations.md`:

```markdown
---
title: "Locations Configuration"
weight: 10
---

# Locations Configuration

## Overview

Locations allow fine-grained control over different API endpoints.

## Keys

| Key | Description | Example |
|-----|-------------|---------|
| `path` | URL path to protect | `/api` |
| `match` | Match type (exact/regex) | `exact` |
| `authc` | Authentication config | `{mtls: true}` |
| `authz` | Authorization config | `{ldap: {...}}` |

## Examples

### Protect /api with LDAP Groups

\`\`\`yaml
- path: /api
  authc:
    oidc: true
  authz:
    join_type: "all"
    ldap:
      url: "ldaps://ldap.example.com/DC=example,DC=com"
      bind-dn: "CN=binduser,DC=example,DC=com"
      bind-pw: "{{ LDAP_PASSWORD }}"
      groups:
        - "CN=api-users,OU=groups,DC=example,DC=com"
\`\`\`

### Allow Specific Users

\`\`\`yaml
- path: /admin
  authz:
    users:
      - alice@example.com
      - bob@example.com
\`\`\`

### Combine Multiple Authorization Methods

\`\`\`yaml
- path: /
  authz:
    join_type: "any"  # Allow if ANY condition matches
    ldap:
      groups: ["CN=admins,OU=groups,DC=example,DC=com"]
    users:
      - emergency@example.com
\`\`\`

**Result**: Access granted if user is in LDAP group OR is emergency@example.com
```

---

### 4. Deployment Guide

`deployment/_index.md`:

```markdown
---
title: "Deployment"
weight: 40
---

# Deploying forevd

## Kubernetes Sidecar

\`\`\`yaml
apiVersion: v1
kind: Pod
metadata:
  name: my-app
spec:
  containers:
  # Application
  - name: app
    image: my-app:latest
    ports:
    - containerPort: 8081

  # forevd sidecar
  - name: forevd
    image: ghcr.io/firestoned/forevd:latest
    ports:
    - containerPort: 8080
    env:
    - name: OIDC_CLIENT_ID
      valueFrom:
        secretKeyRef:
          name: oidc-secrets
          key: client_id
    volumeMounts:
    - name: forevd-config
      mountPath: /etc/forevd

  volumes:
  - name: forevd-config
    configMap:
      name: forevd-config
\`\`\`

## Docker Compose

\`\`\`yaml
version: '3'
services:
  app:
    image: my-app:latest
    ports:
      - "8081"

  forevd:
    image: ghcr.io/firestoned/forevd:latest
    ports:
      - "8080:8080"
    environment:
      - OIDC_CLIENT_ID=${OIDC_CLIENT_ID}
      - OIDC_CLIENT_SECRET=${OIDC_CLIENT_SECRET}
    volumes:
      - ./forevd-config:/etc/forevd
    command: >
      forevd
      --listen 0.0.0.0:8080
      --backend http://app:8081
      --oidc @/etc/forevd/oidc.yaml
\`\`\`
```

---

### 5. Set Up Content Mount

```toml
# Mount forevd
[[mounts]]
  source = "../forevd/docs/hugo"
  target = "content/docs/forevd"
```

---

## Success Criteria

- [ ] Complete forevd documentation
- [ ] Configuration examples well-documented
- [ ] Deployment patterns documented (Kubernetes, Docker)
- [ ] All auth methods documented (mTLS, OIDC, LDAP, static users)
- [ ] Jinja2 templating explained
- [ ] Integration examples provided

---

## Next Phase

**[Phase 5: bindcar Migration →](phase-5-bindcar.md)**
