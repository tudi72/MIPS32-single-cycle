`timescale 1ns / 1ps

module Instruction_Memory(
    input reset,
    input [31:0] PC,
    output [31:0] Instruction
    );
    
    
reg[31:0] ROM[0:1024];

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

// Fetching the instruction from memory , assigning values to outputs
assign Instruction = (reset == 1'b1)?  32'h00000000:ROM[PC];

endmodule
