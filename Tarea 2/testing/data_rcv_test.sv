`timescale 1ns / 1ps
// Módulo para probar físicamente el registro de datos en la BRAM
// Recibe mensajes por UART y muestra el valor registrado en los LEDs
// También permite definir el address a mostrar con los switches

module data_rcv_test_wctrl_unit #(parameter NUM_ELEMENTOS = 2)
(
    input logic CLK100MHZ, CPU_RESETN, UART_RX_USB,
    input logic [9:0] SW,
    output logic UART_TX_USB,
    output logic [9:0] LED

    );
    logic reset;
    assign reset = ~CPU_RESETN;

    logic rx_ready;
    logic [7:0] rx_data;

    logic [9:0] read_mem_dir;
    assign read_mem_dir = SW;

    logic [7:0] command; //  Sigue formato para MainCtrl (dir memoria 0A, 1B, write, read, sum, avg, euc dist, man dist y dot prod)
    logic [9:0] bram_a_dout;
    assign LED = bram_a_dout; // Muestra en los LEDs el dato leído de la BRAM A


   //inputInterface u_inputInterface (
   //.clk                 (CLK100MHZ),
   //.reset               (reset),
   //.rx_ready            (rx_ready),
   //.rx_data             (rx_data),
   //.bram_a_read_addr    (bram_a_read_addr),
   //.bram_b_read_addr    (bram_b_read_addr),
   //.command             (),
   //.bram_a_dout         (bram_a_dout),
   //.bram_b_dout         (bram_b_dout)
	//);
    logic op_done;
    inputInterface #(
        .NUM_ELEMENTOS           (NUM_ELEMENTOS)
    ) u_inputInterface (
        .input_domain_clk        (CLK100MHZ),
        .processor_domain_clk    (CLK100MHZ),
        .reset                   (reset),
        .rx_ready                (rx_ready),
        .begin_write             (begin_write),
        .op_done                 (op_done),
        .rx_data                 (rx_data),
        .read_mem_dir            (read_mem_dir),
        .write_done              (write_done),
        .command_ready           (command_ready),
        .command                 (command),
        //  Sigue formato para MainCtrl (dir memoria 0A, 1B, write, read, sum, avg, euc dist, man dist y dot prod)
        .data_a                  (bram_a_dout),
        //.data_b                  (data_b)
        .data_b                  ()
    );


    controllUnit #(
        .NUM_ELEMENTOS        (NUM_ELEMENTOS)
    ) u_controllUnit (
        .clk                  (CLK100MHZ),                //reloj 100Mhz
        .reset                (reset),              //reset sincronizado
        .command_ready        (command_ready),      //señal para cambiar de comando de IDLE a una operacion
        .write_done           (write_done),         //señal que indica que se termino toda la operacion de escritura
        .tx_sent              (0),            //señal de que se envio un dato completo
        .op_ready             (0),           //señal de que la operacion euc dist esta lista
        .command              (command),            //dir memoria 0A, 1B, dot prod, man dist, euc dist, avg, sum, read y write. En ese orden
        .process_ctrl         (),       //seña para varios controles del processing core
        .read_enable          (),        //enable para las memorias para leer
        .begin_transmision    (op_done),  //señal para iniciar la transmision cuando hay un resultado listo
        .begin_write          (begin_write),        //señal para empezar la escritura
        .enables              (),            //arreglo de enables para las distintas operaciones. Mismo orden que command
        //direccion de memoria a leer
        //.mem_dir              (read_mem_dir)
        .mem_dir              ()
    );





    uart_basic #(
		.CLK_FREQUENCY(100_000_000), // reloj base de entrada
		.BAUD_RATE(115200)
	) uart_basic_inst (
		.clk          (CLK100MHZ),
		.reset        (reset),
		.rx           (UART_RX_USB),
		.rx_data      (rx_data),
		.rx_ready     (rx_ready),
		.tx           (UART_TX_USB),
		.tx_start     (0),
		.tx_data      (0),
		.tx_busy      () //medible
    );

endmodule

