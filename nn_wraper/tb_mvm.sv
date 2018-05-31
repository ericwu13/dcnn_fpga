`timescale 1ns/100ps
`include "mvm.sv"
module tb;
	localparam CLK = 10;
	localparam HCLK = CLK/2;
	logic clk, start, rst, stop, ismvm;
   logic [`NUM_BIT-1:0] x [`DIM-1:0];
   logic [`NUM_BIT-1:0] result_w [`DIM-1:0], result_r [`DIM-1:0], tmp [`DIM-1:0];
   logic [`NUM_BIT-1:0] w;
   logic [23:0] counter_w, counter_r;
   initial begin
      for(int i = 0; i < `DIM; ++i)
         //x[i] = $urandom_range(2**(`NUM_BIT)-1);
         x[i] = i+128;
      //w = $urandom_range(2**(`NUM_BIT)-1);
      w = 64;
      clk = 0;
   end
	always #HCLK clk = ~clk;
   always_comb begin
      if(start) counter_w = 0;
      else counter_w = counter_r + 1;
      if(ismvm) begin
         for(int i = 0; i < `DIM; ++i) begin
            result_w[i] = tmp[i];
         end
      end else begin
         for(int i = 0; i < `DIM; ++i) begin
            result_w[i] = result_r[i];
         end
      end
   end
   always_ff@(posedge clk or posedge rst) begin
      counter_r <= counter_w;
      if(rst)  begin
         for(int i = 0; i < `DIM; ++i) begin
            result_r[i] <= 0;
         end
      end
      else begin
         for(int i = 0; i < `DIM; ++i) begin
            result_r[i] <= result_w[i];
         end
      end
   end


   MVM mvm(
      .i_clk_mvm(clk),
      .i_rst_mvm(rst),
      .i_start_mvm(start),
      .i_x_bn(x),
      .i_w_mvm(w),
      .o_ismvm(ismvm),
      .o_wx_result(tmp)
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
      @(negedge ismvm)
      for(int i = 0; i < `DIM; ++i) begin
         $display("%f * %f is %f", x[i] / 256.0, w / 256.0, result_r[i] / 256.0);
      end
      $display("Cycle costs: %3d", counter_w);
		$finish;
   end
   endmodule
