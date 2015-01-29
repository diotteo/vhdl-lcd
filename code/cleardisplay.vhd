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



entity Clear_Display is
	port(
			clk    : in    std_logic;
			enable : in    std_logic;
			done   : out   std_logic;
			lcd    : out   std_logic_vector(LCD_LEN - 1 downto 0);
			);
end Clear_Display;


architecture Clear_Display of Clear_Display is
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

begin
	COMP_WRITE: write_module port map (clk, enable, 0 & x"01", done, lcd_rs, lcd_en, lcd_rw, lcd_data);
end Clear_Display;


