
wire kernel_monitor_reset;
wire kernel_monitor_clock;
wire kernel_monitor_report;
assign kernel_monitor_reset = ~ap_rst_n;
assign kernel_monitor_clock = ap_clk;
assign kernel_monitor_report = 1'b0;
wire [0:0] axis_block_sigs;
wire [8:0] inst_idle_sigs;
wire [5:0] inst_block_sigs;
wire kernel_block;

assign axis_block_sigs[0] = ~xfMat2AXIvideo_24_16_1080_1920_1_2_U0.grp_xfMat2AXIvideo_24_16_1080_1920_1_2_Pipeline_loop_col_mat2axi_fu_100.vstream_TDATA_blk_n;

assign inst_idle_sigs[0] = mem2mat_1080_1920_U0.ap_idle;
assign inst_block_sigs[0] = (mem2mat_1080_1920_U0.ap_done & ~mem2mat_1080_1920_U0.ap_continue) | ~mem2mat_1080_1920_U0.grp_dataflow_parent_loop_proc_fu_131.dataflow_in_loop_VITIS_LOOP_38_1_1_U0.dataflow_in_loop_VITIS_LOOP_38_1_1_Loop_VITIS_LOOP_43_2_proc5_U0.grp_dataflow_in_loop_VITIS_LOOP_38_1_1_Loop_VITIS_LOOP_43_2_proc5_Pipeline_VITIS_LOO_fu_46.img_data_blk_n | ~mem2mat_1080_1920_U0.img_rows_c_blk_n | ~mem2mat_1080_1920_U0.img_cols_c_blk_n;
assign inst_idle_sigs[1] = xfMat2AXIvideo_24_16_1080_1920_1_2_U0.ap_idle;
assign inst_block_sigs[1] = (xfMat2AXIvideo_24_16_1080_1920_1_2_U0.ap_done & ~xfMat2AXIvideo_24_16_1080_1920_1_2_U0.ap_continue) | ~xfMat2AXIvideo_24_16_1080_1920_1_2_U0.img_1_blk_n | ~xfMat2AXIvideo_24_16_1080_1920_1_2_U0.img_2_blk_n | ~xfMat2AXIvideo_24_16_1080_1920_1_2_U0.grp_xfMat2AXIvideo_24_16_1080_1920_1_2_Pipeline_loop_col_mat2axi_fu_100.img_data_blk_n;
assign inst_idle_sigs[2] = mem2mat_1080_1920_U0.grp_dataflow_parent_loop_proc_fu_131.dataflow_in_loop_VITIS_LOOP_38_1_1_U0.ap_idle;
assign inst_block_sigs[2] = (mem2mat_1080_1920_U0.grp_dataflow_parent_loop_proc_fu_131.dataflow_in_loop_VITIS_LOOP_38_1_1_U0.ap_done & ~mem2mat_1080_1920_U0.grp_dataflow_parent_loop_proc_fu_131.dataflow_in_loop_VITIS_LOOP_38_1_1_U0.ap_continue);
assign inst_idle_sigs[3] = mem2mat_1080_1920_U0.grp_dataflow_parent_loop_proc_fu_131.dataflow_in_loop_VITIS_LOOP_38_1_1_U0.dataflow_in_loop_VITIS_LOOP_38_1_1_Block_newFuncRoot17_proc3_U0.ap_idle;
assign inst_block_sigs[3] = (mem2mat_1080_1920_U0.grp_dataflow_parent_loop_proc_fu_131.dataflow_in_loop_VITIS_LOOP_38_1_1_U0.dataflow_in_loop_VITIS_LOOP_38_1_1_Block_newFuncRoot17_proc3_U0.ap_done & ~mem2mat_1080_1920_U0.grp_dataflow_parent_loop_proc_fu_131.dataflow_in_loop_VITIS_LOOP_38_1_1_U0.dataflow_in_loop_VITIS_LOOP_38_1_1_Block_newFuncRoot17_proc3_U0.ap_continue);
assign inst_idle_sigs[4] = mem2mat_1080_1920_U0.grp_dataflow_parent_loop_proc_fu_131.dataflow_in_loop_VITIS_LOOP_38_1_1_U0.readmem4_U0.ap_idle;
assign inst_block_sigs[4] = (mem2mat_1080_1920_U0.grp_dataflow_parent_loop_proc_fu_131.dataflow_in_loop_VITIS_LOOP_38_1_1_U0.readmem4_U0.ap_done & ~mem2mat_1080_1920_U0.grp_dataflow_parent_loop_proc_fu_131.dataflow_in_loop_VITIS_LOOP_38_1_1_U0.readmem4_U0.ap_continue);
assign inst_idle_sigs[5] = mem2mat_1080_1920_U0.grp_dataflow_parent_loop_proc_fu_131.dataflow_in_loop_VITIS_LOOP_38_1_1_U0.dataflow_in_loop_VITIS_LOOP_38_1_1_Loop_VITIS_LOOP_43_2_proc5_U0.ap_idle;
assign inst_block_sigs[5] = (mem2mat_1080_1920_U0.grp_dataflow_parent_loop_proc_fu_131.dataflow_in_loop_VITIS_LOOP_38_1_1_U0.dataflow_in_loop_VITIS_LOOP_38_1_1_Loop_VITIS_LOOP_43_2_proc5_U0.ap_done & ~mem2mat_1080_1920_U0.grp_dataflow_parent_loop_proc_fu_131.dataflow_in_loop_VITIS_LOOP_38_1_1_U0.dataflow_in_loop_VITIS_LOOP_38_1_1_Loop_VITIS_LOOP_43_2_proc5_U0.ap_continue);

assign inst_idle_sigs[6] = 1'b0;
assign inst_idle_sigs[7] = xfMat2AXIvideo_24_16_1080_1920_1_2_U0.ap_idle;
assign inst_idle_sigs[8] = xfMat2AXIvideo_24_16_1080_1920_1_2_U0.grp_xfMat2AXIvideo_24_16_1080_1920_1_2_Pipeline_loop_col_mat2axi_fu_100.ap_idle;

mem2stream_hls_deadlock_idx0_monitor mem2stream_hls_deadlock_idx0_monitor_U (
    .clock(kernel_monitor_clock),
    .reset(kernel_monitor_reset),
    .axis_block_sigs(axis_block_sigs),
    .inst_idle_sigs(inst_idle_sigs),
    .inst_block_sigs(inst_block_sigs),
    .block(kernel_block)
);


always @ (kernel_block or kernel_monitor_reset) begin
    if (kernel_block == 1'b1 && kernel_monitor_reset == 1'b0) begin
        find_kernel_block = 1'b1;
    end
    else begin
        find_kernel_block = 1'b0;
    end
end
