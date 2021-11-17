`timescale 1ns / 1ps
module Data_Memory(
    input clk,
    input reset,
    input MemWrite,
    input [0:0] Address,
    input [31:0] StoreData,
    output [31:0] ReadData
    );
reg[31:0] RAM[0:1024];
always@* begin
    RAM[1] = 8'h00000001;
    RAM[2] = 8'h00000002;
    RAM[3] = 8'h00000003;
end

always @(posedge clk) begin
    if (MemWrite) begin
        RAM[Address]  <= ReadData;
    end        
end

assign ReadData = RAM[Address];

endmodule

