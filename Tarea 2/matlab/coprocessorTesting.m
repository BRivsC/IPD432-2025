clear all; % borra el workspace
clear; clc;
%% Configuracion de entorno global
N_ELEMENTS=8;  % define el numero de elementos de cada vector
BIT_WIDTH = 10;
N_TESTS = 150; % Repetición de pruebas
%PAUSE_S = 0.005;

% Configurar puerto serial
%COM_port = "/dev/ttyUSB1";
COM_port = "COM13";
vector_size = N_ELEMENTS;
baud_rate = 115200;
port = serialport(COM_port,baud_rate);
port.DataBits = 8;
port.Timeout = 0.5;
port.Parity = "none";
port.StopBits = 1;
port.FlowControl = "none";

flush(port,"input");


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Para las pruebas dinamicas, se recomienda incluir el codigo en un loop que le permita probar varias iteraciones de operaciones
for test = 1:N_TESTS
    
    %Genera vectores A y B de 1024 elementos con numeros positivos 
    %(puede adaptarse facilmente si usan negativos y positivos).
    %A=ceil(rand(N_ELEMENTS,1)*2^BIT_WIDTH);
    %B=ceil(rand(N_ELEMENTS,1)*2^BIT_WIDTH);

    % Sanity checks: todos 1 o todos 0
    A=0*ceil(rand(N_ELEMENTS,1)*2^BIT_WIDTH) + 1;
    B=0*ceil(rand(N_ELEMENTS,1)*2^BIT_WIDTH) + 1;
    for i = 1:N_ELEMENTS
        if A(i)==N_ELEMENTS
            A(i) = 0;
        end
        if B(i)==N_ELEMENTS
            B(i) = 0;
        end
    end
    
    %% Guarda vectores A y B (cada uno de una columna de 1024 filas) en un
    %archivo de texto. Cada linea del archivo contiene un elemento.
    h= fopen('vectorA.txt', 'w');
    fprintf(h, '%i\n', A);
    fclose(h);
    
    h= fopen('vectorB.txt', 'w');
    fprintf(h, '%i\n', B);
    fclose(h);
    
    % Calcula valores de referencia para las operaciones, realizadas en forma local en el host
    sumVec_host = A+B;
    avgVec_host = (A+B)/2;
    man_host = sum(abs(A-B));
    euc_host = sqrt(sum((A-B).^2));
    dot_host = dot(A,B);
    %% A partir de aca se realizan las operaciones por medio de comandos al coprocesador
    
    % Los siguientes comandos son con formato tentativo. 
    % Puede aplicar cambios menores para adaptarlos a su implementacion, lo cual debe quedar claramente documentado.
    % En cualquier caso, debe incluir solo argumentos necesarios para cada operacion. 
    % No aplique aca "parches de software" para cubrir deficiencias en el diseño de hardware.
    % No se aceptarán comentarios del tipo: "hay que poner ese argumento porque sino no funciona", sin una justificacion adecuada.
    
    %writeVec escribe un vector almacenado en un archivo de texto en la BRAM indicada por medio de la UART
    %write2dev('vectorA.txt','BRAMA',COM_port); 
    write2dev('vectorA.txt','BRAMA',port); 
    %pause(PAUSE_S)
    write2dev('vectorB.txt','BRAMB',port); 
    %pause(PAUSE_S)
    %readVec lee el contenido de la BRAM indicada por medio de la UART
    VecA_device = command2dev('readVec','BRAMA', port);
    %pause(PAUSE_S)
    VecB_device = command2dev('readVec', 'BRAMB', port);
    %pause(PAUSE_S)
    sumVec_device = command2dev('sumVec', port); %realiza la suma elemento a elemento de los vectores almacenados y envia el resultado por la UART
    %pause(PAUSE_S)
    avgVec_device = command2dev('avgVec', port);
    %pause(PAUSE_S)
    man_device = command2dev('manDist', port); %realiza el calculo de la distancia de Manhattan entre dos vectores y envia el resultado por la UART
    %pause(PAUSE_S)
    euc_device = command2dev('eucDist', port); %realiza el calculo de la distancia Euclideana entre dos vectores y envia el resultado por la UART
    %pause(PAUSE_S)
    dot_device = command2dev('dotProd', port);
    %pause(PAUSE_S)
    
    
    %% Validacion.
    % Los resultados _diff deberian ser 0 (o cercanos, dependiendo de su
    % decision de diseno en el diseno del coprocesador). Si no es 0, indique
    % claramente por que en su informe.
    
    sumVec_diff = sum(sumVec_host - sumVec_device);
    avgVec_diff = sum(avgVec_host - avgVec_device);
    man_diff = man_host - man_device;
    euc_diff = euc_host - euc_device;
    dot_diff = dot_host - dot_device;

    fprintf("Test %d:\t",test);
    %a = mean(VecA_device);
    %b = mean(VecB_device);
    %fprintf("Mean(A):%.4f\tMean(B):%.4f\t",a,b)
    %fprintf("sum_diff:%d\n", sumVec_diff);
    fprintf("sum_diff:%d\t avg_diff:%d\t man_diff:%d\t euc_diff:%.4f\t dot_diff:%d\n", sumVec_diff, avgVec_diff, man_diff, euc_diff, dot_diff);
    

end

% Cerrar puerto
clear port;
