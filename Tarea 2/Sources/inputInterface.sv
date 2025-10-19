`timescale 1ns / 1ps
// Módulo de interfaz de entrada con memorias, controlador de escritura, decodificador de comandos y contador de direcciones.
// Todo: Definir entradas y salidas
//       Ver qué conexiones faltan desde etapa de operaciones
//       Insertar módulo UART | EDIT: UART se conecta desde afuera
//       Conectar bien los bloques
//       Hacer una testbench

module inputInterface(
    input logic clk, reset, rx_ready,
    input logic [7:0] rx_data,
    input logic [9:0] bram_a_read_addr, bram_b_read_addr,
    output logic [9:0] bram_a_dout, bram_b_dout

    );

    logic [9:0] write_data;
    writeCtrl u_writeCtrl (
        .clk           (clk),
        .reset         (reset),
        .rx_ready      (rx_ready),
        .en            (en),
        .bram_sel      (bram_sel),
        .rx_data       (rx_data),
        .write_done    (write_done),
        .inc           (inc),
        .wea_a         (wea_a),
        .wea_b         (wea_b),
        .dout          (write_data)
    );

    logic [9:0] bram_addr;
    nbit_counter #(
        .N        (10)
    ) write_address_counter (
        .clk      (clk),
        .reset    (reset),
        .inc      (inc),
        .dec      (0),
        .count    (bram_addr)
    );
    
    commandDecoder u_commandDecoder (
        .clk            (clk),
        .rst            (rst),
        .write_done     (write_done),
        .rx_ready       (rx_ready),
        .op_done        (op_done),
        .rx_data        (rx_data),
        .bram_sel       (bram_sel),
        .command_out    (command_out)
    );

    blk_mem_gen_0 BRAMA (
        .clka(clk),    // input wire clka
        .ena(1),      // input wire ena
        .wea(wea),      // input wire [0 : 0] wea
        .addra(bram_addr),  // input wire [9 : 0] addra
        .dina(write_data),    // input wire [9 : 0] dina
        .douta(),  // output wire [9 : 0] douta
        .clkb(clk),    // input wire clkb
        .enb(1),      // input wire enb
        .web(web),      // input wire [0 : 0] web
        .addrb(address),  // input wire [9 : 0] addrb
        .dinb(0),    // input wire [9 : 0] dinb
        .doutb(bram_a_dout)  // output wire [9 : 0] doutb
    );

    blk_mem_gen_0 BRAMB (
        .clka(clk),    // input wire clka
        .ena(1),      // input wire ena
        .wea(wea),      // input wire [0 : 0] wea
        .addra(bram_addr),  // input wire [9 : 0] addra
        .dina(write_data),    // input wire [9 : 0] dina
        .douta(),  // output wire [9 : 0] douta
        .clkb(clk),    // input wire clkb
        .enb(1),      // input wire enb
        .web(web),      // input wire [0 : 0] web
        .addrb(address),  // input wire [9 : 0] addrb
        .dinb(0),    // input wire [9 : 0] dinb
        .doutb(bram_b_dout)  // output wire [9 : 0] doutb
    );


endmodule

