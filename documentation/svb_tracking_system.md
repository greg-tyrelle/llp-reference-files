# Sequence Variant Baseline (SVB) Tracking System

A git-based system for tracking changes to Sequence Variant Baseline files used in targeted NGS panels, with structured documentation for false positive filtering.

## Repository Structure

```
svb-tracking/
├── svb/
│   ├── current_baseline.vcf          # Active baseline file
│   ├── current_baseline.bed          # Alternative BED format
│   └── archived/
│       ├── v1.0_baseline.vcf         # Previous versions
│       ├── v1.1_baseline.vcf
│       └── v1.2_baseline.vcf
├── documentation/
│   ├── CHANGELOG.md                  # Auto-generated change log
│   ├── false_positives_log.md        # Detailed discovery log
│   └── validation_reports/
│       ├── 2025-01-validation.md
│       └── 2025-02-validation.md
├── scripts/
│   ├── generate_changelog.sh         # Automation scripts
│   └── validate_svb.sh
├── README.md                         # Setup and usage guide
└── .gitignore
```

## Structured Commit Message Format

### Template
```
[TYPE]: Brief description

Sample ID: [sample_id_list]
Position: [genomic_position_or_variant]
Rationale: [why_this_change_was_made]
Validated by: [reviewer_initials]
Date discovered: [YYYY-MM-DD]

Additional context:
- Frequency observed: X/Y samples
- Panel version: [panel_version]
- Caller artifacts: [specific_technical_issue]
- References: [literature_or_internal_refs]
```

### Commit Types
- **ADD**: New filter entry added
- **REMOVE**: Filter entry removed
- **MODIFY**: Existing filter modified
- **VALIDATE**: Validation study results
- **RELEASE**: Version release/tagging

## Example Commit Messages

### Adding a New Filter
```bash
git commit -m "ADD: Filter chr17:7578406 BRCA1 recurrent artifact

Sample ID: RP045, RP067, RP089
Position: chr17:7578406 A>G
Rationale: Recurrent false positive in homopolymer region
Validated by: GT
Date discovered: 2025-01-15

Additional context:
- Frequency: 3/50 samples this month
- Panel version: LymphoidNet v2.4
- Caller artifacts: Ion Torrent strand bias in 7bp homopolymer
- References: Internal QC report 2025-001"
```

### Removing an Obsolete Filter
```bash
git commit -m "REMOVE: chr13:32911035 BRCA2 filter no longer needed

Sample ID: Validation cohort (n=100)
Position: chr13:32911035 G>A
Rationale: Improved caller version eliminates false positive
Validated by: GT/AS
Date discovered: 2025-01-20

Additional context:
- Frequency: 0/100 samples with new caller v5.2
- Panel version: LymphoidNet v2.5
- Caller artifacts: Resolved in TorrentSuite v5.2"
```

## Documentation Templates

### False Positives Discovery Log
```markdown
# False Positive Discovery Log

## 2025-01-15: BRCA1 Homopolymer Artifact
- **Position**: chr17:7578406 A>G
- **Samples**: RP045, RP067, RP089
- **Root cause**: Ion Torrent homopolymer calling error in 7bp repeat
- **Frequency**: 3/50 samples (6%)
- **Action**: Added to SVB v2.1
- **Git commit**: abc123f
- **Validation**: Confirmed absent in germline DNA

## 2025-01-10: TP53 Strand Bias Artifact
- **Position**: chr17:7577120 C>T
- **Samples**: RP032, RP041
- **Root cause**: PCR amplification bias in GC-rich region
- **Frequency**: 2/50 samples (4%)
- **Action**: Added to SVB v2.1
- **Git commit**: def456a
- **Validation**: Absent in independent PCR

## 2025-01-05: MYC Translocation Breakpoint
- **Position**: chr8:128748315-128748320
- **Samples**: RP028
- **Root cause**: Panel design includes common breakpoint region
- **Frequency**: 1/50 samples (2%)
- **Action**: Added to SVB v2.1
- **Git commit**: ghi789b
- **Validation**: Confirmed germline variant in dbSNP
```

### Monthly Validation Report Template
```markdown
# SVB Validation Report - January 2025

## Summary
- **Review period**: 2025-01-01 to 2025-01-31
- **Samples processed**: 150
- **New filters added**: 3
- **Filters removed**: 1
- **False positive rate**: 2.3% (before filtering)
- **False positive rate**: 0.1% (after filtering)

## New Filters Added
| Position | Variant | Samples | Frequency | Rationale |
|----------|---------|---------|-----------|-----------|
| chr17:7578406 | A>G | RP045, RP067, RP089 | 3/150 | Homopolymer artifact |
| chr17:7577120 | C>T | RP032, RP041 | 2/150 | Strand bias |
| chr8:128748315 | Complex | RP028 | 1/150 | Panel design issue |

## Filters Removed
| Position | Variant | Rationale |
|----------|---------|-----------|
| chr13:32911035 | G>A | Resolved in caller update |

## Validation Results
- **Sanger confirmation**: 5/5 filters validated as true artifacts
- **Orthogonal method**: ddPCR confirmed absence in 3/3 tested positions
- **Literature review**: 2/3 positions reported as known artifacts

## Recommendations
1. Monitor chr17 homopolymer regions more closely
2. Consider panel redesign for chr8:128748315 region
3. Evaluate caller settings for strand bias detection
```

## Automation Scripts

### Generate Changelog Script
```bash
#!/bin/bash
# generate_changelog.sh

echo "# SVB Change Log - Generated $(date)" > documentation/CHANGELOG.md
echo "" >> documentation/CHANGELOG.md

echo "## Recent Changes" >> documentation/CHANGELOG.md
git log --oneline --grep="ADD:" --grep="REMOVE:" --grep="MODIFY:" \
    --format="### %s%n%b%n---" -10 >> documentation/CHANGELOG.md

echo "" >> documentation/CHANGELOG.md
echo "## Statistics" >> documentation/CHANGELOG.md
echo "- Total filters added: $(git log --oneline --grep="ADD:" | wc -l)" >> documentation/CHANGELOG.md
echo "- Total filters removed: $(git log --oneline --grep="REMOVE:" | wc -l)" >> documentation/CHANGELOG.md
echo "- Last updated: $(date)" >> documentation/CHANGELOG.md
```

### SVB Validation Script
```bash
#!/bin/bash
# validate_svb.sh

echo "Validating SVB file format..."

# Check VCF format
if [[ -f "svb/current_baseline.vcf" ]]; then
    echo "Checking VCF format..."
    bcftools view -h svb/current_baseline.vcf > /dev/null 2>&1
    if [[ $? -eq 0 ]]; then
        echo "✓ VCF format valid"
        echo "  Variants: $(bcftools view -H svb/current_baseline.vcf | wc -l)"
    else
        echo "✗ VCF format invalid"
    fi
fi

# Check BED format
if [[ -f "svb/current_baseline.bed" ]]; then
    echo "Checking BED format..."
    # Basic BED format check
    awk '{if(NF<3) exit 1}' svb/current_baseline.bed
    if [[ $? -eq 0 ]]; then
        echo "✓ BED format valid"
        echo "  Regions: $(wc -l < svb/current_baseline.bed)"
    else
        echo "✗ BED format invalid"
    fi
fi

echo "Validation complete."
```

## Workflow Examples

### Daily Operation
```bash
# 1. Discover false positive during variant review
# 2. Add entry to SVB file
vim svb/current_baseline.vcf

# 3. Commit with structured message
git add svb/current_baseline.vcf
git commit -m "ADD: Filter chr17:7578406 BRCA1 recurrent artifact

Sample ID: RP045, RP067, RP089
Position: chr17:7578406 A>G
Rationale: Recurrent false positive in homopolymer region
Validated by: GT
Date discovered: 2025-01-15

Additional context:
- Frequency: 3/50 samples this month
- Panel version: LymphoidNet v2.4
- Caller artifacts: Ion Torrent strand bias"

# 4. Test on problem samples
./scripts/validate_svb.sh

# 5. Push to shared repository
git push origin main
```

### Weekly/Monthly Maintenance
```bash
# Generate updated changelog
./scripts/generate_changelog.sh

# Review filter effectiveness
git log --oneline --grep="ADD:" --since="1 month ago"

# Tag stable versions
git tag -a v2.1 -m "SVB Release v2.1 - Added 5 new filters, removed 1 obsolete"
git push --tags

# Archive old versions
cp svb/current_baseline.vcf svb/archived/v2.0_baseline.vcf
git add svb/archived/v2.0_baseline.vcf
git commit -m "RELEASE: Archive v2.0 baseline"
```

## Best Practices

### Commit Message Guidelines
1. **Use consistent format** - Follow the structured template
2. **Include sample IDs** - Essential for traceability
3. **Document rationale** - Why was this change necessary?
4. **Add validation info** - How was the change verified?
5. **Reference external docs** - Link to reports, literature, etc.

### File Management
1. **Keep current baseline** - Always maintain a current version
2. **Archive old versions** - Preserve historical baselines
3. **Use descriptive names** - Include version numbers and dates
4. **Regular backups** - Push to remote repository frequently

### Quality Control
1. **Peer review** - Have changes reviewed before deployment
2. **Validation testing** - Test on known problem samples
3. **Documentation** - Maintain detailed logs of all changes
4. **Regular audits** - Review filter effectiveness monthly

## Integration with NGS Pipeline

### Pre-commit Hook Example
```bash
#!/bin/bash
# .git/hooks/pre-commit

# Validate SVB file format before commit
./scripts/validate_svb.sh
if [[ $? -ne 0 ]]; then
    echo "SVB validation failed. Commit aborted."
    exit 1
fi

# Ensure commit message follows format
if ! grep -q "^[A-Z]*:" .git/COMMIT_EDITMSG 2>/dev/null; then
    echo "Commit message must start with TYPE: (ADD:, REMOVE:, MODIFY:, etc.)"
    exit 1
fi
```

This system provides complete traceability, structured documentation, and automated validation while maintaining the flexibility to adapt to your specific NGS workflow requirements.