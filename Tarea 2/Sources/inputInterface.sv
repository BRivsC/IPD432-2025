`timescale 1ns / 1ps
// Módulo de interfaz de entrada con memorias, controlador de escritura, decodificador de comandos y contador de direcciones.
// Todo: Ver qué conexiones faltan desde etapa de operaciones
//       Hacer una testbench

module inputInterface(
    input logic clk, reset, rx_ready, 
    input logic [7:0] rx_data,
    input logic [9:0] bram_a_read_addr, bram_b_read_addr,
    output logic [7:0] command, //  Sigue formato para MainCtrl (dir memoria 0A, 1B, write, read, sum, avg, euc dist, man dist y dot prod)
    output logic [9:0] bram_a_dout, bram_b_dout
    );

    logic [9:0] write_data;
    logic [9:0] write_address;
    logic [6:0] command_out;
    logic [7:0] recv_data;
    logic wea_a, wea_b, en_write, select_bram;
    assign recv_data = rx_data;
    assign en_write = command_out[6]; //  en_write desde commandDecoder
    assign command = {select_bram, command_out}; 


    writeCtrl u_writeCtrl (
        .clk           (clk),
        .reset         (reset),
        .rx_ready      (rx_ready),
        .en            (en_write),   
        .bram_sel      (select_bram),
        .rx_data       (recv_data),
        .write_done    (write_done),
        .inc           (inc),
        .wea_a         (wea_a),
        .wea_b         (wea_b),
        .dout          (write_data)
    );

    nbit_counter #(
        .N        (10)
    ) write_address_counter (
        .clk      (clk),
        .reset    (reset),
        .inc      (inc),
        .count    (write_address)
    );
    
    // Nota: op_code y bram_info vienen del byte recibido por rx_data
    // Formato: [bram_sel(1 bit)][unused(4 bits)][op_code(3 bits)]
    logic [2:0] opcode_in;
    logic bram_info;
    assign opcode_in = rx_data[2:0];
    assign bram_info = rx_data[7];
    commandDecoder u_commandDecoder (
        .clk            (clk),
        .reset          (reset),
        .write_done     (write_done),
        .rx_ready       (rx_ready),
        .op_code        (opcode_in),
        .bram_info_in   (bram_info),
        .op_done        (write_done),   //  Temporalmente conectado a write_done. Conectar a los otros done a medida que se instancien los otros módulos
        //.rx_data        (recv_data),
        .bram_sel       (select_bram),
        .command_out    (command_out) // Orden: Write, Read, Sum, Avg, Euc, Man, Dot
    );

    blk_mem_gen_0 BRAMA (
        .clka(clk),                // input wire clka
        .ena(1),                   // input wire ena
        .wea(wea_a),               // input wire [0 : 0] wea
        .addra(write_address),     // input wire [9 : 0] addra
        .dina(write_data),         // input wire [9 : 0] dina
        .douta(),                  // output wire [9 : 0] douta
        .clkb(clk),                // input wire clkb
        .enb(1),                   // input wire enb
        .web(0),                   // input wire [0 : 0] web
        .addrb(bram_a_read_addr),  // input wire [9 : 0] addrb
        .dinb(10'd0),              // input wire [9 : 0] dinb
        .doutb(bram_a_dout)        // output wire [9 : 0] doutb
    );

    blk_mem_gen_0 BRAMB (
        .clka(clk),                 // input wire clka
        .ena(1),                    // input wire ena
        .wea(wea_b),                // input wire [0 : 0] wea
        .addra(write_address),      // input wire [9 : 0] addra
        .dina(write_data),          // input wire [9 : 0] dina
        .douta(),                   // output wire [9 : 0] douta
        .clkb(clk),                 // input wire clkb
        .enb(1),                    // input wire enb
        .web(0),                    // input wire [0 : 0] web
        .addrb(bram_b_read_addr),   // input wire [9 : 0] addrb
        .dinb(10'd0),               // input wire [9 : 0] dinb
        .doutb(bram_b_dout)         // output wire [9 : 0] doutb
    );


endmodule

