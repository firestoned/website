# Phase 2: zonewarden Documentation (Week 4)

**Status:** Not Started
**Owner:** TBD
**Duration:** 1 week
**Depends On:** Phase 1 (bindy Migration)

---

## Goal

Create comprehensive zonewarden documentation from README and architecture diagrams, expanding the content into a structured Hugo site.

---

## Prerequisites

- Phase 1 completed (bindy in Hugo)
- zonewarden README reviewed
- Architecture diagram understood

---

## Tasks

### 1. Create Hugo Directory Structure

```bash
cd /home/brad/firestoned/zonewarden
mkdir -p docs/hugo/{installation,architecture,configuration,usage,examples}
```

---

### 2. Extract and Organize README Content

Current README has:
- Overview (~160 lines)
- Architecture diagram (ASCII)
- Installation
- Usage
- Configuration
- Development

Reorganize into:

#### 2.1 Overview Page (`_index.md`)

```markdown
---
title: "zonewarden"
linkTitle: "zonewarden"
weight: 30
description: >
  Kubernetes controller for automatic service-to-DNS synchronization
---

# zonewarden

zonewarden is a Kubernetes controller that bridges Kubernetes Services to DNS by automatically syncing service IPs to BIND9 zones via the bindy API.

## What it Does

1. Watches namespaces labeled with `cf.rbccm.com/dns-managed=true`
2. Monitors services within those namespaces
3. Syncs service IPs to BIND9 zones via bindy
4. Enables automatic DNS registration for services

## Use Cases

- **LoadBalancer Services**: Automatically register external IPs
- **Multi-cluster DNS**: Service discovery across clusters
- **GitOps Workflows**: Declarative DNS via Kubernetes resources
- **Service Mesh Integration**: Works with Linkerd for mTLS

## Quick Start

```bash
# 1. Label namespace
kubectl label namespace my-app cf.rbccm.com/dns-managed=true

# 2. Create ServiceDNSConfig
kubectl apply -f servicednsconfig.yaml

# 3. Deploy service - DNS record created automatically!
```

[Get Started →](installation/)
```

#### 2.2 Architecture Page

Create `architecture/_index.md` and convert ASCII diagram to Mermaid:

```markdown
---
title: "Architecture"
weight: 20
description: >
  How zonewarden integrates with Kubernetes and bindy
---

# Architecture

zonewarden operates as a Kubernetes controller that watches for service changes and synchronizes them to DNS.

## System Architecture

{{< mermaid >}}
graph TB
    subgraph "Workload Cluster"
        NS[Namespace<br/>labeled: dns-managed=true]
        SVC[Services]
        ZW[zonewarden Controller]
        LK1[Linkerd<br/>Service Mesh]

        NS --> SVC
        SVC --> ZW
        ZW --> LK1
    end

    subgraph "Mothership Cluster"
        LK2[Linkerd<br/>Service Mesh]
        BINDY[bindy API]
        BIND9[BIND9 Instances]

        LK2 --> BINDY
        BINDY --> BIND9
    end

    LK1 -.mTLS.-> LK2

    style ZW fill:#0066cc,color:#fff
    style BINDY fill:#ff6b35,color:#fff
{{< /mermaid >}}

## Data Flow

1. **Watch Phase**: zonewarden watches labeled namespaces
2. **Detection**: Service created/updated/deleted
3. **Extraction**: Extract service name, namespace, IP
4. **API Call**: Call bindy API via Linkerd mesh
5. **DNS Update**: bindy creates/updates DNS record via RNDC
6. **Propagation**: BIND9 serves updated DNS records

## Components

### zonewarden Controller
- **Language**: Rust
- **Framework**: kube-rs
- **Role**: Kubernetes controller watching Services
- **Output**: REST API calls to bindy

### ServiceDNSConfig CRD
- **Purpose**: Configure DNS sync behavior
- **Scope**: Namespace-level
- **Fields**: Zone reference, record templates, service selectors

### bindy Integration
- **Protocol**: HTTPS REST
- **Transport**: Linkerd service mesh (mTLS)
- **Endpoint**: `http://bindy-api.bindy-system.svc.cluster.local`
```

#### 2.3 Installation

Create `installation/_index.md`:

```markdown
---
title: "Installation"
weight: 10
---

# Installing zonewarden

## Prerequisites

- Kubernetes cluster
- bindy deployed in mothership cluster
- Linkerd service mesh (for cross-cluster communication)
- kubectl access

## 1. Install CRDs

```bash
kubectl apply -f https://raw.githubusercontent.com/firestoned/firestoned/main/zonewarden/deploy/crd-servicednsconfig.yaml
```

## 2. Deploy Controller

```bash
kubectl apply -f https://raw.githubusercontent.com/firestoned/firestoned/main/zonewarden/deploy/deployment.yaml
```

## 3. Verify Installation

```bash
kubectl get pods -n zonewarden-system
kubectl logs -n zonewarden-system -l app=zonewarden
```

Expected output: Controller running, no errors.
```

#### 2.4 Configuration

Create `configuration/_index.md`:

```markdown
---
title: "Configuration"
weight: 30
---

# Configuring zonewarden

## Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `BINDY_URL` | URL of the bindy API | `http://bindy-api.bindy-system.svc.cluster.local` |
| `DEFAULT_ZONE` | Default DNS zone if no ServiceDNSConfig exists | (none) |
| `RECORD_TEMPLATE` | Default record name template | `{service}.{namespace}` |
| `LOG_LEVEL` | Logging level | `info` |
| `JSON_LOGS` | Enable JSON structured logging | `false` |

## ServiceDNSConfig Specification

### Basic Example

\`\`\`yaml
apiVersion: dns.cf.rbccm.com/v1alpha1
kind: ServiceDNSConfig
metadata:
  name: default
  namespace: my-app
spec:
  zoneRef:
    name: apps.rbccm.com
    namespace: bindy-system
  serviceTypes:
    - LoadBalancer
  recordNameTemplate: "{service}.{namespace}"
\`\`\`

### Fields

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `zoneRef.name` | string | Yes | Name of the DNSZone CR in bindy |
| `zoneRef.namespace` | string | No | Namespace of DNSZone (defaults to same) |
| `serviceSelector.matchLabels` | map | No | Label selector for services |
| `recordNameTemplate` | string | No | Template for DNS record names |
| `recordType` | string | No | DNS record type (A or CNAME) |
| `serviceTypes` | []string | No | Service types to sync (default: LoadBalancer) |

### Template Variables

Available in `recordNameTemplate`:
- `{service}` - Service name
- `{namespace}` - Service namespace
- `{cluster}` - Cluster name (from config)

Example: `"{service}.{namespace}.{cluster}"`
```

#### 2.5 Usage Guide

Create `usage/_index.md`:

```markdown
---
title: "Usage"
weight: 40
---

# Using zonewarden

## Step 1: Label Namespace for DNS Management

```bash
kubectl label namespace my-app cf.rbccm.com/dns-managed=true
```

## Step 2: Create ServiceDNSConfig

\`\`\`yaml
apiVersion: dns.cf.rbccm.com/v1alpha1
kind: ServiceDNSConfig
metadata:
  name: default
  namespace: my-app
spec:
  zoneRef:
    name: apps.example.com
    namespace: bindy-system
  serviceTypes:
    - LoadBalancer
  recordNameTemplate: "{service}.{namespace}"
\`\`\`

Apply:
```bash
kubectl apply -f servicednsconfig.yaml
```

## Step 3: Deploy Service

\`\`\`yaml
apiVersion: v1
kind: Service
metadata:
  name: my-api
  namespace: my-app
spec:
  type: LoadBalancer
  ports:
    - port: 443
  selector:
    app: my-api
\`\`\`

## Step 4: Verify DNS Record Created

```bash
# Check zonewarden logs
kubectl logs -n zonewarden-system -l app=zonewarden

# Query DNS
dig @<bind9-ip> my-api.my-app.apps.example.com A
```

Expected: DNS record points to LoadBalancer IP.
```

---

### 3. Add Examples

Create `examples/_index.md` with real-world examples:

```markdown
---
title: "Examples"
weight: 50
---

# zonewarden Examples

## Example 1: Basic LoadBalancer Service

\`\`\`yaml
# Namespace
apiVersion: v1
kind: Namespace
metadata:
  name: production
  labels:
    cf.rbccm.com/dns-managed: "true"
---
# ServiceDNSConfig
apiVersion: dns.cf.rbccm.com/v1alpha1
kind: ServiceDNSConfig
metadata:
  name: default
  namespace: production
spec:
  zoneRef:
    name: prod.example.com
  recordNameTemplate: "{service}"
---
# Service
apiVersion: v1
kind: Service
metadata:
  name: web
  namespace: production
spec:
  type: LoadBalancer
  ports:
    - port: 80
  selector:
    app: web
\`\`\`

Result: DNS record `web.prod.example.com` → LoadBalancer IP

## Example 2: Multi-cluster with Cluster Name

\`\`\`yaml
apiVersion: dns.cf.rbccm.com/v1alpha1
kind: ServiceDNSConfig
metadata:
  name: multi-cluster
  namespace: production
spec:
  zoneRef:
    name: services.example.com
  recordNameTemplate: "{service}.{cluster}"
  clusterName: "us-west-1"
\`\`\`

Result: DNS record `web.us-west-1.services.example.com`

## Example 3: Selective Services with Labels

\`\`\`yaml
apiVersion: dns.cf.rbccm.com/v1alpha1
kind: ServiceDNSConfig
metadata:
  name: external-only
  namespace: production
spec:
  zoneRef:
    name: external.example.com
  serviceSelector:
    matchLabels:
      expose-dns: "true"
  recordNameTemplate: "{service}"
\`\`\`

Only services with label `expose-dns: "true"` get DNS records.
```

---

### 4. Create Development Documentation

Create `development/_index.md`:

```markdown
---
title: "Development"
weight: 60
---

# Developing zonewarden

## Building

```bash
cargo build --release
```

## Testing

```bash
cargo test
```

## Running Locally

```bash
# Point to local kubeconfig
export BINDY_URL=http://localhost:8080
cargo run
```

## Generating CRD Schema

```bash
cargo run --bin crdgen > deploy/crd-servicednsconfig.yaml
```
```

---

### 5. Set Up Content Mount

Add to `website/config/_default/module.toml`:

```toml
# Mount zonewarden
[[mounts]]
  source = "../zonewarden/docs/hugo"
  target = "content/docs/zonewarden"
```

---

### 6. Add to Website Makefile

Update `website/Makefile`:

```makefile
prepare-all: ## Prepare all project docs
	@echo "Preparing bindy documentation..."
	@cd ../bindy && $(MAKE) docs-hugo-prepare
	@echo "Preparing zonewarden documentation..."
	# zonewarden doesn't have auto-gen docs yet
```

---

## Success Criteria

- [ ] Complete zonewarden documentation section
- [ ] Architecture diagram renders as Mermaid
- [ ] Navigation integrated with main site
- [ ] All examples validate successfully
- [ ] ServiceDNSConfig CRD documented
- [ ] Installation guide tested
- [ ] Configuration reference complete

---

## Deliverables

1. ✅ Hugo directory structure in `zonewarden/docs/hugo/`
2. ✅ Overview and architecture pages
3. ✅ Installation guide
4. ✅ Configuration reference
5. ✅ Usage guide with examples
6. ✅ Development documentation
7. ✅ Content mount configured

---

## Next Phase

**[Phase 3: firestone Documentation →](phase-3-firestone.md)**

Create firestone documentation from README and examples.
