LIBRARY ieee;
USE ieee.std_logic_1164.ALL;


ENTITY ebitcomp IS 
    PORT(
        i_Ai, i_Bi : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        o_LT , o_GT : OUT STD_LOGIC
    );
END ENTITY ebitcomp; 


architecture rtl of ebitcomp is
    SIGNAL gt7,gt6,gt5,gt4,gt3,gt2,gt1,gt0 :  STD_LOGIC;
    SIGNAL lt7,lt6,lt5,lt4,lt3,lt2,lt1,lt0 :  STD_LOGIC;
    
    component oneBitComparator 
        PORT (
            i_GTPrevious, i_LTPrevious	: IN	STD_LOGIC;
            i_Ai, i_Bi			: IN	STD_LOGIC;
            o_GT, o_LT			: OUT	STD_LOGIC
        );
    END COMPONENT oneBitComparator;

    BEGIN 

    msbcomp : oneBitComparator 
        PORT MAP(
            i_GTPrevious => '0',
            i_LTPrevious => '0',
            i_Ai => i_Ai(7),
            i_Bi => i_Bi(7), 
            o_GT => gt7,
            o_LT => lt7
    );
	
	 bit6 : oneBitComparator 
        PORT MAP(
            i_GTPrevious => gt7,
            i_LTPrevious => lt7,
            i_Ai => i_Ai(6),
            i_Bi => i_Bi(6), 
            o_GT => gt6,
            o_LT => lt6
    );
	
	 bit5 : oneBitComparator 
        PORT MAP(
            i_GTPrevious => gt6,
            i_LTPrevious => lt6,
            i_Ai => i_Ai(5),
            i_Bi => i_Bi(5), 
            o_GT => gt5,
            o_LT => lt5
    );
	 
	 bit4 : oneBitComparator 
        PORT MAP(
            i_GTPrevious => gt5,
            i_LTPrevious => lt5,
            i_Ai => i_Ai(4),
            i_Bi => i_Bi(4), 
            o_GT => gt4,
            o_LT => lt4
    );
	 
	 bit3 : oneBitComparator 
        PORT MAP(
            i_GTPrevious => gt4,
            i_LTPrevious => lt4,
            i_Ai => i_Ai(3),
            i_Bi => i_Bi(3), 
            o_GT => gt3,
            o_LT => lt3
    );
	 
    bit2 : oneBitComparator 
        PORT MAP(
            i_GTPrevious => gt3,
            i_LTPrevious => lt3,
            i_Ai => i_Ai(2),
            i_Bi => i_Bi(2), 
            o_GT => gt2,
            o_LT => lt2
    );

    bit1 : oneBitComparator 
        PORT MAP(
            i_GTPrevious => gt2,
            i_LTPrevious => lt2,
            i_Ai => i_Ai(1),
            i_Bi => i_Bi(1), 
            o_GT => gt1,
            o_LT => lt1
    );

    bit0 : oneBitComparator 
    PORT MAP(
        i_GTPrevious => gt1,
        i_LTPrevious => lt1,
        i_Ai => i_Ai(0),
        i_Bi => i_Bi(0), 
        o_GT => gt0,
        o_LT => lt0
    );

    o_GT <= gt7 or gt6 or gt5 or gt4 or gt3 or gt2 or gt1 or gt0;
    o_LT <= lt7 or lt6 or lt5 or lt4 or lt3 or lt2 or lt1 or lt0;

end rtl; 