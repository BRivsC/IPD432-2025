`timescale 1ns/1ps
// Adder tree
// Sigue la estructura del ejemplo:
//  sum(0) --|\  sum(8)
//           |+|--------|\
//  sum(1) --|/         | | sum(12)
//                      |+|---------|\
//  sum(2) --|\	 sum(9) | |         | |
//           |+|--------|/          | |
//  sum(3) --|/                     | | sum(14)
//                                  |+|--------- out
//  sum(4) --|\	 sum(10)            | |
//           |+|--------|\          | |
//  sum(5) --|/			| | sum(13) | |
//						|+|---------|/
//  sum(6) --|\	 sum(11)| |
//           |+|--------|/
//  sum(7) --|/
//

module AdderTree #(
    parameter IWIDTH = 10,      
    parameter NINPUTS = 8       
)(
    input  logic clk,
    input  logic [IWIDTH-1:0] data [0:NINPUTS-1], 
    output logic [31:0] out  
);

    // Nro de niveles y ancho de salida
    localparam NLEVELS = $clog2(NINPUTS); 
    localparam OWIDTH = IWIDTH + $clog2(NINPUTS);

    // Señales internas para cada nivel
    logic [OWIDTH-1:0] sum [(2*NINPUTS)-2:0];  // Array de sumas

    // Primer nivel: asignar las entradas directamente
    genvar i, j;
    generate
        for (i = 0; i < NINPUTS; i++) begin 
            always_ff @(posedge clk) begin : level_0
                sum[i] <= {{(OWIDTH - IWIDTH){1'b0}},data[i]};
            end
        end
    endgenerate

    // Generar los niveles sucesivos
    generate
        for (i = 0; i < NLEVELS; i++) begin : level
            for (j = 0; j < (NINPUTS >> (i+1)); j++) begin : suma
                always_ff @(posedge clk) begin
                    sum[2*NINPUTS - (NINPUTS >> i) + j] <= sum[2*NINPUTS - (2*NINPUTS >> i) + 2*j] + sum[2*NINPUTS - (2*NINPUTS >> i) + 2*j + 1];
                end
            end
        end
    endgenerate

    // La salida es el resultado de la última suma en el último nivel
    always_ff @(posedge clk) begin
        out <= sum[(2*NINPUTS)-2];
    end

endmodule
