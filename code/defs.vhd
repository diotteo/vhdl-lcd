package defs is
	-- length in bits of the lcd vector
	constant LCD_LEN : integer := 11;
	
	component write_module is
		port(
				clk : in    std_logic; --Signal de l'horloge cadencé à 100Mhz

				-- Signaux permettant de contrôler l'état du module
				enable: in  boolean; -- Démarre la séquence d'envoie sur un front montant
				done  : out boolean; -- Niveau haut lorsque le module a terminé l'envoie
				rs    : in  std_logic;
				instr : in  std_logic_vector(7 downto 0); -- Instruction ou donnée à envoyer(7 downto 0)

				-- Signaux qui seront liés au LCD
				LCD_rs : out std_logic; -- Signal permettant de choisir entre DATA/INSTRUCTION
				LCD_rw : out std_logic; -- Signal permettant de sélectionner le mode write ou read
				LCD_en : out std_logic; -- Signal permettant de valider la commande
				LCDD   : out std_logic_vector(7 downto 0) -- Bus d'instruction vers le LDC
				);
	end component;

	
end package defs;

--package body defs is
--end package body defs;
