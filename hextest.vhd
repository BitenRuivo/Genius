library IEEE;
use IEEE.Std_Logic_1164.all;
entity hextest is
port(HEX0: out std_logic_vector(6 downto 0));
end hextest;

architecture test of hextest is
begin
HEX0 <= "0000000";

end test;