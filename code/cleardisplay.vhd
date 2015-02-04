-- Company: ETS - ELE740
-- Programmer: Olivier Diotte & Marc-André Séguin
-- 
-- Create Date:    11:13:42 01/20/2015 
-- Module Name:    cleardisplay.vhd
-- Project Name:   Afficheur LCD
-- Target Devices: Virtex 5 LX50T
--
-- Description:    Fonction clear display display on/off permettant de générer le vecteur instruction pour effacer l'écran
--
-- Dependencies:   Module Write
--
-- Revision: 0.01
-- Additional Comments: 
--
----------------------------------------------------------------------------------
use work.defs.all;

library IEEE;
use IEEE.std_logic_1164.all;

use IEEE.numeric_std.all;

entity Clear_Display is
	port(
			rs:		out	std_logic; -- signal instruction/data envoyé au module write
			instr:	out	std_logic_vector(7 downto 0) -- signal vecteur d'instruction envoyé au module write
			);
end Clear_Display;


architecture Clear_Display of Clear_Display is

begin

	rs <= '0'; -- Instruction
	instr <= x"01"; --Composition du vecteur instruction en fonction des paramètres

end Clear_Display;


