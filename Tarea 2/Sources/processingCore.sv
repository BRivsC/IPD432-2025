`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/11/2025 11:28:27 PM
// Design Name: 
// Module Name: processingCore
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


module processingCore #(parameter NUM_ELEMENTOS = 1024)(
    input [15:0] data_A,
    input [15:0] data_B,
    input [5:0] enables,
    input ctrl,
    input clk,
    input reset,
    output logic [31:0] result,
    output logic op_done
    );
    
    logic [15:0]result_read;
    logic [15:0]result_sum;
    logic [15:0]result_avg;
    logic [15:0]result_euc;
    logic [23:0]result_man;
    logic [31:0]result_dot;
    
    always_comb begin
        if(enables[0]) result = {16'h00 , result_read};
        else if(enables[1]) result = {16'h00 , result_sum};
        else if(enables[2]) result = {16'h00 , result_avg};
        else if(enables[3]) result = {16'h00 , result_euc};
        else if(enables[4]) result = {8'h0 , result_man};
        else if(enables[5]) result = result_dot;
        else result = 32'h0000;
    end
         
    
    readVec read(
    .data_A(data_A),
    .data_B(data_B),
    .enable(enables[0]),
    .ctrl(ctrl),
    .clk(clk),
    .reset(reset),
    .result(result_read));

    sumVec sum(
    .data_A(data_A),
    .data_B(data_B),
    .enable(enables[1]),
    .clk(clk),
    .reset(reset),
    .result(result_sum)
    );

    avgVec avgV(
    .data_A(data_A),
    .data_B(data_B),
    .enable(enables[2]),
    .clk(clk),
    .reset(reset),
    .result(result_avg)
    );
    
    eucDist #(.NO_ELEMENTOS(NUM_ELEMENTOS))euc(
    .data_A(data_A),
    .data_B(data_B),
    .enable(enables[3]),
    .ctrl(ctrl),
    .clk(clk),
    .reset(reset),
    .op_done(op_done),
    .result(result_euc)
    );

    manDist man(
    .data_A(data_A),
    .data_B(data_B),
    .enable(enables[4]),
    .ctrl(ctrl),
    .clk(clk),
    .reset(reset),
    .result(result_man)
    );
    
    dotProd dot(
    .data_A(data_A),
    .data_B(data_B),
    .enable(enables[5]),
    .ctrl(ctrl),
    .clk(clk),
    .reset(reset),
    .result(result_dot)
    );

    
endmodule
