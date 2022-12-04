ENTITY Comparador IS
	PORT( SIGNAL e : IN BIT_VECTOR(3 DOWNTO 0);
	      SIGNAL s : OUT BIT );
END Comparador;

ARCHITECTURE structural OF Comparador IS

BEGIN
	s <= (NOT e(3)) AND (e(2) OR e(1) OR e(0));
END structural;