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
         x[i] = 8;
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
      @(posedge clk)
		rst = 1;
      stop = 0;
      @(posedge clk)
		rst = 0;
      @(posedge clk)
      start = 1;
      @(posedge clk)
      start = 0;
      #(20*CLK)
      $display("Accumulated result1 is %16b", result[0]);
      $display("Accumulated result2 is %16b", result[1]);
      $display("Accumulated result3 is %16b", result[2]);
      $display("Accumulated result4 is %16b", result[3]);
		$finish;
   end
   endmodule
