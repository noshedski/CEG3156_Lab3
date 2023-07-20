library ieee;
use ieee.std_logic_1164.all; 

entity stallingUnit is 
	PORT(
		idex_MemRead : IN STD_LOGIC;
		idex_RegRt, ifid_RegRs, ifid_RegRt : IN STD_LOGIC_VECTOR(4 downto 0);
		stall : OUT STD_LOGIC
	);
end entity stallingUnit;

architecture rtl of stallingUnit is


	SIGNAL comp1GT, comp1LT , comp2GT, comp2LT, c1, c2 : STD_LOGIC;

	component fbitcomp 
		PORT(
        i_Ai, i_Bi : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
        o_LT , o_GT : OUT STD_LOGIC
		);
	end component;
	
begin		

	comp1 : fbitcomp
		PORT MAP(
			i_Ai => idex_RegRt,
			i_Bi => ifid_RegRs,
			o_LT => comp1LT,
			o_GT => comp1GT
		);
		
	comp2 : fbitcomp
		PORT MAP(
			i_Ai => idex_RegRt,
			i_Bi => ifid_RegRt,
			o_LT => comp2LT,
			o_GT => comp2GT
		);
		
	c1 <= NOT (comp1LT) AND (NOT comp1GT);
	c2 <= NOT (comp2LT) AND NOT (comp2GT);
	
	stall <= (idex_MemRead AND c1) OR c2;
end rtl;