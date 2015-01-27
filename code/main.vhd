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
library IEEE;
use IEEE.STD_LOGIC_1164.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity afficheur is
	port(
		clk   : in    std_logic
		);

end afficheur;


architecture afficheur_main of afficheur is
	type State_Type is (
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
	signal current_state : State_Type := INIT;

begin
	process(clk)
		variable j, i: integer;
	begin
		if rising_edge(clk) then
			case current_state is


				when INIT =>
					-- raise power on init's enable bit
					COMP_INIT: POWER_ON_INIT port map ();

					if (done) then
						--enable <= 0
						current_state <= CLR_DISP_STATE;
					end if;


				when CLR_DISP_STATE =>
					COMP_CLR_DISP: CLR_DISP port map ();

					if (done) then
						--enable <= 0

						--if != 0
						if (offset) then
							current_state <= WRITE_FIRST_LINE_STATE port map ();
						else
							current_state <= RST_CURSOR_STATE port map ();
						end if;
					end if;


				when WRITE_FIRST_LINE_STATE =>
					COMP_WRITE_LINE: WRITE_LINE port map ();

					if (done) then
						--enable <= 0
						current_state <= RST_CURSOR_STATE port map ();
					end if;


				when RST_CURSOR_STATE =>
					COMP_RST_CURSOR: SET_DDRAM port map (x"50");

					if (done) then
						--enable <= 0
						current_state <= SET_J_STATE;
					end if;


				when SET_J_STATE =>
					j := 16;
					current_state <= SET_I_STATE;


				when SET_I_STATE =>
					i := 16;
					current_state <= DECR_I_STATE;


				when DECR_I_STATE =>
					-- Must wait one clock cycle for decrement to take effect
					i := i - 1;

					-- FIXME: Is such a thing even possible? Or must we add another step?
					charpos := expr_id << 5 + i - 1
					current_state <= WRITE_EXPR_STATE;


				when WRITE_EXPR_STATE =>
					COMP_CHAR_WRITE: WRITE_CHAR port map (expr(charpos))

					if (done) then
						-- FIXME: Is this possible?
						if (i < j) then
							current_state <= WAIT_ANIM_DELAY_STATE;
						else
							current_state <= DECR_I_STATE;
						end if
					end if


				when WAIT_ANIM_DELAY_STATE =>
					if (done) then
						if (j) then
							current_state <= SET_I_STATE;
						elsif (not offset) then
							current_state <= ADD_OFFSET_STATE;
						else
							current_state <= INCR_EXPR_STATE;
					end if;


				when ADD_OFFSET_STATE =>
					offset := 16;
					current_state <= CLR_DISP_STATE;


				when INCR_EXPR_STATE =>
					if expr_idx xnor EXPR_IDX_MAX then
						expr_idx := 0;
					else
						expr_idx := expr_idx + 1
					end if;

					offset := 0;
					current_state <= WAIT_TRANSITION_DELAY_STATE;


				when WAIT_TRANSITION_DELAY_STATE =>
					if (done) then
						current_state <= CLR_DISP_STATE
					end if;
			end case;
		end if;
	end process;

end afficheur_main;
