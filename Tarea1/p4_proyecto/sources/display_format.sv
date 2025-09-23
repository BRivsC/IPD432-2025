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
    logic [ 3:0] h_tens_24h, h_units_24h; 
    logic [15:0] mmss;  // Estos no se usan para mis fines malvados

    assign h_tens_24h   = BCD_in[23:20];
    assign h_units_24h  = BCD_in[19:16];
    assign mmss         = BCD_in[15: 0];

    // Resultados de restar (o no) las horas de la tarde. Pueden estar en 24H o am/pm
    logic [3:0] h_tens_out, h_units_out;    

    always_comb begin
        if (toggle_ampm) begin
            // Convertir por ser hora mayor a 13:00
            if(h_tens_24h >= 1 && h_units_24h >= 3) begin
                pm_flag = 1;
                h_tens_out = h_tens_24h - 1;
                h_units_out = h_units_24h - 2;
            end else 
            // Convertir 00:00 en 12:00 AM
            if (h_tens_24h == 0 && h_units_24h == 0) begin
                pm_flag = 0;
                h_tens_out = 1;
                h_units_out = 2;
            end
            else begin
            // Sigue con formato AM/PM pero no cambia al ser la mañana
                pm_flag = 0;
                h_tens_out = h_tens_24h;
                h_units_out = h_units_24h;
            end
        end else begin
            // Mantener formato 24H
            pm_flag = 0;
            h_tens_out = h_tens_24h;
            h_units_out = h_units_24h;
        end
    end

    assign BCD_out = {h_tens_out, h_units_out, mmss};
    
endmodule
