`timescale 1ns/1ps

module tb_full_time_mem();
    logic clk;
    logic rst;
    logic add_second;
    logic add_hour;
    logic add_minute;
    logic config_en;
    logic [3:0] s_units, s_tens, h_tens, h_units, m_tens, m_units;

    time_mem DUT (
        .add_hour      (add_hour),
        .add_minute    (add_minute),   
        .add_second    (add_second),
        .config_en     (config_en),
        .clk           (clk),
        .rst           (rst),
        .h_tens        (h_tens),
        .h_units       (h_units),
        .m_tens        (m_tens),
        .m_units       (m_units),
        .s_tens        (s_tens),
        .s_units       (s_units)
    );
    

    always #5 clk = ~clk;

    always #10 add_second = ~add_second; // Agregar segundos a cada rato
    //always #5 add_second = ~add_second; // Agregar segundos a cada rato

    

    initial begin
        clk = 0;
        rst = 1;
        add_second = 0;
        add_hour   = 0;
        add_minute = 0;


        #12;
        rst = 0;
                
        // Testeo de la medianoche
        h_tens  = 'd2;
        h_units = 'd3;
        m_tens  = 'd5;
        m_units = 'd9;
        s_tens  = 'd4;
        s_units = 'd0;

        #100 

        // Probar configuración de minutos y horas
        //add_minute = 1;
        //#10 add_minute = 0;
//
        //#10 config_en = 1;
        //add_minute = 1;
        //#10 add_minute = 0;

        #1000

        $finish;
    end

endmodule
