----------------------------------------------------------------------------------
-- Company: ETS - ELE740
-- Programmer: Olivier Diotte & Marc-André Séguin
-- 
-- Create Date:    11:13:42 01/20/2015 
-- Module Name:    writedatatoram.vhd
-- Project Name:   Afficheur LCD
-- Target Devices: Virtex 5 LX50T
--
-- Description:    Fonction du LCD permettant de générer l'instruction d'écriture d'un caractère
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



entity Write_Data_To_Ram is
	port(
			data   : in    std_logic_vector(7 downto 0); -- Caractère ascii à écrire
			rs:		out	std_logic;	  -- signal instruction/data envoyé au module write
			instr:	out	std_logic_vector(7 downto 0) -- signal vecteur d'instruction envoyé au module write
			);
end Write_Data_To_Ram;


architecture Write_Data_To_Ram of Write_Data_To_Ram is
begin
	
	instr <= data; --Composition du vecteur instruction en fonction des paramètres
	rs <= '1'; -- Instruction
	
end Write_Data_To_Ram;
