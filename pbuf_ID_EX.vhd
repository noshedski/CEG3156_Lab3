library ieee;
use ieee.std_logic_1164.all; 

entity pbuf_ID_EX is
	PORT(
		WB_IN, Mem_IN : IN STD_LOGIC_VECTOR(1 downto 0);
		EX_IN, ifid_RegRs, ifid_RegRt, ifid_RegRd : IN STD_LOGIC_VECTOR(4 downto 0);
		readData1_IN, readData2_IN, offset_IN: IN STD_LOGIC_VECTOR(7 downto 0);
		iClock, iReset: IN STD_LOGIC;
		idex_WB, idex_Mem : OUT STD_LOGIC_VECTOR(1 downto 0);
		idex_EX, idex_RegRs, idex_RegRt, idex_RegRd : OUT STD_LOGIC_VECTOR(4 downto 0);
		idex_readData1, idex_readData2, idex_offset: OUT STD_LOGIC_VECTOR(7 downto 0)
	);
end entity pbuf_ID_EX;


architecture rtl of pbuf_ID_EX is



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
			i_value => WB_IN,
			o_Value => idex_WB
		);
		
	memorySignals : twobitregister
		PORT MAP(
			i_resetBar => iReset,
			i_load => '1',
			i_clock => iClock,
			i_value => Mem_IN,
			o_Value => idex_Mem
		);
		
	executeSignals : fivebitregister
		PORT MAP(
			i_resetBar => iReset,
			i_load => '1',
			i_clock => iClock,
			i_value => EX_IN,
			o_Value => idex_EX
		);
		

	fr1 : fivebitregister
		PORT MAP(
			i_resetBar => iReset,
			i_load => '1',
			i_clock => iClock,
			i_value => ifid_RegRt,
			o_Value => idex_RegRt
		);
		
	fr2 : fivebitregister
		PORT MAP(
				i_resetBar => iReset,
				i_load => '1',
				i_clock => iClock,
				i_value => ifid_RegRd,
				o_Value => idex_RegRd
			);
			
	fr3 : fivebitregister
		PORT MAP(
			i_resetBar => iReset,
			i_load => '1',
			i_clock => iClock,
			i_value => ifid_RegRs,
			o_Value => idex_RegRs
		);
	
	rdd1: eightbitregister
		PORT MAP(
			i_resetBar => iReset,
			i_load => '1',
			i_clock => iClock,
			i_value => readData1_IN,
			o_Value => idex_readData1
		);
		
	rdd2: eightbitregister
		PORT MAP(
			i_resetBar => iReset,
			i_load => '1',
			i_clock => iClock,
			i_value => readData2_IN,
			o_Value => idex_readData2
		);	
		
end rtl;