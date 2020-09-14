
-- VHDL Instantiation Created from source file Cache_Cont.vhd -- 13:16:39 10/01/2019
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT Cache_Cont
	PORT(
		clk : IN std_logic;
		ADDin : IN std_logic_vector(15 downto 0);
		WRRDin : IN std_logic;
		CS : IN std_logic;
		DinEn : IN std_logic;
		DoutEn : IN std_logic;          
		ADDout : OUT std_logic_vector(15 downto 0);
		WRRDout : OUT std_logic;
		MSTRB : OUT std_logic;
		WEN : OUT std_logic;
		Rdy : OUT std_logic;
		ADDC : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;

	Inst_Cache_Cont: Cache_Cont PORT MAP(
		clk => ,
		ADDin => ,
		ADDout => ,
		WRRDin => ,
		WRRDout => ,
		CS => ,
		MSTRB => ,
		WEN => ,
		DinEn => ,
		DoutEn => ,
		Rdy => ,
		ADDC => 
	);


