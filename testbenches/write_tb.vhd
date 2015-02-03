library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity write_tb is
end write_tb;

architecture behav of write_tb is
	component write_module
		port(
				clk : in    std_logic;
				send   : in  boolean;
				ins_in : in  std_logic_vector(8 downto 0);
				done_write   : out boolean;
				LCD_rs_out_w : out std_logic;
				LCD_enable_w : out std_logic;
				LCD_rw_out_w : out std_logic;
				LCDD_out_w   : out std_logic_vector(7 downto 0)
				);
	end component;

	signal clock : std_logic := '0';
	signal enable: boolean := false;
	signal rs_instr : std_logic_vector(8 downto 0);
	signal done : boolean;
	signal lcd_rs: std_logic;
	signal lcd_en: std_logic;
	signal lcd_rw: std_logic;
	signal lcdd  : std_logic_vector(7 downto 0);

begin
	comp_test: write_module port map (clock, enable, rs_instr, done, lcd_rs, lcd_en, lcd_rw, lcdd);

	clock <= not clock after 5 ns; -- 100 MHz clock

	process
		type pattern_type is record
			enable : boolean;
			rs_instr : std_logic_vector(8 downto 0);
			done : boolean;
			lcd_rs : std_logic;
			lcd_en : std_logic;
			lcd_rw : std_logic;
			lcdd   : std_logic_vector(7 downto 0);
			wait_delay: natural;
		end record;

		type pattern_array is array (natural range <>) of pattern_type;
		constant patterns : pattern_array :=
				((false, '0' & x"00", false, 'U', '0', 'U', x"00", 0), -- unknown initial state
				 (true,  '0' & x"01", false, 'U', '0', 'U', x"00", 0), -- send enable
				 (true,  '0' & x"01", false, 'U', '0', 'U', x"00", 0), -- 'init' state
				 (false, '0' & x"01", false, '0', '1', 'U', x"01", 80), -- 'enable' state
				 (false, '0' & x"01", false, '0', '0', 'U', x"01", 1200), -- 'hold' state
				 (false, '0' & x"01", true,  'U', '0', 'U', x"00", 0));

	begin
		for i in patterns'range loop
			if (clock /= '0') then
				wait until clock = '0';
			end if;
			wait until clock = '1';

			enable <= patterns(i).enable;
			rs_instr <= patterns(i).rs_instr;
			wait for 1 ns;

			if (patterns(i).wait_delay = 80) then -- 'enable' state
				wait for 80 ns;
			elsif (patterns(i).wait_delay = 1200) then -- 'hold' state
				wait for 1200 ns;
			end if;

			--assert done = patterns(i).done;
			--	report "bad 'done' value" severity error;
			--assert lcd_rs = patterns(i).lcd_rs;
			--	report "bad 'lcd_rs' value" severity error;
			--lcd_rs <= patterns(i).lcd_rs;
			--assert lcd_en = patterns(i).lcd_en;
			--	report "bad 'lcd_en' value" severity error;
			--assert lcd_rw = patterns(i).lcd_rw;
			--	report "bad 'lcd_rw' value" severity error;
			--assert lcdd = patterns(i).lcdd;
			--	report "bad 'lcdd' value" severity error;
		end loop;
		assert false report "end of test" severity failure;
		wait;
	end process;
end behav;
