`timescale 1ns/100ps

/*******************************************************************/
/*** Transform input 4 4-bits i_x_bn to stochastic reprentation, ***/
/*** which are bit streams 16-bits stream                        ***/
/*******************************************************************/

module FSM_MUX(
   input i_clk_fsm_mux,
   input i_rst_fsm_mux,
   input [3:0] i_x_bn [3:0],
   input i_start_fsm_mux,
   input i_stop_fsm_mux,
   output o_isgen,
   output o_sn_bit [3:0]
);
   parameter IDLE = 2'b00, GEN = 2'b01, WAIT= 2'b10;
   logic [1:0] current_state_r,
               current_state_w;
   logic [3:0] counter_r, counter_w;
   logic start_fsm_r, start_fsm_w,
         stop_fsm_r, stop_fsm_w;
   logic [1:0] sel;
   logic gen_bit [3:0];
   logic final_gen_bit[3:0];
   logic gen_w, gen_r;
   assign o_isgen = gen_r;
   assign o_sn_bit = final_gen_bit;
   always_comb begin
      if(counter_r == 15) begin
         final_gen_bit[0] = 0;
         final_gen_bit[1] = 0;
         final_gen_bit[2] = 0;
         final_gen_bit[3] = 0;
      end else begin
         final_gen_bit[0] = gen_bit[0];
         final_gen_bit[1] = gen_bit[1];
         final_gen_bit[2] = gen_bit[2];
         final_gen_bit[3] = gen_bit[3];
      end
   end

   FSM_16_state fsm(
      .i_clk_fsm(i_clk_fsm_mux),
      .i_rst_fsm(i_rst_fsm_mux),
      .i_start_fsm(start_fsm_r),
      .i_stop_fsm(stop_fsm_r),
      .o_sel(sel)
   );

   MUX_4to1 mux_1(
      .i_sel(sel),
      .i_data(i_x_bn[0]),
      .o_data(gen_bit[0])
   );

   MUX_4to1 mux_2(
      .i_sel(sel),
      .i_data(i_x_bn[1]),
      .o_data(gen_bit[1])
   );

   MUX_4to1 mux_3(
      .i_sel(sel),
      .i_data(i_x_bn[2]),
      .o_data(gen_bit[2])
   );

   MUX_4to1 mux_4(
      .i_sel(sel),
      .i_data(i_x_bn[3]),
      .o_data(gen_bit[3])
   );

   always_comb begin
      counter_w = counter_r;
      current_state_w = current_state_r;
      start_fsm_w = start_fsm_r;
      stop_fsm_w = stop_fsm_r;
      gen_w = gen_r;
      case(current_state_r)
         IDLE: begin
            if(i_start_fsm_mux) begin
               current_state_w = GEN;
               start_fsm_w = 1;
               stop_fsm_w = 0;
               counter_w = 0;
               gen_w = 1;
            end else begin
               stop_fsm_w = stop_fsm_r;
               start_fsm_w = start_fsm_r;
               counter_w = counter_r;
            end
         end
         GEN: begin
            start_fsm_w = 0;
            if(i_stop_fsm_mux || counter_r == 15) begin
               current_state_w = IDLE;
               stop_fsm_w = 1;
               gen_w = 0;
            end else begin
               counter_w = counter_r + 1;
               stop_fsm_w = stop_fsm_r;
            end
         end
         default: current_state_w = IDLE;
      endcase
   end

   always_ff@(posedge i_clk_fsm_mux or posedge i_rst_fsm_mux) begin
      if(i_rst_fsm_mux) begin
         current_state_r <= 0;
         counter_r <= 0;
         start_fsm_r <= 0;
         stop_fsm_r <= 0;
         gen_r <= 0;
      end else begin
         current_state_r <= current_state_w;
         counter_r <= counter_w;
         start_fsm_r <= start_fsm_w;
         stop_fsm_r <= stop_fsm_w;
         gen_r <= gen_w;
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

   logic [3:0] counter_r, 
               counter_w;
   logic start_w, start_r;
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
      if(i_start_fsm) begin
         start_w = 1;
         counter_w = 0;
      end else begin
         start_w = start_r;
         counter_w = counter_r;
      end
      if(start_r) begin
         if(i_stop_fsm) begin
            counter_w = 0;
         end else begin
            counter_w = counter_r + 1;
         end
      end else begin
         counter_w = counter_r;
      end
   end

   always_ff@(posedge i_clk_fsm or posedge i_rst_fsm or posedge i_stop_fsm) begin
      if(i_rst_fsm) begin
         counter_r <= 0;
         start_r <= 0;
      end else begin
         counter_r <= counter_w;
         start_r <= start_w;
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
