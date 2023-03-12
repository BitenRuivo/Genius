library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_arith.all; 
use IEEE.std_logic_unsigned.all;
entity LOGICA is port (
    LVL : in std_logic_vector(1 downto 0); -- SETUP(9..8)
    RND : in std_logic_vector(3 downto 0); -- ROUND
    SEQ : in std_logic_vector(1 downto 0); -- SETUP(7..6)
    Y : out std_logic_vector(7 downto 0)); -- POINTS
end LOGICA;
architecture points of LOGICA is
  begin

  Y <= LVL & RND & SEQ;
    
 end points;