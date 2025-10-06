#!/bin/bash
# generate_changelog.sh - Generate comprehensive changelog for LLP reference files

# Set repository root
REPO_ROOT="$(git rev-parse --show-toplevel)"
OUTPUT_FILE="$REPO_ROOT/documentation/CHANGELOG.md"

echo "# Liverpool Lymphoid Network Panel - Change Log" > "$OUTPUT_FILE"
echo "Generated: $(date)" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Table of Contents / Summary Section
echo "## Summary of Changes" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
echo "### Configuration File Changes" >> "$OUTPUT_FILE"
git log --oneline --grep="SVB ADD:\|SVB REMOVE:\|SVB MODIFY:\|SVB VALIDATE:\|PARAMETER OPTIMIZE:\|PARAMETER RELAX:\|PARAMETER TIGHTEN:\|PARAMETER CORRECT:\|PARAMETER UPDATE:\|HOTSPOT ADD:\|HOTSPOT REMOVE:\|HOTSPOT MODIFY:\|HOTSPOT UPDATE:\|HOTSPOT RESTRUCTURE:\|DESIGN MASK:\|DESIGN UPDATE:\|DESIGN MODIFY:" \
    --format="- **%ad** - %s" --date=short -20 >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

echo "### System & Documentation Changes" >> "$OUTPUT_FILE"
git log --oneline --grep="DOC:\|README\|REPO:\|RELEASE:" \
    --format="- **%ad** - %s" --date=short -20 >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
echo "---" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Detailed Recent Changes Section
echo "## Detailed Change History" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Function to generate category sections (compatible with older bash)
generate_category_section() {
    local display_name="$1"
    local pattern="$2"
    
    echo "## $display_name" >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
    
    # Get commits matching this category
    if git log --grep="$(echo $pattern | cut -d'|' -f1)" --oneline | head -1 > /dev/null 2>&1; then
        git log --grep="$pattern" --extended-regexp --format="### %s%n**Date:** %ad | **Author:** %an%n%n%b%n---" --date=short -10 >> "$OUTPUT_FILE"
    else
        echo "*No commits found for this category.*" >> "$OUTPUT_FILE"
    fi
    echo "" >> "$OUTPUT_FILE"
}

# Generate sections for each category
echo "### Configuration File Changes" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
generate_category_section "SVB Filter Changes" "SVB ADD:|SVB REMOVE:|SVB MODIFY:|SVB VALIDATE:"
generate_category_section "Parameter Optimizations" "PARAMETER OPTIMIZE:|PARAMETER RELAX:|PARAMETER TIGHTEN:|PARAMETER CORRECT:|PARAMETER UPDATE:"
generate_category_section "Hotspot Management" "HOTSPOT ADD:|HOTSPOT REMOVE:|HOTSPOT MODIFY:|HOTSPOT UPDATE:|HOTSPOT RESTRUCTURE:"
generate_category_section "Design File Changes" "DESIGN MASK:|DESIGN UPDATE:|DESIGN MODIFY:|DESIGN RESTRUCTURE:"

echo "### System & Repository Changes" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
generate_category_section "Release Management" "RELEASE:"
generate_category_section "Documentation Updates" "DOC:|README"
generate_category_section "Repository Structure" "REPO:"

# Statistics Section  
echo "## Repository Statistics" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
echo "### Configuration Changes" >> "$OUTPUT_FILE"
echo "- **SVB filters added:** $(git log --oneline --grep="SVB ADD:" | wc -l)" >> "$OUTPUT_FILE"
echo "- **SVB filters removed:** $(git log --oneline --grep="SVB REMOVE:" | wc -l)" >> "$OUTPUT_FILE"
echo "- **SVB filters modified:** $(git log --oneline --grep="SVB MODIFY:" | wc -l)" >> "$OUTPUT_FILE"
echo "- **Parameter optimizations:** $(git log --oneline --grep="PARAMETER OPTIMIZE:\|PARAMETER RELAX:\|PARAMETER TIGHTEN:\|PARAMETER CORRECT:\|PARAMETER UPDATE:" | wc -l)" >> "$OUTPUT_FILE"
echo "- **Hotspot changes:** $(git log --oneline --grep="HOTSPOT ADD:\|HOTSPOT REMOVE:\|HOTSPOT MODIFY:\|HOTSPOT UPDATE:\|HOTSPOT RESTRUCTURE:" | wc -l)" >> "$OUTPUT_FILE"
echo "- **Design changes:** $(git log --oneline --grep="DESIGN MASK:\|DESIGN UPDATE:\|DESIGN MODIFY:\|DESIGN RESTRUCTURE:" | wc -l)" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
echo "### Validation & Releases" >> "$OUTPUT_FILE"
echo "- **Validation studies:** $(git log --oneline --grep="SVB VALIDATE:\|PARAMETER VALIDATE:" | wc -l)" >> "$OUTPUT_FILE"
echo "- **Total releases:** $(git tag 2>/dev/null | wc -l)" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
echo "### Documentation" >> "$OUTPUT_FILE"
echo "- **Documentation updates:** $(git log --oneline --grep="DOC:\|README" | wc -l)" >> "$OUTPUT_FILE"
echo "- **Repository changes:** $(git log --oneline --grep="REPO:" | wc -l)" >> "$OUTPUT_FILE"
echo "- **Last updated:** $(date)" >> "$OUTPUT_FILE"

echo "" >> "$OUTPUT_FILE"

# Version History Section
echo "## Version History" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
if git tag > /dev/null 2>&1 && [ -n "$(git tag)" ]; then
    git tag --sort=-version:refname | while read -r tag; do
        echo "### $tag" >> "$OUTPUT_FILE"
        git log --oneline --format="- %s (%ad)" --date=short "$tag"^.."$tag" 2>/dev/null >> "$OUTPUT_FILE" || true
        echo "" >> "$OUTPUT_FILE"
    done
else
    echo "*No releases tagged yet.*" >> "$OUTPUT_FILE"
fi

echo "Changelog generated: $OUTPUT_FILE"
