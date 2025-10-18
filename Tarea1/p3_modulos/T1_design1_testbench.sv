`timescale 1ns / 1ps
// Testbench para el módulo top de la pregunta 3 de la tarea 1
module T1_design1_testbench();

logic clk, resetN, PushButton, IncPulse_out;

T1_design1 #(
    .N_DEBOUNCER_DELAY               (10),
    .N_INCREMENT_DELAY_CONTINUOUS    (5)
) u_T1_design1 (
    .clk                             (clk),
    .resetN                          (resetN),
    .PushButton                      (PushButton),
    .IncPulse_out                    (IncPulse_out)
);

always #1 clk = ~clk;

initial begin
    clk = 1'b0;
    resetN = 1'b0;
    PushButton = 1'b0;
    #5 resetN = 1'b1;
    #10

    // Pulsación corta 1
    PushButton = 1'b1;
    #3 PushButton = 1'b0;
    #17

    // Pulsación corta 2
    PushButton = 1'b1;
    #6 PushButton = 1'b0;
    #24

    // Pulsación larga 1
    PushButton = 1'b1;
    #20 PushButton = 1'b0;


    // Pulsación del largo del delay
    PushButton = 1'b1;
    #10 PushButton = 1'b0;
    #20

    // Pulsación más larga 
    PushButton = 1'b1;
    #100 PushButton = 1'b0;

    // Fin de la simulación
    #50
    $finish;
end

endmodule
