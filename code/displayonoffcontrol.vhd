-- Company: ETS - ELE740
-- Programmer: Olivier Diotte & Marc-Andre Seguin
--
-- Create Date:
-- Module Name:    displayonoffcontrol.vhd
-- Project Name:   Afficheur LCD
-- Target Devices: Virtex 5 LX50T
--
-- Description:    Fonction display on/off permettant de generer le vecteur instruction associe a la fonction
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


entity Display_On_Off_Control is
	port(
			clk         : in    std_logic;
			enable      : in    boolean;
			done        : out   boolean;
			disp_on     : in    std_logic;
			cur_on      : in    std_logic;
			cur_blink_on: in    std_logic;
			lcd         : out   lcd_type
			);
end Display_On_Off_Control;


architecture Display_On_Off_Control of Display_On_Off_Control is
	signal instr: std_logic_vector(7 downto 0);
begin
	instr <= x"08" or ("00000" & disp_on & cur_on & cur_blink_on);

	COMP_WRITE: write_module port map (
			clk,
			enable,
			done,
			'0',
			instr,
			lcd
			);
end Display_On_Off_Control;
