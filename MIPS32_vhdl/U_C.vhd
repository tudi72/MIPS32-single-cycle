----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/29/2021 04:59:42 PM
-- Design Name: 
-- Module Name: U_C - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity U_C is
    Port ( Instr : in STD_LOGIC_VECTOR (15 downto 0);
    RegDst:out STD_LOGIC;
    ExtOp:out STD_LOGIC;
    ALUSrc:out STD_LOGIC; 
    Branch:out STD_LOGIC; --beq 
    BranchNEq:out STD_LOGIC; -- bne
    BranchGE:out STD_LOGIC; -- bge
    SLT:out STD_LOGIC; -- pentru slt 
    Jump:out STD_LOGIC;
    ALUOp:out STD_LOGIC_Vector(3 downto 0);
    MemWrite:out STD_LOGIC;
    MemToReg:out STD_LOGIC;
    RegWrite:out STD_LOGIC);
end U_C;

architecture Behavioral of U_C is
signal opcode: STD_LOGIC_VECTOR(2 downto 0):= Instr(15 downto 13);
signal func:STD_LOGIC_VECTOR(2 downto 0):= Instr(2 downto 0);
begin
      
      
      process(Instr)
      begin
        RegDst <= '0';ExtOp <= '0';ALUSrc <= '0';
        Branch <= '0';BranchNEq <= '0';BranchGE <= '0';SLT <= '0';
        Jump <= '0';MemWrite <= '0';MemToReg <= '0';RegWrite <= '0'; ALUOP <= "0000";
          case Instr(15 downto 13) is 
           
            when "000" => --instructiuni de tip R
              RegDst <= '1'; -- Scriem in RF[RD]
              RegWrite <= '1'; -- scriem in REG FILE
              AluOp(2 downto 0) <= Instr(2 downto 0);
              if Instr(2 downto 0) = "111" then 
                    SLT <= '1';
              end if;
  
           when "001" => -- ADDI
                regWrite <= '1';
                alusrc <= '1';
                ExtOp <= '1';
    
           when "010" => -- LW
                regwrite <= '1';
                alusrc <= '1';
                extop<='1';
                memtoreg <= '1';

           when "011" => -- SW 
                alusrc <= '1';
                extop <= '1';
                memwrite <= '1';
                
           when "100" => --BEQ
                extop <= '1';
                branch <= '1';
                aluop <= "0001";
            when "101" => --bne 
                extop <= '1';
                branchneq <= '1';
                aluop <= "0001";
            when "110" => --bge 
                extop <= '1';
                branchge <= '1';
                aluop <= "1000"; -- se face comparare
             when "111" => -- jump
                jump <= '1';
            when others =>        
              RegDst <= 'X';
              ExtOp <= 'X';
              Alusrc <= 'X';
              Branch <= 'X';
              BranchNEQ <= 'X';
              BRANCHGE <= 'X';
              SLT <= 'X';
              JUMP <= 'X';
              ALUOP <= "XXXX";
              MEMWRITE <= 'X';
              MEMTOREG <= 'X';
              REGWRITE <= 'X';
          end case;
    end process;
end Behavioral;
