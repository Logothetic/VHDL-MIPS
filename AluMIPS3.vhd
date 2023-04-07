library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is
  GENERIC(n : integer := 32);
  port( -- input
        operand_1   : in std_logic_vector(n - 1 downto 0);
        operand_2   : in std_logic_vector(n - 1 downto 0);
        ALU_control : in std_logic_vector(1 downto 0);  -- 4 operations

        -- output
        result      : out std_logic_vector(n - 1 downto 0);
        zero        : out std_logic );
end ALU;

architecture Behavioral of ALU is
  signal temp : std_logic_vector(n - 1 downto 0);

begin

  temp <=
    -- add
    std_logic_vector(unsigned(operand_1) + unsigned(operand_2)) after 1 ns when ALU_control = "00" else
    -- subtract
    std_logic_vector(unsigned(operand_1) - unsigned(operand_2)) after 1 ns when ALU_control = "01" else   
	 -- XOR
    operand_1 XOR  operand_2 after 1 ns when ALU_control = "11" else
    -- shift left logical
    std_logic_vector(shift_left(unsigned(operand_1), to_integer(unsigned(operand_2(10 downto 6))))) after 1 ns when ALU_control = "10" else

    -- in other cases
    (others => '0');

  zero <= '1' when (temp <= "00000000000000000000000000000000") else '0';
  result <= temp;

end Behavioral;