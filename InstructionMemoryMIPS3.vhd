library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity InstructionMemory is
  port( -- input
        register_addr : in  std_logic_vector(31 downto 0);

        -- output
        instruction   : out std_logic_vector(31 downto 0) );
end InstructionMemory;

architecture Behavioral of InstructionMemory is

type reg is array (0 to 10) of std_logic_vector(31 downto 0);
signal instr_memory: reg := (

	--addi $3,$0,1
	0 => "00100000011000000000000000000001",
	--addi $5,$0,3
	1=>  "00100000101000000000000000000011",
	-- L1:add $6,$3,$0
	2=>  "00000000011000000011000000100000",
	--sw $6,0($4)
	3=>  "10101100100001100000000000000000",
	--addi $3,$3,1
	4=>  "00100000011000110000000000000001",
	--addi $4,$4,1
	5=>  "00100000100000100000000000000001",
	--addi $5,$5,01
	6=>  "00100000101001011111111111111111",
	--bne $5,$0,L1
	7=>  "00010100101000001111111111111010",
	others=> "00000000000000000000000000000000" );

begin
  instruction <= instr_memory(to_integer(unsigned(register_addr)));
end Behavioral;