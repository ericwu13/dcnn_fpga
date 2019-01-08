module test_slave # (parameter DATA_WIDTH = 32 ) (
	input	i_clk_ctrl,
	input	i_rst_ctrl,
	input	i_read_req,
	input	i_write_req,
	input	[DATA_WIDTH-1:0] i_data_32b_ctrl,
	output	o_wait_req,
	output	[DATA_WIDTH-1:0] o_y_data
);
	localparam IDLE =  3'd0, GET = 3'd1, SEND = 3'd2, DONE = 3'd3, WAIT = 3'd4;
	parameter DIM = 10'd256, VECTOR = 10'd128, NUM_BIT = 8;
	parameter DIM_WRITE = 10'd64, DIM_SHRINK = 10'd128;
	logic [2:0] current_state_r, current_state_w;
	logic [9:0] dim_counter_r, dim_counter_w;
	logic [9:0] vector_counter_r, vector_counter_w;
	logic [9:0] read_counter_w, read_counter_r;

	logic [NUM_BIT-1:0] matrix_w [256:0], matrix_r [256:0];
	logic [(NUM_BIT<<1)-1:0] y_vector [255:0];
	logic mat_start_w, mat_start_r;
	logic isAcc, mvm_rst;
	logic [9:0] final_write_1, final_write_2, final_write_3, final_write_4, final_read_1, final_read_2;
	logic [9:0] write_shift, read_shift;
	assign write_shift = dim_counter_r << 2;
	assign read_shift = read_counter_r << 1;
	assign final_write_1 = write_shift;
	assign final_write_2 = write_shift + 10'd1;
	assign final_write_3 = write_shift + 10'd2;
	assign final_write_4 = write_shift + 10'd3;
	assign final_read_1 = read_shift; 
	assign final_read_2 = read_shift + 10'd1;
   TOP_MVM  # (.DIM(256), .NUM_VECTOR(128), .NUM_BIT(8)) top_mvm (
      .i_clk_topMvm(i_clk_ctrl),
      .i_rst_topMvm(i_rst_ctrl),
      .i_rst_mvm(mvm_rst),
      .i_start_topMvm(mat_start_w),
      .i_matrix(matrix_r),
      .o_y_vector(y_vector),
      .o_isAcc(isAcc)
   );
   	
	always_comb begin
		o_y_data[15:0]    = y_vector[final_read_1];
		o_y_data[31:16]   = y_vector[final_read_2];
	end 
	always_comb begin
		current_state_w  	= current_state_r;
	   	dim_counter_w     	= dim_counter_r;
		read_counter_w		= read_counter_r;
		o_wait_req			= 1;
		mat_start_w			= mat_start_r;
      	vector_counter_w    = vector_counter_r;
      	mvm_rst 			= 0;
      	for(int j = 0; j < 256+1; j = j+1) begin
        	matrix_w[j] = matrix_r[j];
      	end
		case(current_state_r)
			IDLE: begin
				if(i_write_req) begin
					current_state_w = GET;
					o_wait_req = 0;
					if(dim_counter_r == (DIM_WRITE)) begin
						matrix_w[DIM] = i_data_32b_ctrl[7:0];
					end else begin
						matrix_w[final_write_1] = i_data_32b_ctrl[7:0];
			    		matrix_w[final_write_2] = i_data_32b_ctrl[15:8];
			    		matrix_w[final_write_3] = i_data_32b_ctrl[23:16];
			    		matrix_w[final_write_4] = i_data_32b_ctrl[31:24];
			    	end
            	end else if(i_read_req) begin
               		if(read_counter_r == 0) begin
                  		vector_counter_w = 0;
               		end 
               		current_state_w = SEND;
               		o_wait_req = 0;
            	end
			end
			GET: begin
				o_wait_req = 1;
            	if((dim_counter_r == (DIM_WRITE))) begin
               		vector_counter_w = vector_counter_r + 10'd1;
               		current_state_w = WAIT;
               		dim_counter_w = 0;
		         	mat_start_w = 1;
		         	if(vector_counter_r == 0) begin
            			mvm_rst = 1;
        			end else begin
        				mvm_rst = 0;
        			end // end else
            	end else begin
               		dim_counter_w = dim_counter_r + 10'd1;
		        	current_state_w = IDLE;
		     	end
			end
			WAIT: current_state_w = DONE;
			DONE: begin
            	mat_start_w = 0;
	            if(isAcc) begin
	               o_wait_req = 1;
				end else begin
	               current_state_w = IDLE;
	            end
			end
			SEND: begin
				o_wait_req = 1;
				current_state_w = IDLE;
				if(read_counter_r == DIM_SHRINK-1) begin
					read_counter_w = 0;
				end else begin
					read_counter_w = read_counter_r + 10'd1;
				end // if()end
			end // SEND:
			default: current_state_w = IDLE;
		endcase
	end // always_comb

	always_ff @(posedge i_clk_ctrl) begin
		if(i_rst_ctrl) begin 
			current_state_r 	<= 0;
			dim_counter_r		<= 0;
			read_counter_r		<= 0;
			mat_start_r			<= 0;
        	vector_counter_r  	<= 0;
        	for(int j = 0; j < 256+1; j = j+1) begin
            	matrix_r [j] <= 0;
         	end
		end else begin 
			current_state_r 	<= current_state_w;
			dim_counter_r		<= dim_counter_w;
			read_counter_r		<= read_counter_w;
			mat_start_r			<= mat_start_w;
         	vector_counter_r    <= vector_counter_w;
         	for(int j = 0; j < 256+1; j = j+1) begin
            	matrix_r[j] <= matrix_w[j];
         	end
      	end
	end
endmodule
