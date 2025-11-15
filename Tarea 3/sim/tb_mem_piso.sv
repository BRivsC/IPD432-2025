`timescale 1ns/1ps

module tb_mem_piso;
    // Parámetros
    parameter IWIDTH  = 10;
    parameter NINPUTS = 8;

    // Señales
    logic clk, load, en;
    logic [IWIDTH-1:0] in [NINPUTS-1:0];
    logic [IWIDTH-1:0] out;

    pisoMem #(
        .IWIDTH(IWIDTH),
        .NINPUTS(NINPUTS)
    ) dut (
        .clk(clk),
        .load(load),
        .en(en),
        .in(in),
        .out(out)
    );

    initial clk = 0;
    always #1 clk = ~clk;
    integer i = 0;

    initial begin
        // Inicialización
        load = 0;
        en   = 0;
        foreach (in[i]) in[i] = 0;


        // Cargar datos secuenciales
        for (i = 0; i < NINPUTS; i++) begin
            in[i] = i + 1;  // Datos 1,2,3,...,8
        end

        // Activar carga
        load = 1;
        #2 load = 0;

        // Activar enable y comenzar a shiftear
        #10 en = 1;
        #20 en = 0;

        #20

        
        // Nueva carga de datos
        for (i = 0; i < NINPUTS; i++) begin
            in[i] = NINPUTS - i;  // Datos 1,2,3,...,8
        end

        // Activar carga
        load = 1;
        #2 load = 0;

        // Activar enable y comenzar a shiftear
        #10 en = 1;
        #4 en = 0; // Interrupción de enable

        // Terminar de shiftear
        #10 en = 1;
        #20 en = 0;


        // Caso borde: volver a cargar con valores máximos
        for (i = 0; i < NINPUTS; i++) begin
            in[i] = (2**IWIDTH - 1);
        end

        // Activar carga
        load = 1;
        #2 load = 0;

        // Shift de nuevo
        en = 1;
        #10

        en = 0;

        #20 $finish;
    end

endmodule
