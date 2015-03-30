-- Company: ETS - ELE740
-- Programmer: Olivier Diotte & Marc-Andre Seguin
--
-- Create Date:    2015/01/29
-- Module Name:    cleardisplay.vhd
-- Project Name:   Afficheur LCD
-- Target Devices: Virtex 5 LX50T
--
-- Description:    Fonction clear display display on/off permettant de generer le vecteur instruction pour effacer l'ecran
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
			clk    : in    std_logic;
			enable : in    boolean;
			done   : out   boolean;
			lcd    : out   lcd_type
			);
end Clear_Display;


architecture Clear_Display of Clear_Display is

begin
	COMP_WRITE: write_module port map (
			clk,
			enable,
			done,
			'0',
			x"01",
			lcd
			);
end Clear_Display;


