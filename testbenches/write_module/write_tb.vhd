use work.defs.all;

library IEEE;
use IEEE.std_logic_1164.all;
use std.textio.all;
use IEEE.numeric_std.all;

entity write_tb is
end write_tb;

architecture behav of write_tb is
	signal clock : std_logic := '0';
	signal enable: boolean := false;
	signal rs    : std_logic;
	signal instr : std_logic_vector(7 downto 0);
	signal done : boolean;
	signal lcd_rs: std_logic;
	signal lcd_rw: std_logic;
	signal lcd_en: std_logic;
	signal lcdd  : std_logic_vector(7 downto 0);

begin
	comp_test: write_module port map (clock, enable, done, rs, instr, lcd_rs, lcd_rw, lcd_en, lcdd);

	clock <= not clock after 5 ns; -- 100 MHz clock

	process
		type pattern_type is record
			enable: boolean;
			rs    : std_logic;
			instr : std_logic_vector(7 downto 0);
			done  : std_logic;
			lcd_rs: std_logic;
			lcd_en: std_logic;
			lcd_rw: std_logic;
			lcdd  : std_logic_vector(7 downto 0);
			wait_delay: natural;
		end record;

		type pattern_array is array (natural range <>) of pattern_type;
		constant patterns : pattern_array :=
				((false, 'U', "UUUUUUUU", 'U', 'U', 'U', 'U', "UUUUUUUU", 0), -- unknown initial state
				 (true,  '0', x"01", '0', 'U', 'U', 'U', "UUUUUUUU", 0), -- 'ready' state
				 (true,  '0', x"01", '0', 'U', 'U', 'U', "UUUUUUUU", 0), -- 'init' state
				 (false, '0', x"01", '0', '0', '0', '0', x"01", 0), -- 'signal settle' state
				 (false, '0', x"01", '0', '0', '1', '0', x"01", 80), -- 'enable' state
				 (false, '0', x"01", '0', '0', '0', '0', x"01", 1200), -- 'hold' state
				 (false, '0', x"01", '1', '0', '0', '0', x"01", 0)); -- 'done' state

		variable l: line;
	begin
		for i in patterns'range loop
			write (l, String'("i = " & natural'image(i) & " current time:" & time'IMAGE(now)));
			writeline (output, l);
			if (clock /= '0') then
				wait until clock = '0';
			end if;
			wait until clock = '1';

			enable <= patterns(i).enable;
			rs <= patterns(i).rs;
			instr <= patterns(i).instr;

			wait for 1 ns;

			assert (patterns(i).done = 'U') or ((patterns(i).done = '1') = done)
				report "done: " & boolean'image(done) & " /= " & std_logic'image(patterns(i).done) severity error;
			assert lcd_rs = patterns(i).lcd_rs
				report "lcd_rs: " & std_logic'image(lcd_rs) & " /= " & std_logic'image(patterns(i).lcd_rs) severity error;
			assert lcd_en = patterns(i).lcd_en
				report "lcd_en: " & std_logic'image(lcd_en) & " /= " & std_logic'image(patterns(i).lcd_en) severity error;
			assert lcd_rw = patterns(i).lcd_rw
				report "lcd_rw: " & std_logic'image(lcd_rw) & " /= " & std_logic'image(patterns(i).lcd_rw) severity error;
			assert lcdd = patterns(i).lcdd
				report "lcdd: wrong value" severity error;

			if (patterns(i).wait_delay = 80) then -- 'enable' state
				wait for 80 ns;
			elsif (patterns(i).wait_delay = 1200) then -- 'hold' state
				wait for 1200 ns;
			end if;

		end loop;

		wait for 20 ns;
		assert false report "end of test" severity failure;
		wait;
	end process;
end behav;
