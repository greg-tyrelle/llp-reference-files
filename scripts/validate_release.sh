#!/bin/bash
# validate_release.sh - Basic validation checks for release package
# Usage: ./scripts/validate_release.sh <version>
# Example: ./scripts/validate_release.sh v1.1

set -e

VERSION=$1

if [ -z "$VERSION" ]; then
    echo "Usage: $0 <version>"
    echo "Example: $0 v1.1"
    exit 1
fi

REPO_ROOT="$(git rev-parse --show-toplevel)"
RELEASE_DIR="$REPO_ROOT/releases/Release-${VERSION}"
CONFIG_DIR="$RELEASE_DIR/configuration_files"
DOC_DIR="$RELEASE_DIR/documentation"

echo "=========================================="
echo "Validating Release Package: Release-${VERSION}"
echo "=========================================="
echo ""

# Check if release directory exists
if [ ! -d "$RELEASE_DIR" ]; then
    echo "✗ Error: Release directory not found: $RELEASE_DIR"
    exit 1
fi
echo "✓ Release directory exists"

# Check configuration files
echo ""
echo "Checking configuration files..."
MISSING_FILES=0

if [ -f "$CONFIG_DIR/panel_v1_design_Release-${VERSION}.bed" ]; then
    echo "  ✓ Design file present"
else
    echo "  ✗ Design file missing"
    MISSING_FILES=$((MISSING_FILES + 1))
fi

if [ -f "$CONFIG_DIR/panel_v1_svb_Release-${VERSION}.bed" ]; then
    echo "  ✓ SVB file present"
else
    echo "  ✗ SVB file missing"
    MISSING_FILES=$((MISSING_FILES + 1))
fi

if [ -f "$CONFIG_DIR/panel_v1_hotspot_Release-${VERSION}.bed" ]; then
    echo "  ✓ Hotspot file present"
else
    echo "  ✗ Hotspot file missing"
    MISSING_FILES=$((MISSING_FILES + 1))
fi

if [ -f "$CONFIG_DIR/panel_v1_parameters_Release-${VERSION}.json" ]; then
    echo "  ✓ Parameters file present"
else
    echo "  ✗ Parameters file missing"
    MISSING_FILES=$((MISSING_FILES + 1))
fi

# Check documentation files
echo ""
echo "Checking documentation files..."

if [ -f "$DOC_DIR/RELEASE_NOTES_${VERSION}.md" ]; then
    echo "  ✓ Release notes present"
else
    echo "  ✗ Release notes missing"
    MISSING_FILES=$((MISSING_FILES + 1))
fi

if [ -f "$DOC_DIR/FILE_MANIFEST_${VERSION}.md" ]; then
    echo "  ✓ File manifest present"
else
    echo "  ✗ File manifest missing"
    MISSING_FILES=$((MISSING_FILES + 1))
fi

# Basic file format validation (placeholder for future enhancements)
echo ""
echo "Validating file formats..."

# Check BED files have content
for bedfile in "$CONFIG_DIR"/*.bed; do
    if [ -f "$bedfile" ]; then
        LINE_COUNT=$(wc -l < "$bedfile")
        if [ "$LINE_COUNT" -gt 0 ]; then
            echo "  ✓ $(basename $bedfile): $LINE_COUNT lines"
        else
            echo "  ✗ $(basename $bedfile): empty file"
            MISSING_FILES=$((MISSING_FILES + 1))
        fi
    fi
done

# Check JSON file is valid (basic check)
if [ -f "$CONFIG_DIR/panel_v1_parameters_Release-${VERSION}.json" ]; then
    if python3 -m json.tool "$CONFIG_DIR/panel_v1_parameters_Release-${VERSION}.json" > /dev/null 2>&1; then
        echo "  ✓ Parameters JSON is valid"
    else
        echo "  ✗ Parameters JSON is invalid"
        MISSING_FILES=$((MISSING_FILES + 1))
    fi
fi

# Check for zip archive
echo ""
echo "Checking release archive..."
if [ -f "$REPO_ROOT/releases/Release-${VERSION}.zip" ]; then
    ZIP_SIZE=$(du -h "$REPO_ROOT/releases/Release-${VERSION}.zip" | cut -f1)
    echo "  ✓ Release archive exists (size: $ZIP_SIZE)"
else
    echo "  ✗ Release archive missing"
    MISSING_FILES=$((MISSING_FILES + 1))
fi

# Summary
echo ""
echo "=========================================="
if [ $MISSING_FILES -eq 0 ]; then
    echo "✓ Validation PASSED"
    echo "=========================================="
    echo ""
    echo "Release package is ready for distribution."
    echo ""
    echo "Next steps:"
    echo "1. Create git tag: git tag -a release-${VERSION} -m 'Release ${VERSION}'"
    echo "2. Push tag: git push origin release-${VERSION}"
    echo "3. Create GitHub release and upload Release-${VERSION}.zip"
    echo ""
    exit 0
else
    echo "✗ Validation FAILED"
    echo "=========================================="
    echo ""
    echo "Found $MISSING_FILES issue(s). Please review and fix before releasing."
    echo ""
    exit 1
fi

# Placeholder for future validation enhancements:
# - BED file column validation
# - Cross-file consistency checks
# - Validation cohort results
# - Platform compatibility checks
