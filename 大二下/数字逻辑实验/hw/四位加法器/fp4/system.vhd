architecture system of fp4 is
	signal sys:std_logic_vector(4 downto 0);
begin
	process(a,b)
	begin
		sys<="00000"+a+b+cin;
	end process;
	process(sys)
	begin
		cout<=sys(4);
		s<=sys(3 downto 0);
	end	process;
end system;