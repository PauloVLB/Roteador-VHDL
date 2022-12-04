ENTITY Main IS
    PORT( SIGNAL x : IN BIT_VECTOR(3 DOWNTO 0);
          SIGNAL y : IN BIT_VECTOR(3 DOWNTO 0);
	  SIGNAL n : OUT BIT;
	  SIGNAL s : OUT BIT;
	  SIGNAL l : OUT BIT;
	  SIGNAL o : OUT BIT );
END Main;

ARCHITECTURE structural OF Main IS
    COMPONENT SomadorCompleto PORT (
        a : IN BIT_VECTOR (3 DOWNTO 0);
        b : IN BIT_VECTOR (3 DOWNTO 0);
        cin : IN BIT;
        cout : OUT BIT;
        sum  : OUT BIT_VECTOR (3 DOWNTO 0));
    END COMPONENT;

    COMPONENT Comparador PORT( 
          e : IN BIT_VECTOR(3 DOWNTO 0);
	      s : OUT BIT );
    END COMPONENT;

    COMPONENT Comparador2 PORT( 
          e : IN BIT_VECTOR(3 DOWNTO 0);
	      s : OUT BIT );
    END COMPONENT;

    SIGNAL t1 : BIT;
    SIGNAL t2 : BIT;
    SIGNAL t3 : BIT;
    SIGNAL t4 : BIT;
    SIGNAL succX : BIT_VECTOR(3 DOWNTO 0);
    SIGNAL antX : BIT_VECTOR(3 DOWNTO 0);
    SIGNAL succY : BIT_VECTOR(3 DOWNTO 0);
    SIGNAL antY : BIT_VECTOR(3 DOWNTO 0);

    SIGNAL XP : BIT;
    SIGNAL XN : BIT;
    SIGNAL YP : BIT;
    SIGNAL YN : BIT;
BEGIN
    sc1 : SomadorCompleto PORT MAP (a => x, b => "0001", cin => '0', cout => t1, sum => succX);
    sc2 : SomadorCompleto PORT MAP (a => x, b => "1111", cin => '0', cout => t2, sum => antX);
    sc3 : SomadorCompleto PORT MAP (a => y, b => "0001", cin => '0', cout => t3, sum => succY); 
    sc4 : SomadorCompleto PORT MAP (a => y, b => "1111", cin => '0', cout => t4, sum => antY);

    comp1 : Comparador PORT MAP(e => x, s => l);
    comp2 : Comparador2 PORT MAP(e => x, s => o);
    comp3 : Comparador PORT MAP(e => y, s => s);
    comp4 : Comparador2 PORT MAP(e => y, s => n);
END structural;