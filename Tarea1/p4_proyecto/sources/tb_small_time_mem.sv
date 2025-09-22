`timescale 1ns/1ps

module tb_small_time_mem();
    logic clk;
    logic rst;
    logic add_second;
    logic [3:0] s_units;
    logic [3:0] s_tens;

    time_mem DUT (
        .add_second    (clk),
        .config_en     (config_en),
        .clk           (clk),
        .rst           (rst),
        .s_tens        (s_tens),
        .s_units       (s_units)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        add_second = 0;

        #12;
        rst = 0;
        #100

        $finish;
    end

endmodule
