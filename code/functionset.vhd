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

entity Function_Set is
	port(
			clk    : in    std_logic;
			enable : in    boolean;
			done   : out   boolean;
			data_len: in   std_logic;
			nlines : in    std_logic;
			font   : in    std_logic;
			lcd    : out   std_logic_vector(LCD_LEN - 1 downto 0)
			);
end Function_Set;


architecture Function_Set of Function_Set is
	signal instr: std_logic_vector(7 downto 0);
begin
	instr <= x"20" or ("0000" & data_len & nlines & font & "00");

	COMP_WRITE: write_module port map (
			clk,
			enable,
			done,
			'0',
			instr,
			lcd(LCD_RS_IDX),
			lcd(LCD_RW_IDX),
			lcd(LCD_EN_IDX),
			lcd(LCDD_MAX_IDX downto LCDD_MIN_IDX)
			);
end Function_Set;
