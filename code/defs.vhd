----------------------------------------------------------------------------------
-- Company: ETS - ELE740
-- Programmer: Olivier Diotte & Marc-Andr� S�guin
--
-- Create Date:
-- Module Name:    defs.vhd
-- Project Name:   Afficheur LCD
-- Target Devices: Virtex 5 LX50T
--
-- Description:    Fichier librairie contenant les constantes de notre syst�me et les components de celui-ci
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
	constant LCDD_LEN : natural := 8;

	type lcd_type is record
		-- Signal permettant de choisir entre DATA/INSTRUCTION
		rs : std_logic;
		-- Signal permettant de s�lectionner le mode write ou read
		rw : std_logic;
		-- Signal permettant de valider la commande
		en : std_logic;
		-- Bus d'instruction vers le LCD
		data : std_logic_vector(LCDD_LEN - 1 downto 0);
	end record;


	--- Component declarations ---

	component write_module is
		port(
			clk : in    std_logic; --Signal de l'horloge cadenc� � 100Mhz

			-- Signaux permettant de contr�ler l'�tat du module
			enable: in  boolean; -- D�marre la s�quence d'envoie sur un front montant
			done  : out boolean; -- Niveau haut lorsque le module a termin� l'envoie
			rs    : in  std_logic;
			instr : in  std_logic_vector(7 downto 0); -- Instruction ou donn�e � envoyer(7 downto 0)

			-- Signaux qui seront li�s au LCD
			lcd   : out lcd_type
			);
	end component;

	component Clear_Display is
		port(
			clk    : in    std_logic;
			enable : in    boolean;
			done   : out   boolean;
			lcd    : out   lcd_type
			);
	end component;

	component Cursor_Or_Display_Shift is
	port(
			clk    : in    std_logic;
			enable : in    boolean;
			done   : out   boolean;
			sh_d_c : in    std_logic; -- shift entire display, !cursor
			sh_r_l : in    std_logic; -- shift right, !left
			lcd    : out   lcd_type
			);
	end component;

	component Display_On_Off_Control is
	port(
			clk         : in    std_logic;
			enable      : in    boolean;
			done        : out   boolean;
			disp_on     : in    std_logic;
			cur_on      : in    std_logic;
			cur_blink_on: in    std_logic;
			lcd         : out   lcd_type
			);
	end component;

	component Entry_Mode_Set is
	port(
			clk    : in    std_logic;
			enable : in    boolean;
			done   : out   boolean;
			i_d    : in    std_logic;
			sh     : in    std_logic;
			lcd    : out   lcd_type
			);
	end component;

	component Function_Set is
	port(
			clk    : in    std_logic;
			enable : in    boolean;
			done   : out   boolean;
			data_len: in   std_logic;
			nlines : in    std_logic;
			font   : in    std_logic;
			lcd    : out   lcd_type
			);
	end component;

	component Return_Home is
	port(
			clk    : in    std_logic;
			enable : in    boolean;
			done   : out   boolean;
			lcd    : out   lcd_type
			);
	end component;

	component Set_Cgram_Address is
	port(
			clk    : in    std_logic;
			enable : in    boolean;
			done   : out   boolean;
			address: in    std_logic_vector(5 downto 0);
			lcd    : out   lcd_type
			);
	end component;

	component Set_Ddram_Address is
		port(
			clk    : in    std_logic;
			enable : in    boolean;
			done   : out   boolean;
			address: in    std_logic_vector(6 downto 0);
			lcd    : out   lcd_type
			);
	end component;

	component Write_Data_To_Ram is
	port(
			clk    : in    std_logic;
			enable : in    boolean;
			done   : out   boolean;
			data   : in    std_logic_vector(7 downto 0);
			lcd    : out   lcd_type
			);
	end component;


	component Power_On_Init is
	port(
		clk   : in    std_logic;
		enable: in    boolean;
		done  : out   boolean;
		lcd   : inout lcd_type
		);
	end component;

	component Write_First_line is
	port(
		clk   : in    std_logic; --Horloge du compteur 
		rst	: in	  std_logic; --Signal synchrone pour remettre � z�ro le compteur  
		enable: in    boolean;   -- Signal permettant de d�marrer la s�quence d'�criture (Doit �tre mis � 0 avant la prochaie �criture)
		done  : out   boolean;   -- Signal indiquant que la s�quence d'�criture est termin�e
		line_1: in    string ( 1 to 16 ); --Signal contenant le text � �crire
		position	: in	  std_logic_vector(6 downto 0); --Position o� commencer � �crire la ligne
		lcd    : out   lcd_type --Vecteur contenant les signaux a envoyer au LCD
		);
	end component;

	component Timer is
	port(
		clk   : in    std_logic; --Horloge du compteur 
		rst	  : in	  std_logic; --Signal synchrone pour remettre � z�ro le compteur
		start_timer: in    boolean; --Signal permettant de d�marrer le compteur. Doit �tre remis � 0 pour commencer � compter de nouveau
		clk_count: in integer; -- Nombre de coup d'horloge � compter
		timer_done  : out   boolean -- Signal avertissant la fin du compte
		);
	end component;


end package defs;

--package body defs is
--end package body defs;
