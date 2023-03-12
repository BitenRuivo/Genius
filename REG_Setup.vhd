library ieee;
use ieee.std_logic_1164.all;
entity Reg_Setup is port (
	CLK, RST, EN: in std_logic;
	D: in std_logic_vector (7 downto 0);
	Q: out std_logic_vector(7 downto 0));
end Reg_Setup;
architecture reg of Reg_Setup is

begin
	process(CLK,RST, EN, D)
	begin
		if (RST = '1') then
			Q <= "00000000";
		elsif (CLK'event and CLK = '1') then
			if (EN = '1') then
				Q <= D;
			end if;
		end if;
	end process;
end reg;
