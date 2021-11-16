`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/10/2021 08:18:55 PM
// Design Name: 
// Module Name: register_file
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// Module used for keeping the data about registers ,resolve the structural hazard by doing on each edge a different operation
//////////////////////////////////////////////////////////////////////////////////


module Instruction_decode(
    input clk,
    input reset,
    input RegWrite,
    input[1:0] ImmControl,
    input [31:12] ImmOp31_12,
    input [20:1] ImmOp20_1,
    input [12:1] ImmOp12_1,
    input [11:0] ImmOp11_0,
    input [4:0] a1,
    input [4:0] a2,
    input [4:0] a3,
    input [31:0] wd3,
    output [31:0] rd1,
    output [31:0] rd2,
    output [31:0] ImmOp
    
    );
// registers needed 
reg[31:0] rd1_temp;
reg[31:0] rd2_temp;
reg[31:0] ImmOp_temp;
reg[31:0] R[0:31];

//assign values for outputs
assign rd1 = (reset == 1)?32'h0000000000000000:rd1_temp;
assign rd2 = (reset == 1)?32'h0000000000000000:rd2_temp;
assign ImmOp = (reset == 1)?32'h0000000000000000:ImmOp_temp;
    
// declaring an array having 32 registers of length 32 BITS 
	initial begin
		R[0] <= 32'h00000000; //R[1] <= 32'h00000001; R[2] <= 32'h00000002; R[3] <= 32'h00000003;
		R[4] <= 32'h00000004; //R[5] <= 32'h00000005; R[6] <= 32'h00000006; R[7] <= 32'h00000007;
		R[8] <= 32'h00000008; //R[9] <= 32'h00000009; R[10] <= 32'h0000000A;R[11] <= 32'h0000000B;
		R[12] <= 32'h0000000C;//R[13] <= 32'h0000000D;R[14] <= 32'h0000000E;R[15] <= 32'h0000000F;
		R[16] <= 32'h0000001F;//R[17] <= 32'h0000002F;R[18] <= 32'h0000003F;R[19] <= 32'h0000004F;
		R[20] <= 32'h0000005F;//R[21] <= 32'h0000006F;R[22] <= 32'h0000007F;R[23] <= 32'h0000008F;
		R[24] <= 32'h0000009F;//R[25] <= 32'h000000AF;R[26] <= 32'h000000BF;R[27] <= 32'h000000CF;
		R[28] <= 32'h000000DF;//R[29] <= 32'h000000EF;R[30] <= 32'h000000FF;
		R[31] <= 32'h000001FF;
	end

	
// register file updates data register on the positive edge of the clock
    always @(posedge clk) begin
		if (RegWrite == 1'b1) begin
			R[a3] <= wd3;
		end
	end

	
// register file reads data from registers on the negative edge of the clock
	always @(negedge clk) begin
		rd1_temp <= R[a1];
		rd2_temp <= R[a2];
	end
	
// extending the immediate with sign 
    always@(ImmControl) begin
        if (ImmControl == 2'b00) begin // branch immediate [12:1]
            ImmOp_temp[12:1] <= ImmOp[12:1];
            ImmOp_temp[0] <= 0;
            ImmOp_temp[31:13] <= {18{ImmOp[12]}};
        end else 
        if (ImmControl == 2'b01) begin  // addi/lw/sw/jalr immediate [ 11:0]
            ImmOp_temp[11:0] <= ImmOp11_0;
            ImmOp_temp[31:12] <= {19{ImmOp11_0[11]}};
        end else
        if (ImmControl == 2'b10) begin  // lui immediate [ 31:12]
            ImmOp_temp[31:12] <= ImmOp31_12;
            ImmOp_temp[11:0] <=  12'b0000000000000000;
        end else
        if (ImmControl == 2'b11) begin  // jal immediate [20:1]
            ImmOp_temp[20:1] <= ImmOp20_1;
            ImmOp_temp[0] <= 0;
            ImmOp_temp[31:21] <=    {10{ImmOp20_1[20]}};
        end
    end
endmodule
