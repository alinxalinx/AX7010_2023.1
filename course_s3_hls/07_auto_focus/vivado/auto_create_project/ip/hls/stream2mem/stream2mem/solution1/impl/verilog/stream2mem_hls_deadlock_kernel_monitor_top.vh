
wire kernel_monitor_reset;
wire kernel_monitor_clock;
wire kernel_monitor_report;
assign kernel_monitor_reset = ~ap_rst_n;
assign kernel_monitor_clock = ap_clk;
assign kernel_monitor_report = 1'b0;
wire [2:0] axis_block_sigs;
wire [11:0] inst_idle_sigs;
wire [6:0] inst_block_sigs;
wire kernel_block;

assign axis_block_sigs[0] = ~AXIvideo2xfMat_24_16_1080_1920_1_2_U0.grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_start_hunt_fu_148.vstream_TDATA_blk_n;
assign axis_block_sigs[1] = ~AXIvideo2xfMat_24_16_1080_1920_1_2_U0.grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_col_zxi2mat_fu_168.vstream_TDATA_blk_n;
assign axis_block_sigs[2] = ~AXIvideo2xfMat_24_16_1080_1920_1_2_U0.grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_last_hunt_fu_195.vstream_TDATA_blk_n;

assign inst_idle_sigs[0] = AXIvideo2xfMat_24_16_1080_1920_1_2_U0.ap_idle;
assign inst_block_sigs[0] = (AXIvideo2xfMat_24_16_1080_1920_1_2_U0.ap_done & ~AXIvideo2xfMat_24_16_1080_1920_1_2_U0.ap_continue) | ~AXIvideo2xfMat_24_16_1080_1920_1_2_U0.grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_col_zxi2mat_fu_168.img_data_blk_n | ~AXIvideo2xfMat_24_16_1080_1920_1_2_U0.img_rows_c_blk_n | ~AXIvideo2xfMat_24_16_1080_1920_1_2_U0.img_cols_c_blk_n;
assign inst_idle_sigs[1] = mat2mem_1080_1920_U0.ap_idle;
assign inst_block_sigs[1] = (mat2mem_1080_1920_U0.ap_done & ~mat2mem_1080_1920_U0.ap_continue) | ~mat2mem_1080_1920_U0.img_rows_blk_n | ~mat2mem_1080_1920_U0.img_cols_blk_n | ~mat2mem_1080_1920_U0.grp_dataflow_parent_loop_proc_fu_105.dataflow_in_loop_VITIS_LOOP_25_1_1_U0.dataflow_in_loop_VITIS_LOOP_25_1_1_Loop_VITIS_LOOP_29_2_proc13_U0.img_data_blk_n;
assign inst_idle_sigs[2] = mat2mem_1080_1920_U0.grp_dataflow_parent_loop_proc_fu_105.dataflow_in_loop_VITIS_LOOP_25_1_1_U0.ap_idle;
assign inst_block_sigs[2] = (mat2mem_1080_1920_U0.grp_dataflow_parent_loop_proc_fu_105.dataflow_in_loop_VITIS_LOOP_25_1_1_U0.ap_done & ~mat2mem_1080_1920_U0.grp_dataflow_parent_loop_proc_fu_105.dataflow_in_loop_VITIS_LOOP_25_1_1_U0.ap_continue);
assign inst_idle_sigs[3] = mat2mem_1080_1920_U0.grp_dataflow_parent_loop_proc_fu_105.dataflow_in_loop_VITIS_LOOP_25_1_1_U0.entry_proc_U0.ap_idle;
assign inst_block_sigs[3] = (mat2mem_1080_1920_U0.grp_dataflow_parent_loop_proc_fu_105.dataflow_in_loop_VITIS_LOOP_25_1_1_U0.entry_proc_U0.ap_done & ~mat2mem_1080_1920_U0.grp_dataflow_parent_loop_proc_fu_105.dataflow_in_loop_VITIS_LOOP_25_1_1_U0.entry_proc_U0.ap_continue);
assign inst_idle_sigs[4] = mat2mem_1080_1920_U0.grp_dataflow_parent_loop_proc_fu_105.dataflow_in_loop_VITIS_LOOP_25_1_1_U0.dataflow_in_loop_VITIS_LOOP_25_1_1_Loop_VITIS_LOOP_29_2_proc13_U0.ap_idle;
assign inst_block_sigs[4] = (mat2mem_1080_1920_U0.grp_dataflow_parent_loop_proc_fu_105.dataflow_in_loop_VITIS_LOOP_25_1_1_U0.dataflow_in_loop_VITIS_LOOP_25_1_1_Loop_VITIS_LOOP_29_2_proc13_U0.ap_done & ~mat2mem_1080_1920_U0.grp_dataflow_parent_loop_proc_fu_105.dataflow_in_loop_VITIS_LOOP_25_1_1_U0.dataflow_in_loop_VITIS_LOOP_25_1_1_Loop_VITIS_LOOP_29_2_proc13_U0.ap_continue);
assign inst_idle_sigs[5] = mat2mem_1080_1920_U0.grp_dataflow_parent_loop_proc_fu_105.dataflow_in_loop_VITIS_LOOP_25_1_1_U0.dataflow_in_loop_VITIS_LOOP_25_1_1_Block_for_inc69_proc4_U0.ap_idle;
assign inst_block_sigs[5] = (mat2mem_1080_1920_U0.grp_dataflow_parent_loop_proc_fu_105.dataflow_in_loop_VITIS_LOOP_25_1_1_U0.dataflow_in_loop_VITIS_LOOP_25_1_1_Block_for_inc69_proc4_U0.ap_done & ~mat2mem_1080_1920_U0.grp_dataflow_parent_loop_proc_fu_105.dataflow_in_loop_VITIS_LOOP_25_1_1_U0.dataflow_in_loop_VITIS_LOOP_25_1_1_Block_for_inc69_proc4_U0.ap_continue);
assign inst_idle_sigs[6] = mat2mem_1080_1920_U0.grp_dataflow_parent_loop_proc_fu_105.dataflow_in_loop_VITIS_LOOP_25_1_1_U0.writemem5_U0.ap_idle;
assign inst_block_sigs[6] = (mat2mem_1080_1920_U0.grp_dataflow_parent_loop_proc_fu_105.dataflow_in_loop_VITIS_LOOP_25_1_1_U0.writemem5_U0.ap_done & ~mat2mem_1080_1920_U0.grp_dataflow_parent_loop_proc_fu_105.dataflow_in_loop_VITIS_LOOP_25_1_1_U0.writemem5_U0.ap_continue);

assign inst_idle_sigs[7] = 1'b0;
assign inst_idle_sigs[8] = AXIvideo2xfMat_24_16_1080_1920_1_2_U0.ap_idle;
assign inst_idle_sigs[9] = AXIvideo2xfMat_24_16_1080_1920_1_2_U0.grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_start_hunt_fu_148.ap_idle;
assign inst_idle_sigs[10] = AXIvideo2xfMat_24_16_1080_1920_1_2_U0.grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_col_zxi2mat_fu_168.ap_idle;
assign inst_idle_sigs[11] = AXIvideo2xfMat_24_16_1080_1920_1_2_U0.grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_last_hunt_fu_195.ap_idle;

stream2mem_hls_deadlock_idx0_monitor stream2mem_hls_deadlock_idx0_monitor_U (
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
