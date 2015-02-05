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
			clk    : in    std_logic;
			enable : in    boolean;
			done   : out   boolean;
			data_len: in   std_logic;
			nlines : in    std_logic;
			font   : in    std_logic;
			lcd    : out lcd_type
			);
end Function_Set;


architecture Function_Set of Function_Set is
	signal instr: std_logic_vector(7 downto 0);
begin
	instr <= x"20" or ("000" & data_len & nlines & font & "00");

	COMP_WRITE: write_module port map (
			clk,
			enable,
			done,
			'0',
			instr,
			lcd
			);
end Function_Set;
