----------------------------------------------------------------------------------
-- Company: ETS - ELE740
-- Programmer: Olivier Diotte & Marc-André Séguin
--
-- Create Date:
-- Module Name:    main.vhd
-- Project Name:   Afficheur LCD
-- Target Devices: Virtex 5 LX50T
--
-- Description:    Programme permettant d'afficher 3 expressions sur un LCD 1609 avec une petite animation.
--
-- Dependencies:   Module Write, Ensemble des modules fonctions
--
-- Revision: 0.01
-- Additional Comments:
--
----------------------------------------------------------------------------------
use work.defs.all;

library IEEE;
use IEEE.std_logic_1164.all;

use IEEE.numeric_std.all;

entity afficheur is
	port(
		clk   : in    std_logic; --Horloge de 100Mhz venant de l'oscillateur du FPGA
		led   : out   std_logic_vector(7 downto 0); -- Bus de LED sur la carte de développement
		lcdrs : out   std_logic; -- Signal RS ( 0:instruction/ 1:data) contrôlant le LCD
		lcdrw : out   std_logic; -- Signal RW (1:Read / 0:Write) contrôlant le LCD
		lcden : out   std_logic; -- Signal enable permettant de valider l'instruction au LCD
		lcdd  : out std_logic_vector(7 downto 0) --Vecteur de Data/Instruction pour le LCD
		);
end afficheur;


architecture afficheur_main of afficheur is
	type state_t is (
			INIT_STATE,
			POWER_ON_INIT_STATE,
			CLR_DISP_STATE,
			WRITE_FIRST_LINE_STATE,
			RST_CURSOR_STATE,
			SET_J_STATE,
			SET_I_STATE,
			DECR_I_STATE,
			WRITE_EXPR_STATE,
			WAIT_ANIM_DELAY_STATE,
			ADD_OFFSET_STATE,
			INCR_EXPR_STATE,
			WAIT_TRANSITION_DELAY_STATE
			);

	signal fsm_state : state_t := INIT_STATE;

	signal lcd    : lcd_type;
	signal poi_lcd: lcd_type;
	signal rc_lcd : lcd_type;
	signal cd_lcd : lcd_type;

	signal do_power_on_init: boolean;
	signal power_on_init_done: boolean;
	signal do_set_ddram_addr: boolean;
	signal set_ddram_addr_done: boolean;
	signal do_clr_disp: boolean;
	signal clr_disp_done: boolean;


	signal do_write_char: boolean;
	signal write_char_done: boolean;

	signal wait_anim_done: boolean;
	signal wait_transition_done: boolean;

	constant LAST_ADDR: std_logic_vector(6 downto 0) := std_logic_vector(to_unsigned(16#50#, 7));
begin

	-- lcd variables are hidden in a vector
	lcdd <= lcd.data;
	lcdrs <= lcd.rs;
	lcdrw <= lcd.rw;
	lcden <= lcd.en;

	COMP_INIT: Power_On_Init port map (clk, do_power_on_init, power_on_init_done, poi_lcd);
	COMP_RST_CURSOR: Set_Ddram_Address port map (clk, do_set_ddram_addr, set_ddram_addr_done, LAST_ADDR, rc_lcd);
	COMP_CLR_DISP: Clear_Display port map (clk, do_clr_disp, clr_disp_done, cd_lcd);

	process(clk)
		variable i, j: integer;
		variable offset: integer := 0;
		variable charpos: integer := 0;
		variable expr_idx: integer := 0;

		--FIXME: We need to figure out how to print characters and therefore which type to use
		constant EXPR_IDX_MAX: integer := 8 * 32 * 3 - 1;
		variable expr: std_logic_vector(EXPR_IDX_MAX downto 0);
	begin
		if rising_edge(clk) then
			case fsm_state is

				when INIT_STATE =>
					--Init variables and what not here

					lcd.en <= '0';
					fsm_state <= POWER_ON_INIT_STATE;


				when POWER_ON_INIT_STATE =>
					-- raise power on init's enable bit
					do_power_on_init <= true;
					lcd <= poi_lcd;

					if (power_on_init_done) then
						do_power_on_init <= false;
						fsm_state <= CLR_DISP_STATE;
					end if;


				when CLR_DISP_STATE =>
					do_clr_disp <= true;
					lcd <= cd_lcd;

					if (clr_disp_done) then
						do_clr_disp <= false;

						--if != 0
						if (offset /= 0) then
							fsm_state <= WRITE_FIRST_LINE_STATE;
						else
							fsm_state <= RST_CURSOR_STATE;
						end if;
					end if;


				when WRITE_FIRST_LINE_STATE =>
					--COMP_WRITE_LINE: WRITE_LINE port map ();

					--if (done) then
						--enable <= 0
					--	fsm_state <= RST_CURSOR_STATE;
					--end if;


				when RST_CURSOR_STATE =>
					do_set_ddram_addr <= true;
					lcd <= rc_lcd;

					if (set_ddram_addr_done) then
						do_set_ddram_addr <= false;
						fsm_state <= SET_J_STATE;
					end if;


				when SET_J_STATE =>
					j := 16;
					fsm_state <= SET_I_STATE;


				when SET_I_STATE =>
					i := 16;
					fsm_state <= DECR_I_STATE;


				when DECR_I_STATE =>
					i := i - 1;

					-- i - 1 as decrement will take effect only at next clock cycle
					charpos := to_integer(to_unsigned(expr_idx, 10) sll 5) + i - 1;
					fsm_state <= WRITE_EXPR_STATE;


				when WRITE_EXPR_STATE =>
					--COMP_CHAR_WRITE: WRITE_CHAR port map (expr(charpos))

					if (write_char_done) then
						-- FIXME: Is this possible?
						if (i < j) then
							j := j - 1;
							fsm_state <= WAIT_ANIM_DELAY_STATE;
						else
							fsm_state <= DECR_I_STATE;
						end if;
					end if;


				when WAIT_ANIM_DELAY_STATE =>
					if (wait_anim_done) then
						if (j /= 0) then
							fsm_state <= SET_I_STATE;
						elsif (offset = 0) then
							fsm_state <= ADD_OFFSET_STATE;
						else
							fsm_state <= INCR_EXPR_STATE;
						end if;
					end if;


				when ADD_OFFSET_STATE =>
					offset := 16;
					fsm_state <= CLR_DISP_STATE;


				when INCR_EXPR_STATE =>
					if expr_idx = EXPR_IDX_MAX then
						expr_idx := 0;
					else
						expr_idx := expr_idx + 1;
					end if;

					offset := 0;
					fsm_state <= WAIT_TRANSITION_DELAY_STATE;


				when WAIT_TRANSITION_DELAY_STATE =>
					if (wait_transition_done) then
						fsm_state <= CLR_DISP_STATE;
					end if;
			end case;
		end if;
	end process;

end afficheur_main;
