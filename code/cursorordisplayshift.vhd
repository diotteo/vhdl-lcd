----------------------------------------------------------------------------------
-- Company: ETS - ELE740
-- Programmer: Olivier Diotte & Marc-André Séguin
--
-- Create Date:
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


entity Cursor_Or_Display_Shift is
	port(
			clk    : in    std_logic;
			enable : in    boolean;
			done   : out   boolean;
			sh_d_c : in    std_logic; -- shift entire display, !cursor
			sh_r_l : in    std_logic; -- shift right, !left
			lcd    : out   lcd_type
			);
end Cursor_Or_Display_Shift;


architecture Cursor_Or_Display_Shift of Cursor_Or_Display_Shift is
	signal instr: std_logic_vector(7 downto 0);
begin
	instr <= (x"10" or (sh_d_c & sh_r_l & "00"));

	COMP_WRITE: write_module port map (
			clk,
			enable,
			done,
			'0',
			instr,
			lcd,
			);
end Cursor_Or_Display_Shift;
