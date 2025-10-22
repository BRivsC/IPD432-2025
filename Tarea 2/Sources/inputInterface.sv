`timescale 1ns / 1ps
// Módulo de interfaz de entrada con memorias, controlador de escritura, decodificador de comandos y contador de direcciones.

module inputInterface#(
    parameter NUM_ELEMENTOS = 1024
)(
    input logic input_domain_clk, reset, rx_ready, processor_domain_clk, begin_write,
    input logic [7:0] rx_data,
    input logic [9:0] read_mem_dir,
    output logic write_done, command_ready,
    output logic [7:0] command, //  Sigue formato para MainCtrl (dir memoria 0A, 1B, write, read, sum, avg, euc dist, man dist y dot prod)
    output logic [9:0] data_a, data_b
    );

    logic [9:0] write_data;
    logic [9:0] write_address;
    logic [6:0] command_out;
    logic [7:0] recv_data;
    logic count_done;
    logic wea_a, wea_b, en_write, select_bram;
    assign recv_data = rx_data;
    assign en_write = command_out[0]; //  en_write desde commandDecoder
    assign command = {select_bram, command_out}; 


    writeCtrl u_writeCtrl (
        .clk           (input_domain_clk),
        .reset         (reset),
        .rx_ready      (rx_ready),
        .en            (en_write),   
        .bram_sel      (select_bram),
        .rx_data       (recv_data),
        .write_done    (write_done),
        .count_done    (count_done),
        .inc           (inc),
        .wea_a         (wea_a),
        .wea_b         (wea_b),
        .dout          (write_data)
    );

    nbit_counter_inc #(
        .N        (10),
        .MAX_COUNT(NUM_ELEMENTOS)
    ) write_address_counter (
        .clk      (input_domain_clk),
        .reset    (reset),
        .inc      (inc),
        .count    (write_address),
        .count_done (count_done)
    );
    
    // Nota: op_code y bram_info vienen del byte recibido por rx_data
    // Formato: [bram_sel(1 bit)][unused(4 bits)][op_code(3 bits)]
    logic [2:0] opcode_in;
    logic bram_info_in;
    assign opcode_in = rx_data[2:0];
    assign bram_info_in = rx_data[7];
    commandDecoder u_commandDecoder (
        .clk            (input_domain_clk),
        .reset          (reset),
        .rx_ready       (rx_ready),
        .op_code_in     (opcode_in),
        .bram_info_in   (bram_info_in),
        .op_done        (write_done),   //  Temporalmente conectado a write_done. Conectar a los otros done a medida que se instancien los otros módulos
        .bram_sel       (select_bram),
        .command_out    (command_out) // Orden: Write, Read, Sum, Avg, Euc, Man, Dot
    );

    blk_mem_gen_0 BRAMA (
        .clka(input_domain_clk),   // input wire clka
        .ena(1),                   // input wire ena
        .wea(wea_a),               // input wire [0 : 0] wea
        .addra(write_address),     // input wire [9 : 0] addra
        .dina(write_data),         // input wire [9 : 0] dina
        .douta(),                  // output wire [9 : 0] douta
        .clkb(processor_domain_clk),                // input wire clkb
        .enb(1),                   // input wire enb
        .web(0),                   // input wire [0 : 0] web
        .addrb(read_mem_dir),  // input wire [9 : 0] addrb
        .dinb(10'd0),              // input wire [9 : 0] dinb
        .doutb(data_a)        // output wire [9 : 0] doutb
    );

    blk_mem_gen_0 BRAMB (
        .clka(input_domain_clk),    // input wire clka
        .ena(1),                    // input wire ena
        .wea(wea_b),                // input wire [0 : 0] wea
        .addra(write_address),      // input wire [9 : 0] addra
        .dina(write_data),          // input wire [9 : 0] dina
        .douta(),                   // output wire [9 : 0] douta
        .clkb(processor_domain_clk),// input wire clkb
        .enb(1),                    // input wire enb
        .web(0),                    // input wire [0 : 0] web
        .addrb(read_mem_dir),   // input wire [9 : 0] addrb
        .dinb(10'd0),               // input wire [9 : 0] dinb
        .doutb(data_b)         // output wire [9 : 0] doutb
    );


endmodule