`timescale 1ns / 1ps

module writeCtrl_tb;

    // Señales para el DUT
    logic clk;
    logic reset;
    logic rx_ready;
    logic en;
    logic bram_sel;
    logic [7:0] rx_data;
    logic write_done;
    logic inc;
    logic wea_a;
    logic wea_b;
    logic [9:0] dout;

    // Instancia del DUT
    writeCtrl dut (
        .clk(clk),
        .reset(reset),
        .rx_ready(rx_ready),
        .en(en),
        .bram_sel(bram_sel),
        .rx_data(rx_data),
        .write_done(write_done),
        .inc(inc),
        .wea_a(wea_a),
        .wea_b(wea_b),
        .dout(dout)
    );

    // Generador de reloj
    always #5 clk = ~clk;

    // Testbench
    initial begin
        // Inicialización
        clk = 0;
        reset = 1;
        rx_ready = 0;
        en = 0;
        bram_sel = 0;
        rx_data = 8'b0;

        // Liberar reset
        #10 reset = 0;

        // Paso 1: Enable y escribir a BRAM A
        #10 en = 1;
        bram_sel = 0;

        // Paso 2: Enviar LSB del dato (rx_data = 8'b1010_1010)
        #10 rx_data = 8'b1010_1010;
        rx_ready = 1;
        #10 rx_ready = 0;

        // Paso 3: Enviar MSB del dato (rx_data = 8'b0000_0011)
        #10 rx_data = 8'b0000_0011;
        rx_ready = 1;
        #10 rx_ready = 0;

        // Paso 4: Esperar a que se complete la escritura
        #20 en = 0;

        // Paso 5: Enable y escribir a BRAM B
        #10 en = 1;
        bram_sel = 1;

        // Paso 6: Enviar LSB del dato (rx_data = 8'b1111_0000)
        #10 rx_data = 8'b1111_0000;
        rx_ready = 1;
        #10 rx_ready = 0;

        // Paso 7: Enviar MSB del dato (rx_data = 8'b0000_1111)
        #10 rx_data = 8'b0000_1111;
        rx_ready = 1;
        #10 rx_ready = 0;

        // Paso 8: Esperar a que se complete la escritura
        #20 en = 0;

        // Finalizar simulación
        #50 $finish;
    end

    // Monitor para observar las señales
    initial begin
        $monitor("Time: %0t | en: %b | rx_data: %b | dout: %b | wea_a: %b | wea_b: %b | write_done: %b",
                 $time, en, rx_data, dout, wea_a, wea_b, write_done);
    end

endmodule