
wire kernel_monitor_reset;
wire kernel_monitor_clock;
wire kernel_monitor_report;
assign kernel_monitor_reset = ~ap_rst_n;
assign kernel_monitor_clock = ap_clk;
assign kernel_monitor_report = 1'b0;
wire [3:0] axis_block_sigs;
wire [13:0] inst_idle_sigs;
wire [6:0] inst_block_sigs;
wire kernel_block;

assign axis_block_sigs[0] = ~AXIvideo2xfMat_24_16_1080_1920_1_2_U0.grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_start_hunt_fu_110.src_TDATA_blk_n;
assign axis_block_sigs[1] = ~AXIvideo2xfMat_24_16_1080_1920_1_2_U0.grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_col_zxi2mat_fu_130.src_TDATA_blk_n;
assign axis_block_sigs[2] = ~AXIvideo2xfMat_24_16_1080_1920_1_2_U0.grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_last_hunt_fu_157.src_TDATA_blk_n;
assign axis_block_sigs[3] = ~xfMat2AXIvideo_24_16_1080_1920_1_2_U0.grp_xfMat2AXIvideo_24_16_1080_1920_1_2_Pipeline_loop_col_mat2axi_fu_76.dst_TDATA_blk_n;

assign inst_idle_sigs[0] = AXIvideo2xfMat_24_16_1080_1920_1_2_U0.ap_idle;
assign inst_block_sigs[0] = (AXIvideo2xfMat_24_16_1080_1920_1_2_U0.ap_done & ~AXIvideo2xfMat_24_16_1080_1920_1_2_U0.ap_continue) | ~AXIvideo2xfMat_24_16_1080_1920_1_2_U0.grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_col_zxi2mat_fu_130.srcImg_data_blk_n;
assign inst_idle_sigs[1] = duplicate_1080_1920_U0.ap_idle;
assign inst_block_sigs[1] = (duplicate_1080_1920_U0.ap_done & ~duplicate_1080_1920_U0.ap_continue) | ~duplicate_1080_1920_U0.srcImg_data_blk_n | ~duplicate_1080_1920_U0.split0_data_blk_n | ~duplicate_1080_1920_U0.split1_data_blk_n;
assign inst_idle_sigs[2] = xfrgb2gray_1080_1920_U0.ap_idle;
assign inst_block_sigs[2] = (xfrgb2gray_1080_1920_U0.ap_done & ~xfrgb2gray_1080_1920_U0.ap_continue) | ~xfrgb2gray_1080_1920_U0.split0_data_blk_n | ~xfrgb2gray_1080_1920_U0.grayImg_data_blk_n;
assign inst_idle_sigs[3] = xFSobelFilter3x3_0_0_1080_1920_1_0_0_1_2_2_2_1_1_1920_false_U0.ap_idle;
assign inst_block_sigs[3] = (xFSobelFilter3x3_0_0_1080_1920_1_0_0_1_2_2_2_1_1_1920_false_U0.ap_done & ~xFSobelFilter3x3_0_0_1080_1920_1_0_0_1_2_2_2_1_1_1920_false_U0.ap_continue) | ~xFSobelFilter3x3_0_0_1080_1920_1_0_0_1_2_2_2_1_1_1920_false_U0.grp_xFSobelFilter3x3_Pipeline_Col_Loop_fu_146.grayImg_data_blk_n | ~xFSobelFilter3x3_0_0_1080_1920_1_0_0_1_2_2_2_1_1_1920_false_U0.grp_xFSobelFilter3x3_Pipeline_Clear_Row_Loop_fu_136.grayImg_data_blk_n | ~xFSobelFilter3x3_0_0_1080_1920_1_0_0_1_2_2_2_1_1_1920_false_U0.sobelImg_x_data_blk_n | ~xFSobelFilter3x3_0_0_1080_1920_1_0_0_1_2_2_2_1_1_1920_false_U0.grp_xFSobelFilter3x3_Pipeline_Col_Loop_fu_146.sobelImg_x_data_blk_n | ~xFSobelFilter3x3_0_0_1080_1920_1_0_0_1_2_2_2_1_1_1920_false_U0.sobelImg_y_data_blk_n | ~xFSobelFilter3x3_0_0_1080_1920_1_0_0_1_2_2_2_1_1_1920_false_U0.grp_xFSobelFilter3x3_Pipeline_Col_Loop_fu_146.sobelImg_y_data_blk_n;
assign inst_idle_sigs[4] = AddWeightedKernel_1080_1920_U0.ap_idle;
assign inst_block_sigs[4] = (AddWeightedKernel_1080_1920_U0.ap_done & ~AddWeightedKernel_1080_1920_U0.ap_continue) | ~AddWeightedKernel_1080_1920_U0.sobelImg_x_data_blk_n | ~AddWeightedKernel_1080_1920_U0.sobelImg_y_data_blk_n | ~AddWeightedKernel_1080_1920_U0.sobelImg_data_blk_n;
assign inst_idle_sigs[5] = sum_of_stream_1080_1920_U0.ap_idle;
assign inst_block_sigs[5] = (sum_of_stream_1080_1920_U0.ap_done & ~sum_of_stream_1080_1920_U0.ap_continue) | ~sum_of_stream_1080_1920_U0.sobelImg_data_blk_n;
assign inst_idle_sigs[6] = xfMat2AXIvideo_24_16_1080_1920_1_2_U0.ap_idle;
assign inst_block_sigs[6] = (xfMat2AXIvideo_24_16_1080_1920_1_2_U0.ap_done & ~xfMat2AXIvideo_24_16_1080_1920_1_2_U0.ap_continue) | ~xfMat2AXIvideo_24_16_1080_1920_1_2_U0.grp_xfMat2AXIvideo_24_16_1080_1920_1_2_Pipeline_loop_col_mat2axi_fu_76.split1_data_blk_n;

assign inst_idle_sigs[7] = 1'b0;
assign inst_idle_sigs[8] = AXIvideo2xfMat_24_16_1080_1920_1_2_U0.ap_idle;
assign inst_idle_sigs[9] = AXIvideo2xfMat_24_16_1080_1920_1_2_U0.grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_start_hunt_fu_110.ap_idle;
assign inst_idle_sigs[10] = AXIvideo2xfMat_24_16_1080_1920_1_2_U0.grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_col_zxi2mat_fu_130.ap_idle;
assign inst_idle_sigs[11] = AXIvideo2xfMat_24_16_1080_1920_1_2_U0.grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_last_hunt_fu_157.ap_idle;
assign inst_idle_sigs[12] = xfMat2AXIvideo_24_16_1080_1920_1_2_U0.ap_idle;
assign inst_idle_sigs[13] = xfMat2AXIvideo_24_16_1080_1920_1_2_U0.grp_xfMat2AXIvideo_24_16_1080_1920_1_2_Pipeline_loop_col_mat2axi_fu_76.ap_idle;

sobel_focus_hls_deadlock_idx0_monitor sobel_focus_hls_deadlock_idx0_monitor_U (
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
