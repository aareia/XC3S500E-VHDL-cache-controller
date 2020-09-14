
-- VHDL Instantiation Created from source file mux2to1.vhd -- 13:01:17 10/01/2019
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT mux2to1
	PORT(
		Port0 : IN std_logic_vector(7 downto 0);
		Port1 : IN std_logic_vector(7 downto 0);
		cntrl : IN std_logic;          
		Dout : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;

	Inst_mux2to1: mux2to1 PORT MAP(
		Port0 => ,
		Port1 => ,
		cntrl => ,
		Dout => 
	);


