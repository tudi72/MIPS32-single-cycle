
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;

entity alu is
    Port ( enable : in STD_LOGIC;
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           digits : out STD_LOGIC_VECTOR (15 downto 0);
           led7 : out STD_LOGIC);
end alu;

architecture Behavioral of alu is
    signal counter:STD_LOGIC_VECTOR(1 DOWNTO 0):= "00";
    signal sw1: STD_LOGIC_VECTOR(15 DOWNTO 0):= (OTHERS => '0');
    signal sw2: STD_LOGIC_VECTOR(15 DOWNTO 0):= (OTHERS => '0');
    signal sw3: std_logic_vector(15 DOWNTO 0):= (OTHERS => '0');
    signal rez:STD_LOGIC_VECTOR(15 DOWNTO 0):= (OTHERS => '0');
    
begin
    sw1(3 downto 0) <= sw(3 downto 0);
    sw2(3 downto 0) <= sw(7 downto 4);
    sw3(7 downto 0) <= sw(7 downto 0);
    process(enable)
    begin
        if enable = '1' then 
            counter <= counter + 1;
        end if;
    end process;
    
    mux:process(counter)
    begin 
        case counter is 
            when "00" => rez <= sw1 + sw2;
            when "01" => rez <= sw1 - sw2;
            when "10" => rez <= std_logic_vector(UNSIGNED(sw3) sll 2);
            when "11" => rez <= std_logic_vector(UNSIGNED(sw3) srl 2);
         end case;
    end process;
    digits <= rez;
    LED7 <= '1' when rez = X"FFFF" else '0';
end Behavioral;
