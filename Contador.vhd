LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_unsigned.ALL;
ENTITY Contador IS
    GENERIC(W : NATURAL := 2);
    PORT (  d : IN STD_LOGIC_VECTOR(W-1 DOWNTO 0);-- data input
            clk : IN BIT; -- clock
            clrn: IN BIT; -- clear
            ena: IN BIT; -- enable
            load: IN BIT; -- load
            q : BUFFER STD_LOGIC_VECTOR(W-1 DOWNTO 0));-- data output
END Contador;

ARCHITECTURE arch_1 OF Contador IS
BEGIN

    PROCESS(clk,clrn)
        BEGIN
        IF (clrn='0') THEN
            q <= (OTHERS => '0');
        ELSIF (clk'EVENT AND clk='1') THEN
            IF (ena='1') THEN
                IF (load='1') THEN
                    q <= d;
                ELSE
                    q <= q+1;
                END IF;
            END IF;
        END IF;
    END PROCESS;
END arch_1;