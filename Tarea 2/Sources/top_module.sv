`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/20/2025 11:16:22 PM
// Design Name: 
// Module Name: top_module
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top_module #(parameter NUM_ELEMENTOS = 1024)(
    input clk,
    input resetN,
    input uart_rx,
    output logic uart_tx,
    output logic [7:0] segmentos,
    output logic [7:0] AN
    );
    
    logic clk_input;//reloj 100 mhz
    logic clk_process;//reloj 100 mhz
    logic clk_output;//reloj 100 mhz
    logic reset_input;
    logic reset_process;
    logic [7:0]rx_data;//byte recibido de uart
    logic rx_ready;//recepcion de 1 byte de uart terminada
    logic tx_start;//bit para iniciar transmision
    logic [7:0]tx_data;//byte de datos a transmitir
    logic tx_busy;//byte que indica que el canal de envio esta ocupado
    logic operacion_terminada;//se termino una operacion aritmetica y el resultado se puede transmitir
    logic [5:0]enables;//flags que indican la operacion a realizar
    logic [31:0]resultado;//resultado de la operacin del processing core
    logic register_result32;
    logic send_b0, send_b1, send_b2, send_b3;//banderas de envio de bytes de resultado
    logic tx_done;//byte que indica que se envio un dato completo
    logic bcd_data;//datos bcd para el display
    logic begin_write;
    logic op_done;
    logic [9:0] read_mem_dir;
    logic write_done;
    logic command_ready;
    logic [7:0] command;
    logic [9:0] bram_a_dout;
    logic [9:0] bram_b_dout;
    logic tx_sent;
    logic euc_op_done;
    logic process_control;
    logic read_enable;
    
    PB_Debouncer reset_in(
        .clk(clk_input),
        .rst(1'b0),
        .PB(~resetN),
        .PB_pressed_status(reset_input)
    );
    
    PB_Debouncer reset_proc(
        .clk(clk_process),
        .rst(1'b0),
        .PB(~resetN),
        .PB_pressed_status(reset_process)
    );
    
    clk_wiz_0 instance_name
    (
        // Clock out ports
        .input_domain_clk(clk_input),     // output input_domain_clk
        .ctrl_domain_clk(clk_process),     // output ctrl_domain_clk
        .output_domain_clk(clk_output),     // output output_domain_clk
        // Status and control signals
        .reset(reset_input), // input reset
        // Clock in ports
        .clk_in1(clk)      // input clk_in1
    );
    
    uart_basic #(
		.CLK_FREQUENCY(100_000_000), // reloj base de entrada
		.BAUD_RATE(115200)
	) uart_basic_inst (
		.clk          (clk_input),
		.reset        (reset_input),
		.rx           (uart_rx),
		.rx_data      (rx_data),
		.rx_ready     (rx_ready),
		.tx           (uart_tx),
		.tx_start     (0),
		.tx_data      (0),
		.tx_busy      () //medible
    );
    
    inputInterface #(
        .NUM_ELEMENTOS           (NUM_ELEMENTOS)
    ) u_inputInterface (
        .input_domain_clk        (clk_input),
        .processor_domain_clk    (clk_process),
        .reset                   (reset_input),
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
        .data_b                  (bram_b_dout)
    );
    
    controllUnit #(
        .NUM_ELEMENTOS        (NUM_ELEMENTOS)
    ) u_controllUnit (
        .clk                  (clk_process),                //reloj 100Mhz
        .reset                (reset_process),              //reset sincronizado
        .command_ready        (command_ready),      //señal para cambiar de comando de IDLE a una operacion
        .write_done           (write_done),         //señal que indica que se termino toda la operacion de escritura
        .tx_sent              (tx_sent),            //señal de que se envio un dato completo
        .op_ready             (euc_op_done),           //señal de que la operacion euc dist esta lista
        .command              (command),            //dir memoria 0A, 1B, dot prod, man dist, euc dist, avg, sum, read y write. En ese orden
        .process_ctrl         (process_control),       //seña para varios controles del processing core
        .read_enable          (read_enable),        //enable para las memorias para leer
        .begin_transmision    (op_done),  //señal para iniciar la transmision cuando hay un resultado listo
        .begin_write          (begin_write),        //señal para empezar la escritura
        .enables              (enables),            //arreglo de enables para las distintas operaciones. Mismo orden que command
        //direccion de memoria a leer
        //.mem_dir              (read_mem_dir)
        .mem_dir              (read_mem_dir)
    );
    
    processingCore #(.NUM_ELEMENTOS(NUM_ELEMENTOS))
    pCore(
        .data_A({6'b0 , bram_a_dout}),
        .data_B({6'b0 , bram_b_dout}),
        .enables(enables),
        .ctrl(process_control),
        .clk(clk_process),
        .reset(reset_process),
        .result(resultado),
        .op_done(euc_op_done)
    );
    
    
    
//    outputInterface u_outputInterface (
//        .clk                  (clk_output),
//        .reset                (reset_input),
//        .send_b0              (send_b0),
//        .send_b1              (send_b1),
//        .send_b2              (send_b2),
//        .send_b3              (send_b3),
//        .register_result32    (register_result32),
//        .result_data          (resultado),
//        .tx_data              (tx_data),
//        .bcd_out              (bcd_data)
//    );
    
//    driver_7_seg_en u_driver_7_seg_en (
//        .clock                (clk_100Mhz),
//        .reset                (reset),
//        .enable               (enable_display),
//        .BCD_in               (bcd_data),
//        .segments             ({CA, CB, CC, CD, CE, CF, CG}),
//        .anodos               (AN)// {AN7, AN6, AN5, AN4, AN3, AN2, AN1, AN0}
//    );
    
endmodule
