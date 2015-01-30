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
	component Power_On_Init
		port (
			clk:    in    std_logic;
			enable: in    boolean;
			done:   out   boolean;
			lcd:    inout std_logic_vector(LCD_LEN - 1 downto 0)
		);
	end component;

	component Set_Ddram_Address is
		port(
				clk    : in    std_logic;
				enable : in    boolean;
				done   : out   boolean;
				address: in    std_logic_vector(6 downto 0);
				lcd    : out   std_logic_vector(LCD_LEN - 1 downto 0)
				);
	end component;


	type state_t is (
			INIT_STATE,
			POWER_ON_INIT_STATE,
			CLR_DISP_STATE,
			WRITE_FIRST_LINE_STATE,
			RST_CURSOR_STATE,
			SET_J_STATE,
			SET_I_STATE,
			DECR_I_STATE,
			WRITE_EXPR_STATE,
			WAIT_ANIM_DELAY_STATE,
			ADD_OFFSET_STATE,
			INCR_EXPR_STATE,
			WAIT_TRANSITION_DELAY_STATE
			);

	signal fsm_state : state_t := POWER_ON_INIT_STATE;
	signal lcd : std_logic_vector(LCD_LEN - 1 downto 0);
	signal do_power_on_init: boolean;
	signal do_set_ddram_addr: boolean;
	signal done: boolean;

	-- FIXME: Replace this by the legal equivalent of x"50" (6 downto 0)
	constant LAST_ADDR: std_logic_vector(7 downto 0) := x"50";
begin

	-- lcd variables are hidden in a vector
	lcden <= lcd(10);
	lcdrs <= lcd(9);
	lcdrw <= lcd(8);
	lcdd <= lcd(7 downto 0);

	COMP_INIT: Power_On_Init port map (clk, do_power_on_init, done, lcd);

	COMP_RST_CURSOR: Set_Ddram_Address port map (clk, do_set_ddram_addr, done, LAST_ADDR (6 downto 0), lcd);

	process(clk)
		variable i, j: integer;
		variable offset: integer := 0;
		variable charpos: integer := 0;
		variable expr_idx: integer := 0;

		--FIXME: We need to figure out how to print characters and therefore which type to use
		constant EXPR_IDX_MAX: integer := 8 * 32 * 3 - 1;
		variable expr: std_logic_vector(EXPR_IDX_MAX downto 0);
	begin
		if rising_edge(clk) then
			case fsm_state is

				when INIT_STATE =>
					--Init variables and what not here

					fsm_state <= POWER_ON_INIT_STATE;


				when POWER_ON_INIT_STATE =>
					-- raise power on init's enable bit
					do_power_on_init <= true;

					if (done) then
						do_power_on_init <= false;
						fsm_state <= CLR_DISP_STATE;
					end if;


				when CLR_DISP_STATE =>
					--COMP_CLR_DISP: CLR_DISP port map ();

					if (done) then
						--enable <= 0

						--if != 0
						if (offset /= 0) then
							fsm_state <= WRITE_FIRST_LINE_STATE;
						else
							fsm_state <= RST_CURSOR_STATE;
						end if;
					end if;


				when WRITE_FIRST_LINE_STATE =>
					--COMP_WRITE_LINE: WRITE_LINE port map ();

					if (done) then
						--enable <= 0
						fsm_state <= RST_CURSOR_STATE;
					end if;


				when RST_CURSOR_STATE =>
					do_set_ddram_addr <= true;

					if (done) then
						do_set_ddram_addr <= false;
						fsm_state <= SET_J_STATE;
					end if;


				when SET_J_STATE =>
					j := 16;
					fsm_state <= SET_I_STATE;


				when SET_I_STATE =>
					i := 16;
					fsm_state <= DECR_I_STATE;


				when DECR_I_STATE =>
					i := i - 1;

					-- i - 1 as decrement will take effect only at next clock cycle
					charpos := to_integer(to_unsigned(expr_idx, 10) sll 5) + i - 1;
					fsm_state <= WRITE_EXPR_STATE;


				when WRITE_EXPR_STATE =>
					--COMP_CHAR_WRITE: WRITE_CHAR port map (expr(charpos))

					if (done) then
						-- FIXME: Is this possible?
						if (i < j) then
							j := j - 1;
							fsm_state <= WAIT_ANIM_DELAY_STATE;
						else
							fsm_state <= DECR_I_STATE;
						end if;
					end if;


				when WAIT_ANIM_DELAY_STATE =>
					if (done) then
						if (j /= 0) then
							fsm_state <= SET_I_STATE;
						elsif (offset = 0) then
							fsm_state <= ADD_OFFSET_STATE;
						else
							fsm_state <= INCR_EXPR_STATE;
						end if;
					end if;


				when ADD_OFFSET_STATE =>
					offset := 16;
					fsm_state <= CLR_DISP_STATE;


				when INCR_EXPR_STATE =>
					if expr_idx = EXPR_IDX_MAX then
						expr_idx := 0;
					else
						expr_idx := expr_idx + 1;
					end if;

					offset := 0;
					fsm_state <= WAIT_TRANSITION_DELAY_STATE;


				when WAIT_TRANSITION_DELAY_STATE =>
					if (done) then
						fsm_state <= CLR_DISP_STATE;
					end if;
			end case;
		end if;
	end process;

end afficheur_main;
