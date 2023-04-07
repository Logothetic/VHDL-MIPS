library ieee;
use ieee.std_logic_1164.all;


entity Mips is
	GENERIC (n : integer := 32);
	port( CLK, reset_neg : in std_logic );
end Mips;

architecture Behavioral of Mips is

	component ControlUnit is
	port( -- input
		instruction : in std_logic_vector(31 downto 0);
		ZeroCarry   : in std_logic;

		-- output (control signals)
		RegDst      : out std_logic;
		Branch      : out std_logic;
		MemRead     : out std_logic;
		MemToReg    : out std_logic;
		ALUOp       : out std_logic_vector (1 downto 0);  -- 4 operations
		MemWrite    : out std_logic;
		ALUSrc      : out std_logic;
		RegWrite    : out std_logic );
	end component;

	component DataPath is
	port( -- inputs
	CLK, reset_neg    : in std_logic;
	instruction       : in std_logic_vector(31 downto 0);
	-- control signals
	RegDst            : in std_logic;
	Branch            : in std_logic;
	MemRead           : in std_logic;
	MemToReg          : in std_logic;
	ALUOp             : in std_logic_vector(1 downto 0);
	MemWrite          : in std_logic;
	ALUSrc            : in std_logic;
	RegWrite          : in std_logic;

	-- outputs
	next_instruction  : out std_logic_vector(31 downto 0);
	ZeroCarry         : out std_logic );
	end component;

	component InstructionMemory is
	port( -- input
	register_addr : in  std_logic_vector(31 downto 0);

	-- output
	instruction   : out std_logic_vector(31 downto 0) );
	end component;

	signal RegDst_m        : std_logic;
	signal Branch_m        : std_logic;
	signal MemRead_m       : std_logic;
	signal MemToReg_m      : std_logic;
	signal MemWrite_m      : std_logic;
	signal RegWrite_m      : std_logic;
	signal ALUSrc_m        : std_logic;
	signal ZeroCarry_m     : std_logic;
	signal ALUOp_m    	   : std_logic_vector(1 downto 0);
	signal instr		   : std_logic_vector(31 downto 0);
	signal NextInstruction : std_logic_vector(31 downto 0);
	
	begin
	CU : ControlUnit  port map( 
						instr,
						ZeroCarry_m,
						RegDst_m,
						Branch_m,
						MemRead_m,
						MemToReg_m,
						ALUOp_m,
						MemWrite_m,
						ALUSrc_m,
						RegWrite_m );

	DP : DataPath     port map( 
						CLK,
						reset_neg,
						instr,
						RegDst_m,
						Branch_m,
						MemRead_m,
						MemToReg_m,
						ALUOp_m,
						MemWrite_m,
						ALUSrc_m,
						RegWrite_m,
						NextInstruction,
						ZeroCarry_m );


	I  : InstructionMemory  port map( NextInstruction, instr );
	
end Behavioral;