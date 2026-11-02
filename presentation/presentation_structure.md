# CS6530 Applied Cryptography: Team Presentation Guide
## Four Content Slides (+ Title Slide) Mapping to All 6 Activities
**Presentation Duration:** 10–12 minutes (Strict 4 content slides + 1 title slide)  
**Speakers (Equal 3-Person Split):** Akhilesh K.R (CS26E001), D R Santhosh (CS26E004), Mysha Ali (CS26E008)

---

### Slide 0: Minimal Title Slide (Does Not Count Against the 4-Slide Limit)
* **Title:** Post-Quantum Secure Messaging: Formal Analysis, Failure Reproduction, and Hardened Protocol Design in Signal PQXDH
* **Course:** CS6530 Applied Cryptography | Jul–Nov 2026 | IIT Madras
* **Team Members:**
  * Akhilesh K.R (CS26E001)
  * D R Santhosh (CS26E004)
  * Mysha Ali (CS26E008)

---

### Slide 1: Problem Understanding, Threat Model & Failure Mechanisms (Activities 1 & 2)
* **Speaker:** Akhilesh K.R (CS26E001) | Duration: 2.5 minutes
* **Key Content:**
  * **The HNDL Threat:** Harvest-Now-Decrypt-Later adversaries record classical Diffie–Hellman traffic today to decrypt with Shor's algorithm on a future CRQC.
  * **Signal PQXDH Hybrid Architecture:** Augments classical 4-way Curve25519 Diffie–Hellman (X3DH) with ML-KEM-1024 (Kyber).
  * **The Primitive Substitution Fallacy:** Why simply dropping a post-quantum KEM into an existing protocol fails. Security depends on protocol composition, identity/key binding, and compromise assumptions.
  * **Failure Mode 1 (KEM Re-encapsulation):** IND-CCA2 security protects ciphertexts under a fixed public key, but does not guarantee public-key binding. An adversary with $SK_2$ could craft $CT'$ for $PK_1$ such that $Decaps(SK_1, CT') = SS$, violating forward secrecy and session independence.
  * **Failure Mode 2 (Key-Type Confusion):** When public keys are serialized without rigid domain-separated type prefixes (`encodeEC = encodeKEM`), an attacker can substitute an EC key for a KEM key, causing encapsulation to return a predictable secret (`weakECasKEM`).
  * **Specification vs. Implementation:** Signal remained safe because Kyber's FO transform hashes the public key into the shared secret ($SS = \text{KDF}(m \parallel H(pk))$). Accidental implementation protections must become explicit specification rules.

---

### Slide 2: Activity 3 — Bounded Formal Reproduction in ProVerif (Baseline vs. Hardened)
* **Speaker:** Mysha Ali (CS26E008) | Duration: 2.5 minutes
* **Key Content:**
  * **Formal Modeling Methodology:** Modeled in ProVerif 2.05 under an active Dolev-Yao attacker with prekey registration processes.
  * **Model 01 (Baseline Reproduction - Revision 1):** 
    * Associated Data omits $PQPK$: $\text{AD} = IK_A \parallel IK_B$.
    * **ProVerif Output:** `RESULT inj-event(RespondDone(...)) ==> inj-event(InitDone(...)) is false`.
    * **Attack Trace Extraction:** ProVerif reconstructs the re-encapsulation attack in 23.77s. Alice negotiates with compromised $PQPK_2$; attacker decapsulates $SS$ and re-encapsulates under Bob's honest $PQPK_1$; Bob accepts the session under $PQPK_1$ with an attacker-known key.
  * **Model 02 (Corrected Model - Revision 2):**
    * Associated Data explicitly binds the KEM public key: $\text{AD} = IK_A \parallel IK_B \parallel PQPK_B$.
    * **ProVerif Output:** `RESULT inj-event(RespondDone(...)) ==> inj-event(InitDone(...)) is true`.
    * ProVerif mathematically proves that if the attacker re-encapsulates under $PQPK_1$, Bob's AEAD decryption fails due to AD mismatch, fully restoring injective agreement.

---

### Slide 3: Activity 4 — Novel Cryptographic Explorations in ProVerif
* **Speakers:** D R Santhosh (CS26E004) [Exp 1] & Akhilesh K.R (CS26E001) [Exp 2] | Duration: 2.5 minutes
* **Key Content:**
  * **Exploration 1: Algorithm/Key-Type Confusion (`03_activity4_confuse_kem_ec.pv`) — D R Santhosh:**
    * Modeled what happens when public key type domain separation is omitted (`encodeEC = encodeKEM`).
    * ProVerif query `event(InitDone(...)) && attacker(weakECasKEM)` reports: `RESULT cannot be proved (attack trace found in 15.90s)`.
    * Proves that type tags are cryptographically essential to prevent silent downgrades to classical X3DH.
  * **Exploration 2: Direct KDF Transcript Binding Proposal P2 (`04_activity4_pqxdh_kdf_bound.pv`) — Akhilesh K.R:**
    * Identified that fixing asymmetric binding at the symmetric AEAD layer violates protocol layer encapsulation.
    * Modeled Proposal P2: AEAD Associated Data remains purely classical ($\text{AD} = IK_A \parallel IK_B$), but Bob's KEM public key is fed directly into the root HKDF extraction: $SK = \text{HKDF}(\text{KMAC256}(DH_1..DH_4 \parallel SS \parallel PQPK_B))$.
    * **ProVerif Output:** `RESULT inj-event(RespondDone(...)) ==> inj-event(InitDone(...)) is true` (proved in 20.21s).
    * Demonstrates that direct KDF transcript binding eliminates re-encapsulation at the key-derivation boundary.

---

### Slide 4: Activities 5 & 6 — Security Evolution Matrix & Engineering Lessons
* **Speaker:** Collaborative / Shared (Akhilesh / Santhosh / Mysha) | Duration: 2.5 minutes
* **Key Content:**
  * **Security Evolution Matrix Across Literature [R1]–[R4]:**
    * Key Agreement: Signal [R1] hybrid KEM; [R2] subversion-resilient KEM; [R3] clean-slate PQ ratchets; [R4] authenticated standalone sessions.
    * Transcript Binding: Evolution from unbound KEMs to Associated Data binding ([R1]), Direct KDF binding ([R1] Proposal P2), and cumulative signed transcripts ([R4]).
    * Primitive Invariants: Accidental FO-transform protections must not substitute for explicit specification rules.
  * **Five Core Engineering Lessons:**
    1. *Primitive Substitution Fallacy:* KEMs provide confidentiality, not authentication; dropping a KEM into a DH handshake without identity binding creates active vulnerabilities.
    2. *Mandatory Transcript Binding:* Handshake nonces, public keys, and ciphertexts must be cryptographically hashed into key derivation contexts.
    3. *Bandwidth & MTU Constraints:* Large lattice keys (~1.5 KB) and signatures (~2.4 KB) cause packet fragmentation; protocols must be co-designed with network limits.
    4. *Formal Verification Gate:* Symbolic automated modeling in ProVerif catches compositional flaws that functional unit tests completely miss.
    5. *Specification Independence:* Protocol specifications must explicitly mandate all required mathematical invariants and not rely on underlying library artifacts.
