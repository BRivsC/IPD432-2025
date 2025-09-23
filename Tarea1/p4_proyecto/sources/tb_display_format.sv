`timescale 1ns / 1ps
// Testbench para display_format.sv
// Prueba los casos de conversión entre formatos 24h y 12h

module tb_display_format;

    logic toggle_ampm;
    logic [23:0] BCD_in;
    logic pm_flag;
    logic [23:0] BCD_out;

    display_format dut (
        .toggle_ampm(toggle_ampm),
        .BCD_in(BCD_in),
        .pm_flag(pm_flag),
        .BCD_out(BCD_out)
    );


    initial begin
        // Caso 1: Mañana, no se convierte (ejemplo: 09:45:30)
        toggle_ampm = 1'b1;
        // 09:45:30 en BCD: h_tens=0, h_units=9, m_tens=4, m_units=5, s_tens=3, s_units=0
        BCD_in = {4'd0, 4'd9, 4'd4, 4'd5, 4'd3, 4'd0};
        #1;
        

        // Caso 2: Hora de la tarde, se convierte (ejemplo: 15:20:10)
        toggle_ampm = 1'b1;
        // 15:20:10 en BCD: h_tens=1, h_units=5, m_tens=2, m_units=0, s_tens=1, s_units=0
        BCD_in = {4'd1, 4'd5, 4'd2, 4'd0, 4'd1, 4'd0};
        #1;
        

        // Caso 3: Medianoche, 00:00:00, debe mostrar 12:00:00 AM
        toggle_ampm = 1'b1;
        // 00:00:00 en BCD: h_tens=0, h_units=0, m_tens=0, m_units=0, s_tens=0, s_units=0
        BCD_in = {4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0};
        #1;
        

        // Caso 4: Formato 24h, sin conversión (ejemplo: 21:59:59)
        toggle_ampm = 1'b0;
        // 21:59:59 en BCD: h_tens=2, h_units=1, m_tens=5, m_units=9, s_tens=5, s_units=9
        BCD_in = {4'd2, 4'd1, 4'd5, 4'd9, 4'd5, 4'd9};
        #1;
        
        // Casos problemáticos: 20-22, 12
        toggle_ampm = 1'b1;
        // 21:59:59 en BCD: h_tens=2, h_units=1, m_tens=5, m_units=9, s_tens=5, s_units=9
        #1 BCD_in = {4'd2, 4'd1, 4'd5, 4'd9, 4'd5, 4'd9};
        #1 BCD_in = {4'd2, 4'd2, 4'd5, 4'd9, 4'd5, 4'd9};
        #1 BCD_in = {4'd2, 4'd3, 4'd5, 4'd9, 4'd5, 4'd9};
        #1 BCD_in = {4'd0, 4'd0, 4'd5, 4'd9, 4'd5, 4'd9};
        #1 BCD_in = {4'd1, 4'd2, 4'd5, 4'd9, 4'd5, 4'd9};
        
        

        #1 $finish;
    end

endmodule