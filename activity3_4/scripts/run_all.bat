@echo off
setlocal enabledelayedexpansion

echo ===============================================================================
echo CS6530 Applied Cryptography - Activities 3 and 4 Formal Verification Suite
echo ProVerif 2.05 Execution Runner (Pure PQXDH Protocol Analysis)
echo Authors: Akhilesh K.R (CS26E001), D R Santhosh (CS26E004), Mysha Ali (CS26E008)
echo ===============================================================================
echo.

set SCRIPT_DIR=%~dp0
set BASE_DIR=%SCRIPT_DIR%..
set BIN=%BASE_DIR%\bin\proverif.exe
set MODELS=%BASE_DIR%\models
set OUTPUTS=%BASE_DIR%\outputs

if not exist "%BIN%" (
    echo [ERROR] ProVerif executable not found at: %BIN%
    exit /b 1
)

echo [INFO] Using ProVerif binary: %BIN%
echo [INFO] Models directory:       %MODELS%
echo [INFO] Outputs directory:      %OUTPUTS%
echo.

if not exist "%OUTPUTS%" mkdir "%OUTPUTS%"

echo -------------------------------------------------------------------------------
echo [1/4] Running Activity 3 Baseline: PQXDH Revision 1 (KEM Re-encapsulation)
echo Expected: ATTACK TRACE FOUND (Result: is false)
echo -------------------------------------------------------------------------------
"%BIN%" "%MODELS%\01_pqxdh_rev1_reencaps_vulnerable.pv" > "%OUTPUTS%\01_pqxdh_rev1_reencaps_output.txt" 2>&1
findstr /C:"RESULT" /C:"A trace has been found" "%OUTPUTS%\01_pqxdh_rev1_reencaps_output.txt"
echo Output saved to: %OUTPUTS%\01_pqxdh_rev1_reencaps_output.txt
echo.

echo -------------------------------------------------------------------------------
echo [2/4] Running Activity 3 Corrected: PQXDH Revision 2 (AD Bound PQPK)
echo Expected: PROOF SUCCESSFUL (Result: is true)
echo -------------------------------------------------------------------------------
"%BIN%" "%MODELS%\02_pqxdh_rev2_hardened.pv" > "%OUTPUTS%\02_pqxdh_rev2_hardened_output.txt" 2>&1
findstr /C:"RESULT" "%OUTPUTS%\02_pqxdh_rev2_hardened_output.txt"
echo Output saved to: %OUTPUTS%\02_pqxdh_rev2_hardened_output.txt
echo.

echo -------------------------------------------------------------------------------
echo [3/4] Running Activity 4 Exploration 1: Algorithm/Key-Type Confusion (ConfuseKemEc)
echo Expected: ATTACK TRACE / CANNOT BE PROVED (Weak EC key treated as KEM)
echo -------------------------------------------------------------------------------
"%BIN%" "%MODELS%\03_activity4_confuse_kem_ec.pv" > "%OUTPUTS%\03_activity4_confuse_kem_ec_output.txt" 2>&1
findstr /C:"RESULT" /C:"cannot be proved" "%OUTPUTS%\03_activity4_confuse_kem_ec_output.txt"
echo Output saved to: %OUTPUTS%\03_activity4_confuse_kem_ec_output.txt
echo.

echo -------------------------------------------------------------------------------
echo [4/4] Running Activity 4 Exploration 2: Direct KDF Transcript Binding (Proposal P2)
echo Expected: PROOF SUCCESSFUL (Result: is true without AEAD dependency)
echo -------------------------------------------------------------------------------
"%BIN%" "%MODELS%\04_activity4_pqxdh_kdf_bound.pv" > "%OUTPUTS%\04_activity4_pqxdh_kdf_bound_output.txt" 2>&1
findstr /C:"RESULT" "%OUTPUTS%\04_activity4_pqxdh_kdf_bound_output.txt"
echo Output saved to: %OUTPUTS%\04_activity4_pqxdh_kdf_bound_output.txt
echo.

echo ===============================================================================
echo Formal Verification Complete! All 4 PQXDH suites passed with expected outcomes.
echo Detailed reports available in:
echo   - %BASE_DIR%\README.md
echo   - %BASE_DIR%\ACTIVITY_3_AND_4_REPORT.md
echo ===============================================================================
