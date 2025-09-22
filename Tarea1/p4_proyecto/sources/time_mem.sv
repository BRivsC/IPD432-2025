`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.09.2025 02:04:17
// Design Name: alarm clock
// Module Name: time_mem
// Project Name: p4_proyecto
// Target Devices: 
// Tool Versions: 
// Description: Contador de tiempo en formato HH:MM:SS. Va de 00:00:00 a 23:59:59.
//              Controla cada dígito en formato BCD y asegura que las horas no pasen de 23 y
//              los minutos ni los segundos de 59.
//              Permite también configurar la hora con 3 inputs.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module time_mem(
    input   logic add_hour, add_minute, add_second, config_en, clk, rst,
    output  logic [3:0] h_tens, h_units, m_tens, m_units, s_tens, s_units
    );
    // El reloj se implementa como una serie de contadores que llegan hasta un cierto valor límite.
    // Al alcanzar ese valor, mandan un bit al siguiente dígito más significativo y se auto resetean
    localparam COUNTER_BITS = 4;    //  Bits usados por los contadores. Como cuentan a lo mucho hasta 9, uso 4 bits

    // rst tras superar 23:59:59
    logic midnight_rst;
    
    // Permitir sumar horas/minutos si se pulsa botón mientras se está en el modo correcto (normal para reloj, alarma para alarma) 
    logic allow_hour_cfg;
    assign allow_hour_cfg = add_hour && config_en;

    logic allow_minute_cfg;
    assign allow_minute_cfg = add_minute && config_en;


    // Contadores de segundos
    logic second_unit_done;
    nbit_counter_enable #(
        .N             (COUNTER_BITS),
        .MAX_COUNT     (9)
    ) second_unit_counter (
        .clk           (clk),
        .rst           (rst||second_unit_done||midnight_rst),
        //.rst           (rst||midnight_rst),
        .en            (add_second),
        .count_done    (second_unit_done),
        .counter       (s_units)
    );

    logic second_tens_done;
    nbit_counter_enable #(
        .N             (COUNTER_BITS),
        .MAX_COUNT     (5)
    ) second_tens_counter (
        .clk           (clk),
        .rst           (rst||second_tens_done||midnight_rst),
        .en            (second_unit_done),
        .count_done    (second_tens_done),
        .counter       (s_tens)
    );


    // Contadores de minutos
    logic minute_unit_done;
    nbit_counter_enable #(
        .N             (COUNTER_BITS),
        .MAX_COUNT     (9)
    ) minute_units_counter (
        .clk           (clk),
        .rst           (rst||minute_unit_done||midnight_rst),
        .en            (second_tens_done||allow_minute_cfg),
        .count_done    (minute_unit_done),
        .counter       (m_units)
    );


    logic minute_tens_done;
    nbit_counter_enable #(
        .N             (COUNTER_BITS),
        .MAX_COUNT     (5)
    ) minute_tens_counter (
        .clk           (clk),
        .rst           (rst||minute_tens_done||midnight_rst),
        .en            (minute_unit_done),
        .count_done    (minute_tens_done),
        .counter       (m_tens)
    );


    // Contadores de horas
    logic hour_unit_done;
    nbit_counter_enable #(
        .N             (COUNTER_BITS),
        .MAX_COUNT     (9)
    ) hour_units_counter (
        .clk           (clk),
        .rst           (rst||hour_unit_done||midnight_rst),
        .en            (minute_tens_done||allow_hour_cfg),
        .count_done    (hour_unit_done),
        .counter       (h_units)
    );


    logic hour_tens_done;
    nbit_counter_enable #(
        .N             (COUNTER_BITS),
        .MAX_COUNT     (2)
    ) hour_tens_counter (
        .clk           (clk),
        .rst           (rst||hour_tens_done||midnight_rst),
        .en            (hour_unit_done),
        .count_done    (hour_tens_done),
        .counter       (h_tens)
    );

    // Overflow de la medianoche
    // Revisa si las horas están en 23 y se quiere incrementar a 24. Lleva todo el reloj a 00:00:00 con un reset 
    // Evaluar si es posible ver todos los dígitos!
    always_comb begin
        if (h_tens == 2 && h_units == 3 && minute_tens_done) begin
            midnight_rst = 1;
        end else begin
            midnight_rst = 0;
        end
    end


endmodule

// Módulo auxiliar: contador con enable y bit al terminar
// MAX_COUNT representa el número al que llegará antes de indicar que terminó
module nbit_counter_enable #(parameter N = 32, MAX_COUNT = 9)(
    input  logic clk, rst, en,
    output logic count_done,
    output logic [N-1:0] counter
);
    always_ff @(posedge clk) begin
        if (rst) begin
            counter     <= 'd0;
            count_done  <= 'd0;
        end else if (en) begin
            if (counter == MAX_COUNT) begin
                counter     <= 'd0;
                count_done  <= 'd1;
            end else begin
                counter     <= counter + 1;
                count_done  <= 'd0;
            end
        end else begin
            count_done  <= 'd0;
        end
    end
endmodule