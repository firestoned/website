---
title: "Firestoned"
linkTitle: "Home"
---

{{< blocks/cover title="Firestoned" image_anchor="top" height="full" >}}
<div class="mx-auto">
  <p class="lead mt-5">API-driven infrastructure management for Kubernetes</p>
  <a class="btn btn-lg btn-primary me-3 mb-4" href="docs/">
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
    Firestoned is a toolkit for building API-driven infrastructure, centered around
    <strong>firestone</strong> - an innovative API specification generator that creates OpenAPI,
    AsyncAPI, and CLI tools from JSON Schema resource definitions. The ecosystem includes
    Kubernetes-native DNS management utilities that demonstrate infrastructure-as-code principles.
  </p>
</div>
{{< /blocks/section >}}

{{< blocks/section >}}
<div class="col-lg-4 mb-5">
  <div class="h-100">
    <h3>🔥 firestone</h3>
    <p><strong>Core:</strong> Generate OpenAPI/AsyncAPI specs and CLI tools from JSON Schema. Define your resources once, generate everything else.</p>
    <a href="docs/firestone/">Learn more →</a>
  </div>
</div>

<div class="col-lg-4 mb-5">
  <div class="h-100">
    <h3>🏗️ bindy</h3>
    <p><strong>DNS Operator:</strong> Kubernetes operator managing BIND9 DNS through Custom Resource Definitions</p>
    <a href="docs/bindy/">Learn more →</a>
  </div>
</div>

<div class="col-lg-4 mb-5">
  <div class="h-100">
    <h3>🚗 bindcar</h3>
    <p><strong>DNS API:</strong> REST API sidecar for BIND9 zone management via RNDC protocol</p>
    <a href="docs/bindcar/">Learn more →</a>
  </div>
</div>

<div class="col-lg-4 mb-5">
  <div class="h-100">
    <h3>🛡️ zonewarden</h3>
    <p><strong>DNS Automation:</strong> Kubernetes controller for automatic service-to-DNS synchronization</p>
    <a href="docs/zonewarden/">Learn more →</a>
  </div>
</div>
{{< /blocks/section >}}