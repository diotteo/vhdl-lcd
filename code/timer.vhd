----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:13:42 01/20/2015 
-- Design Name: 
-- Module Name:    afficheur - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------

use work.defs.all;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.numeric_std.all;


entity Timer is
	port(
		clk   : in    std_logic; --Horloge du compteur 
		rst	  : in	  std_logic; --Signal synchrone pour remettre à zéro le compteur
		start_timer: in    boolean; --Signal permettant de démarrer le compteur. Doit être remis à 0 pour commencer à compter de nouveau
		clk_count: in integer; -- Nombre de coup d'horloge à compter
		timer_done  : out   boolean -- Signal avertissant la fin du compte
		);
end Timer;


architecture Timer of Timer is
begin

	process(clk)
		variable timer_counter : integer range 0 to 1000000000 := 0; --Compteur d'horloge pour minuter les états 100Mhz (10 ns)
	begin

		if rising_edge(clk) then
			
			-- Si une remise à zéro est nécessaire
			if( rst = '1' or start_timer = false) then
			
				timer_counter := 0;
				timer_done <= false;
			-- Sinon, nous comptons jusqu'à ce que le maximum soit atteint	
			else
				
				if timer_counter < clk_count then 
					timer_counter := timer_counter + 1;
				else
					timer_done <= true; --Le compte est terminé
				end if;
				
			end if;
			
		end if;
	end process;
end Timer;

