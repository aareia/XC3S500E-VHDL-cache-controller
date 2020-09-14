----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:37:55 10/22/2019 
-- Design Name: 
-- Module Name:    SDRAMController - Behavioral 
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
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity SDRAMController is
	Port (
		clk : in STD_LOGIC;
		ADDR : in STD_LOGIC_VECTOR (15 downto 0);
		WR_RD : in STD_LOGIC;
		MEMSTRB : in STD_LOGIC;
		DIN : in STD_LOGIC_VECTOR (7 downto 0);
		DOUT : out STD_LOGIC_VECTOR (7 downto 0)
	);
end SDRAMController;

architecture Behavioral of SDRAMController is
	--type mem is array (7 downto 0, 31 downto 0) of std_logic_vector(7 downto 0);
	type mem is array (6 downto 1, 31 downto 0) of std_logic_vector(7 downto 0);
	signal first4  : STD_LOGIC_VECTOR(3 downto 0);
	signal last4	: STD_LOGIC_VECTOR(4 downto 0);
	signal mem_sig: mem;
	signal counter : integer := 0;
	begin
		process (CLK)
		begin
		if CLK'event and CLK = '1' then
			if counter = 0 then
				for I in 1 to 6 loop
					for J in 0 to 31 loop
						--mem_sig(I,J) <= "11010100";
						last4 <= std_logic_vector(to_unsigned(J,5));
						first4 <= std_logic_vector(to_unsigned(I,4));
						mem_sig(I,J) <= last4(4) & first4(2 downto 0) & last4(3 downto 0); 
					end loop;
				end loop;
				counter <= 1;
			end if;
			if MEMSTRB = '1' then
				if WR_RD = '1' then
					--mem_sig(to_integer(unsigned(ADDR(7 downto 5))),to_integer(unsigned(ADDR(4 downto 0)))) <= DIN;
					mem_sig(to_integer(unsigned(ADDR(15 downto 12))),to_integer(unsigned(ADDR(4 downto 0)))) <= DIN;
				ELSE
					--DOUT <= mem_sig(to_integer(unsigned(ADDR(7 downto 5))),to_integer(unsigned(ADDR(4 downto 0))));
					DOUT <= mem_sig(to_integer(unsigned(ADDR(15 downto 12))),to_integer(unsigned(ADDR(4 downto 0))));
				end if;
			end if;
		end if;
		end process;
end Behavioral;