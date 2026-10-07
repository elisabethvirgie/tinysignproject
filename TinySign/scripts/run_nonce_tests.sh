#!/usr/bin/env bash
set -euo pipefail
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
build="$root/sim/iverilog/build"
mkdir -p "$build"
iverilog -g2012 -Wall -s tb_hmac -o "$build/tb_hmac.vvp" \
  "$root/rtl/sha256/sha256_compress.sv" "$root/rtl/sha256/sha256_hash.sv" \
  "$root/rtl/nonce/hmac_sha256.sv" "$root/tb/tb_hmac.sv"
vvp "$build/tb_hmac.vvp"
iverilog -g2012 -Wall -s tb_rfc6979 -o "$build/tb_rfc6979.vvp" \
  "$root/rtl/sha256/sha256_compress.sv" "$root/rtl/sha256/sha256_hash.sv" \
  "$root/rtl/nonce/hmac_sha256.sv" "$root/rtl/nonce/rfc6979.sv" "$root/tb/tb_rfc6979.sv"
vvp "$build/tb_rfc6979.vvp"
