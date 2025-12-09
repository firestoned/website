---
title: "Documentation"
linkTitle: "Documentation"
---

<div class="docs-hero">
  <p class="lead">API-driven infrastructure management for Kubernetes</p>
  <div class="mt-4">
    <a class="btn btn-lg btn-primary me-3" href="/website/docs/getting-started/">Get Started →</a>
    <a class="btn btn-lg btn-outline-secondary" href="https://github.com/firestoned">View on GitHub</a>
  </div>
</div>

---

## Quick Start

Get up and running in minutes:

{{% alert title="💡 Fastest Path" color="info" %}}
1. **Install firestone** - `poetry add firestoned`
2. **Define your resource** - Create a JSON Schema for your API resource
3. **Generate your API** - Create OpenAPI specs, CLIs, and client code automatically

**[Follow the Firestone Guide →](/website/docs/firestone/)**
{{% /alert %}}

---

## Core Components

{{< cardpane >}}
{{< card header="<strong>firestone</strong> (Core)" footer="[Learn more →](/website/docs/firestone/)" >}}
<div style="text-align: center; font-size: 3em; margin: 20px 0;">🔥</div>

<strong>API Specification Generator</strong>

The heart of Firestoned. Generate OpenAPI, AsyncAPI specs, and CLI tools from JSON Schema resource definitions. Define your resources once, generate everything else automatically.

<strong>Key Features:</strong>
- JSON Schema based workflow
- OpenAPI 3.x & AsyncAPI generation
- Python Click CLI generation
- Code generation via openapi-generator
{{< /card >}}

{{< card header="<strong>firestone-lib</strong>" footer="[Learn more →](/website/docs/firestone/)" >}}
<div style="text-align: center; font-size: 3em; margin: 20px 0;">📚</div>

<strong>Shared Library</strong>

Core library powering firestone and forevd. Provides reusable components for spec generation, validation, and transformation.

<strong>Use Cases:</strong>
- Build custom generators
- Embed in your tools
- Extend functionality
- API automation
{{< /card >}}

{{< card header="<strong>bindy</strong>" footer="[Learn more →](/website/docs/bindy/)" >}}
<div style="text-align: center; font-size: 3em; margin: 20px 0;">🏗️</div>

<strong>Kubernetes DNS Operator</strong>

Kubernetes-native BIND9 DNS management through CRDs. Demonstrates infrastructure-as-code principles with declarative, GitOps-ready DNS.

<strong>Key Features:</strong>
- High-performance Rust operator
- Full DNS record type support
- DNSSEC automation
- High availability
{{< /card >}}
{{< /cardpane >}}

{{< cardpane >}}
{{< card header="<strong>bindcar</strong>" footer="[Learn more →](/website/docs/bindcar/)" >}}
<div style="text-align: center; font-size: 3em; margin: 20px 0;">🚗</div>

<strong>BIND9 REST API Sidecar</strong>

REST API for BIND9 zone management. Translates HTTP requests into RNDC commands with built-in authentication and Prometheus metrics.

<strong>Key Features:</strong>
- OpenAPI/Swagger documentation
- ServiceAccount token auth
- Real-time zone operations
- Metrics and monitoring
{{< /card >}}

{{< card header="<strong>zonewarden</strong>" footer="[Learn more →](/website/docs/zonewarden/)" >}}
<div style="text-align: center; font-size: 3em; margin: 20px 0;">🛡️</div>

<strong>Service-to-DNS Sync</strong>

Kubernetes controller for automatic DNS record creation. Watch namespaces, sync IPs, and maintain service discovery across clusters.

<strong>Key Features:</strong>
- Automatic DNS registration
- Multi-cluster support
- LoadBalancer integration
- Linkerd mesh ready
{{< /card >}}
{{< /cardpane >}}

---

## Architecture Overview

Understanding how the components work together:

```mermaid
graph TB
    subgraph "Development"
        firestone[firestone<br/>API Generator]
    end

    subgraph "Kubernetes Cluster"
        kubectl[kubectl apply]
        crds[DNS CRDs<br/>Zones & Records]
        bindy[bindy<br/>DNS Operator]
        zonewarden[zonewarden<br/>Service Watcher]
        svc[Kubernetes Services]
    end

    subgraph "DNS Infrastructure"
        forevd[forevd<br/>Auth Proxy]
        bindcar[bindcar<br/>REST API]
        bind9[BIND9<br/>DNS Server]
    end

    firestone -.API Spec.-> bindcar
    kubectl --> crds
    crds --> bindy
    svc --> zonewarden
    zonewarden --> bindy
    bindy --> forevd
    forevd --> bindcar
    bindcar --> bind9

    style bindy fill:#0066cc,color:#fff
    style bindcar fill:#0066cc,color:#fff
    style zonewarden fill:#0066cc,color:#fff
    style firestone fill:#ff6b35,color:#fff
    style forevd fill:#333,color:#fff
```

**[Getting Started Guide →](/website/docs/getting-started/)**

---

## Why Firestoned?

{{% blocks/section color="white" %}}
<div class="col-lg-4">
<h3>🎯 API-First Development</h3>
<p>Define infrastructure resources once using JSON Schema. Automatically generate OpenAPI specs, AsyncAPI specs, CLIs, and client libraries. No manual API coding required.</p>
</div>

<div class="col-lg-4">
<h3>📐 Schema-Driven Consistency</h3>
<p>Single source of truth ensures your API specs, documentation, validation logic, and client code stay in perfect sync. Change the schema, regenerate everything.</p>
</div>

<div class="col-lg-4">
<h3>🔧 Developer Experience</h3>
<p>From resource definition to working API in minutes. Includes practical Kubernetes-native examples showing real-world infrastructure-as-code patterns.</p>
</div>
{{% /blocks/section %}}

---

## Getting Started

Ready to build API-driven infrastructure? Choose your path:

<div style="display: flex; gap: 20px; margin: 30px 0;">
  <div style="flex: 1; padding: 20px; border: 2px solid #ff6b35; border-radius: 8px; background: linear-gradient(135deg, #fff5f0 0%, #ffffff 100%);">
    <h3>🚀 Complete Guide</h3>
    <p>New to Firestoned? Start here for a comprehensive walkthrough from installation to your first API.</p>
    <p><strong><a href="/website/docs/getting-started/">Getting Started Guide →</a></strong></p>
  </div>

  <div style="flex: 1; padding: 20px; border: 2px solid #ff6b35; border-radius: 8px;">
    <h3>📖 Component Docs</h3>
    <p>Jump directly to documentation for specific components:</p>
    <p><strong><a href="/website/docs/firestone/">firestone</a> | <a href="/website/docs/bindy/">bindy</a> | <a href="/website/docs/bindcar/">bindcar</a></strong></p>
  </div>

  <div style="flex: 1; padding: 20px; border: 2px solid #ff6b35; border-radius: 8px;">
    <h3>💬 Community</h3>
    <p>Get help, report issues, or contribute to the project on GitHub.</p>
    <p><strong><a href="https://github.com/firestoned/firestoned">GitHub Repository →</a></strong></p>
  </div>
</div>