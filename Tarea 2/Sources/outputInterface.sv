`timescale 1ns / 1ps

module outputInterface(
    input logic clk, reset, send_b0, send_b1, send_b2, send_b3, register_result32,
    input logic [31:0] result_data,
    output logic [7:0] tx_data,
    output logic [31:0] bcd_out

    );
    
    logic [7:0] byte_0, byte_1, byte_2, byte_3;

    // Registros para los 32 bits de datos

    // Byte 0
    always_ff @(posedge clk) begin
		if (reset) begin
			byte_0 <= 0;
		end else if (register_result32) begin
			byte_0 <= result_data[7:0];
		end else begin
			byte_0 <= byte_0;
		end
	end

    // Byte 1
    always_ff @(posedge clk) begin
		if (reset) begin
			byte_1 <= 0;
		end else if (register_result32) begin
			byte_1 <= result_data[15:8];
		end else begin
			byte_1 <= byte_1;
		end
	end

    // Byte 2
    always_ff @(posedge clk) begin
		if (reset) begin
			byte_2 <= 0;
		end else if (register_result32) begin
			byte_2 <= result_data[23:16];
		end else begin
			byte_2 <= byte_2;
		end
	end

    // Byte 3
    always_ff @(posedge clk) begin
		if (reset) begin
			byte_3 <= 0;
		end else if (register_result32) begin
			byte_3 <= result_data[31:24];
		end else begin
			byte_3 <= byte_3;
		end
	end

    always_comb begin
        if (send_b0) begin
            tx_data = byte_0;
        end else if (send_b1) begin
            tx_data = byte_1;
        end else if (send_b2) begin
            tx_data = byte_2;
        end else if (send_b3) begin
            tx_data = byte_3;
        end else begin
            tx_data = 8'b0;
        end
    end

    logic [31:0] data_32_reg;
    assign data_32_reg = {byte_3, byte_2, byte_1, byte_0};

    unsigned_to_bcd u_unsigned_to_bcd (
    .clk        (clk),
    .reset      (reset),
    .trigger    (1),
    .in         (data_32_reg),
    .idle       (),
    .bcd        (bcd_out)
    );


    
endmodule

