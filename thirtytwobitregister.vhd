LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity thirtytwobitRegister is 
	PORT (A : IN STD_LOGIC_VECTOR(31 downto 0);
			gEn, gClk, gRst : IN STD_LOGIC;
			output : OUT STD_LOGIC_VECTOR(31 downto 0);
			output_not : OUT STD_LOGIC_VECTOR(31 downto 0)
	);
end entity;


architecture rtl of thirtytwobitRegister is 

	SIGNAL D, D_not : STD_LOGIC_VECTOR(31 downto 0);

	component enARdFF_2
		PORT(
		i_resetBar	: IN	STD_LOGIC;
		i_d		: IN	STD_LOGIC;
		i_enable	: IN	STD_LOGIC;
		i_clock		: IN	STD_LOGIC;
		o_q, o_qBar	: OUT	STD_LOGIC);
	END component enARdFF_2;
	
BEGIN

	d31: enARdFF_2
		PORT MAP(
			i_d => A(31),
			i_resetBar => gRst,
			i_enable => gEn,
			i_clock => gClk,
			o_q => D(31),
			o_qBar => D_not(31)
		);
		
	d30: enARdFF_2
		PORT MAP(
			i_d => A(30),
			i_resetBar => gRst,
			i_enable => gEn,
			i_clock => gClk,
			o_q => D(30),
			o_qBar => D_not(30)
		);
		
	d29: enARdFF_2
		PORT MAP(
			i_d => A(29),
			i_resetBar => gRst,
			i_enable => gEn,
			i_clock => gClk,
			o_q => D(29),
			o_qBar => D_not(29)
		);
		
	d28: enARdFF_2
		PORT MAP(
			i_d => A(28),
			i_resetBar => gRst,
			i_enable => gEn,
			i_clock => gClk,
			o_q => D(28),
			o_qBar => D_not(28)
		);
		
	d27: enARdFF_2
		PORT MAP(
			i_d => A(27),
			i_resetBar => gRst,
			i_enable => gEn,
			i_clock => gClk,
			o_q => D(27),
			o_qBar => D_not(27)
		);
		
	d26: enARdFF_2
		PORT MAP(
			i_d => A(26),
			i_resetBar => gRst,
			i_enable => gEn,
			i_clock => gClk,
			o_q => D(26),
			o_qBar => D_not(26)
		);
		
	d25: enARdFF_2
		PORT MAP(
			i_d => A(25),
			i_resetBar => gRst,
			i_enable => gEn,
			i_clock => gClk,
			o_q => D(25),
			o_qBar => D_not(25)
		);
		
	d24: enARdFF_2
		PORT MAP(
			i_d => A(24),
			i_resetBar => gRst,
			i_enable => gEn,
			i_clock => gClk,
			o_q => D(24),
			o_qBar => D_not(24)
		);
		
	d23: enARdFF_2
		PORT MAP(
			i_d => A(23),
			i_resetBar => gRst,
			i_enable => gEn,
			i_clock => gClk,
			o_q => D(23),
			o_qBar => D_not(23)
		);
		
	d22: enARdFF_2
		PORT MAP(
			i_d => A(22),
			i_resetBar => gRst,
			i_enable => gEn,
			i_clock => gClk,
			o_q => D(22),
			o_qBar => D_not(22)
		);
		
	d21: enARdFF_2
		PORT MAP(
			i_d => A(21),
			i_resetBar => gRst,
			i_enable => gEn,
			i_clock => gClk,
			o_q => D(21),
			o_qBar => D_not(21)
		);
		
		
	d20: enARdFF_2
		PORT MAP(
			i_d => A(20),
			i_resetBar => gRst,
			i_enable => gEn,
			i_clock => gClk,
			o_q => D(20),
			o_qBar => D_not(20)
		);
		
	d19: enARdFF_2
		PORT MAP(
			i_d => A(19),
			i_resetBar => gRst,
			i_enable => gEn,
			i_clock => gClk,
			o_q => D(19),
			o_qBar => D_not(19)
		);
		
	d18: enARdFF_2
		PORT MAP(
			i_d => A(18),
			i_resetBar => gRst,
			i_enable => gEn,
			i_clock => gClk,
			o_q => D(18),
			o_qBar => D_not(18)
		);
		
	d17: enARdFF_2
		PORT MAP(
			i_d => A(17),
			i_resetBar => gRst,
			i_enable => gEn,
			i_clock => gClk,
			o_q => D(17),
			o_qBar => D_not(17)
		);
		
	d16: enARdFF_2
		PORT MAP(
			i_d => A(16),
			i_resetBar => gRst,
			i_enable => gEn,
			i_clock => gClk,
			o_q => D(16),
			o_qBar => D_not(16)
		);
	
	d15: enARdFF_2
		PORT MAP(
			i_d => A(15),
			i_resetBar => gRst,
			i_enable => gEn,
			i_clock => gClk,
			o_q => D(15),
			o_qBar => D_not(15)
		);
	
	d14: enARdFF_2
		PORT MAP(
			i_d => A(14),
			i_resetBar => gRst,
			i_enable => gEn,
			i_clock => gClk,
			o_q => D(14),
			o_qBar => D_not(14)
		);
		
	d13: enARdFF_2
		PORT MAP(
			i_d => A(13),
			i_resetBar => gRst,
			i_enable => gEn,
			i_clock => gClk,
			o_q => D(13),
			o_qBar => D_not(13)
		);
		
	d12: enARdFF_2
		PORT MAP(
			i_d => A(12),
			i_resetBar => gRst,
			i_enable => gEn,
			i_clock => gClk,
			o_q => D(12),
			o_qBar => D_not(12)
		);
		
		
	d11: enARdFF_2
		PORT MAP(
			i_d => A(11),
			i_resetBar => gRst,
			i_enable => gEn,
			i_clock => gClk,
			o_q => D(11),
			o_qBar => D_not(11)
		);
		
	d10: enARdFF_2
		PORT MAP(
			i_d => A(10),
			i_resetBar => gRst,
			i_enable => gEn,
			i_clock => gClk,
			o_q => D(10),
			o_qBar => D_not(10)
		);
		
	d9: enARdFF_2
		PORT MAP(
			i_d => A(9),
			i_resetBar => gRst,
			i_enable => gEn,
			i_clock => gClk,
			o_q => D(9),
			o_qBar => D_not(9)
		);
		
	d8: enARdFF_2
		PORT MAP(
			i_d => A(8),
			i_resetBar => gRst,
			i_enable => gEn,
			i_clock => gClk,
			o_q => D(8),
			o_qBar => D_not(8)
		);
		
	d7: enARdFF_2
		PORT MAP(
			i_d => A(7),
			i_resetBar => gRst,
			i_enable => gEn,
			i_clock => gClk,
			o_q => D(7),
			o_qBar => D_not(7)
		);
		
	d6: enARdFF_2
		PORT MAP(
			i_d => A(6),
			i_resetBar => gRst,
			i_enable => gEn,
			i_clock => gClk,
			o_q => D(6),
			o_qBar => D_not(6)
		);
		
	d5: enARdFF_2
		PORT MAP(
			i_d => A(5),
			i_resetBar => gRst,
			i_enable => gEn,
			i_clock => gClk,
			o_q => D(5),
			o_qBar => D_not(5)
		);
		
	d4: enARdFF_2
		PORT MAP(
			i_d => A(4),
			i_resetBar => gRst,
			i_enable => gEn,
			i_clock => gClk,
			o_q => D(4),
			o_qBar => D_not(4)
		);
		
	d3: enARdFF_2
		PORT MAP(
			i_d => A(3),
			i_resetBar => gRst,
			i_enable => gEn,
			i_clock => gClk,
			o_q => D(3),
			o_qBar => D_not(3)
		);
		
	d2: enARdFF_2
		PORT MAP(
			i_d => A(2),
			i_resetBar => gRst,
			i_enable => gEn,
			i_clock => gClk,
			o_q => D(2),
			o_qBar => D_not(2)
		);
		
	d1: enARdFF_2
		PORT MAP(
			i_d => A(1),
			i_resetBar => gRst,
			i_enable => gEn,
			i_clock => gClk,
			o_q => D(1),
			o_qBar => D_not(1)
		);
	
	d0: enARdFF_2
		PORT MAP(
			i_d => A(0),
			i_resetBar => gRst,
			i_enable => gEn,
			i_clock => gClk,
			o_q => D(0),
			o_qBar => D_not(0)
		);
		
		
	output <= D;
	output_not <= D_not;
	
end rtl;