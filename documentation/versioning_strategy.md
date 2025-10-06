# Liverpool Lymphoid Network Panel Versioning Strategy

## Version Number Format

For this project with incremental updates and major releases (no minor releases):

```
vMAJOR.INCREMENTAL
```

Examples:
- `v1.0` - Initial panel release
- `v1.1` - First incremental update (parameter changes, filter additions)  
- `v1.2` - Second incremental update
- `v2.0` - Major panel redesign or significant methodology change

## Version Types

### Major Versions (X.0)
Trigger conditions:
- Panel design changes (new amplicons, removed regions)
- Significant methodology changes (new caller, different chemistry)
- Breaking changes to file formats or structure
- Annual comprehensive reviews

Examples:
- New target gene additions requiring panel redesign
- Migration from Ion Torrent to different sequencing platform
- Major bioinformatics pipeline updates

### Incremental Versions (X.Y)
Trigger conditions:
- Parameter optimizations
- SVB filter additions/removals
- Hotspot file updates
- Quality threshold adjustments
- Minor workflow improvements

Examples:
- Lowering `gen_min_indel_alt_allele_freq` from 0.05 to 0.03
- Adding new false positive filters to SVB
- Updating hotspot annotations
- Adjusting coverage thresholds

## File Versioning and Archival

### Parameter Files
```
panel_v1/parameters/
├── current.parameters.json          # Active version
└── archived/
    ├── v1.0_parameters.json         # Major release
    ├── v1.1_parameters.json         # First incremental
    └── v1.2_parameters.json         # Second incremental
```

### SVB Files  
```
panel_v1/svb/
├── current_svb.vcf                  # Active version
├── current_svb.bed                  # Active BED format
└── archived/
    ├── v1.0_svb.vcf
    ├── v1.1_svb.vcf
    └── v1.2_svb.vcf
```

### Hotspot Files
```
panel_v1/hotspot/
├── current_hotspot.vcf              # Active version
├── current_hotspot.bed              # Active BED format  
└── archived/
    ├── v1.0_hotspot.vcf
    ├── v1.1_hotspot.vcf
    └── v1.2_hotspot.vcf
```

## Git Tagging Strategy

### Tag Format
- Major releases: `v1.0`, `v2.0`, `v3.0`
- Incremental releases: `v1.1`, `v1.2`, `v1.3`

### Tag Commands
```bash
# Major release
git tag -a v1.0 -m "LLP Panel v1.0 - Initial release with 47 targets"

# Incremental release  
git tag -a v1.1 -m "LLP Panel v1.1 - Optimized indel parameters, added 3 SVB filters"
```

## Release Process

### Overview
Releases provide validated snapshots of configuration files for distribution to downstream teams.
Individual file versions may be asynchronous (e.g., SVB v1.2, Hotspot v1.1), but releases coordinate them into a unified package.

### Release Creation Workflow

**For Incremental Updates (v1.1, v1.2, etc.):**
1. Make changes to configuration files (SVB, hotspot, parameters, design)
2. Archive previous version and commit with structured message
3. Accumulate changes as needed
4. When ready for release:
   ```bash
   ./scripts/create_release_package.sh v1.1
   ./scripts/validate_release.sh v1.1  # optional
   git tag -a release-v1.1 -m "Release v1.1: [description]"
   git push origin release-v1.1
   ```
5. Upload Release-v1.1.zip to GitHub Releases
6. Notify downstream teams

**For Major Updates (v2.0, v3.0, etc.):**  
1. Create new panel directory (e.g., `panel_v2/`)
2. Copy and modify all configuration files
3. Update documentation
4. Follow incremental release workflow
5. Tag as release-v2.0

### Release Decisions
- **Cadence:** On-demand (no fixed schedule)
- **Validation:** No formal protocol currently
- **Storage:** GitHub Releases
- **Baseline:** Historical initial commit = release-v1.0

## Documentation Structure

### Global Documentation
```
documentation/
├── CHANGELOG.md                     # Auto-generated global changelog
├── svb_tracking_system.md          # Process documentation  
├── versioning_strategy.md           # This document
├── parameter_changes/
│   ├── v1.1_parameter_changes.md   # Detailed change documentation
│   └── v1.2_parameter_changes.md
└── validation_reports/
    ├── 2025-09-validation.md       # Monthly validation reports
    └── 2025-10-validation.md
```

### Panel-Specific Documentation
```
panel_v1/
├── README.md                        # Panel-specific documentation
└── [panel files...]
```

This approach provides:
- Clear versioning semantics
- Comprehensive change tracking  
- Flexibility for different update types
- Scalability as panels evolve