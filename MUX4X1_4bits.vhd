LIBRARY ieee;
USE ieee.std_logic_1164.all;
ENTITY MUX4X1_4bits IS
PORT ( 
    SEL : in std_logic_vector(1 downto 0);
    A, B, C, D : in std_logic_vector(3 downto 0);
    Y : out std_logic_vector(3 downto 0));
END MUX4X1_4bits;

ARCHITECTURE mux OF MUX4X1_4bits IS
BEGIN
    
    WITH SEL SELECT
    
    Y <= A WHEN "00",
         B WHEN "01",
         C WHEN "10",
         D WHEN others;

END mux ;