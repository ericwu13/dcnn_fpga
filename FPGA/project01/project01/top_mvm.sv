// include "mvm.sv"
module TOP_MVM # (parameter DIM = 256, NUM_VECTOR = 128, NUM_BIT = 8) (
   input i_clk_topMvm, 
   input i_rst_topMvm,
   input i_rst_mvm,
   input i_start_topMvm,
   input [NUM_BIT-1:0] i_matrix [DIM:0], // vector, dim
   output [NUM_BIT+7:0] o_y_vector [DIM-1:0],
   output o_isAcc
);

   localparam IDLE = 2'b00, CAL = 2'b01, DUMMY = 2'b11, WAIT = 2'b10;

   logic [NUM_BIT-1:0] i_x_vector [DIM-1:0];
   logic [NUM_BIT-1:0] i_wt;
   always_comb begin
      for(int j = 0; j < DIM; j++) begin
         i_x_vector[j] = i_matrix[j];
      end
      i_wt = i_matrix[DIM];
   end
   logic startMvm_w, startMvm_r;
   logic isMvm, isAcc;
   logic [14:0] counter_r, counter_w;
   logic [1:0] current_state_r, current_state_w;
   logic [NUM_BIT+7:0] result [DIM-1:0];//, tmp_y[DIM-1:0];

   logic [NUM_BIT-1:0] current_x [DIM-1:0], current_wt;
   assign o_isAcc = isAcc;
   assign o_y_vector = result;

   always_comb begin
	   if(current_state_r != CAL) begin// && current_state_r != WAIT) begin
         isAcc = 0;
      end else begin
         isAcc = 1;
      end
   end

   MVM  #(.DIM(DIM), .NUM_BIT(NUM_BIT)) mvm(
      .i_clk_mvm(i_clk_topMvm),
      .i_rst_mvm(i_rst_mvm),
      .i_start_mvm(startMvm_w),
      .i_sign(i_wt[NUM_BIT-1]),
      .i_x_bn(current_x),
      .i_w_mvm(current_wt),
      .o_ismvm(isMvm),
      .o_wx_result(result)
   );

   NumTransformer   #(.DIM(DIM), .NUM_BIT(NUM_BIT)) numTran (
      .i_x_numTran(i_x_vector),
      .i_wt_numTran(i_wt),
      .o_x_numTran(current_x),
      .o_wt_numTran(current_wt)
   );

   always_comb begin
      startMvm_w = startMvm_r;
      counter_w = counter_r;
      current_state_w = current_state_r;
      case(current_state_r)
         IDLE: begin
            if(i_start_topMvm) begin
               counter_w = 0;
               startMvm_w = 1;
               current_state_w = WAIT;
            end
         end
	      WAIT: begin
            current_state_w = CAL;
	      end
         CAL: begin
            startMvm_w = 0;
            if(~isMvm) begin
               counter_w = counter_r + 1;
               current_state_w = DUMMY;
            end 
         end
         DUMMY: begin
            if(counter_r == NUM_VECTOR) begin
               current_state_w = IDLE;
            end else begin
               if(i_start_topMvm) begin
                  current_state_w = CAL;
                  startMvm_w = 1;
               end
            end
         end
         default: current_state_w = IDLE;
      endcase
   end

   always_ff@(posedge i_clk_topMvm) begin
      if(i_rst_topMvm) begin
         current_state_r <= IDLE;
         counter_r <= 0;
         startMvm_r <= 0;
      end else begin
         current_state_r <= current_state_w;
         counter_r <= counter_w;
         startMvm_r <= startMvm_w;
      end
   end

endmodule

module NumTransformer # (parameter DIM = 128, NUM_BIT = 8) (
   input [NUM_BIT-1:0] i_x_numTran [DIM-1:0],
   input [NUM_BIT-1:0] i_wt_numTran,
   output [NUM_BIT-1:0] o_x_numTran [DIM-1:0],
   output [NUM_BIT-1:0] o_wt_numTran
);

   logic [NUM_BIT-1:0] current_x [DIM-1:0], current_wt;
   logic [NUM_BIT-1:0] tmp_wt, sub;
   assign sub = i_wt_numTran - 8'd1;
   assign o_x_numTran = current_x;
   assign o_wt_numTran = current_wt;

   always_comb begin
      for(int i = 0; i < 8; ++i) begin
         if(i_wt_numTran[7]) tmp_wt[i] = sub[i];
         else tmp_wt[i] = i_wt_numTran[i];
      end // for(int i = 0; i < 7; ++i)end
      for(int i = 0; i < DIM; ++i) begin
         for(int j = 0; j < NUM_BIT-1; ++j) 
               current_x[i][j] = i_x_numTran[i][j];
         current_x[i][NUM_BIT-1] = ~i_x_numTran[i][NUM_BIT-1];
      end
      for(int i = 0; i < NUM_BIT; ++i) begin
         current_wt[i] = (i_wt_numTran[NUM_BIT-1])? ~tmp_wt[i]: tmp_wt[i];
      end
   end
endmodule
