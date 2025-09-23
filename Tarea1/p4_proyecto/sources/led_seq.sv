`timescale 1ns / 1ps
// Módulo que alterna una secuencia sencilla de LEDs
// Bastián Rivas

module led_seq(
    input  logic clk_1s, en,
    output logic [6:0] led_seq_out
    );

    always_comb begin
        if (en) begin
            case (clk_1s)
                1'b0: led_seq_out = 7'b0101010; 
                1'b1: led_seq_out = 7'b1010101; 
                default: led_seq_out = 7'b0000000; 
            endcase
        end else begin
            led_seq_out = 7'b0000000; // Todos apagados si no está habilitado
        end


    end
    
endmodule
