#!/bin/bash
# create_release_package.sh - Create release package for LLP reference files
# Usage: ./scripts/create_release_package.sh <version>
# Example: ./scripts/create_release_package.sh v1.1

set -e  # Exit on error

# Check arguments
if [ $# -ne 1 ]; then
    echo "Usage: $0 <version>"
    echo "Example: $0 v1.1"
    exit 1
fi

VERSION=$1
RELEASE_TAG="release-${VERSION}"

# Validate version format
if [[ ! $VERSION =~ ^v[0-9]+\.[0-9]+$ ]]; then
    echo "Error: Version must be in format vX.Y (e.g., v1.1)"
    exit 1
fi

# Set paths
REPO_ROOT="$(git rev-parse --show-toplevel)"
RELEASE_DIR="$REPO_ROOT/releases/Release-${VERSION}"
CONFIG_DIR="$RELEASE_DIR/configuration_files"
DOC_DIR="$RELEASE_DIR/documentation"

echo "=========================================="
echo "Creating Release Package: Release-${VERSION}"
echo "=========================================="
echo ""

# Check for uncommitted changes
if [[ -n $(git status -s) ]]; then
    echo "Warning: You have uncommitted changes."
    read -p "Continue anyway? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Aborted."
        exit 1
    fi
fi

# Create release directory structure
echo "Creating release directory structure..."
mkdir -p "$CONFIG_DIR"
mkdir -p "$DOC_DIR"

# Copy configuration files with release naming
echo ""
echo "Copying configuration files..."

# Design file
if [ -f "$REPO_ROOT/panel_v1/design/current.design.bed" ]; then
    cp "$REPO_ROOT/panel_v1/design/current.design.bed" "$CONFIG_DIR/panel_v1_design_Release-${VERSION}.bed"
    echo "  ✓ Design file copied"
else
    echo "  ✗ Warning: Design file not found"
fi

# SVB file
if [ -f "$REPO_ROOT/panel_v1/svb/current_svb.bed" ]; then
    cp "$REPO_ROOT/panel_v1/svb/current_svb.bed" "$CONFIG_DIR/panel_v1_svb_Release-${VERSION}.bed"
    echo "  ✓ SVB file copied"
else
    echo "  ✗ Warning: SVB file not found"
fi

# Hotspot file
if [ -f "$REPO_ROOT/panel_v1/hotspot/current_hotspot.bed" ]; then
    cp "$REPO_ROOT/panel_v1/hotspot/current_hotspot.bed" "$CONFIG_DIR/panel_v1_hotspot_Release-${VERSION}.bed"
    echo "  ✓ Hotspot file copied"
else
    echo "  ✗ Warning: Hotspot file not found"
fi

# Parameters file
if [ -f "$REPO_ROOT/panel_v1/parameters/current.paramters.json" ]; then
    cp "$REPO_ROOT/panel_v1/parameters/current.paramters.json" "$CONFIG_DIR/panel_v1_parameters_Release-${VERSION}.json"
    echo "  ✓ Parameters file copied"
else
    echo "  ✗ Warning: Parameters file not found"
fi

# Generate file manifest
echo ""
echo "Generating file manifest..."

cat > "$DOC_DIR/FILE_MANIFEST_${VERSION}.md" << EOF
# Release ${VERSION} - File Manifest

**Release Date:** $(date +"%Y-%m-%d")  
**Panel:** Liverpool Lymphoid Network Panel v1  
**Release Coordinator:** $(git config user.name)

---

## Configuration Files Included

| File Type   | Release Filename | Source File |
|-------------|------------------|-------------|
| Design      | panel_v1_design_Release-${VERSION}.bed | panel_v1/design/current.design.bed |
| SVB         | panel_v1_svb_Release-${VERSION}.bed | panel_v1/svb/current_svb.bed |
| Hotspot     | panel_v1_hotspot_Release-${VERSION}.bed | panel_v1/hotspot/current_hotspot.bed |
| Parameters  | panel_v1_parameters_Release-${VERSION}.json | panel_v1/parameters/current.paramters.json |

---

## File Versions

The files in this release represent the current state of each configuration type.
Individual file version history is maintained in the archived/ subdirectories.

To trace changes in each file type:
- Design changes: See \`panel_v1/design/archived/\`
- SVB changes: See \`panel_v1/svb/archived/\` and \`documentation/svb_changes/\`
- Hotspot changes: See \`panel_v1/hotspot/archived/\` and \`documentation/hotspot_tracking/\`
- Parameter changes: See \`panel_v1/parameters/archived/\` and \`documentation/parameter_changes/\`

---

## Downstream Usage Guidelines

When using these files in downstream processes:

1. **Maintain Traceability:**
   - Document that files originated from "Release-${VERSION}"
   - Include release version in your tracking systems

2. **File Naming:**
   - You may rename files according to your naming conventions
   - Example: \`ThermoFisher_LLP_SVB_2025Q4.bed\`
   - But preserve "Source: Release-${VERSION}" in your documentation

3. **Version Reference:**
   - Git tag: ${RELEASE_TAG}
   - GitHub Release: https://github.com/greg-tyrelle/llp-reference-files/releases/tag/${RELEASE_TAG}

---

## Support & Questions

For questions about this release or to report issues:
- Contact: Liverpool Lymphoid Network Panel Team
- Repository: https://github.com/greg-tyrelle/llp-reference-files
- Tag Reference: ${RELEASE_TAG}

---

**End of Manifest**
EOF

echo "  ✓ File manifest created"

# Generate release notes (call separate script)
echo ""
echo "Generating release notes..."
if [ -f "$REPO_ROOT/scripts/generate_release_notes.sh" ]; then
    bash "$REPO_ROOT/scripts/generate_release_notes.sh" "$VERSION" > "$DOC_DIR/RELEASE_NOTES_${VERSION}.md"
    echo "  ✓ Release notes generated"
else
    echo "  ✗ Warning: generate_release_notes.sh not found, creating placeholder"
    cat > "$DOC_DIR/RELEASE_NOTES_${VERSION}.md" << EOF
# Release ${VERSION} - Release Notes

**Release Date:** $(date +"%Y-%m-%d")

## Summary

Release ${VERSION} of the Liverpool Lymphoid Network Panel configuration files.

## Changes

Please see the repository commit history and CHANGELOG.md for detailed changes.

\`\`\`bash
git log ${RELEASE_TAG}^..${RELEASE_TAG}
\`\`\`

---

For complete change history: See documentation/CHANGELOG.md
EOF
fi

# Copy relevant documentation
echo ""
echo "Copying documentation..."
if [ -f "$REPO_ROOT/documentation/CHANGELOG.md" ]; then
    cp "$REPO_ROOT/documentation/CHANGELOG.md" "$DOC_DIR/CHANGELOG_${VERSION}.md"
    echo "  ✓ Changelog copied"
fi

if [ -f "$REPO_ROOT/README.md" ]; then
    cp "$REPO_ROOT/README.md" "$DOC_DIR/README.md"
    echo "  ✓ README copied"
fi

# Create README for release package
cat > "$RELEASE_DIR/README.md" << EOF
# Liverpool Lymphoid Network Panel - Release ${VERSION}

**Release Date:** $(date +"%Y-%m-%d")  
**Panel Version:** v1

---

## Package Contents

### Configuration Files (\`configuration_files/\`)
- \`panel_v1_design_Release-${VERSION}.bed\` - Amplicon design file
- \`panel_v1_svb_Release-${VERSION}.bed\` - Sequence Variant Baseline filters
- \`panel_v1_hotspot_Release-${VERSION}.bed\` - Hotspot regions
- \`panel_v1_parameters_Release-${VERSION}.json\` - Variant caller parameters

### Documentation (\`documentation/\`)
- \`RELEASE_NOTES_${VERSION}.md\` - Summary of changes in this release
- \`FILE_MANIFEST_${VERSION}.md\` - File inventory and traceability information
- \`CHANGELOG_${VERSION}.md\` - Complete change history
- \`README.md\` - General project information

---

## Quick Start

1. Extract all files from this release package
2. Use the configuration files in your analysis pipeline
3. Refer to \`FILE_MANIFEST_${VERSION}.md\` for traceability
4. See \`RELEASE_NOTES_${VERSION}.md\` for changes since last release

---

## Compatibility

- **Panel:** Liverpool Lymphoid Network Panel v1
- **Sequencing Platforms:** Ion Genexus, Ion S5
- **Variant Caller:** TVC v5.18+
- **File Formats:** BED (design, SVB, hotspot), JSON (parameters)

---

## Traceability

- **Release Tag:** ${RELEASE_TAG}
- **Repository:** https://github.com/greg-tyrelle/llp-reference-files
- **GitHub Release:** https://github.com/greg-tyrelle/llp-reference-files/releases/tag/${RELEASE_TAG}

---

## Support

For questions or issues with this release:
- See repository documentation
- Contact: Liverpool Lymphoid Network Panel Team

---

**Release ${VERSION} - $(date +"%Y-%m-%d")**
EOF

# Create zip archive
echo ""
echo "Creating zip archive..."
cd "$REPO_ROOT/releases"
zip -r "Release-${VERSION}.zip" "Release-${VERSION}" > /dev/null 2>&1
echo "  ✓ Archive created: releases/Release-${VERSION}.zip"

# Summary
echo ""
echo "=========================================="
echo "Release Package Created Successfully!"
echo "=========================================="
echo ""
echo "Release: Release-${VERSION}"
echo "Location: $RELEASE_DIR"
echo "Archive: $REPO_ROOT/releases/Release-${VERSION}.zip"
echo ""
echo "Next Steps:"
echo "1. Review the release package contents"
echo "2. Create git tag: git tag -a ${RELEASE_TAG} -m 'Release ${VERSION}'"
echo "3. Push tag: git push origin ${RELEASE_TAG}"
echo "4. Create GitHub Release and upload Release-${VERSION}.zip"
echo ""
echo "To create GitHub release:"
echo "  gh release create ${RELEASE_TAG} \\"
echo "    --title 'LLP Panel Configuration Release ${VERSION}' \\"
echo "    --notes-file releases/Release-${VERSION}/documentation/RELEASE_NOTES_${VERSION}.md \\"
echo "    releases/Release-${VERSION}.zip"
echo ""
