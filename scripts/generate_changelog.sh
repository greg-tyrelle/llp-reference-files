#!/bin/bash
# generate_changelog.sh - Generate comprehensive changelog for LLP reference files

# Set repository root
REPO_ROOT="$(git rev-parse --show-toplevel)"
OUTPUT_FILE="$REPO_ROOT/documentation/CHANGELOG.md"

echo "# Liverpool Lymphoid Network Panel - Change Log" > "$OUTPUT_FILE"
echo "Generated: $(date)" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Recent Changes Section
echo "## Recent Changes (Last 20 commits)" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
git log --oneline --grep="SVB ADD:" --grep="SVB REMOVE:" --grep="SVB MODIFY:" --grep="SVB VALIDATE:" --grep="PARAMETER OPTIMIZE:" --grep="PARAMETER RELAX:" --grep="PARAMETER TIGHTEN:" --grep="PARAMETER CORRECT:" --grep="PARAMETER UPDATE:" --grep="RELEASE:" \
    --format="### %s%n**Date:** %ad%n**Author:** %an%n%n%b%n---" --date=short -20 >> "$OUTPUT_FILE"

echo "" >> "$OUTPUT_FILE"

# Define categories and their patterns for detailed sections
declare -A categories=(
    ["SVB Filter Changes"]="SVB ADD:|SVB REMOVE:|SVB MODIFY:|SVB VALIDATE:"
    ["Parameter Optimizations"]="PARAMETER OPTIMIZE:|PARAMETER RELAX:|PARAMETER TIGHTEN:|PARAMETER CORRECT:|PARAMETER UPDATE:"
    ["Release Management"]="RELEASE:"
    ["Documentation Updates"]="DOC:|README"
)

# Generate sections for each category
for category in "${!categories[@]}"; do
    pattern="${categories[$category]}"
    echo "## $category" >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
    
    # Get commits matching this category
    if git log --grep="$(echo $pattern | tr '|' '\n' | head -1)" --oneline | head -1 > /dev/null 2>&1; then
        git log --grep="$pattern" --extended-regexp --format="### %s%n**Date:** %ad | **Author:** %an%n%n%b%n---" --date=short -10 >> "$OUTPUT_FILE"
    else
        echo "*No commits found for this category.*" >> "$OUTPUT_FILE"
    fi
    echo "" >> "$OUTPUT_FILE"
done

# Statistics Section  
echo "## Repository Statistics" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
echo "- **SVB filters added:** $(git log --oneline --grep="SVB ADD:" | wc -l)" >> "$OUTPUT_FILE"
echo "- **SVB filters removed:** $(git log --oneline --grep="SVB REMOVE:" | wc -l)" >> "$OUTPUT_FILE"
echo "- **SVB filters modified:** $(git log --oneline --grep="SVB MODIFY:" | wc -l)" >> "$OUTPUT_FILE"
echo "- **Parameter optimizations:** $(git log --oneline --grep="PARAMETER OPTIMIZE:\|PARAMETER RELAX:\|PARAMETER TIGHTEN:\|PARAMETER CORRECT:\|PARAMETER UPDATE:" | wc -l)" >> "$OUTPUT_FILE"
echo "- **Validation studies:** $(git log --oneline --grep="SVB VALIDATE:\|PARAMETER VALIDATE:" | wc -l)" >> "$OUTPUT_FILE"
echo "- **Total releases:** $(git tag 2>/dev/null | wc -l)" >> "$OUTPUT_FILE"
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
