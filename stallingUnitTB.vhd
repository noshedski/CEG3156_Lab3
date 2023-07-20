LIBRARY ieee  ; 
LIBRARY std  ; 
USE ieee.std_logic_1164.all  ; 
USE ieee.std_logic_textio.all  ; 
USE ieee.std_logic_unsigned.all  ; 
USE std.textio.all  ; 
ENTITY stallingUnitTB  IS 
END ; 
 
ARCHITECTURE stallingUnitTB_arch OF stallingUnitTB IS
  SIGNAL stall   :  STD_LOGIC  ; 
  SIGNAL idex_MemRead   :  STD_LOGIC  ; 
  SIGNAL idex_RegRt   :  std_logic_vector (4 downto 0)  ; 
  SIGNAL ifid_RegRs   :  std_logic_vector (4 downto 0)  ; 
  SIGNAL ifid_RegRt   :  std_logic_vector (4 downto 0)  ; 
  COMPONENT stallingUnit  
    PORT ( 
      stall  : out STD_LOGIC ; 
      idex_MemRead  : in STD_LOGIC ; 
      idex_RegRt  : in std_logic_vector (4 downto 0) ; 
      ifid_RegRs  : in std_logic_vector (4 downto 0) ; 
      ifid_RegRt  : in std_logic_vector (4 downto 0) ); 
  END COMPONENT ; 
BEGIN
  DUT  : stallingUnit  
    PORT MAP ( 
      stall   => stall  ,
      idex_MemRead   => idex_MemRead  ,
      idex_RegRt   => idex_RegRt  ,
      ifid_RegRs   => ifid_RegRs  ,
      ifid_RegRt   => ifid_RegRt   ) ; 



-- "Constant Pattern"
-- Start Time = 0 ps, End Time = 1 ns, Period = 0 ps
  Process
	Begin
	 idex_MemRead  <= '0'  ;
	wait for 103 ps ;
	 idex_MemRead  <= '1'  ;
	wait for 511 ps ;
	 idex_MemRead  <= '0'  ;
	wait for 81 ps ;
	 idex_MemRead  <= '1'  ;
	wait for 305 ps ;
-- dumped values till 1 ns
	wait;
 End Process;


-- "Constant Pattern"
-- Start Time = 0 ps, End Time = 1 ns, Period = 0 ps
  Process
	Begin
	 idex_RegRt  <= "01000"  ;
	wait for 427 ps ;
	 idex_RegRt  <= "10000"  ;
	wait for 94 ps ;
	 idex_RegRt  <= "01000"  ;
	wait for 1 ps ;
	 idex_RegRt  <= "00100"  ;
	wait for 176 ps ;
	 idex_RegRt  <= "01000"  ;
	wait for 302 ps ;
-- dumped values till 1 ns
	wait;
 End Process;


-- "Constant Pattern"
-- Start Time = 0 ps, End Time = 1 ns, Period = 0 ps
  Process
	Begin
	 ifid_RegRs  <= "01000"  ;
	wait for 252 ps ;
	 ifid_RegRs  <= "10000"  ;
	wait for 175 ps ;
	 ifid_RegRs  <= "01000"  ;
	wait for 573 ps ;
-- dumped values till 1 ns
	wait;
 End Process;


-- "Constant Pattern"
-- Start Time = 0 ps, End Time = 1 ns, Period = 0 ps
  Process
	Begin
	 ifid_RegRt  <= "00100"  ;
	wait for 1 ns ;
-- dumped values till 1 ns
	wait;
 End Process;
END;
