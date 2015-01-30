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



entity Entry_Mode_Set is
	port(
			clk    : in    std_logic;
			enable : in    std_logic;
			done   : out   std_logic;
			i_d    : in    std_logic;
			sh     : in    std_logic;
			lcd    : out   std_logic_vector(LCD_LEN - 1 downto 0)
			);
end Entry_Mode_Set;


architecture Entry_Mode_Set of Entry_Mode_Set is
	component write_module
		port (
			clk : in std_logic;
			enable : in std_logic;
			rs_and_instr : in std_logic_vector(8 downto 0);
			done : out std_logic;
			lcd_rs : out std_logic;
			lcd_en : out std_logic;
			lcd_rw : out std_logic;
			lcd_data : out std_logic_vector(7 downto 0)
		);
	end component;

	signal instr: std_logic_vector(8 downto 0);
begin
	instr <= '0' & (x"04" or (i_d & sh));

	COMP_WRITE: write_module port map (
			clk,
			enable,
			instr,
			done,
			lcd(9),  --LCD_rs
			lcd(10), --LCD_enable
			lcd(8),  --LCD_rw
			lcd(7 downto 0) --LCDD
			);
end Entry_Mode_Set;


