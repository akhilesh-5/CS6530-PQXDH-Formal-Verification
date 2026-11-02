# CS6530 Course Project: Complete Demonstration Video Walkthrough Script (Artefact 3)

**Course:** CS6530 Applied Cryptography | Jul–Nov 2026 | Indian Institute of Technology Madras  
**Theme:** Theme 2 — Post-Quantum Secure Messaging & Key Agreement  
**Project Title:** Post-Quantum Secure Messaging: Formal Analysis, Failure Reproduction, and Hardened Protocol Design in Signal PQXDH  
**Deliverable Filename:** `CS6530_Project_CS26E001_CS26E004_CS26E008.mp4` (or PDF containing unlisted link)  
**Strict Video Length:** **7 minutes 30 seconds** (Strictly within the 5 to 8 minute course ceiling)  
**Presenters & Time Allocation:**
* **Akhilesh K.R (`CS26E001`):** `0:00 – 2:30` (2 mins 30 secs) — Project Structure, Activities 1 & 2, Launching Test Suite
* **Mysha Ali (`CS26E008`):** `2:30 – 5:00` (2 mins 30 secs) — Activity 3 Bounded Formal Reproduction (Rev 1 vs Rev 2)
* **D R Santhosh (`CS26E004`):** `5:00 – 7:35` (2 mins 35 secs) — Activity 4 Explorations, Activities 5 & 6 Synthesis, and Conclusion

---

## Video Recording Quick-Setup Checklist
1. **Screen Resolution:** 1920x1080 (1080p).
2. **Screen Arrangement:** Split screen:
   * **Left Side (50%):** VS Code (or File Explorer) showing the project files and models.
   * **Right Side (50%):** PowerShell terminal open at `D:\IITM\Applied_Crypto\Project`.
3. **Recording Software:** OBS Studio, Zoom (record locally), or Windows Game Bar (`Win + G`).
4. **Microphone Check:** Ensure all three speakers are clear and level-balanced.

---

## Complete Step-by-Step Storyboard & Verbatim Script

```
+-------------------------------------------------------------------------------------------------------------------+
| MINUTE-BY-MINUTE SPEAKER TIMELINE                                                                                 |
+-------------------------------------------------------------------------------------------------------------------+
| 0:00 – 0:50 | Akhilesh K.R  | Project Introduction & Decluttered Repository Tour                                  |
| 0:50 – 1:50 | Akhilesh K.R  | Activities 1 & 2: HNDL Threat, PQXDH Architecture & Failure Modes                   |
| 1:50 – 2:30 | Akhilesh K.R  | Execution Command: Launching ProVerif Automated Suite & Handover                     |
| 2:30 – 3:45 | Mysha Ali     | Activity 3: Revision 1 KEM Re-encapsulation Vulnerability (Model 01 & Attack Trace) |
| 3:45 – 5:00 | Mysha Ali     | Activity 3: Revision 2 Associated Data Hardening (Model 02 & Proof of Security)     |
| 5:00 – 5:50 | D R Santhosh  | Activity 4 Exploration 1: Algorithm/Key-Type Confusion (Model 03 & Weak Key Trace) |
| 5:50 – 6:40 | D R Santhosh  | Activity 4 Exploration 2: Direct KDF Transcript Binding Proposal P2 (Model 04 Proof)|
| 6:40 – 7:35 | D R Santhosh  | Activities 5 & 6: Security Evolution Matrix, 5 Engineering Lessons & Conclusion     |
+-------------------------------------------------------------------------------------------------------------------+
```

---

### PART 1: Project Tour, System & Threat Model, and Test Launch (0:00 – 2:30)
**Speaker:** Akhilesh K.R (`CS26E001`)  
**Target Duration:** 2 minutes 30 seconds  

#### Step 1.1: Project Introduction & Directory Structure (0:00 – 0:50)
* **Visual Action:**
  * Show fullscreen or left half with VS Code File Explorer focused on `D:\IITM\Applied_Crypto\Project`.
  * Expand the folders one by one: `bin/`, `models/`, `outputs/`, `scripts/`, `report/`, `presentation/`, `course_materials/`.
  * Highlight [`README.md`](file:///D:/IITM/Applied_Crypto/Project/README.md) and [`CS6530_Project_CS26E001_CS26E004_CS26E008_Code.zip`](file:///D:/IITM/Applied_Crypto/Project/CS6530_Project_CS26E001_CS26E004_CS26E008_Code.zip).
* **Verbatim Spoken Narration:**
  > "Hello everyone. Welcome to our demonstration video for CS6530 Applied Cryptography, Course Project Theme 2: Post-Quantum Secure Messaging. Our team consists of Akhilesh K.R, Mysha Ali, and D R Santhosh.
  > 
  > Before executing our automated verification suite, let me walk you through our clean, zero-duplicate project repository here on screen:
  > * In the `bin/` directory, we have the standalone 64-bit Windows binary for ProVerif 2.05, meaning the entire suite runs with zero external dependencies.
  > * In `models/`, we maintain our four formal applied pi-calculus models covering Activities 3 and 4.
  > * In `outputs/`, we store the automated verification logs, counterexample attack traces, and execution timings.
  > * In `scripts/`, we provide cross-platform runners: `run_all.bat` for Windows CMD, `run_all.ps1` for PowerShell, and `run_all.sh` for Linux and macOS.
  > * In `report/` and `presentation/`, we have our 15-page typeset technical report PDF, demonstration script, and strict 4-content-slide PowerPoint deck.
  > * And here in root, we have our master README, comprehensive viva guide, and the ready-to-submit Code ZIP archive."

#### Step 1.2: Activities 1 & 2 — System Model & Failure Analysis (0:50 – 1:50)
* **Visual Action:**
  * Open [`report/CS6530_Project_CS26E001_CS26E004_CS26E008_Report.pdf`](file:///D:/IITM/Applied_Crypto/Project/report/CS6530_Project_CS26E001_CS26E004_CS26E008_Report.pdf) to **Page 3 (Section 2: System and Security Model)** and **Page 5 (Section 3: Security Failure Analysis)**.
  * Hover cursor over the ASCII message exchange diagram and the equation:  
    `SK = KDF(KMAC256(DH1 || DH2 || DH3 || DH4 || SS_PQ))`
* **Verbatim Spoken Narration:**
  > "For Activities 1 and 2, we analyzed Signal's transition from classical X3DH to post-quantum PQXDH. Classical messaging relies on Curve25519 Diffie–Hellman, which is urgently vulnerable to Harvest-Now-Decrypt-Later (HNDL) attacks: adversaries record encrypted traffic today, waiting for a Cryptographically Relevant Quantum Computer to run Shor's algorithm and recover past messages.
  > 
  > To solve this, Signal PQXDH combines four classical DH operations with an IND-CCA2 lattice KEM: ML-KEM-1024 (Kyber-1024).
  > 
  > However, our Phase 1 cryptanalysis exposed the 'Primitive Substitution Fallacy': you cannot simply drop a KEM into a DH protocol. Diffie-Hellman has commutative symmetry ($g^{ab} = g^{ba}$), providing implicit mutual authentication. KEMs are strictly asymmetric.
  > 
  > Crucially, generic IND-CCA2 security protects ciphertexts under a single fixed public key, but does *not* guarantee public-key binding. In Revision 1, an attacker possessing one compromised key could re-encapsulate a shared secret under Bob's honest key, breaking session independence. Furthermore, if key encodings lack domain separation, an attacker can substitute classical EC keys for KEM keys."

#### Step 1.3: Launching the Automated Verification Suite (1:50 – 2:30)
* **Visual Action:**
  * Switch focus to the PowerShell terminal window on the right side.
  * Type the exact command and hit Enter:
    ```powershell
    cd scripts
    .\run_all.ps1
    ```
  * Show the colored banner appearing:
    `CS6530 Applied Cryptography: Activities 3 & 4 Formal Verification`
    `ProVerif 2.05 Automated Verification Suite (Signal PQXDH Analysis)`
  * Watch Test 1 start: `[1/4] Running Activity 3 Baseline: PQXDH Revision 1...`
* **Verbatim Spoken Narration:**
  > "To mathematically verify these findings, we built a fully automated verification harness. In the PowerShell terminal on the right, I navigate into the scripts directory and execute `run_all.ps1`.
  > 
  > As you see on screen, the script locates our standalone `proverif.exe` binary and launches sequential verification of all four models. It captures execution times, verifies injective agreement queries, and automatically saves complete logs to the `outputs/` folder.
  > 
  > While Test 1 executes, I now hand over to Mysha Ali to walk through our Activity 3 formal reproduction."

---

### PART 2: Activity 3 — Bounded Formal Reproduction in ProVerif (2:30 – 5:00)
**Speaker:** Mysha Ali (`CS26E008`)  
**Target Duration:** 2 minutes 30 seconds  

#### Step 2.1: Activity 3 Baseline — Revision 1 Vulnerability & Attack Trace (2:30 – 3:45)
* **Visual Action:**
  * Point to the PowerShell terminal where Test 1 finishes:
    `Result in 30.67s: RESULT event(RespondDone(b,a,useOPK_2,opk,spk,pqpk,ts))@i_1 ==> ... is false.`
  * Open [`models/01_pqxdh_rev1_reencaps_vulnerable.pv`](file:///D:/IITM/Applied_Crypto/Project/models/01_pqxdh_rev1_reencaps_vulnerable.pv) on the left side of the screen.
  * Scroll to **Line 127** (injective agreement query) and **Line 205 / 242** (Associated Data definition).
  * Then open [`outputs/01_pqxdh_rev1_reencaps_output.txt`](file:///D:/IITM/Applied_Crypto/Project/outputs/01_pqxdh_rev1_reencaps_output.txt) and scroll down to the attack trace.
* **Verbatim Spoken Narration:**
  > "Thank you, Akhilesh. I will now demonstrate Activity 3: our bounded formal reproduction of the Signal PQXDH protocol.
  > 
  > In the terminal on the right, Test 1 has finished in 30.67 seconds with the result: `RESULT is false`.
  > 
  > Let's look at the source code on the left in `01_pqxdh_rev1_reencaps_vulnerable.pv`. At line 127, we specify the injective agreement query: if Bob finishes a session with Alice on parameters `opk, spk, pqpk`, Alice must have initiated that exact session with Bob on the identical prekeys.
  > 
  > Notice lines 205 and 242: in Signal Revision 1, the Associated Data for the symmetric initial message is defined simply as:
  > `let ad = concatIK(IKA_p, IKB_p)`
  > Bob's KEM public key `pqpk` is completely omitted from the Associated Data!
  > 
  > Now look at `01_pqxdh_rev1_reencaps_output.txt`. ProVerif reconstructs an active Dolev-Yao attack trace:
  > 1. Alice initiates a session targeting a compromised key `pqpk_2`.
  > 2. The active attacker intercepts Alice's ciphertext, decapsulates the shared secret `SS`, and uses our `reencaps()` equation to generate a new ciphertext under Bob's honest key `pqpk_1`.
  > 3. Bob decapsulates the ciphertext with `sk_1`, derives the identical `SS`, and decrypts the AEAD payload successfully because `ad` only checks identity keys!
  > 4. Bob believes he has established an uncompromised session under `pqpk_1`, but the attacker knows the session key! Injective agreement is falsified."

#### Step 2.2: Activity 3 Corrected — Revision 2 Associated Data Hardening (3:45 – 5:00)
* **Visual Action:**
  * Point to the PowerShell terminal where Test 2 finishes:
    `Result in 28.94s: RESULT event(RespondDone(b,a,useOPK_2,opk,spk,pqpk,ts))@i_1 ==> ... is true.`
  * Open [`models/02_pqxdh_rev2_hardened.pv`](file:///D:/IITM/Applied_Crypto/Project/models/02_pqxdh_rev2_hardened.pv) on the left side.
  * Highlight **Line 196** (Alice) and **Line 233** (Bob):  
    `let ad = concatIKKEM(IKA_p, IKB_p, PQPKB_p)`
  * Open [`outputs/02_pqxdh_rev2_hardened_output.txt`](file:///D:/IITM/Applied_Crypto/Project/outputs/02_pqxdh_rev2_hardened_output.txt) showing the final proof line.
* **Verbatim Spoken Narration:**
  > "Now observe Test 2 in the terminal. Running `02_pqxdh_rev2_hardened.pv`, ProVerif evaluates 6 internal verification stages and proves:
  > `RESULT event(RespondDone(...)) ==> event(InitDone(...)) is true` in 28.94 seconds!
  > 
  > Look at the code fix on the left at line 196 and line 233: Signal Revision 2 explicitly binds Bob's KEM public key into the Associated Data:
  > `let ad = concatIKKEM(IKA_p, IKB_p, PQPKB_p)`
  > 
  > When the attacker attempts to transplant the ciphertext to honest key `pqpk_1`, Bob reconstructs the Associated Data using `pqpk_1`. But Alice encrypted the payload using `pqpk_2`. Because AEAD tags cover the Associated Data, Bob's tag verification fails, and he aborts the session immediately.
  > 
  > ProVerif proves mathematically that injective agreement and session independence are fully restored.
  > 
  > I now hand over to D R Santhosh to present our Activity 4 explorations and final synthesis."

---

### PART 3: Activity 4 Explorations & Activities 5 & 6 Synthesis (5:00 – 7:35)
**Speaker:** D R Santhosh (`CS26E004`)  
**Target Duration:** 2 minutes 35 seconds  

#### Step 3.1: Activity 4 Exploration 1 — Key-Type Confusion (5:00 – 5:50)
* **Visual Action:**
  * Point to the PowerShell terminal where Test 3 finishes:
    `Result in 22.34s: RESULT event(InitDone(...)) && attacker(weakECasKEM) ... cannot be proved.`
  * Open [`models/03_activity4_confuse_kem_ec.pv`](file:///D:/IITM/Applied_Crypto/Project/models/03_activity4_confuse_kem_ec.pv) on the left side.
  * Highlight **Lines 48–52**:
    ```proverif
    fun ECasKEM(point):kempub [typeConverter].
    equation forall x:scalar; encodeKEM(ECasKEM(SMUL(x,G))) = encodeEC(SMUL(x,G)).
    reduc forall x:scalar,k:bitstring; weakECasKEM(penc(ECasKEM(SMUL(x,G)),k)) = k.
    ```
  * Open [`outputs/03_activity4_confuse_kem_ec_output.txt`](file:///D:/IITM/Applied_Crypto/Project/outputs/03_activity4_confuse_kem_ec_output.txt).
* **Verbatim Spoken Narration:**
  > "Thank you, Mysha. For Activity 4, we explored two novel cryptographic engineering questions.
  > 
  > First, in Exploration 1, we asked: what happens if an implementation omits prefix domain separation between classical EC keys and lattice KEM keys?
  > 
  > On the left in `03_activity4_confuse_kem_ec.pv` at lines 48 to 52, we modeled this encoding clash: `encodeKEM(ECasKEM(x)) = encodeEC(x)`. If keys are untyped byte strings, an attacker can substitute Bob's classical Signed Prekey into the KEM prekey slot.
  > 
  > In the terminal, ProVerif confirms in 22.34 seconds that the security query `cannot be proved`. The attacker tricks the initiator into encapsulating against an EC point, producing a predictable shared secret `weakECasKEM`. The attacker recovers this secret and silently strips away post-quantum protection, degrading PQXDH into classical X3DH."

#### Step 3.2: Activity 4 Exploration 2 — Direct KDF Transcript Binding Proposal P2 (5:50 – 6:40)
* **Visual Action:**
  * Point to the PowerShell terminal where Test 4 finishes:
    `Result in 27.10s: RESULT event(RespondDone(...)) ==> event(InitDone(...)) is true.`
  * Show the completed **Formal Verification Suite Summary Table** in PowerShell: all 4 suites marked with expected results.
  * Open [`models/04_activity4_pqxdh_kdf_bound.pv`](file:///D:/IITM/Applied_Crypto/Project/models/04_activity4_pqxdh_kdf_bound.pv) on the left side.
  * Highlight **Lines 63–64** and **Lines 202–207**:
    `kdf(concat4_kdf(DH1, DH2, DH3, SS, PQPKB_p))`
    `let ad = concatIK(IKA_p, IKB_p)`
* **Verbatim Spoken Narration:**
  > "Second, in Exploration 2, we addressed an architectural limitation of Signal Revision 2. Patching an asymmetric key-binding flaw at the symmetric AEAD layer violates clean protocol modularity.
  > 
  > In `04_activity4_pqxdh_kdf_bound.pv`, we modeled **Revision 3 Proposal P2 (Direct KDF Transcript Binding)**:
  > Here, the Associated Data remains purely classical (`ad = concatIK`), but Bob's KEM public key is fed directly into the root HKDF extraction:
  > `SK = HKDF(KMAC256(DH1 || DH2 || DH3 || DH4 || SS || PQPK_B))`
  > 
  > Look at the terminal: ProVerif proves `RESULT is true` in 27.10 seconds!
  > Even with the re-encapsulation rewrite rule active, Alice and Bob derive mathematically different session keys if `PQPK` is modified. Proposal P2 secures the handshake at the key-derivation boundary, completely independent of the AEAD layer.
  > 
  > Notice the summary table on the right: all four suites have completed with exact theoretical correspondence!"

#### Step 3.3: Activities 5 & 6 — Security Matrix, Engineering Lessons & Conclusion (6:40 – 7:35)
* **Visual Action:**
  * Open [`report/security_evolution_matrix.md`](file:///D:/IITM/Applied_Crypto/Project/report/security_evolution_matrix.md) on the left side, then open [`report/engineering_lessons.md`](file:///D:/IITM/Applied_Crypto/Project/report/engineering_lessons.md).
  * Alternatively, switch to **Slide 4** in [`presentation/CS6530_Project_CS26E001_CS26E004_CS26E008_Presentation.pptx`](file:///D:/IITM/Applied_Crypto/Project/presentation/CS6530_Project_CS26E001_CS26E004_CS26E008_Presentation.pptx).
  * Hover over the 5 numbered lessons.
* **Verbatim Spoken Narration:**
  > "Finally, for Activities 5 and 6, we synthesized our findings across Literature R1 through R4 into our Security Evolution Matrix:
  > * Signal PQXDH retrofits existing ratchets via hybrid KEMs;
  > * Duverger et al. at CCS '25 prove subversion resilience against backdoored randomness;
  > * Abiega-L'Eglisse designs clean-slate post-quantum instant messaging; and
  > * Olushola & Meenakshi analyze standalone authenticated session protocols.
  > 
  > We conclude with our **Five Core Engineering Lessons**:
  > 1. The Primitive Substitution Fallacy: KEMs provide secrecy, not authentication; protocols must bind identities to encapsulated keys.
  > 2. Mandatory Transcript Binding: Public keys, ciphertexts, and nonces must be cryptographically hashed into key derivation contexts.
  > 3. Bandwidth and MTU Constraints: Lattice keys and signatures expand packet sizes, forcing careful transport-layer design.
  > 4. Formal Verification as a Specification Gate: Automated symbolic modeling in ProVerif catches protocol composition bugs that functional unit tests completely miss.
  > 5. Specification Independence: Protocols must never rely on accidental implementation side-effects—such as Kyber's Fujisaki-Okamoto transform—to enforce security invariants.
  > 
  > All models, outputs, scripts, and documentation are available in our submission package and synchronized on GitHub. Thank you very much."

---

## Recording Execution Cheat-Sheet

| Timestamp | Speaker | Primary Action | Command / File to Open |
| :--- | :--- | :--- | :--- |
| **0:00 – 0:50** | Akhilesh K.R | Expand folders in File Explorer | Expand `bin/`, `models/`, `outputs/`, `scripts/`, `report/`, `presentation/` |
| **0:50 – 1:50** | Akhilesh K.R | Explain System & Threat Model | Open [`report/CS6530_Project_CS26E001_CS26E004_CS26E008_Report.pdf`](file:///D:/IITM/Applied_Crypto/Project/report/CS6530_Project_CS26E001_CS26E004_CS26E008_Report.pdf) (Pages 3–5) |
| **1:50 – 2:30** | Akhilesh K.R | Run test suite in PowerShell | Type `cd scripts` then `.\run_all.ps1` |
| **2:30 – 3:45** | Mysha Ali | Explain Activity 3 Baseline (Vulnerable) | Open [`models/01_pqxdh_rev1_reencaps_vulnerable.pv`](file:///D:/IITM/Applied_Crypto/Project/models/01_pqxdh_rev1_reencaps_vulnerable.pv) (L127, L205) & [`outputs/01_pqxdh_rev1_reencaps_output.txt`](file:///D:/IITM/Applied_Crypto/Project/outputs/01_pqxdh_rev1_reencaps_output.txt) |
| **3:45 – 5:00** | Mysha Ali | Explain Activity 3 Corrected (Hardened) | Open [`models/02_pqxdh_rev2_hardened.pv`](file:///D:/IITM/Applied_Crypto/Project/models/02_pqxdh_rev2_hardened.pv) (L196, L233) & [`outputs/02_pqxdh_rev2_hardened_output.txt`](file:///D:/IITM/Applied_Crypto/Project/outputs/02_pqxdh_rev2_hardened_output.txt) |
| **5:00 – 5:50** | D R Santhosh | Explain Activity 4 Exploration 1 (Key Confusion) | Open [`models/03_activity4_confuse_kem_ec.pv`](file:///D:/IITM/Applied_Crypto/Project/models/03_activity4_confuse_kem_ec.pv) (L48–52) & [`outputs/03_activity4_confuse_kem_ec_output.txt`](file:///D:/IITM/Applied_Crypto/Project/outputs/03_activity4_confuse_kem_ec_output.txt) |
| **5:50 – 6:40** | D R Santhosh | Explain Activity 4 Exploration 2 (Proposal P2) | Open [`models/04_activity4_pqxdh_kdf_bound.pv`](file:///D:/IITM/Applied_Crypto/Project/models/04_activity4_pqxdh_kdf_bound.pv) (L63, L202) & show PowerShell Summary Table |
| **6:40 – 7:35** | D R Santhosh | Activities 5 & 6 Matrix & 5 Lessons | Open [`report/security_evolution_matrix.md`](file:///D:/IITM/Applied_Crypto/Project/report/security_evolution_matrix.md) & [`report/engineering_lessons.md`](file:///D:/IITM/Applied_Crypto/Project/report/engineering_lessons.md) |
