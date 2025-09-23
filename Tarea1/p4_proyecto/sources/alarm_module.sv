`timescale 1ns / 1ps
// Módulo que contiene todos lo relacionado a la alarma
// Tiene una FSM que controla las etapas de la alarma, un registro de la hora 
// y una secuencia sencilla para cuando se activada
// Bastián Rivas

module alarm_module (
    input  logic        clk, rst, clk_1s,        // Reloj y reset global
    input  logic        add_hour_pulse,          // Pulso para agregar hora a la alarma
    input  logic        add_minute_pulse,        // Pulso para agregar minuto a la alarma
    input  logic        config_en,               // Habilitador de modo configuración
    input  logic [23:0] current_time,            // Hora actual del reloj principal
    output logic [23:0] alm_time,                // Hora de la alarma
    output logic [6:0]  led_seq_out              // Secuencia de LEDs cuando se activa la alarma
    );

    // Señales internas
    logic add_alm_hour, add_alm_minute, enable_seq;


    alarm_fsm u_alarm_fsm (
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

    // Separación de dígitos de la alarma
    logic [3:0] alm_h_tens, alm_h_units, alm_m_tens, alm_m_units, alm_s_tens, alm_s_units;
    assign alm_time = {alm_h_tens, alm_h_units, alm_m_tens, alm_m_units, alm_s_tens, alm_s_units};
    
    time_mem u_time_mem (
        .add_hour      (add_alm_hour),
        .add_minute    (add_alm_minute),
        .add_second    (1'b0),
        .config_en     (config_en),
        .clk           (clk),
        .rst           (rst),
        .h_tens        (alm_h_tens),
        .h_units       (alm_h_units),
        .m_tens        (alm_m_tens),
        .m_units       (alm_m_units),
        .s_tens        (alm_s_tens),
        .s_units       (alm_s_units)
    );
    


    led_seq led_seq (
        .clk_1s(clk_1s),
        .en(enable_seq),
        .led_seq_out(led_seq_out)
    );

    
endmodule