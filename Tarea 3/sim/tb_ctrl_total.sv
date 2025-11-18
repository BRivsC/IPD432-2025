`timescale 1ns / 1ps


module tb_ctrl_total #(parameter NUM_ELEMENTOS = 8)(
    );

    //logic reset_input;
    //logic reset_process;
    //logic [7:0]rx_data;//byte recibido de uart
    logic rx_ready;//recepcion de 1 byte de uart terminada
    logic tx_start;//bit para iniciar transmision
    //logic [7:0]tx_data;//byte de datos a transmitir
    logic tx_busy;//byte que indica que el canal de envio esta ocupado
    logic [5:0]enables;//flags que indican la operacion a realizar
    logic [31:0]resultado;//resultado de la operacin del processing core
    //logic begin_write_src, begin_write_dest;
    //logic op_done_src, op_done_dest;
    //logic write_done_src, write_done_dest;
    //logic command_ready_src, command_ready_dest;
    logic [7:0] command;

    //logic tx_sent_src, tx_sent_dest;
    
    logic shift_mem;
    logic load_mem;

    

    // ===============================
    // Reloj
    // ===============================
    logic clk;
    //logic clk_input;//reloj 100 mhz
    //logic clk_process;//reloj 100 mhz
    //logic clk_output;//reloj 100 mhz

    initial begin
        clk = 0;
        //clk_input = 0;
        //clk_process = 0;
        //clk_output = 0;
        forever #1 clk = ~clk;
    end

    


/*
    // por ahora no voy a considerar la entrada pq sospecho q mi problema está en la coordinación de las fsm de procesamiento y salida
    sipoInputInterface #(
        .NUM_ELEMENTOS    (NUM_ELEMENTOS)
    ) input_interface (
        .input_domain_clk (clk_input),
        .reset            (reset_input),
        .rx_ready         (rx_ready),
        .begin_write      (begin_write_dest),
        .op_done          (op_done_dest),
        .rx_data          (rx_data),
        .write_done       (write_done_src),
        .command_ready    (command_ready_src),
        .command          (command),
        .data_a           (data_a),
        .data_b           (data_b)
    );
*/

    logic [9:0] data_a [NUM_ELEMENTOS-1:0];
    logic [9:0] data_b [NUM_ELEMENTOS-1:0];
    logic read_mem_sel;
    logic [31:0] par_result [NUM_ELEMENTOS-1:0];
    logic [31:0] man_result;
    pipelinedProcessingCore #(
        .NINPUTS(NUM_ELEMENTOS)
    ) dut_processing_core (
        .data_A(data_a),
        .data_B(data_b),
        .enables(enables),
        //.clk(clk_process),
        .clk(clk),
        .read_mem_sel(read_mem_sel),
        .par_result(par_result),
        .man_result(man_result)
    );

    logic begin_transmission;

	pipelineCtrlUnit #(
		.NUM_ELEMENTOS         (NUM_ELEMENTOS)
    ) dut_ctrl_unit (
		//.clk                   (clk_process),
		.clk                   (clk), // por ahora todos con el mismo clk pa descartar q cross domain sea el problema
		.reset                 (reset_process),
		//.command_ready         (command_ready_dest),
		.command_ready         (command_ready),
		//.write_done            (write_done_dest),
		.write_done            (write_done),
		//.tx_sent               (tx_sent_dest),
		.tx_sent               (tx_sent),
		.command               (command),
		//.begin_transmission    (op_done),
		.begin_transmission    (begin_transmission),
		//.begin_write           (begin_write_src),
		.begin_write           (begin_write),
		.read_mem_sel          (read_mem_sel),
		.shift_mem             (shift_mem),
		.load_mem              (load_mem),
		.enables               (enables)
	);


    // Memoria de salida
    resultMem #(
        .NINPUTS        (NUM_ELEMENTOS)
    ) result_mem (
        .par_data_in    (par_result),
        .man_data_in    (man_result),
        .enables        (enables),
        //.clk            (clk_process),
        .clk            (clk),
        //.rst            (reset_process),
        .rst            (reset),
        .load_mem       (load_mem),
        .shift_mem      (shift_mem),
        .result_out     (resultado)
    );


    txCtrl #(
        .INTER_BYTE_DELAY           (1), // no sé qué tanto me convengan estos delays
        .WAIT_FOR_REGISTER_DELAY    (1)
    ) dut_txCtrl (
        .clk                        (clk),
        .reset                      (reset),
        .begin_transmission         (begin_transmission),
        .tx_busy                    (tx_busy),
        .enables                    (enables), // Formato: {dot, man, euc, avg, sum, read} desde CtrllUnit
        .tx_start                   (),
        .tx_sent                    (tx_sent),
        .register_result32          (),
        .send_b0                    (),
        .send_b1                    (),
        .send_b2                    (),
        .send_b3                    ()
    );


    /*
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
        .segments(SEG),
        .tx_data(tx_data),
        .AN(AN)
    );

    assign PMOD_UART_RX = rx_data;
    assign PMOD_UART_TX = tx_data;
    */
endmodule
