use work.defs.all;

library IEEE;
use IEEE.std_logic_1164.all;
use std.textio.all;
use IEEE.numeric_std.all;

entity poi_tb is
end poi_tb;

architecture behav of poi_tb is
	signal clock : std_logic;
	signal enable: boolean := false;
	signal done  : boolean;
	signal lcd   : std_logic_vector(LCD_LEN - 1 downto 0);

	signal runsim: boolean := true;

begin
	comp_test: Power_On_Init port map (clock, enable, done, lcd);

	process
	begin
		if (not runsim) then
			wait;
		else
			clock <= '0';
			wait for 5 ns;
			clock <= '1';
			wait for 5 ns;
		end if;
	end process;

	process
		type pattern_type is record
			enable: boolean;
			done  : std_logic;
			lcd   : std_logic_vector(LCD_LEN - 1 downto 0);
			wait_delay: natural;
		end record;

		type pattern_array is array (natural range <>) of pattern_type;
		constant patterns : pattern_array :=
				(('0', 'U', "UUUU" & "UUUU" & "UUU", 0), -- unknown initial state
				 (), -- 'ready' state
				 (), -- 'init wait' state
				 (), -- 'function set (1/3)' state
				 (), -- 'function set (2/3)' state
				 (), -- 'function set (3/3)' state
				 (), -- 'display on' state
				 (), -- 'display clear' state
				 ()); -- 'entry mode' state

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

			if (patterns(i).wait_delay /= 0) then
				wait for patterns(i).wait_delay * 1 ns;
			end if;

		end loop;

		runsim <= false;
		wait;
	end process;
end behav;
