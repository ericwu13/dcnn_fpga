`timescale 1ns/100ps
module tb;
	localparam CLK = 10;
	localparam HCLK = CLK/2;
	logic clk, start, rst, stop;
   logic [3:0] x;
   logic [15:0] streams_w, streams_r;
   logic bit_stream;
   initial begin
      clk = 0;
   end
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
      @(posedge clk)
		rst = 0;
      for(int i = 0; i < 16; ++i) begin
         @(posedge clk)
         streams_w = 0;
         start = 1;
         stop = 0;
         x = i;
         $display("Binary number is : \"%2d\"", i);
         for(int j = 0; j < 16; ++j) begin
            @(posedge clk)
            start = 0;
            streams_w[15-j] = bit_stream;
         end
         @(posedge clk)
         $display("Stochastic number is : \"%16b\"", streams_r);
         stop = 1;
      end
		$finish;
   end
   always@(posedge clk) streams_r <= streams_w;
   endmodule