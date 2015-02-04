----------------------------------------------------------------------------------
-- Company: ETS - ELE740
-- Programmer: Olivier Diotte & Marc-André Séguin
-- 
-- Create Date:    11:13:42 01/20/2015 
-- Module Name:    Write_First_Line
-- Project Name:   Afficheur LCD
-- Target Devices: Virtex 5 LX50T
--
-- Description:    Module permettant d'écrire la première ligne de l'afficheur sans animation
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
use ieee.std_logic_arith.all;

entity Write_First_line is
	port(
		clk   : in    std_logic; -- Horloge venant du main (100 Mhz)
		enable: in    boolean;   -- Signal permettant de démarrer la séquence d'écriture (Doit être mis à 0 avant la prochaie écriture)
		done  : out   boolean;   -- Signal indiquant que la séquence d'écriture est terminée
		line_1: in    string ( 1 to 16 ); --Signal contenant le text à écrire
		rs_wr : out   std_logic; -- Signal instruction/data envoyé au module write
		instr_wr : out   std_logic_vector( 7 downto 0); --Vecteur d'instruction envoyé au module write
		enable_wr: out std_logic; --Signal permettant de démarrer le module write
		done_wr: in   boolean	 -- Signal venant du module write impliquant que la communication est terminée
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

	-- FIXME: Replace this by the legal equivalent of x"50" (6 downto 0)
	constant FIRST_LINE_ADDR: std_logic_vector(7 downto 0) := 0x0F;
	
	signal fsm_state   : STATE_TYPE := READY_STATE; -- Signal contenant les états

	-- Signaux instruction/data et instruction venant des modules de commandes 
	signal rs_set_cursor: std_logic;
	signal instr_set_cursor: std_logic_vector(7 downto 0);
	
	signal rs_wr_char: std_logic;
	signal instr_wr_char: std_logic_vector(7 downto 0);
	
	signal i: integer range 0 to 16 := 16; -- Index pointant dans le string
	
	
begin

	--Définis les vecteurs instructions pour le module Write First Line
	COMP_SET_CURSOR: Set_Ddram_Address port map (FIRST_LINE_ADDR (6 downto 0),rs_set_cursor, instr_set_cursor); -- Génère l'instruction pour placer le curseur à la 1ere ligne à droite
	COMP_WR_CHAR: Write_Data_To_Ram port map (CONV_STD_LOGIC_VECTOR(character'pos(line_1(i)) ,8) ,rs_wr_char, instr_wr_char); -- Génère l'instruction pour écrire le charactère à l'index i de line_1

	
	process(clk)
		variable timer_counter : integer range 0 to 100000000 := 0; --Compteur d'horloge pour minuter les états 100Mhz (10 ns)
		
	begin

		if rising_edge(clk) then

			case fsm_state is

				-- Attends après le signal Enable pour commencer l'écriture. Initialise les compteurs et registres
				when READY_STATE =>
					
					--RAZ des registres et compteurs
					enable_wr := 0;
					timer_counter := 0;
					i := 16;
					done <= false;
					
					if (enable) then
					  fsm_state <= SET_CURSOR_STATE;
					end if;
				
				-- Permet de placer le curseur à droite de la première ligne
				when SET_CURSOR_STATE =>
					
					enable_wr := 1;
					instr_wr <= instr_set_cursor;
					rs_wr <= rs_set_cursor;
					
					if (done_wr) then
						enable_wr := 0;
						fsm_state <= SET_CURSOR_WAIT_STATE;
					end if;
				
				
				-- Délai de 40 us avant pour terminer la configuration du curseur
				when RSET_CURSOR_WAIT_STATE =>

					timer_counter := timer_counter + 1;

					--Delai 40ms
					if timer_counter > 4000 then
						fsm_state <= FUNCTION_SET_STATE;
						timer_counter := 0;
					end if;


				-- Permet d'écrire le caractère à l'index i sur l'écran
				when WRITE_CHAR_STATE =>
					
					enable_wr := 1;
					instr_wr <= instr_wr_char;
					rs_wr <= rs_wr_char;
					
					if (done_wr) then
						enable_wr := 0;
						i <= i - 1; -- Pointe sur le prochain caratère à gauche du précédent
						fsm_state <= WRITE_CHAR_WAIT_STATE;
					end if;
					
					
				
				-- Délai de 40 us pour terminer l'écriture
				when WRITE_CHAR_WAIT_STATE =>
					
					timer_counter := timer_counter + 1;
					
					
					if (timer_counter > 4000) then
						timer_counter := 0;
						
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
					
					if (/enable) then
						done <= false;
						fsm_state <= READY_STATE;
					end if;
				
				-- S'il y a une erreur, nous recommencons l'écriture
				when others =>
					fsm_state <= READY_STATE;

			end case;
		end if;
	end process;
end Write_First_line;

