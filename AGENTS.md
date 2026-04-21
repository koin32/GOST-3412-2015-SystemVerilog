# AGENTS.md

## Key files
- `kuznechik.sv` - Kuznyechik cipher (128-bit block, 256-bit key)
  - Main module: `grasshopper` (not kuznechik)
- `magma.sv` - Magma cipher (64-bit block, 256-bit key)
  - Note: encrypt/decrypt implementation has issues (see below)
- `tb.sv` - Testbench for Kuznyechik (~60 tests in named groups)
- `tb_magma.sv` - Testbench for Magma

## Running tests
Use Xilinx Vivado with SystemVerilog support:

```bash
# Via Vivado TCL script
xvlog --sv --work work magma.sv tb_magma.sv
xelab -R --debug typical -s magma_tb work.magma_tb

# Or use the provided TCL script
vivado -nojournal -mode batch -source run_magma.tcl
```

## Testbench sections
The Kuznyechik testbench (`tb.sv`) executes these named test groups:
- [G0] Diagnostics (official key)
- [G1] Official GOST R 34.12-2015 test vector
- [G2] Round-trip tests (encrypt then decrypt)
- [G3] Avalanche effect (1-bit change impact)
- [G4] Key uniqueness (different keys produce different ciphertext)
- [G5] Determinism (same input always yields same output)
- [G6] Stress (50 random round-trip tests)

The Magma testbench (`tb_magma.sv`) executes:
-arii diagnostic (official key test)
- Official RFC 8891 test vector
- Round-trip tests
- Determinism tests
- Stress testing

## Verified test vectors (from RFCs)

### Kuznyechik (RFC 7801)
```
KEY = 8899aabbccddeeff0011223344556677fedcba98765432100123456789abcdef
PT  = 1122334455667700ffeeddccbbaa9988
CT  = 7f679d90bebc24305a468d42b9d4edcd
```

### Magma (RFC 8891)
- RFC key: `ffeeddccbbaa99887766554433221100f0f1f2f3f4f5f6f7f8f9fafbfcdfeff` (63 hex - 252-bit!)
- Testbench uses: `0ffeeddcc...` (64 hex - padded to 256-bit)
- Expected CT: `4ee901e5c2d8ca3d`

## Magma Known Issues
- **Key format**: RFC 8891 provides 63-hex (252-bit) key, needs padding to 64-hex
- **Encrypt**: Produces 64-bit output but doesn't match RFC 8891 test vector
- **Round swap**: Added swap after each round (except last) per ГОСТ Р 34.12-2015
- **Decrypt**: Round-trip fails
- S-box and G-function (rotl11) are implemented correctly per Table 3.1
- Key schedule follows ГОСТ pattern (k1-k8, then reversed)

## Notes
- Testbenches display PASS/FAIL messages for each test case with test IDs
- Vivado 2025.2 uses `--sv` instead of `-2012`
- No additional dependencies beyond HDL simulator
- Testbenches show intermediate values (round keys, etc.) during diagnostics