----------------------------------------------------------------------------------
-- Company: ETS - ELE740
-- Programmer: Olivier Diotte & Marc-Andre Seguin
--
-- Create Date:
-- Module Name:    Power_On_Init
-- Project Name:   Afficheur LCD
-- Target Devices: Virtex 5 LX50T
--
-- Description:    Module permettant d'envoyer la sequence d'initialisation au LCD.
--
-- Dependencies:   Write Module
--
-- Revision: 0.01
-- Additional Comments:
--
----------------------------------------------------------------------------------

use work.defs.all;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;


entity Power_On_Init is
	port(
		clk : in std_logic;
		enable : in boolean;
		done : out boolean;
		lcd : inout lcd_type);
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

	signal fsm_state : STATE_TYPE := READY_STATE;

	signal fs_enable : boolean;
	signal fs_done : boolean;
	signal disp_onoff_enable : boolean;
	signal disp_onoff_done : boolean;
	signal disp_clr_enable : boolean;
	signal disp_clr_done : boolean;
	signal entry_mode_enable : boolean;
	signal entry_mode_done : boolean;

	signal fs_lcd : lcd_type;
	signal dooc_lcd : lcd_type;
	signal cd_lcd : lcd_type;
	signal ems_lcd : lcd_type;
begin

	COMP_FUNC_SET : Function_Set port map (clk, fs_enable, fs_done, '1', '1', '0', fs_lcd);
	COMP_DISP_ON_OFF : Display_On_Off_Control port map (clk, disp_onoff_enable, disp_onoff_done, '1', '1', '1', dooc_lcd);
	COMP_DISP_CLEAR : Clear_Display port map (clk, disp_clr_enable, disp_clr_done, cd_lcd);
	COMP_ENTRY_MODE : Entry_Mode_Set port map (clk, entry_mode_enable, entry_mode_done, '0', '0', ems_lcd);

	process(clk)
		variable timer_counter : natural := 0; --Compteur d'horloge pour minuter les etats 100Mhz (10 ns)
		variable func_set_repeat_counter : natural := 0; --Compteur d'iteration pour repeter une instruction
	begin

		if rising_edge(clk) then

			case fsm_state is

			-- Attends apres le signal Enable pour commencer le Power On
			when READY_STATE =>
				lcd.en <= '0';
				done <= false;

				fs_enable <= false;
				disp_onoff_enable <= false;
				disp_clr_enable <= false;
				entry_mode_enable <= false;

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
				if timer_counter > POI_INIT_WAIT_COUNT then
					fsm_state <= FUNCTION_SET_STATE;
					timer_counter := 0;
					func_set_repeat_counter := 3;
				end if;


			-- Transmet l'instruction function set au lcd pour configurer les caracterisitques du LCD (taille, nb ligne)
			when FUNCTION_SET_STATE =>
				--led <= "01000000";
				fs_enable <= true;
				lcd <= fs_lcd;

				if (fs_done) then
					fs_enable <= false;
					fsm_state <= FUNCTION_SET_WAIT_STATE;
				end if;



			-- Delai de 40 us pour terminer la transmission de Function Set
			when FUNCTION_SET_WAIT_STATE =>
				timer_counter := timer_counter + 1;


				if (timer_counter > FCT_SET_WAIT_COUNT) then
					timer_counter := 0;

					if (func_set_repeat_counter > 1) then
						func_set_repeat_counter := func_set_repeat_counter - 1;
						fsm_state <= FUNCTION_SET_STATE;
					else
						fsm_state <= DISP_ON_STATE;
					end if;
				end if;

			-- Transmet l'instruction display_on au lcd pour allumer celui-ci et activer le curseur.
			when DISP_ON_STATE =>
				disp_onoff_enable <= true;
				lcd <= dooc_lcd;

				if (disp_onoff_done) then
					disp_onoff_enable <= false;
					fsm_state <= DISP_ON_WAIT_STATE;
				end if;

			-- Delai de 40 us pour terminer la transmission de Disp_On
			when DISP_ON_WAIT_STATE =>
				timer_counter := timer_counter + 1;

				if (timer_counter > DISP_ON_OFF_CTL_WAIT_COUNT) then
					timer_counter := 0;
					fsm_state <= DISP_CLR_STATE;
				end if;


			-- Transmet l'instruction display_clear au lcd pour effacer l'ecran.
			when DISP_CLR_STATE =>

				disp_clr_enable <= true;
				lcd <= cd_lcd;

				if (disp_clr_done) then
					disp_clr_enable <= false;
					fsm_state <= DISP_CLR_WAIT_STATE;
				end if;

			-- Delai de 1.52 ms pour terminer la transmission de Disp_Clear
			when DISP_CLR_WAIT_STATE =>
				timer_counter := timer_counter + 1;

				if (timer_counter > CLR_DISP_WAIT_COUNT) then
					timer_counter := 0;
					fsm_state <= ENTRY_MODE_STATE;
				end if;


			-- Transmet l'instruction Entry_mode au lcd pour definir le sens d'ecriture.
			when ENTRY_MODE_STATE =>
				entry_mode_enable <= true;
				lcd <= ems_lcd;

				if (entry_mode_done) then
					entry_mode_enable <= false;
					fsm_state <= ENTRY_MODE_WAIT_STATE;
				end if;

			-- Delai de 40 us pour terminer la transmission de Entry_mode
			when ENTRY_MODE_WAIT_STATE =>
				timer_counter := timer_counter + 1;

				if (timer_counter > EMS_WAIT_COUNT) then
					timer_counter := 0;
					fsm_state <= DONE_STATE;
				end if;

			-- L'initialisation est terminee, le signal Enable doit retourner a zero pour recommencer
			when DONE_STATE =>
				done <= true;

				if (not enable) then
					fsm_state <= DONE_STATE;
				end if;

			end case;
		end if;
	end process;
end Power_On_Init;

