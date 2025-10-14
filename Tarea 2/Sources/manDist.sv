module manDist(
    input logic [15:0]data_A,
    input logic [15:0]data_B,
    input logic enable,
    input logic ctrl,
    input logic clk,
    input logic reset,
    output logic [23:0]result
);
    
    logic [15:0]resta;
    
    always_comb begin
        if(data_A > data_B) resta = data_A - data_B;
        else resta = data_B - data_A;
    end
    
    always_ff @(posedge clk) begin
        if(reset) result <= 24'b0;
        else if(enable) begin
            if(ctrl) result <= result + resta;
            else result <= result;
        end
        else result <= 24'b0;
    end
endmodule