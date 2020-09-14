----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:20:39 10/01/2019 
-- Design Name: 
-- Module Name:    mux1to2 - Behavioral 
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

entity mux1to2 is
    Port ( Din : in  STD_LOGIC_VECTOR (7 downto 0);
           Out0 : out  STD_LOGIC_VECTOR (7 downto 0);
           Out1 : out  STD_LOGIC_VECTOR (7 downto 0);
           cntrl : in  STD_LOGIC);
end mux1to2;

architecture Behavioral of mux1to2 is

begin


end Behavioral;

