# Firestoned Unified Documentation Website

This directory contains the source code and configuration for the unified documentation website for the Firestoned project ecosystem.

## Project Goal

The primary goal of this website is to provide a single, cohesive, and modern documentation experience for all tools and libraries within the `firestoned` monorepo. It is built using the [Hugo](https://gohugo.io/) static site generator and the [Docsy](https://www.docsy.dev/) theme for technical documentation.

## Architecture

This site uses a hybrid architecture where documentation is kept alongside the source code of each individual sub-project. Hugo's [content mounts](https://gohugo.io/hugo-modules/configuration/#module-config-mounts) are used to pull content from each project's `docs/hugo` directory into this central site at build time.

This approach allows for:
-   A single, unified documentation portal.
-   Decentralized ownership, where each project team maintains its own documentation.
-   No duplication of content.

## Implementation Plan

The entire project is broken down into a series of phased milestones, from initial setup to content migration and final deployment. For a complete overview of the project timeline, architecture, and deliverables for each phase, please see the detailed [IMPLEMENTATION_PLAN.md](IMPLEMENTATION_PLAN.md).

## Getting Started

To build and serve the site locally:

1.  **Install Hugo:** Ensure you have the extended version of Hugo (v0.120.0 or later) installed.
2.  **Clone the repository:** Make sure you have cloned the entire `firestoned` monorepo.
3.  **Navigate to the website directory:** `cd website`
4.  **Run the development server:** A `Makefile` is provided for convenience. Run `make server` to start the local Hugo development server.

```bash
# From the root of the firestoned repository
cd website
make server
```

The site will be available at `http://localhost:1313`.

---
*For more details, please refer to the [IMPLEMENTATION_PLAN.md](IMPLEMENTATION_PLAN.md).*
