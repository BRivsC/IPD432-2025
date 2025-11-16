`timescale 1ns/1ps


module tb_absSubVec;
    // Parámetros
    parameter IWIDTH = 10;
    parameter NINPUTS = 8;
    localparam OWIDTH = IWIDTH + $clog2(NINPUTS);

    // Señales
    logic clk;
    logic [IWIDTH-1:0] data_A [0:NINPUTS-1];
    logic [IWIDTH-1:0] data_B [0:NINPUTS-1];
    logic [OWIDTH-1:0] out    [0:NINPUTS-1];
    
    
    initial clk = 0;
    always #1 clk = ~clk;

    absSubVec #(
        .IWIDTH     (IWIDTH),
        .NINPUTS    (NINPUTS)
    ) dut (
        .clk        (clk),
        .data_A     (data_A),
        .data_B     (data_B),
        .out        (out)
    );



    //integer suma_esperada;
    
    initial begin
        /// Sanity checks
        // Caso 1: todos ceros
        foreach (data_A[i]) data_A[i] = 10'd0;
        foreach (data_B[i]) data_B[i] = 10'd0;
        #20;

        // Caso 2: todos 1
        foreach (data_A[i]) data_A[i] = 10'd1;
        foreach (data_B[i]) data_B[i] = 10'd1;
        #10;

        /// El resto de casos
        // Caso 3: números cualquiera
        foreach (data_A[i]) data_A[i] = i;
        foreach (data_B[i]) data_B[i] = 1;
        #10;
        
        // Caso 4: Valores máximos
        foreach (data_A[i]) data_A[i] = 10'h3FF;
        foreach (data_B[i]) data_B[i] = 10'h3FF;
        #10;
        
        // Caso : Valor muy grande con uno muy pequeño
        foreach (data_A[i]) data_A[i] = 10'h1;
        foreach (data_B[i]) data_B[i] = 10'h3FF;
        #10;

        #20 $finish;
        
        
    end
endmodule