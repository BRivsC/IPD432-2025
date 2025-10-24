`timescale 1ns / 1ps
// Prueba física de transmisión de datos

module data_transmit_wrapper(
    input logic CLK100MHZ, CPU_RESETN, BTNC, 
    input logic [5:0] SW,
    
    output logic       UART_TX_USB,
    output logic [6:0] SEG,
    output logic [7:0] AN
    );

    logic [5:0] enables_in;
    assign enables_in = SW;

    logic [6:0] segments;
    assign segments = SEG;
    logic [7:0] anodes;
    assign anodes = AN;

data_transmit_test u_data_transmit_test (
        .CLK100MHZ      (CLK100MHZ),
        .CPU_RESETN     (CPU_RESETN),
        .BTNC           (BTNC),
        .SW             (enables_in),
        .UART_TX_USB    (UART_TX_USB),
        .SEG            (SEG),
        .AN             (AN)
    );

endmodule