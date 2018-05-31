`timescale 1ns/100ps
`include "fsm_mux.sv"
module tb;
	localparam CLK = 10;
	localparam HCLK = CLK/2;
	logic clk, start, rst, stop;
   logic [`NUM_BIT-1:0] x [`DIM-1:0];
   logic [2**(`NUM_BIT)-1:0] streams_w [`DIM-1:0], streams_r [`DIM-1:0];
   logic bit_stream [`DIM-1:0];
   logic gen;
   initial begin
      clk = 0;
   end
	always #HCLK clk = ~clk;


   FSM_MUX fsm_mux(
      .i_clk_fsm_mux(clk),
      .i_rst_fsm_mux(rst),
      .i_x_bn(x),
      .i_start_fsm_mux(start),
      .i_stop_fsm_mux(stop),
      .o_isgen(gen),
      .o_sn_bit(bit_stream)
   );

   initial begin
		$fsdbDumpfile("fsm_mux.fsdb");
		$fsdbDumpvars;
		rst = 1;
      @(posedge clk)
		rst = 0;
      for(int i = 0; i < 2**(`NUM_BIT-1); ++i) begin
         @(posedge clk)
         for(int j = 0; j < `DIM-1; ++j) begin
            streams_w[j] = 0;
         end
         start = 1;
         stop = 0;
         for(int j = 0; j < `DIM-1; ++j) begin
            x[j] = i+j+1;
         end
         $display("=============================");
         for(int j = 0; j < `DIM-1; ++j) begin
            $display("Binary number %4d is : \"%4d\"", j, x[j]);
         end
         for(int j = 0; j < 2**(`NUM_BIT); ++j) begin
            @(posedge clk)
            start = 0;
            for(int k = 0; k < `DIM-1; ++k) begin
               streams_w[k][2**(`NUM_BIT)-1-j] = bit_stream[k];
            end
         end
         @(posedge clk)
         for(int j = 0; j < `DIM-1; ++j) begin
            $display("Stochastic number %4d is : \"%256b\"", j, streams_r[j]);
         end
         stop = 1;
      end
		$finish;
   end
   always@(posedge clk) begin
      for(int i = 0; i < `DIM; ++i) begin
         streams_r[i] <= streams_w[i];
      end
   end
   endmodule
