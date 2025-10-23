function [] = write2dev(file,BRAMX,COM)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
arguments (Input)
    file    string {mustBeFile}
    BRAMX   string {mustBeMember(BRAMX,["BRAMA","BRAMB"])}
    COM     string
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

if BRAMX == "BRAMA"
    buffer = 0b00000001;
else
    buffer = 0b10000001;
end

vector = readmatrix(file);
write(port,buffer,"uint8");

%alternativa 1 envio
write(port,vector,"uint16");

%alternativa 2 envio
%for i = 1:vector_size
%    buffer_1 = mod(vector(i),0xFF);
%    buffer_2 = vector(i)/0xFF;
%    write(port, buffer_1, "uint8");
%    write(port, buffer_2, "uint8");
%    
%end

clear port
end