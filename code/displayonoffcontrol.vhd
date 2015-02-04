-- Company: ETS - ELE740
-- Programmer: Olivier Diotte & Marc-André Séguin
--
-- Create Date:
-- Module Name:    displayonoffcontrol.vhd
-- Project Name:   Afficheur LCD
-- Target Devices: Virtex 5 LX50T
--
-- Description:    Fonction display on/off permettant de générer le vecteur instruction associé à la fonction
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
		disp_on     : in    std_logic; -- Paramètre 1: Écran allumé, 0: écran éteint
		cur_on      : in    std_logic; -- Paramètre 1: Curseur allumé, 0: curseur éteint
		cur_blink_on: in    std_logic; -- Paramètre 1: Curseur clignotant, 0: curseur fix
		rs:		out	std_logic;		   -- signal instruction/data envoyé au module write
		instr:	out	std_logic_vector(7 downto 0) -- signal vecteur d'instruction envoyé au module write
		);
end entity;

architecture Display_On_Off_Control of Display_On_Off_Control is
begin

	instr <= x"08" or ("00000" & disp_on & cur_on & cur_blink_on); --Composition du vecteur instruction en fonction des paramètres
	rs <= '0'; -- Instruction
	
end Display_On_Off_Control;
