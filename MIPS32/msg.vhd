library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity mpg is
  Port(enable :out STD_LOGIC;
        btn: in STD_LOGIC;
        clk: in STD_LOGIC);
end mpg;

architecture Behavioral of mpg is
signal counter : std_logic_vector(31 downto 0) :=x"00000000";
signal Q1:STD_LOGIC:='0';
signal Q2:STD_LOGIC:='0';
signal Q3:STD_LOGIC:='0';
begin
    process(CLK)
    begin
        if rising_edge(clk) then 
            counter <= counter + 1;
        end if;
    end process;
    
    process(clk)
    begin 
        if btn = '1' and counter(23 downto 8) = "1111111111111111" then 
            Q1 <= btn;
        end if;
    end process;
    
    process(clk)
    begin 
        if rising_edge(clk) then 
            Q2 <= Q1;
            Q3 <= Q2;
        end if;
    end process;
    
    enable <= Q2 AND (NOT Q3);
end Behavioral;
