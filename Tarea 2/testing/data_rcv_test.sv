`timescale 1ns / 1ps
// Módulo para probar físicamente el registro de datos en la BRAM
// Recibe mensajes por UART y muestra el valor registrado en los LEDs
// También permite definir el address a mostrar con los switches

module data_rcv_test(
    input logic CLK100MHZ, CPU_RESETN, UART_RX_USB,
    input logic [9:0] SW,
    output logic UART_TX_USB,
    output logic [9:0] LED

    );
    logic reset;
    assign reset = ~CPU_RESETN;

    logic rx_ready;
    logic [7:0] rx_data;

    logic [9:0] bram_a_read_addr, bram_b_read_addr;
    assign bram_a_read_addr = SW;
    assign bram_b_read_addr = SW;

    //logic [7:0] command; //  Sigue formato para MainCtrl (dir memoria 0A, 1B, write, read, sum, avg, euc dist, man dist y dot prod)
    logic [9:0] bram_a_dout, bram_b_dout;
    assign LED = bram_a_dout; // Muestra en los LEDs el dato leído de la BRAM A


    inputInterface u_inputInterface (
    .clk                 (CLK100MHZ),
    .reset               (reset),
    .rx_ready            (rx_ready),
    .rx_data             (rx_data),
    .bram_a_read_addr    (bram_a_read_addr),
    .bram_b_read_addr    (bram_b_read_addr),
    .command             (),
    .bram_a_dout         (bram_a_dout),
    .bram_b_dout         (bram_b_dout)
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

