`timescale 1ns / 1ps

module Execution_unit(
    input [31:0] srcA,
    input [31:0] rs2,
    input [31:0] ImmOp,
    input [31:0] PC,
    input slt,
    input ALUSrc,
    input [2:0] ALUControl,
    output zero,
    output [31:0] ALUResult,
    output  [31:0] Branch_address
    );
 
reg[31:0] SLTDATA = 8'h00000000;
reg[31:0] srcB = 8'h00000000;
reg[31:0] ALUResult_before_SLT = 8'h00000000;
reg[31:0] ALUResult_after_SLT = 8'h00000000;
reg zero_reg = 0;
reg sltFlag = 0;

// calculating the address to jump
assign Branch_address = PC + ImmOp;
assign zero = zero_reg;
assign ALUResult = ALUResult_after_SLT;

//always initializing the register for source A


//choosing source B for the execution unit 
    always@(ALUSrc,rs2,ImmOp) 
    begin
        if (ALUSrc) begin 
            srcB <=  ImmOp;
       end else begin
            srcB <= rs2;
       end    
    end
    
// choosing the data for the instruction SLT 
    always@(slt,sltFlag,SLTDATA,ALUResult_before_SLT)
    begin
        if (slt) begin 
            ALUResult_after_SLT <= SLTDATA;
        end else begin 
            ALUResult_after_SLT <= ALUResult_before_SLT;
        end
        
        if (sltFlag) begin 
            SLTDATA <= 4'h0001;
        end else begin 
            SLTDATA <= 4'h0000;
        end
    end 
    
// choosing the operation based on the command from control unit    
    always@(ALUControl,srcA,srcB)
        begin 
        case(ALUControl)
            2'b000: ALUResult_before_SLT <= srcA + srcB;
            2'b001: ALUResult_before_SLT <= srcA - srcB;
            2'b010: ALUResult_before_SLT <= srcA & srcB;
            2'b011: ALUResult_before_SLT <= srcA << srcB;
            2'b100: ALUResult_before_SLT <= srcA >> srcB;
            2'b101: ALUResult_before_SLT <= srcA >>> srcB;
            2'b110: begin
                        if (srcA < srcB) begin
                            sltFlag <= 1'b1;
                        end else begin
                            sltFlag <= 1'b0;
                        end
                    end
            2'b111:  begin
                    ALUResult_before_SLT[31:24] <= srcA[31:24]+ srcB[31:24];
                    ALUResult_before_SLT[23:16] <= srcA[23:16]+ srcB[23:16];
                    ALUResult_before_SLT[15:8] <= srcA[15:8]+ srcB[15:8];
                    ALUResult_before_SLT[7:0] <= srcA[7:0]+ srcB[7:0];
                end
            default: ALUResult_before_SLT <= 4'h0000;
        endcase
   end
   
 // detecting when the result si zero
    always@* begin
        if (ALUResult_after_SLT) begin
            zero_reg <= 0;
        end else begin
            zero_reg <= 1;
        end 
    end
endmodule
