
    wire dl_reset;
    wire dl_clock;
    assign dl_reset = ap_rst_n;
    assign dl_clock = ap_clk;
    wire [0:0] proc_0_data_FIFO_blk;
    wire [0:0] proc_0_data_PIPO_blk;
    wire [0:0] proc_0_start_FIFO_blk;
    wire [0:0] proc_0_TLF_FIFO_blk;
    wire [0:0] proc_0_input_sync_blk;
    wire [0:0] proc_0_output_sync_blk;
    wire [0:0] proc_dep_vld_vec_0;
    reg [0:0] proc_dep_vld_vec_0_reg;
    wire [0:0] in_chan_dep_vld_vec_0;
    wire [4:0] in_chan_dep_data_vec_0;
    wire [0:0] token_in_vec_0;
    wire [0:0] out_chan_dep_vld_vec_0;
    wire [4:0] out_chan_dep_data_0;
    wire [0:0] token_out_vec_0;
    wire dl_detect_out_0;
    wire dep_chan_vld_4_0;
    wire [4:0] dep_chan_data_4_0;
    wire token_4_0;
    wire [0:0] proc_1_data_FIFO_blk;
    wire [0:0] proc_1_data_PIPO_blk;
    wire [0:0] proc_1_start_FIFO_blk;
    wire [0:0] proc_1_TLF_FIFO_blk;
    wire [0:0] proc_1_input_sync_blk;
    wire [0:0] proc_1_output_sync_blk;
    wire [0:0] proc_dep_vld_vec_1;
    reg [0:0] proc_dep_vld_vec_1_reg;
    wire [1:0] in_chan_dep_vld_vec_1;
    wire [9:0] in_chan_dep_data_vec_1;
    wire [1:0] token_in_vec_1;
    wire [0:0] out_chan_dep_vld_vec_1;
    wire [4:0] out_chan_dep_data_1;
    wire [0:0] token_out_vec_1;
    wire dl_detect_out_1;
    wire dep_chan_vld_2_1;
    wire [4:0] dep_chan_data_2_1;
    wire token_2_1;
    wire dep_chan_vld_3_1;
    wire [4:0] dep_chan_data_3_1;
    wire token_3_1;
    wire [1:0] proc_2_data_FIFO_blk;
    wire [1:0] proc_2_data_PIPO_blk;
    wire [1:0] proc_2_start_FIFO_blk;
    wire [1:0] proc_2_TLF_FIFO_blk;
    wire [1:0] proc_2_input_sync_blk;
    wire [1:0] proc_2_output_sync_blk;
    wire [1:0] proc_dep_vld_vec_2;
    reg [1:0] proc_dep_vld_vec_2_reg;
    wire [1:0] in_chan_dep_vld_vec_2;
    wire [9:0] in_chan_dep_data_vec_2;
    wire [1:0] token_in_vec_2;
    wire [1:0] out_chan_dep_vld_vec_2;
    wire [4:0] out_chan_dep_data_2;
    wire [1:0] token_out_vec_2;
    wire dl_detect_out_2;
    wire dep_chan_vld_1_2;
    wire [4:0] dep_chan_data_1_2;
    wire token_1_2;
    wire dep_chan_vld_3_2;
    wire [4:0] dep_chan_data_3_2;
    wire token_3_2;
    wire [1:0] proc_3_data_FIFO_blk;
    wire [1:0] proc_3_data_PIPO_blk;
    wire [1:0] proc_3_start_FIFO_blk;
    wire [1:0] proc_3_TLF_FIFO_blk;
    wire [1:0] proc_3_input_sync_blk;
    wire [1:0] proc_3_output_sync_blk;
    wire [1:0] proc_dep_vld_vec_3;
    reg [1:0] proc_dep_vld_vec_3_reg;
    wire [0:0] in_chan_dep_vld_vec_3;
    wire [4:0] in_chan_dep_data_vec_3;
    wire [0:0] token_in_vec_3;
    wire [1:0] out_chan_dep_vld_vec_3;
    wire [4:0] out_chan_dep_data_3;
    wire [1:0] token_out_vec_3;
    wire dl_detect_out_3;
    wire dep_chan_vld_2_3;
    wire [4:0] dep_chan_data_2_3;
    wire token_2_3;
    wire [0:0] proc_4_data_FIFO_blk;
    wire [0:0] proc_4_data_PIPO_blk;
    wire [0:0] proc_4_start_FIFO_blk;
    wire [0:0] proc_4_TLF_FIFO_blk;
    wire [0:0] proc_4_input_sync_blk;
    wire [0:0] proc_4_output_sync_blk;
    wire [0:0] proc_dep_vld_vec_4;
    reg [0:0] proc_dep_vld_vec_4_reg;
    wire [0:0] in_chan_dep_vld_vec_4;
    wire [4:0] in_chan_dep_data_vec_4;
    wire [0:0] token_in_vec_4;
    wire [0:0] out_chan_dep_vld_vec_4;
    wire [4:0] out_chan_dep_data_4;
    wire [0:0] token_out_vec_4;
    wire dl_detect_out_4;
    wire dep_chan_vld_0_4;
    wire [4:0] dep_chan_data_0_4;
    wire token_0_4;
    wire [4:0] dl_in_vec;
    wire dl_detect_out;
    wire token_clear;
    reg [4:0] origin;

    reg ap_done_reg_0;// for module mem2mat_1080_1920_U0.grp_dataflow_parent_loop_proc_fu_131.dataflow_in_loop_VITIS_LOOP_38_1_1_U0.readmem4_U0
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            ap_done_reg_0 <= 'b0;
        end
        else begin
            ap_done_reg_0 <= mem2mat_1080_1920_U0.grp_dataflow_parent_loop_proc_fu_131.dataflow_in_loop_VITIS_LOOP_38_1_1_U0.readmem4_U0.ap_done & ~mem2mat_1080_1920_U0.grp_dataflow_parent_loop_proc_fu_131.dataflow_in_loop_VITIS_LOOP_38_1_1_U0.readmem4_U0.ap_continue;
        end
    end

    reg ap_done_reg_1;// for module mem2mat_1080_1920_U0.grp_dataflow_parent_loop_proc_fu_131.dataflow_in_loop_VITIS_LOOP_38_1_1_U0.dataflow_in_loop_VITIS_LOOP_38_1_1_Loop_VITIS_LOOP_43_2_proc5_U0
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            ap_done_reg_1 <= 'b0;
        end
        else begin
            ap_done_reg_1 <= mem2mat_1080_1920_U0.grp_dataflow_parent_loop_proc_fu_131.dataflow_in_loop_VITIS_LOOP_38_1_1_U0.dataflow_in_loop_VITIS_LOOP_38_1_1_Loop_VITIS_LOOP_43_2_proc5_U0.ap_done & ~mem2mat_1080_1920_U0.grp_dataflow_parent_loop_proc_fu_131.dataflow_in_loop_VITIS_LOOP_38_1_1_U0.dataflow_in_loop_VITIS_LOOP_38_1_1_Loop_VITIS_LOOP_43_2_proc5_U0.ap_continue;
        end
    end

    reg ap_done_reg_2;// for module mem2mat_1080_1920_U0
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            ap_done_reg_2 <= 'b0;
        end
        else begin
            ap_done_reg_2 <= mem2mat_1080_1920_U0.ap_done & ~mem2mat_1080_1920_U0.ap_continue;
        end
    end

    reg ap_done_reg_3;// for module xfMat2AXIvideo_24_16_1080_1920_1_2_U0
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            ap_done_reg_3 <= 'b0;
        end
        else begin
            ap_done_reg_3 <= xfMat2AXIvideo_24_16_1080_1920_1_2_U0.ap_done & ~xfMat2AXIvideo_24_16_1080_1920_1_2_U0.ap_continue;
        end
    end

reg [15:0] trans_in_cnt_0;// for process mem2mat_1080_1920_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_in_cnt_0 <= 16'h0;
    end
    else if (mem2mat_1080_1920_U0.start_write == 1'b1) begin
        trans_in_cnt_0 <= trans_in_cnt_0 + 16'h1;
    end
    else begin
        trans_in_cnt_0 <= trans_in_cnt_0;
    end
end

reg [15:0] trans_out_cnt_0;// for process mem2mat_1080_1920_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_out_cnt_0 <= 16'h0;
    end
    else if (mem2mat_1080_1920_U0.ap_done == 1'b1 && mem2mat_1080_1920_U0.ap_continue == 1'b1) begin
        trans_out_cnt_0 <= trans_out_cnt_0 + 16'h1;
    end
    else begin
        trans_out_cnt_0 <= trans_out_cnt_0;
    end
end

    // Process: mem2mat_1080_1920_U0
    mem2stream_hls_deadlock_detect_unit #(5, 0, 1, 1) mem2stream_hls_deadlock_detect_unit_0 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_0),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_0),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_0),
        .token_in_vec(token_in_vec_0),
        .dl_detect_in(dl_detect_out),
        .origin(origin[0]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_0),
        .out_chan_dep_data(out_chan_dep_data_0),
        .token_out_vec(token_out_vec_0),
        .dl_detect_out(dl_in_vec[0]));

    assign proc_0_data_FIFO_blk[0] = 1'b0 | (~mem2mat_1080_1920_U0.grp_dataflow_parent_loop_proc_fu_131.dataflow_in_loop_VITIS_LOOP_38_1_1_U0.dataflow_in_loop_VITIS_LOOP_38_1_1_Loop_VITIS_LOOP_43_2_proc5_U0.grp_dataflow_in_loop_VITIS_LOOP_38_1_1_Loop_VITIS_LOOP_43_2_proc5_Pipeline_VITIS_LOO_fu_46.img_data_blk_n) | (~mem2mat_1080_1920_U0.img_rows_c_blk_n) | (~mem2mat_1080_1920_U0.img_cols_c_blk_n);
    assign proc_0_data_PIPO_blk[0] = 1'b0;
    assign proc_0_start_FIFO_blk[0] = 1'b0 | (~start_for_xfMat2AXIvideo_24_16_1080_1920_1_2_U0_U.if_full_n & mem2mat_1080_1920_U0.ap_start & ~mem2mat_1080_1920_U0.real_start & (trans_in_cnt_0 == trans_out_cnt_0) & ~start_for_xfMat2AXIvideo_24_16_1080_1920_1_2_U0_U.if_read);
    assign proc_0_TLF_FIFO_blk[0] = 1'b0;
    assign proc_0_input_sync_blk[0] = 1'b0;
    assign proc_0_output_sync_blk[0] = 1'b0 | (ap_done_reg_2 & mem2mat_1080_1920_U0.ap_done & ~xfMat2AXIvideo_24_16_1080_1920_1_2_U0.ap_done);
    assign proc_dep_vld_vec_0[0] = dl_detect_out ? proc_dep_vld_vec_0_reg[0] : (proc_0_data_FIFO_blk[0] | proc_0_data_PIPO_blk[0] | proc_0_start_FIFO_blk[0] | proc_0_TLF_FIFO_blk[0] | proc_0_input_sync_blk[0] | proc_0_output_sync_blk[0]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_0_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_0_reg <= proc_dep_vld_vec_0;
        end
    end
    assign in_chan_dep_vld_vec_0[0] = dep_chan_vld_4_0;
    assign in_chan_dep_data_vec_0[4 : 0] = dep_chan_data_4_0;
    assign token_in_vec_0[0] = token_4_0;
    assign dep_chan_vld_0_4 = out_chan_dep_vld_vec_0[0];
    assign dep_chan_data_0_4 = out_chan_dep_data_0;
    assign token_0_4 = token_out_vec_0[0];

    // Process: mem2mat_1080_1920_U0.grp_dataflow_parent_loop_proc_fu_131.dataflow_in_loop_VITIS_LOOP_38_1_1_U0.dataflow_in_loop_VITIS_LOOP_38_1_1_Block_newFuncRoot17_proc3_U0
    mem2stream_hls_deadlock_detect_unit #(5, 1, 2, 1) mem2stream_hls_deadlock_detect_unit_1 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_1),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_1),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_1),
        .token_in_vec(token_in_vec_1),
        .dl_detect_in(dl_detect_out),
        .origin(origin[1]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_1),
        .out_chan_dep_data(out_chan_dep_data_1),
        .token_out_vec(token_out_vec_1),
        .dl_detect_out(dl_in_vec[1]));

    assign proc_1_data_FIFO_blk[0] = 1'b0;
    assign proc_1_data_PIPO_blk[0] = 1'b0;
    assign proc_1_start_FIFO_blk[0] = 1'b0;
    assign proc_1_TLF_FIFO_blk[0] = 1'b0;
    assign proc_1_input_sync_blk[0] = 1'b0 | (mem2mat_1080_1920_U0.grp_dataflow_parent_loop_proc_fu_131.dataflow_in_loop_VITIS_LOOP_38_1_1_U0.ap_sync_dataflow_in_loop_VITIS_LOOP_38_1_1_Block_newFuncRoot17_proc3_U0_ap_ready & mem2mat_1080_1920_U0.grp_dataflow_parent_loop_proc_fu_131.dataflow_in_loop_VITIS_LOOP_38_1_1_U0.dataflow_in_loop_VITIS_LOOP_38_1_1_Block_newFuncRoot17_proc3_U0.ap_idle & ~mem2mat_1080_1920_U0.grp_dataflow_parent_loop_proc_fu_131.dataflow_in_loop_VITIS_LOOP_38_1_1_U0.ap_sync_readmem4_U0_ap_ready);
    assign proc_1_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_1[0] = dl_detect_out ? proc_dep_vld_vec_1_reg[0] : (proc_1_data_FIFO_blk[0] | proc_1_data_PIPO_blk[0] | proc_1_start_FIFO_blk[0] | proc_1_TLF_FIFO_blk[0] | proc_1_input_sync_blk[0] | proc_1_output_sync_blk[0]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_1_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_1_reg <= proc_dep_vld_vec_1;
        end
    end
    assign in_chan_dep_vld_vec_1[0] = dep_chan_vld_2_1;
    assign in_chan_dep_data_vec_1[4 : 0] = dep_chan_data_2_1;
    assign token_in_vec_1[0] = token_2_1;
    assign in_chan_dep_vld_vec_1[1] = dep_chan_vld_3_1;
    assign in_chan_dep_data_vec_1[9 : 5] = dep_chan_data_3_1;
    assign token_in_vec_1[1] = token_3_1;
    assign dep_chan_vld_1_2 = out_chan_dep_vld_vec_1[0];
    assign dep_chan_data_1_2 = out_chan_dep_data_1;
    assign token_1_2 = token_out_vec_1[0];

    // Process: mem2mat_1080_1920_U0.grp_dataflow_parent_loop_proc_fu_131.dataflow_in_loop_VITIS_LOOP_38_1_1_U0.readmem4_U0
    mem2stream_hls_deadlock_detect_unit #(5, 2, 2, 2) mem2stream_hls_deadlock_detect_unit_2 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_2),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_2),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_2),
        .token_in_vec(token_in_vec_2),
        .dl_detect_in(dl_detect_out),
        .origin(origin[2]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_2),
        .out_chan_dep_data(out_chan_dep_data_2),
        .token_out_vec(token_out_vec_2),
        .dl_detect_out(dl_in_vec[2]));

    assign proc_2_data_FIFO_blk[0] = 1'b0;
    assign proc_2_data_PIPO_blk[0] = 1'b0;
    assign proc_2_start_FIFO_blk[0] = 1'b0;
    assign proc_2_TLF_FIFO_blk[0] = 1'b0 | (~mem2mat_1080_1920_U0.grp_dataflow_parent_loop_proc_fu_131.dataflow_in_loop_VITIS_LOOP_38_1_1_U0.trunc_ln42_loc_i_i_channel_U.if_empty_n & mem2mat_1080_1920_U0.grp_dataflow_parent_loop_proc_fu_131.dataflow_in_loop_VITIS_LOOP_38_1_1_U0.readmem4_U0.ap_idle & ~mem2mat_1080_1920_U0.grp_dataflow_parent_loop_proc_fu_131.dataflow_in_loop_VITIS_LOOP_38_1_1_U0.trunc_ln42_loc_i_i_channel_U.if_write);
    assign proc_2_input_sync_blk[0] = 1'b0 | (mem2mat_1080_1920_U0.grp_dataflow_parent_loop_proc_fu_131.dataflow_in_loop_VITIS_LOOP_38_1_1_U0.ap_sync_readmem4_U0_ap_ready & mem2mat_1080_1920_U0.grp_dataflow_parent_loop_proc_fu_131.dataflow_in_loop_VITIS_LOOP_38_1_1_U0.readmem4_U0.ap_idle & ~mem2mat_1080_1920_U0.grp_dataflow_parent_loop_proc_fu_131.dataflow_in_loop_VITIS_LOOP_38_1_1_U0.ap_sync_dataflow_in_loop_VITIS_LOOP_38_1_1_Block_newFuncRoot17_proc3_U0_ap_ready);
    assign proc_2_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_2[0] = dl_detect_out ? proc_dep_vld_vec_2_reg[0] : (proc_2_data_FIFO_blk[0] | proc_2_data_PIPO_blk[0] | proc_2_start_FIFO_blk[0] | proc_2_TLF_FIFO_blk[0] | proc_2_input_sync_blk[0] | proc_2_output_sync_blk[0]);
    assign proc_2_data_FIFO_blk[1] = 1'b0 | (~mem2mat_1080_1920_U0.grp_dataflow_parent_loop_proc_fu_131.dataflow_in_loop_VITIS_LOOP_38_1_1_U0.readmem4_U0.grp_readmem4_Pipeline_2_fu_133.cacheBuff_i_i_blk_n);
    assign proc_2_data_PIPO_blk[1] = 1'b0;
    assign proc_2_start_FIFO_blk[1] = 1'b0;
    assign proc_2_TLF_FIFO_blk[1] = 1'b0;
    assign proc_2_input_sync_blk[1] = 1'b0;
    assign proc_2_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_2[1] = dl_detect_out ? proc_dep_vld_vec_2_reg[1] : (proc_2_data_FIFO_blk[1] | proc_2_data_PIPO_blk[1] | proc_2_start_FIFO_blk[1] | proc_2_TLF_FIFO_blk[1] | proc_2_input_sync_blk[1] | proc_2_output_sync_blk[1]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_2_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_2_reg <= proc_dep_vld_vec_2;
        end
    end
    assign in_chan_dep_vld_vec_2[0] = dep_chan_vld_1_2;
    assign in_chan_dep_data_vec_2[4 : 0] = dep_chan_data_1_2;
    assign token_in_vec_2[0] = token_1_2;
    assign in_chan_dep_vld_vec_2[1] = dep_chan_vld_3_2;
    assign in_chan_dep_data_vec_2[9 : 5] = dep_chan_data_3_2;
    assign token_in_vec_2[1] = token_3_2;
    assign dep_chan_vld_2_1 = out_chan_dep_vld_vec_2[0];
    assign dep_chan_data_2_1 = out_chan_dep_data_2;
    assign token_2_1 = token_out_vec_2[0];
    assign dep_chan_vld_2_3 = out_chan_dep_vld_vec_2[1];
    assign dep_chan_data_2_3 = out_chan_dep_data_2;
    assign token_2_3 = token_out_vec_2[1];

    // Process: mem2mat_1080_1920_U0.grp_dataflow_parent_loop_proc_fu_131.dataflow_in_loop_VITIS_LOOP_38_1_1_U0.dataflow_in_loop_VITIS_LOOP_38_1_1_Loop_VITIS_LOOP_43_2_proc5_U0
    mem2stream_hls_deadlock_detect_unit #(5, 3, 1, 2) mem2stream_hls_deadlock_detect_unit_3 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_3),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_3),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_3),
        .token_in_vec(token_in_vec_3),
        .dl_detect_in(dl_detect_out),
        .origin(origin[3]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_3),
        .out_chan_dep_data(out_chan_dep_data_3),
        .token_out_vec(token_out_vec_3),
        .dl_detect_out(dl_in_vec[3]));

    assign proc_3_data_FIFO_blk[0] = 1'b0;
    assign proc_3_data_PIPO_blk[0] = 1'b0;
    assign proc_3_start_FIFO_blk[0] = 1'b0;
    assign proc_3_TLF_FIFO_blk[0] = 1'b0 | (~mem2mat_1080_1920_U0.grp_dataflow_parent_loop_proc_fu_131.dataflow_in_loop_VITIS_LOOP_38_1_1_U0.p_cast16_loc_i_i_channel_U.if_empty_n & mem2mat_1080_1920_U0.grp_dataflow_parent_loop_proc_fu_131.dataflow_in_loop_VITIS_LOOP_38_1_1_U0.dataflow_in_loop_VITIS_LOOP_38_1_1_Loop_VITIS_LOOP_43_2_proc5_U0.ap_idle & ~mem2mat_1080_1920_U0.grp_dataflow_parent_loop_proc_fu_131.dataflow_in_loop_VITIS_LOOP_38_1_1_U0.p_cast16_loc_i_i_channel_U.if_write);
    assign proc_3_input_sync_blk[0] = 1'b0;
    assign proc_3_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_3[0] = dl_detect_out ? proc_dep_vld_vec_3_reg[0] : (proc_3_data_FIFO_blk[0] | proc_3_data_PIPO_blk[0] | proc_3_start_FIFO_blk[0] | proc_3_TLF_FIFO_blk[0] | proc_3_input_sync_blk[0] | proc_3_output_sync_blk[0]);
    assign proc_3_data_FIFO_blk[1] = 1'b0 | (~mem2mat_1080_1920_U0.grp_dataflow_parent_loop_proc_fu_131.dataflow_in_loop_VITIS_LOOP_38_1_1_U0.dataflow_in_loop_VITIS_LOOP_38_1_1_Loop_VITIS_LOOP_43_2_proc5_U0.grp_dataflow_in_loop_VITIS_LOOP_38_1_1_Loop_VITIS_LOOP_43_2_proc5_Pipeline_VITIS_LOO_fu_46.cacheBuff_blk_n);
    assign proc_3_data_PIPO_blk[1] = 1'b0;
    assign proc_3_start_FIFO_blk[1] = 1'b0;
    assign proc_3_TLF_FIFO_blk[1] = 1'b0;
    assign proc_3_input_sync_blk[1] = 1'b0;
    assign proc_3_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_3[1] = dl_detect_out ? proc_dep_vld_vec_3_reg[1] : (proc_3_data_FIFO_blk[1] | proc_3_data_PIPO_blk[1] | proc_3_start_FIFO_blk[1] | proc_3_TLF_FIFO_blk[1] | proc_3_input_sync_blk[1] | proc_3_output_sync_blk[1]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_3_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_3_reg <= proc_dep_vld_vec_3;
        end
    end
    assign in_chan_dep_vld_vec_3[0] = dep_chan_vld_2_3;
    assign in_chan_dep_data_vec_3[4 : 0] = dep_chan_data_2_3;
    assign token_in_vec_3[0] = token_2_3;
    assign dep_chan_vld_3_1 = out_chan_dep_vld_vec_3[0];
    assign dep_chan_data_3_1 = out_chan_dep_data_3;
    assign token_3_1 = token_out_vec_3[0];
    assign dep_chan_vld_3_2 = out_chan_dep_vld_vec_3[1];
    assign dep_chan_data_3_2 = out_chan_dep_data_3;
    assign token_3_2 = token_out_vec_3[1];

    // Process: xfMat2AXIvideo_24_16_1080_1920_1_2_U0
    mem2stream_hls_deadlock_detect_unit #(5, 4, 1, 1) mem2stream_hls_deadlock_detect_unit_4 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_4),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_4),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_4),
        .token_in_vec(token_in_vec_4),
        .dl_detect_in(dl_detect_out),
        .origin(origin[4]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_4),
        .out_chan_dep_data(out_chan_dep_data_4),
        .token_out_vec(token_out_vec_4),
        .dl_detect_out(dl_in_vec[4]));

    assign proc_4_data_FIFO_blk[0] = 1'b0 | (~xfMat2AXIvideo_24_16_1080_1920_1_2_U0.img_1_blk_n) | (~xfMat2AXIvideo_24_16_1080_1920_1_2_U0.img_2_blk_n) | (~xfMat2AXIvideo_24_16_1080_1920_1_2_U0.grp_xfMat2AXIvideo_24_16_1080_1920_1_2_Pipeline_loop_col_mat2axi_fu_100.img_data_blk_n);
    assign proc_4_data_PIPO_blk[0] = 1'b0;
    assign proc_4_start_FIFO_blk[0] = 1'b0 | (~start_for_xfMat2AXIvideo_24_16_1080_1920_1_2_U0_U.if_empty_n & xfMat2AXIvideo_24_16_1080_1920_1_2_U0.ap_idle & ~start_for_xfMat2AXIvideo_24_16_1080_1920_1_2_U0_U.if_write);
    assign proc_4_TLF_FIFO_blk[0] = 1'b0;
    assign proc_4_input_sync_blk[0] = 1'b0;
    assign proc_4_output_sync_blk[0] = 1'b0 | (ap_done_reg_3 & xfMat2AXIvideo_24_16_1080_1920_1_2_U0.ap_done & ~mem2mat_1080_1920_U0.ap_done);
    assign proc_dep_vld_vec_4[0] = dl_detect_out ? proc_dep_vld_vec_4_reg[0] : (proc_4_data_FIFO_blk[0] | proc_4_data_PIPO_blk[0] | proc_4_start_FIFO_blk[0] | proc_4_TLF_FIFO_blk[0] | proc_4_input_sync_blk[0] | proc_4_output_sync_blk[0]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_4_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_4_reg <= proc_dep_vld_vec_4;
        end
    end
    assign in_chan_dep_vld_vec_4[0] = dep_chan_vld_0_4;
    assign in_chan_dep_data_vec_4[4 : 0] = dep_chan_data_0_4;
    assign token_in_vec_4[0] = token_0_4;
    assign dep_chan_vld_4_0 = out_chan_dep_vld_vec_4[0];
    assign dep_chan_data_4_0 = out_chan_dep_data_4;
    assign token_4_0 = token_out_vec_4[0];


`include "mem2stream_hls_deadlock_report_unit.vh"
