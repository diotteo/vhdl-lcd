-- Company: ETS - ELE740
-- Programmer: Olivier Diotte & Marc-André Séguin
--
-- Create Date:    2015/01/29
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
			clk    : in    std_logic;
			enable : in    boolean;
			done   : out   boolean;
			lcd    : out   std_logic_vector(LCD_LEN - 1 downto 0)
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
			lcd(LCD_RS_IDX),
			lcd(LCD_RW_IDX),
			lcd(LCD_EN_IDX),
			lcd(LCDD_MAX_IDX downto LCDD_MIN_IDX)
			);
end Clear_Display;


