`timescale 1ns/1ps


module tb_parSumVec;
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

    parallelSumVec #(
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
        //suma_esperada = 0;
        foreach (data_A[i]) data_A[i] = 10'd1;
        foreach (data_B[i]) data_B[i] = 10'd1;
        #10;

        /// El resto de casos
        // Caso 3: números cualquiera
        foreach (data_A[i]) data_A[i] = i;
        foreach (data_B[i]) data_B[i] = 1;
        #10;
        
        // Caso 4: Valores máximos
        //suma_esperada = 0;
        foreach (data_A[i]) data_A[i] = 10'h3FF;
        foreach (data_B[i]) data_B[i] = 10'h3FF;
        #10;
        //foreach (data[i]) suma_esperada += data[i];
        //$display("Suma caso 4: %d\tEsperada: %d", out, suma_esperada);
        
        #20 $finish;
        
        
    end
endmodule