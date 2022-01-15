# SINGLE-CYCLE CPU DESIGN

# Basic CPU design

The schema is based on the following components. The processor cotains a classic design for MIPS 32. 

![image](https://user-images.githubusercontent.com/33194623/149621276-be0324af-9535-41ca-956e-b39ace072ccc.png)

| Instruction   |	     Syntax            |    Operation                                                          |
| ------------- | -----------------------|---------------------------------------------------------------------- |
| add          	| add rd, rs1, rs2	     | rd ← [rs1] + [rs2];                                                   |	
| addi	        | addi rd, rs1, imm11:0	 | rd ← [rs1] + imm11:0;                                                 |	
| addu.qb	      | addu.qb rd, rs1, rs2	 | rd31:24 ← [rs131:24] + [rs231:24]; rd23:16 ← [rs123:16] + [rs223:16]; |
| and	          | and rd, rs1, rs2       |	rd ← [rs1] & [rs2];	                                                 |
| sub	          | sub rd, rs1, rs2	     | rd ← [rs1] - [rs2];	                                                 |
| slt	          | slt rd, rs1, rs2	     | if [rs1] < [rs2] then rd←1; else rd←0;                                |
| beq	          | beq rs1, rs2, imm12:1	 | if [rs1] == [rs2] go to [PC]+{imm12:1,'0'}; else go to [PC]+4;	       |
| lw	          | lw rd,imm11:0(rs1)	   | rd ← Memory[[rs1] + imm11:0]	                                         |
| sw	          | sw rs2,imm11:0(rs1)    |	Memory[[rs1] + imm11:0] ← [rs2];	                                   |
| lui	          | lui rd, imm31:12	     | rd ← {imm31:12,'0000 0000 0000'};	                                   |
| jal	          | jal rd, imm20:1        |	rd ← [PC]+4; go to [PC] +{imm20:1,'0'};                              | 	
| jalr          | jalr rd, rs1, imm11:0	 | rd ← [PC]+4; go to [rs1]+imm11:0;                                     |
| auipc	        | auipc rd,imm31:12	     | rd ← [PC] + {imm31:12,'0000 0000 0000'};	                             |
| sll	          | sll rd, rs1, rs2	     | rd ← [rs1] << [rs2];                                                  |	
| srl	          | srl rd, rs1, rs2	     | rd ← (unsigned)[rs1] >> [rs2];	                                       |
| sra	          | sra rd, rs1, rs2	     | rd ← (signed)[rs1] >> [rs2];                                          |

# Program S

The assembly program merges two images into one image. We use the RISC-V calling convention.
Suppose that the input addresses for the subroutine are stored in the data memory at following addresses:

* 0x00000004: inputImgA
* 0x00000008: inputImgB
* 0x0000000C: outputImg

For instance, at address 0x00000004 the address of inputImgA is stored (where the image begins).
After returning from the subroutine, program should write the returned result (i.e. the number of pixels of the output image) into the data memory at address of 0x00000010.

Algorithm of program S is designed in the following way: 
* set aplha channel to 0xFF
* output color channel (i.e., red, green and blue) is computed as the sum of corresponding channels of the input pixels. There is no need to treat overflow (i.e. if the sum is greather than 0xFF, only lower 8 bits are used).
Only the images with the same size can be merged. Input images have always the same size.
