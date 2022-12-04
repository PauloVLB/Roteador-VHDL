ENTITY Comparador2 IS
	PORT( SIGNAL e : IN BIT_VECTOR(3 DOWNTO 0);
	      SIGNAL s : OUT BIT );
END Comparador2;

ARCHITECTURE structural OF Comparador2 IS

BEGIN
	s <= e(3);
END structural;