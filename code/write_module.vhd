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
use work.defs.all;

library IEEE;
use IEEE.std_logic_1164.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.numeric_std.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;



entity write_module is
	port(
			clk : in    std_logic; --Signal de l'horloge cadencé à 100Mhz

			-- Signaux permettant de contrôler l'état du module
			enable: in  boolean; -- Démarre la séquence d'envoie sur un front montant
			done  : out boolean; -- Niveau haut lorsque le module a terminé l'envoie
			rs    : in  std_logic;
			instr : in  std_logic_vector(7 downto 0); -- Instruction ou donnée à envoyer(7 downto 0)

			-- Signaux qui seront liés au LCD
			lcd : out lcd_type
			);
end write_module;


architecture Behavioral of write_module is

	TYPE STATE_TYPE IS (
			READY_STATE,
			INIT_STATE,
			SIGNAL_SETTLE_STATE,
			ENABLE_STATE,
			HOLD_STATE,
			DONE_STATE);

	SIGNAL w_state : STATE_TYPE := READY_STATE;
	SIGNAL counter : integer range 0 to 255 := 0; --Compteur d'horloge pour minuter les états 100Mhz (T=10 ns)
begin
	process(clk)
	begin

		if rising_edge(clk) then

			case w_state is

				when READY_STATE =>
					done <= false;

					if (enable) then
						w_state <= INIT_STATE;
					end if;

				when INIT_STATE =>

					-- Prépare les signaux qui seront envoyés au LCD
					lcd.rs <= rs;
					lcd.rw <= '0'; --Mode write
					lcd.en <= '0';
					lcd.data <= instr;

					counter <= 0;

					w_state <= SIGNAL_SETTLE_STATE;

				when SIGNAL_SETTLE_STATE =>
					lcd.en <= '1';
					w_state <= ENABLE_STATE;

				when ENABLE_STATE =>

					lcd.en <= '1';

					--Delai d'activation enable 80 ns
					if counter >= 7 then
						w_state <= HOLD_STATE;
						counter <= 0;
					else
						counter <= counter + 1;
					end if;

				when HOLD_STATE =>

					lcd.en <= '0';

					--Delai avant le prochain write 1200 ns
					if counter >= 119 then
						w_state <= DONE_STATE;
						counter <= 0;
					else
						counter <= counter + 1;
					end if;


				when DONE_STATE =>

					done <= true;

					if (enable) then
						w_state <= READY_STATE;
					end if;

				when others =>

					w_state <= READY_STATE;

			end case;
		end if;
	end process;
end Behavioral;
