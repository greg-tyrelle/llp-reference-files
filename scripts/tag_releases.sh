#!/bin/bash
# tag_releases.sh - Helper script to tag baseline and current release
# This script helps you tag release-v1.0 (historical baseline) and release-v1.1 (current state)

set -e

REPO_ROOT="$(git rev-parse --show-toplevel)"

echo "=========================================="
echo "LLP Panel Release Tagging Helper"
echo "=========================================="
echo ""

# Find first commit
FIRST_COMMIT=$(git rev-list --max-parents=0 HEAD)
FIRST_COMMIT_SHORT=$(git rev-parse --short "$FIRST_COMMIT")
FIRST_COMMIT_MSG=$(git log --format="%s" -n 1 "$FIRST_COMMIT")
FIRST_COMMIT_DATE=$(git log --format="%ad" --date=short -n 1 "$FIRST_COMMIT")

echo "First commit found:"
echo "  Hash: $FIRST_COMMIT_SHORT"
echo "  Message: $FIRST_COMMIT_MSG"
echo "  Date: $FIRST_COMMIT_DATE"
echo ""

# Check if release-v1.0 already exists
if git rev-parse release-v1.0 >/dev/null 2>&1; then
    echo "✓ Tag release-v1.0 already exists"
    git show --no-patch release-v1.0
else
    echo "Tag release-v1.0 does not exist yet."
    echo ""
    read -p "Create release-v1.0 tag at first commit? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        git tag -a release-v1.0 "$FIRST_COMMIT" -m "Release v1.0: Initial baseline

Panel: Liverpool Lymphoid Network Panel v1
Date: $FIRST_COMMIT_DATE

This is the initial baseline release containing the first version of all configuration files:
- Design: v1.0
- SVB: v1.0  
- Hotspot: v1.0
- Parameters: v1.0"
        echo ""
        echo "✓ Created tag release-v1.0 at commit $FIRST_COMMIT_SHORT"
    else
        echo "Skipped creating release-v1.0"
    fi
fi

echo ""
echo "=========================================="
echo ""

# Current state
CURRENT_COMMIT=$(git rev-parse HEAD)
CURRENT_COMMIT_SHORT=$(git rev-parse --short HEAD)

echo "Current commit (HEAD):"
echo "  Hash: $CURRENT_COMMIT_SHORT"
echo ""

# Check for uncommitted changes
if [[ -n $(git status -s) ]]; then
    echo "⚠️  Warning: You have uncommitted changes."
    echo "    Commit or stash them before creating release-v1.1"
    echo ""
    git status -s
    echo ""
fi

# Check if release-v1.1 already exists
if git rev-parse release-v1.1 >/dev/null 2>&1; then
    echo "✓ Tag release-v1.1 already exists"
    git show --no-patch release-v1.1
else
    echo "Tag release-v1.1 does not exist yet."
    echo ""
    echo "To create release-v1.1 (current state):"
    echo ""
    echo "1. First, ensure all changes are committed"
    echo "2. Create the release package:"
    echo "   ./scripts/create_release_package.sh v1.1"
    echo ""
    echo "3. Then create and push the tag:"
    echo "   git tag -a release-v1.1 -m 'Release v1.1: [description of changes]'"
    echo "   git push origin release-v1.1"
    echo ""
fi

echo "=========================================="
echo ""
echo "Summary of release tags:"
git tag -l "release-v*" || echo "  No release tags found yet"
echo ""

if ! git rev-parse release-v1.0 >/dev/null 2>&1; then
    echo "Next step: Run this script again to create release-v1.0"
elif [[ -n $(git status -s) ]]; then
    echo "Next step: Commit your changes, then create release-v1.1 package"
else
    echo "Next step: Create release-v1.1 package"
    echo "  ./scripts/create_release_package.sh v1.1"
fi
echo ""
