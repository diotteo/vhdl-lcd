----------------------------------------------------------------------------------
-- Company: ETS - ELE740
-- Programmer: Olivier Diotte & Marc-AndrÃ© SÃ©guin
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
		reset : in 	  std_logic; -- Bouton 1 utilisé comme reset
		led   : out   std_logic_vector(7 downto 0); -- Bus de LED sur la carte de dÃ©veloppement
		lcdrs : out   std_logic; -- Signal RS ( 0:instruction/ 1:data) contrÃ´lant le LCD
		lcdrw : out   std_logic; -- Signal RW (1:Read / 0:Write) contrÃ´lant le LCD
		lcden : out   std_logic; -- Signal enable permettant de valider l'instruction au LCD
		lcdd  : out std_logic_vector(7 downto 0) --Vecteur de Data/Instruction pour le LCD
		);
end afficheur;


architecture afficheur_main of afficheur is
	type state_t is (
			INIT_STATE,					-- Initialise les compteurs et registres
			POWER_ON_INIT_STATE, 	--Execute la séquence d'initialisation
			CLR_DISP_STATE, 			-- Efface l'écran avant l'écriture d'une expression
			CLR_DISP_WAIT_STATE,		-- Délai de 40us pour terminer l'instruction clear display
			WRITE_FIRST_LINE_STATE,	-- Écrit la premiere ligne de l'afficheur sans animation
			RST_CURSOR_STATE,			-- Place le curseur sur la 2e ligne de l'afficheur
			DECR_I_STATE,				-- Décrémente le compteur d'itération pour l'animation
			WRITE_EXPR_STATE,			-- Permet d'écrire un nombre de caractères sur la ligne 2 dépendant de l'animation
			WAIT_ANIM_DELAY_STATE,	-- Délai d'animation pour la transition de la ligne
			INCR_EXPR_STATE,			-- Calcul l'offset pour passer a la prochaine expression
			WAIT_TRANSITION_DELAY_STATE --Délai avant de passer à la prochaine expression
			);

	signal fsm_state : state_t := INIT_STATE;

	signal lcd    : lcd_type;
	signal poi_lcd: lcd_type;
	signal rc_lcd : lcd_type;
	signal cd_lcd : lcd_type;
	signal wl_lcd : lcd_type;

	signal do_power_on_init: boolean;
	signal power_on_init_done: boolean;
	signal do_set_ddram_addr: boolean;
	signal set_ddram_addr_done: boolean;
	signal do_clr_disp: boolean;
	signal clr_disp_done: boolean;
	signal do_write_char: boolean;
	signal write_char_done: boolean;
	signal do_write_line: boolean;
	signal write_line_done: boolean;

	signal wait_anim_done: boolean;
	signal wait_transition_done: boolean;

	--Signal permettant de contrôler la minuterie
	signal start_timer: boolean := false;
	signal timer_ns   : natural;
	signal timer_done : boolean;

	constant NB_EXPR : natural := 3;
	type string_array is array (NB_EXPR - 1 downto 0) of string (1 to 32);
	constant exprs_array: string_array := (
			"What... is your name?           ",
			"What... is your quest?          ",
			"What... is your favorite color? ");

	signal expr_idx: natural range 0 to 2 := 0;
	signal i: natural range 0 to 16 := 0;


	constant LAST_ADDR: std_logic_vector(6 downto 0) := std_logic_vector(to_unsigned(16#50#, 7));
begin
	led(0) <= clk;


	-- lcd variables are hidden in a vector
	lcdd <= lcd.data;
	lcdrs <= lcd.rs;
	lcdrw <= lcd.rw;
	lcden <= lcd.en;

	COMP_INIT: Power_On_Init port map (clk, do_power_on_init, power_on_init_done, poi_lcd);
	COMP_RST_CURSOR: Set_Ddram_Address port map (clk, do_set_ddram_addr, set_ddram_addr_done, LAST_ADDR, rc_lcd);
	COMP_CLR_DISP: Clear_Display port map (clk, do_clr_disp, clr_disp_done, cd_lcd);

	-- FIX ME change the start address for dynamic address
	COMP_WRITE_LINE: Write_First_line port map (clk, reset, do_write_line, write_line_done, "TESTTESTTESTTEST", LAST_ADDR, 16, wl_lcd);

	TIMER_WAIT: Timer port map (clk, reset, start_timer, timer_ns, timer_done);

	process(clk)
		variable j: natural; -- Compteur pour répéter l'animation sur une ligne
		variable offset: natural := 0;
		variable charpos: natural := 0;
	begin

		if rising_edge(clk) then
			case fsm_state is

				-- Initialise les compteurs et registres
				when INIT_STATE =>
					led(7 downto 1) <= "0000000";
					--Init variables and what not here

					offset := 0;

					do_power_on_init <= false;
					do_set_ddram_addr <= false;
					do_clr_disp <= false;
					do_write_char <= false;
					do_write_line <= false;

					-- Initialize the lcd.en fields to 0.
					-- This is useful when we connect the LCD pins to an uninitialized module
					-- lcd.en <= '0';
					-- poi_lcd.en <= '0';
					-- rc_lcd.en  <= '0';
					-- cd_lcd.en  <= '0';
					-- wl_lcd.en  <= '0';
					fsm_state <= POWER_ON_INIT_STATE;

				--Execute la séquence d'initialisation
				when POWER_ON_INIT_STATE =>
					led(7 downto 1) <= "0000001";
				
					-- raise power on init's enable bit
					do_power_on_init <= true;
					lcd <= poi_lcd;

					if (power_on_init_done) then
						do_power_on_init <= false;
						fsm_state <= CLR_DISP_STATE;
					end if;

				-- Efface l'écran avant l'écriture d'une expression
				when CLR_DISP_STATE =>
					led(7 downto 1) <= "0000010";
					
					do_clr_disp <= true;
					lcd <= cd_lcd;

					if (clr_disp_done) then
						do_clr_disp <= false;
						fsm_state <= CLR_DISP_WAIT_STATE;
					end if;

				-- Délais de 40us pour terminer l'instruction clear display
				when CLR_DISP_WAIT_STATE =>

					start_timer <= true;
					timer_ns <= CLR_DISP_WAIT_COUNT;

					if (timer_done) then
						start_timer <= false;

						--if != 0
						if (offset /= 0) then
							fsm_state <= WRITE_FIRST_LINE_STATE;
						else
							fsm_state <= RST_CURSOR_STATE;
						end if;
					end if;

				-- Écrit la premiere ligne de l'afficheur sans animation
				when WRITE_FIRST_LINE_STATE =>
					led(7 downto 1) <= "0000100";
					do_write_line <= true;
					lcd <= wl_lcd;

					if (write_line_done) then

						do_write_line <= false;
						fsm_state <= RST_CURSOR_STATE;

					end if;

				-- Place le curseur sur la 2e ligne de l'afficheur
				when RST_CURSOR_STATE =>
					led(7 downto 1) <= "0001000";
					do_set_ddram_addr <= true;
					lcd <= rc_lcd;

					if (set_ddram_addr_done) then
						do_set_ddram_addr <= false;
						i <= 16;
						j := 16;
						fsm_state <= DECR_I_STATE;
					end if;

				-- Décrémente le compteur d'animation pour une ligne
				when DECR_I_STATE =>
					i <= i - 1;

					-- i - 1 as decrement will take effect only at next clock cycle
					--charpos := to_integer(to_unsigned(expr_idx, 10) sll 5) + i - 1;
					fsm_state <= WRITE_EXPR_STATE;

				-- Permet d'écrire un nombre de caractères sur la ligne 2 dépendant de l'animation
				when WRITE_EXPR_STATE =>
					led(7 downto 1) <= "0010000";
					do_write_line <= true;
					lcd <= wl_lcd;

					if (write_line_done) then

						do_write_line <= false;
						if (i < j) then
							j := j - 1;
							fsm_state <= WAIT_ANIM_DELAY_STATE;
						else
							fsm_state <= DECR_I_STATE;
						end if;
					end if;

				-- Délai d'animation pour la transition de la ligne
				when WAIT_ANIM_DELAY_STATE =>
					led(7 downto 1) <= "0100000";
					start_timer <= true;
					timer_ns <= ANIMATION_DELAY_WAIT_COUNT;

					if (timer_done) then
						start_timer <= false;

						if (j /= 0) then
							fsm_state <= DECR_I_STATE;
						elsif (offset = 0) then
							offset := 16; --Prochaine ligne
							fsm_state <= CLR_DISP_STATE; --Prepare l'écran pour la prochaine ligne
						else
							fsm_state <= INCR_EXPR_STATE;
						end if;
					end if;

				-- Calcul l'offset pour passer a la prochaine expression
				when INCR_EXPR_STATE =>
					if expr_idx = NB_EXPR - 1 then
						expr_idx <= 0;
					else
						expr_idx <= expr_idx + 1;
					end if;

					offset := 0;
					fsm_state <= WAIT_TRANSITION_DELAY_STATE;

				--Délai avant de passer à la prochaine expression
				when WAIT_TRANSITION_DELAY_STATE =>
					led(7 downto 1) <= "1000000";
					start_timer <= true;
					timer_ns <= TRANSITION_DELAY_WAIT_COUNT;

					if (timer_done) then

						start_timer <= false;
						fsm_state <= CLR_DISP_STATE;

					end if;

			end case;
		end if;
	end process;

end afficheur_main;
