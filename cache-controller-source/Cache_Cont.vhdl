----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:41:56 10/01/2019 
-- Design Name: 
-- Module Name:    Cache_Cont - Behavioral 
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

entity Cache_Cont is
    Port ( clk : in  STD_LOGIC;
			  ADDin : in  STD_LOGIC_VECTOR (15 downto 0);
			  ADDout : out  STD_LOGIC_VECTOR (15 downto 0);
           WRRDin : in  STD_LOGIC;
			  WRRDout : out  STD_LOGIC;
           CS : in  STD_LOGIC;
           MSTRB : out  STD_LOGIC;
           WEN : out  STD_LOGIC;
           DinEn : out  STD_LOGIC;
           DoutEn : out  STD_LOGIC;
			  Rdy : out  STD_LOGIC;
           ADDC : out  STD_LOGIC_VECTOR (7 downto 0));
end Cache_Cont;

architecture Behavioral of Cache_Cont is

begin


end Behavioral;

