ENTITY Somador IS PORT (
    a : IN BIT;
    b : IN BIT;
    cin : IN BIT;
    cout : out BIT;
    sum : out BIT
);
END Somador;

ARCHITECTURE structural OF Somador IS
BEGIN
    sum <= a XOR b XOR cin;
    cout <= ((a AND b) or (b AND cin) or (cin AND a));
END structural;