<#
.SYNOPSIS
    Runs the complete ProVerif Formal Verification Suite for Activities 3 & 4 (Signal PQXDH Analysis).
.DESCRIPTION
    CS6530 Applied Cryptography | Jul-Nov 2026 | IIT Madras
    Theme 2: Post-Quantum Secure Messaging & Key Agreement
    Authors: Akhilesh K.R (CS26E001), D R Santhosh (CS26E004), Mysha Ali (CS26E008)
#>

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$BaseDir = Split-Path -Parent $ScriptDir
$Bin = Join-Path $BaseDir "bin\proverif.exe"
$ModelsDir = Join-Path $BaseDir "models"
$OutputsDir = Join-Path $BaseDir "outputs"

if (-not (Test-Path $Bin)) {
    Write-Error "ProVerif binary not found at: $Bin"
    exit 1
}

if (-not (Test-Path $OutputsDir)) {
    New-Item -ItemType Directory -Path $OutputsDir -Force | Out-Null
}

Write-Host "===============================================================================" -ForegroundColor Cyan
Write-Host " CS6530 Applied Cryptography: Activities 3 & 4 Formal Verification" -ForegroundColor Cyan
Write-Host " ProVerif 2.05 Automated Verification Suite (Signal PQXDH Analysis)" -ForegroundColor Cyan
Write-Host "===============================================================================" -ForegroundColor Cyan
Write-Host "Executable: $Bin" -ForegroundColor Gray
Write-Host "Models:     $ModelsDir" -ForegroundColor Gray
Write-Host "Outputs:    $OutputsDir" -ForegroundColor Gray
Write-Host ""

$Suites = @(
    @{
        Id = "1/4"
        Name = "Activity 3 Baseline: PQXDH Revision 1 (KEM Re-encapsulation)"
        Model = "01_pqxdh_rev1_reencaps_vulnerable.pv"
        Output = "01_pqxdh_rev1_reencaps_output.txt"
        Expected = "ATTACK FOUND (is false)"
    },
    @{
        Id = "2/4"
        Name = "Activity 3 Corrected: PQXDH Revision 2 (AD Bound PQPK)"
        Model = "02_pqxdh_rev2_hardened.pv"
        Output = "02_pqxdh_rev2_hardened_output.txt"
        Expected = "PROOF SUCCESSFUL (is true)"
    },
    @{
        Id = "3/4"
        Name = "Activity 4 Exploration 1: Algorithm/Key-Type Confusion (ConfuseKemEc)"
        Model = "03_activity4_confuse_kem_ec.pv"
        Output = "03_activity4_confuse_kem_ec_output.txt"
        Expected = "ATTACK / CANNOT BE PROVED"
    },
    @{
        Id = "4/4"
        Name = "Activity 4 Exploration 2: Direct KDF Transcript Binding (Proposal P2)"
        Model = "04_activity4_pqxdh_kdf_bound.pv"
        Output = "04_activity4_pqxdh_kdf_bound_output.txt"
        Expected = "PROOF SUCCESSFUL (is true)"
    }
)

$ResultsTable = @()

foreach ($suite in $Suites) {
    Write-Host "-------------------------------------------------------------------------------" -ForegroundColor Yellow
    Write-Host "[$($suite.Id)] Running $($suite.Name)..." -ForegroundColor Yellow
    Write-Host "Model: $($suite.Model) | Expected: $($suite.Expected)" -ForegroundColor Gray
    
    $modelPath = Join-Path $ModelsDir $suite.Model
    $outputPath = Join-Path $OutputsDir $suite.Output
    
    $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
    & $Bin $modelPath > $outputPath 2>&1
    $stopwatch.Stop()
    $duration = [math]::Round($stopwatch.Elapsed.TotalSeconds, 2)
    
    # Parse results
    $resLines = Get-Content $outputPath | Select-String -Pattern "RESULT" | ForEach-Object { $_.Line.Trim() }
    $resSummary = ($resLines -join "; ")
    if ($resSummary.Length -gt 70) {
        $resSummary = $resSummary.Substring(0, 67) + "..."
    }
    
    $statusColor = "Green"
    if ($resLines -match "is false" -or $resLines -match "cannot be proved") {
        $statusColor = "Red"
    }
    
    Write-Host "Result in ${duration}s: " -NoNewline -ForegroundColor Gray
    Write-Host $resSummary -ForegroundColor $statusColor
    Write-Host "Log saved: $outputPath" -ForegroundColor DarkGray
    Write-Host ""
    
    $ResultsTable += [PSCustomObject]@{
        Id = $suite.Id
        Suite = $suite.Name
        Model = $suite.Model
        Expected = $suite.Expected
        Result = $resSummary
        Time = "${duration}s"
    }
}

Write-Host "===============================================================================" -ForegroundColor Cyan
Write-Host " Formal Verification Suite Summary" -ForegroundColor Cyan
Write-Host "===============================================================================" -ForegroundColor Cyan
$ResultsTable | Format-Table -AutoSize
Write-Host "Full detailed report: $(Join-Path $BaseDir 'ACTIVITY_3_AND_4_REPORT.md')" -ForegroundColor Green
