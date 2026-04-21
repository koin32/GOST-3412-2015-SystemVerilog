`timescale 1ns/1ps

module tb_magma_gost3412_2018;

    // ====================== DUT интерфейс ======================
    logic         decrypt;
    logic [63:0]  block_in;
    logic [255:0] key;
    logic [63:0]  block_out;

    magma dut (.*);

    int error_count = 0;

    // ============================================================
    // S-BOX из вашего DUT (и ГОСТ 34.12-2018 / 2015 для Магмы)
    // ============================================================
    localparam logic [3:0] PI [0:7][0:15] = '{
        '{12,4,6,2,10,5,11,9,14,8,13,7,0,3,15,1},
        '{6,8,2,3,9,10,5,12,1,14,4,7,11,13,0,15},
        '{11,3,5,8,2,15,10,13,14,1,7,4,12,9,6,0},
        '{12,8,2,1,13,4,15,6,7,0,10,5,3,14,9,11},
        '{7,15,5,10,8,1,6,13,0,9,3,14,11,4,2,12},
        '{5,13,15,6,9,2,12,10,11,7,8,1,4,3,14,0},
        '{8,14,2,5,6,9,1,12,15,4,11,0,13,10,3,7},
        '{1,7,14,13,0,5,8,3,4,15,10,6,9,12,11,2}
    };

    // ====================== format helpers ======================
    function automatic string hex64(input logic [63:0] x);
        return $sformatf("%016h", x);
    endfunction
    function automatic string hex32(input logic [31:0] x);
        return $sformatf("%08h", x);
    endfunction

    task automatic check_eq64(input string name, input logic [63:0] got, input logic [63:0] exp);
        if (got === exp) $display("[PASS] %-30s %s", name, hex64(got));
        else begin
            $display("[FAIL] %-30s got=%s exp=%s", name, hex64(got), hex64(exp));
            error_count++;
        end
    endtask

    task automatic check_eq32(input string name, input logic [31:0] got, input logic [31:0] exp);
        if (got === exp) $display("[PASS] %-30s %s", name, hex32(got));
        else begin
            $display("[FAIL] %-30s got=%s exp=%s", name, hex32(got), hex32(exp));
            error_count++;
        end
    endtask

    // ============================================================
    // Эталонные t и g (ГОСТ 34.12-2018, A.3.1 / A.3.2)
    // t(a): подстановка π0..π7 над нибблами a0..a7 (справа налево)
    // g[k](a) = ( t(a + k mod 2^32) ) <<< 11
    // ============================================================
    function automatic logic [31:0] t_ref(input logic [31:0] a);
        logic [31:0] y;
        begin
            y = '0;
            for (int i = 0; i < 8; i++)
                y[i*4 +: 4] = PI[i][ a[i*4 +: 4] ];
            t_ref = y;
        end
    endfunction

    function automatic logic [31:0] g_ref(input logic [31:0] a, input logic [31:0] k);
        logic [31:0] s, t;
        begin
            s = a + k;
            t = t_ref(s);
            g_ref = {t[20:0], t[31:21]}; // ROTL 11
        end
    endfunction

    // ============================================================
    // Эталонный key schedule (ГОСТ 34.12-2018, (18), A.3.3)
    // ============================================================
    function automatic logic [31:0] rk_ref(input logic [255:0] K, input int idx_1based);
        logic [31:0] base[1:8];
        begin
            for (int i = 1; i <= 8; i++)
                base[i] = K[255 - (i-1)*32 -: 32];

            if (idx_1based >= 1 && idx_1based <= 24)
                rk_ref = base[((idx_1based-1) % 8) + 1];
            else if (idx_1based >= 25 && idx_1based <= 32)
                rk_ref = base[8 - (idx_1based-25)];
            else
                rk_ref = 32'hx;
        end
    endfunction

    // ====================== DUT call wrappers ======================
    task automatic dut_encrypt(input logic [63:0] pt, input logic [255:0] k, output logic [63:0] ct);
        decrypt  = 1'b0;
        block_in = pt;
        key      = k;
        #20;
        ct = block_out;
    endtask

    task automatic dut_decrypt(input logic [63:0] ct, input logic [255:0] k, output logic [63:0] pt);
        decrypt  = 1'b1;
        block_in = ct;
        key      = k;
        #20;
        pt = block_out;
    endtask

    // ====================== MAIN ======================
    initial begin
        logic [255:0] K;
        logic [63:0]  PT, CT;
        logic [63:0]  got_ct, got_pt;

        $display("\n======================================================");
        $display("   Magma TB (aligned with GOST 34.12-2018, Appendix A.3)");
        $display("======================================================\n");

        // ГОСТ A.3.3 ключ
        K  = 256'hffeeddccbbaa99887766554433221100f0f1f2f3f4f5f6f7f8f9fafbfcfdfeff;

        // ------------------------------------------------------------
        // A.3.1: t-преобразование
        // ------------------------------------------------------------
        $display("[A.3.1] t() checks");
        check_eq32("t(fdb97531)", t_ref(32'hfdb97531), 32'h2a196f34);
        check_eq32("t(2a196f34)", t_ref(32'h2a196f34), 32'hebd9f03a);
        check_eq32("t(ebd9f03a)", t_ref(32'hebd9f03a), 32'hb039bb3d);
        check_eq32("t(b039bb3d)", t_ref(32'hb039bb3d), 32'h68695433);

        // ------------------------------------------------------------
        // A.3.2: g-преобразование
        // ------------------------------------------------------------
        $display("\n[A.3.2] g[]() checks");
        check_eq32("g[87654321](fedcba98)", g_ref(32'hfedcba98, 32'h87654321), 32'hfdcbc20c);
        check_eq32("g[fdcbc20c](87654321)", g_ref(32'h87654321, 32'hfdcbc20c), 32'h7e791a4b);
        check_eq32("g[7e791a4b](fdcbc20c)", g_ref(32'hfdcbc20c, 32'h7e791a4b), 32'hc76549ec);
        check_eq32("g[c76549ec](7e791a4b)", g_ref(32'h7e791a4b, 32'hc76549ec), 32'h9791c849);

        // ------------------------------------------------------------
        // A.3.3: развёртка ключа (точечные проверки из таблицы)
        // ------------------------------------------------------------
        $display("\n[A.3.3] Key schedule checks (selected)");
        check_eq32("K1 ",  rk_ref(K,  1), 32'hffeeddcc);
        check_eq32("K2 ",  rk_ref(K,  2), 32'hbbaa9988);
        check_eq32("K3 ",  rk_ref(K,  3), 32'h77665544);
        check_eq32("K4 ",  rk_ref(K,  4), 32'h33221100);
        check_eq32("K5 ",  rk_ref(K,  5), 32'hf0f1f2f3);
        check_eq32("K8 ",  rk_ref(K,  8), 32'hfcfdfeff);
        check_eq32("K9 (=K1)",   rk_ref(K,  9), 32'hffeeddcc);
        check_eq32("K17(=K1)",   rk_ref(K, 17), 32'hffeeddcc);
        check_eq32("K25(=K8)",   rk_ref(K, 25), 32'hfcfdfeff);
        check_eq32("K32(=K1)",   rk_ref(K, 32), 32'hffeeddcc);

        // ------------------------------------------------------------
        // A.3.4: официальный вектор шифрования/дешифрования
        // ------------------------------------------------------------
        $display("\n[A.3.4] Official encrypt/decrypt vector");
        PT = 64'hfedcba9876543210;
        CT = 64'h4ee901e5c2d8ca3d;

        dut_encrypt(PT, K, got_ct);
        check_eq64("Encrypt(PT)=CT", got_ct, CT);

        dut_decrypt(CT, K, got_pt);
        check_eq64("Decrypt(CT)=PT", got_pt, PT);

        // ------------------------------------------------------------
        // Итог
        // ------------------------------------------------------------
        $display("\n======================================================");
        if (error_count == 0)
            $display("                  ALL TESTS PASSED!");
        else
            $display("                  %0d TESTS FAILED!", error_count);
        $display("======================================================\n");

        $finish;
    end

endmodule