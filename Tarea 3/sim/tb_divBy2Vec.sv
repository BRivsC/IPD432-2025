`timescale 1ns/1ps

module tb_divBy2Vec;
    // Parámetros
    parameter IWIDTH = 10;
    parameter NINPUTS = 8;
    localparam OWIDTH = IWIDTH;

    // Señales
    logic clk;
    logic [IWIDTH-1:0] data [0:NINPUTS-1];
    logic [OWIDTH-1:0] out  [0:NINPUTS-1];
    
    
    initial clk = 0;
    always #1 clk = ~clk;

    divBy2Vec #(
        .IWIDTH     (IWIDTH),
        .NINPUTS    (NINPUTS)
    ) dut (
        .clk        (clk),
        .data       (data),
        .out        (out)
    );


    initial begin
        /// Sanity checks
        // Caso 1: todos ceros
        foreach (data[i]) data[i] = 10'd0;
        #20;

        // Caso 2: todos 1
        //suma_esperada = 0;
        foreach (data[i]) data[i] = 10'd1;
        #10;

        /// El resto de casos
        // Caso 3: todos 2
        foreach (data[i]) data[i] = 10'd2;

        // Caso 4: números cualquiera
        foreach (data[i]) data[i] = i;
        #10;
        
        // Caso 5: Valores máximos
        //suma_esperada = 0;
        foreach (data[i]) data[i] = 10'h3FF;
        #10;
        
        #20 $finish;
        
        
    end
endmodule