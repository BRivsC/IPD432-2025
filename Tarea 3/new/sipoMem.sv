`timescale 1ns/1ps
// Memoria que recibe una palabra por vez y las retorna en una salida paralela
// Imita al funcionamiento de un puerto de BRAM con su dirección, dato y Write Enable
module sipoMem#(
    parameter IWIDTH = 10,
    parameter NINPUTS = 8
)(
    input logic clk, we, //rst,
    input logic [$clog2(NINPUTS)-1:0] addr,
    input logic [IWIDTH-1:0] in,
    output logic [IWIDTH-1:0] out [NINPUTS-1:0] 
);

    logic [IWIDTH-1:0] registers [NINPUTS-1:0];

    // Banco de registros
    always_ff @(posedge clk) begin
        //if (rst) begin
        //    for (int i = 0; i < NINPUTS; i++) begin
        //        registers[i] <= 0;
        //    end
        //end else
        if (we) begin
            registers[addr] <= in;
        end 
    end

    // Asignar los valores de los registros a la salida 'out'
    generate
        genvar i;
        for (i = 0; i < NINPUTS; i++) begin 
            assign out[i] = registers[i];
        end
    endgenerate



endmodule