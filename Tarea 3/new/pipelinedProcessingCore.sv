`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/11/2025 11:28:27 PM
// Design Name: 
// Module Name: pipelinedProcessingCore
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: Recibe datos en paralelo y los retorna serial
// 
//////////////////////////////////////////////////////////////////////////////////


module pipelinedProcessingCore #(
    parameter IWIDTH = 10,
    parameter NINPUTS = 1024
)(
    input [IWIDTH-1:0] data_A [NINPUTS-1:0],
    input [IWIDTH-1:0] data_B [NINPUTS-1:0],
    input [5:0] enables,
    input ctrl,
    input clk,
    input reset,
    // nuevos: para pipeline
    //// lectura de memorias
    input read_mem_sel,
    //// manejo de memoria
    //input load_piso, shift_mem,
    //input update_man,

    output logic [31:0] par_result [NINPUTS-1:0], // Vectores resultado en paralelo
    output logic [31:0] man_result, // Resultado de manhattan como escalar
    output logic op_done
    );

    localparam OWIDTH = IWIDTH + $clog2(NINPUTS);
    
    logic [IWIDTH-1:0]result_read [NINPUTS-1:0];
    logic [IWIDTH-1:0]result_sum  [NINPUTS-1:0];
    logic [IWIDTH-1:0]result_avg  [NINPUTS-1:0];
    logic [IWIDTH-1:0]result_resta[NINPUTS-1:0];

    //logic [15:0]result_euc;
    //logic [23:0]result_man;
    logic [OWIDTH - 1:0]result_man;
    logic [OWIDTH - 1:0]result_man_ff;
    //logic [31:0]result_dot;
    logic [5:0] enables_ff;

    logic [IWIDTH-1:0]par_result [NINPUTS-1:0]; // Resultado en paralelo para read, sum y avg
    logic [IWIDTH-1:0]ser_result; // Resultado en serie para man

    // Lectura: escoger memoria a leer
    always_comb begin
        if (read_mem_sel) begin
            result_read = data_A;
        end else begin
            result_read = data_B;
        end
    end

    // Suma por elementos, usada x sum y avg
    // Revisar si me conviene más comb o ff!
    // En teoría toma 1 ciclo
    //always_comb begin
    always_ff @(posedge clk) begin
        for (int i = 0; i < NINPUTS; i++)
            //result_sum[i] = data_A[i] + data_B[i];
            result_sum[i] <= data_A[i] + data_B[i];
    end

    // División por 2, usada solo por avg
    // Acá me aprovecho de los sumadores ya existentes
    // En teoría agrega 1 ciclo a lo ya obtenido con la suma
    genvar i;
    generate
        for (i = 0; i < NINPUTS; i++) begin
            always_ff @(posedge clk) begin
                result_avg[i] <= result_sum[i] >> 1; // Dividir por 2 es un shift a la derecha!
            end
        end
    endgenerate

    // Definir qué op en paralelo se va a la memoria PISO
    for (i = 0; i < NINPUTS; i++) begin
        always_comb begin
            if(enables[0]) par_result[i] =  result_read[i];
            else if(enables[1]) par_result[i] =  result_sum[i];
            else if(enables[2]) par_result[i] = result_avg[i];
            else par_result[i] = 'h0000;
        end
    end

    // Memoria PISO para ops paralelas
    pisoMem #(
        .IWIDTH     (IWIDTH),
        .NINPUTS    (NINPUTS)
    ) PISO (
        .clk        (clk),
        .load       (load),
        .en         (shift_mem),
        .in         (par_result),
        .out        (ser_result)
    );

    // Resta por elementos, usada x man
    // Revisar si me conviene más comb o ff!
    // En teoría toma 1 ciclo
    always_ff @(posedge clk) begin
        for (int i = 0; i < NINPUTS; i++) begin
            if (data_A[i] > data_B[i])
                result_resta[i] <= data_A[i] - data_B[i];
            else
                result_resta[i] <= data_B[i] - data_A[i];
        end
    end


    // Suma de resultados de resta
    AdderTree #(
        .IWIDTH     (IWIDTH),
        .NINPUTS    (NINPUTS)
    ) u_AdderTree (
        .clk        (clk),
        .data       (result_resta),
        .out        (result_man)
    );

    // Registro para Manhattan
    always_ff @(posedge clk) begin
        if (update_man) begin
            result_man_ff <= result_man;
        end
    end

    

    // Mux del final: escoger entre resultado serial y paralelo
    always_comb begin 
        if (enables[4]) begin // serial para man
            result = ser_result;
        end else begin // paralelo para el resto
            result = result_man_ff;
        end

    end
    /*
    always_comb begin
        if(enables[0]) result = {16'h00 , result_read};
        else if(enables[1]) result = {16'h00 , result_sum};
        else if(enables[2]) result = {16'h00 , result_avg};
        else if(enables[3]) result = {16'h00 , result_euc};
        else if(enables[4]) result = {8'h0 , result_man};
        else if(enables[5]) result = result_dot;
        else result = 32'h0000;
    end
    */


    /*

    always_ff @(posedge clk) begin: sel_operacion
        enables_ff <= enables;
        case (enables_ff) // {dot,man,euc,avg,sum,read}
            6'd1: begin // lectura
                if(ctrl) 
                    par_result <= data_A;
                else 
                    par_result <= data_B; 
            end

            6'd2: begin // suma por elemento
                for (int i=0; i < NINPUTS; i++) begin
                    par_result
                end
            end

            default: begin
                //default_case
            end
        endcase

        
    end: sel_operacion
*/

    /*
    readVec read(
    .data_A(data_A),
    .data_B(data_B),
    .enable(enables[0]),
    .ctrl(ctrl),
    .clk(clk),
    .reset(reset),
    .result(result_read));

    sumVec sum(
    .data_A(data_A),
    .data_B(data_B),
    .enable(enables[1]),
    .clk(clk),
    .reset(reset),
    .result(result_sum)
    );

    avgVec avgV(
    .data_A(data_A),
    .data_B(data_B),
    .enable(enables[2]),
    .clk(clk),
    .reset(reset),
    .result(result_avg)
    );
    
    eucDist #(.NINPUTS(NINPUTS))euc(
    .data_A(data_A),
    .data_B(data_B),
    .enable(enables[3]),
    .ctrl(ctrl),
    .clk(clk),
    .reset(reset),
    .op_done(op_done),
    .result(result_euc)
    );

    manDist man(
    .data_A(data_A),
    .data_B(data_B),
    .enable(enables[4]),
    .ctrl(ctrl),
    .clk(clk),
    .reset(reset),
    .result(result_man)
    );
    
    dotProd dot(
    .data_A(data_A),
    .data_B(data_B),
    .enable(enables[5]),
    .ctrl(ctrl),
    .clk(clk),
    .reset(reset),
    .result(result_dot)
    );

    */

endmodule
