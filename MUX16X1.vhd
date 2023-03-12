LIBRARY ieee;
USE ieee.std_logic_1164.all;
ENTITY MUX16X1 IS
PORT(
    SEL : in std_logic_vector(3 downto 0);
    A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P : in std_logic;
    Y : out std_logic);
END MUX16X1;
ARCHITECTURE mux OF MUX16X1 IS

BEGIN
    
    WITH SEL SELECT
    
    Y <= A WHEN "0000",
         B WHEN "0001",
         C WHEN "0010",
         D WHEN "0011",
         E WHEN "0100",
         F WHEN "0101",
         G WHEN "0110",
         H WHEN "0111",
         I WHEN "1000",
         J WHEN "1001",
         K WHEN "1010",
         L WHEN "1011",
         M WHEN "1100",
         N WHEN "1101",
         O WHEN "1110",
         P WHEN others;

END mux ;