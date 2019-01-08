
module qsysP01 (
	clk_clk,
	hex00_export,
	hex01_export,
	hex02_export,
	hex03_export,
	hex04_export,
	led_out_export,
	reset_reset_n,
	rs232_ex_RXD,
	rs232_ex_TXD,
	sdram_clk_clk,
	sdram_w_addr,
	sdram_w_ba,
	sdram_w_cas_n,
	sdram_w_cke,
	sdram_w_cs_n,
	sdram_w_dq,
	sdram_w_dqm,
	sdram_w_ras_n,
	sdram_w_we_n);	

	input		clk_clk;
	output	[6:0]	hex00_export;
	output	[6:0]	hex01_export;
	output	[6:0]	hex02_export;
	output	[6:0]	hex03_export;
	output	[6:0]	hex04_export;
	output	[17:0]	led_out_export;
	input		reset_reset_n;
	input		rs232_ex_RXD;
	output		rs232_ex_TXD;
	output		sdram_clk_clk;
	output	[12:0]	sdram_w_addr;
	output	[1:0]	sdram_w_ba;
	output		sdram_w_cas_n;
	output		sdram_w_cke;
	output		sdram_w_cs_n;
	inout	[31:0]	sdram_w_dq;
	output	[3:0]	sdram_w_dqm;
	output		sdram_w_ras_n;
	output		sdram_w_we_n;
endmodule
