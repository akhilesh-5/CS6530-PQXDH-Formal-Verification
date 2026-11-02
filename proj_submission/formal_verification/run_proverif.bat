@echo off
setlocal

set PROVERIF_BIN=proverif
if exist "..\..\activity3_4\bin\proverif.exe" (
    set PROVERIF_BIN=..\..\activity3_4\bin\proverif.exe
)

if not exist "outputs" mkdir outputs

echo ===============================================================================
echo CS6530 Applied Cryptography: Formal Verification of PQXDH (Activities 3 and 4)
echo ===============================================================================

echo [1/4] Activity 3 Baseline: PQXDH Revision 1 (KEM Re-encapsulation)...
"%PROVERIF_BIN%" 01_pqxdh_rev1_reencaps_vulnerable.pv > outputs\01_pqxdh_rev1_reencaps_output.txt 2>&1
echo Output saved to outputs\01_pqxdh_rev1_reencaps_output.txt

echo [2/4] Activity 3 Corrected: PQXDH Revision 2 (AD Bound PQPK)...
"%PROVERIF_BIN%" 02_pqxdh_rev2_hardened.pv > outputs\02_pqxdh_rev2_hardened_output.txt 2>&1
echo Output saved to outputs\02_pqxdh_rev2_hardened_output.txt

echo [3/4] Activity 4 Exploration 1: Algorithm/Key-Type Confusion (ConfuseKemEc)...
"%PROVERIF_BIN%" 03_activity4_confuse_kem_ec.pv > outputs\03_activity4_confuse_kem_ec_output.txt 2>&1
echo Output saved to outputs\03_activity4_confuse_kem_ec_output.txt

echo [4/4] Activity 4 Exploration 2: Direct KDF Transcript Binding (Proposal P2)...
"%PROVERIF_BIN%" 04_activity4_pqxdh_kdf_bound.pv > outputs\04_activity4_pqxdh_kdf_bound_output.txt 2>&1
echo Output saved to outputs\04_activity4_pqxdh_kdf_bound_output.txt

echo.
echo All 4 ProVerif models executed. Verification complete.
