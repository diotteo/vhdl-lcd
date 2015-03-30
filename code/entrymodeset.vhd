----------------------------------------------------------------------------------
-- Company: ETS - ELE740
-- Programmer: Olivier Diotte & Marc-Andre Seguin
--
-- Create Date:
-- Module Name:    entrymodeset.vhd
-- Project Name:   Afficheur LCD
-- Target Devices: Virtex 5 LX50T
--
-- Description:    Fonction du LCD permettant de definir le sens d'ecriture et de decalage
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
			clk    : in    std_logic;
			enable : in    boolean;
			done   : out   boolean;
			i_d    : in    std_logic;
			sh     : in    std_logic;
			lcd    : out   lcd_type
			);
end Entry_Mode_Set;


architecture Entry_Mode_Set of Entry_Mode_Set is
	signal instr: std_logic_vector(7 downto 0);
begin
	instr <= x"04" or ("000000" & i_d & sh);

	COMP_WRITE: write_module port map (
			clk,
			enable,
			done,
			'0',
			instr,
			lcd
			);
end Entry_Mode_Set;


