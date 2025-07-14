#!/bin/bash
# scripts/generate_changelog_flexible.sh

OUTPUT_FILE="documentation/CHANGELOG.md"

echo "# LLP Panel Reference Files - Change Log" > $OUTPUT_FILE
echo "" >> $OUTPUT_FILE
echo "Auto-generated from git commit messages on $(date)" >> $OUTPUT_FILE
echo "" >> $OUTPUT_FILE

# Define categories and their patterns
declare -A categories=(
    ["SVB Changes"]="SVB-"
    ["Hotspot Changes"]="HOTSPOT|HOTSPOT-"
    ["Structure Changes"]="RESTRUCTURE|FILE ADDITION|MIGRATE"
    ["Parameter Changes"]="paramters|parameters|TVC"
    ["Documentation Changes"]="README|DOC:|manifest"
)

# Generate sections for each category
for category in "${!categories[@]}"; do
    pattern="${categories[$category]}"
    echo "### $category" >> $OUTPUT_FILE
    
    # Use extended regex with -E flag
    git log --grep="$pattern" --extended-regexp --format="#### %s%n%b%n---" >> $OUTPUT_FILE
    echo "" >> $OUTPUT_FILE
done

# Statistics
echo "### Summary Statistics" >> $OUTPUT_FILE
for category in "${!categories[@]}"; do
    pattern="${categories[$category]}"
    count=$(git log --oneline --grep="$pattern" --extended-regexp | wc -l)
    echo "- $category: $count" >> $OUTPUT_FILE
done

total_count=$(git log --oneline --grep="SVB-|HOTSPOT|RESTRUCTURE|paramters|parameters|TVC|README|DOC:|manifest" --extended-regexp | wc -l)
echo "- Total tracked commits: $total_count" >> $OUTPUT_FILE
echo "- Last updated: $(date)" >> $OUTPUT_FILE

echo "Changelog generated: $OUTPUT_FILE"
