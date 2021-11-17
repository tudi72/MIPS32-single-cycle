`timescale 1ns / 1ps
module Control_unit(
    input[31:0] Instruction,
    output BranchJalr,
    output BranchJal,
    output BranchBeq,
    output RegWrite,
    output MemToReg,
    output MemWrite,
    output[2:0] ALUControl,
    output ALUSrc,
    output[1:0] immControl,
    output slt,
    output auipc
    );

reg BranchJalr_temp,BranchJal_temp,BranchBeq_temp,RegWrite_temp,MemToReg_temp;
reg MemWrite_temp,ALUSrc_temp,slt_temp,auipc_temp;
reg[2:0] ALUControl_temp;
reg[1:0] immControl_temp;

//asign values from registers
assign BranchJalr = BranchJalr_temp;
assign BranchJal = BranchJal_temp;
assign BranchBeq = BranchBeq_temp;
assign RegWrite = RegWrite_temp;
assign MemToReg = MemToReg_temp;
assign MemWrite = MemWrite_temp;
assign ALUControl = ALUControl_temp;
assign ALUSrc = ALUSrc_temp;
assign immControl = immControl_temp;
assign slt = slt_temp;
assign auipc = auipc_temp;

// choosing the right signals
always@(Instruction) 
begin
                             immControl_temp <= 2'b00;  BranchBeq_temp <= 0;  auipc_temp   <= 0;
       BranchJalr_temp <= 0; BranchJal_temp  <= 0;      RegWrite_temp  <= 0; MemToReg_temp <= 0;
       MemWrite_temp   <= 0; ALUControl_temp <= 3'b000; ALUSrc_temp    <= 0; slt_temp      <= 0;
        
        case(Instruction[6:0])
        7'b 0110011: //R-type 
            begin  
                RegWrite_temp <= 1;
                // choosing between (slt/sll/srl/and ) (sub/sra)
                case (Instruction[31:25]) 
                7'b 0000000: 
                      begin
                        // choosing slt/sll/srl/and
                        case(Instruction[14:12])
                        3'b000: ALUControl_temp <= 3'b000; //and function
                        3'b010: 
                            begin   
                                slt_temp <= 1;
                                ALUControl_temp <= 3'b110; // slt function
                            end 
                        3'b111: ALUControl_temp <= 3'b010; // and function
                        3'b001: ALUControl_temp <= 3'b011; //sll function
                        3'b101: ALUControl_temp <= 3'b100; //srl function
                        endcase
                    end
                7'b 0100000: 
                    begin
                         case(Instruction[14:12])
                             3'b000: ALUControl_temp <= 3'b001; // sub function
                             3'b101:ALUControl_temp <= 3'b101; //sra function
                         endcase
                     end
                 endcase
            end
                                    
        7'b0010011:// I-type : addi
            begin 
                RegWrite_temp <= 1;
                ALUSrc_temp <= 1;
                immControl_temp <= 2'b01;
            end
        7'b0100011: //S - type : sw
            begin
                immControl_temp <= 2'b01;
                MemWrite_temp <= 1;
                ALUSrc_temp <= 1;
            end
         7'b0000011: // L-type : lw
            begin
                MemToReg_temp <= 1;
                ALUSrc_temp <= 1;
                RegWrite_temp <= 2'b01;
            end
         7'b1100011: // B-type : branch
            begin
                immControl_temp <= 2'b00;
                BranchBeq_temp <= 1;
                ALUControl_temp <= 3'b001;
                
            end
         7'b1101111: // J- type : jal
            begin
                immControl_temp <= 2'b11;
                BranchJal_temp <= 1;
            end 
         7'b0110111: // user type : lui
            begin
                immControl_temp <= 2'b10;
                RegWrite_temp <= 1;
            end   
         7'b1100111: // J- type : jalr
            begin
                immControl_temp <= 1;
                BranchJalr_temp <= 1;
                RegWrite_temp <= 1;
                ALUSrc_temp <= 1;
            end 
         7'b0001011: // user-type : adduqb
            begin
                RegWrite_temp <= 1;
                ALUControl_temp <= 3'b111; 
            end
         7'b0010111: // user type : auipc
                begin
                    RegWrite_temp <= 1;
                    auipc_temp <= 1;
                end
        endcase

end
endmodule
