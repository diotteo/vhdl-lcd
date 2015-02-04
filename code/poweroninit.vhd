----------------------------------------------------------------------------------
-- Company: ETS - ELE740
-- Programmer: Olivier Diotte & Marc-André Séguin
-- 
-- Create Date:    11:13:42 01/20/2015 
-- Module Name:    Power_On_Init
-- Project Name:   Afficheur LCD
-- Target Devices: Virtex 5 LX50T
--
-- Description:    Module permettant d'envoyer la séquence d'initialisation au LCD.
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
		clk   : in    std_logic; -- Horloge venant du main (100 Mhz)
		enable: in    boolean;   -- Signal permettant de démarrer la séquence Power On (Doit être mis à 0 avant un prochain power on)
		done  : out   boolean;   -- Signal indiquant que la séquence de Power On est terminée
		rs_wr : out   std_logic; -- Signal instruction/data envoyé au module write
		instr_wr : out   std_logic_vector( 7 downto 0); --Vecteur d'instruction envoyé au module write
		enable_wr: out std_logic; --Signal permettant de démarrer le module write
		done_wr: in   boolean	 -- Signal venant du module write impliquant que la communication est terminée
		);
end Power_On_Init;


architecture Power_On_Init of Power_On_Init is
	
	type STATE_TYPE is (
		READY_STATE,        		-- Attends après le signal Enable pour commencer le Power On. Initialise les compteurs et registres
		READ_WAIT_STATE,			-- Délai de 40 ms avant de démarrer la séquence d'initialisation
		FUNCTION_SET_STATE,			-- Transmet l'instruction function set au lcd 
		FUNCTION_SET_WAIT_STATE,	-- Délai de 40 us pour terminer la transmission de Function Set
		DISP_ON_STATE,				-- Transmet l'instruction display_on au lcd pour allumer celui-ci et activer le curseur.
		DISP_ON_WAIT_STATE,			-- Délai de 40 us pour terminer la transmission de Disp_On
		DISP_CLR_STATE,				-- Transmet l'instruction display_clear au lcd pour  effacer l'écran.
		DISP_CLR_WAIT_STATE,		-- Délai de 1.52 ms pour terminer la transmission de Disp_Clear
		ENTRY_MODE_STATE,			-- Transmet l'instruction Entry_mode au lcd pour définir le sens d'écriture.
		ENTRY_MODE_WAIT_STATE,		-- Délai de 40 us pour terminer la transmission de Entry_mode
		DONE_STATE					-- L'initialisation est terminée, le signal Enable doit retourner à zéro pour recommencer
		);

	signal fsm_state   : STATE_TYPE := READY_STATE; -- Signal contenant les états

	-- Signaux instruction/data et instruction venant des modules de commandes 
	signal rs_clear_disp: std_logic;
	signal instr_clear_disp: std_logic_vector(7 downto 0);
	
	signal rs_disp_on: std_logic;
	signal instr_disp_on: std_logic_vector(7 downto 0);
	
	signal rs_fct_set: std_logic;
	signal instr_fct_set: std_logic_vector(7 downto 0);
	
	signal rs_entry_mode: std_logic;
	signal instr_entry_mode: std_logic_vector(7 downto 0);
	
begin

	--Définis les vecteurs instructions pour le module Power On
	COMP_FUNC_SET: Function_Set port map ('1', '1', '0', rs_fct_set, instr_fct_set); -- 5*8 dots, 2 lignes, Bus 8-bits
	COMP_DISP_ON_OFF: Display_On_Off_Control port map ('1', '1', '1', lcd ,rs_disp_on, instr_disp_on); -- Curseur, écran et clignotement actif
	COMP_ENTRY_MODE: Entry_Mode_Set port map ('0', '0', rs_entry_mode, instr_entry_mode; --l'écran et le curseur se décaleront vers la gauche
	COMP_CLR_DISP: Clear_Display port map (rs_clear_disp, instr_clear_disp);
	
	process(clk)
		variable timer_counter : integer range 0 to 100000000 := 0; --Compteur d'horloge pour minuter les états 100Mhz (10 ns)
		variable repeat_fct_set : integer range 0 to 10 := 0; --Compteur d'itération pour répéter une instruction
	begin

		if rising_edge(clk) then

			case fsm_state is

				-- Attends après le signal Enable pour commencer le Power On
				when READY_STATE =>
					
					--RAZ des registres et compteurs
					enable_wr := 0;
					timer_counter := 0;
					repeat_fct_set := 0;
					done <= false;
					--start_timer := 0;
					
					if (enable) then
					  fsm_state <= READ_WAIT_STATE;
					end if;
				
				-- Délai de 40 ms avant de démarrer la séquence d'initialisation
				when READY_WAIT_STATE =>

					timer_counter := timer_counter + 1;
					--start_timer := 1;
					--timer_ns := 4000000;
					
					--Delai 40ms
					if timer_counter > 4000000 then
						fsm_state <= FUNCTION_SET_STATE;
						timer_counter := 0;
					end if;


				-- Transmet l'instruction function set au lcd pour configurer les caractérisitques du LCD (taille, nb ligne)
				when FUNCTION_SET_STATE =>
					
					enable_wr := 1;
					instr_wr <= instr_fct_set;
					rs_wr <= rs_fct_set;
					
					if (done_wr) then
						enable_wr := 0;
						repeat_fct_set := repeat_fct_set + 1; --Incrémente le nombre d'exécution de la commande FUNCTION_SET
						fsm_state <= FUNCTION_SET_WAIT_STATE;
					end if;
					
					
				
				-- Délai de 40 us pour terminer la transmission de Function Set
				when FUNCTION_SET_WAIT_STATE =>
					
					timer_counter := timer_counter + 1;
					
					
					if (timer_counter > 4000) then
						timer_counter := 0;
						
						-- Si function_set a été répété 3 fois, nous passons à la prochaine étape.
						-- Sinon, nous répétons function set
						if (repeat_fct_set >= 3) then
							fsm_state <= FUNCTION_SET_STATE;
						else
							fsm_state <= DISP_ON_STATE;
						end if;
						
					end if;

				-- Transmet l'instruction display_on au lcd pour allumer celui-ci et activer le curseur.
				when DISP_ON_STATE =>
					
					enable_wr := 1;
					instr_wr <= instr_disp_on;
					rs_wr <= rs_disp_on;
					
					if (done_wr) then
						enable_wr := 0;
						fsm_state <= DISP_ON_WAIT_STATE;
					end if;

				-- Délai de 40 us pour terminer la transmission de Disp_On
				when DISP_ON_WAIT_STATE =>
					timer_counter := timer_counter + 1;
					
					if (timer_counter > 4000) then
						timer_counter := 0;
						fsm_state <= DISP_CLR_STATE;
					end if;

					
				-- Transmet l'instruction display_clear au lcd pour effacer l'écran.	
				when DISP_CLR_STATE =>
					
					enable_wr := 1;
					instr_wr <= instr_clear_disp;
					rs_wr <= rs_clear_disp;

					if (done_wr) then
						--enable_wr := 0;
						fsm_state <= DISP_CLR_WAIT_STATE;
					end if;

				-- Délai de 1.52 ms pour terminer la transmission de Disp_Clear
				when DISP_CLR_WAIT_STATE =>
					
					timer_counter := timer_counter + 1;
					
					if (timer_counter > 152000) then
						timer_counter := 0;
						fsm_state <= ENTRY_MODE_STATE;
					end if;

					
				-- Transmet l'instruction Entry_mode au lcd pour définir le sens d'écriture.
				when ENTRY_MODE_STATE =>
					entry_mode_enable <= true;
					
					enable_wr := '1';
					instr_wr <= instr_entry_mode;
					rs_wr <= rs_entry_mode;
					
					if (entry_mode_done) then
						enable_wr := 0;
						fsm_state <= ENTRY_MODE_WAIT_STATE;
					end if;
				
				-- Délai de 40 us pour terminer la transmission de Entry_mode
				when ENTRY_MODE_WAIT_STATE =>
					timer_counter := timer_counter + 1;
					
					if (timer_counter > 4000) then
						timer_counter := 0;
						fsm_state <= DONE_STATE;
					end if;
							
				-- L'initialisation est terminée, le signal Enable doit retourner à zéro pour recommencer
				when DONE_STATE =>
					done <= true;
					
					if (/enable) then
						done <= false;
						fsm_state <= READY_STATE;
					end if;
				
				-- S'il y a une erreur, nous recommencons la transmission
				when others =>
					fsm_state <= READY_STATE;

			end case;
		end if;
	end process;
end Power_On_Init;

