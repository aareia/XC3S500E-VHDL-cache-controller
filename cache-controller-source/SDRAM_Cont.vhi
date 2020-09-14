
-- VHDL Instantiation Created from source file SDRAM_Cont.vhd -- 12:58:04 10/01/2019
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT SDRAM_Cont
	PORT(
		clk : IN std_logic;
		ADD : IN std_logic_vector(15 downto 0);
		WRRD : IN std_logic;
		MSTRB : IN std_logic;
		Din : IN std_logic_vector(7 downto 0);          
		Dout : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;

	Inst_SDRAM_Cont: SDRAM_Cont PORT MAP(
		clk => ,
		ADD => ,
		WRRD => ,
		MSTRB => ,
		Din => ,
		Dout => 
	);


