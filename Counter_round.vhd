library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_arith.all; 
use IEEE.std_logic_unsigned.all;
entity Counter_round is port(
    D: in std_logic_vector(3 downto 0);
    CLK, RST, EN: in std_logic;
    MAX: out std_logic;
    Y: out std_logic_vector(3 downto 0));
end Counter_round;
architecture count of Counter_round is

signal cnt: std_logic_vector(3 downto 0) := "0000";

  begin
    process(CLK,RST,EN)
    begin
        if (RST = '1') then
            cnt <= "0000";
            MAX <= '0';
        elsif (CLK'event and CLK = '1') then
            if (EN = '1') then
                if (cnt < D) then
                    cnt <= cnt + "0001";
                elsif (cnt = D) then
                    MAX <= '1';
                end if;
            end if;
        end if;
    end process;
  Y <= cnt;
    
 end count;