`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/10/2025 05:18:51 PM
// Design Name: 
// Module Name: dotProd
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


module dotProd(
    input logic [15:0]data_A,
    input logic [15:0]data_B,
    input logic enable,
    input logic ctrl,
    input logic clk,
    input logic reset,
    output logic [31:0]result
    );
    
    always_ff @(posedge clk) begin
        if(reset) result <= 32'b0;
        else if(enable)begin
            if(ctrl) result <= result + (data_A * data_B);
            else result <= result;
        end
        else result <= 32'b0;
    end
endmodule
