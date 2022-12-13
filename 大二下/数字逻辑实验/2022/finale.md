# Finale

- 模板

```vhdl
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

entity finale is
	port(
		clk: in std_logic;
		clock: in std_logic;
		long: buffer std_logic;
		short: buffer std_logic;
		rst: in std_logic;
		display: out std_logic_vector(3 downto 0);
        state: buffer std_logic_vector(4 downto 0):="00000"
	);
end finale;

architecture encoding of finale is
	signal count: integer:= 0;
	signal index: integer:=0;
    signal lock: integer:=0;
begin

	process()
	begin
		
	end process;
end encoding;
```

- code

```vhdl
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity Review is
	port(
		clk, rst, mclk: in std_logic;
		mode, stop:in std_logic;
		dis_sudu, dis_dangwei:out std_logic_vector(3 downto 0)
	);
end Review;

architecture Final of Review is
signal count:integer range 0 TO 1000000:=0;
signal dangwei, sudu:integer range 0 TO 10:=0;
begin
	process(mclk, clk, rst)
	begin
		if (mclk = '1' and mclk'event) then
			dangwei <= sudu / 2 + 1;
			if (rst='1') then
				sudu <= 0;
				count <= 0;
				dangwei <= 1;
			else
				if (stop = '1') then
					count <= count + 1;
					if (count >= 1000000) then
						count <= 0;
						if (sudu >0) then
							sudu <= sudu - 1;
						end if;
					end if;
				else
					if (mode = '1') then
						count <= count + 1;
						if (count >= 1000000) then
							count <= 0;
							if (sudu < 9) then
								sudu <= sudu + 1;
							end if;
						end if;
					else
						NULL;
					end if;
				end if;
			end if;
		end if;
	end process;
	process(sudu, dangwei)
	begin
		case sudu is
			when 0=>dis_sudu<="0000";
			when 1=>dis_sudu<="0001";
			when 2=>dis_sudu<="0010";
			when 3=>dis_sudu<="0011";
			when 4=>dis_sudu<="0100";
			when 5=>dis_sudu<="0101";
			when 6=>dis_sudu<="0110";
			when 7=>dis_sudu<="0111";
			when 8=>dis_sudu<="1000";
			when 9=>dis_sudu<="1001";
			when others=>null;
		end case;
		case dangwei is
			when 1=>dis_dangwei<="0001";
			when 2=>dis_dangwei<="0010";
			when 3=>dis_dangwei<="0011";
			when 4=>dis_dangwei<="0100";
			when 5=>dis_dangwei<="0101";
			when others=>null;
		end case;
	end process;
end Final;
```