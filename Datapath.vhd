LIBRARY IEEE;
USE IEEE.std_logic_1164.all; 
USE IEEE.std_logic_arith.all;
USE IEEE.std_logic_unsigned.all;

ENTITY Datapath IS
PORT(
	-- Entradas de dados
	CLOCK: IN std_logic;
	KEY: IN std_logic_vector(3 DOWNTO 0);
	SWITCH: IN std_logic_vector(7 DOWNTO 0);

	-- Entradas de controle
	R1, R2, E1, E2, E3, E4: IN std_logic;
	SEL: IN std_logic;

	-- Saídas de dados
	hex0, hex1, hex2, hex3, hex4, hex5: OUT std_logic_vector(6 DOWNTO 0);
	leds: OUT std_logic_vector(3 DOWNTO 0);
	ledg: out std_logic_vector(3 downto 0);
	
	-- Saídas de status
	end_FPGA, end_User, end_time, win, match: OUT std_logic
);
END ENTITY;

ARCHITECTURE arc OF Datapath IS
---------------------------SIGNALS-----------------------------------------------------------

--ButtonSync-----------------------------------------------------------
	SIGNAL BTN0: std_logic;
	SIGNAL BTN1: std_logic;
	SIGNAL BTN2: std_logic;
	SIGNAL BTN3: std_logic;
	SIGNAL NBTN, NOTKEYS: std_logic_vector(3 DOWNTO 0);

--Operações booleanas--------------------------------------------------
	SIGNAL E_Counter_User: std_logic;
	SIGNAL data_REG_FPGA: std_logic_vector(63 DOWNTO 0);
	SIGNAL data_REG_User: std_logic_vector(63 DOWNTO 0);
	SIGNAL c1aux, c2aux: std_logic;

--REG_Setup-------------------------------------------------------------
	SIGNAL SETUP: std_logic_vector(7 downto 0);

--div_freq--------------------------------------------------------------
	SIGNAL C05Hz, C07Hz, C09Hz, C1Hz, C11Hz, C12Hz, C13Hz, C14Hz, C15Hz, C16Hz, C17Hz, C18Hz, C19Hz: std_logic;
	SIGNAL C2Hz, C21Hz, C22Hz, C23Hz, C24Hz, C25Hz, C26Hz, C27Hz, C28Hz, C29Hz, C3Hz, C31Hz, C32Hz: std_logic;
	SIGNAL C33Hz, C34Hz, C35Hz, C36Hz, C38Hz, C4Hz, C42Hz, C44Hz, C46Hz, C48Hz, C5Hz: std_logic;
	SIGNAL C52Hz, C54Hz, C56Hz, C58Hz, C6Hz: std_logic;

--Counter_Round--------------------------------------------------------
	SIGNAL win_internal: std_logic;
	SIGNAL ROUND: std_logic_vector(3 DOWNTO 0);

--Counter_time---------------------------------------------------------
	SIGNAL TEMPO: std_logic_vector(3 DOWNTO 0);

--Counter_FPGA---------------------------------------------------------
	SIGNAL SEQFPGA: std_logic_vector(3 DOWNTO 0);

--ROM------------------------------------------------------------------
	SIGNAL SEQ_FPGA: std_logic_vector(3 DOWNTO 0);

--Counter_User---------------------------------------------------------
	SIGNAL end_User_internal: std_logic;

--REG_FPGA-------------------------------------------------------------
	SIGNAL OUT_FPGA: std_logic_vector(63 DOWNTO 0);

--REG_User-------------------------------------------------------------
	SIGNAL OUT_User: std_logic_vector(63 DOWNTO 0);	

--COMP-----------------------------------------------------------------
	SIGNAL is_equal: std_logic;

--LOGICA---------------------------------------------------------------
	SIGNAL POINTS: std_logic_vector(7 DOWNTO 0);

--DECODIFICADORES------------------------------------------------------
--Externos-------------------------------------------------------------
	SIGNAL G_dec7segHEX4: std_logic_vector(3 DOWNTO 0);

--DecBCD---------------------------------------------------------------
	SIGNAL POINTS_BCD: std_logic_vector(7 DOWNTO 0);

--dec7segHEX4----------------------------------------------------------
	SIGNAL dec7segHEX4: std_logic_vector(6 DOWNTO 0);

--dec7segHEX2----------------------------------------------------------
	SIGNAL dec7segHEX2: std_logic_vector(6 DOWNTO 0);

--dec7segHEX1----------------------------------------------------------
	SIGNAL dec7segHEX1: std_logic_vector(6 DOWNTO 0);

--dec7segHEX00---------------------------------------------------------
	SIGNAL dec7segHEX00: std_logic_vector(6 DOWNTO 0);

--dec7segHEX01---------------------------------------------------------
	SIGNAL dec7segHEX01: std_logic_vector(6 DOWNTO 0);
	
--MULTIPLEXADORES----------------------------------------------------------------------------

--Mux0HEX5-------------------------------------------------------------
	SIGNAL output_Mux0HEX5: std_logic_vector(6 DOWNTO 0);

--Mux16_1--------------------------------------------------------------
	SIGNAL saida0mux16_1, saida1mux16_1, saida2mux16_1, saida3mux16_1: std_logic;
	
--Mux0HEX2-------------------------------------------------------------
	SIGNAL output_Mux0HEX2: std_logic_vector(6 DOWNTO 0);
	
--Mux0HEX3-------------------------------------------------------------
	SIGNAL output_Mux0HEX3: std_logic_vector(6 DOWNTO 0);

--Mux0HEX4-------------------------------------------------------------
	SIGNAL output_Mux0HEX4: std_logic_vector(6 DOWNTO 0);

--Mux4:1_4bits---------------------------------------------------------
	SIGNAL MUX4X1_4bits00: std_logic_vector(3 DOWNTO 0);
	SIGNAL MUX4X1_4bits01: std_logic_vector(3 DOWNTO 0);
	SIGNAL MUX4X1_4bits10: std_logic_vector(3 DOWNTO 0);
	SIGNAL MUX4X1_4bits11: std_logic_vector(3 DOWNTO 0);

--MUXdiv_freq_de2-------------------------------------------------------
	SIGNAL CLKHZ: std_logic;	
	
---------------------------COMPONENTS-----------------------------------------------------------

--------------------------MUX4X1_4bits----------------------------------
COMPONENT MUX4X1_4bits IS
PORT(
	SEL: IN std_logic_vector(1 DOWNTO 0);
    A, B, C, D: IN std_logic_vector(3 DOWNTO 0);
    Y: OUT std_logic_vector(3 DOWNTO 0)
);
END COMPONENT;
-------------------------MUX2X1_4bits-------------------------------------
COMPONENT MUX2X1_4bits IS
PORT(
	SEL: IN std_logic;
    A, B: IN std_logic_vector(3 DOWNTO 0);
    Y: OUT std_logic_vector(3 DOWNTO 0)
);
END COMPONENT;
-------------------------MUX2X1_7bits-------------------------------------
COMPONENT MUX2X1_7bits IS
PORT(
	SEL: IN std_logic;
    A, B: IN std_logic_vector(6 DOWNTO 0);
    Y: OUT std_logic_vector(6 DOWNTO 0)
);
END COMPONENT;
----------------------------MUX4X1_1bit-----------------------------------
COMPONENT MUX4X1 IS
PORT(
    SEL: IN std_logic_vector(1 DOWNTO 0);
    A, B, C, D: IN std_logic;
    Y: OUT std_logic
);
END COMPONENT;
-------------------------MUX16X1_clock------------------------------------
COMPONENT MUX16X1 IS
PORT(
    SEL: IN std_logic_vector(3 DOWNTO 0);
    A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P: IN std_logic;
    Y: OUT std_logic
);
END COMPONENT;
---------------------------dec7seg----------------------------------------
COMPONENT dec7seg IS
PORT(
    G: IN std_logic_vector(3 DOWNTO 0);
	seg: OUT std_logic_vector(6 DOWNTO 0)
);
END COMPONENT;
---------------------------REG_Setup--------------------------------------
COMPONENT REG_Setup IS 
PORT(
    CLK, RST, EN: IN std_logic;
	D: IN std_logic_vector(7 DOWNTO 0);
	Q: OUT std_logic_vector(7 DOWNTO 0)
 );
END COMPONENT;
---------------------------REG_FPGA---------------------------------------
COMPONENT REG_FPGA IS 
PORT(
    CLK, RST, EN: IN std_logic;
	D: IN std_logic_vector(63 DOWNTO 0);
	Q: OUT std_logic_vector(63 DOWNTO 0)
 );
END COMPONENT;
---------------------------Reg_User---------------------------------------
COMPONENT Reg_User IS 
PORT(
    CLK, RST, EN: IN std_logic;
	D: IN std_logic_vector(63 DOWNTO 0);
	Q: OUT std_logic_vector(63 DOWNTO 0)
 );
END COMPONENT;
-----------------------------decSeq00-------------------------------------
COMPONENT decSeq00 IS
PORT(
	address: IN std_logic_vector(3 DOWNTO 0);
	output: OUT std_logic_vector(3 DOWNTO 0)
);
END COMPONENT;
-----------------------------decSeq01-------------------------------------
COMPONENT decSeq01 IS
PORT(
	address: IN std_logic_vector(3 DOWNTO 0);
	output: OUT std_logic_vector(3 DOWNTO 0)
);
END COMPONENT;
-----------------------------decSeq10-------------------------------------
COMPONENT decSeq10 IS
PORT(
	address: IN std_logic_vector(3 DOWNTO 0);
	output: OUT std_logic_vector(3 DOWNTO 0)
);
END COMPONENT;
-----------------------------decSeq11-------------------------------------
COMPONENT decSeq11 IS
PORT(
	address: IN std_logic_vector(3 DOWNTO 0);
	output: OUT std_logic_vector(3 DOWNTO 0)
);
END COMPONENT;
-------------------------Counter_time-------------------------------------
COMPONENT Counter_time IS
PORT(
    CLK, RST, EN: IN std_logic;
    Y: OUT std_logic_vector(3 DOWNTO 0);
    MAX: OUT std_logic
);
END COMPONENT;
------------------------Counter_round-------------------------------------
COMPONENT Counter_round IS
PORT(
    D: IN std_logic_vector(3 DOWNTO 0);
    CLK, RST, EN: IN std_logic;
    MAX: OUT std_logic;
    Y: OUT std_logic_vector(3 DOWNTO 0)
);
END COMPONENT;
-------------------------Counter_FPGA-------------------------------------
COMPONENT Counter_FPGA IS
PORT(
    CLK, RST, EN: IN std_logic;
	D: IN std_logic_vector(3 DOWNTO 0);
	MAX: OUT std_logic;
    Y: OUT std_logic_vector(3 DOWNTO 0)
);
END COMPONENT;
-------------------------Counter_User-------------------------------------
COMPONENT Counter_User IS
PORT(
    CLK, RST, EN: IN std_logic;
	D: IN std_logic_vector(3 DOWNTO 0);
    MAX: OUT std_logic
);
END COMPONENT;
----------------------div_freq_de2----------------------------------------
COMPONENT div_freq_de2 IS
PORT(reset: IN std_logic;
	CLOCK: in std_logic;
	C05Hz, C07Hz, C09Hz, C1Hz, C11Hz, C12Hz, C13Hz, C14Hz, C15Hz, C16Hz, C17Hz, C18Hz, C19Hz: out std_logic;
	C2Hz, C21Hz, C22Hz, C23Hz, C24Hz, C25Hz, C26Hz, C27Hz, C28Hz, C29Hz, C3Hz, C31Hz, C32Hz: out std_logic; 
	C33Hz, C34Hz, C35Hz, C36Hz, C38Hz, C4Hz, C42Hz, C44Hz, C46Hz, C48Hz, C5Hz: out std_logic;
	C52Hz, C54Hz, C56Hz, C58Hz, C6Hz: out std_logic
);
END COMPONENT;
----------------------div_freq_emu----------------------------------------
COMPONENT div_freq_emu IS
PORT(reset: IN std_logic;
	CLOCK: in std_logic;
	C05Hz, C07Hz, C09Hz, C1Hz, C11Hz, C12Hz, C13Hz, C14Hz, C15Hz, C16Hz, C17Hz, C18Hz, C19Hz: out std_logic;
	C2Hz, C21Hz, C22Hz, C23Hz, C24Hz, C25Hz, C26Hz, C27Hz, C28Hz, C29Hz, C3Hz, C31Hz, C32Hz: out std_logic; 
	C33Hz, C34Hz, C35Hz, C36Hz, C38Hz, C4Hz, C42Hz, C44Hz, C46Hz, C48Hz, C5Hz: out std_logic;
	C52Hz, C54Hz, C56Hz, C58Hz, C6Hz: out std_logic
);
END COMPONENT;
---------------------------LOGICA-----------------------------------------
COMPONENT LOGICA IS
PORT(
    LVL : in std_logic_vector(1 downto 0);
    RND : in std_logic_vector(3 downto 0);
    SEQ : in std_logic_vector(1 downto 0);
    Y : out std_logic_vector(7 downto 0)
);
END COMPONENT;
----------------------------COMP------------------------------------------
COMPONENT COMP IS 
PORT(
	A, B : in std_logic_vector(63 downto 0);
    Y : out std_logic
 );
END COMPONENT;
----------------------------buttonSync------------------------------------
component ButtonSync is
	port
	(
		KEY0, KEY1, KEY2, KEY3, CLK: in std_logic;
		BTN0, BTN1, BTN2, BTN3: out std_logic
	);
end component;

-- COMEÇO DO CODIGO ---------------------------------------------------------------------------------------

BEGIN

	FREQEMU: div_freq_emu PORT MAP(R1,CLOCK, C05Hz, C07Hz, C09Hz, C1Hz, C11Hz, C12Hz, C13Hz, C14Hz, C15Hz, C16Hz, C17Hz, C18Hz, C19Hz, C2Hz, C21Hz, C22Hz, C23Hz, C24Hz, C25Hz, C26Hz, C27Hz, C28Hz, C29Hz, C3Hz, C31Hz, C32Hz, C33Hz, C34Hz, C35Hz, C36Hz, C38Hz, C4Hz, C42Hz, C44Hz, C46Hz, C48Hz, C5Hz, C52Hz, C54Hz, C56Hz, C58Hz, C6Hz);
    -- FREQDE2: div_freq_de2 PORT MAP(R1,CLOCK, C05Hz, C07Hz, C09Hz, C1Hz, C11Hz, C12Hz, C13Hz, C14Hz, C15Hz, C16Hz, C17Hz, C18Hz, C19Hz, C2Hz, C21Hz, C22Hz, C23Hz, C24Hz, C25Hz, C26Hz, C27Hz, C28Hz, C29Hz, C3Hz, C31Hz, C32Hz, C33Hz, C34Hz, C35Hz, C36Hz, C38Hz, C4Hz, C42Hz, C44Hz, C46Hz, C48Hz, C5Hz, C52Hz, C54Hz, C56Hz, C58Hz, C6Hz);
    BSYNC: ButtonSync port map (KEY(0), KEY(1), KEY(2), KEY(3), CLOCK, BTN0, BTN1, BTN2, BTN3);
    
    -- SIGNALS --
    
    win <= win_internal;
    match <= end_User_internal and is_equal;
    end_user <= end_User_internal;
    NBTN <= not (BTN3 & BTN2 & BTN1 & BTN0);
    NOTKEYS <= not KEY;
    
    -- COUNTERS --
    
    c1aux <= E2 and C1Hz;
    c2aux <= E3 and CLKHZ;
    E_Counter_User <= (((NBTN(3) or NBTN(2) or NBTN(1) or NBTN(0))) and E2);
    
    COUNTERTIME: Counter_time port map(CLOCK, R2, c1aux, TEMPO, end_time);
    COUNTERROUND: Counter_round port map(SETUP (3 downto 0), CLOCK, R1, E4, win_internal, ROUND);
    COUNTERFPGA: Counter_FPGA port map(CLOCK, R2, c2aux, ROUND, end_FPGA, SEQFPGA);
    COUNTERUSER: Counter_User port map (CLOCK, R2, E_Counter_User, ROUND, end_User_internal);
    
    -- REG --
    
    REGSETUP: REG_Setup port map (CLOCK, R1, E1, SWITCH, SETUP);
    
    data_REG_FPGA <= SEQ_FPGA & OUT_FPGA(63 downto 4);
    REGFPGA: REG_FPGA port map(CLOCK, R2, c2aux, data_REG_FPGA, OUT_FPGA);
    
    data_REG_user <= NBTN & OUT_USER(63 downto 4);
    REGUSER: Reg_User port map(CLOCK, R2, E_Counter_User, data_REG_user, OUT_USER);

    -- MUX --
    
    M161a: MUX16X1 port map(ROUND, C05Hz, C07Hz, C09Hz, C11Hz, C13Hz, C15Hz, C17Hz, C19Hz, C21Hz, C23Hz, C25Hz, C27Hz, C29Hz, C31Hz, C33Hz, C35Hz, saida0mux16_1);
    M161b: MUX16X1 port map(ROUND, C1Hz, C12Hz, C14Hz, C16Hz, C18Hz, C2Hz, C22Hz, C24Hz, C26Hz, C28Hz, C3Hz, C32Hz, C34Hz, C36Hz, C38Hz, C4Hz, saida1mux16_1);
    M161c: MUX16X1 port map(ROUND, C2Hz, C22Hz, C24Hz, C26Hz, C28Hz, C3Hz, C32Hz, C34Hz, C36Hz, C38Hz, C4Hz, C42Hz, C44Hz, C46Hz, C48Hz, C5Hz, saida2mux16_1);
    M161d: MUX16X1 port map(ROUND,C3Hz, C32Hz, C34Hz, C36Hz, C38Hz, C4Hz, C42Hz, C44Hz, C46Hz, C48Hz, C5Hz, C52Hz, C54Hz, C56Hz, C58Hz, C6Hz, saida3mux16_1);
    MCLKHZ: MUX4X1 port map (SETUP (7 downto 6), saida0mux16_1, saida1mux16_1, saida2mux16_1, saida3mux16_1, CLKHZ);
    
    MSEQ: MUX4X1_4bits port map (SETUP(5 downto 4), MUX4X1_4bits00, MUX4X1_4bits01, MUX4X1_4bits10, MUX4X1_4bits11, SEQ_FPGA);
    
    HEX5a: MUX2X1_7bits port map(win_internal, "0001110", "1000001",output_Mux0HEX5);
    HEX5b: MUX2X1_7bits port map(SEL, "1000111", output_Mux0HEX5, hex5);
    
    G_dec7segHEX4 <= "00" & SETUP(7 downto 6);
    HEX4SEG: dec7seg port map(G_dec7segHEX4, dec7segHEX4);
    HEX4a: MUX2X1_7bits port map(win_internal, "0001100", "0010010", output_Mux0HEX4);
    HEX4b: MUX2X1_7bits port map(SEL, dec7segHEX4, output_Mux0HEX4, hex4);
    
    HEX3a: MUX2X1_7bits port map(win_internal, "0010000", "0000110", output_Mux0HEX3);
    HEX3b: MUX2X1_7bits port map(SEL, "0000111", output_Mux0HEX3, hex3);
    
    HEX2SEG: dec7seg port map(TEMPO, dec7segHEX2);
    HEX2a: MUX2X1_7bits port map(win_internal, "0001000", "0101111", output_Mux0HEX2);
    HEX2b: MUX2X1_7bits port map(SEL, dec7segHEX2, output_Mux0HEX2, hex2);
    
    HEX1SEG: dec7seg port map(POINTS(7 downto 4), dec7segHEX1);
    HEX1a: MUX2X1_7bits port map(SEL, "0101111", dec7segHEX1, hex1);
    
    HEX0SEGa: dec7seg port map(ROUND, dec7segHEX00);
    HEX0SEGb: dec7seg port map(POINTS(3 downto 0), dec7segHEX01);
    HEX00: MUX2X1_7bits port map(SEL, dec7segHEX00, dec7segHEX01, hex0);
    
    leds <= OUT_FPGA (63 downto 60);
    ledg <= NOTKEYS;
    
    -- SEQ --
    
    SEQ0: decSeq00 port map (SEQFPGA, MUX4X1_4bits00);
    SEQ1: decSeq01 port map (SEQFPGA, MUX4X1_4bits01);
    SEQ2: decSeq10 port map (SEQFPGA, MUX4X1_4bits10);
    SEQ3: decSeq11 port map (SEQFPGA, MUX4X1_4bits11);
    
    -- RESTO --
    
    PONTOS: LOGICA port map(SETUP(7 downto 6), ROUND, SETUP(5 downto 4), POINTS);
    COMPARADOR: COMP port map(OUT_FPGA, OUT_USER, is_equal);

end arc;