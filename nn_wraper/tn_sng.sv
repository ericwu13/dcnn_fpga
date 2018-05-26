`timescale 1ns/100ps
module tb;
	localparam CLK = 10;
	localparam HCLK = CLK/2;
	logic clk, start, rst, stop;
   logic [3:0] x;
   logic bit_stream;
	initial clk = 0;
	always #HCLK clk = ~clk;

   SNG sng(
      .i_clk_sng(clk),
      .i_rst_sng(rst),
      .i_x_bn(x),
      .i_start_sng(start),
      .i_stop_sng(stop),
      .o_sn_bit(bit_stream)
   );

   initial begin
		$fsdbDumpfile("sng.fsdb");
		$fsdbDumpvars;
		rst = 1;
		#(2*CLK)
		rst = 0;
      start = 1;
      #CLK
      start = 0;
		#(5000*CLK)
		$finish;
   end
   endmodule