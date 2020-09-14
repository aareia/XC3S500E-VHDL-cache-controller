
-- VHDL Instantiation Created from source file Cache_SRAM.vhd -- 12:59:51 10/01/2019
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT Cache_SRAM
	PORT(
		clk : IN std_logic;
		ADD : IN std_logic_vector(7 downto 0);
		WEN : IN std_logic;
		DIN : IN std_logic_vector(7 downto 0);          
		DOUT : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;

	Inst_Cache_SRAM: Cache_SRAM PORT MAP(
		clk => ,
		ADD => ,
		WEN => ,
		DIN => ,
		DOUT => 
	);


