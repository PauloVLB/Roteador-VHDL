-- Arbitro
-- Descrição: Esse circuito é um buffer circular com comprimento de 4 e profundidade de 1 bit,
-- O ponteiro do buffer é incrementado a cada ciclo de clock, quando o ponteiro chega ao final do buffer,
-- ele é resetado para 0

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Arbitro is
    Port (  clk : in std_logic;
            --rst : in std_logic;
            reqn : in bit;
            reqs : in bit;
            reql : in bit;
            reqo : in bit;

            act : out bit_vector(0 downto 3);
            
            sel : out std_logic_vector(0 to 2) --SELECTOR
    );
end entity Arbitro;


architecture Behavioral of Arbitro is
    signal ptr : std_logic_vector(0 to 1) := "00";
    signal rest : bit := '1';
    signal reqn2, reqs2, reql2, reqo2 : bit;

begin
    mem   : entity work.Registrador4Bits
    port map ( 
        d(0) => reqn,
        d(1) => reqs,
        d(2) => reql,
        d(3) => reqo,
        clk => clk, -- clock
        clrn: => '1',
        ena : '1',
        q(0) => reqn2,
        q(1) => reqs2,
        q(2) => reql2,
        q(3) => reqo2
        );-- data output

    count :   entity work.Contador
    port map (  d => '0', 
                clk => clk,
                clrn => reset,
                ena: => andar,
                load: => '0',
                q => ptr )
    process(clk)
    if ptr = "11" then reset <= '0';

    if ptr = "00" then
        if reqn2 = '1' then
            act <= "1000";
            sel <= "001"; -- "001" corresponde a entrada norte no demux
        else
            act <= "0000";
            sel <= "000";
        end if;
    elsif ptr = "01" then
        if reqs2 = '1' then
            act <= "0100";
            sel <= "010"; -- "010" corresponde a entrada sul no demux
        else
            act <= "0000";
            sel <= "000";
        end if;
    elsif ptr = "10" then
        if reql2 = '1' then
            act <= "0010";
            sel <= "011"; -- "011" corresponde a entrada leste no demux
        else
            act <= "0000";
            sel <= "000";
        end if;
    elsif ptr = "11" then
        if reqo2 = '1' then
            act <= "0001";
            sel <= "100"; -- "100" corresponde a entrada oeste no demux
        else
            act <= "0000";
            sel <= "000";
        end if;
    end if;
    
    end 
    process;
            

    

    begin
        if rising_edge(clk) then
        end if;
    end 
    process;
    act <= req;
    sel <= ptr;
end architecture Behavioral;