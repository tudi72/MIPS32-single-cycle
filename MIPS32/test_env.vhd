library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;

entity test_env is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end test_env;

architecture Behavioral of test_env is
component I_D is
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
end component;
component mpg is
    PORT(enable :out STD_LOGIC;
    btn: in STD_LOGIC;
    clk: in STD_LOGIC);
 end component;
component SSD is
Port 
(clk: in STD_LOGIC;
digit: in STD_LOGIC_VECTOR(15 DOWNTO 0);
an : out STD_LOGIC_VECTOR (3 downto 0);
cat : out STD_LOGIC_VECTOR (6 downto 0));
end component;
component I_F is
 Port (  clk:in STD_LOGIC;
     Clock_enable: in STD_LOGIC;
     reset:in STD_LOGIC;
     Jump:in STD_LOGIC;
     PCSrc:in STD_LOGIC;
     Jump_addr:in STD_LOGIC_VECTOR(15 DOWNTO 0);
     Branch_addr:in STD_LOGIC_VECTOR(15 DOWNTO 0);
     PC:out std_logic_vector(15 downto 0);
     instruction:out std_logic_vector(15 downto 0));
end component;
component U_C is
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
end component;    
component MEM is
    Port (clk:in STD_LOGIC; 
        clk_enable:in STD_LOGIC;
        MemWrite : in STD_LOGIC;
           AluRes : inout STD_LOGIC_VECTOR (15 downto 0);
           RD2 : in STD_LOGIC_VECTOR (15 downto 0);
           MemData : out STD_LOGIC_VECTOR (15 downto 0));
    end component;
component E_X is
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
end component;

    signal clk_enable:STD_LOGIC:='0';
    signal reset:STD_LOGIC:='0';
    signal Jump_addr:STD_LOGIC_VECTOR(15 downto 0):=X"0010";
    signal Branch_addr:STD_LOGIC_VECTOR(15 downto 0):= X"1100";
    signal PC:std_logic_vector(15 downto 0):= (others =>'0');
    signal instruction:STD_LOGIC_VECTOR(15 downto 0):= (others =>'0');
    signal PCSrc:STD_LOGIC:='0'; --sw(1)
    signal SSD_OUT:STD_LOGIC_VECTOR(15 DOWNTO 0);
    
    signal RegDst:STD_LOGIC:='0';
    signal ExtOp:STD_LOGIC:='1';
    signal ALUsrc:STD_LOGIC:='0';
    signal Branch:STD_LOGIC:='0';
    signal BranchNEQ:STD_LOGIC:='0';
    signal BRANCHGE:STD_LOGIC:='0';
    signal SLT:STD_LOGIC:='0';
    SIGNAL JUMP:STD_LOGIC:='0';
    SIGNAL MEMWRITE:STD_LOGIC:='0';
    SIGNAL ALUOP:STD_LOGIC_VECTOR(3 DOWNTO 0):="0000";
    SIGNAL MEMTOREG:STD_LOGIC:='0';
    SIGNAL REGWRITE:STD_LOGIC:='0';
    signal rd1:STD_LOGIC_VECTOR(15 DOWNTO 0):=(OTHERS =>'0');
    signal rd2:STD_LOGIC_VECTOR(15 DOWNTO 0):=(OTHERS =>'0');
    signal wd:STD_LOGIC_VECTOR(15 DOWNTO 0):=(OTHERS =>'0');
    signal Ext_Imm:STD_LOGIC_VECTOR(15 DOWNTO 0):=(OTHERS =>'0');
    signal func:STD_LOGIC_VECTOR(2 downto 0):="000";
    signal sa:STD_LOGIC:='0';
    signal SLTFLAG:STD_LOGIC:='0';
    signal GREATER:STD_LOGIC:='0';
    signal zero:STD_LOGIC:='0';
    signal ALURES:STD_LOGIC_VECTOR(15 DOWNTO 0):=(OTHERS =>'0'); 
    signal MemData:STD_LOGIC_VECTOR(15 DOWNTO 0):= (OTHERS =>'0');   
    signal SLTDATA:STD_LOGIC_VECTOR(15 DOWNTO 0):=(OTHERS =>'0');
-- SIGNALS FOR MIPS PIPELINE-----------------------------------------------
    signal REGIF_ID:STD_LOGIC_VECTOR(31 DOWNTO 0):= (OTHERS =>'0');
    signal REGID_EX:STD_LOGIC_VECTOR(86 DOWNTO 0):= (OTHERS => '0');
    signal REGEX_MEM:STD_LOGIC_VECTOR(59 DOWNTO 0):= (OTHERS =>'0');
    signal REGMEM_WB:STD_LOGIC_VECTOR(37 DOWNTO 0):= (OTHERS => '0');
    signal CLEAR_IF_ID:STD_LOGIC:='0';
    signal LOAD_IF_ID:STD_LOGIC:='0';
    signal CLEAR_ID_EX:STD_LOGIC:='0';
    signal LOAD_ID_EX:STD_LOGIC:='0';
    signal CLEAR_EX_MEM:STD_LOGIC:='0';
    signal LOAD_EX_MEM:STD_LOGIC:='0';
    signal CLEAR_MEM_WB:STD_LOGIC:='0';
    signal LOAD_MEM_WB:STD_LOGIC:='0';
    signal wa:STD_LOGIC_VECTOR(3 DOWNTO 0):="0000";

   begin
    -- REGEX_MEM(4 DOWNTO 2)= (BRANCH,BRANCHNEQ,BRANCHGE) regexMem(23,22) == GREATER,zero
    PCSRC <= ((REGEX_MEM(3) AND NOT REGEX_MEM(22)) OR (REGEX_MEM(22) AND REGEX_MEM(4)) 
    OR (REGEX_MEM(2) AND REGEX_MEM(23)));

    MEM_WB:PROCESS(CLK)
    BEGIN 
        IF CLEAR_MEM_WB = '1' THEN
            REGMEM_WB <= (OTHERS =>'0');
        ELSIF RISING_EDGE(CLK) THEN 
            IF LOAD_MEM_WB = '1' THEN
                REGMEM_WB(1 DOWNTO 0) <= REGEX_MEM(1 DOWNTO 0); --WB
                REGMEM_WB(17 DOWNTO 2) <= MEMDATA;
                REGMEM_WB(33 DOWNTO 18) <= REGEX_MEM(55 DOWNTO 40); -- ALURESTAFTERSLT
                REGMEM_WB(37 DOWNTO 34) <= REGEX_MEM(59 DOWNTO 56); -- WA
            END IF;
        END IF;
    END PROCESS;
    EX_MEM:PROCESS(CLK)
    BEGIN
        if CLEAR_EX_MEM = '1' then
            REGEX_MEM <= (OTHERS =>'0');
        ELSIF RISING_EDGE(CLK) THEN
            IF LOAD_EX_MEM = '1' THEN 
                REGEX_MEM(1 DOWNTO 0) <= REGID_EX(1 DOWNTO 0); --WB
                REGEX_MEM(5 DOWNTO 2) <= REGID_EX(5 DOWNTO 2); -- M
                REGEX_MEM(21 DOWNTO 6) <= BRANCH_ADDR; 
                REGEX_MEM(23 DOWNTO 22) <= (GREATER,ZERO);
                REGEX_MEM(39 DOWNTO 24) <= REGID_EX(44 DOWNTO 29); -- RD2
                REGEX_MEM(55 DOWNTO 40) <= AluRes;
                REGEX_MEM(59 DOWNTO 56)<= wa; -- write address
                
            END IF;
        END IF;
    END PROCESS;
    ID_EX:PROCESS(CLK)
    BEGIN
        IF CLEAR_ID_EX  = '1' THEN 
            REGID_EX <= (OTHERS =>'0'); 
        ELSIF RISING_EDGE(CLK) THEN
            IF LOAD_ID_EX = '1' THEN 
                REGID_EX(1 DOWNTO 0) <= (MEMTOREG,REGWRITE); -- WB
                REGID_EX(5 DOWNTO 2) <= (MEMWRITE,BRANCH,BRANCHNEQ,BRANCHGE); --M
                REGID_EX(6) <= ALUSRC; --EX
                REGID_EX(10 DOWNTO 7) <= ALUOP; --EX
                REGID_EX(12 DOWNTO 11) <= (REGDST,SLT); --EX
                REGID_EX(28 DOWNTO 13) <= RD1;--READ DATA 1
                REGID_EX(44 DOWNTO 29) <= RD2;--READ DATA 2
                REGID_EX(60 DOWNTO 45) <= EXT_IMM; -- EXTENDED OPERAND
                REGID_EX(63 DOWNTO 61) <= INSTRUCTION(2 DOWNTO 0); --FUNCTION
                REGID_EX(69 DOWNTO 64) <= INSTRUCTION(9 DOWNTO 4); -- DESTINATION ADDRESS
                REGID_EX(70) <= INSTRUCTION(3); --SA
                REGID_EX(86 DOWNTO 71) <= REGIF_ID(15 DOWNTO 0  ); -- IF_IF.PC+1
            END IF;
        END IF;    
    END PROCESS;  
    IF_ID:PROCESS(CLK)
    BEGIN
        IF CLEAR_IF_ID = '1' THEN
                REGIF_ID <= (OTHERS =>'0');
        ELSIF RISING_EDGE(CLK) THEN
            IF LOAD_IF_ID = '1' THEN   
                REGIF_ID(15 DOWNTO 0) <= INSTRUCTION;
                REGIF_ID(31 DOWNTO 16) <= PC;
            END IF;
        END IF;
    END PROCESS;
    muxMemToReg:process(REGID_EX(1))
    begin 
        if REGID_EX(1) = '1' then --MEMTOREG
            wd <= REGMEM_WB(17 DOWNTO 2); --MEMDATA
         else 
            wd <=  REGMEM_WB(33 DOWNTO 18); --AluRes
        end if;

end process;
    

    M1: mpg port map(clk_enable,btn(2),clk);
    M2: mpg port map(reset,btn(3),clk);
    M3:I_F port map(clk,clk_enable,reset,Jump,Pcsrc,Jump_addr,Branch_addr,PC,instruction);
    M4: SSD port map(clk,SSD_OUT,an,cat);
    
   -- REGMEM(0) = REGWRITE
   -- INSTRUCTION = REGIF_ID(15 DOWNTO 0)
   -- WA  =REGMEM_WB(37 DOWNTO 34)
    M5:I_D port map(clk,REGMEM_WB(0),REGIF_ID(15 DOWNTO 0),ExtOp,clk_enable,REGMEM_WB(37 DOWNTO 34),wd,RD1,RD2,Ext_IMM,func,sa);
    M6:U_C port map(REGIF_ID(15 DOWNTO 0),RegDst,ExtOp,ALUSrc,Branch,BranchNEq,BranchGE,SLT,Jump,ALUOp,MemWrite,MemToReg,RegWrite);
    
    -- RD1 = REGID_EX(28:13)
    -- RD2 = REGID_EX(44:29)
    -- ALUOP = REGID_EX(10:7)
    -- ALUSRC = REGID_EX(6)
    -- EXT_IMM = REGID_EX(60:45)
    -- SA = REGID_EX(70)
    -- SLT = REGID_EX(11)
    -- RegDst = REGID_EX(12)
    -- rd = REGID_EX(69:67)
    -- RT = REGID_EX(66:64)
 
   M7:E_X port map(REGID_EX(6),REGID_EX(10 DOWNTO 7),REGID_EX(11),REGID_EX(12),GREATER,ZERO,REGID_EX(60 DOWNTO 45),REGID_EX(28 DOWNTO 13),REGID_EX(44 DOWNTO 29),REGID_EX(70),ALURES,REGID_EX(86 DOWNTO 71),Branch_addr
   ,REGID_EX(69 downto 67),REGID_EX(66 downto 64),wa);
   
   -- memwrite =  regex_mem(5)
   -- alurestafterslt = REGMEM_WB(33 DOWNTO 18)
   -- rd2 =  REGEX_MEM(39 DOWNTO 24)
    M8:MEM port map(clk,clk_enable,regex_mem(5),regmem_wb(33 downto 18),regex_mem(39 downto 24),MemData);
    

    Jump_addr(15 downto 14) <= regif_id(31 downto 30); 
    Jump_addr(13) <= '0';
    Jump_addr(12 downto 0) <= REGIF_ID(12 DOWNTO 0);
      

   
--------- afisare instructiune sau program counter ----------------------------------------
    output:process(sw)
    begin 
        case sw(8 downto 5) is
        when "0000" => 
            SSD_OUT <= instruction;
        when "0001" =>
            SSD_OUT <= PC;
        when "0010" =>
            SSD_OUT <= RD1;
        when "0011" =>
            SSD_OUT <= RD2;
        when "0100" =>
            SSD_OUT <= EXT_IMM;
        when "0101"=>
            SSD_OUT <= AluRes;
        when "0110"=>
            SSD_OUT <= MemData;
        when "0111"=>
            SSD_OUT <= WD;
         when "1000"=>
            SSD_OUT <= Jump_addr;
        when "1001" =>
            SSD_OUT <= branch_addr;
        when others =>
            SSD_OUT <= X"FFFF";
        end case;
    end process;
   
--------------------------------------------------------------------------------
   
    led(0) <= RegWrite;
    led(1) <= AluSrc;
    led(2) <= ExtOP;
    
    led(3) <= memToReg;
    led(4) <= Jump;
    led(5) <= BranchGE;
    led(6) <= regDst;
    led(7) <= MemWrite;
    led(8) <= slt;
    led(9) <= pcsrc;
    
    led(10) <= aluop(0);
    led(11) <= aluop(1);
    led(12) <= aluop(2);
    led(13) <= aluop(3);
-----------------------------------------------------------------------------------
 
end Behavioral;
