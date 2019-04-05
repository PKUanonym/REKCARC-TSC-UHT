architecture advance of fp4 is
	component fp1
		port(
			a,b,cin:in std_logic;
			s,cout:out std_logic;
			p,g:buffer std_logic
		);
	end component;
	signal p,g,c:std_logic_vector(3 downto 0);
begin
	fa0:fp1 port map(a(0),b(0),cin,s=>s(0),p=>p(0),g=>g(0));
	fa1:fp1 port map(a(1),b(1),c(0),s=>s(1),p=>p(1),g=>g(1));
	fa2:fp1 port map(a(2),b(2),c(1),s=>s(2),p=>p(2),g=>g(2));
	fa3:fp1 port map(a(3),b(3),c(2),s=>s(3),p=>p(3),g=>g(3));	
	process(p,g)
	begin
		c(0)<=g(0) or (p(0) and cin);
		c(1)<=g(1) or (p(1) and g(0)) or (p(1) and p(0) and cin);
		c(2)<=g(2) or (p(2) and g(1)) or (p(2) and p(1) and g(0)) or (p(2) and p(1) and p(0) and cin);
		cout<=g(3) or (p(3) and g(2)) or (p(3) and p(2) and g(1)) or (p(3) and p(2) and p(1) and g(0)) or (p(3) and p(2) and p(1) and p(0) and cin);
	end process;
end advance;
