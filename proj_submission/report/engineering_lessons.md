# Activity 6: Five Core Engineering Lessons for Post-Quantum Protocol Migration
**CS6530 Applied Cryptography | Course Project Theme 2: Post-Quantum Secure Messaging**  
**Authors:** Akhilesh K.R (CS26E001), D R Santhosh (CS26E004), Mysha Ali (CS26E008)

---

### Engineering Lesson 1: The Primitive Substitution Fallacy
* **Observation / Finding:** Swapping classical Diffie–Hellman with a Post-Quantum KEM (e.g., Kyber-1024) without adapting the authentication state machine creates active Man-in-the-Middle (MitM) and key-substitution vulnerabilities.
* **Why It Matters:** Developers frequently assume that "post-quantum cryptography" is a modular drop-in replacement for classical public keys. However, classical Diffie–Hellman provides non-interactive commutative symmetry ($g^{ab} = g^{ba}$), where both parties implicitly contribute symmetric entropy. In contrast, KEMs are asymmetric (encapsulation vs. decapsulation). Dropping a KEM into a protocol without binding public keys to authenticated identities enables an active adversary to inject or substitute keys.
* **Recommended Practice:** Post-quantum migration must be engineered as a holistic protocol re-design. Public-key encapsulation mechanisms (KEMs) provide confidentiality, not entity authentication; they must be coupled with authentic prekey signatures, authenticated data bindings, or digital signatures (ML-DSA).

---

### Engineering Lesson 2: Cryptographic Transcript and Public-Key Binding
* **Observation / Finding:** Generic IND-CCA2 security of a KEM guarantees ciphertext confidentiality under a single fixed public key, but does not guarantee that a ciphertext cannot produce the same shared secret under a different public key (the KEM Re-encapsulation finding from PQXDH).
* **Why It Matters:** If a protocol fails to cryptographically bind the KEM public key, ciphertext, nonces, and session identities into the Key Derivation Function (HKDF), an attacker can splice or replay keys across sessions. In Signal PQXDH Revision 1, an attacker could transplant a shared secret from a compromised prekey to an honest prekey because the Associated Data only contained classical identity keys.
* **Recommended Practice:** All handshake messages, public keys, and ciphertexts must be hashed into a cumulative transcript hash:
  $$T = \text{Hash}(pk_{\text{client}} \parallel pk_{\text{server}} \parallel ct \parallel \text{nonces})$$
  This transcript must be included in the HKDF context or AEAD Associated Data. As proven in our Activity 4 Proposal P2 model (`04_activity4_pqxdh_kdf_bound.pv`), binding $PQPK$ directly into the root HKDF extraction mathematically eliminates re-encapsulation at the key-derivation boundary.

---

### Engineering Lesson 3: Bandwidth, MTU, and Asynchronous Store-and-Forward Constraints
* **Observation / Finding:** Lattice-based post-quantum cryptography incurs substantial public-key and ciphertext size expansions compared to elliptic curve cryptography.
* **Why It Matters:** Curve25519 public keys and signatures require only 32 and 64 bytes. In contrast, ML-KEM-1024 public keys require 1,568 bytes, and ML-DSA-44 signatures require 2,420 bytes. In asynchronous messaging (Signal), prekey bundles expand tenfold, increasing server storage and mobile client radio wakeups. In interactive UDP protocols, packets exceeding the standard 1,500-byte Ethernet MTU trigger multi-packet IP fragmentation, causing high packet drop rates on wireless networks.
* **Recommended Practice:** Protocol architects must budget for network-layer MTU constraints and consider hybrid designs (like PQXDH) or KEMTLS (using KEMs for mutual authentication instead of large lattice signatures) to keep initial handshakes within single MTU datagram limits.

---

### Engineering Lesson 4: Formal Verification as a Non-Negotiable Specification Gate
* **Observation / Finding:** Classical software unit tests pass completely even when a protocol is fatally insecure against active attackers.
* **Why It Matters:** Unit tests only verify functional correctness (e.g., that $Decaps(Encaps(pk)) == ss$). They cannot reason about an active Dolev-Yao attacker who manipulates message scheduling, interleaves concurrent sessions, substitutes public keys, or exploits lack of domain separation.
* **Recommended Practice:** Automated formal verification tools (ProVerif for symbolic verification, CryptoVerif for computational proofs) must be integrated into the protocol specification phase before code deployment. A protocol model must formally prove injective agreement and secrecy under explicit compromise models before standardization.

---

### Engineering Lesson 5: Specification Invariants Must Not Rely on Implementation Accidents
* **Observation / Finding:** In Signal’s initial PQXDH Revision 1 specification, the theoretical re-encapsulation attack was mitigated only because the Kyber implementation’s Fujisaki–Okamoto (FO) transform happened to hash the public key into the shared secret ($SS = \text{KDF}(m \parallel H(pk))$).
* **Why It Matters:** Had the implementers switched to a different IND-CCA2 KEM lacking this internal hash (e.g., FrodoKEM or Classic McEliece without key hashing), the protocol would have silently become vulnerable in production.
* **Recommended Practice:** Protocol specifications must explicitly mandate all required algebraic and binding properties in normative language. Cryptographic protocols must never rely on implicit implementation-specific features of a particular primitive library.
