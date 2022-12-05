ENTITY Roteamento IS
    PORT( SIGNAL x : IN BIT_VECTOR(3 DOWNTO 0);
          SIGNAL y : IN BIT_VECTOR(3 DOWNTO 0);
        SIGNAL n : OUT BIT;
        SIGNAL s : OUT BIT;
        SIGNAL l : OUT BIT;
        SIGNAL o : OUT BIT );
END Roteamento;

ARCHITECTURE structural OF Roteamento IS
    COMPONENT Comparador PORT( 
          e : IN BIT_VECTOR(3 DOWNTO 0);
	      s : OUT BIT );
    END COMPONENT;

    COMPONENT Comparador2 PORT( 
          e : IN BIT_VECTOR(3 DOWNTO 0);
	      s : OUT BIT );
    END COMPONENT;

    COMPONENT Comparador3 PORT( 
          x : IN BIT_VECTOR(3 DOWNTO 0);
	      y : IN BIT_VECTOR(3 DOWNTO 0);
          s : OUT BIT );
    END COMPONENT;

    COMPONENT Comparador4 PORT( 
          x : IN BIT_VECTOR(3 DOWNTO 0);
	      y : IN BIT_VECTOR(3 DOWNTO 0);
          s : OUT BIT );
    END COMPONENT;
BEGIN
    comp1 : Comparador PORT MAP(e => x, s => l);
    comp2 : Comparador2 PORT MAP(e => x, s => o);
    comp3 : Comparador3 PORT MAP(x => x, y => y, s => s);
    comp4 : Comparador4 PORT MAP(x => x, y => y, s => n);
END structural;