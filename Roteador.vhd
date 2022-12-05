library ieee;
use ieee.numeric_std.all;

ENTITY Roteador IS
    PORT( 
        in_n : IN  BIT_VECTOR(7 DOWNTO 0);
        out_n : OUT  BIT_VECTOR(7 DOWNTO 0);

        in_s : IN  BIT_VECTOR(7 DOWNTO 0);
        out_s : OUT  BIT_VECTOR(7 DOWNTO 0);

        in_l : IN  BIT_VECTOR(7 DOWNTO 0);
        out_l : OUT  BIT_VECTOR(7 DOWNTO 0);

        in_o : IN  BIT_VECTOR(7 DOWNTO 0);
        out_o : OUT  BIT_VECTOR(7 DOWNTO 0);
        
        clk : IN BIT
     );
END Roteador;

ARCHITECTURE structural OF Roteador IS
    component BufferFIFO is
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
      end component BufferFIFO;

    COMPONENT Roteamento PORT( 
        x : IN BIT_VECTOR(3 DOWNTO 0);
        y : IN BIT_VECTOR(3 DOWNTO 0);
        n : OUT BIT;
        s : OUT BIT;
        l : OUT BIT;
        o : OUT BIT 
        );
    END COMPONENT;

    COMPONENT Arbitro PORT (  
        clk : in bit;
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
    END COMPONENT;

signal saidaBufferN : BIT_VECTOR(7 DOWNTO 0); 
signal saidaBufferS : BIT_VECTOR(7 DOWNTO 0);
signal saidaBufferL : BIT_VECTOR(7 DOWNTO 0);
signal saidaBufferO : BIT_VECTOR(7 DOWNTO 0); 

signal RnToArbn, RnToArbs, RnToArbl, RnToArbo : BIT;
signal RsToArbn, RsToArbs, RsToArbl, RsToArbo : BIT;
signal RlToArbn, RlToArbs, RlToArbl, RlToArbo : BIT;
signal RoToArbn, RoToArbs, RoToArbl, RoToArbo : BIT;

signal ArbnToBuffern, ArbsToBuffers, ArblToBufferl, ArboToBuffero : BIT;
signal ArbsToBuffern, ArblToBuffers, ArboToBufferl, ArbnToBuffero : BIT;
signal ArblToBuffern, ArboToBuffers, ArbnToBufferl, ArbsToBuffero : BIT;
signal ArboToBuffern, ArbnToBuffers, ArbsToBufferl, ArblToBuffero : BIT;

signal ArbToBufferN, ArbToBufferS, ArbToBufferL, ArbToBufferO : BIT;

BEGIN

    -- Instanciando os Roteamentos
    roteamentoN : Roteamento PORT MAP ( x => in_n(7 downto 4),
                                        y => in_n(3 downto 0),
                                        n => RnToArbn,
                                        s => RnToArbs,
                                        l => RnToArbl,
                                        o => RnToArbo
                                        );
    
    roteamentoS : Roteamento PORT MAP ( x => in_s(7 downto 4),
                                        y => in_s(3 downto 0),
                                        n => RsToArbn,
                                        s => RsToArbs,
                                        l => RsToArbl,
                                        o => RsToArbo
                                        );
    roteamentoL : Roteamento PORT MAP ( x => in_l(7 downto 4),
                                        y => in_l(3 downto 0),
                                        n => RlToArbn,
                                        s => RlToArbs,
                                        l => RlToArbl,
                                        o => RlToArbo
                                        );
    roteamentoO : Roteamento PORT MAP ( x => in_o(7 downto 4),
                                        y => in_o(3 downto 0),
                                        n => RoToArbn,
                                        s => RoToArbs,
                                        l => RoToArbl,
                                        o => RoToArbo
                                        );

    ArbToBufferN <= ArbnToBuffern or ArbsToBuffern or ArblToBuffern or ArboToBuffern;
    ArbToBufferS <= ArbnToBuffers or ArbsToBuffers or ArblToBuffers or ArboToBuffers;
    ArbToBufferL <= ArbnToBufferl or ArbsToBufferl or ArblToBufferl or ArboToBufferl;
    ArbToBufferO <= ArbnToBuffero or ArbsToBuffero or ArblToBuffero or ArboToBuffero;
    
    -- Instanciando os buffers
    BufferN : BufferFIFO port map ( i_rst_sync => '0',
                                    i_clk => clk, 
                                    i_wr_en => '1',
                                    i_wr_data => in_n,
                                    i_rd_en => ArbToBufferN,
                                    o_rd_data => saidaBufferN -- ARBITRO 
                                    );
    BufferS : BufferFIFO port map ( i_rst_sync => '0',
                                    i_clk => clk, 
                                    i_wr_en => '1',
                                    i_wr_data => in_s,
                                    i_rd_en => ArbToBufferS,
                                    o_rd_data => saidaBufferS -- ARBITRO 
                                    ); 
    BufferL : BufferFIFO port map ( i_rst_sync => '0',
                                    i_clk => clk, 
                                    i_wr_en => '1',
                                    i_wr_data => in_l,
                                    i_rd_en => ArbToBufferL,
                                    o_rd_data => saidaBufferL -- ARBITRO 
                                    );
    BufferO : BufferFIFO port map ( i_rst_sync => '0',
                                    i_clk => clk, 
                                    i_wr_en => '1',
                                    i_wr_data => in_o,
                                    i_rd_en =>  ArbToBufferO,
                                    o_rd_data => saidaBufferO -- ARBITRO 
                                    );
    -- Instanciando os Arbitros

    ArbitroN : Arbitro PORT MAP ( clk => clk,
                                  n_in => saidaBufferN,
                                  s_in => saidaBufferS,
                                  l_in => saidaBufferL,
                                  o_in => saidaBufferO,
                                  reqn => RnToArbn,
                                  reqs => RsToArbn,
                                  reql => RlToArbn,
                                  reqo => RoToArbn,
                                  actn => ArbnToBuffern,
                                  acts => ArbnToBuffers,
                                  actl => ArbnToBufferl,
                                  acto => ArbnToBuffero,
                                  p_out => out_n
                                  );
    ArbitroS : Arbitro PORT MAP ( clk => clk,
                                  n_in => saidaBufferN,
                                  s_in => saidaBufferS,
                                  l_in => saidaBufferL,
                                  o_in => saidaBufferO,
                                  reqn => RnToArbs,
                                  reqs => RsToArbs,
                                  reql => RlToArbs,
                                  reqo => RoToArbs,
                                  actn => ArbsToBuffern,
                                  acts => ArbsToBuffers,
                                  actl => ArbsToBufferl,
                                  acto => ArbsToBuffero,
                                  p_out => out_s
                                );
    ArbitroL : Arbitro PORT MAP ( clk => clk,
                                  n_in => saidaBufferN,
                                  s_in => saidaBufferS,
                                  l_in => saidaBufferL,
                                  o_in => saidaBufferO,
                                  reqn => RnToArbl,
                                  reqs => RsToArbl,
                                  reql => RlToArbl,
                                  reqo => RoToArbl,
                                  actn => ArblToBuffern,
                                  acts => ArblToBuffers,
                                  actl => ArblToBufferl,
                                  acto => ArblToBuffero,
                                  p_out => out_l
                                );
    ArbitroO : Arbitro PORT MAP ( clk => clk,
                                  n_in => saidaBufferN,
                                  s_in => saidaBufferS,
                                  l_in => saidaBufferL,
                                  o_in => saidaBufferO,
                                  reqn => RnToArbo,
                                  reqs => RsToArbo,
                                  reql => RlToArbo,
                                  reqo => RoToArbo,
                                  actn => ArboToBuffern,
                                  acts => ArboToBuffers,
                                  actl => ArboToBufferl,
                                  acto => ArboToBuffero,
                                  p_out => out_o
                                );
    
                                     
END structural;