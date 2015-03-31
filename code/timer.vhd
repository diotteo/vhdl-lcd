----------------------------------------------------------------------------------
-- Company: ETS - ELE740
-- Programmer: Olivier Diotte & Marc-Andre Seguin
-- 
-- Create Date:    11:13:42 01/20/2015 
-- Module Name:    Timer
-- Project Name:   Afficheur LCD
-- Target Devices: Virtex 5 LX50T
--
-- Description:    Module permettant de minuter certain nombre de coups d'horloge
--
-- Dependencies:   Write Module
--
-- Revision: 0.01
-- Additional Comments: 
--
----------------------------------------------------------------------------------

use work.defs.all;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.numeric_std.all;


entity Timer is
	port(
		clk : in std_logic; --Horloge du compteur
		rst : in std_logic; --Signal synchrone pour remettre a zero le compteur
		start_timer: in boolean; --Signal permettant de demarrer le compteur. Doit être remis a 0 pour commencer a compter de nouveau
		clk_count: in integer; -- Nombre de coup d'horloge a compter
		timer_done : out boolean -- Signal avertissant la fin du compte
		);
end Timer;


architecture Timer of Timer is
begin

	process(clk)
		variable timer_counter : natural := 0; --Compteur d'horloge pour minuter les etats 100Mhz (10 ns)
	begin

		if rising_edge(clk) then

			-- Si une remise a zero est necessaire
			if( rst = '1' or start_timer = false) then

				timer_counter := 0;
				timer_done <= false;
			-- Sinon, nous comptons jusqu'a ce que le maximum soit atteint
			else

				if timer_counter < clk_count then
					timer_counter := timer_counter + 1;
				else
					timer_done <= true; --Le compte est termine
				end if;

			end if;

		end if;
	end process;
end Timer;
