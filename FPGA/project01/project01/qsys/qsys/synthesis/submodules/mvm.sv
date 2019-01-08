// include "fsm_mux.sv"
// timescale 1ns/100ps

/************************************************/
/*** Matrix multiplication on 4-bit-signed BN ***/
/*** 4 xs multiplicate w                      ***/
/************************************************/

module MVM # (parameter DIM = 256, NUM_BIT = 8) (
   input i_clk_mvm,
   input i_rst_mvm,
   input i_start_mvm,
   input i_sign,
   input [NUM_BIT-1:0] i_x_bn [DIM-1:0],
   input [NUM_BIT-1:0] i_w_mvm,
   output o_ismvm,
   output [NUM_BIT+7:0] o_wx_result [DIM-1:0]
);
   logic fsm_mux_stop, fsm_gen;
   logic tmp [DIM-1:0];//sn_bit [DIM-1:0];
   assign o_ismvm = fsm_gen;
   /*
   always_comb begin if(fsm_gen) begin
         sn_bit = tmp;
      end else begin
         for(int i = 0; i < DIM; ++i) begin
            sn_bit[i] = 0;
         end
      end
   end*/
   FSM_MUX  #(.DIM(DIM), .NUM_BIT(NUM_BIT)) fsm_mux(
      .i_clk_fsm_mux(i_clk_mvm),
      .i_rst_fsm_mux(i_rst_mvm),
      .i_x_bn(i_x_bn),
      .i_start_fsm_mux(i_start_mvm),
      .i_stop_fsm_mux(fsm_mux_stop),
      .o_isgen(fsm_gen),
      .o_sn_bit(tmp)
   );
   DCounter  #(.NUM_BIT(NUM_BIT)) dcounter (
      .i_clk_dc(i_clk_mvm),
      .i_rst_dc(i_rst_mvm),
      .i_start_dc(i_start_mvm),
      .i_w_dc(i_w_mvm),
      .o_count(fsm_mux_stop)
   );
   genvar i;
   generate
   for (i = 0; i < DIM; i = i + 1) begin : gen_loop
      UpDCounter  #(.NUM_BIT(NUM_BIT)) updcounter (
         .i_clk_udc(i_clk_mvm),
         .i_rst_udc(i_rst_mvm),
         .i_start_udc(fsm_gen),
         .i_sn_bit_udc(tmp[i]),//sn_bit[i]),
         .i_sign_w(i_sign),
         .o_acc_result(o_wx_result[i])
      );
   end
   endgenerate
endmodule
module UpDCounter # (parameter NUM_BIT = 8) (
   input i_clk_udc,
   input i_rst_udc,
   input i_start_udc,
   input i_sn_bit_udc,
   input i_sign_w,
   output [8+7:0] o_acc_result
);

   logic bit_w, bit_r;
   logic [NUM_BIT+7:0] counter_r, counter_w;
   assign o_acc_result = counter_r;
   always_comb begin
      counter_w = counter_r;
      bit_w = i_sign_w ^ i_sn_bit_udc;
      if(i_start_udc) begin
         if(bit_w) begin
            counter_w = counter_r + 1;
         end else begin
            counter_w = counter_r - 1;
         end
      end else begin
         counter_w = counter_r;
      end
   end

   always_ff@(posedge i_clk_udc) begin
      if(i_rst_udc) begin
         counter_r <= 0;
         bit_r <= 0;
      end else begin
         counter_r <= counter_w;
         bit_r <= bit_w;
      end
   end
endmodule

module DCounter # (parameter NUM_BIT = 8) (
   input i_clk_dc,
   input i_rst_dc,
   input i_start_dc,
   input [NUM_BIT-1:0] i_w_dc,
   output o_count
);
   logic [NUM_BIT-1:0] counter_w, counter_r, num;
   logic start_r, start_w;
   assign o_count = ~start_w;
   assign num = (i_w_dc) - 8'd1;
   always_comb begin
      start_w = start_r;
      counter_w = counter_r;
      if(i_start_dc) begin
         if(i_w_dc == 8'd0) begin
            start_w = 0;
         end else begin
            start_w = 1;
         end
      end else begin
         if(start_r) begin
            if(counter_r != num) begin
               start_w = 1;
               counter_w = counter_r + 1;
            end else begin
               start_w = 0;
               counter_w = 0;
            end
         end else begin
            counter_w = counter_r;
            start_w = start_r;
         end
      end
   end
   always_ff@(posedge i_clk_dc) begin // or posedge i_start_dc) begin
      if(i_rst_dc) begin
         counter_r <= 0;
         start_r <= 0;
      end else begin
         counter_r <= counter_w;
         start_r <= start_w;
      end
   end
endmodule
