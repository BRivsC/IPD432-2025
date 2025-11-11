module tb_adder_tree;
    // Parámetros
    parameter IWIDTH = 8;
    parameter NINPUTS = 8;  // Cambiar este valor para probar con diferentes entradas
    
    // Señales
    logic [IWIDTH-1:0] data [0:NINPUTS-1];
    logic [IWIDTH-1:0] sum;
    
    // Instanciar el Adder Tree
    AdderTree #(
        .IWIDTH(IWIDTH),
        .NINPUTS(NINPUTS)
    ) uut (
        .data(data),
        .sum(sum)
    );
    
    initial begin
        // Asignar valores a las entradas
        data[0] = 8'h01;
        data[1] = 8'h02;
        data[2] = 8'h03;
        data[3] = 8'h04;
        data[4] = 8'h05;
        data[5] = 8'h06;
        data[6] = 8'h07;
        data[7] = 8'h08;
        
        // Esperar un poco para ver el resultado
        #10;
        
        // Mostrar el resultado
        $display("Suma total: %h", sum);
    end
endmodule
