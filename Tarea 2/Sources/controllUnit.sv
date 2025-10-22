`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/11/2025 11:28:27 PM
// Design Name: 
// Module Name: controllUnit
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


module controllUnit #(parameter NUM_ELEMENTOS = 1024)(
    input logic clk,//reloj 100Mhz
    input logic reset,//reset sincronizado
    input logic command_ready,//señal para cambiar de comando de IDLE a una operacion
    input logic write_done,//señal que indica que se termino toda la operacion de escritura
    input logic tx_sent,//señal de que se envio un dato completo
    input logic op_ready,//señal de que la operacion euc dist esta lista
    input logic [7:0] command,//dir memoria 0A, 1B, dot prod, man dist, euc dist, avg, sum, read y write. En ese orden
    output logic process_ctrl,//seña para varios controles del processing core
    output logic read_enable,//enable para las memorias para leer
    output logic begin_transmision,//señal para iniciar la transmision cuando hay un resultado listo
    output logic begin_write,//señal para empezar la escritura
    output logic [5:0] enables,//arreglo de enables para las distintas operaciones. Mismo orden que command
    output logic [9:0] mem_dir//direccion de memoria a leer
    );
    
    logic [7:0]operation;//operacion a realizar memoria activa, WRITE,READ, SUM, AVG,EUCDIST
    //MANDIST Y DOTPROD
    enum logic [8:0] {IDLE, WRITE, READ, SUM, AVG, EUC_DIST, MAN_DIST, DOT_PROD, SENDING} STATE, NEXT_STATE = IDLE;
    logic [9:0]counter ,counter_next/*, counter_sync*/;
    logic [10:0]t;//timer para operaciones de estado
    //logic read_block;//bloquea el cambio de estado por 1 tick al activarse.
    
    always_ff @(posedge clk)begin
        if(reset) begin
            STATE <= IDLE;
            operation <= 8'h0;
        end
        else begin
            STATE <= NEXT_STATE;
            counter <= counter_next;
            if(STATE == IDLE & command_ready) operation <= command;
        end
    end
    
    always_ff @(posedge clk) begin
        if(reset) t <= 11'b0;
        else if (STATE != NEXT_STATE) t <= 11'b0;
        else t <= t + 1;
    end
    
//    always_ff @(posedge clk) begin
//        if(reset) begin
//            ena <= 1'b0;
//            enb <= 1'b0;
//            mem_dir <= 10'b0;
//        end
//        else begin
//            wea <= 1'b0;
//            web <= 1'b0;
//            case(STATE)
//                IDLE: begin
//                    if(t >= 2) begin//teimpo que necesita la memoria para escribir tras acabar write.
//                        ena <= 1'b0;
//                        enb <= 1'b0;
//                    end
//                    counter_sync <= 0;
//                end
            
//                WRITE: begin
//                    ena <= ~operation[7];
//                    enb <= operation[7];
//                    if(data_ready/* & ~read_block*/)begin
//                        mem_dir <= counter_sync[9:0];
//                        web <= operation[7];
//                        wea <= ~operation[7];
//                        counter_sync <= counter_sync + 1;
//                    end
//                end
            
//                READ: begin
//                    mem_dir <= counter[9:0];
//                    ena <= ~operation[7];
//                    enb <= operation[7];
//                end
            
//                SUM: begin
//                    mem_dir <= counter[9:0];
//                    ena <= 1'b1;
//                    enb <= 1'b1;
//                end
            
//                AVG: begin
//                    mem_dir <= counter[9:0];
//                    ena <= 1'b1;
//                    enb <= 1'b1;
//                end
            
//                EUC_DIST: begin
//                    mem_dir <= counter[9:0];
//                    ena <= 1'b1;
//                    enb <= 1'b1;
//                end
            
//                MAN_DIST: begin
//                    mem_dir <= counter[9:0];
//                    ena <= 1'b1;
//                    enb <= 1'b1;
//                end
            
//                DOT_PROD: begin
//                    mem_dir <= counter[9:0];
//                    ena <= 1'b1;
//                    enb <= 1'b1;
//                end
//            endcase
//        end
//    end
    
    always_comb begin
        NEXT_STATE = STATE;
        mem_dir = 10'b0;
        read_enable = 1'b0;
        begin_write = 1'b0;
//        wea = 1'b0;
//        web = 1'b0;
        process_ctrl = 1'b0;
        counter_next = counter;
        //ena = 1'b0;
        //enb = 1'b0;
        begin_transmision = 1'b0;
        enables = 6'b0;
        //read_block = 1'b0;
        case(STATE)
            IDLE: begin
                //ena = 1'b0;
                //enb = 1'b0;
                if(command_ready)begin
                    counter_next = 11'b0;
                    if(command[0]) begin
                        NEXT_STATE = WRITE;
                        begin_write = 1'b1;
                    end
                    else if(command[1]) NEXT_STATE = READ;
                    else if(command[2]) NEXT_STATE = SUM;
                    else if(command[3]) NEXT_STATE = AVG;
                    else if(command[4]) NEXT_STATE = EUC_DIST;
                    else if(command[5]) NEXT_STATE = MAN_DIST;
                    else if(command[6]) NEXT_STATE = DOT_PROD;
                end
            end
            
            WRITE: begin//cambiar a realizar operacioness de estructura cada 2 rx_ready
                
                if(write_done) NEXT_STATE = IDLE;
//                if(write_done)begin
//                    read_block = 1'b0;
//                    mem_dir = counter[10:1];
//                    ena = ~counter[0];
//                    enb = counter[0];
//                    web = counter[0];
//                    wea = ~counter[0];
//                    if(counter_sync >= NUM_ELEMENTOS - 1) begin
//                        NEXT_STATE = IDLE;
//                        state_change_block = 1'b1;
//                    end
//                    else counter_next = counter + 1;
//                end
            end
            
            READ: begin
//                mem_dir = counter[10:1];
//                ena = ~counter[0];
//                enb = counter[0];
                read_enable = 1'b1;
                enables = 6'b000001;
                mem_dir = counter;
                process_ctrl = ~operation[7];
                if(t >= 4) begin
                    NEXT_STATE = SENDING;
                    begin_transmision = 1'b1;
                end
            end
            
            SUM: begin
//                mem_dir = counter[9:0];
//                ena = 1'b1;
//                enb = 1'b1;
                enables = 6'b000010;
                read_enable = 1'b1;
                mem_dir = counter;
                if(t >= 4) begin
                    NEXT_STATE = SENDING;
                    begin_transmision = 1'b1;
                end
            end
            
            AVG: begin
//                mem_dir = counter[9:0];
//                ena = 1'b1;
//                enb = 1'b1;
                enables = 6'b000100;
                read_enable = 1'b1;
                mem_dir = counter;
                if(t >= 4) begin
                    NEXT_STATE = SENDING;
                    begin_transmision = 1'b1;
                end
            end
            
            EUC_DIST: begin
//                mem_dir = counter[9:0];
//                ena = 1'b1;
//                enb = 1'b1;
                enables = 6'b001000;
                read_enable = 1'b1;
                mem_dir = counter;
                if(t >= 2) counter_next = counter + 1;//corresponde al delay desde que se cambia la dir de memoria y cambia el valor en la funcion
                if(t >= 4) process_ctrl = 1'b1;//tiempo entre el inicio y cuando la memoria empieza a cambiar (justo el tick antes)
                if(counter >= NUM_ELEMENTOS - 1) begin
                    counter_next = counter;
                    if(t >= NUM_ELEMENTOS + 4) process_ctrl = 1'b0;//se ajusta para que la ventana del proceso tenga el ancho del numero de elementos
                end
                if(op_ready) begin
                    NEXT_STATE = SENDING;
                    begin_transmision = 1'b1;
                end
            end
            
            MAN_DIST: begin
//                mem_dir = counter[9:0];
//                ena = 1'b1;
//                enb = 1'b1;
                enables = 6'b010000;
                read_enable = 1'b1;
                mem_dir = counter;
                if(t >= 1) counter_next = counter + 1;
                if(t >= 3) process_ctrl = 1'b1;
                if(counter >= NUM_ELEMENTOS - 1) counter_next = counter;
                if(t >= NUM_ELEMENTOS + 3) begin
                    process_ctrl = 1'b0;
                    NEXT_STATE = SENDING;
                    begin_transmision = 1'b1;
                end
            end
            
            DOT_PROD: begin
//                mem_dir = counter[9:0];
//                ena = 1'b1;
//                enb = 1'b1;
                enables = 6'b100000;
                read_enable = 1'b1;
                mem_dir = counter;
                if(t >= 1) counter_next = counter + 1;
                if(t >= 3) process_ctrl = 1'b1;
                if(counter >= NUM_ELEMENTOS - 1) counter_next = counter;
                if(t >= NUM_ELEMENTOS + 3) begin
                    process_ctrl = 1'b0;
                    NEXT_STATE = SENDING;
                    begin_transmision = 1'b1;
                end
            end
            
            SENDING: begin
                begin_transmision = 1'b0;
                read_enable = 1'b1;
                mem_dir = counter;
                if(operation[1]) begin//readVec
                    enables = 6'b000001;
                    process_ctrl = ~operation[7];
                    if(tx_sent) begin//debe de ocuparse el canal en el tick siguiente
                        NEXT_STATE = READ;
                        counter_next = counter + 1;
                        if(counter >= NUM_ELEMENTOS - 1) NEXT_STATE = IDLE;
                    end
                end
                
                if(operation[2]) begin//sumVec
                    enables = 6'b000010;
                    if(tx_sent) begin
                        NEXT_STATE = SUM;
                        counter_next = counter + 1;
                        if(counter >= NUM_ELEMENTOS - 1) NEXT_STATE = IDLE;
                    end
                end
                
                if(operation[3]) begin//avgVec
                    enables = 6'b000100;
                    if(tx_sent) begin
                        NEXT_STATE = AVG;
                        counter_next = counter + 1;
                        if(counter >= NUM_ELEMENTOS - 1) NEXT_STATE = IDLE;
                    end
                end
                
                if(operation[4]) begin//euc dist
                    enables = 6'b001000;
                    if(tx_sent) begin
                        NEXT_STATE = IDLE;
                    end
                end
                if(operation[5]) begin//man dist
                    enables = 6'b010000;
                    if(tx_sent) begin
                        NEXT_STATE = IDLE;
                    end
                end
                if(operation[6]) begin//prod punto
                    enables = 6'b100000;
                    if(tx_sent) begin
                        NEXT_STATE = IDLE;
                    end
                end
            end
            
            default: NEXT_STATE = IDLE;
        endcase
    end
endmodule
