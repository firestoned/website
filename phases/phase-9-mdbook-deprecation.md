# Phase 9: mdBook Deprecation (Week 11)

**Status:** Not Started
**Owner:** TBD
**Duration:** 1 week
**Depends On:** Phase 8 (Deployment)

---

## Goal

Complete the migration from mdBook to Hugo as the primary documentation system.

---

## Tasks

### 1. Add Deprecation Notices to mdBook Sites

#### 1.1 bindy mdBook

Edit `bindy/docs/src/introduction.md`:

```markdown
> **⚠️ DEPRECATION NOTICE**
>
> This mdBook documentation site is deprecated. Please visit the new Hugo-based documentation at:
>
> **https://firestoned.io/docs/bindy/**
>
> This mdBook site will be removed in a future release.

# bindy

...existing content...
```

#### 1.2 bindcar mdBook

Similar notice in `bindcar/docs/src/introduction.md`:

```markdown
> **⚠️ DEPRECATION NOTICE**
>
> This mdBook documentation site is deprecated. Please visit:
>
> **https://firestoned.io/docs/bindcar/**
```

---

### 2. Update Project READMEs

#### 2.1 bindy README.md

Update links:

```markdown
## Documentation

**📖 Full documentation**: https://firestoned.io/docs/bindy/

- [Installation](https://firestoned.io/docs/bindy/installation/)
- [Quick Start](https://firestoned.io/docs/bindy/installation/quickstart/)
- [User Guide](https://firestoned.io/docs/bindy/guide/)
- [API Reference](https://firestoned.io/docs/bindy/reference/api/)
- [Rust API Docs](https://firestoned.io/api/bindy/rustdoc/bindy/)

### Legacy Documentation

The old mdBook site at `docs/src/` is deprecated. Use the link above for current documentation.
```

#### 2.2 Other Projects

Update READMEs for bindcar, zonewarden, firestone, forevd similarly.

---

### 3. Update CI/CD Pipelines

#### 3.1 Remove mdBook Builds (Optional)

If you want to fully deprecate mdBook, remove from CI:

Edit `.github/workflows/bindy.yaml` (if exists):

```yaml
# REMOVE or comment out mdBook build steps:
# - name: Build mdBook docs
#   run: cd docs && mdbook build
```

**OR** keep mdBook as backup:

```yaml
# Keep building mdBook but add deprecation notice
- name: Build legacy mdBook docs
  run: |
    cd docs
    mdbook build
    echo "DEPRECATED: Use https://firestoned.io/docs/bindy/" > target/DEPRECATED.txt
```

---

### 4. Add Redirects

#### 4.1 GitHub Pages Redirects

If users have bookmarked old mdBook URLs, add redirects.

Create `website/layouts/index.redirects`:

```
# Redirect old mdBook URLs to Hugo
/bindy/docs/*  /docs/bindy/:splat  301
/bindcar/docs/*  /docs/bindcar/:splat  301
```

---

### 5. Monitor for Issues

#### 5.1 Check for Broken Links

Run link checker:

```bash
npm install -g broken-link-checker
blc https://firestoned.io -ro
```

Fix any broken links found.

#### 5.2 Monitor User Feedback

- Watch GitHub issues for documentation complaints
- Monitor website analytics for 404 errors
- Check search queries for missing content

---

### 6. Archive mdBook Sites (Optional)

If completely removing mdBook:

```bash
# Create archive branch
git checkout -b archive/mdbook-docs
git add bindy/docs/src bindcar/docs/src
git commit -m "Archive mdBook documentation"
git push origin archive/mdbook-docs

# Remove from main
git checkout main
git rm -r bindy/docs/src bindcar/docs/src
git commit -m "Remove deprecated mdBook sites"
```

**OR** keep in repo but clearly marked:

```bash
# Add README to docs/src/
echo "# DEPRECATED - See https://firestoned.io/docs/" > bindy/docs/src/DEPRECATED.md
```

---

### 7. Update Build Scripts

#### 7.1 Remove mdBook from Makefiles

Edit `bindy/Makefile`:

```makefile
# REMOVE or comment out:
# docs: docs-mdbook
# docs-serve: docs-mdbook-serve

# KEEP:
docs-hugo-prepare: ## Prepare for Hugo build
	# ... existing target
```

#### 7.2 Update Documentation Commands

Update any documentation in scripts/README files that reference mdBook commands.

---

### 8. Announce Migration

#### 8.1 Blog Post

Create `website/content/blog/documentation-migration.md`:

```markdown
---
title: "New Documentation Site Launched"
date: 2025-12-04
---

# New Documentation Site Launched

We're excited to announce our new unified documentation site at https://firestoned.io!

## What's New

- **Unified navigation** across all Firestoned projects
- **Better search** - find content across all projects
- **Improved mobile experience**
- **Faster page loads**
- **Dark mode support** (coming soon!)

## Migration from mdBook

All documentation has been migrated from mdBook to Hugo with the Docsy theme. The old mdBook sites are deprecated and will be removed in a future release.

## Feedback

We'd love to hear your feedback! Please open an issue on GitHub if you find any problems.
```

#### 8.2 GitHub Release

Create a release announcing the new docs:

```markdown
## Documentation Site Launch 🎉

We've launched a new unified documentation site at https://firestoned.io!

All project documentation is now available in one place with improved search, navigation, and mobile experience.

### Changes

- Migrated from mdBook to Hugo + Docsy theme
- Unified documentation for all Firestoned projects
- Improved search across all content
- Better mobile responsiveness

### Deprecated

- mdBook sites in `docs/src/` are now deprecated
- Please update any bookmarks to https://firestoned.io
```

---

### 9. Final Cleanup

#### 9.1 Remove Obsolete Files

```bash
# Remove mdBook configuration if no longer needed
rm bindy/docs/book.toml bindcar/docs/book.toml

# Remove mdBook themes
rm -rf bindy/docs/theme bindcar/docs/theme
```

#### 9.2 Update .gitignore

```
# Add to .gitignore if removing mdBook
docs/target/
```

---

## Success Criteria

- [ ] Deprecation notices added to mdBook sites
- [ ] Project READMEs updated with new doc links
- [ ] CI/CD updated (mdBook builds removed or marked deprecated)
- [ ] Redirects configured for old URLs
- [ ] No broken links on new site
- [ ] User feedback monitored
- [ ] Migration announced (blog post, release notes)
- [ ] Obsolete files cleaned up

---

## Rollback Plan

If critical issues are discovered:

1. **Keep mdBook sites running** - Don't delete until migration proven successful
2. **Fix issues in Hugo site** - Address problems offline
3. **Use both temporarily** - mdBook as fallback while fixing Hugo
4. **Gradual deprecation** - Extend deprecation period if needed

---

## Post-Migration Tasks

### Week 12+

- Monitor website analytics
- Gather user feedback
- Fix any issues discovered
- Optimize content based on search queries
- Plan future documentation improvements

---

## Deliverables

1. ✅ mdBook sites deprecated
2. ✅ All links updated to Hugo site
3. ✅ No broken links
4. ✅ Migration announced
5. ✅ Hugo site is primary documentation
6. ✅ User feedback positive

---

## Migration Complete! 🎉

The Hugo documentation site is now the primary documentation for all Firestoned projects.

Future documentation updates should be made in the `docs/hugo/` directories, not mdBook.
