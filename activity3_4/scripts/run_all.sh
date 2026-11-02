#!/bin/bash
# ===============================================================================
# CS6530 Applied Cryptography - Activities 3 & 4 Formal Verification Suite
# Linux / WSL ProVerif Runner (Signal PQXDH Analysis)
# Authors: Akhilesh K.R (CS26E001), D R Santhosh (CS26E004), Mysha Ali (CS26E008)
# ===============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASE_DIR="$SCRIPT_DIR/.."
MODELS_DIR="$BASE_DIR/models"
OUTPUTS_DIR="$BASE_DIR/outputs"

# Determine ProVerif executable (proverif in PATH or windows binary via wine/wsl)
if command -v proverif &> /dev/null; then
    PROVERIF_BIN="proverif"
elif [ -f "$BASE_DIR/bin/proverif.exe" ]; then
    PROVERIF_BIN="$BASE_DIR/bin/proverif.exe"
else
    echo "[ERROR] ProVerif executable not found."
    exit 1
fi

mkdir -p "$OUTPUTS_DIR"

echo "==============================================================================="
echo " CS6530 Applied Cryptography: Activities 3 & 4 Formal Verification Suite"
echo " Protocol Target: Signal PQXDH Key Agreement Protocol"
echo " Using ProVerif: $PROVERIF_BIN"
echo "==============================================================================="

run_test() {
    local num="$1"
    local name="$2"
    local model="$3"
    local output="$4"
    echo "-------------------------------------------------------------------------------"
    echo "[$num] Running $name..."
    "$PROVERIF_BIN" "$MODELS_DIR/$model" > "$OUTPUTS_DIR/$output" 2>&1
    grep "RESULT" "$OUTPUTS_DIR/$output" || true
    echo "Output: $OUTPUTS_DIR/$output"
    echo ""
}

run_test "1/4" "Activity 3 Baseline: PQXDH Revision 1 (KEM Re-encapsulation)" "01_pqxdh_rev1_reencaps_vulnerable.pv" "01_pqxdh_rev1_reencaps_output.txt"
run_test "2/4" "Activity 3 Corrected: PQXDH Revision 2 (AD Bound PQPK)" "02_pqxdh_rev2_hardened.pv" "02_pqxdh_rev2_hardened_output.txt"
run_test "3/4" "Activity 4 Exploration 1: Algorithm/Key-Type Confusion" "03_activity4_confuse_kem_ec.pv" "03_activity4_confuse_kem_ec_output.txt"
run_test "4/4" "Activity 4 Exploration 2: Direct KDF Transcript Binding" "04_activity4_pqxdh_kdf_bound.pv" "04_activity4_pqxdh_kdf_bound_output.txt"

echo "==============================================================================="
echo " Complete! Check outputs in $OUTPUTS_DIR"
echo "==============================================================================="
