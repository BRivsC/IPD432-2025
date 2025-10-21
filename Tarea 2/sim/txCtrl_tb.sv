`timescale 1ns / 1ps

module txCtrl_tb;

    // Señales para el DUT
    logic clk;
    logic reset;
    logic op_done;
    logic tx_busy;
    logic [5:0] enables;
    logic tx_start;
    logic tx_done;
    logic register_result32;
    logic send_b0, send_b1, send_b2, send_b3;

    // Instancia del DUT
    txCtrl #(
        .INTER_BYTE_DELAY(10), // Reducido para simulación rápida
        .WAIT_FOR_REGISTER_DELAY(5)
    ) dut (
        .clk(clk),
        .reset(reset),
        .op_done(op_done),
        .tx_busy(tx_busy),
        .enables(enables),
        .tx_start(tx_start),
        .tx_done(tx_done),
        .register_result32(register_result32),
        .send_b0(send_b0),
        .send_b1(send_b1),
        .send_b2(send_b2),
        .send_b3(send_b3)
    );

    // Generador de reloj
    always #5 clk = ~clk;

    // Testbench
    initial begin
        // Inicialización
        clk = 0;
        reset = 1;
        op_done = 0;
        tx_busy = 0;
        enables = 6'b000000;

        // Liberar reset
        #10 reset = 0;

        // Caso 1: Prueba para "dot" (enables[5])
        #10 op_done = 1;
        enables = 6'b100000; // Activar "dot"
        #10 op_done = 0;

        // Simular transmisión de bytes
        #20 tx_busy = 1; // Simular que el transmisor está ocupado
        #20 tx_busy = 0; // Simular que el transmisor está listo para el siguiente byte

        // Caso 2: Prueba para "sum" (enables[1])
        #110 op_done = 1;
        enables = 6'b000010; // Activar "sum"
        #10 op_done = 0;

        // Simular transmisión de bytes
        #20 tx_busy = 1;
        #20 tx_busy = 0;

        // Caso 3: Prueba para "man" (enables[4])
        #100 op_done = 1;
        enables = 6'b010000; // Activar "man"
        #10 op_done = 0;

        // Simular transmisión de bytes
        #20 tx_busy = 1;
        #20 tx_busy = 0;

        // Finalizar simulación
        #50 $finish;
    end

endmodule