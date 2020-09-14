
-- VHDL Instantiation Created from source file SDRAMController.vhd -- 16:34:31 10/24/2019
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT SDRAMController
	PORT(
		clk : IN std_logic;
		ADDR : IN std_logic_vector(15 downto 0);
		WR_RD : IN std_logic;
		MEMSTRB : IN std_logic;
		DIN : IN std_logic_vector(7 downto 0);          
		DOUT : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;

	Inst_SDRAMController: SDRAMController PORT MAP(
		clk => ,
		ADDR => ,
		WR_RD => ,
		MEMSTRB => ,
		DIN => ,
		DOUT => 
	);


