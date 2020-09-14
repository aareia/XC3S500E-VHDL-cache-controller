----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:45:46 10/01/2019 
-- Design Name: 
-- Module Name:    mux2to1 - Behavioral 
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

entity mux2to1 is
    Port ( Port0 : in  STD_LOGIC_VECTOR (7 downto 0);
           Port1 : in  STD_LOGIC_VECTOR (7 downto 0);
           cntrl : in  STD_LOGIC;
           Dout : out  STD_LOGIC_VECTOR (7 downto 0));
end mux2to1;

architecture Behavioral of mux2to1 is

begin


end Behavioral;

