LIBRARY ieee  ; 
LIBRARY std  ; 
USE ieee.std_logic_1164.all  ; 
USE ieee.std_logic_textio.all  ; 
USE ieee.std_logic_unsigned.all  ; 
USE std.textio.all  ; 
ENTITY forwardingUnitTB  IS 
END ; 
 
ARCHITECTURE forwardingUnitTB_arch OF forwardingUnitTB IS
  SIGNAL idex_RegRs   :  std_logic_vector (4 downto 0)  ; 
  SIGNAL memwb_RegWrite   :  STD_LOGIC  ; 
  SIGNAL exmem_RegWrite   :  STD_LOGIC  ; 
  SIGNAL idex_RegRt   :  std_logic_vector (4 downto 0)  ; 
  SIGNAL forwardA   :  std_logic_vector (1 downto 0)  ; 
  SIGNAL forwardB   :  std_logic_vector (1 downto 0)  ; 
  SIGNAL memwb_RegRd   :  std_logic_vector (4 downto 0)  ; 
  SIGNAL exmem_RegRd   :  std_logic_vector (4 downto 0)  ; 
  COMPONENT forwardingUnit  
    PORT ( 
      idex_RegRs  : in std_logic_vector (4 downto 0) ; 
      memwb_RegWrite  : in STD_LOGIC ; 
      exmem_RegWrite  : in STD_LOGIC ; 
      idex_RegRt  : in std_logic_vector (4 downto 0) ; 
      forwardA  : out std_logic_vector (1 downto 0) ; 
      forwardB  : out std_logic_vector (1 downto 0) ; 
      memwb_RegRd  : in std_logic_vector (4 downto 0) ; 
      exmem_RegRd  : in std_logic_vector (4 downto 0) ); 
  END COMPONENT ; 
BEGIN
  DUT  : forwardingUnit  
    PORT MAP ( 
      idex_RegRs   => idex_RegRs  ,
      memwb_RegWrite   => memwb_RegWrite  ,
      exmem_RegWrite   => exmem_RegWrite  ,
      idex_RegRt   => idex_RegRt  ,
      forwardA   => forwardA  ,
      forwardB   => forwardB  ,
      memwb_RegRd   => memwb_RegRd  ,
      exmem_RegRd   => exmem_RegRd   ) ; 



-- "Constant Pattern"
-- Start Time = 0 ps, End Time = 1 ns, Period = 0 ps
  Process
	Begin
	 exmem_RegRd  <= "01000"  ;
	wait for 1 ns ;
-- dumped values till 1 ns
	wait;
 End Process;


-- "Constant Pattern"
-- Start Time = 0 ps, End Time = 1 ns, Period = 0 ps
  Process
	Begin
	 exmem_RegWrite  <= '1'  ;
	wait for 400 ps ;
	 exmem_RegWrite  <= '0'  ;
	wait for 490 ps ;
	 exmem_RegWrite  <= '1'  ;
	wait for 110 ps ;
-- dumped values till 1 ns
	wait;
 End Process;


-- "Constant Pattern"
-- Start Time = 0 ps, End Time = 1 ns, Period = 0 ps
  Process
	Begin
	 idex_RegRs  <= "01000"  ;
	wait for 137 ps ;
	 idex_RegRs  <= "10000"  ;
	wait for 566 ps ;
	 idex_RegRs  <= "01000"  ;
	wait for 297 ps ;
-- dumped values till 1 ns
	wait;
 End Process;


-- "Constant Pattern"
-- Start Time = 0 ps, End Time = 1 ns, Period = 0 ps
  Process
	Begin
	 idex_RegRt  <= "01000"  ;
	wait for 7 ps ;
	 idex_RegRt  <= "10000"  ;
	wait for 295 ps ;
	 idex_RegRt  <= "01000"  ;
	wait for 401 ps ;
	 idex_RegRt  <= "10000"  ;
	wait for 189 ps ;
	 idex_RegRt  <= "01000"  ;
	wait for 108 ps ;
-- dumped values till 1 ns
	wait;
 End Process;


-- "Constant Pattern"
-- Start Time = 0 ps, End Time = 1 ns, Period = 0 ps
  Process
	Begin
	 memwb_RegRd  <= "01000"  ;
	wait for 1 ns ;
-- dumped values till 1 ns
	wait;
 End Process;


-- "Constant Pattern"
-- Start Time = 0 ps, End Time = 1 ns, Period = 0 ps
  Process
	Begin
	 memwb_RegWrite  <= '1'  ;
	wait for 5 ps ;
	 memwb_RegWrite  <= '0'  ;
	wait for 398 ps ;
	 memwb_RegWrite  <= '1'  ;
	wait for 597 ps ;
-- dumped values till 1 ns
	wait;
 End Process;
END;
