----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/05/2021 10:06:43 PM
-- Design Name: 
-- Module Name: E_X - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;

entity E_X is
    Port ( 
        ALUSRC:in STD_LOGIC;
        ALUOP: in STD_LOGIC_VECTOR(3 downto 0);
        SLT:in std_logic;
        RegDst:in std_logic;
        GREATER: OUT STD_LOGIC;
        ZERO:OUT STD_LOGIC;
        EXT_IMM: in STD_LOGIC_VECTOR(15 DOWNTO 0);
        RD1 : in STD_LOGIC_VECTOR (15 downto 0);
        RD2 : in STD_LOGIC_VECTOR (15 downto 0);
        sa: in STD_LOGIC;
        ALURes: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        PC:in STD_LOGIC_VECTOR(15 Downto 0);
        Branch_addr:out STD_LOGIC_VECTOR(15 DOWNTO 0);
        rd:in std_logic_vector(2 downto 0);
        rt:in std_logic_vector(2 downto 0);
        wa: out std_logic_vector(3 downto 0));
end E_X;

architecture Behavioral of E_X is
    signal B:STD_LOGIC_VECTOR(15 DOWNTO 0):=(OTHERS => '0');
    signal RES:STD_LOGIC_VECTOR(15 DOWNTO 0):=(OTHERS =>'0');
    signal SLTDATA:STD_LOGIC_VECTOR(15 DOWNTO 0):=(OTHERS =>'0');
    signal sltflag:std_logic:='0';
begin

    Branch_addr <= ("0" & Ext_Imm(14 downto 0)) + PC;
    
    muxRegDst:process(RegDst)
    begin 
        if RegDst = '0' then 
            wa(2 downto 0) <= rd;
        else 
            wa(2 downto 0) <= rt;
        end if;
    end process;
    
    muxSlt:process(slt,sltflag)
    begin
      if slt = '1' then 
                ALURes <= SLTDATA;
             else 
                ALURES <= RES;
            end if;
            
            if SLTFLAG = '1' then 
                SLTDATA <= X"0001";
            else 
                SLTDATA <= X"0000";
            end if;
    end process;
    
    muxAluSrc:process(ALUSRC) 
    begin
        if ALUSRC = '1' then
            B <= Ext_Imm;
        else 
            B <= RD2;      
        end if; 
    end process;
       
     muxAlu:process(ALUOP)
     begin
      case ALUOP is
          when "0000" =>
            RES <= RD1  + B;
          when "0001" =>
            RES <= RD1 - B;
          when "0010" =>
          if sa = '1' then 
            RES <= RD1(14 downto 0) & "0";
           else 
            RES <= RD1;
            end if;
        when "0011" => 
            if sa = '1' then 
              RES <= std_logic_vector(UNSIGNED(RD1) srl 1);
              else 
              RES <= RD1;
              end if;
      when "0100" =>
            RES <= RD1 AND B;
        when "0101" =>
            RES <= RD1 OR B;
        when "0110" =>
            RES <= RD1 XOR B;
        when "0111" =>
            IF RD1 < B THEN 
                sltFLAG <= '1'; -- warning:inferring latch
            else 
                sltflag <= '0';
            end if;
        when "1000" =>
            if RD1 >= B THEN 
                GREATER <= '1';
            ELSE 
                GREATER <= '0';
            END IF;
          when others =>
            RES <= (others => '0');    
    end case;
    
    if RES = "0000000000000000" then 
        zero <= '1';
    else 
        zero <= '0';
    end if;
  end process;
      
end Behavioral;
