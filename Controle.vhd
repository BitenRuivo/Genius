LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY Controle IS
PORT(
	-- Entradas de controle
	CLOCK: IN std_logic;
	enter: IN std_logic;
	reset: IN std_logic;
	-- Entradas de status
	end_FPGA, end_User, end_time, win, match: IN std_logic;
	-- Saídas de comandos
	R1, R2, E1, E2, E3, E4: OUT std_logic;
	SEL: OUT std_logic
	-- Saídas de controle
);
END Controle;

ARCHITECTURE arc OF Controle IS
	TYPE STATES IS (Init, Setup, Play_FPGA, Play_User, Check, Next_Round, Result);
	SIGNAL EA, PE: STATES;
BEGIN
	
    process(clock,reset)
    begin
        if (reset = '1') then
            EA <= init;
        elsif (clock'event AND clock = '1') then 
             EA <= PE;
        end if;
    end process;
    
    process(EA, enter, end_FPGA, end_User, end_time, win, match)
    begin
        case EA is
            when INIT =>    
                            R1 <= '1';
                            R2 <= '1';
                            E1 <= '0';
                            E2 <= '0';
                            E3 <= '0';
                            E4 <= '0';
                            SEL <= '0';
                            PE <= SETUP;
                            
            when SETUP =>
                            R1 <= '0';
                            R2 <= '0';
                            E1 <= '1';
                            E2 <= '0';
                            E3 <= '0';
                            E4 <= '0';
                            SEL <= '0';
                            if enter = '0' then
                                PE <= SETUP;
                            else
                                PE <= PLAY_FPGA;
                            end if;
            
            when PLAY_FPGA =>
                            R1 <= '0';
                            R2 <= '0';
                            E1 <= '0';
                            E2 <= '0';
                            E3 <= '1';
                            E4 <= '0';
                            SEL <= '0';
                            if END_FPGA = '0' then
                                PE <= PLAY_FPGA;
                            elsif END_FPGA = '1' then
                                PE <= PLAY_USER;
                            end if;
            
            when PLAY_USER =>
                            R1 <= '0';
                            R2 <= '0';
                            E1 <= '0';
                            E2 <= '1';
                            E3 <= '0';
                            E4 <= '0';
                            SEL <= '0';
                            if (END_USER = '0') and (END_TIME = '0') then
                                PE <= PLAY_USER;
                            elsif END_TIME = '1' then
                                PE <= RESULT;
                            elsif END_USER = '1' then
                                PE <= CHECK;
                            end if;
                            
            when CHECK =>
                            R1 <= '0';
                            R2 <= '0';
                            E1 <= '0';
                            E2 <= '0';
                            E3 <= '0';
                            SEL <= '0';
                            if match = '0' then
                                PE <= RESULT;
                                E4 <= '0';
                            elsif match = '1' then
                                PE <= NEXT_ROUND;
                                E4 <= '1';
                            end if;
                            
            when NEXT_ROUND =>
                            R1 <= '0';
                            R2 <= '1';
                            E1 <= '0';
                            E2 <= '0';
                            E3 <= '0';
                            E4 <= '0';
                            SEL <= '0';
                            if win = '0' then
                                PE <= PLAY_FPGA;
                            elsif win = '1' then
                                PE <= RESULT;
                            end if;
                            
            when RESULT =>
                            R1 <= '0';
                            R2 <= '0';
                            E1 <= '0';
                            E2 <= '0';
                            E3 <= '0';
                            E4 <= '0';
                            SEL <= '1';
                            PE <= RESULT;

        end case;
    end process;
END arc;