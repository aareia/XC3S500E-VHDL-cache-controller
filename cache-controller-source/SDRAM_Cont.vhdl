----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:43:03 10/01/2019 
-- Design Name: 
-- Module Name:    SDRAM_Cont - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SDRAM_Cont is
    Port ( clk : in  STD_LOGIC;
			  ADD : in  STD_LOGIC_VECTOR (15 downto 0);
           WRRD : in  STD_LOGIC;
           MSTRB : in  STD_LOGIC;
           Din : in  STD_LOGIC_VECTOR (7 downto 0);
           Dout : out  STD_LOGIC_VECTOR (7 downto 0));
end SDRAM_Cont;

architecture Behavioral of SDRAM_Cont is

begin


end Behavioral;

