-- Arbitro
-- Descrição: Esse circuito é um buffer circular com comprimento de 4 e profundidade de 1 bit,
-- O ponteiro do buffer é incrementado a cada ciclo de clock, quando o ponteiro chega ao final do buffer,
-- ele é resetado para 0

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Arbitro is
    Port (  clk : in bit;
            --rst : in std_logic;
            reqn : in bit;
            reqs : in bit;
            reql : in bit;
            reqo : in bit;

            actn : out bit;
            acts : out bit;
            actl : out bit;
            acto : out bit;
            
            sel : out bit_vector(0 to 2) --SELECTOR
    );
end entity Arbitro;


architecture Behavioral of Arbitro is
    signal ptr : std_logic_vector(0 to 1) := "00";
    signal reset : bit := '1';
    signal reqn2, reqs2, reql2, reqo2 : bit;
    signal act : bit_vector(0 to 3) := "0000";

begin
    mem   : entity work.Registrador4Bits
    port map ( 
        d(0) => reqn,
        d(1) => reqs,
        d(2) => reql,
        d(3) => reqo,
        clk => clk, -- clock
        clrn => '1',
        ena => '1',
        q(0) => reqn2,
        q(1) => reqs2,
        q(2) => reql2,
        q(3) => reqo2
        );-- data output

    count :   entity work.Contador
    port map (  d => "00", 
                clk => clk,
                clrn => '1',
                ena => '1',
                load => '0',
                q => ptr );
    process(clk)
    begin
        if (clk'EVENT AND clk='1') then
            if ptr = "00" then
                if reqn = '1' then
                    act <= "1000";
                else
                    act <= "0000";
                end if;
            elsif ptr = "01" then
                if reqs = '1' then
                    act <= "0100";
                else
                    act <= "0000";
                end if;
            elsif ptr = "10" then
                if reql = '1' then
                    act <= "0010";
                else
                    act <= "0000";
                end if;
            elsif ptr = "11" then
                if reqo = '1' then
                    act <= "0001";
                else
                    act <= "0000";
                end if;
            end if;
        end if;
    end process;

    actn <= act(0);
    acts <= act(1);
    actl <= act(2);
    acto <= act(3);
    
    sel <= "001" when act(0) = '1' else
           "010" when act(1) = '1' else
           "011" when act(2) = '1' else
           "100" when act(3) = '1' else
           "000";
end architecture Behavioral;