# Verification record

## Phase 1: Python P-256 reference

Command: `python -m unittest discover -s tests -v`

Result: PASS, 6 tests. Covers P-256 curve/group boundaries, affine and Jacobian point operations, RFC 6979 P-256/SHA-256 nonce and signature vectors, public-key derivation, valid verification, tampered digest, invalid signature ranges, and input validation.

## Phase 2: modular arithmetic RTL

Command: `bash scripts/run_rtl_tests.sh` (Ubuntu/WSL with Icarus Verilog).

Result: PASS. Self-checking tests cover zero/one/max boundaries and eight deterministic random operand pairs for add, subtract, and multiply, under both P-256 moduli `p` and `n`; inverse of two modulo each prime; and rejection of zero inversion input. Multiplication uses a 256-round datapath; inversion uses Fermat exponentiation with a fixed 256-bit schedule.

## Phase 3: P-256 Jacobian point operations

Command: `bash scripts/run_rtl_tests.sh` (Ubuntu/WSL with Icarus Verilog).

Result: PASS. RTL checks projective `2G`, `G+G`, `G+2G`, and `G+(-G)` against the Python Jacobian model and affine golden points. The test covers equal-point doubling and inverse-point infinity handling.

## Phase 4: fixed-round scalar multiplication

Command: `bash scripts/run_rtl_tests.sh` (Ubuntu/WSL with Icarus Verilog).

Result: PASS. The Montgomery ladder performs 256 bit rounds and two fixed 7,000-cycle operation slots per round. Tests check `1G`, `2G`, `nG`, and the RFC 6979 P-256 test key's public key against affine golden points. All four transactions completed in 3,585,024 cycles. Arithmetic, point-operation, and Python regressions passed.

## Phase 5: SHA-256, HMAC-SHA-256, and RFC 6979

Command: `bash scripts/run_rtl_tests.sh` (Ubuntu/WSL with Icarus Verilog), including `python3 -m unittest discover -s tests -v`.

Result: PASS. HMAC matches RFC 4231 Test Case 2 and a 97-byte HMAC input used by RFC 6979. The RFC 6979 controller matches the Appendix A.2.5 P-256/SHA-256 nonce for the published private key and `SHA-256("sample")`; zero private key is rejected. The first regression found V initialized to `FF` bytes instead of RFC 6979's `01` bytes; the RTL initialization was corrected and the complete regression now passes. Icarus emits only sensitivity-list warnings for the SHA-256 message schedule array.

## Phase 6: ECDSA P-256 signer

Command: `bash scripts/run_rtl_tests.sh` (Ubuntu/WSL with Icarus Verilog), including `python3 -m unittest discover -s tests -v`.

Result: PASS. The serialized signer runs RFC 6979, computes `kG`, converts the Jacobian result to affine form, reduces `r`, and computes `s = k^-1(z + rd) mod n`. The output matches the Python model and RFC 6979 Appendix A.2.5 signature (`r=EFD48B2A...EAF3716`, `s=F7CB1C94...43ACDA8`); zero private key is rejected. The full Python and RTL regression passes, including prior phase gates.

## Phase 7: protected key manager

Command: `bash scripts/run_rtl_tests.sh` (Ubuntu/WSL with Icarus Verilog).

Result: PASS. The manager has write-only eight-word staging, checks completeness and `1 <= d < n`, derives the public key internally, locks a valid key against overwrite, and clears key and point state on zeroize/reset. Tests reject incomplete and zero-key provisioning, derive `Q=G` for `d=1`, reject overwrite after lock, and verify zeroization. The private key is exposed only on the manager's internal `signing_key` connection; no host register maps it.

## Phase 8: TinySign core and register interface

Command: `bash scripts/run_rtl_tests.sh` (Ubuntu/WSL with Icarus Verilog), including `python3 -m unittest discover -s tests -v`.

Result: PASS. The self-contained core accepts write-only key and digest words, provisions and locks the key, signs through the ECDSA controller, and exposes status, public key, and signature words. Its bus transaction test matches the Python signature for `d=1` and `SHA-256("sample")`, confirms key-word reads return zero, and interrupts a second signing operation with zeroize. Zeroize waits for key-manager clearing and resets signer internals before reporting command completion. Partial-word writes are rejected. Full Python and RTL regressions pass through Phase 8.

## Phase 9: DE10-Nano Avalon-MM shell

Command: compile and run `tb_tinysign_de10nano` with Icarus Verilog (the same top-level test is included in `scripts/run_rtl_tests.sh`).

Result: RTL shell PASS. The wrapper exposes a non-stalling 32-bit Avalon-MM register interface, with the core rejecting writes while busy except ZEROIZE. Icarus checks status reads, command writes, and byte-enable rejection. A Cyclone V Quartus project skeleton targets the DE10-Nano's 5CSEBA6U23I7 and has a baseline 50 MHz SDC clock. Quartus tools and a DE10-Nano board are unavailable here, so Quartus synthesis, pin/fabric integration, and board behavior remain unverified; Phase 9 is not complete.
