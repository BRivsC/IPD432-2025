`timescale 1ns/1ps

module tb_core_ctrl;

    // Parámetros
    localparam NINPUTS = 8;

    logic clk, rst;
    logic read_mem_sel;
    logic [5:0] enables;
    logic [9:0] data_A [NINPUTS-1:0];
    logic [9:0] data_B [NINPUTS-1:0];
	logic command_ready;
	logic write_done;
	logic tx_sent;
	logic command;
	logic begin_transmission;
	logic begin_write;
	logic read_mem_sel;
	logic shift_mem;
	logic load_mem;
	logic enables;

    logic [31:0] par_result [NINPUTS-1:0];
    logic [31:0] man_result;

    pipelinedProcessingCore #(
        .NINPUTS(NINPUTS)
	) core_dut (
        .data_A(data_A),
        .data_B(data_B),
        .enables(enables),
        .clk(clk),
        .read_mem_sel(read_mem_sel),
        .par_result(par_result),
        .man_result(man_result)
    );

	pipelineCtrlUnit #(
		.NUM_ELEMENTOS         (NINPUTS)
		) ctrl_dut (
		.clk                   (clk),
		.reset                 (rst),
		.command_ready         (command_ready),
		.write_done            (write_done),
		.tx_sent               (tx_sent),
		.command               (command),
		.begin_transmission    (begin_transmission),
		.begin_write           (begin_write),
		.read_mem_sel          (read_mem_sel),
		.shift_mem             (shift_mem),
		.load_mem              (load_mem),
		.enables               (enables),
	);

    initial clk = 0;
    always #1 clk = ~clk;

    string prueba; // Para facilitarme la lectura en la simulación
    initial begin
        integer i;
        prueba = "Ini";
        // Inicializaciones
        read_mem_sel = 0;
        enables      = 6'b000000; // Nada habilitado inicialmente

        // Esperar algunos ciclos
        #20;

        /*
        // Activar lectura (enables[0])
        enables = 6'b000001;
        prueba = "Read";
        // Caso 1: Sanity check
        for (i = 0; i < NINPUTS; i++) begin
            data_A[i] = 0;
            data_B[i] = 0;
        end

        // Leer A
        #50 read_mem_sel = 0;
        prueba = "Read A";

        // Leer B
        #50 read_mem_sel = 1;
        prueba = "Read B";
        
        for (i = 0; i < NINPUTS; i++) begin
            data_A[i] = 1;
            data_B[i] = 0;
        end

        // Leer A
        #50 read_mem_sel = 0;
        prueba = "Read A";

        // Leer B
        #50 read_mem_sel = 1;
        prueba = "Read B";


        #20

        for (i = 0; i < NINPUTS; i++) begin
            data_A[i] = 1;
            data_B[i] = 1;
        end

        // Leer A
        #50 read_mem_sel = 0;
        prueba = "Read A";

        // Leer B
        #50 read_mem_sel = 1;
        prueba = "Read B";


        #30 

        // Caso 2: Cargar valores simples
        for (i = 0; i < NINPUTS; i++) begin
            data_A[i] = i;            // 0,1,2,3,...
            data_B[i] = (i+1)*2;      // 2,4,6,8,...
        end


        // Leer A
        #50 read_mem_sel = 0;
        prueba = "Read A";

        // Leer B
        #50 read_mem_sel = 1;
        prueba = "Read B";

        #30 
        
        // Caso 3: Cargar valores extremos
        for (i = 0; i < NINPUTS; i++) begin
            data_A[i] = 'h3FF;
            data_B[i] = 'h3FF;
        end


        // Leer A
        #50 read_mem_sel = 0;
        prueba = "Read A";

        // Leer B
        #50 read_mem_sel = 1;
        prueba = "Read B";


        #10 read_mem_sel = 0;
        #100;
        
*/


        /// Pruebas de suma
        // Activar suma (enables[1])
        enables = 6'b000010;

        // Caso 1: Sanity check
        for (i = 0; i < NINPUTS; i++) begin
            data_A[i] = 0;
            data_B[i] = 0;
        end
        prueba = "Sum sanity check";
        #20

        for (i = 0; i < NINPUTS; i++) begin
            data_A[i] = 1;
            data_B[i] = 0;
        end

        #20

        for (i = 0; i < NINPUTS; i++) begin
            data_A[i] = 1;
            data_B[i] = 1;
        end

        #30 

        // Caso 2: Cargar valores simples
        for (i = 0; i < NINPUTS; i++) begin
            data_A[i] = i;            // 0,1,2,3,...
            data_B[i] = (i+1)*2;      // 2,4,6,8,...
        end
        prueba = "Sum val simples";
        #30 
        
        // Caso 3: Cargar valores extremos
        for (i = 0; i < NINPUTS; i++) begin
            data_A[i] = 'h3FF;
            data_B[i] = 'h3FF;
        end
        prueba = "Sum extremos";


        #100;
        
        
        /// Pruebas de promedio
        // Esperar algunos ciclos
        #20;

        // Activar promedio (enables[2])
        enables = 6'b000100;
        $display("\n=== Ejecutando promedio ===");

        // Caso 1: Sanity check
        for (i = 0; i < NINPUTS; i++) begin
            data_A[i] = 0;
            data_B[i] = 0;
        end
        prueba = "Avg sanity check";

        #20

        for (i = 0; i < NINPUTS; i++) begin
            data_A[i] = 1;
            data_B[i] = 0;
        end

        #20

        for (i = 0; i < NINPUTS; i++) begin
            data_A[i] = 1;
            data_B[i] = 1;
        end

        #30 

        // Cargar valores simples
        for (i = 0; i < NINPUTS; i++) begin
            data_A[i] = i;            // 0,1,2,3,...
            data_B[i] = (i+1)*2;      // 2,4,6,8,...
        end
        prueba = "Avg val simples";
        #30 
        
        // Cargar valores extremos
        for (i = 0; i < NINPUTS; i++) begin
            data_A[i] = 'h3FF;
            data_B[i] = 'h3FF;
        end
        prueba = "Avg extremos";
        # 50
        for (i = 0; i < NINPUTS; i++) begin
            data_A[i] = 1;
            data_B[i] = 0;
        end
        #200

        $finish;
    end

endmodule
