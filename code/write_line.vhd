----------------------------------------------------------------------------------
-- Company: ETS - ELE740
-- Programmer: Olivier Diotte & Marc-Andr� S�guin
-- 
-- Create Date:    11:13:42 01/20/2015 
-- Module Name:    Write_First_Line
-- Project Name:   Afficheur LCD
-- Target Devices: Virtex 5 LX50T
--
-- Description:    Module permettant d'�crire la premi�re ligne de l'afficheur sans animation
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
		enable: in    boolean;   -- Signal permettant de d�marrer la s�quence d'�criture (Doit �tre mis � 0 avant la prochaie �criture)
		done  : out   boolean;   -- Signal indiquant que la s�quence d'�criture est termin�e
		line_1: in    string ( 1 to 16 ); --Signal contenant le text � �crire
		rs_wr : out   std_logic; -- Signal instruction/data envoy� au module write
		instr_wr : out   std_logic_vector( 7 downto 0); --Vecteur d'instruction envoy� au module write
		enable_wr: out std_logic; --Signal permettant de d�marrer le module write
		done_wr: in   boolean	 -- Signal venant du module write impliquant que la communication est termin�e
		);
end Write_First_line;


architecture Write_First_line of Write_First_line is
	
	type STATE_TYPE is (
		READY_STATE,        		-- Attends apr�s le signal Enable pour commencer l'�criture. Initialise les compteurs et registres
		SET_CURSOR_STATE,			-- Permet de placer le curseur � droite de la premi�re ligne
		SET_CURSOR_WAIT_STATE,		-- D�lai de 40 us pour terminer la transmission de SET_CURSOR
		WRITE_CHAR_STATE,			-- Permet d'�crire le caract�re � l'index i sur l'�cran
		WRITE_CHAR_WAIT_STATE,		-- D�lai de 40 us pour terminer la transmission de Write Char
		DONE_STATE					-- L'�criture est termin�e, le signal Enable doit retourner � z�ro pour recommencer
		);

	-- FIXME: Replace this by the legal equivalent of x"50" (6 downto 0)
	constant FIRST_LINE_ADDR: std_logic_vector(7 downto 0) := 0x0F;
	
	signal fsm_state   : STATE_TYPE := READY_STATE; -- Signal contenant les �tats

	-- Signaux instruction/data et instruction venant des modules de commandes 
	signal rs_set_cursor: std_logic;
	signal instr_set_cursor: std_logic_vector(7 downto 0);
	
	signal rs_wr_char: std_logic;
	signal instr_wr_char: std_logic_vector(7 downto 0);
	
	signal i: integer range 0 to 16 := 16; -- Index pointant dans le string
	
	
begin

	--D�finis les vecteurs instructions pour le module Write First Line
	COMP_SET_CURSOR: Set_Ddram_Address port map (FIRST_LINE_ADDR (6 downto 0),rs_set_cursor, instr_set_cursor); -- G�n�re l'instruction pour placer le curseur � la 1ere ligne � droite
	COMP_WR_CHAR: Write_Data_To_Ram port map (CONV_STD_LOGIC_VECTOR(character'pos(line_1(i)) ,8) ,rs_wr_char, instr_wr_char); -- G�n�re l'instruction pour �crire le charact�re � l'index i de line_1

	
	process(clk)
		variable timer_counter : integer range 0 to 100000000 := 0; --Compteur d'horloge pour minuter les �tats 100Mhz (10 ns)
		
	begin

		if rising_edge(clk) then

			case fsm_state is

				-- Attends apr�s le signal Enable pour commencer l'�criture. Initialise les compteurs et registres
				when READY_STATE =>
					
					--RAZ des registres et compteurs
					enable_wr := 0;
					timer_counter := 0;
					i := 16;
					done <= false;
					
					if (enable) then
					  fsm_state <= SET_CURSOR_STATE;
					end if;
				
				-- Permet de placer le curseur � droite de la premi�re ligne
				when SET_CURSOR_STATE =>
					
					enable_wr := 1;
					instr_wr <= instr_set_cursor;
					rs_wr <= rs_set_cursor;
					
					if (done_wr) then
						enable_wr := 0;
						fsm_state <= SET_CURSOR_WAIT_STATE;
					end if;
				
				
				-- D�lai de 40 us avant pour terminer la configuration du curseur
				when RSET_CURSOR_WAIT_STATE =>

					timer_counter := timer_counter + 1;

					--Delai 40ms
					if timer_counter > 4000 then
						fsm_state <= FUNCTION_SET_STATE;
						timer_counter := 0;
					end if;


				-- Permet d'�crire le caract�re � l'index i sur l'�cran
				when WRITE_CHAR_STATE =>
					
					enable_wr := 1;
					instr_wr <= instr_wr_char;
					rs_wr <= rs_wr_char;
					
					if (done_wr) then
						enable_wr := 0;
						i <= i - 1; -- Pointe sur le prochain carat�re � gauche du pr�c�dent
						fsm_state <= WRITE_CHAR_WAIT_STATE;
					end if;
					
					
				
				-- D�lai de 40 us pour terminer l'�criture
				when WRITE_CHAR_WAIT_STATE =>
					
					timer_counter := timer_counter + 1;
					
					
					if (timer_counter > 4000) then
						timer_counter := 0;
						
						-- Si toute la ligne a �t� �crite, nous terminons le module
						-- Sinon, nous �crivons le prochain caract�re
						if (i > 0) then
							fsm_state <= WRITE_CHAR_STATE;
						else
							fsm_state <= DONE_STATE;
						end if;
						
					end if;
							
				-- L'�criture est termin�e, le signal Enable doit retourner � z�ro pour recommencer
				when DONE_STATE =>
					done <= true;
					
					if (/enable) then
						done <= false;
						fsm_state <= READY_STATE;
					end if;
				
				-- S'il y a une erreur, nous recommencons l'�criture
				when others =>
					fsm_state <= READY_STATE;

			end case;
		end if;
	end process;
end Write_First_line;

