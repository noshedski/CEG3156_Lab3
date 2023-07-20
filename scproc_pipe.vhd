library ieee;
use ieee.std_logic_1164.all; 

entity scproc_pipe is 
	PORT(
	gClock, gReset, clk_2, clk_8: in STD_LOGIC;
	valueSelect : IN STD_LOGIC_VECTOR(2 downto 0);
	MuxOUT,  brAddress, jAddress : OUT STD_LOGIC_VECTOR(7 downto 0);
	instruction_OUT : OUT STD_LOGIC_VECTOR(31 downto 0);
	-- wrAddress : OUT STD_LOGIC_VECTOR(4 downto 0); -- , memOUT, rdA, rdB,
	zeroOut, MemWriteOUT, RegWriteOUT, branchOUT : OUT STD_LOGIC
	);
end entity scproc_pipe;


architecture rtl of scproc_pipe is

	SIGNAL buf_idex_WB, buf_idex_Mem, buf_exmem_WB, buf_exmem_Mem , buf_memwb_WB, buf_memwb_Mem, sigBUF_EX_forwardA,  sigBUF_EX_forwardB : STD_LOGIC_VECTOR(1 downto 0);
	sigNAL sig_ifid_AluOP: STD_LOGIC_VECTOR(2 downto 0);
	signal buf_ifid_cSigs : STD_LOGIC_VECTOR(8 downto 0);
	signal buf_idex_RegRt, buf_ifid_RegRs, buf_ifid_RegRt, buf_memwb_wr, buf_idex_EX, buf_memwb_RegRd, buf_exmem_RegRd, buf_idex_chosenDestinationAddress, buf_exmem_wR, buf_idex_RegRs, buf_idex_RegRd : STD_LOGIC_VECTOR(4 downto 0);
	SIGNAL buf_ifid_chosenPC, buf_if_currentPC, buf_if_pcp4, buf_ifid_nextPC, readA, readB, buf_ifid_SignExtend, aluB, buf_ifid_JumpADDRESS, buf_ifid_BranchAddress, buf_ifid_ChosenBranchorPCP4, buf_id_chosenNEXTPC: STD_LOGIC_VECTOR(7 downto 0);
	SIGNAL buf_idex_ReadDataA, buf_idex_ReadDataB, buf_exmem_aluResult, buf_memwb_aluResult, buf_EX_A, buf_EX_B, buf_EX_ALUresult, buf_exmem_DataMemory, buf_MEM_dataSelect, buf_memwb_dataSelect, bufWriteData, bufOTHERS  : STD_LOGIC_VECTOR(7 downto 0);
	SigNAL pInstruction, cInstruction: STD_LOGIC_VECTOR(31 downto 0);
	signal sig_if_Skip, sig_ifid_Jump, sig_ifid_Branch, sig_ifid_stall, sig_ifid_RegWrite, sig_ifid_MemRead, sig_ifid_Mem2Reg, sig_ifid_MemWrite, sig_ifid_RegDest, sig_ifid_BNE, carryoutBranch, oflowBranch : STD_LOGIC;
	signal sig_ifid_AluSRC, sig_ifid_rd1LTrd2, sig_ifid_rd1GTrd2, sig_ifid_bEq, sig_ifid_ChooseAddress, zeroFlag  : STD_LOGIC;

	component addsub8bit 
		port( OP: in std_logic;
				 A,B  : in std_logic_vector(7 downto 0);
				 R  : out std_logic_vector(7 downto 0);
				 Cout, OVERFLOW : out std_logic);
	end component addsub8bit;

	component fileRegister 
		PORT(
			gClock, gReset, regWrite : IN STD_LOGIC;
			addRR1, addRR2 : IN STD_logic_vector(4 downto 0);
			writeData  : IN STD_logic_vector(7 downto 0);
			writeRegister : IN STD_logic_vector(4 downto 0);
			readReg1: OUT STD_logic_vector(7 downto 0);
			readReg2 : OUT STD_logic_vector(7 downto 0)
		);
	end component fileRegister;
	
	component pc_plus4 
		PORT(
			pcin : IN STD_LOGIC_VECTOR(7 downto 0);
			gClock, clk8, gReset, skip : IN STD_LOGIC;
			pcp4, pcCurrent : OUT STD_LOGIC_VECTOR(7 downto 0);
			instructionOUT : OUT STD_LOGIC_VECTOR( 31 downto 0)
		);
	end component pc_plus4;
	
	component alu8bit 
		PORT(
			rA,rB : IN STD_LOGIC_VECTOR(7 downto 0);
			aluOP: IN STD_LOGIC_VECTOR(2 downto 0);
			alurOUT : OUT STD_LOGIC_VECTOR(7 downto 0);
			zeroes : OUT STD_logic
		);
	end component alu8bit;
	
	component mux2to18bit 
		 Port ( s : in  STD_LOGIC;
				  w0 , w1  : in  STD_LOGIC_VECTOR(7 Downto 0);
				  f   : out STD_LOGIC_VECTOR(7 Downto 0));
	end component mux2to18bit;
	
	component mux2to1_5bit 
		 Port ( s : in  STD_LOGIC;
				  w0 , w1  : in  STD_LOGIC_VECTOR(4 Downto 0);
				  f   : out STD_LOGIC_VECTOR(4 Downto 0));
	end component mux2to1_5bit;
	
	component mux4to1_8bit 
		 Port ( sel : in  STD_LOGIC_VECTOR(1 downto 0);
				  w0 , w1, w2, w3  : in  STD_LOGIC_VECTOR(7 Downto 0);
				  f   : out STD_LOGIC_VECTOR(7 Downto 0));
	end component mux4to1_8bit;
	
	component mux6to1_8bit
		Port ( sel : in  STD_LOGIC_VECTOR(2 downto 0);
           w0 , w1, w2, w3, w4, w5  : in  STD_LOGIC_VECTOR(7 Downto 0);
           f   : out STD_LOGIC_VECTOR(7 Downto 0));
	end component mux6to1_8bit;
	
	component shift_left2_addpc 
		PORT(
			toShift : IN STD_logic_VECTOR(3 downto 0);
			pc_val : IN STD_logic_VECTOR(7 downto 0);
			shifted : OUT StD_logic_VECTOR(7 downto 0)
		);
	end component shift_left2_addpc;
	
	component controlUnit 
		PORT (
			instructionCode : IN STD_LOGIC_VECTOR(5 downto 0);
			RegWrite, Jump, Branch, MemRead, MemToReg, MemWrite, ALUSrc, BNE, RegDst: OUT STD_LOGIC;
			ALUop : OUT STD_LOGIC_VECTOR(2 downto 0)
		);
	end component;
	
	COMPONENT dataMem
		PORT
		(
			clk		:	 IN STD_LOGIC;
			clk2		 :  IN STD_LOGIC;
			writeData		:	 IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			address		:	 IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			mWrite		:	 IN STD_LOGIC;
			valu		:	 OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
		);
	END COMPONENT;
	
	component pbuf_IF_ID
		PORT(
			instructionIN : IN STD_LOGIC_VECTOR(31 downto 0);
			pcp4_IN : IN STD_LOGIC_VECTOR(7 downto 0);
			iClock, iReset, eFLUSH : IN STD_LOGIC;
			ifid_instructionOUT: OUT STD_LOGIC_VECTOR(31 downto 0);
			ifid_pcp4_OUT : OUT STD_LOGIC_VECTOR(7 downto 0)
		);
	end component;
	
	component pbuf_ID_EX
		PORT(
			WB_IN, Mem_IN : IN STD_LOGIC_VECTOR(1 downto 0);
			EX_IN, ifid_RegRs, ifid_RegRt, ifid_RegRd : IN STD_LOGIC_VECTOR(4 downto 0);
			readData1_IN, readData2_IN: IN STD_LOGIC_VECTOR(7 downto 0);
			iClock, iReset: IN STD_LOGIC;
			idex_WB, idex_Mem : OUT STD_LOGIC_VECTOR(1 downto 0);
			idex_EX, idex_RegRs, idex_RegRt, idex_RegRd : OUT STD_LOGIC_VECTOR(4 downto 0);
			idex_readData1, idex_readData2: OUT STD_LOGIC_VECTOR(7 downto 0)
		);
	end component;
	
	component pbuf_EX_MEM
		PORT(
			idex_WB, idex_Mem : IN STD_LOGIC_VECTOR(1 downto 0);
			aluResult_IN, dataMemory : IN STD_LOGIC_VECTOR(7 downto 0);
			wR_IN : IN STD_LOGIC_VECTOR(4 downto 0);
			iReset, iClock: IN STD_LOGIC;
			exmem_WB, exmem_Mem : OUT STD_LOGIC_VECTOR(1 downto 0);
			wR_OUT  : OUT STD_LOGIC_VECTOR(4 downto 0);
			aluResult_OUT, dataMemoryOUT: OUT STD_LOGIC_VECTOR(7 downto 0)
			);
	end component;
	
	component pbuf_MEM_WB
		PORT(
			exmem_WB: IN STD_LOGIC_VECTOR(1 downto 0);
			aluResult_IN, dataMem_IN : IN STD_LOGIC_VECTOR(7 downto 0);
			wR_IN  : IN STD_LOGIC_VECTOR(4 downto 0);	
			iClock, iReset: IN STD_LOGIC;
			memwb_WB : OUT STD_LOGIC_VECTOR(1 downto 0);
			aluResult_OUT, dataMem_OUT : OUT STD_LOGIC_VECTOR(7 downto 0);
			wR_OUT : OUT STD_LOGIC_VECTOR(4 downto 0)
		);
	end component;
	
	component forwardingUnit
		PORT(
			exmem_RegWrite, memwb_RegWrite  : IN STD_LOGIC;
			exmem_RegRd, idex_RegRs, idex_RegRt, memwb_RegRd : IN STD_LOGIC_VECTOR(4 downto 0);
			forwardA, forwardB : OUT STD_LOGIC_VECTOR(1 downto 0)
		);
	end component;
	
	component stallingUnit
		PORT(
			idex_MemRead : IN STD_LOGIC;
			idex_RegRt, ifid_RegRs, ifid_RegRt : IN STD_LOGIC_VECTOR(4 downto 0);
			stall : OUT STD_LOGIC
		);
	end component;
	
	component ebitcomp IS 
		 PORT(
			  i_Ai, i_Bi : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			  o_LT , o_GT : OUT STD_LOGIC
		 );
	END component; 
	
	component mux2to19bit IS
		Port ( s : in  STD_LOGIC;
				  w0 , w1  : in  STD_LOGIC_VECTOR(8 Downto 0);
				  f   : out STD_LOGIC_VECTOR(8 Downto 0));
	end component;
		
begin 

	sig_if_Skip <= sig_ifid_Jump OR sig_ifid_Branch;

	pcp4Unit : pc_plus4
		PORT MAP(
			pcin => buf_id_chosenNEXTPC,
			gClock => gClock,
			clk8 => clk_8,
			skip => sig_if_Skip,
			gReset => gReset ,
			pcCurrent => buf_if_currentPC,
			pcp4 => buf_if_pcp4,
			instructionOUT => pInstruction
		);

		
	bufIF_ID : pbuf_IF_ID
		PORT MAP(
			instructionIN => pInstruction,
			pcp4_IN => buf_if_pcp4,
			iClock => gClock,
			iReset => gReset,
			eFLUSH => sig_if_Skip,
			ifid_instructionOUT => cInstruction,
			ifid_pcp4_OUT => buf_ifid_nextPC
		);	
		
		
	staller : stallingUnit
		PORT MAP(
			idex_MemRead => buf_idex_Mem(1), --ERRROR 
			idex_RegRt => buf_idex_RegRt,
			ifid_RegRs => buf_ifid_RegRs,
			ifid_RegRt => buf_ifid_RegRt,
			stall => sig_ifid_Stall
		);
	
	cU: controlUnit
		PORT MAP(
			instructionCode => cInstruction(31 downto 26),
			RegWrite => sig_ifid_RegWrite,
			Jump => sig_ifid_Jump,
			Branch => sig_ifid_Branch,
			MemRead => sig_ifid_MemRead,
			MemToReg => sig_ifid_Mem2Reg,
			MemWrite => sig_ifid_MemWrite,
			ALUSrc => sig_ifid_AluSRC,
			RegDst => sig_ifid_RegDest,
			BNE => sig_ifid_BNE,
			ALUop => sig_ifid_AluOP
		);
		
	fReg : fileRegister
		PORT MAP(
			gClock => clk_8,
			gReset => gReset,
			regWrite => buf_memwb_WB(1), -- write back reg write
			addRR1 => cInstruction(25 downto 21),
			addRR2 => cInstruction(20 downto 16),
			writeData => bufWriteData,
			writeRegister => buf_memwb_wr,
			readReg1 => readA,
			readReg2 => readB
		);
		
	buf_ifid_SignExtend <= cInstruction(7 downto 0);	
		
	chooseB : mux2to18bit
		PORT MAP(
			s => sig_ifid_AluSRC,
			w0 => readB,
			w1 => buf_ifid_SignExtend,
			f => aluB
		);

	jumpADDr : shift_left2_addpc
		PORT MAP(
			toShift => cInstruction(3 downto 0),
			pc_val => buf_ifid_nextPC, 
			shifted=> buf_ifid_JumpADDRESS
		);
	
	addpcp4 : addsub8bit
		PORT MAP(
			OP => '0',
			A => buf_ifid_nextPC,
			B => buf_ifid_SignExtend,
			R => buf_ifid_BranchAddress,
			Cout => carryoutBranch,
			OVERFLOW => oflowBranch
		);
		
	bEqual: ebitcomp
		PORT MAP(
			i_Ai => readA, -- read data 1
			i_Bi => readB, -- read data 2
			o_LT => sig_ifid_rd1LTrd2,
			o_GT => sig_ifid_rd1GTrd2
		);
		
	sig_ifid_bEq <= sig_ifid_rd1GTrd2 AND sig_ifid_rd1LTrd2;
	sig_ifid_ChooseAddress <= (sig_ifid_Branch AND sig_ifid_bEq) OR (sig_ifid_BNE AND NOT sig_ifid_bEq);
	 
	chooseAddress : mux2to18bit
		PORT MAP(
			s => sig_ifid_ChooseAddress,
			w0 => buf_ifid_nextPC, -- change this
			w1 => buf_ifid_BranchAddress,
			f => buf_ifid_ChosenBranchorPCP4
		);
		
	chooseJBrPCP4 : mux2to18bit
		PORT MAP(
			s => sig_ifid_Jump,
			w0 => buf_ifid_ChosenBranchorPCP4,
			w1 => buf_ifid_JumpADDRESS,
			f =>  buf_ifid_chosenPC
		);
		
	chooseBranchORStall : mux2to18bit
		PORT MAP(
			s => sig_ifid_stall,
			w0 => buf_ifid_chosenPC,
			w1 => buf_if_currentPC,
			f => buf_id_chosenNEXTPC
		
		);
		
	
	chooseStall : mux2to19bit
		PORT MAP(
			s => sig_ifid_stall,
			w0 => sig_ifid_RegWrite & sig_ifid_Mem2Reg & sig_ifid_MemRead & sig_ifid_MemWrite & sig_ifid_RegDest & sig_ifid_AluSRC & sig_ifid_AluOP,
			w1 => "000000000",
			f => buf_ifid_cSigs
		);
	
	bufidex : pbuf_ID_EX
		PORT MAP(
			WB_IN => buf_ifid_cSigs(8 downto 7),
			MEM_IN => buf_ifid_cSigs(6 downto 5),
			EX_IN =>  buf_ifid_cSigs(4 downto 0), 
			ifid_RegRs => cInstruction(25 downto 21),
			ifid_RegRt => cInstruction(20 downto 16),
			ifid_RegRd => cInstruction(15 downto 11),
			readData1_IN => readA,
			readData2_IN => alub,
			iClock => gClock,
			iReset => gReset,
			idex_WB => buf_idex_WB,
			idex_Mem => buf_idex_Mem,
			idex_EX => buf_idex_EX,
			idex_RegRs => buf_idex_RegRs,
			idex_RegRt => buf_idex_RegRt,
			idex_RegRd => buf_idex_RegRd,
			idex_ReadData1 => buf_idex_ReadDataA,
			idex_ReadData2 => buf_idex_ReadDataB
		);
	
	fwdUnit : forwardingUnit
		PORT MAP(
			exmem_RegWrite => buf_exmem_WB(1),
			memwb_RegWrite => buf_memwb_Mem(0),
			exmem_RegRd => buf_exmem_RegRd,
			idex_RegRs => buf_idex_RegRs,
			idex_RegRt => buf_idex_RegRt,
			memwb_RegRd => buf_memwb_RegRd, -- outpuit
			forwardA => sigBUF_EX_forwardA,
			forwardB =>	sigbuf_EX_forwardB
		);
		
	chooseWriteRegister : mux2to1_5bit
		PORT MAP(
			s => buf_idex_EX(4),
			w0 => buf_idex_RegRt, 
			w1 => buf_idex_RegRd, 
			f => buf_idex_chosenDestinationAddress
		);
		
	chooseA_EX: mux4to1_8bit
		PORT MAP(
			sel => sigBUF_EX_forwardA,
			w0 => buf_idex_ReadDataA,
			w1 => buf_exmem_aluResult, -- exmem alu res
			w2 => buf_memwb_aluResult, -- memwb alu result
			w3 => "00000000",
			f => buf_EX_A
		);
		
	chooseB_EX: mux4to1_8bit
		PORT MAP(
			sel => sigBUF_EX_forwardB,
			w0 => buf_idex_ReadDataB,
			w1 => buf_exmem_aluResult, -- exmem alu res
			w2 => buf_memwb_aluResult, -- memwb alu result
			w3 => "00000000",
			f => buf_EX_B
		);
		
	a_alu_b : alu8bit
		PORT MAP(
			rA => buf_EX_A,
			rB => buf_EX_B,
			aluOP => buf_idex_EX(2 downto 0),
			alurOUT => buf_EX_ALUresult,
			zeroes => zeroFlag
		);
		
	bufExMem : pbuf_EX_MEM
		PORT MAP(
			idex_WB => buf_idex_WB,
			idex_Mem => buf_idex_Mem,
			aluResult_IN => buf_EX_ALUresult,
			wR_IN => buf_idex_chosenDestinationAddress,
			dataMemory => buf_idex_ReadDataB,
			iReset => gReset,
			iClock => gClock,
			exmem_WB => buf_exmem_WB,
			exmem_Mem => buf_exmem_Mem,
			wR_OUT => buf_exmem_wR,
			dataMemoryOUT => buf_exmem_DataMemory,
			aluResult_OUT => buf_exmem_aluResult
		);
		
	dM : dataMem
		PORT MAP(
			clk => clk_2,
			clk2 => clk_8,
			writeData => buf_exmem_DataMemory,
			address => buf_exmem_aluResult,
			mWrite => buf_exmem_Mem(0), -- memwrite
			valu => buf_MEM_dataSelect
		);
		
	bufMemWb : pbuf_MEM_WB
		PORT MAP(
			exmem_WB => buf_exmem_WB,
			aluResult_IN => buf_exmem_aluResult,
			dataMem_IN => buf_MEM_dataSelect,
			wR_IN => buf_exmem_wR,
			iClock => gClock,
			iReset => gReset,
			memwb_WB => buf_memwb_WB,
			aluResult_OUT => buf_memwb_aluResult,
			dataMem_OUT => buf_memwb_dataSelect,
			wr_OUT => buf_memwb_wr
		);
		
	chooseEndValu : mux2to18bit
		PORT MAP(
			s => buf_memwb_WB(0),
			w0 => buf_memwb_aluResult,
			w1 => buf_memwb_dataSelect,
			f => bufWriteData
		);
		
		
	bufOTHERS <= sig_ifid_Stall & sig_if_Skip & sigBUF_EX_forwardA & sigBUF_EX_forwardB & sig_ifid_MemRead & sig_ifid_Mem2Reg  ;
	
	chooseResult : mux6to1_8bit
		PORT MAP(
			sel => valueSelect,
			w0 => buf_if_currentPC,
			w1 => buf_EX_ALUresult,
			w2 => readA,
			w3 => readB,
			w4 => bufWriteData,
			w5 => bufOTHERS,
			f => muxOUT
		);	
		
	instruction_OUT <= cInstruction;
	branchOUT <= sig_ifid_Branch;
	memWriteOUT <= sig_ifid_MemWrite;
	RegWriteOUT <= sig_ifid_RegWrite;
	brAddress <= buf_ifid_BranchAddress;
	jAddress <= buf_ifid_JumpADDRESS;
		
end rtl;