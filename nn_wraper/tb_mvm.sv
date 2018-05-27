`timescale 1ns/100ps
module tb;
	localparam CLK = 10;
	localparam HCLK = CLK/2;
	logic clk, start, rst, stop, ismvm;
   logic [3:0] x [3:0];
   logic [3:0] result [3:0];
   logic [3:0] w;
   initial begin
      for(int i = 0; i < 4; ++i)
         x[i] = 15;
      w = 8;
      clk = 0;
   end
	always #HCLK clk = ~clk;


   MVM mvm(
      .i_clk_mvm(clk),
      .i_rst_mvm(rst),
      .i_start_mvm(start),
      .i_x_bn(x),
      .i_w_mvm(w),
      .o_ismvm(ismvm),
      .o_wx_result(result)
   );

   initial begin
		$fsdbDumpfile("mvm.fsdb");
		$fsdbDumpvars;
		rst = 1;
      @(posedge clk)
		rst = 0;
      @(posedge clk)
      start = 1;
      @(posedge clk)
      start = 0;
      #20*CLK
      $display("%16b", result[0]);
		$finish;
   end
   always@(posedge clk) streams_r <= streams_w;
   endmodule
