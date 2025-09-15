# Liverpool Lymphoid Network Panel - Change Log
Generated: Tue Sep 16 00:34:01 CEST 2025

## Recent Changes (Last 20 commits)

### SVB ADD: Block strand bias artifact upstream of SF3B1 p.G742D
**Date:** 2025-09-15
**Author:** Greg Tyrelle

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
### PARAMETER OPTIMIZE: Reduce Freebayes indel detection threshold for improved sensitivity
**Date:** 2025-09-12
**Author:** Greg Tyrelle

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
### HOTSPOT RESTRUCTURE: Added Ampliseq.com hotspot file to panel-versioned directory structure FILE ADDITION: Added transcripts.txt containing RefSeq transcript IDs
**Date:** 2025-07-07
**Author:** Greg Tyrelle


---

## SVB Filter Changes

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

### HOTSPOT RESTRUCTURE: Added Ampliseq.com hotspot file to panel-versioned directory structure FILE ADDITION: Added transcripts.txt containing RefSeq transcript IDs
**Date:** 2025-07-07 | **Author:** Greg Tyrelle


---

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

## Repository Statistics

- **SVB filters added:**        1
- **SVB filters removed:**        0
- **SVB filters modified:**        0
- **Parameter optimizations:**        1
- **Hotspot changes:**        1
- **Validation studies:**        0
- **Total releases:**        0
- **Last updated:** Tue Sep 16 00:34:01 CEST 2025

## Version History

*No releases tagged yet.*
