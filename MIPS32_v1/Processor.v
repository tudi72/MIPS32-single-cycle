`timescale 1ns / 1ps

module Processor(input clk,
                input reset,
                input [31:0] Instruction,
                input [31:0] data_from_mem,
                output WE,
                output[31:0] PC,
                output[31:0] data_to_mem,
                output[31:0] address_to_mem);

wire zero,BranchJalr,BranchJal,BranchBeq,RegWrite,MemToReg,ALUSrc,slt,auipc,MemWrite;
wire[31:0] ALUOut,ExtOp,ImmOp,ALUResult,Branch_address,Res;
wire[2:0] ALUControl;
wire[1:0] immControl;
wire[31:0] PC_no;
wire[31:0] PC_temp;
wire[31:0] Results_temp,rs1,rs2;

assign PC = PC_temp;
assign data_to_mem = Results_temp;
assign address_to_mem = ALUResult;
assign WE = MemWrite;

Instruction_fetch IF(clk,reset,zero,BranchBeq,BranchJal,BranchJalr,Results_temp,Branch_address,PC_temp,PC_no);

Instruction_decode ID(clk,reset,RegWrite,immControl,ImmOp[31:12],ImmOp[20:1],ImmOp[12:1],ImmOp[11:0],Instruction[19:15],Instruction[24:20],Instruction[11:7],Res,rs1,rs2,ImmOp);

Execution_unit EX (rs1,rs2,ImmOp,PC_temp,slt,ALUSrc,ALUControl,zero,ALUResult,Branch_address);

Memory_data MEM(clk,reset,MemWrite,MemToReg,BranchJal,BranchJalr,auipc,ALUResult,rs2,PC_no,PC_temp,data_from_mem,Results_temp);

Control_unit CU(Instruction,BranchJalr,BranchJal,BranchBeq,RegWrite,MemToReg,MemWrite,ALUControl,ALUSrc,immControl,slt,auipc);

endmodule
