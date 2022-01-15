module processor( input         clk, reset,
					output [31:0] PC,
                  input  [31:0] instruction,
                  output        WE,
                  output [31:0] address_to_mem,
                  output [31:0] data_to_mem,
                  input  [31:0] data_from_mem
                  );
  
wire zero,BranchJalr,BranchJal,BranchBeq,RegWrite,MemToReg,ALUSrc,slt,auipc,MemWrite;
wire[31:0] ImmOp,Branch_address,ALUResult,Res;
wire[31:0] PC_4;	
wire[3:0] ALUControl;
wire[2:0] immControl;
wire[31:0] rs1,rs2;
assign WE = MemWrite;
assign data_to_mem = rs2;
assign address_to_mem = ALUResult;
 
 PC_counter counter(clk,reset,zero,BranchBeq,BranchJal,BranchJalr,ALUResult,Branch_address,PC,PC_4);
 Control_unit CU(instruction,BranchJalr,BranchJal,BranchBeq,RegWrite,MemToReg,MemWrite,ALUControl,ALUSrc,immControl,auipc);
 reg_file RF(clk,instruction,RegWrite,Res,rs1,rs2);
 Imm_decode ID(instruction,PC,immControl,ImmOp,Branch_address);
 Execution_unit EX(ALUSrc,ALUControl,ImmOp,rs1,rs2,zero,ALUResult);
 Write_back WB(auipc,BranchJal,BranchJalr,MemToReg,PC,PC_4,ImmOp,ALUResult,data_from_mem,Res);

endmodule

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module PC_counter(input clk,reset,
    input zero,
    input BranchBeq,
    input BranchJal,
    input BranchJalr,
    input[31:0] ALUResult,
    input[31:0] Branch_address,
    output [31:0] PC,
    output[31:0] PC_4);

reg[1:0] sel;
reg[31:0] PC_temp,PC_temp_4,PCn;    
assign PC = PC_temp;
assign PC_4 = PC_temp_4;

    always @(BranchJalr,zero,BranchBeq,BranchJal) 
	begin
      sel[0] = BranchJalr;
      sel[1] = (zero & BranchBeq) | BranchJal;
    end

	always@(posedge clk)
    begin
        
		if (reset == 1) 
		begin
			PC_temp = 32'h00000000;
		end else begin
		  PC_temp = PCn;
		end      
    end
	
    always@(sel or ALUResult or PC_temp_4 or Branch_address) 
	begin    
        case(sel)
            2'b01   : PCn <= ALUResult;
            2'b00   : PCn <= PC_temp_4;
            2'b10   : PCn <= Branch_address;
            default : PCn <= PC_temp_4;
        endcase
    end
    
	always@(PC_temp) 
    begin
        PC_temp_4 = PC_temp + 32'h00000004;
		
    end
endmodule
//////////////////////////////////////////////////////////////////////////////////////////////////////////CONTROL UNIT////////////////////////////////////////////////////////////////////////////
module Control_unit(
    input[31:0] instruction,
    output reg BranchJalr,
    output reg BranchJal,
    output reg BranchBeq,
    output reg RegWrite,
    output reg MemToReg,
    output reg MemWrite,
    output reg [3:0] ALUControl,
    output reg ALUSrc,
    output reg[2:0] immControl,
    output reg auipc
    );
    
    
	always@(instruction) 
	begin
	                    immControl <= 3'b000;  BranchBeq <= 0;  auipc   <= 0;
       BranchJalr <= 0; BranchJal  <= 0;      RegWrite  <= 0; MemToReg <= 0;
       MemWrite   <= 0; ALUControl <= 4'b0000; ALUSrc    <= 0;
    
        case(instruction[6:0])
        7'b 0110011: //R-type 
            begin  
                RegWrite <= 1;
                // choosing between (slt/sll/srl/and ) (sub/sra)
                case (instruction[31:25]) 
                7'b 0000000: 
                      begin

                        // choosing slt/sll/srl/and
                        case(instruction[14:12])
                        3'b000: 
                            begin
                             ALUControl <= 4'b0000; //add function
                             ALUSrc <= 0;
                            end
                        3'b010: ALUControl <= 4'b0110; // slt function
                        3'b111: ALUControl <= 4'b0010; // and function
                        3'b001: ALUControl <= 4'b0011; //sll function
                        3'b101: ALUControl <= 4'b0100; //srl function
                        3'b110: ALUControl <= 4'b1000; // or function
                        endcase
                    end
                7'b 0100000: 
                    begin
                         case(instruction[14:12])
                             3'b000: ALUControl <= 4'b0001; // sub function
                             3'b101:ALUControl  <= 4'b0101; //sra function
                         endcase
                     end
                 endcase
            end
                                    
        7'b0010011:// I-type : addi
            begin 
                RegWrite <= 1;
                ALUSrc  <= 1;
                immControl <= 3'b001;
            end
        7'b0100011: //S - type : sw
            begin
                immControl <= 3'b100;
                MemWrite  <= 1;
                ALUSrc <= 1;
            end
         7'b0000011: // L-type : lw
            begin
                MemToReg <= 1;
                ALUSrc <= 1;
                RegWrite <= 2'b01;
                immControl <= 3'b001;
            end
         7'b1100011: // B-type : branch
            begin
                immControl <= 3'b000;
                BranchBeq  <= 1;
                ALUControl <= 4'b0001;
                
                
            end
         7'b1101111: // J- type : jal
            begin
                immControl <= 3'b011;
                BranchJal  <= 1;
				RegWrite <= 1;
				
            end 
         7'b0110111: // user type : lui
            begin
                immControl <= 3'b010;
                RegWrite <= 1;
                ALUSrc <= 1;
            end   
         7'b1100111: // J- type : jalr
            begin
                immControl <= 3'b001;
                BranchJalr <= 1;
                RegWrite <= 1;
            end 
         7'b0001011: // user-type : adduqb
            begin
                RegWrite <= 1;
                ALUControl <= 4'b0111; 
            end
         7'b0010111: // user type : auipc
                begin
                    RegWrite <= 1;
                    auipc <= 1;
                    ALUSrc <= 1;
                    immControl <= 3'b010;
                end
        endcase

end
endmodule
/////////////////////////////////////////////////////////////////////////////////INSTRUCTION DECODE////////////////////////////////////////////////////////////////////////////
module reg_file(
                input clk,
                input[31:0] instruction,
                input RegWrite,
                input[31:0] Res,
                output[31:0] rs1,
                output[31:0] rs2);
               
                
	reg[31:0] R[0:31];
	integer i;    
	assign   rs1 = instruction[19:15]?R[instruction[19:15]]:32'h00000000;
	assign   rs2 = instruction[24:20]?R[instruction[24:20]]:32'h00000000;
    
    
	initial 
	begin
		R[0] <= 32'h00000000; R[1] <= 32'h00000000; R[2] <= 32'h00000000; R[3] <= 32'h00000000;
		R[4] <= 32'h00000000; R[5] <= 32'h00000000; R[6] <= 32'h00000000; R[7] <= 32'h00000000;
		R[8] <= 32'h00000000; R[9] <= 32'h00000000; R[10] <= 32'h00000000;R[11] <= 32'h00000000;
		R[12] <= 32'h00000000;R[13] <= 32'h00000000;R[14] <= 32'h00000000;R[15] <= 32'h00000000;
		R[16] <= 32'h00000000;R[17] <= 32'h00000000;R[18] <= 32'h00000000;R[19] <= 32'h00000000;
		R[20] <= 32'h00000000;R[21] <= 32'h00000000;R[22] <= 32'h00000000;R[23] <= 32'h00000000;
		R[24] <= 32'h00000000;R[25] <= 32'h00000000;R[26] <= 32'h00000000;R[27] <= 32'h00000000;
		R[28] <= 32'h00000000;R[29] <= 32'h00000000;R[30] <= 32'h00000000;
		R[31] <= 32'h00000000;
	
	end 
	always @(posedge clk) 
	begin
		if (RegWrite == 1) begin
			if(instruction[11:7] != 0) begin
				R[instruction[11:7]] <= Res;
			end
		end
	end

	always @(negedge clk) begin                                                                               
//	$display("------------------------------REGISTER MEMORY------------------------------------------------");
//           for (i = 0; i < 8; i = i + 1)                                                                      
//           begin                                                                                              
//            $display("%d %h %d %h %d %h %d %h",i, R[i],i+8, R[i+8],i+16, R[i+16],i+24, R[i+24]);              
//           end                                                                                                
	end
	endmodule
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
module Imm_decode(input[31:0] instruction,
                  input[31:0] PC,
                  input[2:0] immControl,
                  output reg[31:0] ImmOp,
                  output reg[31:0] Branch_address);
                  

    always@(ImmOp,PC) 
	begin
        Branch_address = ImmOp + PC;
		
    end 
always@(immControl,instruction) begin
        if (immControl == 3'b000) begin // branch immediate [12:1]
            ImmOp[12] = instruction[31];
            ImmOp[11] = instruction[7];
            ImmOp[10:5] = instruction[30:25];
            ImmOp[4:1] = instruction[11:8];
            ImmOp[0] = 0;
            ImmOp[31:13] = {19{instruction[31]}};
			
        end else 
        if (immControl == 3'b001) begin  // addi/jalr/lw immediate [ 11:0]
            ImmOp[11:0] = instruction[31:20];
            ImmOp[31:12] = {20{instruction[31]}};
        end else
        if (immControl == 3'b010) begin  // lui/auipc immediate [ 31:12]
            ImmOp[31:12] = instruction[31:12];
            ImmOp[11:0] =  12'b000000000000;
        end else
        if (immControl == 3'b011) begin  // jal immediate [20:1]
            ImmOp[20] = instruction[31];
            ImmOp[10:1] = instruction[30:21];
            ImmOp[11] = instruction[20];
            ImmOp[19:12] = instruction[19:12];
            ImmOp[0] = 0;
            ImmOp[31:21] =    {11{instruction[31]}};
           // $display("ImmOP,Imm[10:1]: %h",ImmOp,instruction[30:21]);

        end else
        if (immControl == 3'b100) begin // sw
            ImmOp[11:5] = instruction[31:25];
            ImmOp[4:0] = instruction[11:7];
           // $display("[IMM_ins]: = %h, IMm11_0 = %h",instruction[10:7],ImmOp[11:0]);
            ImmOp[31:12] = {20{instruction[31]}};
        end
        
    end
endmodule
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 module Execution_unit(input ALUSrc,
                       input[3:0] ALUControl,
                       input[31:0] ImmOp,
                       input[31:0] rs1,
                       input[31:0] rs2,
                       output reg zero,
                       output reg[31:0] ALUResult);
                       
wire[31:0] srcB = ALUSrc? ImmOp:rs2;
        
    always@(ALUResult) begin
        if (ALUResult == 0) begin
            zero = 1;
        end else begin
            zero = 0;
        end 
    end
    always@(ALUControl,rs1,srcB)
        begin 
        case(ALUControl)
            4'b0000: ALUResult = rs1 + srcB;
            4'b0001: ALUResult = rs1 - srcB;
            4'b0010: ALUResult = rs1 & srcB;
            4'b0011: ALUResult = rs1 << srcB;
            4'b0100: ALUResult = rs1 >> srcB;
            4'b0101: ALUResult = $signed(rs1) >>> srcB;
            4'b0110: ALUResult = ($signed(rs1) < $signed(srcB))? 32'h00000001: 32'h00000000;       
            4'b0111: begin
                   ALUResult[31:24] = rs1[31:24]+ srcB[31:24];
                   ALUResult[23:16] = rs1[23:16]+ srcB[23:16];
                   ALUResult[15:8] = rs1[15:8]+ srcB[15:8];
                   ALUResult[7:0] = rs1[7:0]+ srcB[7:0];
                   end
            4'b1000: ALUResult = rs1 | srcB;
            default: ALUResult= 32'h00000000;
        endcase
   end
endmodule   
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
module Write_back(  input auipc,
                    input BranchJal,
                    input BranchJalr,
                    input MemToReg,
                    input[31:0] PC,
                    input[31:0] PC_4,
                    input[31:0] ImmOp,
                    input[31:0] ALUResult,
                    input[31:0] data_from_mem,
                    output[31:0] Res);

wire[31:0] PC_Imm = PC + ImmOp;
wire[31:0]res_temp_auipc = (auipc)? PC_Imm: ALUResult;
wire[31:0]res_temp_branch = (BranchJal | BranchJalr)? PC_4:res_temp_auipc;
assign Res = MemToReg?data_from_mem:res_temp_branch;
endmodule

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
