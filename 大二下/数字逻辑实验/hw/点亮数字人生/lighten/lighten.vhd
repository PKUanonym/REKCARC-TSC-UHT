LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

entity lighten is
	port(
--		key: in std_logic_vector(3 downto 0);
		display: out std_logic_vector(6 downto 0);
		display_4: out std_logic_vector(3 downto 0);
		display_4_2: out std_logic_vector(3 downto 0);
		clk: in std_logic
	);
end lighten;

architecture fire of lighten is
	signal display_4_buf: std_logic_vector(3 downto 0):="0000";
	signal display_4_buf_odd: std_logic_vector(3 downto 0):="0001";
	signal display_4_buf_even: std_logic_vector(3 downto 0):="0000";
	signal cnt:integer:=0;
begin
	process(clk)
	begin
		if (clk'event and clk='1') then
			if (cnt<1000000) then
				cnt<=cnt+1;
			else
				cnt<=0;
				if (display_4_buf="1001") then
					display_4_buf<="0000";
				else
					display_4_buf<=display_4_buf+1;
				end if;
				if (display_4_buf_even="1000") then
					display_4_buf_even<="0000";
				else
					display_4_buf_even<=display_4_buf_even+2;
				end if;
				if (display_4_buf_odd="1001") then
					display_4_buf_odd<="0001";
				else
					display_4_buf_odd<=display_4_buf_odd+2;
				end if;
				display_4<=display_4_buf_even;
				display_4_2<=display_4_buf_odd;
			end if;
		end if;
	end process;
	process(display_4_buf)
	begin
		case display_4_buf is
			when "0000"=>display<="1111110";
			when "0001"=>display<="0110000";
			when "0010"=>display<="1101101";
			when "0011"=>display<="1111001";
			when "0100"=>display<="0110011";
			when "0101"=>display<="1011011";
			when "0110"=>display<="0011111";
			when "0111"=>display<="1110000";
			when "1000"=>display<="1111111";
			when "1001"=>display<="1110011";
			when "1010"=>display<="1110111";
			when "1011"=>display<="0011111";
			when "1100"=>display<="1001110";
			when "1101"=>display<="0111101";
			when "1110"=>display<="1001111";
			when "1111"=>display<="1000111";
			when others=>display<="0000000";
		end case;
	end process;
end fire;