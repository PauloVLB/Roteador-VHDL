-- Arbitro
-- Descrição: Esse circuito é um buffer circular com comprimento de 4 e profundidade de 1 bit,
-- O ponteiro do buffer é incrementado a cada ciclo de clock, quando o ponteiro chega ao final do buffer,
-- ele é resetado para 0

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Arbitro is
    Port (  clk : in bit;
            
            -- Entradas quem vêm do buffer
            n_in : in bit_vector(7 downto 0);
            s_in : in bit_vector(7 downto 0);
            l_in : in bit_vector(7 downto 0);
            o_in : in bit_vector(7 downto 0);

            -- Sinais do roteamento
            reqn : in bit;
            reqs : in bit;
            reql : in bit;
            reqo : in bit;

            -- Sinais para leitura do buffer
            actn : out bit;
            acts : out bit;
            actl : out bit;
            acto : out bit;

            -- Pacote de saída
            p_out : out bit_vector(7 downto 0)            
    );
end entity Arbitro;


architecture Behavioral of Arbitro is
    signal ptr : integer range 0 to 3 := 0;
    signal act : bit_vector(0 to 3) := "0000";

    signal y_n, y_s, x_l, x_o : bit_vector(3 downto 0);
    
    COMPONENT SomadorCompleto PORT (
        a : IN BIT_VECTOR (3 DOWNTO 0);
        b : IN BIT_VECTOR (3 DOWNTO 0);
        cin : IN BIT;
        cout : OUT BIT;
        sum  : OUT BIT_VECTOR (3 DOWNTO 0));
    END COMPONENT;
begin
    -- y_n <= n_in(7 downto 4); 00010011
    -- y_s <= s_in(7 downto 4);
    -- x_l <= l_in(3 downto 0);
    -- x_o <= o_in(3 downto 0);

    sc3 : SomadorCompleto PORT MAP (a => n_in(7 downto 4), b => "0001", cin => '0', sum => y_n);
    sc2 : SomadorCompleto PORT MAP (a => s_in(7 downto 4), b => "1111", cin => '0', sum => y_s);
    sc1 : SomadorCompleto PORT MAP (a => l_in(3 downto 0), b => "1111", cin => '0', sum => x_l);
    sc4 : SomadorCompleto PORT MAP (a => o_in(3 downto 0), b => "0001", cin => '0', sum => x_o);

    ptr_control : process(clk)
    begin
        if rising_edge(clk) then
            if ptr = 3 then
                ptr <= 0;
            else
                ptr <= ptr + 1;
            end if;
        end if;
    end process ptr_control;
    
    ring_buffer : process(clk)
    begin
        if rising_edge(clk) then
            if (ptr = 0 and reqn = '1') then
                act <= "1000";
            elsif (ptr = 1 and reqs = '1') then
                act <= "0100";
            elsif (ptr = 2 and reql = '1') then
                act <= "0010";
            elsif (ptr = 3 and reqo = '1') then
                act <= "0001";
            else
                act <= "0000";
            end if;
        end if;
    end process ring_buffer;
    
    actn <= act(0);
    acts <= act(1);
    actl <= act(2);
    acto <= act(3);
    
    p_out <= n_in(3 downto 0) & y_n when act(0) = '1' else
             s_in(3 downto 0) & y_s when act(1) = '1' else
             x_l & l_in(7 downto 4) when act(2) = '1' else
             x_o & o_in(7 downto 4) when act(3) = '1' else
             "00000000";

    -- p_out <= n_in when act(0) = '1' else
    --          s_in when act(1) = '1' else
    --          l_in when act(2) = '1' else
    --          o_in when act(3) = '1' else
    --          "00000000";
             
end architecture Behavioral;