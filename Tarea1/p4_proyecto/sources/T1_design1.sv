// Módulo top pregunta 3 tarea 1
// Incluye un debouncer y una máquina de estados PB_FSM de tipo Moore
module T1_design1 #(
    parameter N_DEBOUNCER_DELAY = 10,
    parameter N_INCREMENT_DELAY_CONTINUOUS = 5
)(
    input   logic   clk,
    input   logic   resetN,
    input   logic   PushButton,
    output  logic   IncPulse_out
);

logic rst;
assign rst = ~resetN;
logic PB_status; 
PB_Debouncer_FSM #(
    .DELAY                (N_DEBOUNCER_DELAY)   // Number of clock pulses to check stable button pressing
) PB_Debouncer (
    .clk                  (clk), // base clock
	.rst                  (rst), // global reset
	.PB                   (PushButton),  // raw asynchronous input from mechanical PB         
	
    .PB_pressed_status    (PB_status),  // clean and synchronized pulse for button pressed
	.PB_pressed_pulse     (),   // high if button is pressed
    .PB_released_pulse    ()    // clean and synchronized pulse for button released
);


PB_FSM #(
    .N_INCREMENT_DELAY_CONTINUOUS    (N_INCREMENT_DELAY_CONTINUOUS)
) u_PB_FSM (
    .clk                             (clk),
    .resetN                          (resetN),
    .PB_status                       (PB_status),
    .IncPulse_out                    (IncPulse_out)
);


endmodule