function [vector] = command2dev(operation,COM,BRAM)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
arguments (Input)
    operation string {mustBeMember(operation,["ReadVec","SumVec","AvgVec","EucDist","ManDist","DotProd"])}
    COM string
    BRAM string {mustBeMember(BRAM,["BRAMA","BRAMB"])} = "BRAMA"
end

arguments (Output)
    vector
end

vector_size = 1024;
baud_rate = 115200;
port = serialport(COM,baud_rate);
port.DataBits = 8;
port.Timeout = 0.5;
port.Parity = "none";
port.StopBits = 1;
port.FlowControl = "none";

flush(port,"input");

switch operation
    case "ReadVec"
        if BRAM == "BRAMA"
            instruction = 0b00000010;
        else
            instruction = 0b10000010;
        end
        write(port,instruction,"uint8");
        % Read the vector data from the specified BRAM
        vector = read(port, vector_size, "uint16");
    case "SumVec"
        instruction = 0b00000100;
        write(port,instruction,"uint8");
        vector = read(port, vector_size, "uint16");
    case "AvgVec"
        instruction = 0b00001000;
        write(port,instruction,"uint8");
        vector = read(port, vector_size, "uint16");
    case "EucDist"
        instruction = 0b00010000;
        write(port,instruction,"uint8");
        vector = read(port, vector_size, "uint32");
    case "ManDist"
        instruction = 0b00100000;
        write(port,instruction,"uint8");
        vector = read(port, vector_size, "uint32");
    case "DotProd"
        instruction = 0b01000000;
        write(port,instruction,"uint8");
        vector = read(port, vector_size, "uint32");
end

% Close the serial port connection after operation
clear port;
end