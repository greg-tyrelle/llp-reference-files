# Hotspot Change Log Template

## Date: [DD/MMM/YY or YYYY-MM-DD]

## Change: [Brief title of the change]

### Hotspot Entry Modified
- **Action:** [ADD/REMOVE/MODIFY]
- **Locus:** [genomic_coordinates]
- **Variant Type:** [HP_INDEL/SNV/MNV/etc]
- **Entry:** `[full_hotspot_line]`

### Clinical Context
- **Gene/Variant:** [gene_name and specific variant notation]
- **Sample ID:** [sample_identifier_if_available]
- **Original Issue:** [description_of_false_positive_or_false_negative]

### Problem Analysis
- **Root Cause:** [technical_explanation_of_the_issue]
- **Frequency:** [how_often_observed / validation_cohort_size]
- **Impact:** [sensitivity/specificity impact]

### Solution Implemented
- **Hotspot Action:** [what_was_added_removed_or_modified]
- **Parameters Changed:**
  - [parameter_1]: [value_and_explanation]
  - [parameter_2]: [value_and_explanation]
- **Rationale:** [why_these_specific_parameters_were_chosen]
- **Expected Outcome:** [how_this_improves_calling]
- **Validation Results:** [before/after_statistics_if_available]

### Impact Analysis
- **Before Change:** [calling_behavior_before]
- **After Change:** [calling_behavior_after]
- **Validation Cohort:** [number_of_samples_if_applicable]

### Files Changed
- `panel_v1/hotspot/current_hotspot.bed`
- Archived previous version as `[version]_hotspot.bed`

### Panel Information
- **Panel Version:** [panel_version]
- **Validated by:** [reviewer_initials]
- **References:** [JIRA_tickets_literature_or_internal_reports]

### Next Steps
1. [any_follow_up_actions_needed]
2. [monitoring_requirements]
3. [additional_validation_if_needed]
