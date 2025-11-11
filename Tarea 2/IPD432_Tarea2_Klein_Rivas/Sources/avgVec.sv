`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/10/2025 05:17:15 PM
// Design Name: 
// Module Name: avgVec
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module avgVec(
    input logic [15:0]data_A,
    input logic [15:0]data_B,
    input logic enable,
    input logic clk,
    input logic reset,
    output logic [15:0]result
    );
    
    logic [15:0] avg_scalar;
    logic [1:0] sum;
    
    always_ff @(posedge clk) begin
        if(reset) result <= 16'h0;
        else if(enable) result <= avg_scalar;
        else result <= 16'h0;
    end
    
    always_comb begin
        sum = data_A[0] + data_B[0];
        if(sum[0]) avg_scalar = 16'h8000 + ((data_A + data_B) / 2);
        else avg_scalar = (data_A + data_B) / 2;
    end
endmodule
