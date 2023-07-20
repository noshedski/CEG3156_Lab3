library ieee;
use ieee.std_logic_1164.all; 

entity forwardingUnit is
	PORT(
		exmem_RegWrite, memwb_RegWrite  : IN STD_LOGIC;
		exmem_RegRd, idex_RegRs, idex_RegRt, memwb_RegRd : IN STD_LOGIC_VECTOR(4 downto 0);
		forwardA, forwardB : OUT STD_LOGIC_VECTOR(1 downto 0)
	);
end entity forwardingUnit;

architecture rtl of forwardingUnit is
	
	SIGNAL sigEX_MEM_RdGreaterThanRs, sigEX_MEM_RdGreaterThanRt, sigEX_MEM_RdLessThanRs, sigEX_MEM_RdLessThanRt, sigMWB_RdGreaterThanRs : STD_LOGIC; 
	SIGNAL sigMWB_RdGreaterThanRt, sigMWB_RdLessThanRs, sigMWB_RdLessThanRt, sig_exmem_Rd_great, sig_exmem_Rd_less, sig_memwb_Rd_great, sig_memwb_Rd_less : STD_LOGIC;
	SIGNAL c1, c2, c3, c4 : STD_LOGIC;
	
	component fbitcomp 
		PORT(
        i_Ai, i_Bi : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
        o_LT , o_GT : OUT STD_LOGIC
		);
	end component;
	
begin 


	exmem_Rd_gt0 : fbitcomp
		PORT MAP(
			i_Ai => exmem_RegRd,
			i_Bi => "00000",
			o_LT => sig_exmem_Rd_less,
			o_GT => sig_exmem_Rd_great
		);
			
	
	comp1: fbitcomp
		PORT MAP(
			i_Ai => exmem_RegRd,
			i_Bi => idex_RegRs,
			o_LT => sigEX_MEM_RdLessThanRs,
			o_GT => sigEX_MEM_RdGreaterThanRs
		);
		
	c1 <= NOT sigEX_MEM_RdLessThanRs AND NOT sigEX_MEM_RdGreaterThanRs;	
	
	comp2: fbitcomp
		PORT MAP(
			i_Ai => exmem_RegRd,
			i_Bi => idex_RegRt,
			o_LT => sigEX_MEM_RdLessThanRt,
			o_GT => sigEX_MEM_RdGreaterThanRt
		);
		
	c2 <= NOT sigEX_MEM_RdLessThanRt AND NOT sigEX_MEM_RdGreaterThanRt;
	
	forwardA(1) <= (sig_exmem_Rd_great AND exmem_RegWrite) AND c1;
	forwardB(1) <= (sig_exmem_Rd_great AND exmem_RegWrite) AND c2;
	
		
	memwb_Rd_gt0 : fbitcomp
		PORT MAP(
			i_Ai => memwb_RegRd,
			i_Bi => "00000",
			o_LT => sig_memwb_Rd_less,
			o_GT => sig_memwb_Rd_great
		);
		
	comp3: fbitcomp
		PORT MAP(
			i_Ai => memwb_RegRd,
			i_Bi => idex_RegRs,
			o_LT => sigMWB_RdLessThanRs,
			o_GT => sigMWB_RdGreaterThanRs
		);
		
	c3 <= NOT sigMWB_RdLessThanRs AND NOT sigMWB_RdGreaterThanRs;	
	
	comp4: fbitcomp
		PORT MAP(
			i_Ai => memwb_RegRd,
			i_Bi => idex_RegRt,
			o_LT => sigMWB_RdLessThanRt,
			o_GT => sigMWB_RdGreaterThanRt
		);
		
	c4 <= NOT sigMWB_RdLessThanRt AND NOT sigMWB_RdGreaterThanRt;	
		
	forwardA(0) <= (memwb_RegWrite AND sig_memwb_Rd_great) AND c3;
	forwardB(0) <= (memwb_RegWrite AND sig_memwb_Rd_great) AND c4;
		
end rtl;