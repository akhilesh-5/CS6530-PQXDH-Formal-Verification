# Demonstration Video Script & Recording Walkthrough (Artefact 3)
**Course:** CS6530 Applied Cryptography | Course Project Theme 2: Post-Quantum Secure Messaging  
**Target Duration:** 6 minutes 30 seconds (within 5–8 min guideline)  
**Deliverable Filename:** `CS6530_Project_CS26E001_CS26E004_CS26E008.mp4`  
**Presenters:** Akhilesh K.R (CS26E001), D R Santhosh (CS26E004), Mysha Ali (CS26E008)

---

### Segment 1: Introduction, Problem Statement & Threat Model (0:00 – 1:30)
* **Speaker:** Akhilesh K.R (CS26E001)
* **Screen Display:** 
  * Title slide showing Course, Project Title, Team Roll Numbers.
  * Diagram of Signal PQXDH asynchronous key agreement workflow (X25519 + Kyber-1024).
* **Spoken Script:**
  > "Hello everyone. This is our project demonstration for CS6530 Applied Cryptography, Theme 2: Post-Quantum Secure Messaging. Our team members are Akhilesh K.R, D R Santhosh, and Mysha Ali.
  > 
  > Classical end-to-end messaging protocols like Signal X3DH rely on Diffie–Hellman over Curve25519. Today, these systems face the urgent Harvest-Now-Decrypt-Later (HNDL) threat: adversaries can intercept and store encrypted messages now, waiting for a Cryptographically Relevant Quantum Computer to run Shor's algorithm and recover all session keys.
  > 
  > To counter this, Signal introduced PQXDH, combining four classical Diffie–Hellman operations with ML-KEM-1024 (Kyber). However, as shown by Bhargavan et al. at USENIX Security 2024, post-quantum migration is not a simple drop-in replacement. Generic IND-CCA2 security of a KEM guarantees confidentiality under a single key, but does not guarantee public-key binding. This opened up the KEM Re-encapsulation vulnerability in Signal Revision 1, alongside key-type confusion risks.
  > 
  > In this video, we demonstrate our automated formal verification suite in ProVerif 2.05, reproducing the vulnerability, proving the official Signal fix, and validating our novel engineering explorations."

---

### Segment 2: Activity 3 — Bounded Formal Reproduction in ProVerif (1:30 – 3:30)
* **Speaker:** Mysha Ali (CS26E008)
* **Screen Display:**
  * Terminal showing the `activity3_4/scripts/` directory.
  * Executing `.\run_all.ps1`.
  * Inspecting `01_pqxdh_rev1_reencaps_vulnerable.pv` and `02_pqxdh_rev2_hardened.pv`.
* **Spoken Script:**
  > "I will now demonstrate our Activity 3 bounded formal reproduction. 
  > 
  > Here in PowerShell, we execute our unified automated verification suite via `run_all.ps1`.
  > 
  > Model 1 is `01_pqxdh_rev1_reencaps_vulnerable.pv`. In Signal Revision 1, the initiator sends an AEAD ciphertext where the Associated Data only includes the identity keys: AD equals IK_A concatenated with IK_B. Notice on screen: ProVerif runs in 23 seconds and outputs:
  > `RESULT event(RespondDone(b, a, ...)) ==> event(InitDone(a, b, ...)) is false.`
  > 
  > ProVerif reconstructs an active Dolev-Yao attack trace: Alice initiates a session with a compromised key `pqpk_2`. The attacker intercepts the message, decapsulates the shared secret `ss`, and re-encapsulates the identical `ss` under Bob's uncompromised honest key `pqpk_1`. Bob accepts the session under `pqpk_1` while Alice completed under `pqpk_2`. Bob believes he has established an uncompromised session, but the session key is known to the attacker, completely violating injective agreement.
  > 
  > Now look at Model 2: `02_pqxdh_rev2_hardened.pv`. Here, Signal Revision 2 appends Bob's KEM public key directly into the Associated Data: AD equals IK_A, IK_B, and PQPK_B. 
  > Watch the ProVerif output:
  > `RESULT event(RespondDone(...)) ==> event(InitDone(...)) is true.`
  > ProVerif mathematically proves that if the attacker modifies the KEM key, Bob's AEAD decryption fails, completely restoring injective agreement and session independence."

---

### Segment 3: Activity 4 — Novel Cryptographic Explorations in ProVerif (3:30 – 5:15)
* **Speakers:** D R Santhosh (CS26E004) [Exploration 1] & Akhilesh K.R (CS26E001) [Exploration 2]
* **Screen Display:**
  * Terminal showing Model 3 (`03_activity4_confuse_kem_ec.pv`) and Model 4 (`04_activity4_pqxdh_kdf_bound.pv`).
  * Code highlighting of disjoint key typing and direct KDF transcript binding.
* **Spoken Script:**
  > **[D R Santhosh]:** "For Activity 4, we conducted two novel cryptographic engineering explorations.
  > 
  > First, in Model 3, we examined Key-Type Confusion. In multi-primitive protocols, if public keys are represented as raw byte arrays without strict type prefixes such that `encodeEC` equals `encodeKEM`, an attacker can substitute an EC Signed Prekey for a KEM prekey. In our ProVerif model, we formalized this coercion. ProVerif reports:
  > `RESULT event(InitDone(...)) && attacker(weakECasKEM) cannot be proved.`
  > ProVerif demonstrates that an attacker can trick the initiator into treating an EC point as a lattice key, collapsing the post-quantum secret into a predictable value and silently downgrading the protocol to classical X3DH."
  > 
  > **[Akhilesh K.R]:** "Second, in Model 4, I explored Direct KDF Transcript Binding, corresponding to Proposal P2. Signal Revision 2 solved re-encapsulation at the AEAD layer. But what if the symmetric layer changes? In Proposal P2, we keep the AEAD purely classical and bind Bob's KEM public key directly into the root HKDF computation. 
  > As ProVerif demonstrates on screen:
  > `RESULT event(RespondDone(...)) ==> event(InitDone(...)) is true.`
  > This proves that direct KDF transcript binding mathematically eliminates re-encapsulation at the key-derivation boundary, providing clean layer separation and cryptographic independence."

---

### Segment 4: Activities 5 & 6 — Security Evolution Matrix & Engineering Lessons (5:15 – 6:30)
* **Speaker:** Akhilesh K.R (CS26E001)
* **Screen Display:**
  * Slide showing the Security Evolution Matrix comparing Literature [R1]–[R4].
  * Slide listing the Five Core Engineering Lessons.
* **Spoken Script:**
  > "To synthesize our findings across Literature R1 through R4, we constructed a comprehensive Security Evolution Matrix comparing key agreement architectures, HNDL mitigation, transcript binding, and formal verification assumptions.
  > 
  > We conclude with our five core engineering lessons for post-quantum protocol migration:
  > 1. The Primitive Substitution Fallacy: KEMs provide confidentiality, not authentication; dropping a KEM into a DH handshake without identity binding creates active vulnerabilities.
  > 2. Mandatory Transcript Binding: Public keys, ciphertexts, and nonces must be hashed into key derivation contexts.
  > 3. Bandwidth and MTU Constraints: Large post-quantum keys require careful transport-layer engineering to avoid fragmentation.
  > 4. Formal Verification as a Specification Gate: Automated symbolic verification in ProVerif catches compositional flaws that functional unit tests completely miss.
  > 5. Specification Independence: Protocols must never rely on accidental implementation artifacts—such as Kyber's Fujisaki-Okamoto transform—to enforce specification security invariants.
  > 
  > All models, scripts, and logs are fully automated and verified in our project repository. Thank you."

---

### Recording & Upload Instructions for the Team:
1. **Tool:** Use OBS Studio, Windows Game Bar (`Win + G`), or Zoom to record screen + mic audio.
2. **Setup:** Run PowerShell in `D:\IITM\Applied_Crypto\Project\activity3_4\scripts` with 1080p resolution and clear font size.
3. **Execution:** Run `.\run_all.ps1`. The script executes all 4 models and prints clean headers and summary tables in ~80 seconds total.
4. **Export:** Export as `CS6530_Project_CS26E001_CS26E004_CS26E008.mp4` and upload to Google Drive or YouTube (Unlisted), providing the link in the final submission.
