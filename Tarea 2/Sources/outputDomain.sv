`timescale 1ns / 1ps
// Módulo de interfaz de salida con memorias, controlador de transmisión, y driver de 7 segmentos

module outputDomain(
    input logic clk, reset, begin_transmission, 
    input logic [5:0] enables_in,
    input logic [31:0] result_data,
    
    output logic       tx_start, tx_busy, tx_sent,
    output logic       CA, CB, CC, CD, CE, CF, CG,
    output logic [7:0] tx_data,
    output logic [7:0] AN
    );

    logic tx_start, register_result32, send_b0, send_b1, send_b2, send_b3;
    logic [7:0] dout;

    logic [5:0] enables;
    assign enables = enables_in;
    
    logic [31:0] result_data_in;
    assign result_data_in = result_data;
    

    txCtrl #(
        .INTER_BYTE_DELAY           (1000000),// ciclos de reloj de espera entre el envio de 2 bytes consecutivos
    	    // tiempo de espera para iniciar la transmision luego de registrar el dato a enviar
        .WAIT_FOR_REGISTER_DELAY    (100)
    ) u_txCtrl (
        .clk                        (clk),
        .reset                      (reset),
        .begin_transmission         (begin_transmission),
        .tx_busy                    (tx_busy),
        .enables                    (enables),// Formato: {dot, man, euc, avg, sum, read} desde CtrllUnit
        .tx_start                   (tx_start),
        .register_result32          (register_result32),
        .send_b0                    (send_b0),
        .send_b1                    (send_b1),
        .send_b2                    (send_b2),
        .send_b3                    (send_b3),
        .dout                       (dout)
    );

    logic [31:0] bcd_data;
    outputInterface u_outputInterface (
        .clk                  (clk),
        .reset                (reset),
        .send_b0              (send_b0),
        .send_b1              (send_b1),
        .send_b2              (send_b2),
        .send_b3              (send_b3),
        .register_result32    (register_result32),
        .result_data          (result_data_in),
        .tx_data              (tx_data),
        .bcd_out              (bcd_data)
    );

    logic enable_display;
    assign enable_display = enables[3]||enables[4]||enables[5]; //activar display solo para avg, euclidea o manhattan

    driver_7_seg_en #(
        .N                    (32),
        .count_max            (3),
        .clk_divider_count    (200_000)
    ) u_driver_7_seg_en (
        .clock                (clk),
        .reset                (reset),
        .enable               (enable_display),
        .BCD_in               (bcd_data),
        .segments             ({CA, CB, CC, CD, CE, CF, CG}),
        .anodos               (AN)// {AN7, AN6, AN5, AN4, AN3, AN2, AN1, AN0}
    );


endmodule

