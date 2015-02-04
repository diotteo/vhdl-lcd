----------------------------------------------------------------------------------
-- Company: ETS - ELE740
-- Programmer: Olivier Diotte & Marc-André Séguin
-- 
-- Create Date:    11:13:42 01/20/2015 
-- Module Name:    cursorordisplayshift.vhd
-- Project Name:   Afficheur LCD
-- Target Devices: Virtex 5 LX50T
--
-- Description:    Fonction du LCD permettant de décaler le curseur ou l'écran
--
-- Dependencies:   Write Module
--
-- Revision: 0.01
-- Additional Comments: 
--
----------------------------------------------------------------------------------
use work.defs.all;

library IEEE;
use IEEE.std_logic_1164.all;

use IEEE.numeric_std.all;

use work.defs.all;


entity  Cursor_Or_Display_Shift is
	port(
			sh_d_c : in    std_logic; -- paramètre shift entire display, !cursor
			sh_r_l : in    std_logic; -- paramètre shift right, !left
			rs:		out	std_logic;	  -- signal instruction/data envoyé au module write
			instr:	out	std_logic_vector(7 downto 0) -- signal vecteur d'instruction envoyé au module write
			);
end entity ;


architecture Cursor_Or_Display_Shift of Cursor_Or_Display_Shift is
begin
	
	instr <= (x"10" or (sh_d_c & sh_r_l & "00")); --Composition du vecteur instruction en fonction des paramètres
	rs <= '0'; -- Instruction
	
end Cursor_Or_Display_Shift;
