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



entity Return_Home is
	port(
			clk    : in    std_logic;
			enable : in    boolean;
			done   : out   boolean;
			lcd    : out   std_logic_vector(LCD_LEN - 1 downto 0)
			);
end Return_Home;


architecture Return_Home of Return_Home is
	component write_module
		port (
			clk : in std_logic;
			enable: in boolean;
			done  : out boolean;
			rs    : in boolean;
			instr : in std_logic_vector(7 downto 0);
			lcd_rs: out std_logic;
			lcd_rw: out std_logic;
			lcd_en: out std_logic;
			lcd_data : out std_logic_vector(7 downto 0)
		);
	end component;

begin
	COMP_WRITE: write_module port map (
			clk,
			enable,
			done,
			'0',
			x"02",
			lcd(10),--LCD_rs
			lcd(9), --LCD_rw
			lcd(8), --LCD_enable
			lcd(7 downto 0) --LCDD
			);
end Return_Home;


