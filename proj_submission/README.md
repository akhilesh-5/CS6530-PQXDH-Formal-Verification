# CS6530 Applied Cryptography — Course Project Final Submission
## Post-Quantum Secure Messaging: Formal Analysis, Failure Reproduction, and Hardened Protocol Design in Signal PQXDH

**Course:** CS6530 Applied Cryptography (Jul–Nov 2026) | IIT Madras  
**Instructor:** Prof. Manikantan  
**Theme:** Theme 2 — Post-Quantum Secure Messaging  

**Team Members & Equal 3-Person Split:**
* **Akhilesh K.R (CS26E001):** Activities 1 & 2 (Theoretical Foundations & Failure Analysis) + Activity 4 Exploration 2 (Direct KDF Binding - P2)
* **Mysha Ali (CS26E008):** Activity 3 (Bounded Formal Reproduction in ProVerif: Baseline Rev 1 vs Rev 2 Fix)
* **D R Santhosh (CS26E004):** Activity 4 Exploration 1 (Key-Type Confusion Exploration in ProVerif)
*(Activities 5 & 6 Collaborative Synthesis across All Members)*

---

## 1. Project Overview & Deliverables
This repository contains the complete technical deliverables for CS6530 Course Project Theme 2: Post-Quantum Secure Messaging. We investigate the post-quantum transition of Signal's key agreement protocol from classical X3DH to hybrid PQXDH (combining Curve25519 with ML-KEM-1024 / Kyber). 

We formally evaluate and verify the security properties, vulnerabilities, and hardening mechanisms using **ProVerif 2.05** (Applied Pi-Calculus), reproducing primary findings from Bhargavan et al. (USENIX Security '24) and exploring novel key-typing and transcript-binding designs.

### Clean Repository Layout:
```
Project/
├── activity3_4/                               # Working verification suite with executables
│   ├── bin/proverif.exe                       # Standalone 64-bit Windows ProVerif 2.05 executable
│   ├── models/                                # 4 Preprocessed, self-contained ProVerif models
│   │   ├── 01_pqxdh_rev1_reencaps_vulnerable.pv  # Activity 3: Rev 1 KEM Re-encapsulation attack
│   │   ├── 02_pqxdh_rev2_hardened.pv             # Activity 3: Rev 2 Associated Data binding fix
│   │   ├── 03_activity4_confuse_kem_ec.pv        # Activity 4: Key-Type Confusion exploration
│   │   └── 04_activity4_pqxdh_kdf_bound.pv       # Activity 4: Direct KDF Transcript Binding (Proposal P2)
│   ├── outputs/                               # Complete verified execution logs & traces
│   │   ├── 01_pqxdh_rev1_reencaps_output.txt
│   │   ├── 02_pqxdh_rev2_hardened_output.txt
│   │   ├── 03_activity4_confuse_kem_ec_output.txt
│   │   └── 04_activity4_pqxdh_kdf_bound_output.txt
│   ├── scripts/                               # Cross-platform execution scripts
│   │   ├── run_all.bat                        # Windows CMD batch runner
│   │   ├── run_all.ps1                        # Windows PowerShell automated suite
│   │   └── run_all.sh                         # Linux / macOS Bash runner
│   ├── README.md                              # Activity 3 & 4 user manual
│   └── ACTIVITY_3_AND_4_REPORT.md             # Comprehensive Activities 3 & 4 technical breakdown
│
├── guidelines_and_phase1/                     # Course administration & baseline report
│   ├── CS6530_Jul_Nov2026_Project_Phase2_andProjectCompletion_Guidelines.pdf
│   ├── CS26E001_CS26E004_CS26E008_Phase1_Report.pdf
│   ├── phase1_report_extracted.txt
│   ├── phase2_guidelines_extracted.txt
│   └── theme2_req_extracted.txt
│
└── proj_submission/                           # Official Moodle Submission Artifacts
    ├── README.md                              # This submission manual & reproduction guide
    ├── project_overview.md                    # Project blueprint, viva defense Q&A, and marks matrix
    ├── formal_verification/                   # ProVerif verification models & scripts
    │   ├── 01_pqxdh_rev1_reencaps_vulnerable.pv
    │   ├── 02_pqxdh_rev2_hardened.pv
    │   ├── 03_activity4_confuse_kem_ec.pv
    │   ├── 04_activity4_pqxdh_kdf_bound.pv
    │   ├── run_proverif.bat
    │   ├── run_proverif.sh
    │   └── outputs/                           # Raw ProVerif output logs
    ├── presentation/                          # Presentation Slides (Strict 4 Content Slides + Title)
    │   ├── presentation_structure.md          # 10-minute presentation guide & speaker cue sheet
    │   └── slides_content.txt                 # Formatted content for PowerPoint / PDF slides
    └── report/                                # Technical Report & Artefact Documentation
        ├── CS6530_Project_CS26E001_CS26E004_CS26E008_Report.md  # Final Technical Report (Artefact 1)
        ├── demo_video_script.md               # 5–8 Minute Demonstration Video Script (Artefact 3)
        ├── security_evolution_matrix.md       # Activity 5: Comparative Matrix ([R1]–[R4])
        └── engineering_lessons.md             # Activity 6: Five Generalizable Engineering Lessons
```

---

## 2. Provenance of Resources (Mandatory Guideline Distinction)

| Component | Source / Provenance | Description / Modification |
| :--- | :--- | :--- |
| **ProVerif 2.05 Engine (`proverif.exe`)** | Inria / Bruno Blanchet | Automated symbolic protocol verifier based on the applied pi-calculus under the Dolev-Yao attacker model. |
| **Baseline PQXDH Artifact (`pqxdh-analysis`)** | Primary Paper Authors (Bhargavan et al., USENIX '24) | Macro-templated ProVerif specifications for Signal PQXDH. |
| **Preprocessed Self-Contained Models (`01`, `02`)** | **Student Adaptation & Preprocessing** | Extracted and transformed into standalone, self-contained ProVerif models with explicit algebraic re-encapsulation rewrite rules to reproduce the exact attack trace and verified fix. |
| **Exploration 1: Key Confusion (`03`)** | **Student-Created Novel Model** | Formalized the unification of EC and KEM public-key encodings to mathematically prove that omitting domain prefixes allows active downgrade to predictable keys (`weakECasKEM`). |
| **Exploration 2: Direct KDF Binding (`04`)** | **Student-Created Novel Model** | Formalized and proved Signal Revision 3 Proposal P2, binding the KEM public key directly into the root HKDF extraction without modifying symmetric AEAD Associated Data. |
| **Security Matrix & Engineering Lessons** | **Student Analysis & Synthesis** | Comparative evaluation synthesizing literature [R1], [R2], [R3], [R4] and extracting 5 core principles for real-world post-quantum protocol migrations. |

---

## 3. Quick Reproduction (Single-Command Execution)

### On Windows:
Open PowerShell and run:
```powershell
cd activity3_4\scripts
.\run_all.ps1
```
Or double-click `activity3_4\scripts\run_all.bat`.

### On Linux / macOS:
```bash
cd activity3_4/scripts
chmod +x run_all.sh
./run_all.sh
```

### Verification Output Summary:
```
========================================================================================================
Id  Suite                                    Model                                  Result
--  -----                                    -----                                  ------
1/4 Activity 3: PQXDH Revision 1 Baseline    01_pqxdh_rev1_reencaps_vulnerable.pv   ATTACK FOUND (is false)
2/4 Activity 3: PQXDH Revision 2 Corrected   02_pqxdh_rev2_hardened.pv              PROOF SUCCESSFUL (is true)
3/4 Activity 4: Key-Type Confusion           03_activity4_confuse_kem_ec.pv         ATTACK (cannot be proved)
4/4 Activity 4: Direct KDF Binding (P2)      04_activity4_pqxdh_kdf_bound.pv        PROOF SUCCESSFUL (is true)
========================================================================================================
```

---

## 4. Final Submission Checklist for Moodle
Before Monday, 2 November 2026, 11:59 PM IST, upload the 3 required artefacts:
1. **Artefact 1 (Technical Report PDF):** Convert `report/CS6530_Project_CS26E001_CS26E004_CS26E008_Report.md` to PDF named `CS6530_Project_CS26E001_CS26E004_CS26E008_Report.pdf`.
2. **Artefact 2 (Code & Models ZIP):** Compress the `proj_submission` folder (containing `formal_verification/`, `report/`, `presentation/`, `README.md`) into `CS6530_Project_CS26E001_CS26E004_CS26E008_Code.zip`.
3. **Artefact 3 (Demo Video MP4 / Link):** Record the 6-minute walkthrough using `report/demo_video_script.md` and upload the MP4 file (or submit a PDF with the unlisted YouTube/Drive link) named `CS6530_Project_CS26E001_CS26E004_CS26E008_Demo.pdf`.
