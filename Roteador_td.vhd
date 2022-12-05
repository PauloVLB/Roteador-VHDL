--Test banch para o roteador

library ieee;
use ieee.std_logic_1164.all;

entity Roteador_td is
end Roteador_td;

architecture Behavioral of Roteador_td is
    signal r_clk : bit;
    
    signal inN : bit_vector(7 downto 0);
    signal inS : bit_vector(7 downto 0);
    signal inL : bit_vector(7 downto 0);
    signal inO : bit_vector(7 downto 0);

    signal outN : bit_vector(7 downto 0);
    signal outS : bit_vector(7 downto 0);
    signal outL : bit_vector(7 downto 0);
    signal outO : bit_vector(7 downto 0);

    component Roteador is
        port (
            in_n : IN  BIT_VECTOR(7 DOWNTO 0);
            out_n : OUT  BIT_VECTOR(7 DOWNTO 0);
    
            in_s : IN  BIT_VECTOR(7 DOWNTO 0);
            out_s : OUT  BIT_VECTOR(7 DOWNTO 0);
    
            in_l : IN  BIT_VECTOR(7 DOWNTO 0);
            out_l : OUT  BIT_VECTOR(7 DOWNTO 0);
    
            in_o : IN  BIT_VECTOR(7 DOWNTO 0);
            out_o : OUT  BIT_VECTOR(7 DOWNTO 0);
            
            in_clk : IN BIT
          );
      end component Roteador;
begin
    roteador : Roteador
        port map (
            in_n => inN,
            out_n => outN,
    
            in_s => inS,
            out_s => outS,
    
            in_l => inL,
            out_l => outL,
    
            in_o => inO,
            out_o => outO,
            
            in_clk => r_clk
        );
    r_clk <= not r_clk after 10 ns;


    process
    begin
        inN <= "00000000";
        inS <= "00000001";
        inL <= "00000010";
        inO <= "00000011";
        wait until r_clk = '1';
        inN <= "00000000";
        inS <= "00010000";
        inL <= "00100000";
        inO <= "00110011";
        wait until r_clk = '1';
        inN <= "00000100";
        inS <= "00000101";
        inL <= "00000110";
        inO <= "00000111";
        wait until r_clk = '1';
        inN <= "01000000";
        inS <= "01010000";
        inL <= "01100000";
        inO <= "01110000";
        wait until r_clk = '1';
        inN <= "00001000";
        inS <= "00001001";
        inL <= "00001010";
        inO <= "00001011";
        wait until r_clk = '1';
        inN <= "10000000";
        inS <= "10010000";
        inL <= "10100000";
        inO <= "10110000";
        wait until r_clk = '1';
    end process;
end Behavioral;

