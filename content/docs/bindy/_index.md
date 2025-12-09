---
title: "bindy"
linkTitle: "bindy"
weight: 20
---

# BIND9 DNS Controller for Kubernetes

`bindy` is a high-performance Kubernetes operator written in Rust using kube-rs that manages BIND9 DNS infrastructure through Custom Resource Definitions (CRDs).

[Project Repository](https://github.com/firestoned/firestoned/tree/main/bindy)

## Overview

Bindy is a cloud-native DNS controller that brings declarative DNS management to Kubernetes. It watches for DNS-related CRDs and automatically provisions, configures, and manages BIND9 DNS infrastructure using industry-standard RNDC (Remote Name Daemon Control) protocol for dynamic DNS updates.

## Key Features

- 🚀 **High Performance** - Native Rust with async/await and zero-copy operations
- 🏗️ **Cluster Management** - Manage logical DNS clusters with automatic instance provisioning
- 🔄 **Dynamic DNS Updates** - Real-time record updates via RNDC protocol
- 📝 **Multi-Record Types** - A, AAAA, CNAME, MX, TXT, NS, SRV, CAA records
- 🎯 **Declarative Configuration** - Manage DNS as Kubernetes resources with full GitOps support
- 🔒 **Security First** - Non-root containers, RBAC-ready, mTLS for RNDC communication
- 📊 **Full Observability** - Status tracking, resource annotations, Prometheus metrics
- 🏆 **High Availability** - Leader election support with automatic failover (~15s)
- 🔐 **DNSSEC Support** - Automated DNSSEC key management and zone signing
- 🎨 **Resource Tracking** - Automatic annotations linking records to clusters, instances, and zones

## Architecture

### Custom Resource Definitions (CRDs)

#### Infrastructure Resources

1. **Bind9Cluster** (`bind9clusters.bindy.firestoned.io`) - Logical DNS cluster definition
2. **Bind9Instance** (`bind9instances.bindy.firestoned.io`) - Individual BIND9 server deployment

#### DNS Management Resources

3. **DNSZone** (`dnszones.bindy.firestoned.io`) - DNS zone definition with SOA records

#### DNS Record Types

4. **ARecord** (`arecords.bindy.firestoned.io`) - IPv4 address records
5. **AAAARecord** (`aaaarecords.bindy.firestoned.io`) - IPv6 address records
6. **TXTRecord** (`txtrecords.bindy.firestoned.io`) - Text records (SPF, DKIM, DMARC, etc.)
7. **CNAMERecord** (`cnamerecords.bindy.firestoned.io`) - Canonical name (alias) records
8. **MXRecord** (`mxrecords.bindy.firestoned.io`) - Mail exchanger records
9. **NSRecord** (`nsrecords.bindy.firestoned.io`) - Nameserver delegation records
10. **SRVRecord** (`srvrecords.bindy.firestoned.io`) - Service location records
11. **CAARecord** (`caarecords.bindy.firestoned.io`) - Certificate Authority Authorization records

## Installation

### 1. Create Namespace

```bash
kubectl create namespace dns-system
```

### 2. Install CRDs

```bash
kubectl apply -f https://raw.githubusercontent.com/firestoned/firestoned/main/bindy/deploy/crds/
```

### 3. Create RBAC

```bash
kubectl apply -f https://raw.githubusercontent.com/firestoned/firestoned/main/bindy/deploy/rbac/
```

### 4. Deploy Controller

```bash
kubectl apply -f https://raw.githubusercontent.com/firestoned/firestoned/main/bindy/deploy/operator/deployment.yaml
```

Wait for the controller to be ready:

```bash
kubectl wait --for=condition=available --timeout=300s deployment/bindy -n dns-system
```

## Quick Start: Creating DNS Records

### 1. Create a DNS Cluster

The easiest way to get started is with a `Bind9Cluster`, which automatically manages instances for you:

```yaml
apiVersion: bindy.firestoned.io/v1alpha1
kind: Bind9Cluster
metadata:
  name: my-dns-cluster
  namespace: dns-system
spec:
  primary:
    replicas: 1
```

Apply the cluster: `kubectl apply -f my-dns-cluster.yaml`

### 2. Create a DNS Zone

```yaml
apiVersion: bindy.firestoned.io/v1alpha1
kind: DNSZone
metadata:
  name: example-com
  namespace: dns-system
spec:
  zoneName: example.com
  clusterRef: my-dns-cluster
```

### 3. Add DNS Records

```yaml
---
# A Record
apiVersion: bindy.firestoned.io/v1alpha1
kind: ARecord
metadata:
  name: www-example-com
  namespace: dns-system
spec:
  zoneRef: example-com
  name: www
  ipv4Address: "192.0.2.1"
```

Apply the records: `kubectl apply -f dns-records.yaml`