----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:35:06 10/22/2019 
-- Design Name: 
-- Module Name:    CacheController - Behavioral 
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

-- Upper Level Cache Controller Entity 
entity CacheController is
	Port ( 
		clk       					: in STD_LOGIC;
		Cache_Addr_Comp      	: out STD_LOGIC_VECTOR(15 downto 0);
		Cache_Dout_Comp			: out STD_LOGIC_VECTOR(7 downto 0);
		SRAM_Addr_Comp    		: out STD_LOGIC_VECTOR(7 downto 0);
		SRAM_Din_Comp   			: out STD_LOGIC_VECTOR(7 downto 0);
		SRAM_Dout_Comp  			: out STD_LOGIC_VECTOR(7 downto 0);
		SDRAM_Addr_Comp   		: out STD_LOGIC_VECTOR(15 downto 0);
		SDRAM_Din_Comp  			: out STD_LOGIC_VECTOR(7 downto 0);
		SDRAM_Dout_Comp  			: out STD_LOGIC_VECTOR(7 downto 0);
		Cache_SRAMAddr_Comp     : out STD_LOGIC_VECTOR(7 downto 0);
		Cache_WR_RD_Comp        : out STD_LOGIC;
		Cache_memStrb_Comp      : out STD_LOGIC;
		Cache_RDY_Comp          : out STD_LOGIC;
		Cache_CS_Comp           : out STD_LOGIC		
	);
end CacheController;

architecture Behavioral of CacheController is
	--CPU Signals
	signal Cpu_Dout_Sig, Cpu_Din_Sig 	 : STD_LOGIC_VECTOR(7 downto 0);
	signal Cpu_Addr_Sig     	          : STD_LOGIC_VECTOR (15 downto 0);
	signal Cpu_WR_RD_Sig,Cpu_CS_Sig    	 : STD_LOGIC;
	signal Cpu_Rdy_Sig           	 		 : STD_LOGIC;
	signal Cpu_Tag_Sig 			 			 : STD_LOGIC_VECTOR(7 downto 0);
	signal Cpu_Index_Sig 				 	 : STD_LOGIC_VECTOR(2 downto 0);
	signal offset 				 			    : STD_LOGIC_VECTOR(4 downto 0);
	
	--SRAM(cache memory) Signals
	signal DirtyByte 				 : STD_LOGIC_VECTOR(7 downto 0):= "00000000";
	signal ValidByte 				 : STD_LOGIC_VECTOR(7 downto 0):= "00000000";
	signal sADD, sDin, sDout    : STD_LOGIC_VECTOR(7 downto 0);
	signal sWen 				    : STD_LOGIC_VECTOR(0 DOWNTO 0);
	signal HitMiss 				    : STD_LOGIC := '0';
	type cachemem is array (7 downto 0) of STD_LOGIC_VECTOR(7 downto 0);
	signal sTAG: cachemem := ((others=> (others=>'0')));
	
	--SDRAM Signals
	signal SDRAM_Din,SDRAM_Dout : STD_LOGIC_VECTOR(7 downto 0);
	signal SDRAM_ADD      		 : STD_LOGIC_VECTOR(15 downto 0);
	signal SDRAM_MSTRB,SDRAM_W_R: STD_LOGIC;
	
	--Counters
	signal counter 			    : integer := 0;
	signal delay_counter 			    : integer := 0;
	signal startup 			    : integer := 0;
	signal offset_counter             : integer := 0;
		

	--ICON & VIO & ILA Signals
	signal control0 				 : STD_LOGIC_VECTOR(35 downto 0);
	signal control1 				 : STD_LOGIC_VECTOR(35 downto 0);
	signal ila_data 				 : std_logic_vector(99 downto 0);
	signal trig0 				    : std_logic_vector(0 DOWNTO 0);

	--State
	signal state : STD_LOGIC_VECTOR(3 downto 0);

	--Components
	COMPONENT SDRAMController
	Port (
		clk     : in STD_LOGIC;
		ADDR 	  : in STD_LOGIC_VECTOR (15 downto 0);
		WR_RD   : in STD_LOGIC;
		MEMSTRB : in STD_LOGIC;
		DIN     : in STD_LOGIC_VECTOR (7 downto 0);
		DOUT    : out STD_LOGIC_VECTOR (7 downto 0)
	);
	END COMPONENT;
	
	COMPONENT SRAM
	PORT (
		clka    : IN STD_LOGIC;
		wea 	  : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
		addra   : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		dina 	  : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		douta   : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
	END COMPONENT;
	
	COMPONENT CPU_gen
	Port (
		clk     : in STD_LOGIC;
		rst     : in STD_LOGIC;
		trig    : in STD_LOGIC;
		Address : out STD_LOGIC_VECTOR (15 downto 0);
		wr_rd   : out STD_LOGIC;
		cs      : out STD_LOGIC;
		DOut    : out STD_LOGIC_VECTOR (7 downto 0)
	);
	END COMPONENT;
	
	COMPONENT icon
	PORT (
		CONTROL0 : INOUT STD_LOGIC_VECTOR(35 DOWNTO 0);
		CONTROL1 : INOUT STD_LOGIC_VECTOR(35 DOWNTO 0)
	);
	END COMPONENT;

	COMPONENT ila
	PORT (
		CONTROL  : INOUT STD_LOGIC_VECTOR(35 DOWNTO 0);
		CLK      : IN STD_LOGIC;
		DATA     : IN STD_LOGIC_VECTOR(99 DOWNTO 0);
		TRIG0    : IN STD_LOGIC_VECTOR(0 TO 0)
	);
	END COMPONENT;
	
	component vio
	PORT (
	CONTROL : INOUT STD_LOGIC_VECTOR(35 DOWNTO 0);
	ASYNC_OUT : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
	);
	
	end component;
	signal vioOut : std_logic_vector(1 downto 0);
	signal ilaTrig : std_logic_vector(7 downto 0);
	
	BEGIN
	
	--PORT MAPS:
	myCPU_gen : CPU_gen         
	Port Map (clk => clk,
				 rst => vioOut(0),
				 trig => Cpu_Rdy_Sig,
				 Address => Cpu_Addr_Sig,
				 wr_rd   => Cpu_WR_RD_Sig,
				 cs      => Cpu_CS_Sig,
				 DOut    => Cpu_Dout_Sig
	);
	
	
	SDRAM     : SDRAMController 
	Port Map (clk  => clk,
				 ADDR => SDRAM_ADD,
				 WR_RD=> SDRAM_W_R,
				 MEMSTRB=> SDRAM_MSTRB,
				 DIN=> SDRAM_Din,
				 DOUT=> SDRAM_Dout
	);
	
	mySRAM    : SRAM            
	Port Map (clka => clk,
				 wea => sWen,
				 addra => sADD, 
				 dina => sDin, 
				 douta=> sDout
	);
	
	myIcon    : icon            
	Port Map (CONTROL0 => control0,
				 CONTROL1 => control1
	);
	
	myILA     : ila             
	Port Map (CONTROL => control0,
				 CLK => clk,
 				 DATA => ila_data,
				 TRIG0 => trig0
	);
	
	
	myvio : vio
	port map (
		CONTROL => control1,
		ASYNC_OUT => vioOut
	);
	
	process(clk, Cpu_CS_Sig)
	begin
		if (clk'event AND clk = '1') then
			
			if (startup = 0) then
			state <= "0100";
			startup <= 1;
			end if;
				
				--evaluation 0000 0
				--Write      0001 1
				--Load  		 0010 2
				--CPU wr/rd  0011 3
				--READY      0100 4
				
			-- STATE 0
			if (state = "0000") then
				delay_counter <= 0;
				Cpu_Rdy_Sig <= '0';
				Cpu_Tag_Sig <= Cpu_Addr_Sig(15 downto 8);
				Cpu_Index_Sig <= Cpu_Addr_Sig(7 downto 5);
				offset <= Cpu_Addr_Sig(4 downto 0);
				SDRAM_ADD(15 downto 5) <= Cpu_Addr_Sig(15 downto 5);
				sADD(7 downto 0) <= Cpu_Addr_Sig(7 downto 0);
				sWen <= "0";

				--Evaluating HIT/MISS
				if(ValidByte(to_integer(unsigned(Cpu_Index_Sig))) = '1' AND sTAG(to_integer(unsigned(Cpu_Index_Sig))) = Cpu_Tag_Sig) then -- HIT
					HitMiss <= '1';
					state <= "0011";
				else --MISS
					HitMiss <= '0';
					
					--Dirty and Valid bit check
					if (DirtyByte(to_integer(unsigned(Cpu_Index_Sig))) = '1' AND ValidByte(to_integer(unsigned(Cpu_Index_Sig))) = '1') then
						state <= "0001"; --Switching to write state
					else 
						state <= "0010"; --Switch to load state
					end if;
				end if;
			
			-- STATE 1 MISS, write-back to SDRAM
			elsif(state = "0001") then
				SDRAM_ADD(15 downto 8) <= Cpu_Tag_Sig;
				SDRAM_ADD(7 downto 5) <= Cpu_Index_Sig;
				--sDin <= (others=>'0');
				if (counter = 64) then
					counter <= 0;
					DirtyByte(to_integer(unsigned(Cpu_Index_Sig))) <= '0';
					sTAG(to_integer(unsigned(Cpu_Index_Sig))) <= (others=>'0');
					offset_counter <= 0;
					state <= "0010"; -- switch to load state, write complete
				else
					if (counter mod 2 = 1) then
						SDRAM_MSTRB <= '0';
					else
						SDRAM_MSTRB <= '1';
						SDRAM_ADD(4 downto 0) <= STD_LOGIC_VECTOR(to_unsigned(offset_counter, 5));
						SDRAM_W_R <= '1';
						SDRAM_Din <= sDout;
						
						sADD(7 downto 5) <= Cpu_Index_Sig;
						sADD(4 downto 0) <= STD_LOGIC_VECTOR(to_unsigned(offset_counter, 5));
						sWen <= "0";
						
						offset_counter <= offset_counter + 1;
					end if;
				counter <= counter + 1;
				end if;
				
			-- STATE 2 MISS read
			elsif(state = "0010") then
				SDRAM_ADD(15 downto 8) <= Cpu_Tag_Sig;
				SDRAM_ADD(7 downto 5) <= Cpu_Index_Sig;
				--sDout <= (others=>'0');
				if (counter = 64) then
					counter <= 0;
					ValidByte(to_integer(unsigned(Cpu_Index_Sig))) <= '1';
					sTAG(to_integer(unsigned(Cpu_Index_Sig))) <= Cpu_Tag_Sig;
					offset_counter <= 0;
					state <= "0011"; -- switch to cpu rd/wr
				else
					if (counter mod 2 = 1) then
						SDRAM_MSTRB <= '0';
					else
					   SDRAM_MSTRB <= '1';
						SDRAM_ADD(4 downto 0) <= STD_LOGIC_VECTOR(to_unsigned(offset_counter, 5));
						SDRAM_W_R <= '0';
						
						sADD(7 downto 5) <= Cpu_Index_Sig;
						sADD(4 downto 0) <= STD_LOGIC_VECTOR(to_unsigned(offset_counter, 5));
						sDin <= SDRAM_Dout;
						sWen <= "1";
						
						offset_counter <= offset_counter + 1;
					end if;
				counter <= counter + 1;
				end if;
				
			-- STATE 3 CPU read/write	
			elsif(state = "0011") then
				if (Cpu_WR_RD_Sig = '1') then
					sWen <= "1";
						DirtyByte(to_integer(unsigned(Cpu_Index_Sig))) <= '1';
						ValidByte(to_integer(unsigned(Cpu_Index_Sig))) <= '1';
						sDin <= Cpu_Dout_Sig;
						Cpu_Din_Sig <= "00000000";
				else
					Cpu_Din_Sig <= sDout;
				end if;	
			state <= "0100";
					
			-- STATE 4	send ready, wait for CS
			elsif(state = "0100") then
				Cpu_Rdy_Sig <= '1';
				if ((Cpu_CS_Sig = '1') AND (delay_counter >= 2)) then
					state <= "0000";
				end if;
				delay_counter <= delay_counter + 1;
			end if;
		end if;
	end process;
	
	-- Signals
	Cache_memStrb_Comp <= SDRAM_MSTRB;
	Cache_Addr_Comp    <= Cpu_Addr_Sig;
	Cache_WR_RD_Comp   <= Cpu_WR_RD_Sig;
	Cache_Dout_Comp    <= Cpu_Din_Sig;
	Cache_RDY_Comp     <= Cpu_Rdy_Sig;
	Cache_CS_Comp      <= Cpu_CS_Sig;
	SRAM_Addr_Comp     <= sADD;
	SRAM_Din_Comp      <= sDin;
	SRAM_Dout_Comp  	 <= sDout;
	SDRAM_Addr_Comp    <= SDRAM_ADD;
	SDRAM_Din_Comp  	 <= SDRAM_Din;
	SDRAM_Dout_Comp 	 <= SDRAM_Dout;
	Cache_SRAMAddr_Comp<= Cpu_Addr_Sig(15 downto 8);
	
   -- ILA outputs
	ila_data(15 downto 0)  <= Cpu_Addr_Sig;
	ila_data(16)           <= Cpu_WR_RD_Sig;
	ila_data(17)           <= Cpu_Rdy_Sig;
	ila_data(18)           <= Cpu_CS_Sig;
	ila_data(26 downto 19) <= Cpu_Din_Sig;
	ila_data(30 downto 27) <= state;
	ila_data(31)           <= SDRAM_MSTRB;
	ila_data(32)           <= ValidByte(to_integer(unsigned(Cpu_Index_Sig)));
	ila_data(33)           <= DirtyByte(to_integer(unsigned(Cpu_Index_Sig)));
	ila_data(34)           <= HitMiss;
	ila_data(42 downto 35) <= sADD;
	ila_data(50 downto 43) <= sDin;
	ila_data(58 downto 51) <= sDout;
	ila_data(74 downto 59) <= SDRAM_ADD;
	ila_data(82 downto 75) <= SDRAM_Din;
	ila_data(90 downto 83) <= SDRAM_Dout;
	ila_data(98 downto 91) <= Cpu_Dout_Sig;
	ila_data(99)           <= vioOut(0);
	
	-- Trigger
	ilaTrig(0) <= vioOut(0);
	ilaTrig(7 downto 1) <= (others => '0');
end Behavioral;
