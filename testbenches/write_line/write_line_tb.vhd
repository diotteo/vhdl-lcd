use work.defs.all;

library IEEE;
use IEEE.std_logic_1164.all;
use std.textio.all;
use IEEE.numeric_std.all;

entity write_line_tb is
end write_line_tb;

architecture behav of write_line_tb is
	  
	signal clock  : std_logic; --Horloge du compteur 
	signal rst	  : std_logic; --Signal synchrone pour remettre a zero la machine a etat
	signal enable: boolean; -- Signal permettant de demarrer la sequence d'ecriture (Doit être mis a 0 avant la prochaie ecriture)
	signal done  : boolean;   -- Signal indiquant que la sequence d'ecriture est terminee
	signal line_1: string ( 1 to 16 ); --Signal contenant le text a ecrire
	signal position:	  std_logic_vector(6 downto 0); --Position où commencer a ecrire la ligne
	signal lcd   : lcd_type;

	signal runsim: boolean := true;

begin

	comp_test: Write_First_Line port map (clock, rst, enable, done, line_1, position, lcd);

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
	begin
		rst <= '0';
		enable <= false;
		
		wait for 20 ns;
		
		rst <= '0';
		enable <= true;
		line_1 <= "ABCDEFGHIJKLMNOP";
		position <= "1111111";
		
		wait until done <= true;
		
		enable <= false;
		
		wait for 60 ns;
		
		runsim <= false;
		
		wait;
	
--		type pattern_type is record
--			rst    : std_logic;
--			start_timer: boolean;
--			clk_count : integer;
--			timer_done : boolean;
--			wait_delay: natural;
--		end record;
--
--		type pattern_array is array (natural range <>) of pattern_type;
--		constant patterns : pattern_array :=
--				((false, false, U, 'U', 0), -- unknown initial state
--				 (false, true, 4000, '0', 0), -- 'start counting
--				 (false,  true, U,'1', 4000), -- 'done counting'
--				 (false, false, 4000, '0', 0)); -- 'signal settle' state
--
--	variable l: line;
--	begin
--		for i in patterns'range loop
--			write (l, String'("i = " & natural'image(i) & " current time:" & time'IMAGE(now)));
--			writeline (output, l);
--			if (clock /= '0') then
--				wait until clock = '0';
--			end if;
--			wait until clock = '1';
--		
--			rst<= patterns(i).rst;
--			start_timer <= patterns(i).start_timer;
--			clk_count <= patterns(i).clk_count;
--
--			wait for 1 ns;
--
--			assert (patterns(i).timer_done = 'U') or ((patterns(i).timer_done = '1') = done)
--				report "timer done: " & boolean'image(timer_done) & " /= " & std_logic'image(patterns(i).timer_done) severity error;
--			
--			assert lcdd = patterns(i).lcdd
--				report "lcdd: wrong value" severity error;
--				
--			wait for patterns(i).wait_delay * 1 ns;
--
--		end loop;
--
--		runsim <= false;
--		wait;
	end process;
end behav;
