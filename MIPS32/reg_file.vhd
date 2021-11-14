library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;

entity reg_file is
  Port (clk:in std_logic;
  ra1: in std_logic_vector(3 downto 0);
  ra2:in std_logic_vector(3 downto 0);
  wa:in std_logic_vector(3 downto 0);
  wd:in std_logic_vector(15 downto 0);
  enable:in std_logic;
  RegWrite: in std_logic;
  rd1:out std_logic_vector(15 downto 0);
  rd2:out std_logic_vector(15 downto 0));
end reg_file;

architecture Behavioral of reg_file is
    type register_array is array(0 to 15) of std_logic_vector(15 downto 0);
    signal Register_file:register_array:= ( X"0000", -- $0
                                            X"1111", -- $1 
                                            X"2222", -- $2
                                            X"3333", -- $3
                                            X"4444", -- $4
                                            X"5555", -- $5
                                            X"6666", -- $6
                                            X"7777", -- $7
                                            X"8888", -- $8
                                            others => X"FFFF");
begin
    -- rezolvare hazard structural -> scriere pe front descrescator
    process(clk)
    begin 
        if falling_edge(clk) then 
            if enable = '1' then 
                if RegWrite = '1' then
                    Register_file(conv_integer(wa)) <= wd;
                 end if;
            end if;
        end if;
    end process;
    rd1  <= Register_file(conv_integer(ra1));
    rd2 <= Register_file(conv_integer(ra2));
end Behavioral;
