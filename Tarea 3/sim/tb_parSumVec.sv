`timescale 1ns/1ps


module tb_parSumVec;
    // Parámetros
    parameter IWIDTH = 10;
    parameter NINPUTS = 1024;
    localparam OWIDTH = IWIDTH + $clog2(NINPUTS);

    // Señales
    logic clk;
    logic [IWIDTH-1:0] data [0:NINPUTS-1];
    logic [OWIDTH-1:0] out;
    
    
    initial clk = 0;
    always #1 clk = ~clk;

    AdderTree #(
        .IWIDTH     (IWIDTH),
        .NINPUTS    (NINPUTS)
    ) dut (
        .clk        (clk),
        .data       (data),
        .out        (out)
    );

    integer suma_esperada;
    
    initial begin
        // Caso 1: todos ceros
        suma_esperada = 0;
        foreach (data[i]) data[i] = 10'd0;
        #10;
        foreach (data[i]) suma_esperada += data[i];
        $display("Suma caso 1: %d\tEsperada: %d", out, suma_esperada);

        // Caso 2: todos 1
        suma_esperada = 0;
        foreach (data[i]) data[i] = 10'd1;
        #10;
        foreach (data[i]) suma_esperada += data[i];
        $display("Suma caso 2: %d\tEsperada: %d", out, suma_esperada);

        // Caso 3: números cualquiera
        //suma_esperada = 0;
        //data = '{10'd5, 10'd50, 10'd100, 10'd0, 10'd512, 10'd1, 10'd23, 10'd7};
        //#10;
        //foreach (data[i]) suma_esperada += data[i];
        //$display("Suma caso 3: %d\tEsperada: %d", out, suma_esperada);
        
        // Caso 4: Valores máximos
        suma_esperada = 0;
        foreach (data[i]) data[i] = 10'h3FF;
        #10;
        foreach (data[i]) suma_esperada += data[i];
        $display("Suma caso 4: %d\tEsperada: %d", out, suma_esperada);
        
        //#20 $finish;
        
        
    end
endmodule