`timescale 1ns / 1ps
// Módulo que alterna una secuencia sencilla de LEDs
// Bastián Rivas

module led_seq(
    input  logic clk_1s, en,
    output logic [6:0] led_seq_out
);

    logic [6:0] pattern;
    logic state;

    always_ff @(posedge clk_1s or negedge en) begin
        if (!en) begin
            state   <= 1'b0;
            pattern <= 7'b0000000;
        end else begin
            state   <= ~state;
            pattern <= state ? 7'b1010101 : 7'b0101010;
        end
    end

    assign led_seq_out = en ? pattern : 7'b0000000;

endmodule