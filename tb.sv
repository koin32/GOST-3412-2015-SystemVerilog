
`timescale 1ns/1ps

module kuz_tb;

    localparam CLK_HALF = 5;

    logic        clk     = 1'b0;
    logic        rst_n   = 1'b0;
    logic        start   = 1'b0;
    logic        decrypt = 1'b0;
    logic [127:0] data_in  = '0;
    logic [255:0] key      = '0;
    logic [127:0] data_out;
    logic         valid;

    always #CLK_HALF clk = ~clk;

    grasshopper dut (.*);

    int pass_cnt = 0;
    int fail_cnt = 0;
    int test_id  = 0;

    task automatic do_op (
        input  logic [127:0] din,
        input  logic [255:0] k,
        input  logic         dec,
        output logic [127:0] dout
    );
        @(negedge clk);
        data_in = din; key = k; decrypt = dec; start = 1'b1;
        @(negedge clk);
        start = 1'b0;
        @(negedge clk);
        dout = data_out;
    endtask

    task automatic chk_enc (
        input logic [127:0] pt,
        input logic [255:0] k,
        input logic [127:0] exp,
        input string        nm
    );
        automatic logic [127:0] got;
        do_op(pt, k, 1'b0, got);
        test_id++;
        if (got === exp) begin
            $display("PASS[%0d] %s  CT=%h", test_id, nm, got);
            pass_cnt++;
        end else begin
            $display("FAIL[%0d] %s", test_id, nm);
            $display("  PT =%h", pt);
            $display("  KEY=%h", k);
            $display("  GOT=%h", got);
            $display("  EXP=%h", exp);
            fail_cnt++;
        end
    endtask

    task automatic chk_dec (
        input logic [127:0] ct,
        input logic [255:0] k,
        input logic [127:0] exp,
        input string        nm
    );
        automatic logic [127:0] got;
        do_op(ct, k, 1'b1, got);
        test_id++;
        if (got === exp) begin
            $display("PASS[%0d] %s  PT=%h", test_id, nm, got);
            pass_cnt++;
        end else begin
            $display("FAIL[%0d] %s", test_id, nm);
            $display("  CT =%h", ct);
            $display("  KEY=%h", k);
            $display("  GOT=%h", got);
            $display("  EXP=%h", exp);
            fail_cnt++;
        end
    endtask

    task automatic chk_rt (
        input logic [127:0] pt,
        input logic [255:0] k,
        input string        nm
    );
        automatic logic [127:0] ct, pt2;
        do_op(pt, k, 1'b0, ct);
        do_op(ct, k, 1'b1, pt2);
        test_id++;
        if (pt2 === pt) begin
            $display("PASS[%0d] RT:%s  %h->%h->%h", test_id, nm, pt, ct, pt2);
            pass_cnt++;
        end else begin
            $display("FAIL[%0d] RT:%s", test_id, nm);
            $display("  PT =%h", pt);
            $display("  CT =%h", ct);
            $display("  PT2=%h (want %h)", pt2, pt);
            fail_cnt++;
        end
    endtask

    task automatic show_diag;
        key     = 256'h8899AABBCCDDEEFF0011223344556677FEDCBA98765432100123456789ABCDEF;
        data_in = 128'h1122334455667700FFEEDDCCBBAA9988;
        #2;

        $display("=== Diagnostic (Official GOST R 34.12-2015 Key) ===");
        $display("KEY = %h", key);

        $display("rk[0]=%h", dut.rk[0]);
        $display(" exp =8899aabbccddeeff0011223344556677");

        $display("rk[1]=%h", dut.rk[1]);
        $display(" exp =fedcba98765432100123456789abcdef");

        $display("rk[2]=%h", dut.rk[2]);
        // ГОСТ Р 34.12-2015, Приложение А.1.4, стр. 13:
        // K3 = db31485315694343228d6aef8cc78c44
        $display(" exp =db31485315694343228d6aef8cc78c44");

        $display("rk[3]=%h", dut.rk[3]);
        $display(" exp =3d4553d8e9cfec6815ebadc40a9ffd04");

        $display("rk[4]=%h", dut.rk[4]);
        $display(" exp =57646468c44a5e28d3e59246f429f1ac");

        $display("rk[5]=%h", dut.rk[5]);
        $display(" exp =bd079435165c6432b532e82834da581b");

        $display("rk[6]=%h", dut.rk[6]);
        $display(" exp =51e640757e8745de705727265a0098b1");

        $display("rk[7]=%h", dut.rk[7]);
        $display(" exp =5a7925017b9fdd3ed72a91a22286f984");

        $display("rk[8]=%h", dut.rk[8]);
        $display(" exp =bb44e25378c73123a5f32f73cdb6e517");

        $display("rk[9]=%h", dut.rk[9]);
        $display(" exp =72e9dd7416bcf45b755dbaa88e4a4043");

        $display("enc_out=%h", dut.enc_out);
        $display("   exp =7f679d90bebc24305a468d42b9d4edcd");
        $display("===================================================");
    endtask

    initial begin
        $display("===================================");
        $display("  GOST R 34.12-2015 Kuznyechik TB");
        $display("  Key source: RFC 7801 / GOST R 34.12-2015 App.A");
        $display("===================================");

        rst_n = 1'b0;
        repeat(4) @(posedge clk);
        @(negedge clk); rst_n = 1'b1;
        repeat(2) @(posedge clk);

        $display("[G0] Diagnostics");
        show_diag;

        $display("[G1] Official GOST R 34.12-2015 test vector");
        $display("     Source: GOST R 34.12-2015 Appendix A, RFC 7801 Section 7");

        chk_enc(
            128'h1122334455667700FFEEDDCCBBAA9988,
            256'h8899AABBCCDDEEFF0011223344556677FEDCBA98765432100123456789ABCDEF,
            128'h7F679D90BEBC24305A468D42B9D4EDCD,
            "GOST-Appendix-A encrypt"
        );

        chk_dec(
            128'h7F679D90BEBC24305A468D42B9D4EDCD,
            256'h8899AABBCCDDEEFF0011223344556677FEDCBA98765432100123456789ABCDEF,
            128'h1122334455667700FFEEDDCCBBAA9988,
            "GOST-Appendix-A decrypt"
        );

        $display("[G2] Round-trip tests");

        chk_rt(
            128'h00000000000000000000000000000000,
            256'h0000000000000000000000000000000000000000000000000000000000000000,
            "zeros"
        );

        chk_rt(
            128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF,
            256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF,
            "ones"
        );

        chk_rt(
            128'h1122334455667700FFEEDDCCBBAA9988,
            256'h8899AABBCCDDEEFF0011223344556677FEDCBA98765432100123456789ABCDEF,
            "official-key-roundtrip"
        );

        chk_rt(
            128'h0123456789ABCDEF0123456789ABCDEF,
            256'hDEADBEEFCAFEBABE0123456789ABCDEFFEDCBA98765432100123456789ABCDEF,
            "rnd1"
        );

        chk_rt(
            128'hA5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5,
            256'h5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A,
            "alternating"
        );

        chk_rt(
            128'h80000000000000000000000000000000,
            256'h8000000000000000000000000000000000000000000000000000000000000001,
            "msb"
        );

        // Младший бит PT
        chk_rt(
            128'h00000000000000000000000000000001,
            256'h0000000000000000000000000000000100000000000000000000000000000001,
            "lsb"
        );

        $display("[G3] Avalanche effect");

        begin : avl_pt
            automatic logic [127:0] ct0, ct1;
            automatic logic [255:0] kav;
            automatic int hd;
            kav = 256'h8899AABBCCDDEEFF0011223344556677FEDCBA98765432100123456789ABCDEF;
            do_op(128'h1122334455667700FFEEDDCCBBAA9988, kav, 1'b0, ct0);
            do_op(128'h1022334455667700FFEEDDCCBBAA9988, kav, 1'b0, ct1);
            hd = 0;
            for (int b = 0; b < 128; b++)
                if (ct0[b] ^ ct1[b]) hd++;
            test_id++;
            $display("  1-bit PT change: CT0=%h", ct0);
            $display("                   CT1=%h", ct1);
            $display("  Hamming distance = %0d / 128 bits", hd);
            if (hd >= 32) begin
                $display("PASS[%0d] Avalanche-PT (%0d bits changed)", test_id, hd);
                pass_cnt++;
            end else begin
                $display("FAIL[%0d] Avalanche-PT weak (%0d bits)", test_id, hd);
                fail_cnt++;
            end
        end

        begin : avl_key
            automatic logic [127:0] ct0, ct1;
            automatic logic [127:0] ptav;
            automatic int hd;
            ptav = 128'h1122334455667700FFEEDDCCBBAA9988;
            do_op(ptav,
                  256'h8899AABBCCDDEEFF0011223344556677FEDCBA98765432100123456789ABCDEF,
                  1'b0, ct0);
            do_op(ptav,
                  256'h8999AABBCCDDEEFF0011223344556677FEDCBA98765432100123456789ABCDEF,
                  1'b0, ct1);
            hd = 0;
            for (int b = 0; b < 128; b++)
                if (ct0[b] ^ ct1[b]) hd++;
            test_id++;
            $display("  1-bit KEY change: CT0=%h", ct0);
            $display("                    CT1=%h", ct1);
            $display("  Hamming distance = %0d / 128 bits", hd);
            if (hd >= 32) begin
                $display("PASS[%0d] Avalanche-KEY (%0d bits changed)", test_id, hd);
                pass_cnt++;
            end else begin
                $display("FAIL[%0d] Avalanche-KEY weak (%0d bits)", test_id, hd);
                fail_cnt++;
            end
        end

        $display("[G4] Key uniqueness");
        begin : uniq
            automatic logic [127:0] cta, ctb;
            automatic logic [127:0] pt_u;
            pt_u = 128'hAABBCCDDEEFF00112233445566778899;
            do_op(pt_u,
                  256'h0000000000000000000000000000000011111111111111111111111111111111,
                  1'b0, cta);
            do_op(pt_u,
                  256'h1111111111111111111111111111111100000000000000000000000000000000,
                  1'b0, ctb);
            test_id++;
            if (cta !== ctb) begin
                $display("PASS[%0d] Diff keys -> diff CT", test_id);
                $display("  CTA=%h", cta);
                $display("  CTB=%h", ctb);
                pass_cnt++;
            end else begin
                $display("FAIL[%0d] Diff keys -> SAME CT!", test_id);
                fail_cnt++;
            end
        end

        $display("[G5] Determinism");
        begin : det
            automatic logic [127:0] cx, cy;
            automatic logic [255:0] kd;
            kd = 256'hFEDCBA98765432100123456789ABCDEFFEDCBA98765432100123456789ABCDEF;
            do_op(128'hDEADBEEFCAFEBABE1234567890ABCDEF, kd, 1'b0, cx);
            do_op(128'hDEADBEEFCAFEBABE1234567890ABCDEF, kd, 1'b0, cy);
            test_id++;
            if (cx === cy) begin
                $display("PASS[%0d] Deterministic: %h", test_id, cx);
                pass_cnt++;
            end else begin
                $display("FAIL[%0d] Non-deterministic: %h != %h", test_id, cx, cy);
                fail_cnt++;
            end
        end

        $display("[G6] Stress (50 random round-trips)");
        begin : stress
            automatic int ok;
            automatic logic [127:0] spt, sct, sdec;
            automatic logic [255:0] sk;
            ok = 0;
            for (int i = 0; i < 50; i++) begin
                spt = {$urandom(), $urandom(), $urandom(), $urandom()};
                sk  = {$urandom(), $urandom(), $urandom(), $urandom(),
                       $urandom(), $urandom(), $urandom(), $urandom()};
                do_op(spt, sk, 1'b0, sct);
                do_op(sct, sk, 1'b1, sdec);
                if (sdec === spt) begin
                    ok++;
                end else begin
                    $display("  FAIL iter%0d:", i);
                    $display("    pt =%h", spt);
                    $display("    ct =%h", sct);
                    $display("    dec=%h", sdec);
                end
            end
            test_id++;
            if (ok == 50) begin
                $display("PASS[%0d] Stress 50/50", test_id);
                pass_cnt++;
            end else begin
                $display("FAIL[%0d] Stress %0d/50", test_id, ok);
                fail_cnt++;
            end
        end

        $display("");
        $display("===================================");
        $display("  RESULTS");
        $display("  Pass:  %0d", pass_cnt);
        $display("  Fail:  %0d", fail_cnt);
        $display("  Total: %0d", test_id);
        if (fail_cnt == 0)
            $display("  *** ALL TESTS PASSED ***");
        else
            $display("  *** FAILURES DETECTED ***");
        $display("===================================");

        $finish;
    end

    initial begin #500_000; $display("WATCHDOG timeout"); $finish; end
    initial begin $dumpfile("kuz.vcd"); $dumpvars(0, kuz_tb); end

endmodule