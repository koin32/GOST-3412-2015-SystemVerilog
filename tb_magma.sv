`timescale 1ns/1ps

module tb_magma;

    // Интерфейс DUT
    logic         decrypt;
    logic [63:0]  block_in;
    logic [255:0] key;
    logic [63:0]  block_out;

    // Вспомогательные переменные
    logic [63:0]  ct, recovered;
    logic [255:0] test_key;
    int           error_count = 0;

    // Инстанс модуля
    magma dut (.*);

    // Функция для красивого вывода HEX
    function automatic string hex64(input logic [63:0] x);
        return $sformatf("%016h", x);
    endfunction

    // Задача для проверки одного вектора
    task automatic run_test(
        input string test_name,
        input logic [63:0]  pt,
        input logic [255:0] tk,
        input logic         dec_mode,
        input logic [63:0]  expected
    );
        block_in = pt;
        key      = tk;
        decrypt  = dec_mode;
        #20; // Ожидание распространения сигнала

        if (block_out === expected) begin
            $display("[PASS] %-25s : %s", test_name, hex64(block_out));
        end else begin
            $display("[FAIL] %-25s : Got=%s  Exp=%s", test_name, hex64(block_out), hex64(expected));
            error_count++;
        end
    endtask

    // Задача для проверки Round-Trip (Зашифровать -> Расшифровать)
    task automatic round_trip(
        input string name,
        input logic [63:0]  pt,
        input logic [255:0] tk
    );
        // 1. Шифрование
        decrypt = 0; block_in = pt; key = tk; #20; 
        ct = block_out;
        
        // 2. Дешифрование
        decrypt = 1; block_in = ct; #20; 
        recovered = block_out;

        if (recovered === pt)
            $display("[PASS] RT:%-12s  %s -> %s -> %s", name, hex64(pt), hex64(ct), hex64(recovered));
        else begin
            $display("[FAIL] RT:%-12s  %s -> %s -> %s", name, hex64(pt), hex64(ct), hex64(recovered));
            error_count++;
        end
    endtask

    initial begin
        $display("\n======================================================");
        $display("          Magma (GOST R 34.12-2015) TestBench");
        $display("======================================================\n");

        // Тестовый ключ (произвольный)
        test_key = 256'h0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef;

        // Группа 1: Проверка Round-Trip (самый надежный способ проверить корректность)
        $display("[G1] Round-trip tests (Encrypt -> Decrypt)");
        round_trip("zeros",      64'h0000000000000000, test_key);
        round_trip("ones",       64'hffffffffffffffff, test_key);
        round_trip("alternating",64'ha5a5a5a5a5a5a5a5, test_key);
        round_trip("random",     64'h1234567890abcdef, test_key);

        // Группа 2: Проверка с другим ключом
        $display("\n[G2] Round-trip with different key");
        test_key = 256'hfedcba9876543210fedcba9876543210fedcba9876543210fedcba9876543210;
        round_trip("official_pt", 64'h1122334455667700, test_key);

        // Группа 3: Проверка лавинного эффекта (изменение 1 бита PT)
        $display("\n[G3] Avalanche effect check");
        decrypt = 0; key = test_key;
        block_in = 64'h1122334455667700; #20; ct = block_out;
        block_in = 64'h1122334455667701; #20;
        $display("PT1: %s -> CT1: %s", hex64(64'h1122334455667700), hex64(ct));
        $display("PT2: %s -> CT2: %s", hex64(64'h1122334455667701), hex64(block_out));
        $display("Hamming distance: %0d bits", $countones(ct ^ block_out));

        $display("\n======================================================");
        if (error_count == 0)
            $display("                  ALL TESTS PASSED!");
        else
            $display("                  %0d TESTS FAILED!", error_count);
        $display("======================================================\n");

        $finish;
    end

endmodule