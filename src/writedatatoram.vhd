----------------------------------------------------------------------------------
-- Company: ETS - ELE740
-- Programmer: Olivier Diotte & Marc-Andre Seguin
--
-- Create Date:
-- Module Name:    writedatatoram.vhd
-- Project Name:   Afficheur LCD
-- Target Devices: Virtex 5 LX50T
--
-- Description:    Fonction du LCD permettant de generer l'instruction d'ecriture d'un caractere
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
			clk : in std_logic;
			enable : in boolean;
			done : out boolean;
			data : in std_logic_vector(7 downto 0);
			lcd : out lcd_type
			);
end Write_Data_To_Ram;


architecture Write_Data_To_Ram of Write_Data_To_Ram is
begin
	COMP_WRITE : write_module port map (
			clk,
			enable,
			done,
			'1',
			data,
			lcd
			);
end Write_Data_To_Ram;
