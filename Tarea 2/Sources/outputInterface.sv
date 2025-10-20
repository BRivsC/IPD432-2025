`timescale 1ns / 1ps

module outputInterface(
    input logic clk, reset, load_b0, load_b1, load_b2, load_b3, register_result32,
    input logic [31:0] result_data,
    output logic [7:0] tx_data,
    output logic [31:0] bcd_out,

    );
    
    logic [7:0] byte_0, byte_1, byte_2, byte_3;

    // Registros para los 32 bits de datos

    // Byte 0
    always_ff @(posedge clk) begin
		if (reset) begin
			byte_0 <= 0;
		end else if (load_b0) begin
			byte_0 <= rx_data;
		end else begin
			byte_0 <= byte_0;
		end
	end

    // Byte 1
    always_ff @(posedge clk) begin
		if (reset) begin
			byte_1 <= 0;
		end else if (load_b1) begin
			byte_1 <= rx_data;
		end else begin
			byte_1 <= byte_1;
		end
	end

    // Byte 2
    always_ff @(posedge clk) begin
		if (reset) begin
			byte_2 <= 0;
		end else if (load_b2) begin
			byte_2 <= rx_data;
		end else begin
			byte_2 <= byte_2;
		end
	end

    // Byte 3
    always_ff @(posedge clk) begin
		if (reset) begin
			byte_3 <= 0;
		end else if (load_b3) begin
			byte_3 <= rx_data;
		end else begin
			byte_3 <= byte_3;
		end
	end

    logic [31:0] data_32_reg;
    assign data_32_reg = {byte_3, byte_2, byte_1, byte_0};

    


    
endmodule

