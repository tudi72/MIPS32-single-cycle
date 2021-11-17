`timescale 1ns / 1ps

module Instruction_fetch(
    input clk,
    input reset,
    input zero,
    input BranchBeq,
    input BranchJal,
    input BranchJalr,
    input[31:0] ALUOut,
    input[31:0] ExtOp,
    output [31:0] PC,
    output[31:0] PC_4
    );

// declaring the necessary wires and register for this component

reg[31:0] PC_temp = 8'h00000000;
reg[31:0] PCn = 8'h00000000;
reg[1:0] sel = 2'b00;
reg[31:0] PC_temp_4= 8'h00000000;

// initialize the selection for the multiplexer of PC
    always @* begin
      sel[0] = BranchJalr;
      sel[1] = (zero & BranchBeq) | BranchJal;
    end

always@(posedge clk)
    begin      
        PC_temp <= PCn;
    end

// checking the jumping conditions and making the multiplexation
    always@(sel,ALUOut,PC_temp,ExtOp) begin
        case(sel)
            2'b01   : PCn = ALUOut;
            2'b00   : PCn = PC_temp_4;
            2'b10   : PCn = ExtOp;
        endcase
    end
    

assign PC = (reset == 1'b1)? 8'h00000000: PC_temp_4;
assign PC_4 = (reset == 1'b1)? 8'h00000000: PC_temp;

always@* 
    begin 
        PC_temp_4 <= PC_temp + 8'h00000001;
    end
endmodule
