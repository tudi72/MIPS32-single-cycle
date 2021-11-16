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
    output[31:0] Instruction
    );

// declaring the necessary wires and register for this component
reg[31:0] PC_out,PC_temp;
reg[1:0] sel;
reg[31:0] ROM[0:1024];
reg[31:0] Instruction_temp;
    
//assign values to instruction memory 
always@* begin
    ROM[0]=16'h5601; ROM[1]=16'h3401;
    ROM[2]=16'h1801; ROM[3]=16'h0ac1;
    ROM[4]=16'h0521; ROM[5]=16'h0221;
    ROM[6]=16'h5601; ROM[7]=16'h5401;
    ROM[8]=16'h4801; ROM[9]=16'h3801;
    ROM[10]=16'h3001; ROM[11]=16'h2401;
    ROM[12]=16'h1c01; ROM[13]=16'h1601;
    ROM[14]=16'h5601; ROM[15]=16'h5401;   
end

// initialize the selection for the multiplexer of PC
    always @* begin
      sel[0] = BranchJalr;
      sel[1] = (zero & BranchBeq) | BranchJal;
    end

// initialize PC with 0 at the start of the program
initial begin
    PC_temp <= 32'h00000000;
end

// incrementing the value of PC by 4 on each edge of the clock
        always@(posedge clk) begin
            PC_out <= PC_temp;
        end

// checking the jumping conditions and making the multiplexation
    always@(BranchJal, BranchJalr, BranchBeq, zero) begin
        case(sel)
            2'b01   : PC_temp = ALUOut;
            2'b00   : PC_temp = PC_temp + 32'h00000004;
            2'b10   : PC_temp = ExtOp;
            default : PC_temp = 32'h00000000;
        endcase
    end
    

// Fetching the instruction from memory , assigning values to outputs
assign Instruction = (reset == 1'b1)?  32'h00000000:ROM[PC_temp];
assign PC = (reset == 1'b1)? 32'h00000000: PC_out;

endmodule
