# Liverpool Lymphoid Network Panel - Release Management Guide

## Overview

This document describes the release management system for LLP reference files, using a two-layer versioning approach.

## Two-Layer Versioning System

### Layer 1: File Versions (Current Practice)
```
Individual files evolve independently:
- SVB:        v1.0 → v1.1 → v1.2 → current
- Hotspot:    v1.0 → v1.1 → current
- Parameters: v1.0 → v1.1 → current  
- Design:     v1.0 → v1.1 → current
```

### Layer 2: Release Versions (NEW - Coordinated Snapshots)
```
Validated snapshots for distribution:
Release-v1.0: [Design v1.0, SVB v1.0, Hotspot v1.0, Params v1.0]
Release-v1.1: [Design v1.1, SVB v1.2, Hotspot v1.1, Params v1.1]
Release-v1.2: [Design v1.1, SVB v1.4, Hotspot v1.2, Params v1.1]
```

## When to Change Version Numbers

### File Version Changes (Layer 1)
**Trigger:** Any modification to a configuration file
**Action:** Archive current → increment version → update current
**Example:** 
```bash
# Making change to SVB
mv current_svb.bed archived/v1.2_svb.bed
# Edit file
mv edited.bed current_svb.bed
# Commit with SVB ADD/MODIFY/REMOVE
```

### Release Version Changes (Layer 2)
**Trigger:** Ready to distribute validated snapshot to downstream teams
**Action:** Create release package, tag in git
**Example:**
```bash
# Create release
./scripts/create_release_package.sh v1.1
git tag -a release-v1.1 -m "Release notes..."
git push origin release-v1.1
```

## Major vs. Incremental Releases

### Major Release (Panel Redesign)
**v1.0 → v2.0**
- New PCR primers (physical assay change)
- New genes added/removed
- New sequencing platform
- Creates new panel_v2/ directory

### Incremental Release (Configuration Update)
**v1.0 → v1.1 → v1.2**
- SVB filter changes
- Hotspot optimizations
- Parameter adjustments
- Design masking
- Within same panel_v1/ directory

## File Naming Convention

### In Repository (Development)
```
panel_v1/
  design/current.design.bed
  svb/current_svb.bed
  hotspot/current_hotspot.bed
  parameters/current.parameters.json
```

### In Release Package (Distribution)
```
Release-v1.1/
  panel_v1_design_Release-v1.1.bed
  panel_v1_svb_Release-v1.1.bed
  panel_v1_hotspot_Release-v1.1.bed
  panel_v1_parameters_Release-v1.1.json
  RELEASE_NOTES_v1.1.md
  FILE_MANIFEST_v1.1.md
```

### Downstream (After Rename)
```
Downstream teams can rename as needed:
  ThermoFisher_LLP_SVB_2025Q4.bed
  
But must document:
  "Source: Release-v1.1"
```

## Traceability Chain

```
Customer Issue
    ↓
Configuration Change (e.g., SVB v1.1 → v1.2)
    ↓
Commit with detailed rationale
    ↓
Accumulate changes
    ↓
Validation (50 samples)
    ↓
Release-v1.1 created
    ↓
GitHub tag: release-v1.1
    ↓
Release package: Release-v1.1.zip
    ↓
Downstream team downloads
    ↓
Downstream renames & uploads
    ↓
Customer uses updated configuration
    ↓
Traceable back: "Which config?" → "Release-v1.1" → Git tag → File versions → Change rationale
```

## Current State → First Release Transition

### Current State (Before Release System)
```
✅ File versions: SVB v1.2, Hotspot v1.1, Params v1.1, Design v1.1
❌ No formal release tags
❌ No release packages
❌ No snapshot identifier for downstream
```

### Immediate Next Steps
1. **Tag current state as Release-v1.0** (baseline reference)
2. **Create release packaging scripts**
3. **Accumulate next batch of changes**
4. **Package & tag Release-v1.1** (first formal release)

### Going Forward
```
Every significant batch of changes:
1. Modify files → archive → commit
2. Accumulate 3-5 changes
3. Run validation cohort
4. Create Release-vX.Y package
5. Tag in git
6. Distribute to downstream teams
7. They rename & document source
```

## Release Workflow

### Creating a Release

1. **Prepare Release Package:**
   ```bash
   ./scripts/create_release_package.sh v1.1
   ```
   This creates `releases/Release-v1.1/` with all configuration files and documentation.

2. **Validate Release (Optional):**
   ```bash
   ./scripts/validate_release.sh v1.1
   ```
   Performs basic file integrity checks.

3. **Create Git Tag:**
   ```bash
   git tag -a release-v1.1 -m "Release v1.1: Description of changes"
   git push origin release-v1.1
   ```

4. **Create GitHub Release:**
   ```bash
   gh release create release-v1.1 \
     --title "LLP Panel Configuration Release v1.1" \
     --notes-file releases/Release-v1.1/documentation/RELEASE_NOTES_v1.1.md \
     releases/Release-v1.1.zip
   ```
   Or use the GitHub web interface to upload the zip file.

5. **Communicate to Downstream Teams:**
   - Send notification with GitHub release link
   - Downstream teams download and integrate
   - They document source as "Release-v1.1"

## Release Decisions

| Decision | Approach |
|----------|----------|
| **Baseline** | Historical initial commit tagged as release-v1.0 |
| **Cadence** | On-demand (no fixed schedule) |
| **Validation** | No formal protocol (users can access "current" files for latest) |
| **Storage** | GitHub Releases (zip packages) |

## Benefits Summary

| Challenge | Solution |
|-----------|----------|
| Async file versions | Release snapshots coordinate versions |
| "Which snapshot used?" | Release tags provide identifier |
| Downstream traceability | File manifest in each release |
| Panel redesign (v2) | Major version change, new directory |
| Validation tracking | Release notes document changes |
| Change documentation | Changelog filtered per release |

## Scripts Reference

| Script | Purpose |
|--------|---------|
| `scripts/create_release_package.sh` | Creates release directory, copies files, generates manifest |
| `scripts/generate_release_notes.sh` | Extracts commits since last release |
| `scripts/validate_release.sh` | Basic file integrity checks (placeholder) |
| `scripts/generate_changelog.sh` | Generates comprehensive CHANGELOG.md |

## Quick Start for New Release

```bash
# 1. Ensure all changes are committed
git status

# 2. Create release package
./scripts/create_release_package.sh v1.1

# 3. Validate (optional)
./scripts/validate_release.sh v1.1

# 4. Tag release
git tag -a release-v1.1 -m "Release v1.1: [description]"
git push origin release-v1.1

# 5. Upload to GitHub Releases
# Use GitHub web interface or gh CLI
```

---

**For technical details, see:** `documentation/versioning_strategy.md`
