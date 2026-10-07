# TinySign: Hardware Security Element untuk Secure Digital Signing Berbasis ECDSA P-256 pada Identitas dan Dokumen Digital

TinySign is a hardware security element prototype for protected-key ECDSA P-256 signing. It targets the Peruri Chip Hackathon 2026, Topik 1: Secure Identity & Security Element, with DE10-Nano / Cyclone V as the planned FPGA target.


## Current status

- [x] Architecture, module hierarchy, register map, and implementation phases
- [x] Python P-256 reference model and RFC 6979 known-answer test
- [x] RTL modular arithmetic
- [x] RTL Jacobian point addition and doubling
- [x] RTL fixed-round scalar multiplication
- [x] RTL SHA-256, HMAC-SHA-256, and RFC 6979 nonce generation
- [x] RTL ECDSA P-256 signing controller
- [x] Protected key manager and key lifecycle
- [x] Register/security-element integration
- [ ] DE10-Nano Avalon-MM integration and Quartus project

This is a prototype architecture. It does not claim resistance to physical tampering, power/EM side channels, or fault injection. Key state is volatile and cleared by reset/zeroization.

## Phase 1 reference tests

From this directory, run:

```sh
python -m unittest discover -s tests -v
```

The Python model uses only the standard library and includes P-256 point arithmetic, RFC 6979 HMAC-SHA-256 nonce derivation, digest signing, and signature verification. The registered RFC 6979 P-256/SHA-256 vector is used as a known-answer test.

## Architecture and interface

See [`docs/architecture.md`](docs/architecture.md), [`docs/interface.md`](docs/interface.md), and [`docs/implementation_plan.md`](docs/implementation_plan.md). P-256 parameters are sourced from NIST SP 800-186; the deterministic signing vector is from RFC 6979 Appendix A.2.5.
