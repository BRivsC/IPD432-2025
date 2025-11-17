`timescale 1ns/1ps

module tb_ctrl_proce;

    localparam NINPUTS = 8;

    // ===============================
    // Señales del sistema
    // ===============================
    logic clk;
    logic reset;

    // Señales del control
    logic command_ready;
    logic write_done;
    logic tx_sent;
    logic [7:0] command;

    // Señales de salida del control
    logic begin_transmission;
    logic begin_write;
    logic read_mem_sel;
    logic shift_mem;
    logic load_mem;
    logic [5:0] enables;

    // Datos del core
    logic [9:0] data_A [NINPUTS-1:0];
    logic [9:0] data_B [NINPUTS-1:0];

    logic [31:0] par_result [NINPUTS-1:0];
    logic [31:0] man_result;

    // ===============================
    // Instancias
    // ===============================

    pipelinedProcessingCore #(
        .NINPUTS(NINPUTS)
    ) u_core (
        .data_A(data_A),
        .data_B(data_B),
        .enables(enables),
        .clk(clk),
        .read_mem_sel(read_mem_sel),
        .par_result(par_result),
        .man_result(man_result)
    );

    pipelineCtrlUnit #(
        .NUM_ELEMENTOS(NINPUTS)
    ) u_ctrl (
        .clk(clk),
        .reset(reset),
        .command_ready(command_ready),
        .write_done(write_done),
        .tx_sent(tx_sent),
        .command(command),
        .begin_transmission(begin_transmission),
        .begin_write(begin_write),
        .read_mem_sel(read_mem_sel),
        .shift_mem(shift_mem),
        .load_mem(load_mem),
        .enables(enables)
    );

    // ===============================
    // Reloj
    // ===============================
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // ===============================
    // Estímulos
    // ===============================
    initial begin
        integer i;

        // Inicialización
        reset = 1;
        command_ready = 0;
        write_done = 0;
        tx_sent = 0;
        command = 8'b0;

        // Cargar valores simples en A y B
        for (i = 0; i < NINPUTS; i++) begin
            data_A[i] = i;         // 0,1,2,3...
            data_B[i] = 10 + i;    // 10,11,12...
        end

        // Liberar reset
        #20;
        reset = 0;

        // ===============================
        // Enviar comando SUM (command[2] = 1)
        // command = [0A, 1B, SUM, AVG, EUC, MAN, DOT, (unused)]
        //           bit0 bit1 bit2 bit3 bit4 bit5 bit6 bit7
        // SUM = 0000_0100
        // ===============================
        @(posedge clk);
        command = 8'b0000_0100;
        command_ready = 1;

        @(posedge clk);
        command_ready = 0;

        // FSM ahora va a SUM -> STORE -> SENDING -> SHIFT_MEM ...
        // Simulemos tx_sent para avanzar estados
        repeat (5) begin
            #15 tx_sent = 1;
            #10 tx_sent = 0;
        end

        // ===============================
        // Mostrar resultados después de la operación
        // ===============================
        #50;
        $display("\n--- Resultados SUM ---");
        for (i = 0; i < NINPUTS; i++)
            $display("par_result[%0d] = %0d", i, par_result[i]);

        $display("man_result = %0d", man_result);

        #40;
        $finish;
    end

endmodule
