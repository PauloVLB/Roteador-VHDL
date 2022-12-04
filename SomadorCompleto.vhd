ENTITY SomadorCompleto IS 
PORT (
    a : IN BIT_VECTOR (3 DOWNTO 0);
    b : IN BIT_VECTOR (3 DOWNTO 0);
    cin : IN BIT;
    cout : OUT BIT;
    sum  : OUT BIT_VECTOR (3 DOWNTO 0));
END SomadorCompleto;

ARCHITECTURE structural OF SomadorCompleto IS
    COMPONENT Somador PORT (
        a : IN BIT;
        b : IN BIT;
        cin : IN BIT;
        cout : OUT BIT;
        sum : OUT BIT);
    END COMPONENT;

    SIGNAL c : BIT_VECTOR (3 DOWNTO 1);
BEGIN
    s1 : Somador PORT MAP (a => a(0), b => b(0), cin => cin,  cout => c(1), sum => sum(0)); 
    s2 : Somador PORT MAP (a => a(1), b => b(1), cin => c(1), cout => c(2), sum => sum(1));
    s3 : Somador PORT MAP (a => a(2), b => b(2), cin => c(2), cout => c(3), sum => sum(2)); 
    s4 : Somador PORT MAP (a => a(3), b => b(3), cin => c(3), cout => cout, sum => sum(3)); 
END structural;