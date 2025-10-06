#!/bin/bash
# generate_release_notes.sh - Generate release notes from git commits
# Usage: ./scripts/generate_release_notes.sh <version> [previous_tag]
# Example: ./scripts/generate_release_notes.sh v1.1 release-v1.0

VERSION=$1
PREVIOUS_TAG=$2

# If no previous tag specified, try to find the most recent release tag
if [ -z "$PREVIOUS_TAG" ]; then
    PREVIOUS_TAG=$(git tag -l "release-v*" --sort=-version:refname | head -1)
    if [ -z "$PREVIOUS_TAG" ]; then
        # No previous release, use all history
        COMMIT_RANGE="HEAD"
    else
        COMMIT_RANGE="${PREVIOUS_TAG}..HEAD"
    fi
else
    COMMIT_RANGE="${PREVIOUS_TAG}..HEAD"
fi

# Generate release notes
cat << EOF
# Release ${VERSION} - Release Notes

**Release Date:** $(date +"%Y-%m-%d")  
**Panel:** Liverpool Lymphoid Network Panel v1

---

## Summary

Release ${VERSION} includes configuration file updates for improved variant calling performance.

EOF

# Check if there are any commits
if [ "$COMMIT_RANGE" = "HEAD" ]; then
    echo "## Changes Since Repository Creation"
    echo ""
else
    echo "## Changes Since ${PREVIOUS_TAG}"
    echo ""
fi

# Configuration file changes
echo "### Configuration File Changes"
echo ""

# SVB changes
SVB_CHANGES=$(git log $COMMIT_RANGE --oneline --grep="SVB ADD:\|SVB REMOVE:\|SVB MODIFY:\|SVB VALIDATE:" 2>/dev/null)
if [ -n "$SVB_CHANGES" ]; then
    echo "**Sequence Variant Baseline (SVB):**"
    echo "$SVB_CHANGES" | while read line; do
        echo "- $line"
    done
    echo ""
fi

# Hotspot changes
HOTSPOT_CHANGES=$(git log $COMMIT_RANGE --oneline --grep="HOTSPOT ADD:\|HOTSPOT REMOVE:\|HOTSPOT MODIFY:\|HOTSPOT UPDATE:\|HOTSPOT RESTRUCTURE:" 2>/dev/null)
if [ -n "$HOTSPOT_CHANGES" ]; then
    echo "**Hotspot Files:**"
    echo "$HOTSPOT_CHANGES" | while read line; do
        echo "- $line"
    done
    echo ""
fi

# Parameter changes
PARAM_CHANGES=$(git log $COMMIT_RANGE --oneline --grep="PARAMETER OPTIMIZE:\|PARAMETER RELAX:\|PARAMETER TIGHTEN:\|PARAMETER CORRECT:\|PARAMETER UPDATE:" 2>/dev/null)
if [ -n "$PARAM_CHANGES" ]; then
    echo "**Parameters:**"
    echo "$PARAM_CHANGES" | while read line; do
        echo "- $line"
    done
    echo ""
fi

# Design changes
DESIGN_CHANGES=$(git log $COMMIT_RANGE --oneline --grep="DESIGN MASK:\|DESIGN UPDATE:\|DESIGN MODIFY:\|DESIGN RESTRUCTURE:" 2>/dev/null)
if [ -n "$DESIGN_CHANGES" ]; then
    echo "**Design Files:**"
    echo "$DESIGN_CHANGES" | while read line; do
        echo "- $line"
    done
    echo ""
fi

# Documentation changes
echo "### Documentation & Repository Changes"
echo ""
DOC_CHANGES=$(git log $COMMIT_RANGE --oneline --grep="DOC:\|README\|REPO:" 2>/dev/null)
if [ -n "$DOC_CHANGES" ]; then
    echo "$DOC_CHANGES" | while read line; do
        echo "- $line"
    done
    echo ""
else
    echo "- No documentation changes"
    echo ""
fi

# Detailed changes section
cat << EOF
---

## Detailed Changes

For detailed information about each change, see:
- \`documentation/CHANGELOG.md\` - Complete change history
- \`documentation/svb_changes/\` - SVB filter rationale and validation
- \`documentation/hotspot_tracking/\` - Hotspot modification details
- \`documentation/parameter_changes/\` - Parameter optimization documentation

EOF

# Commit list
echo "### All Commits in This Release"
echo ""
echo "\`\`\`"
git log $COMMIT_RANGE --oneline 2>/dev/null || echo "No commits found"
echo "\`\`\`"
echo ""

# Statistics
cat << EOF
---

## Statistics

EOF

# Count changes
SVB_ADD_COUNT=$(git log $COMMIT_RANGE --oneline --grep="SVB ADD:" 2>/dev/null | wc -l)
SVB_REMOVE_COUNT=$(git log $COMMIT_RANGE --oneline --grep="SVB REMOVE:" 2>/dev/null | wc -l)
HOTSPOT_COUNT=$(git log $COMMIT_RANGE --oneline --grep="HOTSPOT ADD:\|HOTSPOT REMOVE:\|HOTSPOT MODIFY:" 2>/dev/null | wc -l)
PARAM_COUNT=$(git log $COMMIT_RANGE --oneline --grep="PARAMETER" 2>/dev/null | wc -l)
DESIGN_COUNT=$(git log $COMMIT_RANGE --oneline --grep="DESIGN" 2>/dev/null | wc -l)

echo "- SVB filters added: $SVB_ADD_COUNT"
echo "- SVB filters removed: $SVB_REMOVE_COUNT"
echo "- Hotspot changes: $HOTSPOT_COUNT"
echo "- Parameter optimizations: $PARAM_COUNT"
echo "- Design changes: $DESIGN_COUNT"

cat << EOF

---

## Files Included

This release includes:
- \`panel_v1_design_Release-${VERSION}.bed\`
- \`panel_v1_svb_Release-${VERSION}.bed\`
- \`panel_v1_hotspot_Release-${VERSION}.bed\`
- \`panel_v1_parameters_Release-${VERSION}.json\`

See \`FILE_MANIFEST_${VERSION}.md\` for complete file inventory and traceability.

---

## Compatibility

- **Panel:** Liverpool Lymphoid Network Panel v1
- **Platforms:** Ion Genexus, Ion S5
- **Variant Caller:** TVC v5.18+
- **Reference Genome:** hg19/GRCh37

---

## Known Issues

None reported for this release.

---

## References

- **Repository:** https://github.com/greg-tyrelle/llp-reference-files
- **Release Tag:** release-${VERSION}
- **Previous Release:** ${PREVIOUS_TAG:-None (initial release)}

For questions or support, contact the Liverpool Lymphoid Network Panel team.

---

**Release ${VERSION} - $(date +"%Y-%m-%d")**
EOF
