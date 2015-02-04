----------------------------------------------------------------------------------
-- Company: ETS - ELE740
-- Programmer: Olivier Diotte & Marc-André Séguin
-- 
-- Create Date:    11:13:42 01/20/2015 
-- Module Name:    entrymodeset.vhd
-- Project Name:   Afficheur LCD
-- Target Devices: Virtex 5 LX50T
--
-- Description:    Fonction du LCD permettant de définir le sens d'écriture et de décalage
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

entity Entry_Mode_Set is
	port(
			i_d    : in std_logic; 	-- Paramètre 1: Écriture vers la droite, 0: écriture vers la gauche
			sh     : in std_logic;	-- Paramètre 1: Décalage de l'écran vers la droite, 0: vers la gauche
			rs:		out	std_logic;	-- signal instruction/data envoyé au module write
			instr:	out	std_logic_vector(7 downto 0) -- signal vecteur d'instruction envoyé au module write
			);
end Entry_Mode_Set;


architecture Entry_Mode_Set of Entry_Mode_Set is

begin
	instr <= x"04" or ("000000" & i_d & sh);  --Composition du vecteur instruction en fonction des paramètres
	rs <= '0'; --Instruction

end Entry_Mode_Set;


