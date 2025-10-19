`timescale 1ns / 1ps

module inputInterface_tb;

    // Señales para el DUT
    logic clk;
    logic reset;
    logic rx_ready;
    logic [7:0] rx_data;
    logic [9:0] bram_a_read_addr;
    logic [9:0] bram_b_read_addr;
    logic [7:0] command;
    logic [9:0] bram_a_dout;
    logic [9:0] bram_b_dout;

    // Instancia del DUT
    inputInterface uut (
        .clk(clk),
        .reset(reset),
        .rx_ready(rx_ready),
        .rx_data(rx_data),
        .bram_a_read_addr(bram_a_read_addr),
        .bram_b_read_addr(bram_b_read_addr),
        .command(command),
        .bram_a_dout(bram_a_dout),
        .bram_b_dout(bram_b_dout)
    );

    // Generador de reloj
    always #1 clk = ~clk;

    // Testbench
    initial begin
        // Inicialización
        clk = 0;
        reset = 1;
        rx_ready = 0;
        rx_data = 8'b0;
        bram_a_read_addr = 10'b0;
        bram_b_read_addr = 10'b0;

        // Liberar reset
        #10 reset = 0;

        // Paso 1: Instrucción de escritura a la dirección 0 (rx_data = 0000_0001)
        #10 rx_data = 8'b0000_0001;
        rx_ready = 1;
        #10 rx_ready = 0;

        // Paso 2: 3 mensajes con datos cualesquiera
        #10 rx_data = 8'b1010_1010;
        rx_ready = 1;
        #10 rx_ready = 0;

        #10 rx_data = 8'b0101_0101;
        rx_ready = 1;
        #10 rx_ready = 0;

        #10 rx_data = 8'b1111_0000;
        rx_ready = 1;
        #10 rx_ready = 0;

        // Paso 3: Definir bram_a_read_addr en 00_0000_0001
        #10 bram_a_read_addr = 10'b00_0000_0001;

        // Paso 4: Instrucción de escritura a la dirección 1 (rx_data = 1000_0001)
        #10 rx_data = 8'b1000_0001;
        rx_ready = 1;
        #10 rx_ready = 0;

        // Paso 5: Otros 3 mensajes con datos cualesquiera
        #10 rx_data = 8'b0011_1100;
        rx_ready = 1;
        #10 rx_ready = 0;

        #10 rx_data = 8'b1100_0011;
        rx_ready = 1;
        #10 rx_ready = 0;

        #10 rx_data = 8'b0001_1110;
        rx_ready = 1;
        #10 rx_ready = 0;

        // Paso 6: Definir bram_b_read_addr en 00_0000_0001
        #10 bram_b_read_addr = 10'b00_0000_0001;

        // Finalizar simulación
        #50 $finish;
    end

    // Monitor para observar las señales
    initial begin
        $monitor("Time: %0t | rx_data: %b | command: %b | bram_a_dout: %d | bram_b_dout: %d",
                 $time, rx_data, command, bram_a_dout, bram_b_dout);
    end

endmodule