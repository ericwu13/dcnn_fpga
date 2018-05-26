`timescale 1ns/100ps
// Transform input 4 bits "i_x_bn" to stochastic reprentation which are bit streams 16-bits stream
module SNG(
   input i_clk_sng,
   input i_rst_sng,
   input [3:0] i_x_bn,
   input i_start_sng,
   input i_stop_sng,
   output o_sn_bit
);
   parameter IDLE = 2'b00, GEN = 2'b01, DONE = 2'b10;
   logic [1:0] current_state_r,
               current_state_w;
   logic [3:0] counter_r, counter_w;
   logic start_fsm_r, start_fsm_w,
         stop_fsm_r, stop_fsm_w;
   logic [1:0] sel;
   logic gen_bit;
   assign o_sn_bit = (counter_r == 15)? 0: gen_bit;

   FSM_16_state fsm(
      .i_clk_fsm(i_clk_sng),
      .i_rst_fsm(i_rst_sng),
      .i_start_fsm(start_fsm_r),
      .i_stop_fsm(stop_fsm_r),
      .o_sel(sel)
   );

   MUX_4to1 mux(
      .i_sel(sel),
      .i_data(i_x_bn),
      .o_data(gen_bit)
   );
   always_comb begin
      counter_w = counter_r;
      current_state_w = current_state_r;
      start_fsm_w = start_fsm_r;
      stop_fsm_w = stop_fsm_r;
      case(current_state_r)
         IDLE: begin
            if(i_start_sng) begin
               current_state_w = GEN;
               start_fsm_w = 1;
               stop_fsm_w = 0;
               counter_w = 0;
            end else begin
               stop_fsm_w = stop_fsm_r;
               start_fsm_w = start_fsm_r;
               counter_w = counter_r;
            end
         end
         GEN: begin
            counter_w = counter_r + 1;
            start_fsm_w = 0;
            if(i_stop_sng || counter_r == 15) begin
               current_state_w = IDLE;
               stop_fsm_w = 1;
            end else begin
               stop_fsm_w = stop_fsm_r;
            end
         end
         default: current_state_w = IDLE;
      endcase
   end

   always_ff@(posedge i_clk_sng or posedge i_rst_sng) begin
      if(i_rst_sng) begin
         current_state_r <= 0;
         counter_r <= 0;
         start_fsm_r <= 0;
         stop_fsm_r <= 0;
      end else begin
         current_state_r <= current_state_w;
         counter_r <= counter_w;
         start_fsm_r <= start_fsm_w;
         stop_fsm_r <= stop_fsm_w;
      end
   end
endmodule

module FSM_16_state(
   input i_clk_fsm,
   input i_rst_fsm,
   input i_start_fsm,
   input i_stop_fsm,
   output [1:0] o_sel
);
   parameter IDLE = 2'b00, GEN = 2'b01, DONE = 2'b10;
   logic [1:0] current_state_r, 
               current_state_w;

   logic [3:0] counter_r, 
               counter_w;
   assign o_sel = (counter_r == 0)? 3:
                  (counter_r == 1)? 2:
                  (counter_r == 2)? 3:
                  (counter_r == 3)? 1:
                  (counter_r == 4)? 3:
                  (counter_r == 5)? 2:
                  (counter_r == 6)? 3:
                  (counter_r == 7)? 0:
                  (counter_r == 8)? 3:
                  (counter_r == 9)? 2:
                  (counter_r == 10)? 3:
                  (counter_r == 11)? 1:
                  (counter_r == 12)? 3:
                  (counter_r == 13)? 2:
                  (counter_r == 14)? 3:2;
   always_comb begin
      current_state_w = current_state_r;
      counter_w = counter_r;
      case(current_state_r)
         IDLE: begin
            if(i_start_fsm) begin
               current_state_w = GEN;
               counter_w = 0;
            end else begin
               current_state_w = current_state_r;
               counter_w = counter_r;
            end
         end
         GEN: begin
            if(i_stop_fsm) begin
               current_state_w = IDLE;
            end else begin
               counter_w = counter_r + 1;
            end
         end
         default: current_state_w = IDLE;
      endcase
   end

   always_ff@(posedge i_clk_fsm or posedge i_rst_fsm) begin
      if(i_rst_fsm) begin
         current_state_r <= IDLE;
         counter_r <= 0;
      end else begin
         current_state_r <= current_state_w;
         counter_r <= counter_w;
      end
   end

endmodule


module MUX_4to1(
   input [1:0] i_sel,
   input [3:0] i_data,
   output o_data
);
   assign o_data = i_data[i_sel+:1];
endmodule
