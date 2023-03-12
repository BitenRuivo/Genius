library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_arith.all; 
use IEEE.std_logic_unsigned.all;
entity COMP is port (
    A, B : in std_logic_vector(63 downto 0);
    Y : out std_logic);
end COMP;
architecture comparacao of COMP is
begin
    process(A, B)
    begin
        if (A = B) then
            Y <= '1';
        else
            Y <= '0';
        end if;
    end process; 
 end comparacao;