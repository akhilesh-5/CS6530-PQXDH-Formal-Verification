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
cd activity3_4\scripts
.\run_all.ps1
```

#### Option B: Windows CMD Batch Runner
```cmd
cd activity3_4\scripts
run_all.bat
```

#### Option C: Linux / WSL Runner
```bash
cd activity3_4/scripts
chmod +x run_all.sh
./run_all.sh
```

#### Option D: Standalone Execution for Activity 4 Exploration 1
To run only the Key-Type Confusion exploration model:
```cmd
cd activity3_4
.\bin\proverif.exe models\03_activity4_confuse_kem_ec.pv
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

## 4. Deep Dive: Activity 4 Exploration 1 (Key-Type Confusion)

* **Lead Contributor:** D R Santhosh (`CS26E004`)
* **File:** `models/03_activity4_confuse_kem_ec.pv`
* **Log:** `outputs/03_activity4_confuse_kem_ec_output.txt`

### Threat Model & Formulation
In hybrid handshakes combining classical elliptic curve cryptography with post-quantum lattice-based KEMs, public keys are transmitted over untrusted channels. If public keys lack cryptographic domain separation tags or explicit type prefixes, an attacker can coerce one public key type into another.

In `03_activity4_confuse_kem_ec.pv`, we model the absence of wire-format type tags:
```proverif
fun encodeEC(point): bitstring.
fun encodeKEM(kempub): bitstring.
fun ECasKEM(point): kempub [typeConverter].

(* Equation modeling cross-primitive encoding collision *)
equation forall x: scalar; encodeKEM(ECasKEM(SMUL(x, G))) = encodeEC(SMUL(x, G)).

(* Equation modeling weakness: an EC point coerced as a KEM key yields a recoverable secret *)
reduc forall x: scalar, k: bitstring; weakECasKEM(penc(ECasKEM(SMUL(x, G)), k)) = k.
```

### Attack Trace Analysis
1. The active Dolev-Yao attacker intercepts Bob's prekey bundle from the server.
2. The attacker delivers Bob's classical Signed Prekey `SPKB` in place of the post-quantum prekey `PQPKB`.
3. Because `encodeKEM(ECasKEM(SPKB)) = encodeEC(SPKB)`, the XEdDSA signature check succeeds:
   `verify(IKB_p, encodeKEM(PQPKB_p), PQPKB_sig) = true`
4. Alice performs post-quantum encapsulation against Bob's EC key:
   `(CT, SS) = pqkem_enc(ECasKEM(SPKB))`
5. The attacker recovers the shared secret via `weakECasKEM(CT) = SS`, effectively stripping the post-quantum protection layer and degrading the hybrid session to classical Diffie–Hellman.
6. ProVerif verifies this failure mode:
   ```text
   RESULT event(InitDone(a,b,useOPK_2,opk,spk,pqpk,ts))@i_1 && attacker(ts) ==> ... cannot be proved.
   A trace has been found.
   ```

### Engineering Mitigation
To prevent cross-primitive type confusion, protocol implementations must prepend unforgeable 1-byte algorithm/domain identifiers (e.g., `0x01` for Curve25519, `0x02` for ML-KEM-1024) to all public keys before signing and hashing.

---

## 5. Equal 3-Member Contribution Split

* **Akhilesh K.R (`CS26E001`):** Activities 1 & 2 (Theoretical Foundations & Security Failure Modes) + Activity 4 Exploration 2 (Direct KDF Transcript Binding - Proposal P2: `04_activity4_pqxdh_kdf_bound.pv`).
* **Mysha Ali (`CS26E008`):** Activity 3 (Bounded Formal Reproduction in ProVerif: Baseline Rev 1 Vulnerability `01` vs. Rev 2 Hardened Fix `02`).
* **D R Santhosh (`CS26E004`):** Activity 4 Exploration 1 (Key-Type Confusion Exploration in ProVerif: `03_activity4_confuse_kem_ec.pv`, Automated Trace Extraction, and Type-Tagging Domain Separation Analysis).
*(Activities 5 & 6 Collaborative Synthesis across All Members)*
