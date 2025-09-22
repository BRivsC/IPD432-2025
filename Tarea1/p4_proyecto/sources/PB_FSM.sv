// Módulo FSM de tipo Moore de la pregunta 3, tarea 1
//    in:   PB_status, estado de mantener pulsado un botón
// param:   N_DEBOUNCER_DELAY, nro de ciclos de reloj para que la pulsación se considere válida
//   out:   IncPulse_out, pulso de salida
// Bastián Rivas

// Module header:-----------------------------
module PB_FSM #(
    parameter N_INCREMENT_DELAY_CONTINUOUS = 5
)(
	input 	logic clk, resetN, PB_status,
	output 	logic IncPulse_out
);

logic rst;
assign rst = ~resetN;

//Declarations:------------------------------

//FSM states type:

enum logic [4:0] {S0, S1, S2, S3, S4} CurrentState, NextState;

//Timer-related declarations:
	
localparam DELAY_WIDTH = $clog2(N_INCREMENT_DELAY_CONTINUOUS);
logic [DELAY_WIDTH-1:0] delay_timer; 


//Part 3: Statements:---------------------------------------

//Timer :
always_ff @(posedge clk) begin
	if (rst) delay_timer <= 0;
	else if (CurrentState != NextState) delay_timer <= 0; //reset the timer when state changes
	else delay_timer <= delay_timer + 1;
end


 //FSM state register:
always_ff @(posedge clk)
	if (rst) CurrentState <= S0;
	else CurrentState <= NextState;

 //FSM combinational logic:
always_comb begin
    // Valores por defecto
    NextState = S0;
    IncPulse_out = 1'b0;

	case (CurrentState)
        // S0: PB sin pulsar
		S0: begin   
			if (PB_status) 
                NextState = S1;
            
		end
        
        // S1: PB pulsado, se prepara para enviar pulso 
		S1: begin
			if (~PB_status) 
                NextState = S2;
            
            else if (PB_status && (delay_timer >= N_INCREMENT_DELAY_CONTINUOUS-1)) 
                NextState = S3;
            
			else 
                NextState = S1;
            
        end
		
        // S2: PB soltado antes de completar timer, manda pulso único antes de volver a inicio
        S2: begin
            IncPulse_out = 1'b1;
            NextState = S0;
        end
    
        // S3: Mandar pulso único después de completar timer, ir a espera incondicionalmente
        S3: begin
            IncPulse_out = 1'b1;
            NextState = S4;
        end

        // S4: Esperar timer para mandar nuevo pulso, o volver a inicio sin mandar pulso si se suelta PB
        S4: begin
			if (~PB_status) 
                NextState = S0;
            
            else if (PB_status && (delay_timer >= N_INCREMENT_DELAY_CONTINUOUS-2)) // Acá se pierde un pulso al resetear timer 2 veces
                NextState = S3;
            
			else 
                NextState = S4;
            
        end

	endcase
end

endmodule
