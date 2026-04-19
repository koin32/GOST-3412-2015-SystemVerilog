# AGENTS.md

## Key files
- `kuznechik.sv` - Kuznyechik cipher (128-bit block, 256-bit key)
- `magma.sv` - Magma cipher (64-bit block, 256-bit key)
- `tb.sv` - Testbench for Kuznyechik (~60 tests)
- `tb_magma.sv` - Testbench for Magma

## Running tests
No standard build system. Use an HDL simulator (Xcelium, ModelSim, VCS, Vivado):

```bash
# Kuznyechik
xvlog -2012 kuznechik.sv tb.sv
xsim -t tb

# Magma
xvlog -2012 magma.sv tb_magma.sv
xsim -t tb_magma
```

## Verified test vectors (from RFCs)

### Kuznyechik (RFC 7801)
```
KEY = 8899aabbccddeeff0011223344556677fedcba98765432100123456789abcdef
PT  = 1122334455667700ffeeddccbbaa9988
CT  = 7f679d90bebc24305a468d42b9d4edcd
```

### Magma (RFC 8891)
```
KEY = ffeeddccbbaa99887766554433221100f0f1f2f3f4f5f6f7f8f9fafbfcfdfeff
PT  = fedcba9876543210
CT  = 4ee901e5c2d8ca3d
```

## Notes
- Testbenches display PASS/FAIL messages for each test case
- Simulator must support SystemVerilog 2012 (`-2012` flag)
- No additional dependencies beyond HDL simulator