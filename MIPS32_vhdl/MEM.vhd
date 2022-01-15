----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/05/2021 11:50:25 PM
-- Design Name: 
-- Module Name: MEM - Behavioral
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

entity MEM is
    Port (clk:in STD_LOGIC; 
           clk_enable:in STD_LOGIC;
            MemWrite : in STD_LOGIC;
           AluRes : inout STD_LOGIC_VECTOR (15 downto 0);
           RD2 : in STD_LOGIC_VECTOR (15 downto 0);
           MemData : out STD_LOGIC_VECTOR (15 downto 0));
end MEM;

architecture Behavioral of MEM is
    type tRAM is array(0 to 15) of STD_LOGIC_VECTOR(15 DOWNTO 0);
   signal RAM:tRAM:= ( 
   X"0010", -- var1 = 16
   X"ABCD", --temp  = 1 setat
   X"0002",
   X"0003",
   X"0004",
   X"0005",
   X"0006",
   X"0007",
   X"0008",
   others =>X"AAAA");
begin
    
    MemData <= RAM(conv_integer(ALURES));
    
    main:process(clk)
    begin 
        if clk_enable = '1' then
            if rising_edge(clk) then 
                if MemWrite = '1' then 
                    RAM(conv_integer(ALURES)) <= RD2;
               end if;
            end if;
        end if;
    end process;
    
        
end Behavioral;
