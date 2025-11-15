`timescale 1ns/1ps
// División por 2 de elementos de un vector
// Dividir por 2 sería un shift a la derecha
module divBy2Vec #(
    parameter IWIDTH = 10,      
    parameter NINPUTS = 8       
)(
    input  logic clk,
    input  logic [IWIDTH-1:0] data [NINPUTS-1:0], 
    output logic [IWIDTH - 1:0] out [NINPUTS-1:0]
);
    genvar i;
    generate
        for (i=0; i < NINPUTS - 1; i++) begin
            always_ff @(posedge clk) begin
                for (int i = 0; i < NINPUTS; i++)
                    out[i] <= data[i] >> 1;
            end
        end
    endgenerate
endmodule