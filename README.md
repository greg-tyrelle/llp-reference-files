# Liverpool Lymphoid Network Panel Reference Files

## Overview

This repository maintains versioned reference files for the Liverpool Lymphoid Network Panel (LLP), a custom NGS assay for detecting somatic variants in lymphoid malignancies. The repository tracks all configuration changes including design files, sequence variant baseline (SVB) filters, hotspot regions, and variant caller parameters.

## Purpose

The LLP reference files enable:
- **Reproducible variant calling** across different analysis runs
- **Comprehensive change tracking** with detailed rationale and validation
- **Version control** for all configuration components
- **Quality assurance** through documented validation studies

## Getting Started

### For Current/Development Use
For the most up-to-date files, use the **"current"** prefix in each relevant subdirectory:
- `panel_v1/design/current.design.bed` - Current amplicon design
- `panel_v1/svb/current_svb.bed` - Current SVB filter set
- `panel_v1/hotspot/current_hotspot.bed` - Current hotspot regions
- `panel_v1/parameters/current.paramters.json` - Current variant caller parameters

### For Stable/Production Use
For stable, validated configurations, **download a release package** from the GitHub releases page. Release packages include:
- Locked versions of all configuration files
- Validation reports and performance metrics
- Change logs and documentation
- Release notes with version compatibility information

## Repository Structure

```
├── panel_v1/                    # Panel version 1 files
│   ├── design/                  # Amplicon design files
│   ├── svb/                     # Sequence Variant Baseline filters
│   ├── hotspot/                 # Hotspot regions for variant calling
│   ├── parameters/              # Variant caller parameters
│   ├── cnv_baseline/            # Copy number baseline files
│   └── false_positives/         # False positive tracking
├── documentation/               # Change logs and tracking
│   ├── CHANGELOG.md             # Auto-generated comprehensive changelog
│   ├── svb_changes/             # SVB modification history
│   ├── hotspot_tracking/        # Hotspot modification history
│   ├── parameter_changes/       # Parameter optimization history
│   └── svb_tracking_system.md   # SVB tracking methodology
├── templates/                   # Commit message templates
├── scripts/                     # Automation scripts
└── archive/                     # Deprecated files

```

## File Formats

- **BED files** are the primary format for design, SVB, and hotspot files
- **VCF files** are generated from BED files using `tvcutils` for compatibility
- **JSON files** store variant caller parameters
- **Markdown files** document all changes with detailed rationale

## Documentation

All configuration changes are documented with:
- **Rationale**: Clinical or technical justification
- **Validation**: Testing results and validation cohort details
- **References**: Customer case IDs, Jira tickets, or literature citations
- **Impact**: Expected sensitivity/specificity changes
- **Versioning**: Archived previous versions for traceability

See `documentation/CHANGELOG.md` for a comprehensive history of all changes.

## Contributing

Changes to reference files should follow the structured commit message templates in `templates/` and include:
1. Detailed rationale and validation
2. Archived copy of previous version
3. Updated change log documentation
4. Testing or validation results

For detailed panel information, see [Ampliseq.com](https://ampliseq.com)

## Support

For questions or issues, contact the Liverpool Lymphoid Network panel support team.
