----------------------------------------------------------------------------------
-- Company: ETS - ELE740
-- Programmer: Olivier Diotte & Marc-André Séguin
--
-- Create Date:
-- Module Name:    functionset.vhd
-- Project Name:   Afficheur LCD
-- Target Devices: Virtex 5 LX50T
--
-- Description:    Fonction du LCD permettant de configurer le nombre de ligne du LCD, la taille du caractère et taille du bus data
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

entity Function_Set is
	port(
			data_len: in   std_logic; -- parametre 1: 8bits, 0: 4bits
			nlines : in    std_logic; -- parametre 1: 2 lignes, 0: 4 lignes
			font   : in    std_logic; -- parametre 0:5*8 dots
			rs:		out	std_logic;	-- signal instruction/data envoyé au module write
			instr:	out	std_logic_vector(7 downto 0) -- signal vecteur d'instruction envoyé au module write
			);
end Function_Set;


architecture Function_Set of Function_Set is
begin

	instr <= x"20" or ("000" & data_len & nlines & font & "00");--Composition du vecteur instruction en fonction des paramètres
	rs <= '0'; --Instruction

end Function_Set;
