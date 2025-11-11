module tb_mem_sipo;
    // Parámetros
    parameter IWIDTH = 8;     // 8 bits por registro
    parameter NINPUTS = 4;    // 4 registros en el banco
    
    // Señales
    logic clk;
    logic we;
    logic [$clog2(NINPUTS)-1:0] addr;
    logic [IWIDTH-1:0] in;
    logic [IWIDTH-1:0] out [NINPUTS-1:0];
    
    // Instanciación del banco de registros
    sipeMem #(
        .IWIDTH(IWIDTH),
        .NINPUTS(NINPUTS)
    ) dut (
        .clk(clk),
        .we(we),
        .addr(addr),
        .in(in),
        .out(out)
    );
    
    // Generación de la señal de reloj
    always #5 clk = ~clk;  // Reloj de 10 unidades de tiempo
    
    initial begin
        // Inicialización de señales
        clk = 0;
        we = 0;
        addr = 0;
        in = 0;
        
        // Esperar un ciclo de reloj
        #10;
        
        // Escribir en el registro 0
        we = 1;
        addr = 0;
        in = 8'hAA;  // Dato de entrada
        #10; // Esperar un ciclo
        
        // Escribir en el registro 1
        addr = 1;
        in = 8'hBB;
        #10;
        
        // Leer los registros
        we = 0;
        #10;
        
        // Mostrar los resultados
        $display("Registro 0: %h", out[0]);
        $display("Registro 1: %h", out[1]);
        $display("Registro 2: %h", out[2]);
        $display("Registro 3: %h", out[3]);
        
        // Terminar la simulación
        $finish;
    end
endmodule
