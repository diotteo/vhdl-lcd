----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:
-- Design Name:
-- Module Name:
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
use IEEE.std_logic_1164.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.numeric_std.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;



entity ENTITY_NAME_HERE is
	port(
			clk : in    std_logic;
			);
end ENTITY_NAME_HERE;


architecture ARCH_NAME_HERE of ENTITY_NAME_HERE is
	type state_t is (
			READY,
			INIT,
			DONE
			);

	signal fsm_state : state_t := READY;
begin
	process(clk)
	begin
	end process;

end ARCH_NAME_HERE;


