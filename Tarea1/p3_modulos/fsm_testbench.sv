`timescale 1ns / 1ps
// Testbench para la FSM diseñada en la pregunta 3 de la tarea 1
module fsm_testbench();

logic clk, resetN, PB_status, IncPulse_out;


PB_FSM #(
    .N_INCREMENT_DELAY_CONTINUOUS    (7)
) u_PB_FSM (
    .clk                             (clk),
    .resetN                          (resetN),
    .PB_status                       (PB_status),
    .IncPulse_out                    (IncPulse_out)
);

always #1 clk = ~clk;

initial begin
    clk = 1'b0;
    resetN = 1'b0;
    PB_status = 1'b0;
    #5 resetN = 1'b1;
    #10
    
    //Pulsación menor a delay
    PB_status = 1'b1;
    #3 PB_status = 1'b0;
    #17

    // Pulsación mayor a delay
    PB_status = 1'b1;
    #20 PB_status = 1'b0;
    #20;

    // Pulsación del largo del delay
    PB_status = 1'b1;
    #14 PB_status = 1'b0;
    #20 $finish;

    // Pulsación de varios ciclos 
    PB_status = 1'b1;
    #100 PB_status = 1'b0;
    
    // Reiniciar con PB_status constante
    #20 PB_status = 1'b1;
    resetN = 1'b0;
    #10 resetN = 1'b1;

    // Fin de la simulación
    #50
    $finish;
end

endmodule
