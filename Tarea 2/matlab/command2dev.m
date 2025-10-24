function [vector] = command2dev(varargin)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

if nargin == 2
    operation_in = varargin{1};
    COM_in = varargin{2};
end
if nargin == 3
    operation_in = varargin{1};
    COM_in = varargin{3};
    BRAM_in = varargin{2};
end

vector_size = 1024;
baud_rate = 115200;
port = serialport(COM_in,baud_rate);
port.DataBits = 8;
port.Timeout = 0.5;
port.Parity = "none";
port.StopBits = 1;
port.FlowControl = "none";

flush(port,"input");

switch operation_in
    case "readVec"
        if BRAM_in == "BRAMA"
            instruction = 0b00000010;
        else
            instruction = 0b10000010;
        end
        write(port,instruction,"uint8");
        % Read the vector data from the specified BRAM
        vector = transpose(read(port, vector_size, "uint16"));
    case "sumVec"
        instruction = 0b00000011;
        write(port,instruction,"uint8");
        vector = transpose(read(port, vector_size, "uint16"));
    case "avgVec"
        instruction = 0b00000100;
        write(port,instruction,"uint8");
        vector = transpose(read(port, vector_size, "uint16"));
        for i = 1:1024
            if vector(i)>1024
                vector(i) = vector(i) - 32767.5;
            end
        end
    case "eucDist"
        instruction = 0b00000101;
        write(port,instruction,"uint8");
        vector = transpose(read(port, 1, "uint16"));
    case "manDist"
        instruction = 0b00000110;
        write(port,instruction,"uint8");
        vector = transpose(read(port, 1, "uint32"));
    case "dotProd"
        instruction = 0b00000111;
        write(port,instruction,"uint8");
        vector = transpose(read(port, 1, "uint32"));
end

% Close the serial port connection after operation
clear port;
end