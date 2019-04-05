architecture successive of fp4 is
	component fp1
		port(
			a,b,cin:in std_logic;
			s,cout:out std_logic;
			p,g:buffer std_logic
		);
	end component;
	signal p,g,c:std_logic_vector(3 downto 0);
begin
	fa0:fp1 port map(a(0),b(0),cin,s(0),c(0),p(0),g(0));
	fa1:fp1 port map(a(1),b(1),c(0),s(1),c(1),p(1),g(1));
	fa2:fp1 port map(a(2),b(2),c(1),s(2),c(2),p(2),g(2));
	fa3:fp1 port map(a(3),b(3),c(2),s(3),cout,p(3),g(3));	
end successive;

