// timescale 1ns/100ps
// define NUM_BIT 8
// define DIM 8

/*******************************************************************/
/*** Transform input 4 4-bits i_x_bn to stochastic reprentation, ***/
/*** which are bit streams 16-bits stream                        ***/
/*******************************************************************/


module FSM_MUX # (parameter DIM = 256, NUM_BIT = 8) (
   input i_clk_fsm_mux,
   input i_rst_fsm_mux,
   input [NUM_BIT-1:0] i_x_bn [DIM-1:0],
   input i_start_fsm_mux,
   input i_stop_fsm_mux,
   output o_isgen,
   output o_sn_bit [DIM-1:0]
);
   localparam IDLE = 2'b00, GEN = 2'b01, WAIT= 2'b10;

   logic [1:0] current_state_r,
               current_state_w;
   logic [NUM_BIT-1:0] counter_r, counter_w;
   logic start_fsm_r, start_fsm_w,
         stop_fsm_r, stop_fsm_w;
   logic [$clog2(NUM_BIT)-1:0] sel;
   logic gen_bit [DIM-1:0];
   //logic final_gen_bit[DIM-1:0];
   logic gen_w, gen_r;
   assign o_isgen = gen_w;
   assign o_sn_bit = gen_bit;//final_gen_bit;
   /* 
   always_comb begin
      if(counter_r == (2**(NUM_BIT) - 1)) begin
         for(int i = 0; i < DIM; ++i) begin
            final_gen_bit[i] = 0;
         end
      end else begin
         for(int i = 0; i < DIM; ++i) begin
            final_gen_bit[i] = gen_bit[i];
         end
      end
   end*/

   FSM_16_state fsm(
      .i_clk_fsm(i_clk_fsm_mux),
      .i_rst_fsm(i_rst_fsm_mux),
      .i_start_fsm(start_fsm_r),
      .i_stop_fsm(stop_fsm_r),
      .o_sel(sel)
   );
   genvar i;
   generate
   for (i = 0; i < DIM; i = i + 1) begin : gen_loop
      MUX_4to1 mux(
         .i_sel(sel),
         .i_data(i_x_bn[i]),
         .o_data(gen_bit[i])
      );
   end
   endgenerate

   always_comb begin
      counter_w = counter_r;
      current_state_w = current_state_r;
      start_fsm_w = start_fsm_r;
      stop_fsm_w = stop_fsm_r;
      gen_w = 0;
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
            gen_w = 1;
            if(i_stop_fsm_mux || counter_w == (2**(NUM_BIT) -1)) begin
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

   always_ff@(posedge i_clk_fsm_mux)begin// or posedge i_start_fsm_mux or posedge i_stop_fsm_mux) begin
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
   output [2:0] o_sel
);
   localparam NUM_BIT = 8;
   logic [7:0] counter_r, 
               counter_w;
   logic start_w, start_r;
   logic [2:0] sel;
   assign o_sel = sel;
   /*
   assign o_sel = (counter_w == 0)? 3:
                  (counter_w == 1)? 2:
                  (counter_w == 2)? 3:
                  (counter_w == 3)? 1:
                  (counter_w == 4)? 3:
                  (counter_w == 5)? 2:
                  (counter_w == 6)? 3:
                  (counter_w == 7)? 0:
                  (counter_w == 8)? 3: (counter_w == 9)? 2:
                  (counter_w == 10)? 3:
                  (counter_w == 11)? 1:
                  (counter_w == 12)? 3:
                  (counter_w == 13)? 2:
                  (counter_w == 14)? 3:2;
   */
   always_comb begin
      if(counter_w % 2 == 0) begin
         sel = 7;
      end else if(counter_w % 4 == 1)  begin
         sel = 6;
      end else if(counter_w % 8 == 3)  begin
         sel = 5;
      end else if(counter_w % 16 == 7)  begin
         sel = 4;
      end else if(counter_w % 32 == 15)  begin
         sel = 3;
      end else if(counter_w % 64 == 31)  begin
         sel = 2;
      end else if(counter_w % 128 == 63)  begin
         sel = 1;
      end else begin
         sel = 0;
      end 
   end
   always_comb begin
	 start_w = start_r;
	 counter_w = counter_r;
      if(i_start_fsm) begin
         start_w = 1;
         counter_w = 0;
      end else begin
         if(start_r) begin
            if(i_stop_fsm) begin
               start_w = 0;
               counter_w = 0;
            end else begin
               counter_w = counter_r + 1;
            end
         end else begin
            start_w = start_r;
            counter_w = counter_r;
         end
      end
   end

   always_ff@(posedge i_clk_fsm ) begin //or posedge i_stop_fsm ) begin
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
   input [$clog2(8)-1:0] i_sel,
   input [7:0] i_data,
   output o_data
);
   assign o_data = i_data[i_sel+:1];
endmodule
