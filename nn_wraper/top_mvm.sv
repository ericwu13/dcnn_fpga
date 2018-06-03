`include "mvm.sv"
`define NUM_VECTOR 3

module TOP_MVM(
   input i_clk_topMvm, 
   input i_rst_topMvm,
   input i_start_topMvm,
   input [`NUM_BIT-1:0] i_x_vectors [`NUM_VECTOR-1:0][`DIM-1:0],
   input [`NUM_BIT-1:0] i_wts [`NUM_VECTOR-1:0],
   output [`NUM_BIT-1:0] o_y_vector [`DIM-1:0],
   output o_isAcc
);
   localparam IDLE = 2'b00, CAL = 2'b01, DUMMY = 2'b11;
   logic startMvm_w, startMvm_r;
   logic isMvm, isAcc;
   logic [14:0] counter_r, counter_w;
   logic [1:0] current_state_r, current_state_w;
   logic [`NUM_BIT-1:0] result [`DIM-1:0], tmp_y[`DIM-1:0];

   logic [`NUM_BIT-1:0] current_x [`DIM-1:0], current_wt;
   assign o_isAcc = isAcc;
   assign o_y_vector = tmp_y;
   always_comb begin
      if(counter_w == `NUM_VECTOR) begin
         isAcc = 0;
         for(int i = 0; i <`DIM; i++) begin
            tmp_y[i] = result[i];
         end
      end else begin
         isAcc = 1;
         for(int i = 0; i <`DIM; i++) begin
            tmp_y[i] = 0;
         end
      end
   end


   MVM mvm(
      .i_clk_mvm(i_clk_topMvm),
      .i_rst_mvm(i_rst_topMvm),
      .i_start_mvm(startMvm_w),
      .i_sign(i_wts[counter_r][`NUM_BIT-1]),
      .i_x_bn(current_x),
      .i_w_mvm(current_wt),
      //.i_x_bn(i_x_vectors[counter_r]),
      //.i_w_mvm(i_wts[counter_r]),
      .o_ismvm(isMvm),
      .o_wx_result(result)
   );

   NumTransformer numTran(
      .i_x_numTran(i_x_vectors[counter_r]),
      .i_wt_numTran(i_wts[counter_r]),
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
               startMvm_w = 1;
               current_state_w = CAL;
            end
         end
         CAL: begin
            startMvm_w = 0;
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
         startMvm_r <= startMvm_w;
      end
   end

endmodule

module NumTransformer(
   input [`NUM_BIT-1:0] i_x_numTran [`DIM-1:0],
   input [`NUM_BIT-1:0] i_wt_numTran,
   output [`NUM_BIT-1:0] o_x_numTran [`DIM-1:0],
   output [`NUM_BIT-1:0] o_wt_numTran
);
   logic [`NUM_BIT-1:0] current_x [`DIM-1:0], current_wt;
   logic [`NUM_BIT-1:0] tmp_wt;
   
   assign tmp_wt = (i_wt_numTran[`NUM_BIT-1])? i_wt_numTran - 1: i_wt_numTran;
   assign o_x_numTran = current_x;
   assign o_wt_numTran = current_wt;

   always_comb begin
      for(int i = 0; i < `DIM; ++i) begin
         for(int j = 0; j < `NUM_BIT-1; ++j) 
               current_x[i][j] = i_x_numTran[i][j];
         current_x[i][`NUM_BIT-1] = ~i_x_numTran[i][`NUM_BIT-1];
      end
      if(i_wt_numTran[`NUM_BIT-1]) begin
         for(int i = 0; i < `NUM_BIT-1; ++i) begin
            current_wt[i] = ~tmp_wt[i];
         end
      end else begin
         for(int i = 0; i <`NUM_BIT;++i) begin
            current_wt[i] = tmp_wt[i];
         end
      end
   end
endmodule
