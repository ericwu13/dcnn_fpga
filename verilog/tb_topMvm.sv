`timescale 1ns/100ps
`include "top_mvm.sv"
`define NUM_BIT 8
`define NUM_VECTOR 8
`define DIM 8

module tb;
	localparam CLK = 10;
	localparam HCLK = CLK/2;
	logic clk, start, rst, isAcc;
   logic [`NUM_BIT-1:0] x [`NUM_VECTOR-1:0] [`DIM:0];
   logic [`NUM_BIT+7:0] result_w [`DIM-1:0], result_r [`DIM-1:0], tmp [`DIM-1:0];
   logic [`NUM_BIT-1:0] w[`NUM_VECTOR-1:0];
   logic [23:0] counter_w, counter_r;
   initial begin
      for(int i = 0; i < `NUM_VECTOR; ++i) begin
         for(int j = 0; j < `DIM+1; ++j) begin
	    if(j == `DIM) x[i][j] = 130;
            //x[i][j] = -64-(i*j);
            else x[i][j] = 64 + i + j;
         end
         //w[i] = -64-i*i;
         
      end
         //x[i] = $urandom_range(2**(`NUM_BIT)-1);
      //w = $urandom_range(2**(`NUM_BIT)-1);
      $display("%8b", x[0][0]);
      $display("%8b", w[0]);
      clk = 0;
   end
	always #HCLK clk = ~clk;
   always_comb begin
      if(start) counter_w = 0;
      else counter_w = counter_r + 1;
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

   TOP_MVM top_mvm(
      .i_clk_topMvm(clk),
      .i_rst_topMvm(rst),
      .i_start_topMvm(start),
      .i_matrix(x),
      //.i_x_vectors(x),
      //.i_wts(w),
      .o_y_vector(result_w),
      .o_isAcc(isAcc)
   );

   initial begin
		$fsdbDumpfile("topMvm.fsdb");
		$fsdbDumpvars;
      @(posedge clk)
		rst = 1;
      @(posedge clk)
		rst = 0;
      @(posedge clk)
      start = 1;
      @(posedge clk)
      start = 0;
      @(negedge isAcc)
      $display("=================");
      for(int i = 0; i < `DIM; ++i) begin
         $write("[ ");
         for(int j = 0; j < `NUM_VECTOR; ++j) begin
            if(j == `NUM_VECTOR-1) begin
               //$write("%f ] %f  ", signed'(x[j][i]) / 128.0 , signed'(x[i][`DIM]) / 128.0 );
               $write("%8b ] %8b  ", (x[j][i]), x[i][`DIM]);
            end else begin
               //$write("%f ", signed'(x[j][i]) / 128.0 );
               $write("%8b ", x[j][i]);
            end
         end
         //$write("%f\n", signed'(result_w[i]) / 128.0 );
         $write("%16b\n", (result_w[i]));
      end
      $display("=================");
      $display("Cycle costs: %3d", counter_w);
      $display("=================");
/*
      for(int i = 0; i < `NUM_VECTOR; ++i) begin
         for(int j = 0; j < `DIM+1; ++j) begin
            //x[i][j] = -64-(i*j);
            if(j == `DIM) x[i][j] = 130;
	    else x[i][j] = 64;
         end
         //w[i] = -64-i*i;
         
      end
      /*
      @(posedge clk)
		rst = 1;
      @(posedge clk)
		rst = 0;
	*/
 
      @(posedge clk)
      start = 1;
      @(posedge clk)
      start = 0;
      @(negedge isAcc)
      $display("=================");
      for(int i = 0; i < `DIM; ++i) begin
         $write("[ ");
         for(int j = 0; j < `NUM_VECTOR; ++j) begin
            if(j == `NUM_VECTOR-1) begin
               $write("%f ] %f  ", signed'(x[j][i]) / 16.0 , signed'(x[i][`DIM]) / 128.0 );
               //$write("%8b ] %8b  ", (x[j][i]), x[i][`DIM]);
            end else begin
               $write("%f ", signed'(x[j][i]) / 16.0 );
               //$write("%8b ", x[j][i]);
            end
         end
         $write("%f\n", signed'(result_w[i]) / 16.0 );
         //$write("%16b\n", (result_w[i]));
      end
      $display("=================");
      $display("Cycle costs: %3d", counter_w);
      $display("=================");
	$finish;
end
   endmodule

