use work.defs.all;

library IEEE;
use IEEE.std_logic_1164.all;
use std.textio.all;
use IEEE.numeric_std.all;

entity write_tb is
end write_tb;

architecture behav of write_tb is
	signal clock : std_logic;
	signal enable: boolean := false;
	signal rs    : std_logic;
	signal instr : std_logic_vector(7 downto 0);
	signal done  : boolean;
	signal lcd   : lcd_type;

	-- These are set to track lcd, used only because GHDL doesn't support records well
	signal lcd_data: std_logic_vector(LCDD_LEN - 1 downto 0);
	signal lcd_en  : std_logic;
	signal lcd_rs  : std_logic;
	signal lcd_rw  : std_logic;

	signal runsim: boolean := true;

begin
	comp_test: write_module port map (clock, enable, done, rs, instr, lcd);
	lcd_data <= lcd.data;
	lcd_en <= lcd.en;
	lcd_rs <= lcd.rs;
	lcd_rw <= lcd.rw;

	process
	begin
		if (not runsim) then
			wait;
		else
			clock <= '0';
			wait for CLK_PERIOD / 2;
			clock <= '1';
			wait for CLK_PERIOD / 2;
		end if;
	end process;

	process
		type pattern_type is record
			enable: boolean;
			rs    : std_logic;
			instr : std_logic_vector(7 downto 0);
			done  : std_logic;
			lcd: lcd_type;
			wait_delay: time;
		end record;

		type pattern_array is array (natural range <>) of pattern_type;
		constant patterns : pattern_array :=
				((false, 'U', "UUUUUUUU", 'U', ('U', 'U', 'U', "UUUUUUUU"), 0 fs),    -- unknown initial state
				 (true,  '0', x"01",      '0', ('U', 'U', 'U', "UUUUUUUU"), 0 fs),    -- 'ready' state
				 (true,  '0', x"01",      '0', ('U', 'U', 'U', "UUUUUUUU"), 0 fs),    -- 'init' state
				 (false, '0', x"01",      '0', ('0', '0', '0', x"01"     ), 0 fs),    -- 'signal settle' state
				 (false, '0', x"01",      '0', ('0', '0', '1', x"01"     ), 80 ns),   -- 'enable' state
				 (false, '0', x"01",      '0', ('0', '0', '0', x"01"     ), 1200 ns), -- 'hold' state
				 (false, '0', x"01",      '1', ('0', '0', '0', x"01"     ), 0 fs));   -- 'done' state

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
			assert lcd.rs = patterns(i).lcd.rs
				report "lcd.rs: " & std_logic'image(lcd.rs) & " /= " & std_logic'image(patterns(i).lcd.rs) severity error;
			assert lcd.en = patterns(i).lcd.en
				report "lcd.en: " & std_logic'image(lcd.en) & " /= " & std_logic'image(patterns(i).lcd.en) severity error;
			assert lcd.rw = patterns(i).lcd.rw
				report "lcd.rw: " & std_logic'image(lcd.rw) & " /= " & std_logic'image(patterns(i).lcd.rw) severity error;
			assert lcd.data = patterns(i).lcd.data
				report "lcd.data: wrong value" severity error;

			if (patterns(i).wait_delay /= 0 fs) then
				wait for patterns(i).wait_delay;
			end if;

		end loop;

		runsim <= false;
		wait;
	end process;
end behav;
