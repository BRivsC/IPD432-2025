`timescale 1ns/1ps

module tb_mem_sipo;
    // Parámetros
    parameter IWIDTH = 10;
    parameter NINPUTS = 8;
    
    // Señales
    logic clk;
    logic we;
    logic [$clog2(NINPUTS)-1:0] addr;
    logic [IWIDTH-1:0] in;
    logic [IWIDTH-1:0] out [NINPUTS-1:0];
    
    sipoMem #(
        .IWIDTH(IWIDTH),
        .NINPUTS(NINPUTS)
    ) dut (
        .clk(clk),
        .we(we),
        .addr(addr),
        .in(in),
        .out(out)
    );
    
    initial clk = 0;
    always #1 clk = ~clk;  
    
    initial begin
        // Inicialización de señales
        we = 1;
        addr = 'd0;
        in = 0;
        
        #10;
        
        // Escribir en el registro 0
        we = 1;
        addr = 'd0;
        in = 10'h0AA;  
        #10; 
        
        // Escribir en el registro 1
        addr = 'd1;
        in = 10'h1BB;
        #10;

        // Escribir en el registro 2
        addr = 'd2;
        in = 10'h2CC;
        #10;

        // Escribir en el registro 3
        addr = 'd3;
        in = 10'h3DD;
        #10;

        // Escribir en el registro 4
        addr = 'd4;
        in = 10'h0EE;
        #10;
        
        // Registro 5
        addr = 'd5;
        in = 10'h1FF;
        #10;

        // Registro 6
        addr = 'd6;
        in = 10'h211;
        #10;

        // Registro 7
        addr = 'd7;
        in = 10'h322;
        #10;

        // Leer los registros
        we = 0;
        #10;
        
        // Mostrar los resultados
        $display("Registro 0: %h", out[0]);
        $display("Registro 1: %h", out[1]);
        $display("Registro 2: %h", out[2]);
        $display("Registro 3: %h", out[3]);
        
        #20 $finish;
    end
endmodule
