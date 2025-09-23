`timescale 1ns / 1ps
// Módulo FSM que controla el comportamiento de la alarma. 
// Tiene un modo en el que espera a que la hora definida coincida con la actual,
// un modo de configuración, agregar minutos, horas, y gatillar una secuencia de 
// LEDs para la alarma.
//
//  in: clk, rst, add_hour_pulse, add_minute_pulse, config_en, current_time,
//		alm_time
// out: add_alm_hour, add_alm_minute, enable_seq
// Bastián Rivas

// Module header:-----------------------------
module alarm_fsm (
	input 	logic clk, rst, add_hour_pulse, add_minute_pulse, config_en,
	input 	logic [23:0] current_time, alm_time,	// Ojo: current viene del reloj ppal y alm viene de la memoria de la alarma
	output 	logic add_alm_hour, add_alm_minute, enable_seq
	);

 //Declarations:------------------------------

 //FSM states type:
enum logic [5:0] {ALM_IDLE, ALM_SET, ALM_ADD_MIN, ALM_ADD_HR, ALM_ACTIVE} CurrentState, NextState;

 //Statements:--------------------------------

 //FSM state register:
always_ff @(posedge clk) begin
	if (rst) CurrentState <= ALM_IDLE;
	else CurrentState <= NextState;
end

 //FSM combinational logic:
always_comb begin
	NextState = ALM_IDLE;  //Optional default state assigment
	add_alm_hour = 0;
	add_alm_minute = 0;
	enable_seq = 0;

	case (CurrentState)
	// Esperar a que la hora coincida o se entre en config
		ALM_IDLE: begin
			if (config_en == 1) NextState = ALM_SET;
			else if (current_time == alm_time) NextState = ALM_ACTIVE;
			else NextState = ALM_IDLE;
		end
	
	// Modo configuración, esperar a que se agregue hora o minuto
		ALM_SET: begin
			if (add_hour_pulse) NextState = ALM_ADD_HR;
			else if (add_minute_pulse) NextState = ALM_ADD_MIN;
			else if (config_en == 0) NextState = ALM_IDLE;
			else NextState = ALM_SET;
		end

	// Agregar hora a la alarma
		ALM_ADD_HR: begin
			add_alm_hour = 1;
			NextState = ALM_SET;
		end
		

	// Agregar minuto a la alarma
		ALM_ADD_MIN: begin
			add_alm_minute = 1;
			NextState = ALM_SET;
		end
		
	// Alarma activada hasta que se reciba cualquier input
		ALM_ACTIVE: begin
			enable_seq = 1;
			// if (add_hour_pulse == 1 || add_minute_pulse == 1) NextState = ALM_IDLE;
			if (config_en == 1) NextState = ALM_IDLE;
			else NextState = ALM_ACTIVE;
		end

		
		default: NextState = ALM_IDLE;

	endcase
end

endmodule
