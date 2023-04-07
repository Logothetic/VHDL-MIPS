
library ieee;
use ieee.std_logic_1164.all;

entity ControlUnit is
  port( -- input
        instruction : in std_logic_vector(31 downto 0);
        ZeroCarry   : in std_logic;

        -- output (control signals)
        RegDst      : out std_logic;
        Branch      : out std_logic;
        MemRead     : out std_logic;
        MemToReg    : out std_logic;
        ALUOp       : out std_logic_vector (1 downto 0);  -- 3 operations
        MemWrite    : out std_logic;
        ALUSrc      : out std_logic;
        RegWrite    : out std_logic );
end ControlUnit;

architecture Behavioral of ControlUnit is
  signal data : std_logic_vector(8 downto 0);  -- used to set the control signals

begin
  -- in according to the standard MIPS32 instruction reference
  -- add
  data <= "100000001" when (instruction(31 downto 26) = "000000" and
                               instruction(10 downto 0)  = "00000000001") else
  -- subtract
  "100001001" when (instruction(31 downto 26) = "000000" and
                       instruction(10 downto 0)  = "00000100010") else
  -- shift left logical
  "100010011" when (instruction(31 downto 26) = "000000" and
                       instruction(5 downto 0)   = "000000") else
  -- add immediate
  "000000011" when instruction(31 downto 26) = "001000" else
  -- load word
  "001100011" when instruction(31 downto 26) = "100011" else
  -- store word
  "000000110" when instruction(31 downto 26) = "101011" else
  -- branch on not equal
  "010011010" when instruction(31 downto 26) = "000101" else
  -- otherwise
  (others =>'0');

  RegDst   <= data(8);
  -- AND port included considering the LSB of beq and bne
  Branch   <= data(7) AND (ZeroCarry XOR instruction(26));
  MemRead  <= data(6);
  MemToReg <= data(5);
  ALUOp    <= data(4 downto 3);  -- 4 operations available
  MemWrite <= data(2);
  ALUSrc   <= data(1);
  RegWrite <= data(0);

end Behavioral;