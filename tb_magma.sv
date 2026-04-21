`timescale 1ns/1ps

// ============================================================
// MAGMA TestBench
// Reference: GOST 34.12-2018, Appendix A, Section A.3
// ============================================================

module magma_tb;

    // =========================================================
    // DUT Signals
    // =========================================================
    logic         decrypt;
    logic [63:0]  block_in;
    logic [255:0] key;
    logic [63:0]  block_out;

    // =========================================================
    // Test Counters
    // =========================================================
    int total_tests;
    int passed_tests;
    int failed_tests;

    // =========================================================
    // DUT Instance
    // =========================================================
    magma dut (
        .decrypt   (decrypt),
        .block_in  (block_in),
        .key       (key),
        .block_out (block_out)
    );

    // =========================================================
    // Helper Task: Apply vector and verify result
    //
    // Parameters:
    //   test_name   - test description string
    //   dec         - mode (0=encrypt, 1=decrypt)
    //   blk_in      - input block 64 bit
    //   k           - key 256 bit
    //   expected    - expected result 64 bit
    // =========================================================
    task automatic run_test(
        input string    test_name,
        input logic     dec,
        input logic [63:0]  blk_in,
        input logic [255:0] k,
        input logic [63:0]  expected
    );
        logic [63:0] result;

        decrypt  = dec;
        block_in = blk_in;
        key      = k;

        #10;

        result = block_out;
        total_tests++;

        if (result === expected) begin
            $display("[PASS] %s", test_name);
            $display("       block_in  = 0x%016h", blk_in);
            $display("       key       = 0x%064h", k);
            $display("       expected  = 0x%016h", expected);
            $display("       got       = 0x%016h", result);
            passed_tests++;
        end else begin
            $display("[FAIL] %s", test_name);
            $display("       block_in  = 0x%016h", blk_in);
            $display("       key       = 0x%064h", k);
            $display("       expected  = 0x%016h", expected);
            $display("       got       = 0x%016h", result);
            $display("       DIFF      = 0x%016h", result ^ expected);
            failed_tests++;
        end
        $display("");

    endtask

    // =========================================================
    // Helper Task: Verify reversibility
    // Encrypt then decrypt - should recover original plaintext
    // =========================================================
    task automatic run_roundtrip_test(
        input string    test_name,
        input logic [63:0]  plaintext,
        input logic [255:0] k
    );
        logic [63:0] ciphertext;
        logic [63:0] decrypted;

        // Step 1: Encrypt
        decrypt  = 1'b0;
        block_in = plaintext;
        key      = k;
        #10;
        ciphertext = block_out;

        // Step 2: Decrypt
        decrypt  = 1'b1;
        block_in = ciphertext;
        key      = k;
        #10;
        decrypted = block_out;

        total_tests++;
        if (decrypted === plaintext) begin
            $display("[PASS] ROUNDTRIP: %s", test_name);
            $display("       plaintext  = 0x%016h", plaintext);
            $display("       ciphertext = 0x%016h", ciphertext);
            $display("       decrypted  = 0x%016h", decrypted);
            passed_tests++;
        end else begin
            $display("[FAIL] ROUNDTRIP: %s", test_name);
            $display("       plaintext  = 0x%016h", plaintext);
            $display("       ciphertext = 0x%016h", ciphertext);
            $display("       decrypted  = 0x%016h", decrypted);
            $display("       DIFF       = 0x%016h", decrypted ^ plaintext);
            failed_tests++;
        end
        $display("");

    endtask

    // =========================================================
    // Main Test Block
    // =========================================================
    initial begin

        total_tests  = 0;
        passed_tests = 0;
        failed_tests = 0;

        decrypt  = 1'b0;
        block_in = 64'h0;
        key      = 256'h0;

        $display("=========================================================");
        $display("  MAGMA TestBench - GOST 34.12-2018 (Appendix A, A.3)");
        $display("=========================================================");
        $display("");

        $display("---------------------------------------------------------");
        $display(" GROUP 1: Encrypt (GOST A.3.4)");
        $display(" Key K = ffeeddccbbaa99887766554433221100f0f1f2f3f4f5f6f7f8f9fafbfcfdfeff");
        $display(" Plaintext a = fedcba9876543210");
        $display(" Expected ciphertext b = 4ee901e5c2d8ca3d");
        $display("---------------------------------------------------------");
        $display("");

        run_test(
            "GOST A.3.4 - Encrypt: fedcba9876543210",
            1'b0,
            64'hfedcba9876543210,
            256'hffeeddccbbaa99887766554433221100f0f1f2f3f4f5f6f7f8f9fafbfcfdfeff,
            64'h4ee901e5c2d8ca3d
        );

        $display("---------------------------------------------------------");
        $display(" GROUP 2: Decrypt (GOST A.3.5)");
        $display(" Ciphertext b = 4ee901e5c2d8ca3d");
        $display(" Expected plaintext a = fedcba9876543210");
        $display("---------------------------------------------------------");
        $display("");

        run_test(
            "GOST A.3.5 - Decrypt: 4ee901e5c2d8ca3d",
            1'b1,
            64'h4ee901e5c2d8ca3d,
            256'hffeeddccbbaa99887766554433221100f0f1f2f3f4f5f6f7f8f9fafbfcfdfeff,
            64'hfedcba9876543210
        );

        $display("---------------------------------------------------------");
        $display(" GROUP 3: Roundtrip Tests (Encrypt -> Decrypt)");
        $display("---------------------------------------------------------");
        $display("");

        run_roundtrip_test(
            "GOST vector: fedcba9876543210",
            64'hfedcba9876543210,
            256'hffeeddccbbaa99887766554433221100f0f1f2f3f4f5f6f7f8f9fafbfcfdfeff
        );

        run_roundtrip_test(
            "Zero plaintext",
            64'h0000000000000000,
            256'hffeeddccbbaa99887766554433221100f0f1f2f3f4f5f6f7f8f9fafbfcfdfeff
        );

        run_roundtrip_test(
            "All-ones plaintext",
            64'hffffffffffffffff,
            256'hffeeddccbbaa99887766554433221100f0f1f2f3f4f5f6f7f8f9fafbfcfdfeff
        );

        run_roundtrip_test(
            "Zero key",
            64'hfedcba9876543210,
            256'h0000000000000000000000000000000000000000000000000000000000000000
        );

        run_roundtrip_test(
            "All-ones key",
            64'hfedcba9876543210,
            256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffff
        );

        run_roundtrip_test(
            "Alternating pattern 0xAA plaintext",
            64'haaaaaaaaaaaaaaaa,
            256'hffeeddccbbaa99887766554433221100f0f1f2f3f4f5f6f7f8f9fafbfcfdfeff
        );

        run_roundtrip_test(
            "Alternating pattern 0x55 key",
            64'hfedcba9876543210,
            256'h5555555555555555555555555555555555555555555555555555555555555555
        );

        run_roundtrip_test(
            "One bit in plaintext (LSB)",
            64'h0000000000000001,
            256'hffeeddccbbaa99887766554433221100f0f1f2f3f4f5f6f7f8f9fafbfcfdfeff
        );

        run_roundtrip_test(
            "One bit in plaintext (MSB)",
            64'h8000000000000000,
            256'hffeeddccbbaa99887766554433221100f0f1f2f3f4f5f6f7f8f9fafbfcfdfeff
        );

        run_roundtrip_test(
            "Pseudorandom vector 1",
            64'hdeadbeefcafebabe,
            256'h0102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f20
        );

        run_roundtrip_test(
            "Pseudorandom vector 2",
            64'h0123456789abcdef,
            256'hfedcba9876543210fedcba9876543210fedcba9876543210fedcba9876543210
        );

        run_roundtrip_test(
            "Zero key + zero block",
            64'h0000000000000000,
            256'h0000000000000000000000000000000000000000000000000000000000000000
        );

        $display("---------------------------------------------------------");
        $display(" GROUP 4: Avalanche Effect Test");
        $display("---------------------------------------------------------");
        $display("");

        begin
            logic [63:0]  ct_orig, ct_flip_pt, ct_flip_key;
            logic [255:0] test_key;
            logic [63:0]  test_pt;
            int           diff_bits_pt, diff_bits_key;

            test_pt  = 64'hfedcba9876543210;
            test_key = 256'hffeeddccbbaa99887766554433221100f0f1f2f3f4f5f6f7f8f9fafbfcfdfeff;

            decrypt  = 1'b0;
            block_in = test_pt;
            key      = test_key;
            #10;
            ct_orig = block_out;

            decrypt  = 1'b0;
            block_in = test_pt ^ 64'h0000000000000001;
            key      = test_key;
            #10;
            ct_flip_pt = block_out;

            decrypt  = 1'b0;
            block_in = test_pt;
            key      = test_key ^ 256'h1;
            #10;
            ct_flip_key = block_out;

            diff_bits_pt  = $countones(ct_orig ^ ct_flip_pt);
            diff_bits_key = $countones(ct_orig ^ ct_flip_key);

            total_tests++;
            $display("[INFO] Avalanche - 1 bit change in PT:");
            $display("       CT_original = 0x%016h", ct_orig);
            $display("       CT_flipped  = 0x%016h", ct_flip_pt);
            $display("       Bit difference = %0d / 64", diff_bits_pt);
            if (diff_bits_pt >= 16) begin
                $display("[PASS] Avalanche (1 bit PT change): %0d bits", diff_bits_pt);
                passed_tests++;
            end else begin
                $display("[FAIL] Weak avalanche: only %0d bits changed", diff_bits_pt);
                failed_tests++;
            end
            $display("");

            total_tests++;
            $display("[INFO] Avalanche - 1 bit change in KEY:");
            $display("       CT_original = 0x%016h", ct_orig);
            $display("       CT_flipped  = 0x%016h", ct_flip_key);
            $display("       Bit difference = %0d / 64", diff_bits_key);
            if (diff_bits_key >= 16) begin
                $display("[PASS] Avalanche (1 bit KEY change): %0d bits", diff_bits_key);
                passed_tests++;
            end else begin
                $display("[FAIL] Weak avalanche: only %0d bits changed", diff_bits_key);
                failed_tests++;
            end
            $display("");
        end

        $display("---------------------------------------------------------");
        $display(" GROUP 5: Additional Compatibility Tests");
        $display("---------------------------------------------------------");
        $display("");

        begin
            logic [63:0] ct_zero;
            decrypt  = 1'b0;
            block_in = 64'h0;
            key      = 256'h0;
            #10;
            ct_zero = block_out;
            total_tests++;
            if (ct_zero !== 64'h0) begin
                $display("[PASS] Encryption does not return zeros with zero inputs");
                $display("       CT = 0x%016h", ct_zero);
                passed_tests++;
            end else begin
                $display("[FAIL] Encryption returned zero result!");
                failed_tests++;
            end
            $display("");
        end

        begin
            logic [63:0] ct_enc, ct_dec;
            logic [63:0] test_block;
            logic [255:0] test_k;
            test_block = 64'hfedcba9876543210;
            test_k     = 256'hffeeddccbbaa99887766554433221100f0f1f2f3f4f5f6f7f8f9fafbfcfdfeff;

            decrypt  = 1'b0;
            block_in = test_block;
            key      = test_k;
            #10;
            ct_enc = block_out;

            decrypt  = 1'b1;
            block_in = test_block;
            key      = test_k;
            #10;
            ct_dec = block_out;

            total_tests++;
            if (ct_enc !== ct_dec) begin
                $display("[PASS] Encrypt and decrypt modes produce different results");
                $display("       ENC(PT) = 0x%016h", ct_enc);
                $display("       DEC(PT) = 0x%016h", ct_dec);
                passed_tests++;
            end else begin
                $display("[FAIL] Encryption and decryption returned same result!");
                failed_tests++;
            end
            $display("");
        end

        $display("=========================================================");
        $display("  FINAL REPORT");
        $display("=========================================================");
        $display("  Total tests : %0d", total_tests);
        $display("  Passed    : %0d", passed_tests);
        $display("  Failed    : %0d", failed_tests);
        $display("---------------------------------------------------------");

        if (failed_tests == 0) begin
            $display("  STATUS: ALL TESTS PASSED");
            $display("  Implementation conforms to GOST 34.12-2018");
        end else begin
            $display("  STATUS: ERRORS DETECTED");
            $display("  Implementation does NOT conform to GOST 34.12-2018");
        end
        $display("=========================================================");

        $finish;
    end

    // =========================================================
    // Simulation Timeout
    // =========================================================
    initial begin
        #100000;
        $display("[ERROR] Simulation timeout!");
        $finish;
    end

    // =========================================================
    // VCD Dump for GTKWave / ModelSim
    // =========================================================
    initial begin
        $dumpfile("magma_tb.vcd");
        $dumpvars(0, magma_tb);
    end

endmodule