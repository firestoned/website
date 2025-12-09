#!/bin/bash
set -e

echo "🧪 Testing Firestoned Documentation Site"
echo "========================================"

# Test 1: Hugo build succeeds
echo "✓ Test 1: Hugo build validation"
hugo --quiet --minify
echo "  ✅ Build successful"

# Test 2: Check for broken internal links
echo ""
echo "✓ Test 2: Internal link validation"
if command -v grep &> /dev/null; then
    # Check for common broken link patterns in generated HTML
    broken_links=$(find public -name "*.html" -exec grep -l "404\.html" {} \; 2>/dev/null || true)
    if [ -z "$broken_links" ]; then
        echo "  ✅ No obvious broken links detected"
    else
        echo "  ⚠️  Potential broken links found"
        echo "$broken_links"
    fi
fi

# Test 3: Verify required pages exist
echo ""
echo "✓ Test 3: Required pages exist"
required_pages=(
    "public/index.html"
    "public/docs/index.html"
    "public/docs/getting-started/index.html"
    "public/docs/firestone/index.html"
    "public/docs/bindy/index.html"
    "public/docs/bindcar/index.html"
    "public/docs/zonewarden/index.html"
)

all_exist=true
for page in "${required_pages[@]}"; do
    if [ ! -f "$page" ]; then
        echo "  ❌ Missing: $page"
        all_exist=false
    fi
done

if [ "$all_exist" = true ]; then
    echo "  ✅ All required pages present"
fi

# Test 4: Check for color palette usage
echo ""
echo "✓ Test 4: Brand colors present"
if grep -q "#ff6b35" public/index.html && grep -q "#1e3a5f" public/index.html; then
    echo "  ✅ Orange (#ff6b35) and Navy (#1e3a5f) colors found"
else
    echo "  ⚠️  Brand colors may not be applied correctly"
fi

# Test 5: Verify firestone is emphasized
echo ""
echo "✓ Test 5: Firestone-centric content"
if grep -q "firestone" public/docs/index.html && grep -q "API" public/docs/index.html; then
    echo "  ✅ Firestone and API-focused content present"
else
    echo "  ⚠️  Content focus may need review"
fi

echo ""
echo "========================================"
echo "🎉 Site validation complete!"
echo ""
echo "To run a full link check, install htmltest:"
echo "  brew install htmltest  # macOS"
echo "  # or download from https://github.com/wjdp/htmltest"
echo "  htmltest"
