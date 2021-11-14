library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;


entity I_F is
 Port (  clk:in STD_LOGIC;
         Clock_enable: in STD_LOGIC;
         reset:in STD_LOGIC;
         Jump:in STD_LOGIC;
         PCSrc:in STD_LOGIC;
         Jump_addr:in STD_LOGIC_VECTOR(15 DOWNTO 0);
         Branch_addr:in STD_LOGIC_VECTOR(15 DOWNTO 0);
         PC:out std_logic_vector(15 downto 0);
         instruction:out std_logic_vector(15 downto 0));
end I_F;

architecture Behavioral of I_F is
    signal PC_D:STD_LOGIC_VECTOR(15 downto 0):= (others =>'0');
    signal PC_Q:STD_LOGIC_VECTOR(15 downto 0):= (others =>'0');
    signal PC_Q_1:STD_LOGIC_VECTOR(15 downto 0):= (others =>'0');
    signal PC_src:STD_LOGIC_VECTOR(15 downto 0):= (others =>'0');
    signal PC_jump:STD_LOGIC_VECTOR(15 downto 0):= (others =>'0');
     type tROM is array(0 to 15) of STD_LOGIC_VECTOR(15 DOWNTO 0);
   signal ROM:tROM:= ( -- var1 = adresa X"0000" ,temp = X"0001"
   B"010_000_010_0000000",   --1 RF[2] <- RAM[RF[0] + VAR1] 
   B"001_000_001_0000001",   --2 RF[1] <- RF[0] + 1
   B"000_0000000000000",     -- noOP
   B"000_0000000000000",     -- NOOP
   B"011_000_010_0000001",   --3 M[ RAM[RF[0]] + temp]  <- RF[1]
   B"000_0000000000000",     -- noOP
   B"000_0000000000000",     -- NOOP
   B"110_001_010_0000011",   --4 IF RF[1] >= RF[2] then PC <- PC+ 1 + X"0003"
   B"000_0000000000000",     -- noOP
   B"000_0000000000000",     -- NOOP
   B"000_001_000_001_1_010", --5 RF[1] <- RF[1] << 1
   B"000_0000000000000",     -- noOP
   B"000_0000000000000",     -- NOOP
   B"011_000_001_0000001",   --6 M[ RAM[RF[0]] + temp] <- RF[1]
   B"111_0000000000010",     --7 PC <- X"0002"   
    others => B"111_0000000000000"); -- PC <- X"0000"

begin
        instruction <= ROM(conv_integer(PC_Q));
        PC <= PC_Q_1;
        PC_Q_1 <= PC_Q+1;
        Pc_Src <= Branch_addr when PCsrc = '1' else PC_Q_1;
        PC_D <= Jump_addr when Jump = '1' else Pc_src;
            
        ProgramCounter:process(clk,Clock_enable,reset)
        begin 
                 
            if reset = '1' then 
                PC_Q <= X"0000";
            end if;

            if rising_edge(clk) then
                if Clock_enable = '1' then 
                    PC_Q <= PC_D; 
                end if;
               end if;
        end process;

     
end Behavioral;
    