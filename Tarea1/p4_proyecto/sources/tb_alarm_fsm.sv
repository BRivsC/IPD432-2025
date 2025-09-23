`timescale 1ns/1ps

module tb_alarm_fsm;

    // Señales de entrada
    logic clk, rst, add_hour_pulse, add_minute_pulse, config_en;
    logic [23:0] current_time, alm_time;

    // Señales de salida
    logic add_alm_hour, add_alm_minute, enable_seq;

    // Instancia del DUT
    alarm_fsm dut (
        .clk(clk),
        .rst(rst),
        .add_hour_pulse(add_hour_pulse),
        .add_minute_pulse(add_minute_pulse),
        .config_en(config_en),
        .current_time(current_time),
        .alm_time(alm_time),
        .add_alm_hour(add_alm_hour),
        .add_alm_minute(add_alm_minute),
        .enable_seq(enable_seq)
    );

    // Generador de clock
    always #5 clk = ~clk;

    // Test sequence
    initial begin
        // Inicialización
        clk = 0;
        rst = 1;
        add_hour_pulse = 0;
        add_minute_pulse = 0;
        config_en = 0;
        current_time = 24'h000000;
        alm_time = 24'h000001;  //  distinta para evitar gatillar alarma

        // Reset
        #12;
        rst = 0;

        // Espera en IDLE, sin coincidencia de hora
        #10;
        current_time = 24'h000001;
        alm_time = 24'h000002;
        #10;

        // Entra a configuración
        config_en = 1;
        #10;

        // Pulso para agregar hora
        add_hour_pulse = 1;
        #10;
        add_hour_pulse = 0;
        #10;

        // Pulso para agregar minuto
        add_minute_pulse = 1;
        #10;
        add_minute_pulse = 0;
        #10;

        // Salir de configuración
        config_en = 0;
        #10;

        // Coincidencia de hora: activar alarma
        current_time = 24'h0000A5;
        alm_time = 24'h0000A5;
        #10;

        // Mientras está activa la alarma
        #10;
        // Desactivar alarma con pulso de hora y cambiar la hora para no reactivar
        add_hour_pulse = 1;
        current_time = 24'h0000A6; 
        #10;
        add_hour_pulse = 0;

        #10;

        // Terminar simulación
        $finish;
    end

endmodule