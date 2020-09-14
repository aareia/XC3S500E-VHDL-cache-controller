----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 16:00:53 09/22/2012
-- Design Name:
-- Module Name: topLevelTest - Behavioral
-- Project Name:
-- Target Devices:
-- Tool versions:
-- Description:
--
-- Dependencies:
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
----------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;
-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
ENTITY topLevelTest IS
	PORT (
		clk : IN STD_LOGIC
	);
END topLevelTest;
ARCHITECTURE Behavioral OF topLevelTest IS
	-- Component under test.
	COMPONENT CPU_gen
	PORT(
		clk : IN std_logic;
		rst : IN std_logic;
		trig : IN std_logic;          
		Address : OUT std_logic_vector(15 downto 0);
		wr_rd : OUT std_logic;
		cs : OUT std_logic;
		DOut : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;
	
	COMPONENT Cache_Cont
	PORT(
		clk : IN std_logic;
		ADDin : IN std_logic_vector(15 downto 0);
		WRRDin : IN std_logic;
		CS : IN std_logic;
		DinEn : OUT std_logic;
		DoutEn : OUT std_logic;          
		ADDout : OUT std_logic_vector(15 downto 0);
		WRRDout : OUT std_logic;
		MSTRB : OUT std_logic;
		WEN : OUT std_logic;
		Rdy : OUT std_logic;
		ADDC : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;
	
	COMPONENT Cache_SRAM
	PORT(
		clk : IN std_logic;
		ADD : IN std_logic_vector(7 downto 0);
		WEN : IN std_logic;
		DIN : IN std_logic_vector(7 downto 0);          
		DOUT : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;

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
	
	COMPONENT mux2to1
	PORT(
		Port0 : IN std_logic_vector(7 downto 0);
		Port1 : IN std_logic_vector(7 downto 0);
		cntrl : IN std_logic;          
		Dout : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;
	
	COMPONENT mux1to2
	PORT(
		Din : IN std_logic_vector(7 downto 0);
		cntrl : IN std_logic;          
		Out0 : OUT std_logic_vector(7 downto 0);
		Out1 : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;

	-- ICON.
	COMPONENT icon
		PORT (
			CONTROL0 : INOUT STD_LOGIC_VECTOR(35 DOWNTO 0);
			CONTROL1 : INOUT STD_LOGIC_VECTOR(35 DOWNTO 0)
		);
	END COMPONENT;
	SIGNAL control0, control1 : std_logic_vector(35 DOWNTO 0);
	-- ILA.
	COMPONENT ila
		PORT (
			CONTROL : INOUT STD_LOGIC_VECTOR(35 DOWNTO 0);
			CLK : IN STD_LOGIC;
			DATA : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			TRIG0 : IN STD_LOGIC_VECTOR(7 DOWNTO 0)
		);
	END COMPONENT;
	SIGNAL ilaData : std_logic_vector(15 DOWNTO 0);
	SIGNAL ilaTrig : std_logic_vector(7 DOWNTO 0);
	signal vioOut : std_logic_vector(1 downto 0);
	-- VIO
	COMPONENT vio
		PORT (
			CONTROL : INOUT STD_LOGIC_VECTOR(35 DOWNTO 0);
			ASYNC_OUT : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
		);
	END COMPONENT;
	
	SIGNAL Add_CPU_CC : std_logic_vector(15 DOWNTO 0);
	SIGNAL Add_CC_SC : std_logic_vector(15 DOWNTO 0);
	SIGNAL Add_CC_CS : std_logic_vector(7 DOWNTO 0);
	SIGNAL Din_CS : std_logic_vector(7 DOWNTO 0);
	SIGNAL Din_SC : std_logic_vector(7 DOWNTO 0);
	SIGNAL Din_CPU : std_logic_vector(7 DOWNTO 0);
	SIGNAL Dout_CS : std_logic_vector(7 DOWNTO 0);
	SIGNAL Dout_SC : std_logic_vector(7 DOWNTO 0);
	SIGNAL Dout_CPU : std_logic_vector(7 DOWNTO 0);
	SIGNAL WrRd_CPU_CC :std_logic;
	SIGNAL WrRd_CC_SC :std_logic;
	SIGNAL Rdy_CC_CPU :std_logic;
	SIGNAL CS_CPU_CC :std_logic;
	SIGNAL Mux1En :std_logic;
	SIGNAL Mux2En :std_logic;
	SIGNAL Wen_CC_CS :std_logic;
	SIGNAL MSTRB_CC_SC :std_logic;
	
	Signal temp :std_logic;

	
	--- Entities
BEGIN
	-- Component under test.
	
	Inst_CPU_gen: CPU_gen 
	PORT MAP(
		clk => clk,
		rst => temp,
		trig => temp,
		Address => Add_CPU_CC,
		wr_rd => WrRd_CPU_CC,
		cs => CS_CPU_CC,
		DOut => Dout_CPU
	);

	SC: SDRAM_Cont 
	PORT MAP(
		clk => clk,
		ADD => Add_CC_SC,
		WRRD => WrRd_CC_SC,
		MSTRB => MSTRB_CC_SC,
		Din => Din_SC,
		Dout => Dout_SC
	);
	
	CS: Cache_SRAM 
	PORT MAP(
		clk => clk,
		ADD => Add_CC_CS,
		WEN => Wen_CC_CS,
		DIN => Din_CS,
		DOUT => Dout_CS
	);
	
	CC: Cache_Cont 
	PORT MAP(
		clk => clk,
		ADDin => Add_CPU_CC,
		ADDout => Add_CC_SC,
		WRRDin => WrRd_CPU_CC,
		WRRDout => WrRd_CC_SC,
		CS => CS_CPU_CC,
		MSTRB => MSTRB_CC_SC,
		WEN => Wen_CC_CS,
		DinEn => Mux1En,
		DoutEn => Mux2En,
		Rdy => Rdy_CC_CPU,
		ADDC => Add_CC_CS 
	);

	mux1: mux2to1 
	PORT MAP(
		Port0 => Dout_CPU,
		Port1 => Dout_SC,
		cntrl => Mux1En,
		Dout => Din_CS
	);
	
	mux2: mux1to2 
	PORT MAP(
		Din => Dout_CS,
		Out0 => Din_SC,
		Out1 => Din_CPU,
		cntrl => Mux2En
	);
	
	-- Test circuits.
	-- ICON.
	systemIcon : icon
	PORT MAP(
		CONTROL0 => control0,
		CONTROL1 => control1
	);
	-- ILA.
	systemIla : ila
	PORT MAP(
		CONTROL => control0,
		CLK => clk,
		DATA => ilaData,
		TRIG0 => ilaTrig
	);
	-- VIO.
	systemVio : vio
	PORT MAP(
		CONTROL => control1,
		ASYNC_OUT => vioOut
	);
	-- Debug signal assignments.
	-- Normal inputs and outputs.
	
	-- Debug outputs.
	
	-- Trigger assignment.
	
END Behavioral;