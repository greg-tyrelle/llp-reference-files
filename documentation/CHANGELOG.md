# Liverpool Lymphoid Network Panel - Change Log
Generated: Mon Oct  6 15:22:26 CEST 2025

## Summary of Changes

### Configuration File Changes
- **2025-10-03** - HOTSPOT ADD: KMT2D c.5549del chr12:49436953 GC>G False Negative HP region
- **2025-10-03** - SVB ADD: ARID1A c.4555delC chr1:27101267 GCCCCCCAG>GCCCCCAG homopolymer false negative override
- **2025-10-03** - DESIGN MASK: Masked poorly performing amplicons
- **2025-09-15** - SVB ADD: Block strand bias artifact upstream of SF3B1 p.G742D
- **2025-09-12** - PARAMETER OPTIMIZE: Reduce Freebayes indel detection threshold for improved sensitivity
- **2025-07-07** - SVB ADD: Masking FP NM_006015.6:c.83A>G in SVB - Panel v1
- **2025-07-07** - HOTSPOT MODIFY: Increase frequency for hotspot NM_006015.6:c.3999_4001del due to FP deletion - Panel v1
- **2025-07-07** - HOTSPOT RESTRUCTURE: Added Ampliseq.com hotspot file to panel-versioned directory structure FILE ADDITION: Added transcripts.txt containing RefSeq transcript IDs

### System & Documentation Changes
- **2025-09-16** - DOC: Add hotspot support to changelog and create hotspot commit template
- **2025-09-16** - DOC: Update commit templates to use prefixed convention for better changelog grouping
- **2025-07-14** - DOC: Updated main readme. CHANGELOG.md added via automated SCRIPT.
- **2025-07-10** - Updated README.md
- **2023-10-20** - Added file manifest to README.md

---

## Detailed Change History

### Configuration File Changes

## SVB Filter Changes

### SVB ADD: ARID1A c.4555delC chr1:27101267 GCCCCCCAG>GCCCCCAG homopolymer false negative override
**Date:** 2025-10-03 | **Author:** Greg Tyrelle

Sample ID: No sample IDs provided (observed in 2 samples)
Position: chr1:27101266-27101268 (REF=GC;OBS=G)
Rationale: False negative in homopolymer region with opposing signal shift directions between samples. Standard FWDB/REVB overrides ineffective due to bidirectional signal shifts. Solution uses filter_unusual_predictions=0.3 to handle unpredictable signal patterns and adjust_sigma=1 to manage variability. Added SP0.07:0.07 to reduce low-level false positive noise.
References: FST-23909
Validated by: JN
Date discovered: 22/Apr/24

Additional context:
- Frequency observed: 2 samples (no sample IDs available)
- Panel version: v1
- Caller artifacts: Homopolymer region with bidirectional signal shift preventing standard strand bias correction
- Technical solution: filter_unusual_predictions override in combination with adjust_sigma=1, no need for stringency override
- Signal characteristics: Very different signal shift directions in 2 bam files preclude FWDB/REVB correction approach

---
### SVB ADD: Block strand bias artifact upstream of SF3B1 p.G742D
**Date:** 2025-09-15 | **Author:** Greg Tyrelle

Sample ID: Customer reported case
Position: chr2:198266607-198266608 (blocking artifact affecting chr2:198266611)
Rationale: Customer reported false negative for SF3B1 chr2:198266611 p.G742D due to upstream strand bias interference
References: FST-27010
Validated by: MT, GT
Date discovered: 2025-06-24

Additional context:
- Frequency observed: Isolated case affecting clinically significant SF3B1 variant
- Panel version: LLP v1.1
- Caller artifacts: Strand bias at chr2:198266607 preventing detection of SF3B1 p.G742D at 22% AF
- References: Customer case report, SF3B1 clinical significance in lymphoid malignancies

SVB Entry Added: chr2    198266607   198266608   sipara  REF=A;OBS=;BSTRAND=Ss0.45363:0.450000   NONE

---
### SVB ADD: Masking FP NM_006015.6:c.83A>G in SVB - Panel v1
**Date:** 2025-07-07 | **Author:** Greg Tyrelle

Sample ID: NA
Position: chr1:27022977
Amplicon: AMPL7170424926, AMPL7170425062
Rationale: Frequent FP in ARID1A at end of amplicon
PCR Issue: NA
Validated by: GT
Date discovered: 01-01-2024

Additional context:
- Frequency observed: All samples reported
- Panel version: v1
- Amplicon design: v1
- Caller artifacts: likely due to amplicon edge effects
- Related files: NA

---

## Parameter Optimizations

### PARAMETER OPTIMIZE: Reduce Freebayes indel detection threshold for improved sensitivity
**Date:** 2025-09-12 | **Author:** Greg Tyrelle

Parameter: gen_min_indel_alt_allele_freq
Old value: 0.05
New value: 0.03
Rationale: NOTCH1 chr9:139390648 p.P2514RfsTer4 not called at about 5% in LLNP
Validated by: GT
References: FST-27009
Date changed: 2025-09-12

Impact analysis:
- Both samples contain 2 low frequency indels C>CG and C>CAG at ~5% with weak flow disruptiveness (FDVR=5) and strong flow disruptiveness (FDVR=10) respectively. C>CG appears as HP indel but behaves like SNP in flow space requiring 2 adjacent flow changes. C>CAG allele shows stronger evidence due to FDVR=10. In sample R2, C>CAG base space AF falls slightly below 5%, causing freebayes to drop it from candidate list with gen_min_indel_alt_allele_freq=0.05, preventing flow evaluation and calling. Setting gen_min_indel_alt_allele_freq to 0.03 preserves the allele for freebayes processing and enables TVC calling.
- Expected sensitivity change: increase
- Expected specificity change: minimal decrease
- Affected variant types: indels
- Panel version: LLP v1.1

Testing notes:
- Validation by CAC for customer
- Test results: variants called with global parameter change
- Performance metrics: variant rescue

---

## Hotspot Management

### HOTSPOT ADD: KMT2D c.5549del chr12:49436953 GC>G False Negative HP region
**Date:** 2025-10-03 | **Author:** Greg Tyrelle

Locus: chr12:49436952
Variant Type: HP INDEL
Change: Added adjust_sigma=1 and FWDB=0.29 to new hotspot entry for locus
Rationale: Most HP indel call optimizations should start with adjust_sigma=1, which makes HP indel calling consistent. Added FWDB=0.29 to accommodate similar forward signal shifts for both samples
Validated by: JN
Reference: FST-23910
Date changed: 05/Jun/24

Impact Analysis:
- Mainly a sensitivity change to detect this variant
- Panel version: v1
- Validation cohort: 2 samples (no broader validation cohort)
- After changes: variant was called in both samples
- Before changes: variant not called (false negatives)

Additional context:
- Gene/Variant: KMT2D c.5549del (GC>G deletion)
- Homopolymer indel requiring signal normalization
- Standard approach: adjust_sigma=1 for consistency, then FWDB for signal shift correction

---
### HOTSPOT MODIFY: Increase frequency for hotspot NM_006015.6:c.3999_4001del due to FP deletion - Panel v1
**Date:** 2025-07-07 | **Author:** Greg Tyrelle

Sample ID: NA
TASER: FST-24587,FST-25175,FST-26987
HGVS: NM_006015.6:c.3999_4001del
Position: chr1:27100181
Amplicon: AMPL7170424872, AMPL7170425382
Rationale: Frequent false postive, add override min_allele_freq=0.15
Validated by: GT
Date discovered: 2024-01-01

Additional context:
- Frequency observed: Multiple network samples and TASER cases
- Panel version: v1
- Amplicon design: v1
- Caller artifacts: NA
- Related files: Not added to SVB due to hotspot, also seen in OCAPlus (FST-14823)

---
### HOTSPOT RESTRUCTURE: Added Ampliseq.com hotspot file to panel-versioned directory structure FILE ADDITION: Added transcripts.txt containing RefSeq transcript IDs
**Date:** 2025-07-07 | **Author:** Greg Tyrelle


---

## Design File Changes

### DESIGN MASK: Masked poorly performing amplicons
**Date:** 2025-10-03 | **Author:** Greg Tyrelle

Validated by: GT and LO

Changes made:
- A short script to take a bed formatted list of amplicons and modify them with the additional TRIM_LEFT directive was created
- After consultation with R&D TRIM_LEFT=200 was used to mask the amplicons and also for easy identification

Dataset and Preprocessing
* Analysis included 169 samples total (excluding Manheim samples based on run report)
* Data sources: Gx 4 samples/lane (105 samples), S5 platform (24 samples)
* Gx 8plex data was removed in the second analysis round
* "Total reads" per amplicon from amplicon.cov.xls used for all analyses
Analysis Methodology
* Primary analysis performed on both normalized and unnormalized data
* Normalization done by RPKM: (sample amplicon reads/sample total reads × 1,000,000)/(Amplicon length/1000)
* Unnormalized data used as a sanity check and guide to determine <100x coverage
* Standard deviation considered when determining coverage thresholds
Results Validation
* Results cross-checked across multiple analyses:
    * Comparison between Gx 4plex and S5 platforms
    * Comparison between normalized and unnormalized data
    * Concordance with previous analyses (Greg's "GT" top 10/poor performing analysis and SydPath's "SP" findings)
Key Findings
* 14 poorly performing amplicons identified with high confidence
* Amplicons classified by confidence level:
    * High concordance: all datasets in agreement
    * Medium concordance: 1 factor from a dataset impacting confidence
    * Low concordance: 1 significant factor impacting confidence
* No hotspots exist in the 14 identified poorly performing amplicons
* One ClinVar hit for IRF4 amplicon AMPL7170447466 with benign/VUS variants
Notes
* Data skews toward Gx platform due to sample distribution (105 Gx vs 24 S5)
* This skew is beneficial as normalization for chip read capacity wasn't performed
* All identified poor-performing amplicons align with previous analyses

---

### System & Repository Changes

## Release Management


## Documentation Updates

### DOC: Add hotspot support to changelog and create hotspot commit template
**Date:** 2025-09-16 | **Author:** Greg Tyrelle

Templates added:
- hotspot_commit_template.txt with HOTSPOT + COMMIT TYPE format

Changelog script updated:
- Added HOTSPOT ADD, REMOVE, MODIFY, UPDATE, RESTRUCTURE support
- Added Hotspot Management category section
- Enhanced statistics to track hotspot changes

Rationale: Enable structured tracking of hotspot file changes
Validated by: GT
Date changed: 2025-09-16

Changes made:
- Support for HOTSPOT ADD, HOTSPOT REMOVE, HOTSPOT MODIFY, HOTSPOT UPDATE, HOTSPOT RESTRUCTURE
- New hotspot commit template following same structure as SVB and parameter templates
- Enhanced changelog categorization for hotspot changes
- Improved commit message tracking for hotspot modifications

---
### DOC: Update commit templates to use prefixed convention for better changelog grouping
**Date:** 2025-09-16 | **Author:** Greg Tyrelle

Templates updated:
- SVB commit template: [SVB + COMMIT TYPE] format (e.g., SVB ADD, SVB REMOVE)
- Parameter commit template: [PARAMETER + COMMIT TYPE] format (e.g., PARAMETER OPTIMIZE)

Rationale: Enable better categorization and filtering in changelog generation
Validated by: GT
Date changed: 2025-09-16

Changes made:
- Updated svb_commit_template.txt to use 'SVB + COMMIT TYPE' convention
- Updated parameter_commit_template.txt to use 'PARAMETER + COMMIT TYPE' convention
- Modified generate_changelog.sh to recognize new prefixed patterns
- Enhanced statistics section to separate SVB and parameter actions
- Improved commit message categorization for cleaner changelog output

Impact:
- Better commit message organization and searchability
- Clearer separation between SVB and parameter changes in reports
- Enhanced automation for change tracking and documentation
- Improved team workflow consistency

---
### DOC: Updated main readme. CHANGELOG.md added via automated SCRIPT.
**Date:** 2025-07-14 | **Author:** Greg Tyrelle


---
### Updated README.md
**Date:** 2025-07-10 | **Author:** Greg Tyrelle


---
### Added file manifest to README.md
**Date:** 2023-10-20 | **Author:** Tyrelle, Greg


---

## Repository Structure


## Repository Statistics

### Configuration Changes
- **SVB filters added:**        3
- **SVB filters removed:**        0
- **SVB filters modified:**        0
- **Parameter optimizations:**        1
- **Hotspot changes:**        3
- **Design changes:**        1

### Validation & Releases
- **Validation studies:**        0
- **Total releases:**        0

### Documentation
- **Documentation updates:**        5
- **Repository changes:**        0
- **Last updated:** Mon Oct  6 15:22:27 CEST 2025

## Version History

*No releases tagged yet.*
