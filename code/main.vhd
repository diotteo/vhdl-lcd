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

entity afficheur is
	port(
		clk   : in    std_logic;
		--led   : out   std_logic_vector(7 downto 0);
		lcden : out   std_logic;
		lcdrs : out   std_logic;
		lcdrw : out   std_logic;
		lcdd  : inout std_logic_vector(7 downto 0)
		);

end afficheur;


architecture afficheur_main of afficheur is
	type state_t is (
			INIT_STATE,
			CLR_DISP_STATE,
			WRITE_FIRST_LINE_STATE,
			RST_CURSOR_STATE,
			SET_J_STATE,
			SET_I_STATE,
			DECR_I_STATE,
			WRITE_EXPR_STATE,
			DECR_J_STATE,
			WAIT_ANIM_DELAY_STATE,
			ADD_OFFSET_STATE,
			INCR_EXPR_STATE,
			WAIT_TRANSITION_DELAY_STATE
			);


	component Power_On_Init
		port (
			clk:    in    std_logic;
			enable: in    std_logic;
			done:   out   std_logic;
			lcd:    inout std_logic_vector(LCD_LEN - 1 downto 0)
		);
	end component;

	signal fsm_state : state_t := INIT;
	signal lcd : std_logic_vector(LCD_LEN - 1 downto 0);

begin

	lcd <= lcden & lcdrs & lcdrw & lcdd;

	process(clk)
		variable j, i: integer;
	begin
		if rising_edge(clk) then
			case fsm_state is


				when INIT =>
					-- raise power on init's enable bit
					COMP_INIT: Power_On_Init port map (clk, enable, done, lcd);

					if (done) then
						--enable <= 0
						fsm_state <= CLR_DISP_STATE;
					end if;


				when CLR_DISP_STATE =>
					COMP_CLR_DISP: CLR_DISP port map ();

					if (done) then
						--enable <= 0

						--if != 0
						if (offset) then
							fsm_state <= WRITE_FIRST_LINE_STATE port map ();
						else
							fsm_state <= RST_CURSOR_STATE port map ();
						end if;
					end if;


				when WRITE_FIRST_LINE_STATE =>
					COMP_WRITE_LINE: WRITE_LINE port map ();

					if (done) then
						--enable <= 0
						fsm_state <= RST_CURSOR_STATE port map ();
					end if;


				when RST_CURSOR_STATE =>
					COMP_RST_CURSOR: SET_DDRAM port map (x"50");

					if (done) then
						--enable <= 0
						fsm_state <= SET_J_STATE;
					end if;


				when SET_J_STATE =>
					j := 16;
					fsm_state <= SET_I_STATE;


				when SET_I_STATE =>
					i := 16;
					fsm_state <= DECR_I_STATE;


				when DECR_I_STATE =>
					-- Must wait one clock cycle for decrement to take effect
					i := i - 1;

					-- FIXME: Is such a thing even possible? Or must we add another step?
					charpos := expr_id << 5 + i - 1
					fsm_state <= WRITE_EXPR_STATE;


				when WRITE_EXPR_STATE =>
					COMP_CHAR_WRITE: WRITE_CHAR port map (expr(charpos))

					if (done) then
						-- FIXME: Is this possible?
						if (i < j) then
							fsm_state <= WAIT_ANIM_DELAY_STATE;
						else
							fsm_state <= DECR_I_STATE;
						end if
					end if


				when WAIT_ANIM_DELAY_STATE =>
					if (done) then
						if (j) then
							fsm_state <= SET_I_STATE;
						elsif (not offset) then
							fsm_state <= ADD_OFFSET_STATE;
						else
							fsm_state <= INCR_EXPR_STATE;
					end if;


				when ADD_OFFSET_STATE =>
					offset := 16;
					fsm_state <= CLR_DISP_STATE;


				when INCR_EXPR_STATE =>
					if expr_idx xnor EXPR_IDX_MAX then
						expr_idx := 0;
					else
						expr_idx := expr_idx + 1
					end if;

					offset := 0;
					fsm_state <= WAIT_TRANSITION_DELAY_STATE;


				when WAIT_TRANSITION_DELAY_STATE =>
					if (done) then
						fsm_state <= CLR_DISP_STATE
					end if;
			end case;
		end if;
	end process;

end afficheur_main;
