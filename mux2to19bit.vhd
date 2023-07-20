library ieee;
use ieee.std_logic_1164.all; 

entity mux2to19bit is
    Port ( s : in  STD_LOGIC;
           w0 , w1  : in  STD_LOGIC_VECTOR(8 Downto 0);
           f   : out STD_LOGIC_VECTOR(8 Downto 0));
end mux2to19bit;

architecture Behavioral of mux2to19bit is
begin
    f <= w1 when (s = '1') else w0;
end Behavioral;