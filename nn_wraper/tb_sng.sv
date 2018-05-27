`timescale 1ns/100ps
module tb;
	localparam CLK = 10;
	localparam HCLK = CLK/2;
	logic clk, start, rst, stop;
   logic [3:0] x;
   logic [7:0] streams;
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
		#(2*CLK)
		rst = 0;
      #CLK
      for(int i = 0; i < 15; ++i) begin
         start <= 1;
         stop <= 0;
         x <= 0;
         $display("Binary number is : \"%2d\"", i);
         for(int j = 0; j < 8; ++j) begin
            start <= 0;
            @(posedge clk)
            streams[i] = bit_stream
         end
         $display("Stochastic number is : \"%8x\"", streams);
         stop <= 1;
      end
		$finish;
   end
   endmodule
