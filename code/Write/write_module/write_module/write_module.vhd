----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:15:18 01/27/2015 
-- Design Name: 
-- Module Name:    write_module - Behavioral 
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
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;



entity write_module is
	port( 
			clk :	in	STD_LOGIC; --Signal de l'horloge cadencé à 100Mhz
			
			-- Signaux permettant de contrôler l'état du module
			send   : in  STD_LOGIC; -- Démarre la séquence d'envoie sur un front montant
			ins_in : in  STD_LOGIC_VECTOR(8 downto 0); -- Instruction ou donnée à envoyer(7 downto 0) + bit RS(8)
			done_write   : out STD_LOGIC; -- Niveau haut lorsque le module a terminé l'envoie
			
			-- Signaux qui seront liés au LCD
			LCD_rs_out_w : out STD_LOGIC; -- Signal permettant de choisir entre DATA/INSTRUCTION
			LCD_enable_w : out STD_LOGIC; -- Signal permettant de valider la commande 
			LCD_rw_out_w : out STD_LOGIC; -- Signal permettant de sélectionner le mode write ou read
			LCDD_out_w   : out STD_LOGIC_VECTOR(7 downto 0) -- Bus d'instruction vers le LDC
			);
end write_module;


architecture Behavioral of write_module is

	TYPE STATE_TYPE IS (READY, 
							  INIT, 
							  ENABLE, 
							  HOLD, 
							  DONE);
							  
   SIGNAL w_state   : STATE_TYPE := READY;
	SIGNAL counter : integer range 0 to 255 := 0; --Compteur d'horloge pour minuter les états 100Mhz (T=10 ns)
begin
	process(clk)
	begin
		
		if rising_edge(clk) then
		
			case w_state is
				
				when READY =>
					done_write <= '0';
					
					if send = '1' then
						w_state <=  INIT;
					end if;
			
				when INIT =>
					
					-- Prépare les signaux qui seront envoyés au LCD
					LCDD_out_w <= ins_in(7 downto 0);
					LCD_rs_out_w <= ins_in(8); 
					LCD_enable_w <= '0';
					LCD_rw_out_w <= '0'; --Mode write
					
					counter <=  0;
					
					w_state <=  ENABLE;
					
					
				when ENABLE =>
					
					LCD_enable_w <= '1'; 
					
					--Delai d'activation enable 80 ns
					if counter >= 7 then
						w_state <= HOLD;
						counter <= 0;
					else
						counter <= counter + 1;
					end if;
								
				when HOLD =>
					
					LCD_enable_w <= '0'; 
					
					--Delai avant le prochain write 1200 ns
					if counter >= 119 then
						w_state <= DONE;
						counter <= 0;
					else
						counter <= counter + 1;
					end if;
					
					
				when DONE =>
					
					done_write <= '1';
										
					if send = '0' then
						w_state <=  READY;
					end if;
				
				when others =>
					
					w_state <=  READY;
			
			end case;
		end if;
	end process;
	
end Behavioral;


