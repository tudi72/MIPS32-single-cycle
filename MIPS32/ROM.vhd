----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/08/2021 04:30:35 PM
-- Design Name: 
-- Module Name: ROM - Behavioral
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

entity ROM is
  Port (
  en:in std_logic;
  address:in std_logic_vector(7 downto 0);
  dataIn:in std_logic_vector(15 downto 0);
  dataOut:out std_logic_vector(15 downto 0) );
end ROM;

architecture Behavioral of ROM is
    type tROM is array(0 to 255) of STD_LOGIC_VECTOR(15 DOWNTO 0);
   signal ROM:tRom:= ( X"0001",X"0005",X"0007",X"000F",others =>X"0000");

begin
            dataOut <= ROM(conv_integer(address));
        
end Behavioral;
