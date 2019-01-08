	component qsysP01 is
		port (
			clk_clk        : in    std_logic                     := 'X';             -- clk
			hex00_export   : out   std_logic_vector(6 downto 0);                     -- export
			hex01_export   : out   std_logic_vector(6 downto 0);                     -- export
			hex02_export   : out   std_logic_vector(6 downto 0);                     -- export
			hex03_export   : out   std_logic_vector(6 downto 0);                     -- export
			hex04_export   : out   std_logic_vector(6 downto 0);                     -- export
			led_out_export : out   std_logic_vector(17 downto 0);                    -- export
			reset_reset_n  : in    std_logic                     := 'X';             -- reset_n
			rs232_ex_RXD   : in    std_logic                     := 'X';             -- RXD
			rs232_ex_TXD   : out   std_logic;                                        -- TXD
			sdram_clk_clk  : out   std_logic;                                        -- clk
			sdram_w_addr   : out   std_logic_vector(12 downto 0);                    -- addr
			sdram_w_ba     : out   std_logic_vector(1 downto 0);                     -- ba
			sdram_w_cas_n  : out   std_logic;                                        -- cas_n
			sdram_w_cke    : out   std_logic;                                        -- cke
			sdram_w_cs_n   : out   std_logic;                                        -- cs_n
			sdram_w_dq     : inout std_logic_vector(31 downto 0) := (others => 'X'); -- dq
			sdram_w_dqm    : out   std_logic_vector(3 downto 0);                     -- dqm
			sdram_w_ras_n  : out   std_logic;                                        -- ras_n
			sdram_w_we_n   : out   std_logic                                         -- we_n
		);
	end component qsysP01;

	u0 : component qsysP01
		port map (
			clk_clk        => CONNECTED_TO_clk_clk,        --       clk.clk
			hex00_export   => CONNECTED_TO_hex00_export,   --     hex00.export
			hex01_export   => CONNECTED_TO_hex01_export,   --     hex01.export
			hex02_export   => CONNECTED_TO_hex02_export,   --     hex02.export
			hex03_export   => CONNECTED_TO_hex03_export,   --     hex03.export
			hex04_export   => CONNECTED_TO_hex04_export,   --     hex04.export
			led_out_export => CONNECTED_TO_led_out_export, --   led_out.export
			reset_reset_n  => CONNECTED_TO_reset_reset_n,  --     reset.reset_n
			rs232_ex_RXD   => CONNECTED_TO_rs232_ex_RXD,   --  rs232_ex.RXD
			rs232_ex_TXD   => CONNECTED_TO_rs232_ex_TXD,   --          .TXD
			sdram_clk_clk  => CONNECTED_TO_sdram_clk_clk,  -- sdram_clk.clk
			sdram_w_addr   => CONNECTED_TO_sdram_w_addr,   --   sdram_w.addr
			sdram_w_ba     => CONNECTED_TO_sdram_w_ba,     --          .ba
			sdram_w_cas_n  => CONNECTED_TO_sdram_w_cas_n,  --          .cas_n
			sdram_w_cke    => CONNECTED_TO_sdram_w_cke,    --          .cke
			sdram_w_cs_n   => CONNECTED_TO_sdram_w_cs_n,   --          .cs_n
			sdram_w_dq     => CONNECTED_TO_sdram_w_dq,     --          .dq
			sdram_w_dqm    => CONNECTED_TO_sdram_w_dqm,    --          .dqm
			sdram_w_ras_n  => CONNECTED_TO_sdram_w_ras_n,  --          .ras_n
			sdram_w_we_n   => CONNECTED_TO_sdram_w_we_n    --          .we_n
		);

