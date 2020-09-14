----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 15:39:41 09/22/2012
-- Design Name:
-- Module Name: resetBlock - Behavioral
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
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;
-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
ENTITY resetBlock IS
	PORT (
		clk : IN STD_LOGIC;
		rst : IN STD_LOGIC;
		rstAux1 : OUT STD_LOGIC;
		rstAux2 : OUT STD_LOGIC;
		rstAux3 : OUT STD_LOGIC;
		-- Debug
		debSt : OUT std_logic_vector(2 DOWNTO 0);
		debC : OUT std_logic_vector(4 DOWNTO 0);
		debM16 : OUT std_logic;
		debM24 : OUT std_logic;
		debM30 : OUT std_logic
	);
END resetBlock;

ARCHITECTURE Behavioral OF resetBlock IS
	-- Up counter.
	SIGNAL countVal : std_logic_vector(4 DOWNTO 0) := "00000";
	SIGNAL rstC, incC : std_logic;
	-- Comparators.
	SIGNAL match16, match24, match30 : std_logic;
	-- FSM control unit.
	SIGNAL st1 : std_logic_vector(2 DOWNTO 0) := "000";
	SIGNAL st1N : std_logic_vector(2 DOWNTO 0);
BEGIN
	-- System up-counter, used to keep track of time.
	upCounter : PROCESS (clk, rstC, incC)
	BEGIN
		IF (rstC = '1') THEN
			countVal <= "00000";
		ELSE
			IF (clk'event AND clk = '1' AND incC = '1') THEN
				countVal <= countVal + "00001";
			END IF;
		END IF;
	END PROCESS;
	debC <= countVal;
	-- Comparators, used to flag specific counter values.
	comparator16 : PROCESS (countVal)
	BEGIN
		IF (countVal = "10000") THEN
			match16 <= '1';
		ELSE
			match16 <= '0';
		END IF;
	END PROCESS;
	debM16 <= match16;
	comparator24 : PROCESS (countVal)
	BEGIN
		IF (countVal = "11000") THEN
			match24 <= '1';
		ELSE
			match24 <= '0';
		END IF;
	END PROCESS;
	debM24 <= match24;
	comparator30 : PROCESS (countVal)
	BEGIN
		IF (countVal = "11110") THEN
			match30 <= '1';
		ELSE
			match30 <= '0';
		END IF;
	END PROCESS;
	debM30 <= match30;
	-- FSM control unit, with 6 states.
	-- State storage.
	stateStorage : PROCESS (clk, st1N)
	BEGIN
		IF (clk'event AND clk = '1') THEN
			st1 <= st1N;
		END IF;
	END PROCESS;
	debSt <= st1;
	-- Next state generation.
	nextStateGen : PROCESS (st1, rst, match16, match24, match30)
	BEGIN
		IF (st1 = "000") THEN -- S0: Rest state.
			IF (rst = '1') THEN
				st1N <= "001";
			ELSE
				st1N <= "000";
			END IF;
		ELSIF (st1 = "001") THEN -- S1: generate all three reset signals.
			IF (match16 = '1') THEN
				st1N <= "010";
			ELSE
				st1N <= "001";
			END IF;
		ELSIF (st1 = "010") THEN -- S2: generate only two reset signals.
			IF (match24 = '1') THEN
				st1N <= "011";
			ELSE
				st1N <= "010";
			END IF;
		ELSIF (st1 = "011") THEN -- S3: generate only one reset signal.
			IF (match30 = '1') THEN
				st1N <= "100";
			ELSE
				st1N <= "011";
			END IF;
		ELSIF (st1 = "100") THEN -- S4: de-assert all reset signals.
			st1N <= "101";
		ELSIF (st1 = "101") THEN -- S5: reset up-counter.
			st1N <= "000";
		ELSE
			st1N <= "000";
		END IF;
	END PROCESS;
	-- Output generation.
	outGen : PROCESS (st1)
	BEGIN
		IF (st1 = "000") THEN -- S0: Rest state.
			incC <= '0';
			rstC <= '0';
			rstAux1 <= '0';
			rstAux2 <= '0';
			rstAux3 <= '0';
		ELSIF (st1 = "001") THEN -- S1: generate all three reset signals.
			incC <= '1';
			rstC <= '0';
			rstAux1 <= '1';
			rstAux2 <= '1';
			rstAux3 <= '1';
		ELSIF (st1 = "010") THEN -- S2: generate only two reset signals.
			incC <= '1';
			rstC <= '0';
			rstAux1 <= '1';
			rstAux2 <= '1';
			rstAux3 <= '0';
		ELSIF (st1 = "011") THEN -- S3: generate only one reset signal.
			incC <= '1';
			rstC <= '0';
			rstAux1 <= '1';
			rstAux2 <= '0';
			rstAux3 <= '0';
		ELSIF (st1 = "100") THEN -- S4: de-assert all reset signals.
			incC <= '0';
			rstC <= '0';
			rstAux1 <= '0';
			rstAux2 <= '0';
			rstAux3 <= '0';
		ELSIF (st1 = "101") THEN -- S5: reset up-counter.
			incC <= '0';
			rstC <= '1';
			rstAux1 <= '0';
			rstAux2 <= '0';
			rstAux3 <= '0';
		ELSE
			incC <= '0';
			rstC <= '0';
			rstAux1 <= '0';
			rstAux2 <= '0';
			rstAux3 <= '0';
		END IF;
	END PROCESS;
END Behavioral;