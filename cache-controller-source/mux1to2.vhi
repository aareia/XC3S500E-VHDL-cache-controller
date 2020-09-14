
-- VHDL Instantiation Created from source file mux1to2.vhd -- 13:21:11 10/01/2019
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT mux1to2
	PORT(
		Din : IN std_logic_vector(7 downto 0);
		cntrl : IN std_logic;          
		Out0 : OUT std_logic_vector(7 downto 0);
		Out1 : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;

	Inst_mux1to2: mux1to2 PORT MAP(
		Din => ,
		Out0 => ,
		Out1 => ,
		cntrl => 
	);


