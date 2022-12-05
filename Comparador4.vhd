ENTITY Comparador4 IS
	PORT( SIGNAL x : IN BIT_VECTOR(3 DOWNTO 0); 
         SIGNAL y : IN BIT_VECTOR(3 DOWNTO 0);
	      SIGNAL s : OUT BIT );
END Comparador4;

ARCHITECTURE structural OF Comparador4 IS

BEGIN
	s <= y(3) AND (NOT (x(0) OR x(1) OR x(2) OR x(3)));
END structural;