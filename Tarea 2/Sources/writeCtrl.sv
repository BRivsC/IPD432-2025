`timescale 1ns / 1ps

module writeCtrl(
    input logic clk, reset, rx_ready, en, bram_sel,
    input logic [7:0]rx_data,
    output logic write_done, inc, wea_a, wea_b,
    output logic [9:0] dout

    );
    
    
    enum logic [6:0] {IDLE, WAIT_LSB, STORE_LSB, WAIT_MSB, STORE_MSB, WRITE_BRAM, WRITE_DONE} state, next_state;
    always_ff @(posedge clk) begin
        if(reset)
            state <= IDLE;
        else
            state <= next_state;
    end
    
    logic update_bram_sel, bram_sel_mem, load_lsb, load_msb;
    //logic [9:0] dout_reg;
    logic [7:0] data_lsb;
    logic [1:0] data_msb;
    //assign data_msb = rx_data[1:0];
    //assign data_lsb = rx_data[7:0];
    
    always_comb begin
        next_state = state;

        // Default control signals
        load_lsb = 0;
        load_msb = 0;
        update_bram_sel = 0;
        
        // Default outputs
        dout = 0;
        write_done = 0;
        inc = 0;
        wea_a = 0;
        wea_b = 0;

        case(state)
            IDLE: begin
                if(en) begin
                    update_bram_sel = 1;    //  Actualizar apenas se reciba el enable
                    next_state = WAIT_LSB;
                end else
                    next_state = IDLE;
            end 

            WAIT_LSB: begin
                if(rx_ready)
                    next_state = STORE_LSB;
            end

            STORE_LSB: begin
                load_lsb = 1;
                next_state = WAIT_MSB;
            end

            WAIT_MSB: begin
                if(rx_ready)
                    next_state = STORE_MSB;
            end

            STORE_MSB: begin
                load_msb = 1;
                next_state = WRITE_BRAM;
            end

            WRITE_BRAM: begin
                //dout = dout_reg;
                dout = {data_msb, data_lsb};
                wea_a = ~bram_sel_mem; //  Escribir en BRAM A si bram_sel_mem es 0
                wea_b = bram_sel_mem;  //  Escribir en BRAM B si bram_sel_mem es 1
                next_state = WRITE_DONE;
            end

            WRITE_DONE: begin
                write_done = 1;
                inc = 1;
                next_state = IDLE;
            end

            default : next_state = IDLE;
        endcase
    end
    
    // Registros para los 10 bits de datos
    // 8 menos significativos:
    always_ff @(posedge clk) begin
		if (reset) begin
			data_lsb <= 0;
		end else if (load_lsb) begin
			data_lsb <= rx_data;
		end else begin
			data_lsb <= data_lsb;
		end
	end
    // 2 más significativos
    always_ff @(posedge clk) begin
		if (reset) begin
			data_msb <= 0;
		end else if (load_msb) begin
			data_msb <= rx_data[1:0];
		end else begin
			data_msb <= data_msb;
		end
	end

	//always_ff @(posedge clk) begin
	//	if (reset) begin
	//		dout_reg <= 0;
	//	end else if (load_lsb) begin
	//		dout_reg[7:0] <= data_lsb;
	//	end else if (load_msb) begin
	//		dout_reg[9:8] <= data_msb;
	//	end else begin
	//		dout_reg <= dout_reg;
	//	end
	//end
    
    // Registro para mantener la BRAM a escribir
    
    always_ff @(posedge clk) begin
        if (reset) begin
            bram_sel_mem <= 0;
        end else if (update_bram_sel) begin
            bram_sel_mem <= bram_sel;
        end else begin
            bram_sel_mem <= bram_sel_mem;
        end
    end

    
endmodule

