LIBRARY ieee;
USE ieee.std_logic_1164.all;
ENTITY MUX2X1_4bits IS
PORT (
    SEL : in std_logic;
    A, B : in std_logic_vector(3 downto 0);
    Y : out std_logic_vector(3 downto 0));
END MUX2X1_4bits;
ARCHITECTURE mux OF MUX2X1_4bits IS

BEGIN
    
    WITH SEL SELECT
    Y <= A WHEN '0',
         B WHEN OTHERS;
         
END mux ;