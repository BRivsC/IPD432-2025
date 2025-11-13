clear all; % borra el workspace

%% Configuracion de entorno global
N_ELEMENTS=1024;  % define el numero de elementos de cada vector
BIT_WIDTH = 10;

NUM_REP = 100;

% Configurar puerto serial
%COM_port = "/dev/ttyUSB1";
COM_port = "COM7";
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Para las pruebas dinamicas, se recomienda incluir el codigo en un loop que le permita probar varias iteraciones de operaciones

%Genera vectores A y B de 1024 elementos con numeros positivos 
%(puede adaptarse facilmente si usan negativos y positivos).

VecA_diff = zeros(N_ELEMENTS,NUM_REP);
VecB_diff = zeros(N_ELEMENTS,NUM_REP);
sumVec_diff = zeros(N_ELEMENTS,NUM_REP);
avgVec_diff = zeros(N_ELEMENTS,NUM_REP);
euc_diff = zeros(NUM_REP,1);
man_diff = zeros(NUM_REP,1);
dot_diff = zeros(NUM_REP,1);


for n = 1:NUM_REP
    

A=ceil(rand(N_ELEMENTS,1)*2^BIT_WIDTH);
B=ceil(rand(N_ELEMENTS,1)*2^BIT_WIDTH);
for i = 1:1024
    if A(i)==1024
        A(i) = 0;
    end
    if B(i)==1024
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
write2dev('vectorA.txt','BRAMA',COM_port); 
write2dev('vectorB.txt','BRAMB',COM_port); 

%readVec lee el contenido de la BRAM indicada por medio de la UART
VecA_diff(:,n) = command2dev('readVec','BRAMA', COM_port)-A;
VecB_diff(:,n) = command2dev('readVec', 'BRAMB', COM_port)-B;

sumVec_device = command2dev('sumVec', COM_port); %realiza la suma elemento a elemento de los vectores almacenados y envia el resultado por la UART
avgVec_device = command2dev('avgVec', COM_port);
man_device = command2dev('manDist', COM_port); %realiza el calculo de la distancia de Manhattan entre dos vectores y envia el resultado por la UART
euc_device = command2dev('eucDist', COM_port); %realiza el calculo de la distancia Euclideana entre dos vectores y envia el resultado por la UART
dot_device = command2dev('dotProd', COM_port);

%% Validacion.
% Los resultados _diff deberian ser 0 (o cercanos, dependiendo de su
% decision de diseno en el diseno del coprocesador). Si no es 0, indique
% claramente por que en su informe.

sumVec_diff(:,n) = sum(sumVec_host - sumVec_device);
avgVec_diff(:,n) = sum(avgVec_host - avgVec_device);
man_diff(n) = man_host - man_device;
euc_diff(n) = euc_host - euc_device;
dot_diff(n) = dot_host - dot_device;

end

fprintf("Error max lectura A = %d\n",max(max(VecA_diff)));
fprintf("Error max lectura B = %d\n",max(max(VecB_diff)));
fprintf("Error max suma = %d\n",max(max(sumVec_diff)));
fprintf("Error max avg = %d\n",max(max(avgVec_diff)));
fprintf("Error max man = %d\n",max(man_diff));
fprintf("Error max euc = %4f\n",max(euc_diff));
fprintf("Error max dot = %d\n",max(dot_diff));