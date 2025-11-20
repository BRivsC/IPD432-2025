`timescale 1ns/1ps

module tb_shiftRegister;

    localparam IWIDTH  = 10;
    localparam NINPUTS = 8;

    // Señales
    logic clk;
    logic inc;
    logic [IWIDTH-1:0] in;
    logic [IWIDTH-1:0] out [NINPUTS-1:0];

    // Instancia del DUT
    shiftSipoMem #(
        .IWIDTH(IWIDTH),
        .NINPUTS(NINPUTS)
    ) dut (
        .clk(clk),
        .enable(inc),
        .in(in),
        .out(out)
    );

    // Generador de clock
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // período 10 ns
    end

    // Estímulos
    initial begin
        integer i;

        // Inicial
        inc = 0;
        in  = 0;

        // Esperar un poco
        #20;

        // Enviar 10 valores y hacer shift en cada ciclo
        for (i = 1; i <= 10; i++) begin
            @(posedge clk);
            in  = i;     // cargar valor
            inc = 1;     // habilitar shift

            @(posedge clk);
            inc = 0;     // deshabilitar shift por un ciclo (opcional)

            // Mostrar contenido del registro
            $display("\nShift #%0d, in = %0d", i, in);
            for (int j = 0; j < NINPUTS; j++) begin
                $display("  out[%0d] = %0d", j, out[j]);
            end
        end

        #50;
        $finish;
    end

endmodule
