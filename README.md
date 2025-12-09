# Firestoned Website

Official documentation website for the [Firestoned](https://github.com/firestoned) project.

## About

This repository contains the documentation website for **Firestoned** - a toolkit for building API-driven infrastructure. The site provides comprehensive documentation for all Firestoned components:

- **[firestone](https://github.com/firestoned/firestone)** - API specification generator that creates OpenAPI, AsyncAPI, and CLI tools from JSON Schema
- **[firestone-lib](https://github.com/firestoned/firestone-lib)** - Shared library for specification generation
- **[bindy](https://github.com/firestoned/bindy)** - Kubernetes operator for managing BIND9 DNS via CRDs
- **[bindcar](https://github.com/firestoned/bindcar)** - REST API sidecar for BIND9 zone management
- **[zonewarden](https://github.com/firestoned/zonewarden)** - Kubernetes controller for service-to-DNS synchronization
- **[forevd](https://github.com/firestoned/forevd)** - Authentication/authorization proxy (mTLS, OIDC, LDAP)

## Live Site

- **Production**: https://firestoned.io (custom domain)
- **GitHub Pages**: https://firestoned.github.io/website/

## Technology Stack

This website is built with:

- **[Hugo](https://gohugo.io/)** (v0.146.0 Extended) - Static site generator
- **[Docsy](https://www.docsy.dev/)** (v0.13.0) - Documentation theme
- **Dart Sass** - SCSS compilation
- **Bootstrap** - Responsive framework
- **Mermaid** - Diagram rendering

## Local Development

### Prerequisites

- Hugo Extended v0.146.0 or later
- Go 1.23.0 or later (for Hugo modules)
- Node.js and npm (for dependencies)

### Setup

```bash
# Clone the repository
git clone https://github.com/firestoned/website.git
cd website

# Install Node.js dependencies
npm install

# Run the development server
hugo server

# Or use the Makefile
make serve
```

The site will be available at http://localhost:1313

### Building

```bash
# Build the site
hugo --gc --minify

# Output will be in the public/ directory
```

## Content Structure

```
website/
├── content/
│   ├── _index.md              # Homepage
│   └── docs/
│       ├── _index.md          # Documentation landing page
│       ├── getting-started/   # Getting started guide
│       ├── firestone/         # firestone documentation
│       ├── bindy/             # bindy documentation
│       ├── bindcar/           # bindcar documentation
│       ├── zonewarden/        # zonewarden documentation
│       └── forevd/            # forevd documentation
├── layouts/                   # Custom Hugo layouts
├── assets/
│   └── scss/
│       ├── _variables_project.scss  # Theme variables
│       └── _custom.scss            # Custom styles
└── static/                    # Static assets (images, etc.)
```

## Making Changes

### Documentation Content

All documentation is written in Markdown with Hugo/Docsy extensions:

1. Edit files in `content/docs/`
2. Use Hugo shortcodes for special elements (alerts, code blocks, etc.)
3. Test locally with `hugo server`
4. Commit and push to `main` branch

### Styling

1. Edit SCSS in `assets/scss/`
2. Main customizations go in `_custom.scss`
3. Theme color variables in `_variables_project.scss`

### Navigation

- Top navigation: `config/_default/config.toml`
- Sidebar navigation: Auto-generated from content structure
- Footer: `layouts/partials/footer.html`

## Deployment

The site automatically deploys to GitHub Pages when changes are pushed to the `main` branch.

### GitHub Actions Workflow

The deployment is handled by `.github/workflows/deploy-website.yml`:

1. Triggers on push to `main` or manual dispatch
2. Installs Hugo Extended 0.146.0
3. Installs dependencies (Dart Sass, Node.js packages)
4. Builds the site with `hugo --gc --minify`
5. Deploys to GitHub Pages

### Manual Deployment

```bash
# Build the production site
hugo --gc --minify --baseURL "https://firestoned.io/"

# The public/ directory can be deployed to any static hosting
```

## Contributing

To contribute to the documentation:

1. Fork this repository
2. Create a feature branch
3. Make your changes
4. Test locally
5. Submit a pull request

### Documentation Guidelines

- Use clear, concise language
- Include code examples where applicable
- Add diagrams for complex architectures (using Mermaid)
- Follow the existing style and structure
- Test all code examples

## Project Conventions

### Python Package Manager

**Important**: Always use Poetry for Python package management, never pip.

- Installation examples: `poetry add firestoned` (NOT `pip install firestoned`)
- Running commands: `poetry run firestone` (NOT direct `firestone` calls)
- See [CLAUDE.md](../CLAUDE.md) for more details

### Color Scheme

- **Primary**: `#ff6b35` (Orange flame)
- **Secondary**: `#1e3a5f` (Deep navy blue)
- **Dark**: `#333333` (Dark gray)
- **Light**: `#f0f2f5` (Light gray)

## License

This documentation website is part of the Firestoned project and is licensed under the same terms as the main project.

See [LICENSE](LICENSE) for details.

## Support

- **Documentation Issues**: [GitHub Issues](https://github.com/firestoned/website/issues)
- **General Questions**: [GitHub Discussions](https://github.com/firestoned/firestoned/discussions)
- **Firestoned Organization**: https://github.com/firestoned

## Links

- **Main Website**: https://firestoned.io
- **GitHub Organization**: https://github.com/firestoned
- **Documentation**: https://firestoned.io/docs/
