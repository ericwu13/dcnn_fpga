// `include "top_mvm.sv"
module MVM_controller (
	input i_clk_ctrl,
	input i_rst_ctrl,
	input [64-1:0] i_data_64b_ctrl,
  input i_read_req,
  input i_write_req,
	output o_wait_req,
	output [64-1:0] o_y_data
);
	// X = [vector][dim]
	// W = [vector]
	// Y = [dim]
  
	localparam DIM = 8, VECTOR = 8, NUM_BIT = 8;
	localparam IDLE =  3'd0, GET = 3'd1, SEND = 3'd2, ACK = 3'd3, NIOS2V_DONE = 3'd4, V2NIOS_DONE = 3'd5;
	
  logic wait_w, wait_r;
  logic mat_start_w, mat_start_r;
  logic isAcc;
	logic [2:0] current_state_r, current_state_w;
	logic [6:0] dim_counter_r, dim_counter_w;
	logic [3:0] vector_counter_r, vector_counter_w;
	logic [5:0] y_counter_r, y_counter_w;
	logic [8-1:0] matrix [VECTOR-1:0][DIM:0];
	logic [16-1:0] y_vector [DIM-1:0];

   assign o_y_data[15:0]  = (current_state_r == SEND)?y_vector[(y_counter_r << 2)  ]:0;
   assign o_y_data[31:16] = (current_state_r == SEND)?y_vector[(y_counter_r << 2)+1]:0;
   assign o_y_data[47:32] = (current_state_r == SEND)?y_vector[(y_counter_r << 2)+2]:0;
   assign o_y_data[63:48] = (current_state_r == SEND)?y_vector[(y_counter_r << 2)+3]:0;
   assign o_wait_req = wait_r;


   TOP_MVM top_mvm (
      .i_clk_topMvm(i_clk_ctrl),
      .i_rst_topMvm(i_rst_ctrl),
      .i_start_topMvm(mat_start_w),
      .i_matrix(matrix),
      .o_y_vector(y_vector),
      .o_isAcc(isAcc)
   );
	
	always_comb begin
		current_state_w   = current_state_r;
    mat_start_w       = mat_start_r;
    vector_counter_w  = vector_counter_r;
    dim_counter_w     = dim_counter_r;
    y_counter_w       = y_counter_r;
    wait_w            = wait_r;
		case(current_state_r)
			IDLE: begin
        wait_w = 1;
        mat_start_w = 0;
				if(i_write_req) begin
          current_state_w = GET;
        end else if(i_read_req && ~isAcc) begin
          current_state_w = SEND;
        end // end else if(i_read_req)
			end // IDLE: wait for NIOS transmission request
			GET: begin
        wait_w = 0;
        current_state_w = IDLE;
        if(vector_counter_r == (VECTOR>>3)) begin
            dim_counter_w = dim_counter_r + 1;
            vector_counter_w = 0;
        end else begin
            vector_counter_w = vector_counter_r + 1;
        end
        if(dim_counter_r == DIM && vector_counter_r == (VECTOR>>3)) begin // matrix prepared
            current_state_w = IDLE;
            dim_counter_w = 0;
            vector_counter_w = 0;
            mat_start_w = 1;
        end
			end
			SEND: begin
          wait_w = 0;
          current_state_w = IDLE;
          if(y_counter_r == DIM-1) begin
              y_counter_w = 0;    
          end else begin
              y_counter_w = y_counter_r + 1;
          end
			end 
			default: current_state_w = IDLE;
		endcase
	end // always_comb
	always_ff @(posedge i_clk_ctrl or posedge  i_rst_ctrl) begin
		if(i_rst_ctrl) begin
			 current_state_r      <= 0;
          dim_counter_r     <= dim_counter_w;
          vector_counter_r  <= vector_counter_w;
          mat_start_r       <= 0;
          y_counter_r       <= 0;
          wait_r            <= 1;
          for(int i = 0; i < VECTOR; i = i+1) begin
             for(int j = 0; j < DIM+1; j = j+1) begin
                matrix[i][j] <= 0;
             end
          end
		end else begin
         current_state_r  <= current_state_w;
         dim_counter_r    <= dim_counter_w;
         vector_counter_r <= vector_counter_w;
         mat_start_r      <= mat_start_w;
         y_counter_r      <= y_counter_w;
         wait_r           <= wait_w;
         if(wait_r) begin
            matrix[(vector_counter_r * 8)    ][dim_counter_r] <= i_data_64b_ctrl[7:0];
            matrix[(vector_counter_r * 8 + 1)][dim_counter_r] <= i_data_64b_ctrl[15:8];
            matrix[(vector_counter_r * 8 + 2)][dim_counter_r] <= i_data_64b_ctrl[23:16];
            matrix[(vector_counter_r * 8 + 3)][dim_counter_r] <= i_data_64b_ctrl[31:24];
            matrix[(vector_counter_r * 8 + 4)][dim_counter_r] <= i_data_64b_ctrl[39:32];
            matrix[(vector_counter_r * 8 + 5)][dim_counter_r] <= i_data_64b_ctrl[47:40];
            matrix[(vector_counter_r * 8 + 6)][dim_counter_r] <= i_data_64b_ctrl[55:48];
            matrix[(vector_counter_r * 8 + 7)][dim_counter_r] <= i_data_64b_ctrl[63:56];
         end
      end
	end
endmodule
