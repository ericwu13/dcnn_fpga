`include "mvm.sv"
`define NUM_VECTOR 10

module TOP_MVM(
   input i_clk_topMvm,
   input i_rst_topMvm,
   input i_start_topMvm,
   input [`NUM_BIT-1:0] i_x_vectors [`NUM_VECTOR-1:0][`NUM_DIM-1:0],
   input [`NUM_BIT-1:0] i_wts [`NUM_VECTOR-1:0],
   output [`NUM_BIT-1:0] o_y_vector [`NUM_DIM-1:0],
   output o_isAcc
);
   localparam IDLE = 2'b00, CAL = 2'b01, DUMMY = 2'b11;
   logic startMvm_w, startMvm_r;
   logic isMvm, isAcc;
   logic [14:0] counter_r, counter_w;
   logic [1:0] current_state_r, current_state_w;
   logic [`NUM_BIT-1:0] current_x [`NUM_DIM-1:0], current_w;
   logic [`NUM_BIT-1:0] result [`NUM_DIM-1:0], tmp_y[`NUM_DIM-1:0];
   assign o_isAcc = isAcc;
   assign o_y_vector = tmp_y;
   always_comb begin
      if(counter_w == `NUM_VECTOR) begin
         isAcc = 0;
         for(int i = 0; i <`NUM_DIM -1; i++) begin
            tmp_y[i] = result[i];
         end
      end else begin
         isAcc = 1;
         for(int i = 0; i <`NUM_DIM -1; i++) begin
            tmp_y[i] = 0;
         end
      end
   end


   MVM mvm(
      .i_clk_mvm(i_clk_topMvm),
      .i_rst_mvm(i_rst_topMvm),
      .i_start_mvm(startMvm_w),
      .i_x_bn(i_x_vectors[counter_r+:1]),
      .i_w_mvm(i_wts[counter_r+:1]),
      .o_ismvm(isMvm),
      .o_wx_result(result)
   );

   always_comb begin
      startMvm_w = starMvm_w;
      counter_w = counter_r;
      current_state_w = current_state_r;
      case(current_state_r)
         IDLE: begin
            if(i_start_topMvm) begin
               startMvm_w = 1;
               current_state_w = CAL;
            end
         end
         CAL: begin
            starMvm_w = 0;
            if(~isMvm) begin
               counter_w = counter_r + 1;
               current_state_w = DUMMY;
            end 
         end
         DUMMY: begin
            if(counter_r == `NUM_VECTOR) begin
               counter_w = 0;
               current_state_w = IDLE;
            end else begin
               current_state_w = CAL;
               startMvm_w = 1;
            end
         end
         default: current_state_w = current_state_r;
      endcase
   end

   always_ff@(posedge i_clk_topMvm or posedge i_rst_topMvm) begin
      if(i_rst_topMvm) begin
         current_state_r <= IDLE;
         counter_r <= 0;
         startMvm_r <= 0;
      end else begin
         current_state_r <= current_state_w;
         counter_r <= counter_w;
         startMvm_r <= starMvm_w;
      end
   end

endmodule;


