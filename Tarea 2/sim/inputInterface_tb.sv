`timescale 1ns / 1ps

module inputInterface_tb;

    localparam NUM_ELEMENTOS = 4;
    
    // Señales para el DUT
    logic clk;
    logic reset;
    logic rx_ready;
    logic begin_write_src, begin_write_dest;
    logic op_done_src, op_done_dest;
    logic [7:0] rx_data;
    logic [9:0] read_mem_dir;
    logic [7:0] command;
    logic [9:0] data_a;
    logic [9:0] data_b;
    logic [5:0] enables;
    logic process_control;
    logic [31:0] result;
    logic euc_op_done;
    logic tx_sent_src, tx_sent_dest;
    logic command_ready_src, command_ready_dest;
    logic write_done_src, write_done_dest;
    // Instancia del DUT
    
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
    
    clk_wiz_0 clock_sim
    (
        // Clock out ports
        .input_domain_clk(clk_input),     // output input_domain_clk
        .ctrl_domain_clk(clk_process),     // output ctrl_domain_clk
        .output_domain_clk(clk_output),     // output output_domain_clk
        // Status and control signals
        .reset(reset), // input reset
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
        .src_rst               (reset),
        .dest_rst              (reset),
        .dest_pulse            (write_done_dest)
    );
    
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
        .src_rst               (reset),
        .dest_rst              (reset),
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
        .src_rst               (reset),
        .dest_rst              (reset),
        .dest_pulse            (op_done_dest)
    );
    
    inputInterface #(
        .NUM_ELEMENTOS           (NUM_ELEMENTOS)
    ) dut (
        .input_domain_clk        (clk),
        .processor_domain_clk    (clk),
        .reset                   (reset),
        .rx_ready                (rx_ready),
        .begin_write             (begin_write_dest),
        .rx_data                 (rx_data),
        .read_mem_dir            (read_mem_dir),
        .write_done              (write_done_src),
        .command_ready           (command_ready_src),
        .command                 (command), //  Sigue formato para MainCtrl (dir memoria 0A, 1B, write, read, sum, avg, euc dist, man dist y dot prod)
        .op_done                 (op_done_dest),
        .data_a                  (data_a),
        .data_b                  (data_b)
    );

    controllUnit #(
        .NUM_ELEMENTOS        (NUM_ELEMENTOS)
    ) u_controllUnit (
        .clk                  (clk),                //reloj 100Mhz
        .reset                (reset),              //reset sincronizado
        .command_ready        (command_ready_dest),      //señal para cambiar de comando de IDLE a una operacion
        .write_done           (write_done_dest),         //señal que indica que se termino toda la operacion de escritura
        .tx_sent              (tx_sent_dest),                  //señal de que se envio un dato completo
        .op_ready             (euc_op_done),        //señal de que la operacion euc dist esta lista
        .command              (command),            //dir memoria 0A, 1B, dot prod, man dist, euc dist, avg, sum, read y write. En ese orden
        .process_ctrl         (process_control),    //seña para varios controles del processing core
        .read_enable          (),                   //enable para las memorias para leer
        .begin_transmision    (op_done_src),            //señal para iniciar la transmision cuando hay un resultado listo
        .begin_write          (begin_write_src),        //señal para empezar la escritura
        .enables              (enables),            //arreglo de enables para las distintas operaciones. Mismo orden que command
        .mem_dir              (read_mem_dir)        //direccion de memoria a leer
    );
    
    processingCore #(.NUM_ELEMENTOS(NUM_ELEMENTOS))
    pCore(
        .data_A({6'b0 , data_a}),
        .data_B({6'b0 , data_b}),
        .enables(enables),
        .ctrl(process_control),
        .clk(clk),
        .reset(reset),
        .result(result),
        .op_done(euc_op_done)
    );
    
    transmitter_test trans_test(
    .tx_start(op_done_dest),
    .clk(clk),
    .reset(reset),
    .tx_sent(tx_sent_src)
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
        //read_mem_dir = 10'b0;

        // Liberar reset
        #20 reset = 0;

        // Paso 1: Instrucción de escritura a la dirección 0 (rx_data = 0000_0001)
        #350 rx_data = 8'b0000_0001;
        rx_ready = 1;
        #10 rx_ready = 0;

        // Paso 2: 4 mensajes con datos cualesquiera 2 numeros de 10 bits
        #300 rx_data = 8'b1010_1010;//lsb
        rx_ready = 1;
        #10 rx_ready = 0;

        #300 rx_data = 8'b0000_0001;//msb
        rx_ready = 1;
        #10 rx_ready = 0;

        #300 rx_data = 8'b0000_0000;
        rx_ready = 1;
        #10 rx_ready = 0;
        
        #300 rx_data = 8'b0000_0000;
        rx_ready = 1;
        #10 rx_ready = 0;
        
        #300 rx_data = 8'hff;
        rx_ready = 1;
        #10 rx_ready = 0;
        
        #300 rx_data = 8'b0000_0011;
        rx_ready = 1;
        #10 rx_ready = 0;
        
        #300 rx_data = 8'ha3;
        rx_ready = 1;
        #10 rx_ready = 0;
        
        #300 rx_data = 8'b0000_0010;
        rx_ready = 1;
        #10 rx_ready = 0;


        // Paso 5: Otros 2 mensajes con datos cualesquiera
        
        #300 rx_data = 8'b1000_0001;
        rx_ready = 1;
        #10 rx_ready = 0;
        
        #300 rx_data = 8'b0011_1100;
        rx_ready = 1;
        #10 rx_ready = 0;

        #300 rx_data = 8'b0000_0011;
        rx_ready = 1;
        #10 rx_ready = 0;

        #300 rx_data = 8'b1111_1111;
        rx_ready = 1;
        #10 rx_ready = 0;
        
        #300 rx_data = 8'b0000_0011;
        rx_ready = 1;
        #10 rx_ready = 0;
        
        #300 rx_data = 8'b0000_1111;
        rx_ready = 1;
        #10 rx_ready = 0;
        
        #300 rx_data = 8'b0000_0010;
        rx_ready = 1;
        #10 rx_ready = 0;
        
        #300 rx_data = 8'hd7;
        rx_ready = 1;
        #10 rx_ready = 0;
        
        #300 rx_data = 8'b0000_0001;
        rx_ready = 1;
        #10 rx_ready = 0;

      // // 6 mensajes más con datos cualesquiera
      // #20 rx_data = 8'b1110_0001;
      // rx_ready = 1;
      // #10 rx_ready = 0;

      // #20 rx_data = 8'b1001_0110;
      // rx_ready = 1;
      // #10 rx_ready = 0;

      // #20 rx_data = 8'b0110_1001;
      // rx_ready = 1;
      // #10 rx_ready = 0;

      // #20 rx_data = 8'b0011_1100;
      // rx_ready = 1;
      // #10 rx_ready = 0;

      // #20 rx_data = 8'b1100_0011;
      // rx_ready = 1;
      // #10 rx_ready = 0;

      // //#20 rx_data = 8'b0001_1110;
      // //rx_ready = 1;
      // #10 //rx_ready = 0;


        // Nuevo: Mandar comando de lectura
        #120 rx_data = 8'b1000_0010; // bram_sel = 1, op_code = 010 (ReadVect)
        rx_ready = 1;
        #10 rx_ready = 0;
//        #70 tx_sent = 1;
//        #10 tx_sent = 0;
//        #70 tx_sent = 1;
//        #10 tx_sent = 0;
//        #70 tx_sent = 1;
//        #10 tx_sent = 0;
//        #70 tx_sent = 1;
//        #10 tx_sent = 0;
        
        #2200 rx_data = 8'b0000_0010; // bram_sel = 0, op_code = 010 (ReadVect)
        rx_ready = 1;
        #10 rx_ready = 0;
//        #70 tx_sent = 1;
//        #10 tx_sent = 0;
//        #70 tx_sent = 1;
//        #10 tx_sent = 0;
//        #70 tx_sent = 1;
//        #10 tx_sent = 0;
//        #70 tx_sent = 1;
//        #10 tx_sent = 0;
        
        #2000 rx_data = 8'b0000_0011; // sum vectorial
        rx_ready = 1;
        #10 rx_ready = 0;
//        #70 tx_sent = 1;
//        #10 tx_sent = 0;
//        #70 tx_sent = 1;
//        #10 tx_sent = 0;
//        #70 tx_sent = 1;
//        #10 tx_sent = 0;
//        #70 tx_sent = 1;
//        #10 tx_sent = 0;
        
        #2000 rx_data = 8'b0000_0100; // avg vec
        rx_ready = 1;
        #10 rx_ready = 0;
//        #70 tx_sent = 1;
//        #10 tx_sent = 0;
//        #70 tx_sent = 1;
//        #10 tx_sent = 0;
//        #70 tx_sent = 1;
//        #10 tx_sent = 0;
//        #70 tx_sent = 1;
//        #10 tx_sent = 0;
        
        #2000 rx_data = 8'b0000_0101; // euc dist
        rx_ready = 1;
        #10 rx_ready = 0;
//        #300 tx_sent = 1;
//        #10 tx_sent = 0;
        
        #600 rx_data = 8'b0000_0110; // euc dist
        rx_ready = 1;
        #10 rx_ready = 0;
//        #200 tx_sent = 1;
//        #10 tx_sent = 0;
        
        #600 rx_data = 8'b0000_0111; // euc dist
        rx_ready = 1;
        #10 rx_ready = 0;
//        #200 tx_sent = 1;
//        #10 tx_sent = 0;
     
        // Finalizar simulación
        #500 $finish;
    end



endmodule