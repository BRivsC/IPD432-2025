`timescale 1ns / 1ps

module outputInterface_tb;

    // Señales para el DUT
    logic clk;
    logic reset;
    logic begin_transmission;
    logic tx_busy;
    logic [5:0] enables_in;
    logic [31:0] result_data;
    logic tx_start;
    logic tx_sent;
    logic [6:0] segments;
    logic [7:0] tx_data;
    logic [7:0] AN;

    // Instancia del DUT
    outputInterface #(
        .INTER_BYTE_DELAY           (1),
        .WAIT_FOR_REGISTER_DELAY    (1)
    ) dut (
        .clk                        (clk),
        .reset                      (reset),
        .begin_transmission         (begin_transmission),
        .tx_busy                    (tx_busy),
        .enables_in                 (enables_in),
        .result_data                (result_data),
        .tx_start                   (tx_start),
        .tx_sent                    (tx_sent),
        .segments                   (segments),
        .tx_data                    (tx_data),
        .AN                         (AN)
    );

    // Generador de reloj
    always #5 clk = ~clk;

    // Testbench
    initial begin
        // Inicialización
        clk = 0;
        reset = 1;
        begin_transmission = 0;
        tx_busy = 0;
        enables_in = 6'b001000; // Activar "euc"
        result_data = 32'h12345678; // Dato de prueba

        // Liberar reset
        #10 reset = 0;

        // Caso 1: Iniciar transmisión
        #10 begin_transmission = 1;
        #10 begin_transmission = 0;

        // Simular transmisión de bytes
        #20 tx_busy = 1; // UART ocupada
        #20 tx_busy = 0; // UART lista para el siguiente byte

        #30

        #20 tx_busy = 1; // UART ocupada
        #20 tx_busy = 0; // UART lista para el siguiente byte

        #30

        #20 tx_busy = 1; // UART ocupada
        #20 tx_busy = 0; // UART lista para el siguiente byte

        #30

        #20 tx_busy = 1; // UART ocupada
        #20 tx_busy = 0; // UART lista para el siguiente byte

        // Finalizar simulación
        #100 $finish;
    end



endmodule