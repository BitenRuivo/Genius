LIBRARY IEEE;
USE IEEE.Std_Logic_1164.all;
USE IEEE.std_logic_arith.all;
USE IEEE.std_logic_unsigned.all;

ENTITY Topo IS
PORT(
	-- Entradas
	-- CLOCK_50: IN std_logic; -- Ativar para FPGA
	CLK_500Hz: IN std_logic; --Ativar para o Emulador
	KEY: IN std_logic_vector(3 DOWNTO 0);
	SW: IN std_logic_vector(9 DOWNTO 0);
	-- Saídas
	LEDR: OUT std_logic_vector(4 DOWNTO 0);
	LEDG: OUT std_logic_vector(17 DOWNTO 14);
	HEX0: OUT std_logic_vector(6 DOWNTO 0);
	HEX1: OUT std_logic_vector(6 DOWNTO 0);
	HEX2: OUT std_logic_vector(6 DOWNTO 0);
	HEX3: OUT std_logic_vector(6 DOWNTO 0);
	HEX4: OUT std_logic_vector(6 DOWNTO 0);
	HEX5: OUT std_logic_vector(6 DOWNTO 0);
	HEX6: OUT std_logic_vector(6 DOWNTO 0);
	HEX7: OUT std_logic_vector(6 DOWNTO 0)
);
END ENTITY;

ARCHITECTURE arc OF Topo IS

	
---------------------------COMPONENTS------------------------------------

---------------------------Datapath--------------------------------------
COMPONENT Datapath IS
PORT(
	CLOCK: IN std_logic;
	KEY: IN std_logic_vector(3 DOWNTO 0);
	SWITCH: IN std_logic_vector(7 DOWNTO 0);
	R1, R2, E1, E2, E3, E4: IN std_logic;
	SEL: IN std_logic;
	hex0, hex1, hex2, hex3, hex4, hex5: OUT std_logic_vector(6 DOWNTO 0);
	leds: OUT std_logic_vector(3 DOWNTO 0);
	ledg: out std_logic_vector(3 downto 0);
	end_FPGA, end_User, end_time, win, match: OUT std_logic
);
END COMPONENT;
---------------------------Controle--------------------------------------
COMPONENT Controle IS
PORT(
	CLOCK: IN std_logic;
	enter: IN std_logic;
	reset: IN std_logic;
	end_FPGA, end_User, end_time, win, match: IN std_logic;
	R1, R2, E1, E2, E3, E4: OUT std_logic;
	SEL: OUT std_logic
);
END COMPONENT;
-----------------------------SIGNALS-------------------------------------
--CLOCK---------------------------------------------
	SIGNAL clock: std_logic;
	
--PMControle----------------------------------------
	SIGNAL R1: std_logic;
	SIGNAL R2: std_logic;
	SIGNAL E1: std_logic;
	SIGNAL E2: std_logic;
	SIGNAL E3: std_logic;
	SIGNAL E4: std_logic;
	SIGNAL end_FPGA: std_logic;
	SIGNAL end_User: std_logic;
	SIGNAL end_time: std_logic;
	SIGNAL win: std_logic;
	SIGNAL match: std_logic;
	SIGNAL SEL: std_logic;


BEGIN

	clock <= CLK_500Hz; --emulador
    --clock <= CLOCK_50; --FPGA
    
	LEDR(4) <= win;
	HEX6 <= "1111111";
	HEX7 <= "1111111";
	 
	CTRL: Controle port map(clock, SW(0), SW(1), end_FPGA, end_User, end_time, win, match, R1, R2, E1, E2, E3, E4, SEL);
	                         
	DATA: Datapath port map(clock, KEY, SW(9 downto 2), R1, R2, E1, E2, E3, E4, SEL, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, LEDR(3 downto 0), LEDG, end_FPGA, end_User, end_time, win, match);

END ARCHITECTURE;