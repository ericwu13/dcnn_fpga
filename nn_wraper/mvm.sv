`include "fsm_mux.sv"
`timescale 1ns/100ps

/************************************************/
/*** Matrix multiplication on 4-bit-signed BN ***/
/*** 4 xs multiplicate w                      ***/
/************************************************/

module MVM(
   input i_clk_mvm,
   input i_rst_mvm,
   input i_start_mvm,
   input [3:0] i_x_bn [3:0],
   input [3:0] i_w_mvm,
   output o_ismvm,
   output [3:0] o_wx_result [3:0]
);

   logic fsm_mux_stop, fsm_gen;
   logic tmp [3:0], sn_bit [3:0];
   assign sn_bit = (fsm_gen == 1)? tmp: 0;
   assign o_ismvm = fsm_gen;
   FSM_MUX fsm_mux(
      .i_clk_fsm_mux(i_clk_mvm),
      .i_rst_fsm_mux(i_rst_mvm),
      .i_x_bn(i_x_bn),
      .i_start_fsm_mux(i_start_mvm),
      .i_stop_fsm_mux(fsm_mux_stop),
      .o_isgen(fsm_gen),
      .o_sn_bit(sn_bit)
   );
   DCounter dcounter(
      .i_clk_dc(i_clk_mvm),
      .i_rst_dc(i_rst_mvm),
      .i_start_dc(i_start_mvm),
      .i_w_dc(i_w_mvm),
      .o_count(fsm_mux_stop)
   );
   UpDCounter updcounter_1(
      .i_clk_udc(i_clk_mvm),
      .i_rst_udc(i_clk_mvm),
      .i_start_udc(fsm_gen),
      .i_sn_bit_udc(sn_bit[0]),
      .o_acc_result(o_wx_result[0])
   );
   UpDCounter updcounter_2(
      .i_clk_udc(i_clk_mvm),
      .i_rst_udc(i_clk_mvm),
      .i_start_udc(fsm_gen),
      .i_sn_bit_udc(sn_bit[1]),
      .o_acc_result(o_wx_result[1])
   );
   UpDCounter updcounter_3(
      .i_clk_udc(i_clk_mvm),
      .i_rst_udc(i_clk_mvm),
      .i_start_udc(fsm_gen),
      .i_sn_bit_udc(sn_bit[2]),
      .o_acc_result(o_wx_result[2])
   );
   UpDCounter updcounter_4(
      .i_clk_udc(i_clk_mvm),
      .i_rst_udc(i_clk_mvm),
      .i_start_udc(fsm_gen),
      .i_sn_bit_udc(sn_bit[3]),
      .o_acc_result(o_wx_result[3])
   );

endmodule
module UpDCounter(
   input i_clk_udc,
   input i_rst_udc,
   input i_start_udc,
   input i_sn_bit_udc,
   output [3:0] o_acc_result
);
   logic [3:0] counter_r, counter_w;
   assign o_acc_result = counter_r;
   always_comb begin
      if(i_start_udc) begin
         if(i_sn_bit_udc) begin
            counter_w = counter_r + 1;
         end else begin
            counter_w = counter_r - 1;
         end
      end else begin
         counter_w = 0;
      end
   end

   always_ff@(posedge i_clk_udc or posedge i_rst_udc) begin
      if(i_rst_udc) begin
         counter_r <= 0;
      end else begin
         counter_r <= counter_w;
      end
   end
endmodule

module DCounter(
   input i_clk_dc,
   input i_rst_dc,
   input i_start_dc,
   input [3:0] i_w_dc,
   output o_count
);
   logic [3:0] counter_w, counter_r;
   logic start_r, start_w;
   assign o_count = ~start_r;
   always_comb begin
      if(i_start_dc) begin
         start_w = 1;
      end else begin
         if(start_r) begin
            if(counter_r < i_w_dc) begin
               start_w = start_r;
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
   always_ff@(posedge i_clk_dc or posedge i_rst_dc) begin
      if(i_rst_dc) begin
         counter_r <= 0;
         start_r <= 0;
      end else begin
         counter_r <= counter_w;
         start_r <= start_w;
      end
   end
endmodule

