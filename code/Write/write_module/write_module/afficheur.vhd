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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity afficheur is
	port( Led : out STD_LOGIC_VECTOR(7 downto 0);
			LCDD : inout STD_LOGIC_VECTOR(7 downto 0);
			LCDEN : out STD_LOGIC;
			LCDRS : out STD_LOGIC;
			LCDRW : out STD_LOGIC;
			clk :	in	STD_LOGIC
			);

end afficheur;


architecture Behavioral of afficheur is
   TYPE STATE_TYPE IS (INIT, FUNCTION_SET, DISP_ON, DISP_CLR, PRINT_CHAR, DONE);
   SIGNAL current_state   : STATE_TYPE := INIT;

	constant INS_FUNCTION_SET : Std_Logic_Vector(7 downto 0) := "00111000";
	constant INS_DISP_ON		  : Std_Logic_Vector(7 downto 0) := "00001111";
	constant INS_DISP_CLR	  : Std_Logic_Vector(7 downto 0) := "00000001";
begin
	
	process(clk)
		variable timer_counter : integer range 0 to 100000000 := 0; --Compteur d'horloge pour minuter les états 100Mhz (10 ns)
		variable enable_counter : integer range 0 to 100 := 0; --Compteur d'horloge pour minuter l'activation du signal enable
		variable ins_loop_counter : integer range 0 to 10 := 0; --Compteur d'iteration pour repeter une instruction
	begin
		
		if rising_edge(clk) then
		
			case current_state is
			
				when INIT =>
					Led <= "10000000";
					LCDEN <= '0';
					LCDRS <= '0';
					LCDRW <= '0';
					
					timer_counter := timer_counter + 1;
					
					--Delais 40ms
					if timer_counter > 4000000 then
						current_state <= FUNCTION_SET;
						timer_counter := 0;
					end if;
					
					
					
				when FUNCTION_SET =>
					Led <= "01000000";
					
					LCDD <= INS_FUNCTION_SET;
					LCDRS <= '0';
					LCDRW <= '0';
					timer_counter := timer_counter + 1;
					
					--Delai d'activation enable 80 ns
					if enable_counter > 8 then
						LCDEN <= '0';
					else
						LCDEN <= '1';
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
					Led <= "00100000";
					
					LCDD <= INS_DISP_ON;
					LCDRS <= '0';
					LCDRW <= '0';
					timer_counter := timer_counter + 1;
					
					--Delai d'activation enable 80 ns
					if enable_counter > 8 then
						LCDEN <= '0';
					else
						LCDEN <= '1';
						enable_counter := enable_counter + 1;
					end if;
					
					--Délais 37 us
					if timer_counter > 3700 then
						enable_counter := 0;
						timer_counter := 0;
						current_state <= DISP_CLR;
						
					end if;
					
				when DISP_CLR =>
					Led <= "00010000";
					
					LCDD <= INS_DISP_CLR;
					LCDRS <= '0';
					LCDRW <= '0';
					timer_counter := timer_counter + 1;
					
					--Delai d'activation enable 80 ns
					if enable_counter > 8 then
						LCDEN <= '0';
					else
						LCDEN <= '1';
						enable_counter := enable_counter + 1;
					end if;
					
					--Délais 1.52ms
					if timer_counter > 152000 then
						enable_counter := 0;
						timer_counter := 0;
						current_state <= PRINT_CHAR;
						
					end if;

				when PRINT_CHAR =>
					Led <= "00001000";
					
					LCDD <= "01000001";
					LCDRS <= '1';
					LCDRW <= '0';
					timer_counter := timer_counter + 1;
					
					--Delai d'activation enable 80 ns
					if enable_counter > 8 then
						LCDEN <= '0';
					else
						LCDEN <= '1';
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
					Led <= "11110000";
			
			end case;
		end if;
	end process;

	--LCDD <= "00000000";
	--LCDEN <= '0';
	--LCDRS <= '0';
	--LCDRW <= '0';
	--Led <= "01010101";
	
	
end Behavioral;

