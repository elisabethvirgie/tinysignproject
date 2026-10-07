#!/usr/bin/env bash
set -euo pipefail
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
build="$root/sim/iverilog/build"
mkdir -p "$build"
iverilog -g2012 -Wall -s tb_mod_arith -o "$build/tb_mod_arith.vvp" \
  "$root/rtl/arithmetic/mod_add.sv" "$root/rtl/arithmetic/mod_sub.sv" \
  "$root/rtl/arithmetic/mod_mul.sv" "$root/rtl/arithmetic/mod_inv.sv" \
  "$root/tb/tb_mod_arith.sv"
vvp "$build/tb_mod_arith.vvp"
iverilog -g2012 -Wall -s tb_point_ops -o "$build/tb_point_ops.vvp" \
  "$root/rtl/arithmetic/mod_add.sv" "$root/rtl/arithmetic/mod_sub.sv" \
  "$root/rtl/arithmetic/mod_mul.sv" "$root/rtl/ec/point_ops.sv" \
  "$root/rtl/ec/point_add.sv" "$root/rtl/ec/point_double.sv" "$root/tb/tb_point_ops.sv"
vvp "$build/tb_point_ops.vvp"

iverilog -g2012 -Wall -s tb_scalar_mult -o "$build/tb_scalar_mult.vvp" \
  "$root/rtl/arithmetic/mod_add.sv" "$root/rtl/arithmetic/mod_sub.sv" \
  "$root/rtl/arithmetic/mod_mul.sv" "$root/rtl/ec/point_ops.sv" \
  "$root/rtl/ecdsa/scalar_mult.sv" "$root/tb/tb_scalar_mult.sv"
vvp "$build/tb_scalar_mult.vvp"

iverilog -g2012 -Wall -s tb_hmac -o "$build/tb_hmac.vvp" \
  "$root/rtl/sha256/sha256_compress.sv" "$root/rtl/sha256/sha256_hash.sv" \
  "$root/rtl/nonce/hmac_sha256.sv" "$root/tb/tb_hmac.sv"
vvp "$build/tb_hmac.vvp"

iverilog -g2012 -Wall -s tb_rfc6979 -o "$build/tb_rfc6979.vvp" \
  "$root/rtl/sha256/sha256_compress.sv" "$root/rtl/sha256/sha256_hash.sv" \
  "$root/rtl/nonce/hmac_sha256.sv" "$root/rtl/nonce/rfc6979.sv" "$root/tb/tb_rfc6979.sv"
vvp "$build/tb_rfc6979.vvp"

iverilog -g2012 -Wall -s tb_ecdsa_signer -o "$build/tb_ecdsa_signer.vvp" \
  "$root/rtl/arithmetic/mod_add.sv" "$root/rtl/arithmetic/mod_sub.sv" "$root/rtl/arithmetic/mod_mul.sv" \
  "$root/rtl/arithmetic/mod_inv.sv" "$root/rtl/ec/point_ops.sv" \
  "$root/rtl/ecdsa/scalar_mult.sv" "$root/rtl/sha256/sha256_compress.sv" \
  "$root/rtl/sha256/sha256_hash.sv" "$root/rtl/nonce/hmac_sha256.sv" \
  "$root/rtl/nonce/rfc6979.sv" "$root/rtl/ecdsa/ecdsa_signer.sv" \
  "$root/tb/tb_ecdsa_signer.sv"
vvp "$build/tb_ecdsa_signer.vvp"

iverilog -g2012 -Wall -s tb_key_manager -o "$build/tb_key_manager.vvp" \
  "$root/rtl/arithmetic/mod_add.sv" "$root/rtl/arithmetic/mod_sub.sv" \
  "$root/rtl/arithmetic/mod_mul.sv" "$root/rtl/arithmetic/mod_inv.sv" \
  "$root/rtl/ec/point_ops.sv" "$root/rtl/ecdsa/scalar_mult.sv" \
  "$root/rtl/security/key_manager.sv" "$root/tb/tb_key_manager.sv"
vvp "$build/tb_key_manager.vvp"

iverilog -g2012 -Wall -s tb_tinysign_core -o "$build/tb_tinysign_core.vvp" \
  "$root/rtl/arithmetic/mod_add.sv" "$root/rtl/arithmetic/mod_sub.sv" \
  "$root/rtl/arithmetic/mod_mul.sv" "$root/rtl/arithmetic/mod_inv.sv" \
  "$root/rtl/ec/point_ops.sv" "$root/rtl/ecdsa/scalar_mult.sv" \
  "$root/rtl/sha256/sha256_compress.sv" "$root/rtl/sha256/sha256_hash.sv" \
  "$root/rtl/nonce/hmac_sha256.sv" "$root/rtl/nonce/rfc6979.sv" \
  "$root/rtl/ecdsa/ecdsa_signer.sv" "$root/rtl/security/key_manager.sv" \
  "$root/rtl/security/tinysign_core.sv" "$root/tb/tb_tinysign_core.sv"
vvp "$build/tb_tinysign_core.vvp"

iverilog -g2012 -Wall -s tb_tinysign_de10nano -o "$build/tb_tinysign_de10nano.vvp" \
  "$root/rtl/arithmetic/mod_add.sv" "$root/rtl/arithmetic/mod_sub.sv" \
  "$root/rtl/arithmetic/mod_mul.sv" "$root/rtl/arithmetic/mod_inv.sv" \
  "$root/rtl/ec/point_ops.sv" "$root/rtl/ecdsa/scalar_mult.sv" \
  "$root/rtl/sha256/sha256_compress.sv" "$root/rtl/sha256/sha256_hash.sv" \
  "$root/rtl/nonce/hmac_sha256.sv" "$root/rtl/nonce/rfc6979.sv" \
  "$root/rtl/ecdsa/ecdsa_signer.sv" "$root/rtl/security/key_manager.sv" \
  "$root/rtl/security/tinysign_core.sv" "$root/rtl/platform/tinysign_de10nano.sv" \
  "$root/tb/tb_tinysign_de10nano.sv"
vvp "$build/tb_tinysign_de10nano.vvp"
