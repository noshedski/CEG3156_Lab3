library ieee;
use ieee.std_logic_1164.all; 

entity pbuf_EX_MEM is
	PORT(
		idex_WB, idex_Mem : IN STD_LOGIC_VECTOR(1 downto 0);
		aluResult_IN, dataMemory : IN STD_LOGIC_VECTOR(7 downto 0);
		wR_IN : IN STD_LOGIC_VECTOR(4 downto 0);
		iReset, iClock: IN STD_LOGIC;
		exmem_WB, exmem_Mem : OUT STD_LOGIC_VECTOR(1 downto 0);
		wR_OUT  : OUT STD_LOGIC_VECTOR(4 downto 0);
		aluResult_OUT, dataMemoryOUT: OUT STD_LOGIC_VECTOR(7 downto 0)
	);
end entity pbuf_EX_MEM;

architecture rtl of pbuf_EX_MEM is

	SIGNAL notZout : STD_LOGIC;

	component eightbitregister 
		PORT(
			i_resetBar, i_load	: IN	STD_LOGIC;
			i_clock			: IN	STD_LOGIC;
			i_Value			: IN	STD_LOGIC_VECTOR(7 downto 0);
			o_Value			: OUT	STD_LOGIC_VECTOR(7 downto 0));
	end component;
	
	component fivebitregister
		PORT(
			i_resetBar, i_load	: IN	STD_LOGIC;
			i_clock			: IN	STD_LOGIC;
			i_Value			: IN	STD_LOGIC_VECTOR(4 downto 0);
			o_Value			: OUT	STD_LOGIC_VECTOR(4 downto 0));
	end component;
	
	component twobitregister
		PORT(
			i_resetBar, i_load	: IN	STD_LOGIC;
			i_clock			: IN	STD_LOGIC;
			i_Value			: IN	STD_LOGIC_VECTOR(1 downto 0);
			o_Value			: OUT	STD_LOGIC_VECTOR(1 downto 0));
	end component; 
	
begin 

		
	writeback : twobitregister
		PORT MAP(
			i_resetBar => iReset,
			i_load => '1',
			i_clock => iClock,
			i_value => idex_WB,
			o_Value => exmem_WB
		);
		
	memorySignals : twobitregister
		PORT MAP(
			i_resetBar => iReset,
			i_load => '1',
			i_clock => iClock,
			i_value => idex_Mem,
			o_Value => exmem_Mem
		);
		
		
	wrd_buf : fivebitregister
		PORT MAP(
			i_resetBar => iReset,
			i_load => '1',
			i_clock => iClock,
			i_value => wr_IN,
			o_Value => wr_Out
		);
		
	dataAddress_buf : eightbitregister
		PORT MAP(
			i_resetBar => iReset,
			i_load => '1',
			i_clock => iClock,
			i_value => dataMemory,
			o_Value => dataMemoryOUT
		);
		
	alures_buf : eightbitregister
		PORT MAP(
			i_resetBar => iReset,
			i_load => '1',
			i_clock => iClock,
			i_value => aluResult_IN,
			o_Value => aluResult_OUT
		);	
		
	
end rtl;