`timescale 1ns / 1ps

module inputInterface_tb;

    // Señales para el DUT
    logic clk;
    logic reset;
    logic rx_ready;
    logic begin_write;
    logic [7:0] rx_data;
    logic [9:0] read_mem_dir;
    logic [7:0] command;
    logic [9:0] bram_a_dout;
    logic [9:0] bram_b_dout;
    localparam NUM_ELEMENTOS = 2;
    // Instancia del DUT

    inputInterface #(
        .NUM_ELEMENTOS           (NUM_ELEMENTOS)
    ) dut (
        .input_domain_clk        (clk),
        .processor_domain_clk    (clk),
        .reset                   (reset),
        .rx_ready                (rx_ready),
        .begin_write             (begin_write),
        .rx_data                 (rx_data),
        .read_mem_dir            (read_mem_dir),
        .write_done              (write_done),
        .command_ready           (command_ready),
        .command                 (command), //  Sigue formato para MainCtrl (dir memoria 0A, 1B, write, read, sum, avg, euc dist, man dist y dot prod)
        .data_a                  (data_a),
        .data_b                  (data_b)
    );

    controllUnit #(
        .NUM_ELEMENTOS        (NUM_ELEMENTOS)
    ) u_controllUnit (
        .clk                  (clk),                //reloj 100Mhz
        .reset                (reset),              //reset sincronizado
        .command_ready        (command_ready),      //señal para cambiar de comando de IDLE a una operacion
        .write_done           (write_done),         //señal que indica que se termino toda la operacion de escritura
        .tx_sent              (0),            //señal de que se envio un dato completo
        .op_ready             (0),           //señal de que la operacion euc dist esta lista
        .command              (command),            //dir memoria 0A, 1B, dot prod, man dist, euc dist, avg, sum, read y write. En ese orden
        .process_ctrl         (),       //seña para varios controles del processing core
        .read_enable          (),        //enable para las memorias para leer
        .begin_transmision    (),  //señal para iniciar la transmision cuando hay un resultado listo
        .begin_write          (begin_write),        //señal para empezar la escritura
        .enables              (),            //arreglo de enables para las distintas operaciones. Mismo orden que command
        //direccion de memoria a leer
        .mem_dir              (read_mem_dir)
    );

    // Generador de reloj
    always #5 clk = ~clk;

    // Testbench
    initial begin
        // Inicialización
        clk = 0;
        reset = 1;
        rx_ready = 0;
        rx_data = 8'b0;
        read_mem_dir = 10'b0;

        // Liberar reset
        #10 reset = 0;

        // Paso 1: Instrucción de escritura a la dirección 0 (rx_data = 0000_0001)
        #10 rx_data = 8'b0000_0001;
        rx_ready = 1;
        #10 rx_ready = 0;

        // Paso 2: 3 mensajes con datos cualesquiera
        #20 rx_data = 8'b1010_1010;
        rx_ready = 1;
        #10 rx_ready = 0;

        #20 rx_data = 8'b0101_0101;
        rx_ready = 1;
        #10 rx_ready = 0;

        #20 rx_data = 8'b1111_0000;
        rx_ready = 1;
        #10 rx_ready = 0;

        // Paso 3: Definir read_mem_dir en 00_0000_0001
        //#10 read_mem_dir = 10'b00_0000_0001;

        // Paso 4: Instrucción de escritura a la dirección 1 (rx_data = 1000_0001)
        //#10 rx_data = 8'b1000_0001;
        //rx_ready = 1;
        //#10 rx_ready = 0;

        // Paso 5: Otros 3 mensajes con datos cualesquiera
        #20 rx_data = 8'b0011_1100;
        rx_ready = 1;
        #10 rx_ready = 0;

        #20 rx_data = 8'b1100_0011;
        rx_ready = 1;
        #10 rx_ready = 0;

        #20 rx_data = 8'b0001_1110;
        rx_ready = 1;
        #10 rx_ready = 0;

        // 6 mensajes más con datos cualesquiera
        #20 rx_data = 8'b1110_0001;
        rx_ready = 1;
        #10 rx_ready = 0;

        #20 rx_data = 8'b1001_0110;
        rx_ready = 1;
        #10 rx_ready = 0;

        #20 rx_data = 8'b0110_1001;
        rx_ready = 1;
        #10 rx_ready = 0;

        #20 rx_data = 8'b0011_1100;
        rx_ready = 1;
        #10 rx_ready = 0;

        #20 rx_data = 8'b1100_0011;
        rx_ready = 1;
        #10 rx_ready = 0;

        #20 rx_data = 8'b0001_1110;
        rx_ready = 1;
        #10 rx_ready = 0;

        // Paso 6: Definir read_mem_dir en 00_0000_0001
        #10 read_mem_dir = 10'b00_0000_0001;

        // Para ver pq se borra la bram
        #100 rx_data = 8'b0000_0001;
        rx_ready = 1;
        #10 rx_ready = 0;

        // Finalizar simulación
        #50 $finish;
    end



endmodule