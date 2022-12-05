ENTITY Comparador3 IS
	PORT(SIGNAL x : IN BIT_VECTOR(3 DOWNTO 0); 
         SIGNAL y : IN BIT_VECTOR(3 DOWNTO 0);
	     SIGNAL s : OUT BIT );
END Comparador3;

ARCHITECTURE structural OF Comparador3 IS

BEGIN
	s <= (NOT y(3)) AND (y(2) OR y(1) OR y(0)) AND (NOT (x(0) OR x(1) OR x(2) OR x(3)));
END structural;