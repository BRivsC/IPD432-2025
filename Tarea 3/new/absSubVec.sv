`timescale 1ns/1ps
// Valor absoluto de resta entre 2 vectores
// Acá el valor absoluto se obtiene por siempre restarle el menor al mayor
module absSubVec #(
    parameter IWIDTH = 10,      
    parameter NINPUTS = 8       
)(
    input  logic clk,
    input  logic [IWIDTH-1:0] data_A [NINPUTS-1:0], 
    input  logic [IWIDTH-1:0] data_B [NINPUTS-1:0], 
    output logic [IWIDTH-1:0] out [NINPUTS-1:0]
);
    genvar i;
    generate
        for (i=0; i < NINPUTS; i++) begin
            always_ff @(posedge clk) begin
                if (data_A[i] > data_B[i])
                    out[i] <= data_A[i] - data_B[i];
                else
                    out[i] <= data_B[i] - data_A[i];
            end
        end
    endgenerate
endmodule
