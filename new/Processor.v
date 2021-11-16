`timescale 1ns / 1ps

module Processor();

wire clk,reset,zero,BranchJalr,BranchJal,BranchBeq,RegWrite,MemToReg,MemWrite,ALUSrc,slt,auipc;
wire[2:0] ALUControl;
wire[31:0] Instruction,ALUOut,ExtOp,PC;
wire[31:12] ImmOp31_12;
wire[20:1] ImmOp12_1;
wire[11:0] ImmOp11_0;
wire[12:1] ImmOp12_1;
wire[1:0] ImmControl;
wire[4:0] a1,a2,a3;
wire[31:0] wd3,rd1,rd2,ImmOp;
wire[31:0] srcA,srcB,ImmOp,PC,ALUResult,Branch_address;
wire[31:0] Res, PC_4;

IF Instruction_fetch(clk,
reset,
zero,
BranchBeq,
BranchJal,
BranchJalr,
ALUOut,
ExtOp,
PC,Instruction
)
ID Instruction_decode(clk,reset,RegWrite,ImmControl,ImmOp31_12,ImmOp20_1,ImmOp12_1,ImmOp11_0,a1,a2,a3,wd3,rd1,rd2,ImmOp);
EX Execution_unit(
srcA,
rs2,
ImmOp,
PC,
slt,
ALUSrc,
ALUControl,
zero,
ALUResult,
Branch_address
);
MEM Memory_data(clk,reset,MemWrite,MemToReg,BranchJal,BranchJalr,auipc,ALUOut,rs2,PC,PC_4,Res);

CU Control_unit(Instruction,BranchJalr,BranchJal,BranchBeq,RegWrite,MemToReg,MemWrite,ALUControl,ALUSrc,immControl,slt,auipc);

endmodule
