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
    output logic [6:0] segmentos,
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
    logic begin_write_src, begin_write_dest;
    logic op_done_src, op_done_dest;
    logic [9:0] read_mem_dir;
    logic write_done_src, write_done_dest;
    logic command_ready_src, command_ready_dest;
    logic [7:0] command;
    logic [9:0] bram_a_dout;
    logic [9:0] bram_b_dout;
    logic tx_sent_src, tx_sent_dest;
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
    
    xpm_cdc_single/* #(
    .DEST_SYNC_FF          (PL_DEST_SYNC_FF),
    .REG_OUTPUT            (PL_REG_OUTPUT),
    .RST_USED              (PL_RST_USED),
    .SIM_ASSERT_CHK        (SIM_ASSERT_CHK)
  )*/ 
    single_begin_write (
        .src_clk               (clk_process),
        .src_in                (begin_write_src),
        .dest_clk              (clk_input),
        .dest_out              (begin_write_dest)
    );
    
    xpm_cdc_pulse/* #(
    .DEST_SYNC_FF          (PL_DEST_SYNC_FF),
    .REG_OUTPUT            (PL_REG_OUTPUT),
    .RST_USED              (PL_RST_USED),
    .SIM_ASSERT_CHK        (SIM_ASSERT_CHK)
  )*/ 
    pulse_write_done (
        .src_clk               (clk_input),
        .src_pulse             (write_done_src),
        .dest_clk              (clk_process),
        .src_rst               (reset_input),
        .dest_rst              (reset_process),
        .dest_pulse            (write_done_dest)
    );
    
    //command ready tambien
    
    xpm_cdc_pulse/* #(
    .DEST_SYNC_FF          (PL_DEST_SYNC_FF),
    .REG_OUTPUT            (PL_REG_OUTPUT),
    .RST_USED              (PL_RST_USED),
    .SIM_ASSERT_CHK        (SIM_ASSERT_CHK)
  )*/ 
    pulse_tx_sent (
        .src_clk               (clk_output),
        .src_pulse             (tx_sent_src),
        .dest_clk              (clk_process),
        .src_rst               (reset_input),
        .dest_rst              (reset_process),
        .dest_pulse            (tx_sent_dest)
    );
    
    xpm_cdc_pulse/* #(
    .DEST_SYNC_FF          (PL_DEST_SYNC_FF),
    .REG_OUTPUT            (PL_REG_OUTPUT),
    .RST_USED              (PL_RST_USED),
    .SIM_ASSERT_CHK        (SIM_ASSERT_CHK)
  )*/ 
    pulse_begin_transmision (
        .src_clk               (clk_process),
        .src_pulse             (op_done_src),
        .dest_clk              (clk_output),
        .src_rst               (reset_process),
        .dest_rst              (reset_input),
        .dest_pulse            (op_done_dest)
    );
    
    xpm_cdc_single /*#(
    .DEST_SYNC_FF          (S_DEST_SYNC_FF),
    .SIM_ASSERT_CHK        (SIM_ASSERT_CHK),
    .SRC_INPUT_REG         (S_SRC_INPUT_REG)
    )*/
    single_command (
        .src_clk               (clk_input),
        .src_in                (command_ready_src),
        .dest_clk              (clk_process),
        .dest_out              (command_ready_dest)
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
		.tx_start     (tx_start),
		.tx_data      (tx_data),
		.tx_busy      (tx_busy) //medible
    );
    
    inputInterface #(
        .NUM_ELEMENTOS           (NUM_ELEMENTOS)
    ) u_inputInterface (
        .input_domain_clk        (clk_input),
        .processor_domain_clk    (clk_process),
        .reset                   (reset_input),
        .rx_ready                (rx_ready),
        .begin_write             (begin_write_dest),
        .op_done                 (op_done_dest),
        .rx_data                 (rx_data),
        .read_mem_dir            (read_mem_dir),
        .write_done              (write_done_src),
        .command_ready           (command_ready_src),
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
        .command_ready        (command_ready_dest),      //señal para cambiar de comando de IDLE a una operacion
        .write_done           (write_done_dest),         //señal que indica que se termino toda la operacion de escritura
        .tx_sent              (tx_sent_dest),            //señal de que se envio un dato completo
        .op_ready             (euc_op_done),           //señal de que la operacion euc dist esta lista
        .command              (command),            //dir memoria 0A, 1B, dot prod, man dist, euc dist, avg, sum, read y write. En ese orden
        .process_ctrl         (process_control),       //seña para varios controles del processing core
        .read_enable          (read_enable),        //enable para las memorias para leer
        .begin_transmision    (op_done_src),  //señal para iniciar la transmision cuando hay un resultado listo
        .begin_write          (begin_write_src),        //señal para empezar la escritura
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
    
    outputInterface #(
        .INTER_BYTE_DELAY(1000000),   // ciclos de reloj de espera entre el envio de 2 bytes consecutivos
        .WAIT_FOR_REGISTER_DELAY(100), // tiempo de espera para iniciar la transmision luego de registrar el dato a enviar
        .DISPLAY_DURATION(100_000)  // Duración de cada dígito en el display multiplexado
    )
    output_interface_instance(
        .clk(clk_output),
        .reset(reset_input),
        .begin_transmission(op_done_dest),
        .tx_busy(tx_busy),
        .enables_in(enables),    //  {dot, man, euc, avg, sum, read} desde CtrllUnit
        .result_data(resultado),
    
        .tx_start(tx_start),
        .tx_sent(tx_sent_src),
        .segments(segmentos),
        .tx_data(tx_data),
        .AN(AN)
    );
    
endmodule
