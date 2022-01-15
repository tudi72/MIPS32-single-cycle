----------------------------------------------------------------------------------
-- Company: UTCN
-- Engineer: Zaharia Tudorita
-- 
-- Create Date: 03/29/2021 04:08:28 PM
-- Design Name: Instruction Decoder
-- Module Name: I_D - Behavioral

----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity I_D is
  Port (clk : in STD_LOGIC;
      RegWrite:in STD_LOGIC;
      Instr:in STD_LOGIC_VECTOR(15 DOWNTO 0);
      ExtOp: in STD_LOGIC;
      enable:in STD_LOGIC;
      wa:in STD_LOGIC_VECTOR(3 DOWNTO 0);
      wd:in STD_LOGIC_VECTOR(15 downto 0);
      RD1: out STD_LOGIC_VECTOR(15 downto 0);
      RD2: out STD_LOGIC_VECTOR(15 downto 0);
      Ext_IMM:out STD_LOGIC_VECTOR(15 downto 0);
      func: out STD_LOGIC_VECTOR(2 downto 0);
      sa:out STD_LOGIC);
end I_D;

architecture Behavioral of I_D is
    component reg_file is
      Port (clk:in std_logic;
      ra1: in std_logic_vector(3 downto 0);
      ra2:in std_logic_vector(3 downto 0);
      wa:in std_logic_vector(3 downto 0);
      wd:in std_logic_vector(15 downto 0);
      enable:in std_logic;
      RegWrite:in std_logic;
      rd1:out std_logic_vector(15 downto 0);
      rd2:out std_logic_vector(15 downto 0));
    end component;

signal ra1: STD_LOGIC_VECTOR(3 downto 0):= "0000";
signal ra2: STD_LOGIC_VECTOR(3 downto 0):= "0000";
signal ext_1:STD_LOGIC_VECTOR(15 downto 0);
signal ext_2:STD_LOGIC_VECTOR(15 downto 0);
begin
-- reading ra1 <= rs ,ra2 = rt 
    ra1(2 downto 0)<= Instr(12 downto 10);
    ra2(2 downto 0)<= Instr(9 downto 7);
   
    func <= Instr(2 downto 0);
    sa <= Instr(3);
    ext_1 <=  "000000000" & Instr(6 downto 0);
    ext_2 <= "000000000" & Instr(6 downto 0) when Instr(6) = '0' else "111111111" & Instr(6 downto 0) ;
    Ext_IMM <= ext_1 when ExtOp = '1' else ext_2;  
    
    -- some connections are wrong here, it won't connect -- 
    -- register write
    M1:reg_file port map(clk,ra1,ra2,wa,wd,enable,RegWrite,rd1,rd2);
    
end Behavioral;
