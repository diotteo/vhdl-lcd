----------------------------------------------------------------------------------
-- Company: ETS - ELE740
-- Programmer: Olivier Diotte & Marc-Andre Seguin
--
-- Create Date:
-- Module Name:    defs.vhd
-- Project Name:   Afficheur LCD
-- Target Devices: Virtex 5 LX50T
--
-- Description:    Fichier librairie contenant les constantes de notre systeme et les components de celui-ci
--
-- Dependencies:   None
--
-- Revision: 0.01
-- Additional Comments:
--
----------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

package defs is
	constant CLK_PERIOD : time := 10 ns;
	constant ANIMATION_DELAY_WAIT_COUNT : natural := 500_000_00; --500 ms / CLK_PERIOD;
	constant TRANSITION_DELAY_WAIT_COUNT : natural := 5_000_000_00; -- 5 sec / CLK_PERIOD;

	constant LCDD_LEN : natural := 8;

	type lcd_type is record
		-- Signal permettant de choisir entre DATA/INSTRUCTION
		rs : std_logic;
		-- Signal permettant de selectionner le mode write ou read
		rw : std_logic;
		-- Signal permettant de valider la commande
		en : std_logic;
		-- Bus d'instruction vers le LCD
		data : std_logic_vector(LCDD_LEN - 1 downto 0);
	end record;


	--- Component declarations ---

	component write_module is
		port(
			clk : in std_logic; --Signal de l'horloge cadence a 100Mhz

			-- Signaux permettant de controler l'etat du module
			enable : in boolean; -- Demarre la sequence d'envoie sur un front montant
			done : out boolean; -- Niveau haut lorsque le module a termine l'envoie
			rs : in std_logic;
			instr : in std_logic_vector(7 downto 0); -- Instruction ou donnee a envoyer(7 downto 0)

			-- Signaux qui seront lies au LCD
			lcd : out lcd_type
			);
	end component;

	constant CLR_DISP_WAIT_COUNT : natural := 1_520_000_00; -- 1520 us / CLK_PERIOD;
	component Clear_Display is
		port(
			clk : in std_logic;
			enable : in boolean;
			done : out boolean;
			lcd : out lcd_type
			);
	end component;

	component Cursor_Or_Display_Shift is
	port(
			clk : in std_logic;
			enable : in boolean;
			done : out boolean;
			sh_d_c : in std_logic; -- shift entire display, !cursor
			sh_r_l : in std_logic; -- shift right, !left
			lcd : out lcd_type
			);
	end component;

	constant DISP_ON_OFF_CTL_WAIT_COUNT : natural := 40_00; -- 40 us / CLK_PERIOD;
	component Display_On_Off_Control is
	port(
			clk : in std_logic;
			enable : in boolean;
			done : out boolean;
			disp_on : in std_logic;
			cur_on : in std_logic;
			cur_blink_on : in std_logic;
			lcd : out lcd_type
			);
	end component;

	constant EMS_WAIT_COUNT : natural := 40_00; -- 40 us / CLK_PERIOD;
	component Entry_Mode_Set is
	port(
			clk : in std_logic;
			enable : in boolean;
			done : out boolean;
			i_d : in std_logic;
			sh : in std_logic;
			lcd : out lcd_type
			);
	end component;

	constant FCT_SET_WAIT_COUNT : natural := 40_00; -- 40 us / CLK_PERIOD;
	component Function_Set is
	port(
			clk : in std_logic;
			enable : in boolean;
			done : out boolean;
			data_len : in std_logic;
			nlines : in std_logic;
			font : in std_logic;
			lcd : out lcd_type
			);
	end component;

	component Return_Home is
	port(
			clk : in std_logic;
			enable : in boolean;
			done : out boolean;
			lcd : out lcd_type
			);
	end component;

	component Set_Cgram_Address is
	port(
			clk : in std_logic;
			enable : in boolean;
			done : out boolean;
			address : in std_logic_vector(5 downto 0);
			lcd : out lcd_type
			);
	end component;

	component Set_Ddram_Address is
		port(
			clk : in std_logic;
			enable : in boolean;
			done : out boolean;
			address : in std_logic_vector(6 downto 0);
			lcd : out lcd_type
			);
	end component;

	component Write_Data_To_Ram is
	port(
			clk : in std_logic;
			enable : in boolean;
			done : out boolean;
			data : in std_logic_vector(7 downto 0);
			lcd : out lcd_type
			);
	end component;


	constant POI_INIT_WAIT_COUNT : natural := 40_00; -- 40 ms / CLK_PERIOD;
	component Power_On_Init is
	port(
		clk : in std_logic;
		enable : in boolean;
		done : out boolean;
		lcd : inout lcd_type
		);
	end component;

	component Write_First_line is
	port(
		clk : in std_logic; -- Horloge du compteur
		rst : in std_logic; -- Signal synchrone pour remettre a zero le compteur
		enable : in boolean; -- Signal permettant de demarrer la sequence d'ecriture (Doit être mis a 0 avant la prochaie ecriture)
		done : out boolean; -- Signal indiquant que la sequence d'ecriture est terminee
		line_1 : in string ( 1 to 16 ); -- Signal contenant le text a ecrire
		position : in std_logic_vector(6 downto 0); -- Position où commencer a ecrire la ligne
		char_to_write : in integer range 0 to 16; -- Nombre de lettre a ecrire venant du string
		lcd : out lcd_type -- Vecteur contenant les signaux a envoyer au LCD
		);
	end component;

	component Timer is
	port(
		clk : in std_logic; -- Horloge du compteur
		rst : in std_logic; -- Signal synchrone pour remettre a zero le compteur
		start_timer : in boolean; -- Signal permettant de demarrer le compteur. Doit être remis a 0 pour commencer a compter de nouveau
		clk_count : in integer; -- Nombre de coup d'horloge a compter
		timer_done : out boolean -- Signal avertissant la fin du compte
		);
	end component;


end package defs;

--package body defs is
--end package body defs;
