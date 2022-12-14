library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
entity Bu is
  generic (
    g_WIDTH : natural := 8;
    g_DEPTH : natural := 4
    );
  port (
    i_rst_sync : in bit;
    i_clk      : in bit;
 
    -- Dados de escrita 
    i_wr_en   : in  bit;
    i_wr_data : in  bit_vector(g_WIDTH-1 downto 0);
    o_full    : out bit;
 
    -- Dados de leitura
    i_rd_en   : in  bit;
    o_rd_data : out bit_vector(g_WIDTH-1 downto 0);
    o_empty   : out bit
    );
end entity Bu;
 
architecture rtl of Bu is
  type t_FIFO_DATA is array (0 to g_DEPTH-1) of bit_vector(g_WIDTH-1 downto 0);
  signal r_FIFO_DATA : t_FIFO_DATA := (others => (others => '0'));
 
  signal r_WR_INDEX   : integer range 0 to g_DEPTH-1 := 0;
  signal r_RD_INDEX   : integer range 0 to g_DEPTH-1 := 0;
 
  -- Quantidade de dados no buffer maior para evitar overflow
  signal r_FIFO_COUNT : integer range -1 to g_DEPTH+1 := 0;
 
  signal w_FULL  : bit;
  signal w_EMPTY : bit;
   
begin
  p_CONTROL : process (i_clk) is
  begin
    if rising_edge(i_clk) then
      if i_rst_sync = '1' then
        r_FIFO_COUNT <= 0;
        r_WR_INDEX   <= 0;
        r_RD_INDEX   <= 0;
      else
 
        -- Atualização de quantos dados tem no buffer
        if (i_wr_en = '1' and i_rd_en = '0') then
          r_FIFO_COUNT <= r_FIFO_COUNT + 1;
        elsif (i_wr_en = '0' and i_rd_en = '1') then
          r_FIFO_COUNT <= r_FIFO_COUNT - 1;
        end if;
 
        -- Atualiza o ponteiro de escrita, voltando pro começo caso chegue no final
        if (i_wr_en = '1' and w_FULL = '0') then
          if r_WR_INDEX = g_DEPTH-1 then
            r_WR_INDEX <= 0;
          else
            r_WR_INDEX <= r_WR_INDEX + 1;
          end if;
        end if;
 
        -- Atualiza o ponteiro de leitura, voltando pro começo caso chegue no final.    
        if (i_rd_en = '1' and w_EMPTY = '0') then
          if r_RD_INDEX = g_DEPTH-1 then
            r_RD_INDEX <= 0;
          else
            r_RD_INDEX <= r_RD_INDEX + 1;
          end if;
        end if;
 
        -- Quando tem escrita, escreve o dado no buffer
        if i_wr_en = '1' then
          r_FIFO_DATA(r_WR_INDEX) <= i_wr_data;
        end if;
         
      end if;                           
    end if;                             
  end process p_CONTROL;
   
  o_rd_data <= r_FIFO_DATA(r_RD_INDEX);
 
  w_FULL  <= '1' when r_FIFO_COUNT = g_DEPTH else '0';
  w_EMPTY <= '1' when r_FIFO_COUNT = 0       else '0';
 
  o_full  <= w_FULL;
  o_empty <= w_EMPTY;
end architecture rtl;