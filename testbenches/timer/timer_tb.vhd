use work.defs.all;

library IEEE;
use IEEE.std_logic_1164.all;
use std.textio.all;
use IEEE.numeric_std.all;

entity timer_tb is
end timer_tb;

architecture behav of timer_tb is
	

	signal clock  : std_logic; --Horloge du compteur 
	signal rst	  : std_logic; --Signal synchrone pour remettre à zéro le compteur
	signal start_timer: boolean; --Signal permettant de démarrer le compteur. Doit être remis à 0 pour commencer à compter de nouveau
	signal clk_count: integer; -- Nombre de coup d'horloge à compter
	signal timer_done  : boolean; -- Signal avertissant la fin du compte

	signal runsim: boolean := true;

begin
	
	comp_test: timer port map (clock, rst, start_timer, clk_count, timer_done);

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
		start_timer <= false;
		
		wait for 20 ns;
		
		rst <= '0';
		start_timer <= true;
		clk_count <= 40;
		
		wait until timer_done <= true;
		
		start_timer <= false;
		
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
