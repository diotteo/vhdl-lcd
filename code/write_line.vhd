----------------------------------------------------------------------------------
-- Company: ETS - ELE740
-- Programmer: Olivier Diotte & Marc-André Séguin
-- 
-- Create Date:    11:13:42 01/20/2015 
-- Module Name:    Write_First_Line
-- Project Name:   Afficheur LCD
-- Target Devices: Virtex 5 LX50T
--
-- Description:    Module permettant d'écrire une ligne sur l'afficheur sans animation
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

entity Write_First_line is
	port(
		clk   : in    std_logic; --Horloge du compteur 
		rst	: in	  std_logic; --Signal synchrone pour remettre à zéro le compteur  
		enable: in    boolean;   -- Signal permettant de démarrer la séquence d'écriture (Doit être mis à 0 avant la prochaie écriture)
		done  : out   boolean;   -- Signal indiquant que la séquence d'écriture est terminée
		line_1: in    string ( 1 to 16 ); --Signal contenant le text à écrire
		position	: in	  std_logic_vector(6 downto 0); --Position où commencer à écrire la ligne
		lcd   : out   lcd_type
		);
end Write_First_line;


architecture Write_First_line of Write_First_line is
	
	type STATE_TYPE is (
		READY_STATE,        		-- Attends après le signal Enable pour commencer l'écriture. Initialise les compteurs et registres
		SET_CURSOR_STATE,			-- Permet de placer le curseur à droite de la première ligne
		SET_CURSOR_WAIT_STATE,		-- Délai de 40 us pour terminer la transmission de SET_CURSOR
		WRITE_CHAR_STATE,			-- Permet d'écrire le caractère à l'index i sur l'écran
		WRITE_CHAR_WAIT_STATE,		-- Délai de 40 us pour terminer la transmission de Write Char
		DONE_STATE					-- L'écriture est terminée, le signal Enable doit retourner à zéro pour recommencer
		);

	signal fsm_state   : STATE_TYPE := READY_STATE; -- Signal contenant les états

	-- Signaux utilisés pour démarrer une commande et vérifier si elle est terminée.
	signal do_set_ddram_addr: boolean := false;
	signal set_ddram_addr_done: boolean;
	
	signal do_write_data_to_ram: boolean := false;
	signal write_data_to_ram_done: boolean;
	
	signal i: integer range 0 to 16 := 16; -- Index pointant dans le string
	
	-- Signaux intermédiaire à transmettre au LCD 
	signal sda_lcd: lcd_type;
	signal wr_lcd : lcd_type;
	
	-- Vecteur contenant le caractere ascii en vecteur de bits
	signal character_string : std_logic_vector(7 downto 0);
	
	--Signal permettant de contrôler la minuterie
	signal start_timer : boolean := false;
	signal timer_ns :		integer;
	signal timer_done:	boolean;

begin

	--Définis les vecteurs instructions pour le module Write First Line
	COMP_RST_CURSOR: Set_Ddram_Address port map (clk, do_set_ddram_addr, set_ddram_addr_done, position, sda_lcd); -- Génère l'instruction pour placer le curseur à la 1ere ligne à droite
	COMP_WR_CHAR: Write_Data_To_Ram port map (clk, do_write_data_to_ram, write_data_to_ram_done, character_string, wr_lcd); -- Génère l'instruction pour écrire le charactère à l'index i de line_1

	TIMER_WAIT: Timer port map (clk, rst, start_timer, timer_ns, timer_done);
	
	process(clk)	
	begin

		if rising_edge(clk) then
			
			-- Dans le cas d'une remise à zéro, nous retournons à l'état initial
			if rst = '1' then
			
				do_set_ddram_addr <= false;
				do_write_data_to_ram <= false;
				start_timer <= false;
				i <= 16;
				fsm_state <= READY_STATE;
				
			else
			

				case fsm_state is

					-- Attends après le signal Enable pour commencer l'écriture. Initialise les compteurs et registres
					when READY_STATE =>
						
						--RAZ des registres et compteurs
						do_set_ddram_addr <= false;
						
						start_timer <= false;
						i <= 16;
						done <= false;
						
						if (enable) then
						  fsm_state <= SET_CURSOR_STATE;
						end if;
					
					-- Permet de placer le curseur à droite de la première ligne
					when SET_CURSOR_STATE =>
						
						lcd <= sda_lcd;
						do_set_ddram_addr <= true;
						if (set_ddram_addr_done) then
							do_set_ddram_addr <= false;
							fsm_state <= SET_CURSOR_WAIT_STATE;
						end if;
					
					
					-- Délai de 40 us avant pour terminer la configuration du curseur
					when SET_CURSOR_WAIT_STATE =>

						
						timer_ns <= 4000;
						start_timer <= true;
						
						--Delai 40ms
						if timer_done then
							fsm_state <= WRITE_CHAR_STATE;
							start_timer <= false;
						end if;


					-- Permet d'écrire le caractère à l'index i sur l'écran
					when WRITE_CHAR_STATE =>
						
						character_string <=  std_logic_vector(to_unsigned(character'pos(line_1(i)),8)); -- std_logic_vector(to_unsigned(natural(character'pos(line_1(i))), 8)); --Conversion d'un caractère de la string pointée par l'index i en vecteur
	
						do_write_data_to_ram <= true;
						lcd <= wr_lcd;
						
						if (write_data_to_ram_done) then
							do_write_data_to_ram <= false;
							i <= i - 1; -- Pointe sur le prochain caratère à gauche du précédent
							fsm_state <= WRITE_CHAR_WAIT_STATE;
						end if;
						
						
					
					-- Délai de 40 us pour terminer l'écriture
					when WRITE_CHAR_WAIT_STATE =>
												
						
						timer_ns <= 4000;
						start_timer <= true;
						--Delai 40ms
						if timer_done then
							start_timer <= false;
							-- Si toute la ligne a été écrite, nous terminons le module
							-- Sinon, nous écrivons le prochain caractère
							if (i > 0) then
								fsm_state <= WRITE_CHAR_STATE;
							else
								fsm_state <= DONE_STATE;
							end if;
						end if;
						
					-- L'écriture est terminée, le signal Enable doit retourner à zéro pour recommencer
					when DONE_STATE =>
						done <= true;
						
						if (not enable) then
							done <= false;
							fsm_state <= READY_STATE;
						end if;
					
					-- S'il y a une erreur, nous recommencons l'écriture
					when others =>
						fsm_state <= READY_STATE;

				end case;
			end if;
		end if;
	end process;
end Write_First_line;

