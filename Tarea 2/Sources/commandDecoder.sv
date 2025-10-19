`timescale 1ns / 1ps

module commandDecoder
(
	input 	logic clk, reset, write_done, rx_ready, op_done, bram_info_in,
	//input 	logic [7:0] rx_data, 
	input 	logic [2:0] op_code, 
	output 	logic bram_sel, 
	output 	logic [6:0] command_out );
// Codificación one-hot de comandos
// Orden: Write, Read, Sum, Avg, Euc, Man, Dot

// Nota: op_code y bram_info vienen del byte recibido por rx_data
// Formato: [bram_sel(1 bit)][unused(4 bits)][op_code(3 bits)]

 //Internal signals:-------------------------
logic en_write, en_read, en_sum, en_avg, en_euc, en_man, en_dot;

 //Declarations:------------------------------

 //FSM states type:
enum logic [12:0] {WAIT, STORE, DECODE, WRITE_A, WRITE_B, READ_A, READ_B, SUM, AVG, EUC, MAN, DOT} CurrentState, NextState;

 //Statements:--------------------------------

 //FSM state register:
 always_ff @(posedge clk)
	if (reset) CurrentState <= WAIT;
	else CurrentState <= NextState;

assign command_out = {en_write, en_read, en_sum, en_avg, en_euc, en_man, en_dot};

 //FSM combinational logic:
 always_comb begin
	NextState = WAIT;  //Optional default state assigment
	en_write = 0; 
	en_read  = 0; 
	en_sum   = 0; 
	en_avg   = 0; 
	en_euc   = 0;
	en_man   = 0;
	en_dot   = 0;
	bram_sel = 0;

	case (CurrentState)
		WAIT: begin
			if (rx_ready) NextState = DECODE;
			else NextState = WAIT;
		end

		DECODE: begin
			//command_mem = rx_data;
			case (op_code)
				3'b001: begin // Write2dev
					en_write = 1; 
					bram_sel = bram_info_in; // 0 para A, 1 para B. Este va hacia writeCtrl
					//NextState = WRITE; 
				end
				3'b010: begin // ReadVect
					en_read  = 1; 
					//NextState = READ;  
				end
				3'b011: begin // SumVect
					en_sum   = 1; 
					//NextState = SUM;     
				end
				3'b100: begin // AvgVect
					en_avg   = 1; 
					//NextState = AVG;     
				end
				3'b101: begin // EucDist
					en_euc   = 1; 
					//NextState = EUC;     
				end
				3'b110: begin // ManDist
					en_man   = 1; 
					//NextState = MAN;     
				end
				3'b111: begin // DotProd
					en_dot   = 1;
					//NextState = DOT;
				end
				default: begin
					NextState = WAIT;
				end
			endcase

            if (op_done||write_done) NextState = WAIT;  
            else NextState = DECODE;
		end

		default: NextState = WAIT;


	endcase

	
 end
endmodule
