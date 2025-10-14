//lee info de un bloque de memoria. se indica cual por un input. Control unit
//se encarga de seleccionar esta. demora 1 ciclo de reloj en sacar resultado
module readVec(
    input logic [15:0]data_A,
    input logic [15:0]data_B,
    input logic enable,
    input logic ctrl,
    input logic clk,
    input logic reset,
    output logic [15:0]result
    );
    
    always_ff @(posedge clk)begin
        if(reset) result <= 16'h0;
        else if(enable) begin
            if(ctrl) result <= data_A;
            else result <= data_B;
        end
        else result <= 16'h0;
    end
    
endmodule