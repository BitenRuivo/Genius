library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_arith.all; 
use IEEE.std_logic_unsigned.all;
entity Counter_FPGA is port (
    CLK, RST, EN: in std_logic;
    D: in std_logic_vector(3 downto 0);
    MAX: out std_logic;
    Y: out std_logic_vector(3 downto 0));
end Counter_FPGA;
architecture count of Counter_FPGA is

signal CNT: std_logic_vector(3 downto 0):= "0000";
begin
    p: process (CLK, RST, EN)
    begin
        if RST= '1' then
            CNT<= "0000";
				MAX <= '0';
        elsif (clk'event and clk = '1') then
            if EN = '1' then
		        CNT <= CNT + 1;
		        if CNT = d then
			        MAX <= '1';
	        	else
			        MAX <= '0';
		        end if;
	       end if;
	    end if;
    end process;
    Y <= CNT;
    
end count;