# LLP Panel Reference Files - Change Log

Auto-generated from git commit messages on Mon Jul 14 11:01:28 PM CEST 2025

### Structure Changes
#### HOTSPOT RESTRUCTURE: Added Ampliseq.com hotspot file to panel-versioned directory structure FILE ADDITION: Added transcripts.txt containing RefSeq transcript IDs

---
#### RESTRUCTURE: Migrate to panel-versioned directory structure
- Moved existing reference files to panel_v1 structure
- Created directories for SVB tracking system
- Prepared for systematic configuration management

---

### Documentation Changes
#### Updated README.md

---
#### Added file manifest to README.md

---

### SVB Changes
#### SVB-NOTE: Masking FP NM_006015.6:c.83A>G in SVB - Panel v1
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

### Parameter Changes
#### Renamed paramters to be consistent with uploaded files.

---
#### - updated paramters to the release version v1 - Synchronized  paramters with optimized version - Key change is Freebays generate minimum indel alt allele frequency from 0.1 -> 0.05

---

### Hotspot Changes
#### HOTSPOT-MODIFY: Increase frequency for hotspot NM_006015.6:c.3999_4001del due to FP deletion - Panel v1
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
#### HOTSPOT RESTRUCTURE: Added Ampliseq.com hotspot file to panel-versioned directory structure FILE ADDITION: Added transcripts.txt containing RefSeq transcript IDs

---

### Summary Statistics
- Structure Changes: 2
- Documentation Changes: 2
- SVB Changes: 1
- Parameter Changes: 2
- Hotspot Changes: 2
- Total tracked commits: 8
- Last updated: Mon Jul 14 11:01:28 PM CEST 2025
