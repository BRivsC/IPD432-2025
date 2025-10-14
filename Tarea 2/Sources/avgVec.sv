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
    
    always_ff @(posedge clk) begin
        if(reset) result <= 16'h0;
        else if(enable) result <= (data_A + data_B) / 2;
        else result <= 16'h0;
    end
endmodule
