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
		reset : in 	  std_logic; -- Bouton 1 utilis� comme reset
		led   : out   std_logic_vector(7 downto 0); -- Bus de LED sur la carte de développement
		lcdrs : out   std_logic; -- Signal RS ( 0:instruction/ 1:data) contrôlant le LCD
		lcdrw : out   std_logic; -- Signal RW (1:Read / 0:Write) contrôlant le LCD
		lcden : out   std_logic; -- Signal enable permettant de valider l'instruction au LCD
		lcdd  : out std_logic_vector(7 downto 0) --Vecteur de Data/Instruction pour le LCD
		);
end afficheur;


architecture afficheur_main of afficheur is
	type state_t is (
			INIT_STATE,					-- Initialise les compteurs et registres
			POWER_ON_INIT_STATE, 	--Execute la s�quence d'initialisation 
			CLR_DISP_STATE, 			-- Efface l'�cran avant l'�criture d'une expression
			CLR_DISP_WAIT_STATE,		-- D�lai de 40us pour terminer l'instruction clear display
			WRITE_FIRST_LINE_STATE,	-- �crit la premiere ligne de l'afficheur sans animation
			RST_CURSOR_STATE,			-- Place le curseur sur la 2e ligne de l'afficheur
			DECR_I_STATE,				-- D�cr�mente le compteur d'it�ration pour l'animation
			WRITE_EXPR_STATE,			-- Permet d'�crire un nombre de caract�res sur la ligne 2 d�pendant de l'animation
			WAIT_ANIM_DELAY_STATE,	-- D�lai d'animation pour la transition de la ligne		
			INCR_EXPR_STATE,			-- Calcul l'offset pour passer a la prochaine expression			
			WAIT_TRANSITION_DELAY_STATE --D�lai avant de passer � la prochaine expression
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
	
	--Signal permettant de contr�ler la minuterie
	signal start_timer : boolean := false;
	signal timer_ns :		integer;
	signal timer_done:	boolean;
	
	type string_array is array (2 downto 0) of string (0 to 32);
	signal exprs_array: string_array;
	
	signal expr_idx: integer range 0 to 2 := 0;
	signal i: integer range 0 to 16 := 0;
	
	
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
	
	-- FIX ME change the start address for dynamic address
	COMP_WRITE_LINE: Write_First_line port map (clk, reset, do_write_line, write_line_done, "TESTTESTTESTTEST", LAST_ADDR, 10, wl_lcd );
		
	TIMER_WAIT: Timer port map (clk, reset, start_timer, timer_ns, timer_done);
	
	exprs_array(0) <= "What... is your name?           ";
	exprs_array(1) <= "What... is your quest?          ";
	exprs_array(2) <= "What... is your favorite color? ";
	
	process(clk)
		variable j: integer; -- i Compteur pour r�p�ter l'animation sur une ligne 
		variable offset: integer := 0;
		variable charpos: integer := 0;
		

		--FIXME: We need to figure out how to print characters and therefore which type to use
		constant EXPR_IDX_MAX: integer := 8 * 32 * 3 - 1;
		variable expr: std_logic_vector(EXPR_IDX_MAX downto 0);
	begin
		
		if rising_edge(clk) then
			case fsm_state is

				-- Initialise les compteurs et registres
				when INIT_STATE =>
					--Init variables and what not here
					
					offset := 0;
					lcd.en <= '0';
					fsm_state <= POWER_ON_INIT_STATE;

				--Execute la s�quence d'initialisation 
				when POWER_ON_INIT_STATE =>
					-- raise power on init's enable bit
					do_power_on_init <= true;
					lcd <= poi_lcd;

					if (power_on_init_done) then
						do_power_on_init <= false;
						fsm_state <= CLR_DISP_STATE;
					end if;

				-- Efface l'�cran avant l'�criture d'une expression
				when CLR_DISP_STATE =>
					do_clr_disp <= true;
					lcd <= cd_lcd;

					if (clr_disp_done) then
						do_clr_disp <= false;
						fsm_state <= CLR_DISP_WAIT_STATE;
					end if;
			
				-- D�lais de 40us pour terminer l'instruction clear display
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

				-- �crit la premiere ligne de l'afficheur sans animation
				when WRITE_FIRST_LINE_STATE =>
					
					do_write_line <= true;
					
					if (write_line_done) then
					
						do_write_line <= false;
						fsm_state <= RST_CURSOR_STATE;
						
					end if;
				
				-- D�lai d'animation pour la transition de la ligne
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
			

				-- Place le curseur sur la 2e ligne de l'afficheur
				when RST_CURSOR_STATE =>
					do_set_ddram_addr <= true;
					lcd <= rc_lcd;

					if (set_ddram_addr_done) then
						do_set_ddram_addr <= false;
						i <= 16;
						j := 16;
						fsm_state <= DECR_I_STATE;
					end if;

				-- D�cr�mente le compteur d'animation pour une ligne
				when DECR_I_STATE =>
					i <= i - 1;

					-- i - 1 as decrement will take effect only at next clock cycle
					charpos := to_integer(to_unsigned(expr_idx, 10) sll 5) + i - 1;
					fsm_state <= WRITE_EXPR_STATE;

				-- Permet d'�crire un nombre de caract�res sur la ligne 2 d�pendant de l'animation
				when WRITE_EXPR_STATE =>

					do_write_line <= true;
					
					if (write_line_done) then
					
						do_write_line <= false;
						if (i < j) then
							j := j - 1;
							fsm_state <= WAIT_ANIM_DELAY_STATE;
						else
							fsm_state <= DECR_I_STATE;
						end if;
					end if;
					
				-- D�lai d'animation pour la transition de la ligne
				when WAIT_ANIM_DELAY_STATE =>
				
					start_timer <= true;
					timer_ns <= ANIMATION_DELAY_WAIT_COUNT;
					
					if (timer_done) then
						start_timer <= false;
						
						if (j /= 0) then
							fsm_state <= DECR_I_STATE;
						elsif (offset = 0) then
							offset := 16; --Prochaine ligne
							fsm_state <= CLR_DISP_STATE; --Prepare l'�cran pour la prochaine ligne
						else
							fsm_state <= INCR_EXPR_STATE;
						end if;
					end if;
			
				-- Calcul l'offset pour passer a la prochaine expression
				when INCR_EXPR_STATE =>
					if expr_idx = EXPR_IDX_MAX then
						expr_idx <= 0;
					else
						expr_idx <= expr_idx + 1;
					end if;

					offset := 0;
					fsm_state <= WAIT_TRANSITION_DELAY_STATE;

				--D�lai avant de passer � la prochaine expression
				when WAIT_TRANSITION_DELAY_STATE =>
				
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
