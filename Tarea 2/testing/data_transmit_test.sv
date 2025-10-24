`timescale 1ns / 1ps
// Prueba física de transmisión de datos

module data_transmit_test(
    input logic CLK100MHZ, CPU_RESETN, BTNC, 
    input logic [5:0] SW,
    
    output logic       UART_TX_USB,
    output logic [6:0] SEG,
    output logic [7:0] AN
    );
    logic reset, begin_transmission;
    assign reset = ~CPU_RESETN;

    PB_Debouncer #(
        .DELAY                (100_000)
    ) btnc_debouncer (
        .clk                  (CLK100MHZ),
        .rst                  (reset),
        .PB                   (BTNC),
        .PB_pressed_status    (),
        .PB_pressed_pulse     (begin_transmission),
        .PB_released_pulse    ()
    );
    logic tx_start, tx_busy, tx_sent;
    logic [7:0] tx_data;
    outputInterface u_outputInterface (
        .clk                        (CLK100MHZ),
        .reset                      (reset),
        .begin_transmission         (begin_transmission),
        .tx_busy                    (tx_busy),
        .enables_in                 (SW),
        .result_data                (32'd12345678),
        .tx_start                   (tx_start),
        .tx_sent                    (tx_sent),
        .segments                   (SEG),
        .tx_data                    (tx_data),
        .AN                         (AN)
    );



    uart_basic #(
        .CLK_FREQUENCY    (100000000),
        .BAUD_RATE        (115200)
    ) u_uart_basic (
        .clk              (CLK100MHZ),
        .reset            (reset),
        .rx               (UART_RX_USB),
        .rx_data          (),
        .rx_ready         (),
        .tx               (UART_TX_USB),
        .tx_start         (tx_start),
        .tx_data          (tx_data),
        .tx_busy          (tx_busy)
    );
endmodule

