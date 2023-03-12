LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;

ENTITY decSeq00 IS
PORT(
	address: IN std_logic_vector(3 DOWNTO 0);
	output: OUT std_logic_vector(3 DOWNTO 0)
);
END decSeq00;

ARCHITECTURE arc OF decSeq00 IS
BEGIN
	output <= 	"0001" WHEN address="0000" ELSE
					"0010" WHEN address="0001" ELSE
					"1000" WHEN address="0010" ELSE
					"0100" WHEN address="0011" ELSE
					"0010" WHEN address="0100" ELSE
					"0100" WHEN address="0101" ELSE
					"0100" WHEN address="0110" ELSE
					"0001" WHEN address="0111" ELSE
					"1000" WHEN address="1000" ELSE
					"1000" WHEN address="1001" ELSE
					"0001" WHEN address="1010" ELSE
					"0100" WHEN address="1011" ELSE
					"0010" WHEN address="1100" ELSE
					"0001" WHEN address="1101" ELSE
					"0100" WHEN address="1110" ELSE
					"0010" WHEN address="1111";
END ARCHITECTURE;
