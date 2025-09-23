`timescale 1ns / 1ps
// Módulo que calcula el formato AM/PM para las horas.
// Permite escoger formato 24H o AM/PM en base a un switch
// Hay una condición de carrera al trabajar solamente con las horas, pero dada
// la aplicación donde se usa, se decide ignorar
//  in: toggle_ampm, [23:0] BCD_in,
// out: [23:0] BCD_out
// Ojo: Tuve que separar por dígitos porque estoy trabajando con BCD en lugar de
//      binario puro
// Bastián Rivas


module display_format(
    input  logic toggle_ampm, 
    input  logic [23:0] BCD_in,
    output logic pm_flag,
    output logic [23:0] BCD_out
    );
     // Separar por dígitos por usar BCD
    logic [3:0] h_tens_24h, h_units_24h;
    logic [15:0] mmss;

    assign h_tens_24h  = BCD_in[23:20];
    assign h_units_24h = BCD_in[19:16];
    assign mmss        = BCD_in[15:0];

    logic [3:0] h_tens_out, h_units_out;

    always_comb begin
        if (toggle_ampm) begin
            // 00:00 -> 12:00 AM
            if (h_tens_24h == 4'd0 && h_units_24h == 4'd0) begin
                h_tens_out = 4'd1;
                h_units_out = 4'd2;
                pm_flag = 1'b0;
            end
            // 01:00 - 11:59 AM
            else if (h_tens_24h == 4'd0 || (h_tens_24h == 4'd1 && h_units_24h <= 4'd1)) begin
                h_tens_out = h_tens_24h;
                h_units_out = h_units_24h;
                pm_flag = 1'b0;
            end
            // 12:00 PM
            else if (h_tens_24h == 4'd1 && h_units_24h == 4'd2) begin
                h_tens_out = 4'd1;
                h_units_out = 4'd2;
                pm_flag = 1'b1;
            end
            // 13:00 - 19:59 PM (h_tens_24h == 1, h_units_24h 3..9)
            else if (h_tens_24h == 4'd1 && h_units_24h >= 4'd3) begin
                h_tens_out = 4'd0;
                h_units_out = h_units_24h - 4'd2;
                pm_flag = 1'b1;
            end
            // 20:00 - 23:59 PM (h_tens_24h == 2, h_units_24h 0..3)
            else if (h_tens_24h == 4'd2 && h_units_24h < 4'd2) begin
                h_tens_out = 4'd0;
                h_units_out = h_units_24h + 4'd8; // 20-12=8, 21-12=9
                pm_flag = 1'b1;
            end
            else if (h_tens_24h == 4'd2 && h_units_24h >= 4'd2) begin
                h_tens_out = h_tens_24h - 4'd1;
                h_units_out = h_units_24h - 4'd2; // 22-12=10, 23-12=11
                pm_flag = 1'b1;
            end
            else begin
                // Default: mostrar igual
                h_tens_out = h_tens_24h;
                h_units_out = h_units_24h;
                pm_flag = 1'b0;
            end
        end else begin
            // Formato 24h
            h_tens_out = h_tens_24h;
            h_units_out = h_units_24h;
            pm_flag = 1'b0;
        end
    end

    assign BCD_out = {h_tens_out, h_units_out, mmss};

endmodule