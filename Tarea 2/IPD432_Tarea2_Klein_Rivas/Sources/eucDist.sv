`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/10/2025 05:15:33 PM
// Design Name: 
// Module Name: eucDist
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
// modulo de distancia euclideana. se usa la señal de control cada vez que se envia
//un dato. la salida op done indica cuando est listo el resultado para leer.
//////////////////////////////////////////////////////////////////////////////////


module eucDist#(parameter NUM_ELEMENTOS = 1024
    )(
    input logic [15:0]data_A,
    input logic [15:0]data_B,
    input logic enable,
    input logic ctrl,
    input logic clk,
    input logic reset,
    output logic op_done,
    output logic [15:0]result
    );
    
    localparam counter_width = $clog2(NUM_ELEMENTOS + 1);
    logic [29:0]aux;
    logic [counter_width:0]n;
    logic conv_raiz;
    logic [15:0]res_buff;
//    logic [29:0]res_buff;
    logic [9:0]res_buffer;
    logic [9:0]resta;
    
    always_ff @(posedge clk)begin
        if(reset) begin
            aux <= 30'b0;
            res_buffer <= 10'b0;
            n<= 0;
        end
        else if(enable) begin
            if(ctrl) begin
                res_buffer <= resta;
                aux <= aux + (res_buffer * res_buffer);
                n <= n + 1;
            end
            else begin
                aux <= aux;
                n <= n;
            end
        end
        else begin
            aux <= 30'b0;
            n <= 0;
        end
    end
    
    always_comb begin
        if(n>=NUM_ELEMENTOS + 1) conv_raiz = 1'b1;
        else conv_raiz = 1'b0;
    end
    
    always_comb begin
        if(data_A > data_B) resta = data_A - data_B;
        else resta = data_B - data_A;
    end
    
    raiz raiz_euc_dist (
        .aclk(clk),                                        // input wire aclk
        .s_axis_cartesian_tvalid(conv_raiz),  // input wire s_axis_cartesian_tvalid
        .s_axis_cartesian_tdata({2'b00,aux}),    // input wire [23 : 0] s_axis_cartesian_tdata
        .m_axis_dout_tvalid(op_done),            // output wire m_axis_dout_tvalid
        .m_axis_dout_tdata(res_buff)              // output wire [15 : 0] m_axis_dout_tdata
    );
    assign result = {1'b0 , res_buff[14:0]};

//    sqrt_int #(.WIDTH(30))
//    simple_sqrt(      // width of radicand
//        .clk(clk),
//    .start(conv_raiz),             // start signal
//    .valid(op_done),             // root and rem are valid
//    .rad(aux),   // radicand
//    .root(res_buff),  // root
//    .rem()    // remainder
//    );
//    assign result = res_buff[15:0];
endmodule
