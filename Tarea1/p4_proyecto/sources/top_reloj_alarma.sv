`timescale 1ns / 1ps
// Módulo top que instancia todos los elementos del reloj con alarma
// Incluye: Driver de displays de 7 segmentos
//          Conversor de formato 24h a AM/PM
//          Reloj principal
//          Módulo de alarma
//          Divisor de frecuencias a 1 segundo
//          Debouncers con tren de pulso
//          Una montonera de conexiones
//
//      in: BTNR (minutos), BTNL (horas), SW0 (AM/PM), SW1 (set alarma), 
//          CLK100MHZ, CPU_RESETN
//
//      out: [7:0] segments, DP, [3:0] AN, [6:0] LEDS_ALARMA, LED0 (led pm)

module top_reloj_alarma (
    input  logic        BTNR,
    input  logic        BTNL,
    input  logic        SW0,        // 0: 24h, 1: AM/PM
    input  logic        SW1,  // 0: normal, 1: set alarma
    input  logic        CLK100MHZ,
    input  logic        CPU_RESETN,
    output logic        CA, CB, CC, CD, CE, CF, CG, DP,
    output logic [7:0]  AN,     //  {AN7, AN6, AN5, AN4, AN3, AN2, AN1, AN0}
    output logic [6:0]  LEDS_ALARMA,    
    output logic        LED0          
);
    // Señales intermedias
    logic  add_hour_pulse, add_minute_pulse; // Pulsos debounceados de los botones
    logic  clk_1s;
    logic  rst;
    assign rst = ~CPU_RESETN;
    
    // logic [6:0]  segments,   //  {CA, CB, CC, CD, CE, CF, CG}
    //assign {CA, CB, CC, CD, CE, CF, CG} = segments;

    logic separador;
    assign separador = AN[5];

    assign DP = ~separador;    // DP para separar horas de minutos

    // Parámetros 
    localparam DEBOUNCER_DELAY_1S = 1_000_000;
    localparam HOLD_DELAY_500MS   = 500_000;
    localparam FREQ_DIV_COUNT_1S  = 1_000_000;  // Considera clk de 100MHz
    localparam MAX_BCD_SIZE       = 32;     
    localparam DRIVER_7SEG_MAX_COUNT = 3;   

    // Debouncers con tren de pulso
    T1_design1 #(
        .N_DEBOUNCER_DELAY               (DEBOUNCER_DELAY_1S), 
        .N_INCREMENT_DELAY_CONTINUOUS    (HOLD_DELAY_500MS)
    ) hour_btn_debouncer (
        .clk                             (CLK100MHZ),
        .resetN                          (CPU_RESETN),
        .PushButton                      (BTNL),
        .IncPulse_out                    (add_hour_pulse)
    );
    
    T1_design1 #(
        .N_DEBOUNCER_DELAY               (DEBOUNCER_DELAY_1S), 
        .N_INCREMENT_DELAY_CONTINUOUS    (HOLD_DELAY_500MS)
    ) minute_btn_debouncer (
        .clk                             (CLK100MHZ),
        .resetN                          (CPU_RESETN),
        .PushButton                      (BTNR),
        .IncPulse_out                    (add_minute_pulse)
    );

    // Divisor de frecuencia a 1 Hz
    freq_divider #(
        .COUNTER_MAX    (FREQ_DIV_COUNT_1S) //nro de cantos de subida hasta invertir clk_out
    ) freq_divider_1hz (
        .clk_in         (CLK100MHZ),
        .reset          (rst),
        .clk_out        (clk_1s)
    );

    // Reloj principal
    logic [23:0] current_time;  // Hora actual en BCD (24h)
                                // {HH:MM:SS}
    time_mem main_clk (
        .add_hour      (add_hour_pulse),
        .add_minute    (add_minute_pulse),
        .add_second    (clk_1s),
        .config_en     (~SW1),
        .clk           (CLK100MHZ),
        .rst           (rst),
        .h_tens        (current_time[23:20]),
        .h_units       (current_time[19:16]),
        .m_tens        (current_time[15:12]),
        .m_units       (current_time[11:8]),
        .s_tens        (current_time[7:4]),
        .s_units       (current_time[3:0])
    );

    // Módulo de alarma
    logic [23:0] alm_time;      // Hora de la alarma en BCD (24h)
    alarm_module alarm_clk (
        .clk                 (CLK100MHZ),
        .rst                 (rst),
        .clk_1s              (clk_1s),
        .add_hour_pulse      (add_hour_pulse),
        .add_minute_pulse    (add_minute_pulse),
        .config_en           (SW1),
        .current_time        (current_time),
        .alm_time            (alm_time),
        .led_seq_out         (LEDS_ALARMA)
    );

    // Alternar entre mostrar hora actual y hora de alarma
    logic [23:0] BCD_24h;       // Hora actual en BCD (24h)
    assign BCD_24h = SW1 ? alm_time : current_time;

    // Conversor de formato 24h a AM/PM
    logic [23:0] BCD_display;   // Hora a mostrar en BCD (puede ser 24h o AM/PM)
    
    display_format u_display_format (
        .toggle_ampm    (SW0),
        .BCD_in         (BCD_24h),
        .pm_flag        (LED0),
        .BCD_out        (BCD_display)
    );

    // Driver de displays de 7 segmentos
    // Incluye trucazo para usar los displays de la izquierda y mantener 
    // apagados los de la derecha.
    // El driver mantiene apagado un cierto display si recibe F
    driver_7_seg #(
        .N            (MAX_BCD_SIZE),
        .count_max    (DRIVER_7SEG_MAX_COUNT)
    ) u_driver_7_seg (
        .clock        (CLK100MHZ),
        .reset        (rst),
        .BCD_in       ({BCD_display,8'hFF}),
        .segments     ({CA, CB, CC, CD, CE, CF, CG} ),  
        .anodos       (AN)      // {AN7, AN6, AN5, AN4, AN3, AN2, AN1, AN0}
    );

endmodule