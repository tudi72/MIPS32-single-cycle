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
    output[31:0] Res     
    );

// declaring varriables 
reg[31:0] RAM[0:1024];
reg[31:0] res_temp_mux;
reg[31:0] res_temp_data;
reg[31:0] res_temp;

// read data from memory 
always@* begin res_temp_data = RAM[ALUOut]; end;
assign Res = (reset == 1)?32'h0000000000000000:res_temp;

// memory data component 
always @(posedge clk) begin
    if (MemWrite) begin
        RAM[ALUOut]  <= rs2;
    end        
end


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
always@(MemToReg,res_temp_data,ALUOut) begin
    if (MemToReg) begin
        res_temp <= res_temp_data;
    end else begin
        res_temp <= res_temp_mux;
    end
end
endmodule   