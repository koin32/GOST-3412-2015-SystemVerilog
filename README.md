===================================
  GOST R 34.12-2015 Kuznyechik TB
  Key source: RFC 7801 / GOST R 34.12-2015 App.A
===================================
[G0] Diagnostics
=== Diagnostic (Official GOST R 34.12-2015 Key) ===
KEY = 8899aabbccddeeff0011223344556677fedcba98765432100123456789abcdef
rk[0]=8899aabbccddeeff0011223344556677
 exp =8899aabbccddeeff0011223344556677
rk[1]=fedcba98765432100123456789abcdef
 exp =fedcba98765432100123456789abcdef
rk[2]=db31485315694343228d6aef8cc78c44
 exp =db31485315694343228d6aef8cc78c44
rk[3]=3d4553d8e9cfec6815ebadc40a9ffd04
 exp =3d4553d8e9cfec6815ebadc40a9ffd04
rk[4]=57646468c44a5e28d3e59246f429f1ac
 exp =57646468c44a5e28d3e59246f429f1ac
rk[5]=bd079435165c6432b532e82834da581b
 exp =bd079435165c6432b532e82834da581b
rk[6]=51e640757e8745de705727265a0098b1
 exp =51e640757e8745de705727265a0098b1
rk[7]=5a7925017b9fdd3ed72a91a22286f984
 exp =5a7925017b9fdd3ed72a91a22286f984
rk[8]=bb44e25378c73123a5f32f73cdb6e517
 exp =bb44e25378c73123a5f32f73cdb6e517
rk[9]=72e9dd7416bcf45b755dbaa88e4a4043
 exp =72e9dd7416bcf45b755dbaa88e4a4043
enc_out=7f679d90bebc24305a468d42b9d4edcd
   exp =7f679d90bebc24305a468d42b9d4edcd
===================================================
[G1] Official GOST R 34.12-2015 test vector
     Source: GOST R 34.12-2015 Appendix A, RFC 7801 Section 7
PASS[1] GOST-Appendix-A encrypt  CT=7f679d90bebc24305a468d42b9d4edcd
PASS[2] GOST-Appendix-A decrypt  PT=1122334455667700ffeeddccbbaa9988
[G2] Round-trip tests
PASS[3] RT:zeros  00000000000000000000000000000000->98cc6b54dbcf7bd2f0800c1fab0677ef->00000000000000000000000000000000
PASS[4] RT:ones  ffffffffffffffffffffffffffffffff->0e697e9f0587a38c908454ac39e1c463->ffffffffffffffffffffffffffffffff
PASS[5] RT:official-key-roundtrip  1122334455667700ffeeddccbbaa9988->7f679d90bebc24305a468d42b9d4edcd->1122334455667700ffeeddccbbaa9988
PASS[6] RT:rnd1  0123456789abcdef0123456789abcdef->ea759d9d003805061bc8511312526dcd->0123456789abcdef0123456789abcdef
PASS[7] RT:alternating  a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5->9ad2be3c31c78ea3e87a9b0328177f9f->a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5
PASS[8] RT:msb  80000000000000000000000000000000->626f3c1f630037f638c1e06cbb419a1b->80000000000000000000000000000000
PASS[9] RT:lsb  00000000000000000000000000000001->f190347ea051cd1c53258d9cab8c0982->00000000000000000000000000000001
[G3] Avalanche effect
  1-bit PT change: CT0=7f679d90bebc24305a468d42b9d4edcd
                   CT1=91eb889b4b73d593a441ba5045740220
  Hamming distance = 74 / 128 bits
PASS[10] Avalanche-PT (74 bits changed)
  1-bit KEY change: CT0=7f679d90bebc24305a468d42b9d4edcd
                    CT1=efbf0c595253b3a989aa6a5b3e140acf
  Hamming distance = 66 / 128 bits
PASS[11] Avalanche-KEY (66 bits changed)
[G4] Key uniqueness
PASS[12] Diff keys -> diff CT
  CTA=c136f5f7d4d79374d3798ac22f1ec66d
  CTB=71c3944bc6550a42763e9e7f7d44c205
[G5] Determinism
PASS[13] Deterministic: c2c03d0f88d8ebecfb24af5480f5fa18
[G6] Stress (50 random round-trips)
