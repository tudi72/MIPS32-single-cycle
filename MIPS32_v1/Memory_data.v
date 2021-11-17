`timescale 1ns / 1ps
module Memory_data(
    input clk,
    input reset,
    input MemWrite,
    input MemToReg,
    input BranchJal,
    input BranchJalr,
    input auipc,
    input[31:0] ALUOut,
    input[31:0] rs2,
    input[31:0] PC,
    input[31:0] PC_4,
    input[31:0] ReadData,
    output[31:0] Res     
    );

// declaring varriables 
reg[31:0] res_temp_mux = 8'h00000000;
reg[31:0] res_temp = 8'h00000000;

// read data from memory 
assign Res = (reset == 1)?8'h00000000:res_temp;
assign Res = (reset == 1)?8'h00000000:res_temp;


// mux for branch and link
always@(auipc,BranchJal,BranchJalr,PC,ALUOut) begin
    if (auipc) begin
        res_temp_mux <= PC;
    end else if (BranchJal | BranchJalr) begin
        res_temp_mux <= PC_4;
    end else begin
        res_temp_mux <= ALUOut;
    end
end


// mux choosing if send memory or execution data
always@(MemToReg,ReadData,ALUOut) begin
    if (MemToReg) begin
        res_temp <= ReadData;
    end else begin
        res_temp <= res_temp_mux;
    end
end
endmodule   