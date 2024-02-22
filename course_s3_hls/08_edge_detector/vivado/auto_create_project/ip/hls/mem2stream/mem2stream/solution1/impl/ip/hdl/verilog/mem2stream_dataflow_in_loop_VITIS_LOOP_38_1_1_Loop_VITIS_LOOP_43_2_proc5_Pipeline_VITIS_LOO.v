// ==============================================================
// Generated by Vitis HLS v2023.1
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// ==============================================================

`timescale 1 ns / 1 ps 

module mem2stream_dataflow_in_loop_VITIS_LOOP_38_1_1_Loop_VITIS_LOOP_43_2_proc5_Pipeline_VITIS_LOO (
        ap_clk,
        ap_rst,
        ap_start,
        ap_done,
        ap_idle,
        ap_ready,
        img_data_din,
        img_data_num_data_valid,
        img_data_fifo_cap,
        img_data_full_n,
        img_data_write,
        cacheBuff_dout,
        cacheBuff_num_data_valid,
        cacheBuff_fifo_cap,
        cacheBuff_empty_n,
        cacheBuff_read,
        empty
);

parameter    ap_ST_fsm_pp0_stage0 = 4'd1;
parameter    ap_ST_fsm_pp0_stage1 = 4'd2;
parameter    ap_ST_fsm_pp0_stage2 = 4'd4;
parameter    ap_ST_fsm_pp0_stage3 = 4'd8;

input   ap_clk;
input   ap_rst;
input   ap_start;
output   ap_done;
output   ap_idle;
output   ap_ready;
output  [23:0] img_data_din;
input  [1:0] img_data_num_data_valid;
input  [1:0] img_data_fifo_cap;
input   img_data_full_n;
output   img_data_write;
input  [31:0] cacheBuff_dout;
input  [12:0] cacheBuff_num_data_valid;
input  [12:0] cacheBuff_fifo_cap;
input   cacheBuff_empty_n;
output   cacheBuff_read;
input  [31:0] empty;

reg ap_idle;
reg[23:0] img_data_din;
reg img_data_write;
reg cacheBuff_read;

(* fsm_encoding = "none" *) reg   [3:0] ap_CS_fsm;
wire    ap_CS_fsm_pp0_stage0;
reg    ap_enable_reg_pp0_iter0;
reg    ap_enable_reg_pp0_iter1;
reg    ap_idle_pp0;
wire    ap_block_state1_pp0_stage0_iter0;
reg    ap_block_state5_pp0_stage0_iter1;
reg    ap_block_pp0_stage0_subdone;
wire   [0:0] icmp_ln43_fu_91_p2;
reg    ap_condition_exit_pp0_iter0_stage0;
wire    ap_loop_exit_ready;
reg    ap_ready_int;
wire    ap_CS_fsm_pp0_stage3;
reg   [0:0] icmp_ln43_reg_178;
reg    ap_block_state4_pp0_stage3_iter0;
reg    ap_block_pp0_stage3_subdone;
reg    cacheBuff_blk_n;
wire    ap_CS_fsm_pp0_stage1;
wire    ap_block_pp0_stage1;
wire    ap_CS_fsm_pp0_stage2;
wire    ap_block_pp0_stage2;
wire    ap_block_pp0_stage3;
reg    img_data_blk_n;
wire    ap_block_pp0_stage0;
reg   [31:0] col_2_reg_173;
reg    ap_block_pp0_stage0_11001;
reg   [7:0] trunc_ln_reg_182;
reg    ap_block_state2_pp0_stage1_iter0;
reg    ap_block_pp0_stage1_11001;
reg   [15:0] tmp_4_reg_187;
reg    ap_block_state3_pp0_stage2_iter0;
reg    ap_block_pp0_stage2_11001;
reg   [23:0] pixel_3_reg_192;
reg    ap_block_pp0_stage3_11001;
reg    ap_enable_reg_pp0_iter0_reg;
reg   [31:0] col_fu_60;
wire   [31:0] col_3_fu_156_p2;
wire    ap_loop_init;
reg   [31:0] ap_sig_allocacmp_col_2;
wire   [23:0] pixel_fu_97_p1;
reg    ap_block_pp0_stage1_01001;
wire   [23:0] pixel_1_fu_116_p3;
reg    ap_block_pp0_stage2_01001;
wire   [23:0] pixel_2_fu_138_p3;
reg    ap_block_pp0_stage3_01001;
reg    ap_block_pp0_stage0_01001;
wire   [15:0] trunc_ln52_fu_112_p1;
wire   [7:0] trunc_ln56_fu_134_p1;
reg    ap_done_reg;
wire    ap_continue_int;
reg    ap_done_int;
reg   [3:0] ap_NS_fsm;
reg    ap_idle_pp0_1to1;
reg    ap_block_pp0_stage1_subdone;
reg    ap_block_pp0_stage2_subdone;
wire    ap_enable_pp0;
wire    ap_start_int;
wire    ap_ce_reg;

// power-on initialization
initial begin
#0 ap_CS_fsm = 4'd1;
#0 ap_enable_reg_pp0_iter1 = 1'b0;
#0 ap_enable_reg_pp0_iter0_reg = 1'b0;
#0 ap_done_reg = 1'b0;
end

mem2stream_flow_control_loop_pipe_sequential_init flow_control_loop_pipe_sequential_init_U(
    .ap_clk(ap_clk),
    .ap_rst(ap_rst),
    .ap_start(ap_start),
    .ap_ready(ap_ready),
    .ap_done(ap_done),
    .ap_start_int(ap_start_int),
    .ap_loop_init(ap_loop_init),
    .ap_ready_int(ap_ready_int),
    .ap_loop_exit_ready(ap_condition_exit_pp0_iter0_stage0),
    .ap_loop_exit_done(ap_done_int),
    .ap_continue_int(ap_continue_int),
    .ap_done_int(ap_done_int)
);

always @ (posedge ap_clk) begin
    if (ap_rst == 1'b1) begin
        ap_CS_fsm <= ap_ST_fsm_pp0_stage0;
    end else begin
        ap_CS_fsm <= ap_NS_fsm;
    end
end

always @ (posedge ap_clk) begin
    if (ap_rst == 1'b1) begin
        ap_done_reg <= 1'b0;
    end else begin
        if ((ap_continue_int == 1'b1)) begin
            ap_done_reg <= 1'b0;
        end else if (((ap_loop_exit_ready == 1'b1) & (1'b0 == ap_block_pp0_stage0_subdone) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
            ap_done_reg <= 1'b1;
        end
    end
end

always @ (posedge ap_clk) begin
    if (ap_rst == 1'b1) begin
        ap_enable_reg_pp0_iter0_reg <= 1'b0;
    end else begin
        if ((1'b1 == ap_condition_exit_pp0_iter0_stage0)) begin
            ap_enable_reg_pp0_iter0_reg <= 1'b0;
        end else if ((1'b1 == ap_CS_fsm_pp0_stage0)) begin
            ap_enable_reg_pp0_iter0_reg <= ap_start_int;
        end
    end
end

always @ (posedge ap_clk) begin
    if (ap_rst == 1'b1) begin
        ap_enable_reg_pp0_iter1 <= 1'b0;
    end else begin
        if (((1'b0 == ap_block_pp0_stage0_subdone) & (ap_enable_reg_pp0_iter1 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
            ap_enable_reg_pp0_iter1 <= 1'b0;
        end else if (((1'b0 == ap_block_pp0_stage3_subdone) & (1'b1 == ap_CS_fsm_pp0_stage3))) begin
            ap_enable_reg_pp0_iter1 <= ap_enable_reg_pp0_iter0;
        end
    end
end

always @ (posedge ap_clk) begin
    if (((1'b0 == ap_block_pp0_stage0_11001) & (1'b1 == ap_CS_fsm_pp0_stage0) & (ap_loop_init == 1'b1))) begin
        col_fu_60 <= 32'd0;
    end else if (((icmp_ln43_reg_178 == 1'd0) & (1'b0 == ap_block_pp0_stage3_11001) & (ap_enable_reg_pp0_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage3))) begin
        col_fu_60 <= col_3_fu_156_p2;
    end
end

always @ (posedge ap_clk) begin
    if (((1'b0 == ap_block_pp0_stage0_11001) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        col_2_reg_173 <= ap_sig_allocacmp_col_2;
        icmp_ln43_reg_178 <= icmp_ln43_fu_91_p2;
    end
end

always @ (posedge ap_clk) begin
    if (((icmp_ln43_reg_178 == 1'd0) & (1'b0 == ap_block_pp0_stage3_11001) & (1'b1 == ap_CS_fsm_pp0_stage3))) begin
        pixel_3_reg_192 <= {{cacheBuff_dout[31:8]}};
    end
end

always @ (posedge ap_clk) begin
    if (((icmp_ln43_reg_178 == 1'd0) & (1'b0 == ap_block_pp0_stage2_11001) & (1'b1 == ap_CS_fsm_pp0_stage2))) begin
        tmp_4_reg_187 <= {{cacheBuff_dout[31:16]}};
    end
end

always @ (posedge ap_clk) begin
    if (((icmp_ln43_reg_178 == 1'd0) & (1'b0 == ap_block_pp0_stage1_11001) & (1'b1 == ap_CS_fsm_pp0_stage1))) begin
        trunc_ln_reg_182 <= {{cacheBuff_dout[31:24]}};
    end
end

always @ (*) begin
    if (((icmp_ln43_fu_91_p2 == 1'd1) & (1'b0 == ap_block_pp0_stage0_subdone) & (ap_enable_reg_pp0_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        ap_condition_exit_pp0_iter0_stage0 = 1'b1;
    end else begin
        ap_condition_exit_pp0_iter0_stage0 = 1'b0;
    end
end

always @ (*) begin
    if (((ap_loop_exit_ready == 1'b1) & (1'b0 == ap_block_pp0_stage0_subdone) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        ap_done_int = 1'b1;
    end else begin
        ap_done_int = ap_done_reg;
    end
end

always @ (*) begin
    if ((1'b1 == ap_CS_fsm_pp0_stage0)) begin
        ap_enable_reg_pp0_iter0 = ap_start_int;
    end else begin
        ap_enable_reg_pp0_iter0 = ap_enable_reg_pp0_iter0_reg;
    end
end

always @ (*) begin
    if (((ap_idle_pp0 == 1'b1) & (ap_start_int == 1'b0) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        ap_idle = 1'b1;
    end else begin
        ap_idle = 1'b0;
    end
end

always @ (*) begin
    if (((ap_enable_reg_pp0_iter1 == 1'b0) & (ap_enable_reg_pp0_iter0 == 1'b0))) begin
        ap_idle_pp0 = 1'b1;
    end else begin
        ap_idle_pp0 = 1'b0;
    end
end

always @ (*) begin
    if ((ap_enable_reg_pp0_iter1 == 1'b0)) begin
        ap_idle_pp0_1to1 = 1'b1;
    end else begin
        ap_idle_pp0_1to1 = 1'b0;
    end
end

always @ (*) begin
    if (((1'b0 == ap_block_pp0_stage3_subdone) & (ap_enable_reg_pp0_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage3))) begin
        ap_ready_int = 1'b1;
    end else begin
        ap_ready_int = 1'b0;
    end
end

always @ (*) begin
    if (((1'b0 == ap_block_pp0_stage0) & (1'b1 == ap_CS_fsm_pp0_stage0) & (ap_loop_init == 1'b1))) begin
        ap_sig_allocacmp_col_2 = 32'd0;
    end else begin
        ap_sig_allocacmp_col_2 = col_fu_60;
    end
end

always @ (*) begin
    if ((((icmp_ln43_reg_178 == 1'd0) & (1'b0 == ap_block_pp0_stage1) & (ap_enable_reg_pp0_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage1)) | ((icmp_ln43_reg_178 == 1'd0) & (1'b0 == ap_block_pp0_stage3) & (ap_enable_reg_pp0_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage3)) | ((icmp_ln43_reg_178 == 1'd0) & (1'b0 == ap_block_pp0_stage2) & (ap_enable_reg_pp0_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage2)))) begin
        cacheBuff_blk_n = cacheBuff_empty_n;
    end else begin
        cacheBuff_blk_n = 1'b1;
    end
end

always @ (*) begin
    if ((((icmp_ln43_reg_178 == 1'd0) & (1'b0 == ap_block_pp0_stage3_11001) & (ap_enable_reg_pp0_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage3)) | ((icmp_ln43_reg_178 == 1'd0) & (1'b0 == ap_block_pp0_stage2_11001) & (ap_enable_reg_pp0_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage2)) | ((icmp_ln43_reg_178 == 1'd0) & (1'b0 == ap_block_pp0_stage1_11001) & (ap_enable_reg_pp0_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage1)))) begin
        cacheBuff_read = 1'b1;
    end else begin
        cacheBuff_read = 1'b0;
    end
end

always @ (*) begin
    if ((((icmp_ln43_reg_178 == 1'd0) & (1'b0 == ap_block_pp0_stage1) & (ap_enable_reg_pp0_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage1)) | ((icmp_ln43_reg_178 == 1'd0) & (1'b0 == ap_block_pp0_stage3) & (ap_enable_reg_pp0_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage3)) | ((icmp_ln43_reg_178 == 1'd0) & (1'b0 == ap_block_pp0_stage2) & (ap_enable_reg_pp0_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage2)) | ((1'b0 == ap_block_pp0_stage0) & (ap_enable_reg_pp0_iter1 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0)))) begin
        img_data_blk_n = img_data_full_n;
    end else begin
        img_data_blk_n = 1'b1;
    end
end

always @ (*) begin
    if (((1'b0 == ap_block_pp0_stage0_01001) & (ap_enable_reg_pp0_iter1 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        img_data_din = pixel_3_reg_192;
    end else if (((icmp_ln43_reg_178 == 1'd0) & (1'b0 == ap_block_pp0_stage3_01001) & (ap_enable_reg_pp0_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage3))) begin
        img_data_din = pixel_2_fu_138_p3;
    end else if (((icmp_ln43_reg_178 == 1'd0) & (1'b0 == ap_block_pp0_stage2_01001) & (ap_enable_reg_pp0_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage2))) begin
        img_data_din = pixel_1_fu_116_p3;
    end else if (((icmp_ln43_reg_178 == 1'd0) & (1'b0 == ap_block_pp0_stage1_01001) & (ap_enable_reg_pp0_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage1))) begin
        img_data_din = pixel_fu_97_p1;
    end else begin
        img_data_din = 'bx;
    end
end

always @ (*) begin
    if ((((icmp_ln43_reg_178 == 1'd0) & (1'b0 == ap_block_pp0_stage3_11001) & (ap_enable_reg_pp0_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage3)) | ((icmp_ln43_reg_178 == 1'd0) & (1'b0 == ap_block_pp0_stage2_11001) & (ap_enable_reg_pp0_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage2)) | ((icmp_ln43_reg_178 == 1'd0) & (1'b0 == ap_block_pp0_stage1_11001) & (ap_enable_reg_pp0_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage1)) | ((1'b0 == ap_block_pp0_stage0_11001) & (ap_enable_reg_pp0_iter1 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0)))) begin
        img_data_write = 1'b1;
    end else begin
        img_data_write = 1'b0;
    end
end

always @ (*) begin
    case (ap_CS_fsm)
        ap_ST_fsm_pp0_stage0 : begin
            if ((1'b1 == ap_condition_exit_pp0_iter0_stage0)) begin
                ap_NS_fsm = ap_ST_fsm_pp0_stage0;
            end else if ((~((ap_start_int == 1'b0) & (ap_idle_pp0_1to1 == 1'b1)) & (1'b0 == ap_block_pp0_stage0_subdone))) begin
                ap_NS_fsm = ap_ST_fsm_pp0_stage1;
            end else begin
                ap_NS_fsm = ap_ST_fsm_pp0_stage0;
            end
        end
        ap_ST_fsm_pp0_stage1 : begin
            if ((1'b0 == ap_block_pp0_stage1_subdone)) begin
                ap_NS_fsm = ap_ST_fsm_pp0_stage2;
            end else begin
                ap_NS_fsm = ap_ST_fsm_pp0_stage1;
            end
        end
        ap_ST_fsm_pp0_stage2 : begin
            if ((1'b0 == ap_block_pp0_stage2_subdone)) begin
                ap_NS_fsm = ap_ST_fsm_pp0_stage3;
            end else begin
                ap_NS_fsm = ap_ST_fsm_pp0_stage2;
            end
        end
        ap_ST_fsm_pp0_stage3 : begin
            if ((1'b0 == ap_block_pp0_stage3_subdone)) begin
                ap_NS_fsm = ap_ST_fsm_pp0_stage0;
            end else begin
                ap_NS_fsm = ap_ST_fsm_pp0_stage3;
            end
        end
        default : begin
            ap_NS_fsm = 'bx;
        end
    endcase
end

assign ap_CS_fsm_pp0_stage0 = ap_CS_fsm[32'd0];

assign ap_CS_fsm_pp0_stage1 = ap_CS_fsm[32'd1];

assign ap_CS_fsm_pp0_stage2 = ap_CS_fsm[32'd2];

assign ap_CS_fsm_pp0_stage3 = ap_CS_fsm[32'd3];

assign ap_block_pp0_stage0 = ~(1'b1 == 1'b1);

always @ (*) begin
    ap_block_pp0_stage0_01001 = ((img_data_full_n == 1'b0) & (ap_enable_reg_pp0_iter1 == 1'b1));
end

always @ (*) begin
    ap_block_pp0_stage0_11001 = ((img_data_full_n == 1'b0) & (ap_enable_reg_pp0_iter1 == 1'b1));
end

always @ (*) begin
    ap_block_pp0_stage0_subdone = ((img_data_full_n == 1'b0) & (ap_enable_reg_pp0_iter1 == 1'b1));
end

assign ap_block_pp0_stage1 = ~(1'b1 == 1'b1);

always @ (*) begin
    ap_block_pp0_stage1_01001 = ((ap_enable_reg_pp0_iter0 == 1'b1) & (((icmp_ln43_reg_178 == 1'd0) & (cacheBuff_empty_n == 1'b0)) | ((icmp_ln43_reg_178 == 1'd0) & (img_data_full_n == 1'b0))));
end

always @ (*) begin
    ap_block_pp0_stage1_11001 = ((ap_enable_reg_pp0_iter0 == 1'b1) & (((icmp_ln43_reg_178 == 1'd0) & (cacheBuff_empty_n == 1'b0)) | ((icmp_ln43_reg_178 == 1'd0) & (img_data_full_n == 1'b0))));
end

always @ (*) begin
    ap_block_pp0_stage1_subdone = ((ap_enable_reg_pp0_iter0 == 1'b1) & (((icmp_ln43_reg_178 == 1'd0) & (cacheBuff_empty_n == 1'b0)) | ((icmp_ln43_reg_178 == 1'd0) & (img_data_full_n == 1'b0))));
end

assign ap_block_pp0_stage2 = ~(1'b1 == 1'b1);

always @ (*) begin
    ap_block_pp0_stage2_01001 = ((ap_enable_reg_pp0_iter0 == 1'b1) & (((icmp_ln43_reg_178 == 1'd0) & (cacheBuff_empty_n == 1'b0)) | ((icmp_ln43_reg_178 == 1'd0) & (img_data_full_n == 1'b0))));
end

always @ (*) begin
    ap_block_pp0_stage2_11001 = ((ap_enable_reg_pp0_iter0 == 1'b1) & (((icmp_ln43_reg_178 == 1'd0) & (cacheBuff_empty_n == 1'b0)) | ((icmp_ln43_reg_178 == 1'd0) & (img_data_full_n == 1'b0))));
end

always @ (*) begin
    ap_block_pp0_stage2_subdone = ((ap_enable_reg_pp0_iter0 == 1'b1) & (((icmp_ln43_reg_178 == 1'd0) & (cacheBuff_empty_n == 1'b0)) | ((icmp_ln43_reg_178 == 1'd0) & (img_data_full_n == 1'b0))));
end

assign ap_block_pp0_stage3 = ~(1'b1 == 1'b1);

always @ (*) begin
    ap_block_pp0_stage3_01001 = ((ap_enable_reg_pp0_iter0 == 1'b1) & (((icmp_ln43_reg_178 == 1'd0) & (cacheBuff_empty_n == 1'b0)) | ((icmp_ln43_reg_178 == 1'd0) & (img_data_full_n == 1'b0))));
end

always @ (*) begin
    ap_block_pp0_stage3_11001 = ((ap_enable_reg_pp0_iter0 == 1'b1) & (((icmp_ln43_reg_178 == 1'd0) & (cacheBuff_empty_n == 1'b0)) | ((icmp_ln43_reg_178 == 1'd0) & (img_data_full_n == 1'b0))));
end

always @ (*) begin
    ap_block_pp0_stage3_subdone = ((ap_enable_reg_pp0_iter0 == 1'b1) & (((icmp_ln43_reg_178 == 1'd0) & (cacheBuff_empty_n == 1'b0)) | ((icmp_ln43_reg_178 == 1'd0) & (img_data_full_n == 1'b0))));
end

assign ap_block_state1_pp0_stage0_iter0 = ~(1'b1 == 1'b1);

always @ (*) begin
    ap_block_state2_pp0_stage1_iter0 = (((icmp_ln43_reg_178 == 1'd0) & (cacheBuff_empty_n == 1'b0)) | ((icmp_ln43_reg_178 == 1'd0) & (img_data_full_n == 1'b0)));
end

always @ (*) begin
    ap_block_state3_pp0_stage2_iter0 = (((icmp_ln43_reg_178 == 1'd0) & (cacheBuff_empty_n == 1'b0)) | ((icmp_ln43_reg_178 == 1'd0) & (img_data_full_n == 1'b0)));
end

always @ (*) begin
    ap_block_state4_pp0_stage3_iter0 = (((icmp_ln43_reg_178 == 1'd0) & (cacheBuff_empty_n == 1'b0)) | ((icmp_ln43_reg_178 == 1'd0) & (img_data_full_n == 1'b0)));
end

always @ (*) begin
    ap_block_state5_pp0_stage0_iter1 = (img_data_full_n == 1'b0);
end

assign ap_enable_pp0 = (ap_idle_pp0 ^ 1'b1);

assign ap_loop_exit_ready = ap_condition_exit_pp0_iter0_stage0;

assign col_3_fu_156_p2 = (col_2_reg_173 + 32'd4);

assign icmp_ln43_fu_91_p2 = ((ap_sig_allocacmp_col_2 == empty) ? 1'b1 : 1'b0);

assign pixel_1_fu_116_p3 = {{trunc_ln52_fu_112_p1}, {trunc_ln_reg_182}};

assign pixel_2_fu_138_p3 = {{trunc_ln56_fu_134_p1}, {tmp_4_reg_187}};

assign pixel_fu_97_p1 = cacheBuff_dout[23:0];

assign trunc_ln52_fu_112_p1 = cacheBuff_dout[15:0];

assign trunc_ln56_fu_134_p1 = cacheBuff_dout[7:0];

endmodule //mem2stream_dataflow_in_loop_VITIS_LOOP_38_1_1_Loop_VITIS_LOOP_43_2_proc5_Pipeline_VITIS_LOO