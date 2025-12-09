# Firestoned Website Artwork

This document describes the artwork assets for the Firestoned website.

## Assets Created

All artwork assets have been saved and are ready for use once the Hugo site is initialized.

### 1. Logo (Primary)

**File:** `static/images/logo.svg`
**Design:** Variation A - K8s Core (Recommended)
**Description:** Kubernetes hexagon with blue flame, representing DNS infrastructure powered by API energy
**Usage:** Navbar logo
**Dark Mode:** Uses `currentColor` for adaptive theming

**Alternative Variations:**
- `static/images/logo-variation-b.svg` - Network Stack design
- `static/images/logo-variation-c.svg` - DNS Hierarchy design

### 2. Favicon

**Files:**
- `static/favicon.svg` - SVG favicon (modern browsers)
- `layouts/partials/favicons.html` - Hugo partial for favicon references

**Note:** A PNG version (`favicon-32x32.png`) will need to be generated from the SVG for older browser support.

**To generate PNG favicon:**
```bash
# Using ImageMagick
convert -background none -density 300 -resize 32x32 website/static/favicon.svg website/static/favicon-32x32.png

# OR using Inkscape
inkscape website/static/favicon.svg --export-type=png --export-filename=website/static/favicon-32x32.png --export-width=32 --export-height=32

# OR use an online converter like https://cloudconvert.com/svg-to-png
```

### 3. Hero Background

**File:** `static/images/hero-background.svg`
**Dimensions:** 1920×1080
**Description:** Subtle hexagonal mesh pattern with blue data connections
**Usage:** Background for landing page hero section

### 4. Social Preview Image

**File:** `static/images/social-preview.svg`
**Dimensions:** 1200×630
**Description:** Dark-themed social media preview with logo, tagline, and network visualization
**Usage:** Open Graph / Twitter Card image

**Note:** Some platforms require PNG format. To convert:
```bash
# Using ImageMagick
convert -background none -density 300 website/static/images/social-preview.svg website/static/images/social-preview.png

# OR using Inkscape
inkscape website/static/images/social-preview.svg --export-type=png --export-filename=website/static/images/social-preview.png --export-width=1200 --export-height=630

# OR use an online converter
```

## Color Scheme

- **Primary Blue:** `#0066cc` - Used for flames, energy, brand elements
- **Dark Gray:** `#333333` - Used for text and structural elements (uses `currentColor` for adaptive theming)
- **White:** `#ffffff` - Light mode text/backgrounds
- **Light Gray:** `#f0f2f5` - Subtle gradients

## Design Principles

- **Adaptive Theming:** Logo uses `currentColor` for elements that should change between light/dark modes
- **Cloud-Native Aesthetic:** Inspired by CNCF projects (Kubernetes, FluxCD, Argo)
- **Scalability:** SVG format ensures crisp rendering at any size
- **Accessibility:** Proper ARIA labels and semantic markup

## Integration Status

✅ All SVG assets created
✅ Favicon partial created
⏳ Waiting for Hugo site initialization (Phase 0, Tasks 1-10)
⏳ Configuration updates needed (Phase 0, Task 11)

## Next Steps

1. Complete Hugo site initialization (Phase 0, Tasks 1-10)
2. Update `config/_default/params.toml` to reference the logo
3. Generate PNG versions of favicon and social preview
4. Test the site with artwork
5. Deploy to GitHub Pages

## Credits

Artwork generated using AI with the following prompt concept:
- Fire + Stone metaphor (energy + foundation)
- Kubernetes hexagon integration
- DNS infrastructure representation
- Modern, technical, professional aesthetic
