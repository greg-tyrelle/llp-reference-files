#!/bin/bash
# validate_parameters.sh - Validate parameter file format and values

PANEL_DIR="${1:-panel_v1}"
PARAM_FILE="$PANEL_DIR/parameters/current.paramters.json"

echo "Validating LLP Panel parameters..."
echo "Panel directory: $PANEL_DIR"
echo "Parameter file: $PARAM_FILE"
echo ""

# Check if parameter file exists
if [[ ! -f "$PARAM_FILE" ]]; then
    echo "✗ Parameter file not found: $PARAM_FILE"
    exit 1
fi

# Check JSON format
echo "Checking JSON format..."
if jq empty "$PARAM_FILE" 2>/dev/null; then
    echo "✓ JSON format valid"
else
    echo "✗ JSON format invalid"
    exit 1
fi

# Extract key parameters for validation
echo ""
echo "Key Parameter Values:"
echo "====================="

# TVC parameters
echo "Torrent Variant Caller:"
echo "  - SNP min allele freq: $(jq -r '.torrent_variant_caller.snp_min_allele_freq' "$PARAM_FILE")"
echo "  - Indel min allele freq: $(jq -r '.torrent_variant_caller.indel_min_allele_freq' "$PARAM_FILE")"
echo "  - Hotspot min allele freq: $(jq -r '.torrent_variant_caller.hotspot_min_allele_freq' "$PARAM_FILE")"
echo "  - Min coverage: $(jq -r '.torrent_variant_caller.snp_min_coverage' "$PARAM_FILE")"

# Freebayes parameters  
echo ""
echo "Freebayes:"
echo "  - General min alt allele freq: $(jq -r '.freebayes.gen_min_alt_allele_freq' "$PARAM_FILE")"
echo "  - General min indel alt allele freq: $(jq -r '.freebayes.gen_min_indel_alt_allele_freq' "$PARAM_FILE")"
echo "  - Min coverage: $(jq -r '.freebayes.gen_min_coverage' "$PARAM_FILE")"

# Long indel assembler
echo ""
echo "Long Indel Assembler:"
echo "  - Min variant frequency: $(jq -r '.long_indel_assembler.min_var_freq' "$PARAM_FILE")"
echo "  - Min variant count: $(jq -r '.long_indel_assembler.min_var_count' "$PARAM_FILE")"

# Validate parameter ranges
echo ""
echo "Parameter Validation:"
echo "===================="

# Check frequency parameters are between 0 and 1
check_frequency() {
    local param_name="$1"
    local param_value="$2"
    
    if [[ "$param_value" =~ ^[0-9]+\.?[0-9]*$ ]] && (( $(echo "$param_value >= 0" | bc -l) )) && (( $(echo "$param_value <= 1" | bc -l) )); then
        echo "✓ $param_name: $param_value (valid)"
    else
        echo "✗ $param_name: $param_value (invalid - should be 0.0-1.0)"
    fi
}

# Check integer parameters
check_integer() {
    local param_name="$1" 
    local param_value="$2"
    local min_val="${3:-0}"
    
    if [[ "$param_value" =~ ^[0-9]+$ ]] && (( param_value >= min_val )); then
        echo "✓ $param_name: $param_value (valid)"
    else
        echo "✗ $param_name: $param_value (invalid - should be integer ≥ $min_val)"
    fi
}

# Validate frequency parameters
check_frequency "SNP min allele freq" "$(jq -r '.torrent_variant_caller.snp_min_allele_freq' "$PARAM_FILE")"
check_frequency "Indel min allele freq" "$(jq -r '.torrent_variant_caller.indel_min_allele_freq' "$PARAM_FILE")"
check_frequency "Hotspot min allele freq" "$(jq -r '.torrent_variant_caller.hotspot_min_allele_freq' "$PARAM_FILE")"
check_frequency "Freebayes general min alt allele freq" "$(jq -r '.freebayes.gen_min_alt_allele_freq' "$PARAM_FILE")"
check_frequency "Freebayes general min indel alt allele freq" "$(jq -r '.freebayes.gen_min_indel_alt_allele_freq' "$PARAM_FILE")"
check_frequency "Long indel min var freq" "$(jq -r '.long_indel_assembler.min_var_freq' "$PARAM_FILE")"

# Validate integer parameters
check_integer "SNP min coverage" "$(jq -r '.torrent_variant_caller.snp_min_coverage' "$PARAM_FILE")" 1
check_integer "Indel min coverage" "$(jq -r '.torrent_variant_caller.indel_min_coverage' "$PARAM_FILE")" 1
check_integer "Freebayes min coverage" "$(jq -r '.freebayes.gen_min_coverage' "$PARAM_FILE")" 1
check_integer "Long indel min var count" "$(jq -r '.long_indel_assembler.min_var_count' "$PARAM_FILE")" 1

echo ""
echo "Validation complete."