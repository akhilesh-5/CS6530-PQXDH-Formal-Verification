# CS6530 Applied Cryptography: Activities 3 & 4 Formal Verification Package
**Course:** CS6530 Applied Cryptography | Jul–Nov 2026 | Indian Institute of Technology Madras  
**Theme:** Theme 2 — Post-Quantum Secure Messaging & Key Agreement  
**Protocol Target:** Signal PQXDH (Post-Quantum Extended Triple Diffie–Hellman)  
**Primary Reference:** K. Bhargavan, C. Jacomme, F. Kiefer, and R. Schmidt, *"Formal Verification of the PQXDH Post-Quantum Key Agreement Protocol for End-to-End Secure Messaging,"* in *USENIX Security '24*, 2024.  
**Team Members:**  
* **Akhilesh K.R** (`CS26E001`)  
* **D R Santhosh** (`CS26E004`)  
* **Mysha Ali** (`CS26E008`)  

---

## 1. Directory Structure

```
activity3_4/
├── bin/
│   └── proverif.exe                          # Standalone ProVerif 2.05 executable (Windows x64)
├── models/
│   ├── 01_pqxdh_rev1_reencaps_vulnerable.pv  # Activity 3 Baseline: PQXDH Rev 1 KEM Re-encapsulation flaw
│   ├── 02_pqxdh_rev2_hardened.pv             # Activity 3 Corrected: PQXDH Rev 2 Associated Data binding
│   ├── 03_activity4_confuse_kem_ec.pv        # Activity 4 Exploration 1: Algorithm/Key-Type Confusion
│   └── 04_activity4_pqxdh_kdf_bound.pv       # Activity 4 Exploration 2: Direct KDF Transcript Binding
├── outputs/
│   ├── 01_pqxdh_rev1_reencaps_output.txt     # Output log: Attack trace found (RESULT is false)
│   ├── 02_pqxdh_rev2_hardened_output.txt     # Output log: Proof successful (RESULT is true)
│   ├── 03_activity4_confuse_kem_ec_output.txt# Output log: Key-type confusion (cannot be proved)
│   └── 04_activity4_pqxdh_kdf_bound_output.txt# Output log: KDF binding proof (RESULT is true)
├── scripts/
│   ├── run_all.bat                           # One-click Windows CMD batch runner
│   ├── run_all.ps1                           # Formatted PowerShell runner with per-test timing
│   └── run_all.sh                            # Linux / WSL runner
├── README.md                                 # This file (quickstart & verification instructions)
└── ACTIVITY_3_AND_4_REPORT.md                # Comprehensive technical & academic report
```

---

## 2. Execution Guide

### Prerequisites
* **Windows (Native):** No installation required. Pre-compiled standalone `bin/proverif.exe` (ProVerif 2.05) is included directly.
* **Linux / WSL:** Install `proverif` via `opam install proverif` or package manager `sudo apt install proverif`.

### How to Run

#### Option A: Windows PowerShell Runner (Recommended)
```powershell
cd D:\IITM\Applied_Crypto\Project\activity3_4\scripts
.\run_all.ps1
```

#### Option B: Windows CMD Batch Runner
```cmd
cd D:\IITM\Applied_Crypto\Project\activity3_4\scripts
run_all.bat
```

#### Option C: Linux / WSL Runner
```bash
cd activity3_4/scripts
chmod +x run_all.sh
./run_all.sh
```

---

## 3. Verification Summary Table

| # | Model File | Subsystem & Property Tested | Verification Query Goal | ProVerif Output | Security Meaning |
| :---: | :--- | :--- | :--- | :---: | :--- |
| **01** | `01_pqxdh_rev1_reencaps_vulnerable.pv` | **Activity 3 Baseline:** PQXDH Revision 1 (Unbound KEM) | Responder Injective Agreement on PQPK under Dolev-Yao attacker | **`is false`**<br>(Attack trace synthesized) | **Vulnerability Reproduced:** Attacker re-encapsulates shared secret under Bob's second key, breaking session independence. |
| **02** | `02_pqxdh_rev2_hardened.pv` | **Activity 3 Corrected:** PQXDH Revision 2 (AD Bound PQPK) | Responder Injective Agreement with PQPK in Associated Data | **`is true`**<br>(Proof holds) | **Correction Verified:** Binding Bob's `PQPK` into AEAD AD eliminates re-encapsulation attack. |
| **03** | `03_activity4_confuse_kem_ec.pv` | **Activity 4 Exploration 1:** Algorithm/Key-Type Confusion | Secrecy of Initiator Key when `encodeEC(x) = encodeKEM(x)` | **`cannot be proved`**<br>(Trace found) | **Finding:** Lack of domain separation allows substituting SPK for PQPK, yielding a weak DH value as KEM secret. |
| **04** | `04_activity4_pqxdh_kdf_bound.pv` | **Activity 4 Exploration 2:** Direct KDF Transcript Binding | Responder Injective Agreement with PQPK in KDF (pure classical AD) | **`is true`**<br>(Proof holds) | **Finding:** Binding `PQPK` directly into KDF derivation ensures session independence even without AEAD AD dependency. |

---

## 4. Equal 3-Member Contribution Split

* **Akhilesh K.R (`CS26E001`):** PQXDH protocol architecture, prekey bundle analysis, Dolev-Yao attacker capabilities, and trust/compromise model.
* **D R Santhosh (`CS26E004`):** Formal modeling in ProVerif, Activity 3 Bounded Reproduction of PQXDH Rev 1 vulnerability (`01`) vs. Rev 2 correction (`02`), and attack trace analysis.
* **Mysha Ali (`CS26E008`):** Activity 4 Controlled Engineering Explorations: key-type domain confusion (`03`), direct KDF transcript binding (`04`), and formal security interpretation.
