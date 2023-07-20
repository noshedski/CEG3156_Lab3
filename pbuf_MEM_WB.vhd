library ieee;
use ieee.std_logic_1164.all; 

entity pbuf_MEM_WB is
	PORT(
		exmem_WB: IN STD_LOGIC_VECTOR(1 downto 0);
		aluResult_IN, dataMem_IN : IN STD_LOGIC_VECTOR(7 downto 0);
		wR_IN  : IN STD_LOGIC_VECTOR(4 downto 0);	
		iClock, iReset: IN STD_LOGIC;
		memwb_WB : OUT STD_LOGIC_VECTOR(1 downto 0);
		aluResult_OUT, dataMem_OUT : OUT STD_LOGIC_VECTOR(7 downto 0);
		wR_OUT : OUT STD_LOGIC_VECTOR(4 downto 0)
	);
end entity pbuf_MEM_WB;


architecture rtl of pbuf_MEM_WB is


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
			i_value => exmem_WB,
			o_Value => memwb_WB
		);
		
	alures_buf : eightbitregister
		PORT MAP(
			i_resetBar => iReset,
			i_load => '1',
			i_clock => iClock,
			i_value => aluResult_IN,
			o_Value => aluResult_OUT
		);	
	
	dataMemRead : eightbitregister
		PORT MAP(
			i_resetBar => iReset,
			i_load => '1',
			i_clock => iClock,
			i_value => dataMem_IN,
			o_Value => dataMem_OUT
		);
	
	wrd_buf : fivebitregister
		PORT MAP(
			i_resetBar => iReset,
			i_load => '1',
			i_clock => iClock,
			i_value => wr_IN,
			o_Value => wr_Out
		);
	
end rtl;	
	