----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:13:42 01/20/2015 
-- Design Name: 
-- Module Name:    afficheur - Behavioral 
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
use IEEE.numeric_std.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Power_On_Init is
	port(
		clk   : in    std_logic;
		enable: in    std_logic;
		done  : out   std_logic;
		lcd   : inout std_logic_vector(LCD_LEN - 1 downto 0)
		--led   : out   std_logic_vector(7 downto 0);
		--lcdd  : inout std_logic_vector(7 downto 0);
		--lcden : out   std_logic;
		--lcdrs : out   std_logic;
		--lcdrw : out   std_logic
		);
end Power_On_Init;


architecture Power_On_Init of Power_On_Init is
   type STATE_TYPE is (
			INIT_STATE,
			FUNCTION_SET_STATE,
			DISP_ON_STATE,
			DISP_CLR_STATE,
			PRINT_CHAR_STATE,
			DONE_STATE);
   signal current_state   : STATE_TYPE := INIT_STATE;

	constant INS_FUNCTION_SET : std_logic_vector(7 downto 0) := "00111000";
	constant INS_DISP_ON		  : std_logic_vector(7 downto 0) := "00001111";
	constant INS_DISP_CLR	  : std_logic_vector(7 downto 0) := "00000001";
begin
	
	process(clk)
		variable timer_counter : integer range 0 to 100000000 := 0; --Compteur d'horloge pour minuter les états 100Mhz (10 ns)
		variable enable_counter : integer range 0 to 100 := 0; --Compteur d'horloge pour minuter l'activation du signal enable
		variable ins_loop_counter : integer range 0 to 10 := 0; --Compteur d'iteration pour repeter une instruction
	begin
		
		if rising_edge(clk) then
		
			case current_state is
			
				when INIT_STATE =>
					led <= x"1";
					lcden <= '0';
					lcdrs <= '0';
					lcdrw <= '0';
					
					timer_counter := timer_counter + 1;
					
					--Delais 40ms
					if timer_counter > 4000000 then
						current_state <= FUNCTION_SET;
						timer_counter := 0;
					end if;
					
					
					
				when FUNCTION_SET =>
					led <= "01000000";
					
					lcdd <= INS_FUNCTION_SET;
					lcdrs <= '0';
					lcdrw <= '0';
					timer_counter := timer_counter + 1;
					
					--Delai d'activation enable 80 ns
					if enable_counter > 8 then
						lcden <= '0';
					else
						lcden <= '1';
						enable_counter := enable_counter + 1;
					end if;
					
					--Délais 37 us
					if timer_counter > 3700 then
						enable_counter := 0;
						timer_counter := 0;
						
						if ins_loop_counter < 3 then
							ins_loop_counter := ins_loop_counter + 1;
							current_state <= FUNCTION_SET;
						else
							current_state <= DISP_ON;
							ins_loop_counter := 0;
						end if;
					end if;
			
				when DISP_ON =>
					led <= "00100000";
					
					lcdd <= INS_DISP_ON;
					lcdrs <= '0';
					lcdrw <= '0';
					timer_counter := timer_counter + 1;
					
					--Delai d'activation enable 80 ns
					if enable_counter > 8 then
						lcden <= '0';
					else
						lcden <= '1';
						enable_counter := enable_counter + 1;
					end if;
					
					--Délais 37 us
					if timer_counter > 3700 then
						enable_counter := 0;
						timer_counter := 0;
						current_state <= DISP_CLR;
						
					end if;
					
				when DISP_CLR =>
					led <= "00010000";
					
					lcdd <= INS_DISP_CLR;
					lcdrs <= '0';
					lcdrw <= '0';
					timer_counter := timer_counter + 1;
					
					--Delai d'activation enable 80 ns
					if enable_counter > 8 then
						lcden <= '0';
					else
						lcden <= '1';
						enable_counter := enable_counter + 1;
					end if;
					
					--Délais 1.52ms
					if timer_counter > 152000 then
						enable_counter := 0;
						timer_counter := 0;
						current_state <= PRINT_CHAR;
						
					end if;

				when PRINT_CHAR =>
					led <= "00001000";
					
					lcdd <= "01000001";
					lcdrs <= '1';
					lcdrw <= '0';
					timer_counter := timer_counter + 1;
					
					--Delai d'activation enable 80 ns
					if enable_counter > 8 then
						lcden <= '0';
					else
						lcden <= '1';
						enable_counter := enable_counter + 1;
					end if;
					
					--Délais 37us
					if timer_counter >3700 then
						enable_counter := 0;
						timer_counter := 0;
						current_state <= DONE;
						
					end if;
				
				when DONE =>
					
				
				when others =>
					led <= "11110000";
			
			end case;
		end if;
	end process;

	--lcdd <= "00000000";
	--lcden <= '0';
	--lcdrs <= '0';
	--lcdrw <= '0';
	--led <= "01010101";
end Power_On_Init;

