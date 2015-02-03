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

use work.defs.all;

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
		enable: in    boolean;
		done  : out   boolean;
		lcd   : inout std_logic_vector(LCD_LEN - 1 downto 0)
		);
end Power_On_Init;


architecture Power_On_Init of Power_On_Init is
	type STATE_TYPE is (
		READY_STATE,
		INIT_WAIT_STATE,
		FUNCTION_SET_STATE,
		FUNCTION_SET_WAIT_STATE,
		DISP_ON_STATE,
		DISP_ON_WAIT_STATE,
		DISP_CLR_STATE,
		DISP_CLR_WAIT_STATE,
		ENTRY_MODE_STATE,
		ENTRY_MODE_WAIT_STATE,
		DONE_STATE);

	signal fsm_state   : STATE_TYPE := READY_STATE;
	
	signal fs_enable : boolean := false;
	signal fs_done   : boolean;
	signal disp_onoff_enable: boolean := false;
	signal disp_onoff_done  : boolean;
	signal disp_clr_enable: boolean := false;
	signal disp_clr_done  : boolean;
	signal entry_mode_enable: boolean := false;
	signal entry_mode_done  : boolean;
begin

	COMP_FUNC_SET: Function_Set port map (clk, fs_enable, fs_done, '1', '1', '0', lcd);
	COMP_DISP_ON_OFF: Display_On_Off_Control port map (clk, disp_onoff_enable, disp_onoff_done, '1', '1', '1', lcd);
	COMP_DISP_CLEAR: Clear_Display port map (clk, disp_clr_enable, disp_clr_done, lcd);
	COMP_ENTRY_MODE: Entry_Mode_Set port map (clk, entry_mode_enable, entry_mode_done, '0', '0', lcd);

	process(clk)
		variable timer_counter : integer range 0 to 100000000 := 0; --Compteur d'horloge pour minuter les états 100Mhz (10 ns)
		variable func_set_repeat_counter : integer range 0 to 10 := 0; --Compteur d'iteration pour repeter une instruction
	begin

		if rising_edge(clk) then

			case fsm_state is

				when READY_STATE =>
					lcd(LCD_EN_IDX) <= '0';
					timer_counter := 0;
					
					if (enable) then
					  fsm_state <= INIT_WAIT_STATE;
					end if;
				
				when INIT_WAIT_STATE =>
					--led <= x"1";
					--lcden <= '0';
					--lcdrs <= '0';
					--lcdrw <= '0';

					timer_counter := timer_counter + 1;

					--Delai 40ms
					if timer_counter > 4000000 then
						fsm_state <= FUNCTION_SET_STATE;
						timer_counter := 0;
						func_set_repeat_counter := 3;
					end if;



				when FUNCTION_SET_STATE =>
					--led <= "01000000";
					fs_enable <= true;
					
					if (fs_done) then
						fs_enable <= false;
						fsm_state <= FUNCTION_SET_WAIT_STATE;
					end if;
--					lcdd <= INS_FUNCTION_SET;
--					lcdrs <= '0';
--					lcdrw <= '0';
--					timer_counter := timer_counter + 1;
--
--					--Delai d'activation enable 80 ns
--					if enable_counter > 8 then
--						lcden <= '0';
--					else
--						lcden <= '1';
--						enable_counter := enable_counter + 1;
--					end if;
--
--					--Délais 37 us
--					if timer_counter > 3700 then
--						enable_counter := 0;
--						timer_counter := 0;
--
--						if ins_loop_counter < 3 then
--							ins_loop_counter := ins_loop_counter + 1;
--							fsm_state <= FUNCTION_SET_STATE;
--						else
--							fsm_state <= DISP_ON_STATE;
--							ins_loop_counter := 0;
--						end if;
--					end if;

				when FUNCTION_SET_WAIT_STATE =>
					timer_counter := timer_counter + 1;
					if (timer_counter > 3700) then
						timer_counter := 0;
						
						if (func_set_repeat_counter > 1) then
							func_set_repeat_counter := func_set_repeat_counter - 1;
						else
							fsm_state <= DISP_ON_STATE;
						end if;
					end if;


				when DISP_ON_STATE =>
					disp_onoff_enable <= true;
					
					if (disp_onoff_done) then
						disp_onoff_enable <= false;
						fsm_state <= DISP_ON_WAIT_STATE;
					end if;
--					led <= "00100000";
--
--					lcdd <= INS_DISP_ON;
--					lcdrs <= '0';
--					lcdrw <= '0';
--					timer_counter := timer_counter + 1;
--
--					--Delai d'activation enable 80 ns
--					if enable_counter > 8 then
--						lcden <= '0';
--					else
--						lcden <= '1';
--						enable_counter := enable_counter + 1;
--					end if;
--
--					--Délais 37 us
--					if timer_counter > 3700 then
--						enable_counter := 0;
--						timer_counter := 0;
--						fsm_state <= DISP_CLR_STATE;
--
--					end if;

				when DISP_ON_WAIT_STATE =>
					timer_counter := timer_counter + 1;
					
					if (timer_counter > 3700) then
						timer_counter := 0;
						fsm_state <= DISP_CLR_STATE;
					end if;

				when DISP_CLR_STATE =>
--					led <= "00010000";
--
--					lcdd <= INS_DISP_CLR;
--					lcdrs <= '0';
--					lcdrw <= '0';
--					timer_counter := timer_counter + 1;

					disp_clr_enable <= true;
					if (disp_clr_done) then
						disp_clr_enable <= false;
					end if;

--					--Delai d'activation enable 80 ns
--					if enable_counter > 8 then
--						lcden <= '0';
--					else
--						lcden <= '1';
--						enable_counter := enable_counter + 1;
--					end if;
--
--					--Délais 1.52ms
--					if timer_counter > 152000 then
--						enable_counter := 0;
--						timer_counter := 0;
--						fsm_state <= PRINT_CHAR_STATE;
--
--					end if;

				when DISP_CLR_WAIT_STATE =>
					timer_counter := timer_counter + 1;
					
					if (timer_counter > 152000) then
						timer_counter := 0;
						fsm_state <= ENTRY_MODE_STATE;
					end if;

				when ENTRY_MODE_STATE =>
					entry_mode_enable <= true;
					
					if (entry_mode_done) then
						entry_mode_enable <= false;
						fsm_state <= ENTRY_MODE_WAIT_STATE;
					end if;
					
				when ENTRY_MODE_WAIT_STATE =>
					timer_counter := timer_counter + 1;
					
					if (timer_counter > 3700) then
						timer_counter := 0;
						fsm_state <= DONE_STATE;
					end if;
					
--				when PRINT_CHAR_STATE =>
--					led <= "00001000";
--
--					lcdd <= "01000001";
--					lcdrs <= '1';
--					lcdrw <= '0';
--					timer_counter := timer_counter + 1;
--
--					--Delai d'activation enable 80 ns
--					if enable_counter > 8 then
--						lcden <= '0';
--					else
--						lcden <= '1';
--						enable_counter := enable_counter + 1;
--					end if;
--
--					--Délais 37us
--					if timer_counter >3700 then
--						enable_counter := 0;
--						timer_counter := 0;
--						fsm_state <= DONE_STATE;
--
--					end if;
--
				when DONE_STATE =>
					done <= true;


--				when others =>
--					led <= "11110000";
--
			end case;
		end if;
	end process;
--
--	--lcdd <= "00000000";
--	--lcden <= '0';
--	--lcdrs <= '0';
--	--lcdrw <= '0';
--	--led <= "01010101";
end Power_On_Init;

