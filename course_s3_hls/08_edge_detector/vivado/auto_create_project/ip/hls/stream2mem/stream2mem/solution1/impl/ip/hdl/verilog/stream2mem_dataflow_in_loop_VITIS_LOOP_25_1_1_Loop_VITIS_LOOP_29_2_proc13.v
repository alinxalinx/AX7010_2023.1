// ==============================================================
// Generated by Vitis HLS v2023.1
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// ==============================================================

`timescale 1 ns / 1 ps 

module stream2mem_dataflow_in_loop_VITIS_LOOP_25_1_1_Loop_VITIS_LOOP_29_2_proc13 (
        ap_clk,
        ap_rst,
        ap_start,
        ap_done,
        ap_continue,
        ap_idle,
        ap_ready,
        cacheBuff_i_din,
        cacheBuff_i_num_data_valid,
        cacheBuff_i_fifo_cap,
        cacheBuff_i_full_n,
        cacheBuff_i_write,
        p_read,
        img_data_dout,
        img_data_num_data_valid,
        img_data_fifo_cap,
        img_data_empty_n,
        img_data_read
);

parameter    ap_ST_fsm_pp0_stage0 = 12'd1;
parameter    ap_ST_fsm_pp0_stage1 = 12'd2;
parameter    ap_ST_fsm_pp0_stage2 = 12'd4;
parameter    ap_ST_fsm_pp0_stage3 = 12'd8;
parameter    ap_ST_fsm_pp0_stage4 = 12'd16;
parameter    ap_ST_fsm_pp0_stage5 = 12'd32;
parameter    ap_ST_fsm_pp0_stage6 = 12'd64;
parameter    ap_ST_fsm_pp0_stage7 = 12'd128;
parameter    ap_ST_fsm_pp0_stage8 = 12'd256;
parameter    ap_ST_fsm_pp0_stage9 = 12'd512;
parameter    ap_ST_fsm_pp0_stage10 = 12'd1024;
parameter    ap_ST_fsm_pp0_stage11 = 12'd2048;

input   ap_clk;
input   ap_rst;
input   ap_start;
output   ap_done;
input   ap_continue;
output   ap_idle;
output   ap_ready;
output  [7:0] cacheBuff_i_din;
input  [9:0] cacheBuff_i_num_data_valid;
input  [9:0] cacheBuff_i_fifo_cap;
input   cacheBuff_i_full_n;
output   cacheBuff_i_write;
input  [7:0] p_read;
input  [23:0] img_data_dout;
input  [1:0] img_data_num_data_valid;
input  [1:0] img_data_fifo_cap;
input   img_data_empty_n;
output   img_data_read;

reg ap_idle;
reg[7:0] cacheBuff_i_din;
reg cacheBuff_i_write;
reg img_data_read;

(* fsm_encoding = "none" *) reg   [11:0] ap_CS_fsm;
wire    ap_CS_fsm_pp0_stage0;
reg    ap_enable_reg_pp0_iter0;
reg    ap_enable_reg_pp0_iter1;
reg    ap_idle_pp0;
reg    ap_done_reg;
reg    ap_block_state1_pp0_stage0_iter0;
reg    ap_block_state13_pp0_stage0_iter1;
reg    ap_block_pp0_stage0_subdone;
wire   [0:0] icmp_ln29_fu_127_p2;
reg    ap_condition_exit_pp0_iter0_stage0;
wire    ap_loop_exit_ready;
reg    ap_ready_int;
wire    ap_CS_fsm_pp0_stage11;
reg   [0:0] icmp_ln29_reg_169;
reg    ap_block_state12_pp0_stage11_iter0;
reg    ap_block_pp0_stage11_subdone;
reg    img_data_blk_n;
wire    ap_CS_fsm_pp0_stage1;
wire    ap_block_pp0_stage1;
wire    ap_CS_fsm_pp0_stage5;
wire    ap_block_pp0_stage5;
wire    ap_CS_fsm_pp0_stage7;
wire    ap_block_pp0_stage7;
wire    ap_CS_fsm_pp0_stage8;
wire    ap_block_pp0_stage8;
reg    cacheBuff_i_blk_n;
wire    ap_CS_fsm_pp0_stage2;
wire    ap_block_pp0_stage2;
wire    ap_CS_fsm_pp0_stage3;
wire    ap_block_pp0_stage3;
wire    ap_CS_fsm_pp0_stage4;
wire    ap_block_pp0_stage4;
wire    ap_CS_fsm_pp0_stage6;
wire    ap_block_pp0_stage6;
wire    ap_CS_fsm_pp0_stage9;
wire    ap_block_pp0_stage9;
wire    ap_CS_fsm_pp0_stage10;
wire    ap_block_pp0_stage10;
wire    ap_block_pp0_stage11;
wire    ap_block_pp0_stage0;
reg   [7:0] reg_101;
reg    ap_block_state2_pp0_stage1_iter0;
reg    ap_block_pp0_stage1_11001;
reg    ap_block_state9_pp0_stage8_iter0;
reg    ap_block_pp0_stage8_11001;
reg   [7:0] reg_106;
reg    ap_block_state6_pp0_stage5_iter0;
reg    ap_block_pp0_stage5_11001;
reg    ap_block_state8_pp0_stage7_iter0;
reg    ap_block_pp0_stage7_11001;
reg   [11:0] col_2_reg_164;
reg    ap_block_pp0_stage0_11001;
wire   [7:0] trunc_ln38_fu_143_p1;
reg   [7:0] trunc_ln38_reg_173;
reg    ap_enable_reg_pp0_iter0_reg;
reg   [11:0] col_fu_56;
wire   [11:0] col_3_fu_147_p2;
reg    ap_block_pp0_stage11_11001;
wire    ap_loop_init;
reg   [11:0] ap_sig_allocacmp_col_2;
wire   [7:0] trunc_ln34_fu_133_p1;
reg    ap_block_pp0_stage1_01001;
reg    ap_block_state3_pp0_stage2_iter0;
reg    ap_block_pp0_stage2_01001;
reg    ap_block_state4_pp0_stage3_iter0;
reg    ap_block_pp0_stage3_01001;
reg    ap_block_state5_pp0_stage4_iter0;
reg    ap_block_pp0_stage4_01001;
reg    ap_block_pp0_stage5_01001;
reg    ap_block_state7_pp0_stage6_iter0;
reg    ap_block_pp0_stage6_01001;
wire   [7:0] trunc_ln36_fu_138_p1;
reg    ap_block_pp0_stage7_01001;
reg    ap_block_pp0_stage8_01001;
reg    ap_block_state10_pp0_stage9_iter0;
reg    ap_block_pp0_stage9_01001;
reg    ap_block_state11_pp0_stage10_iter0;
reg    ap_block_pp0_stage10_01001;
reg    ap_block_pp0_stage11_01001;
reg    ap_block_pp0_stage0_01001;
reg    ap_block_pp0_stage2_11001;
reg    ap_block_pp0_stage3_11001;
reg    ap_block_pp0_stage4_11001;
reg    ap_block_pp0_stage6_11001;
reg    ap_block_pp0_stage9_11001;
reg    ap_block_pp0_stage10_11001;
wire  signed [10:0] p_read_cast_cast_cast_cast_fu_111_p1;
wire   [11:0] p_read_cast_cast_cast_cast_cast_fu_115_p1;
wire    ap_continue_int;
reg    ap_done_int;
reg   [11:0] ap_NS_fsm;
reg    ap_idle_pp0_1to1;
reg    ap_block_pp0_stage1_subdone;
reg    ap_block_pp0_stage2_subdone;
reg    ap_block_pp0_stage3_subdone;
reg    ap_block_pp0_stage4_subdone;
reg    ap_block_pp0_stage5_subdone;
reg    ap_block_pp0_stage6_subdone;
reg    ap_block_pp0_stage7_subdone;
reg    ap_block_pp0_stage8_subdone;
reg    ap_block_pp0_stage9_subdone;
reg    ap_block_pp0_stage10_subdone;
wire    ap_enable_pp0;
wire    ap_start_int;
reg    ap_condition_525;
reg    ap_condition_529;
wire    ap_ce_reg;

// power-on initialization
initial begin
#0 ap_CS_fsm = 12'd1;
#0 ap_enable_reg_pp0_iter1 = 1'b0;
#0 ap_done_reg = 1'b0;
#0 ap_enable_reg_pp0_iter0_reg = 1'b0;
end

stream2mem_flow_control_loop_pipe flow_control_loop_pipe_U(
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
    .ap_done_int(ap_done_int),
    .ap_continue(ap_continue)
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
        end else if (((1'b0 == ap_block_pp0_stage11_subdone) & (1'b1 == ap_CS_fsm_pp0_stage11))) begin
            ap_enable_reg_pp0_iter1 <= ap_enable_reg_pp0_iter0;
        end
    end
end

always @ (posedge ap_clk) begin
    if ((ap_enable_reg_pp0_iter0 == 1'b1)) begin
        if ((1'b1 == ap_condition_529)) begin
            col_fu_56 <= 12'd0;
        end else if ((1'b1 == ap_condition_525)) begin
            col_fu_56 <= col_3_fu_147_p2;
        end
    end
end

always @ (posedge ap_clk) begin
    if (((1'b0 == ap_block_pp0_stage0_11001) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        col_2_reg_164 <= ap_sig_allocacmp_col_2;
        icmp_ln29_reg_169 <= icmp_ln29_fu_127_p2;
    end
end

always @ (posedge ap_clk) begin
    if ((((icmp_ln29_reg_169 == 1'd1) & (1'b0 == ap_block_pp0_stage8_11001) & (ap_enable_reg_pp0_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage8)) | ((icmp_ln29_reg_169 == 1'd1) & (1'b0 == ap_block_pp0_stage1_11001) & (ap_enable_reg_pp0_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage1)))) begin
        reg_101 <= {{img_data_dout[15:8]}};
    end
end

always @ (posedge ap_clk) begin
    if ((((icmp_ln29_reg_169 == 1'd1) & (1'b0 == ap_block_pp0_stage7_11001) & (ap_enable_reg_pp0_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage7)) | ((icmp_ln29_reg_169 == 1'd1) & (1'b0 == ap_block_pp0_stage5_11001) & (ap_enable_reg_pp0_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage5)) | ((icmp_ln29_reg_169 == 1'd1) & (1'b0 == ap_block_pp0_stage1_11001) & (ap_enable_reg_pp0_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage1)))) begin
        reg_106 <= {{img_data_dout[23:16]}};
    end
end

always @ (posedge ap_clk) begin
    if (((icmp_ln29_reg_169 == 1'd1) & (1'b0 == ap_block_pp0_stage8_11001) & (1'b1 == ap_CS_fsm_pp0_stage8))) begin
        trunc_ln38_reg_173 <= trunc_ln38_fu_143_p1;
    end
end

always @ (*) begin
    if (((icmp_ln29_fu_127_p2 == 1'd0) & (1'b0 == ap_block_pp0_stage0_subdone) & (ap_enable_reg_pp0_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
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
    if (((ap_start_int == 1'b0) & (ap_idle_pp0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
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
    if (((1'b0 == ap_block_pp0_stage11_subdone) & (ap_enable_reg_pp0_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage11))) begin
        ap_ready_int = 1'b1;
    end else begin
        ap_ready_int = 1'b0;
    end
end

always @ (*) begin
    if (((1'b0 == ap_block_pp0_stage0) & (ap_enable_reg_pp0_iter0 == 1'b1) & (ap_loop_init == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        ap_sig_allocacmp_col_2 = 12'd0;
    end else begin
        ap_sig_allocacmp_col_2 = col_fu_56;
    end
end

always @ (*) begin
    if ((((icmp_ln29_reg_169 == 1'd1) & (1'b0 == ap_block_pp0_stage11) & (ap_enable_reg_pp0_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage11)) | ((icmp_ln29_reg_169 == 1'd1) & (1'b0 == ap_block_pp0_stage10) & (ap_enable_reg_pp0_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage10)) | ((icmp_ln29_reg_169 == 1'd1) & (1'b0 == ap_block_pp0_stage9) & (ap_enable_reg_pp0_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage9)) | ((icmp_ln29_reg_169 == 1'd1) & (1'b0 == ap_block_pp0_stage6) & (ap_enable_reg_pp0_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage6)) | ((icmp_ln29_reg_169 == 1'd1) & (1'b0 == ap_block_pp0_stage4) & (ap_enable_reg_pp0_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage4)) | ((icmp_ln29_reg_169 == 1'd1) & (1'b0 == ap_block_pp0_stage3) & (ap_enable_reg_pp0_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage3)) | ((icmp_ln29_reg_169 == 1'd1) & (1'b0 == ap_block_pp0_stage2) & (ap_enable_reg_pp0_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage2)) | ((icmp_ln29_reg_169 == 1'd1) & (1'b0 == ap_block_pp0_stage8) & (ap_enable_reg_pp0_iter0 == 
    1'b1) & (1'b1 == ap_CS_fsm_pp0_stage8)) | ((icmp_ln29_reg_169 == 1'd1) & (1'b0 == ap_block_pp0_stage7) & (ap_enable_reg_pp0_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage7)) | ((icmp_ln29_reg_169 == 1'd1) & (1'b0 == ap_block_pp0_stage5) & (ap_enable_reg_pp0_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage5)) | ((icmp_ln29_reg_169 == 1'd1) & (1'b0 == ap_block_pp0_stage1) & (ap_enable_reg_pp0_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage1)) | ((1'b0 == ap_block_pp0_stage0) & (ap_enable_reg_pp0_iter1 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0)))) begin
        cacheBuff_i_blk_n = cacheBuff_i_full_n;
    end else begin
        cacheBuff_i_blk_n = 1'b1;
    end
end

always @ (*) begin
    if (((icmp_ln29_reg_169 == 1'd1) & (1'b0 == ap_block_pp0_stage10_01001) & (ap_enable_reg_pp0_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage10))) begin
        cacheBuff_i_din = trunc_ln38_reg_173;
    end else if (((icmp_ln29_reg_169 == 1'd1) & (1'b0 == ap_block_pp0_stage7_01001) & (ap_enable_reg_pp0_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage7))) begin
        cacheBuff_i_din = trunc_ln36_fu_138_p1;
    end else if (((icmp_ln29_reg_169 == 1'd1) & (1'b0 == ap_block_pp0_stage5_01001) & (ap_enable_reg_pp0_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage5))) begin
        cacheBuff_i_din = {{img_data_dout[15:8]}};
    end else if ((((icmp_ln29_reg_169 == 1'd1) & (1'b0 == ap_block_pp0_stage8_01001) & (ap_enable_reg_pp0_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage8)) | ((icmp_ln29_reg_169 == 1'd1) & (1'b0 == ap_block_pp0_stage4_01001) & (ap_enable_reg_pp0_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage4)) | ((1'b0 == ap_block_pp0_stage0_01001) & (ap_enable_reg_pp0_iter1 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0)))) begin
        cacheBuff_i_din = 8'd0;
    end else if ((((icmp_ln29_reg_169 == 1'd1) & (1'b0 == ap_block_pp0_stage9_01001) & (ap_enable_reg_pp0_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage9)) | ((icmp_ln29_reg_169 == 1'd1) & (1'b0 == ap_block_pp0_stage6_01001) & (ap_enable_reg_pp0_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage6)) | ((icmp_ln29_reg_169 == 1'd1) & (1'b0 == ap_block_pp0_stage3_01001) & (ap_enable_reg_pp0_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage3)))) begin
        cacheBuff_i_din = reg_106;
    end else if ((((icmp_ln29_reg_169 == 1'd1) & (1'b0 == ap_block_pp0_stage11_01001) & (ap_enable_reg_pp0_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage11)) | ((icmp_ln29_reg_169 == 1'd1) & (1'b0 == ap_block_pp0_stage2_01001) & (ap_enable_reg_pp0_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage2)))) begin
        cacheBuff_i_din = reg_101;
    end else if (((icmp_ln29_reg_169 == 1'd1) & (1'b0 == ap_block_pp0_stage1_01001) & (ap_enable_reg_pp0_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage1))) begin
        cacheBuff_i_din = trunc_ln34_fu_133_p1;
    end else begin
        cacheBuff_i_din = 'bx;
    end
end

always @ (*) begin
    if ((((icmp_ln29_reg_169 == 1'd1) & (1'b0 == ap_block_pp0_stage10_11001) & (ap_enable_reg_pp0_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage10)) | ((icmp_ln29_reg_169 == 1'd1) & (1'b0 == ap_block_pp0_stage9_11001) & (ap_enable_reg_pp0_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage9)) | ((icmp_ln29_reg_169 == 1'd1) & (1'b0 == ap_block_pp0_stage6_11001) & (ap_enable_reg_pp0_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage6)) | ((icmp_ln29_reg_169 == 1'd1) & (1'b0 == ap_block_pp0_stage4_11001) & (ap_enable_reg_pp0_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage4)) | ((icmp_ln29_reg_169 == 1'd1) & (1'b0 == ap_block_pp0_stage3_11001) & (ap_enable_reg_pp0_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage3)) | ((icmp_ln29_reg_169 == 1'd1) & (1'b0 == ap_block_pp0_stage2_11001) & (ap_enable_reg_pp0_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage2)) | ((icmp_ln29_reg_169 == 1'd1) & (1'b0 == ap_block_pp0_stage11_11001) & (ap_enable_reg_pp0_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage11)) | ((icmp_ln29_reg_169 == 1'd1) & (1'b0 == ap_block_pp0_stage7_11001) 
    & (ap_enable_reg_pp0_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage7)) | ((icmp_ln29_reg_169 == 1'd1) & (1'b0 == ap_block_pp0_stage5_11001) & (ap_enable_reg_pp0_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage5)) | ((icmp_ln29_reg_169 == 1'd1) & (1'b0 == ap_block_pp0_stage8_11001) & (ap_enable_reg_pp0_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage8)) | ((icmp_ln29_reg_169 == 1'd1) & (1'b0 == ap_block_pp0_stage1_11001) & (ap_enable_reg_pp0_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage1)) | ((1'b0 == ap_block_pp0_stage0_11001) & (ap_enable_reg_pp0_iter1 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0)))) begin
        cacheBuff_i_write = 1'b1;
    end else begin
        cacheBuff_i_write = 1'b0;
    end
end

always @ (*) begin
    if ((((icmp_ln29_reg_169 == 1'd1) & (1'b0 == ap_block_pp0_stage8) & (ap_enable_reg_pp0_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage8)) | ((icmp_ln29_reg_169 == 1'd1) & (1'b0 == ap_block_pp0_stage7) & (ap_enable_reg_pp0_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage7)) | ((icmp_ln29_reg_169 == 1'd1) & (1'b0 == ap_block_pp0_stage5) & (ap_enable_reg_pp0_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage5)) | ((icmp_ln29_reg_169 == 1'd1) & (1'b0 == ap_block_pp0_stage1) & (ap_enable_reg_pp0_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage1)))) begin
        img_data_blk_n = img_data_empty_n;
    end else begin
        img_data_blk_n = 1'b1;
    end
end

always @ (*) begin
    if ((((icmp_ln29_reg_169 == 1'd1) & (1'b0 == ap_block_pp0_stage7_11001) & (ap_enable_reg_pp0_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage7)) | ((icmp_ln29_reg_169 == 1'd1) & (1'b0 == ap_block_pp0_stage5_11001) & (ap_enable_reg_pp0_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage5)) | ((icmp_ln29_reg_169 == 1'd1) & (1'b0 == ap_block_pp0_stage8_11001) & (ap_enable_reg_pp0_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage8)) | ((icmp_ln29_reg_169 == 1'd1) & (1'b0 == ap_block_pp0_stage1_11001) & (ap_enable_reg_pp0_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage1)))) begin
        img_data_read = 1'b1;
    end else begin
        img_data_read = 1'b0;
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
                ap_NS_fsm = ap_ST_fsm_pp0_stage4;
            end else begin
                ap_NS_fsm = ap_ST_fsm_pp0_stage3;
            end
        end
        ap_ST_fsm_pp0_stage4 : begin
            if ((1'b0 == ap_block_pp0_stage4_subdone)) begin
                ap_NS_fsm = ap_ST_fsm_pp0_stage5;
            end else begin
                ap_NS_fsm = ap_ST_fsm_pp0_stage4;
            end
        end
        ap_ST_fsm_pp0_stage5 : begin
            if ((1'b0 == ap_block_pp0_stage5_subdone)) begin
                ap_NS_fsm = ap_ST_fsm_pp0_stage6;
            end else begin
                ap_NS_fsm = ap_ST_fsm_pp0_stage5;
            end
        end
        ap_ST_fsm_pp0_stage6 : begin
            if ((1'b0 == ap_block_pp0_stage6_subdone)) begin
                ap_NS_fsm = ap_ST_fsm_pp0_stage7;
            end else begin
                ap_NS_fsm = ap_ST_fsm_pp0_stage6;
            end
        end
        ap_ST_fsm_pp0_stage7 : begin
            if ((1'b0 == ap_block_pp0_stage7_subdone)) begin
                ap_NS_fsm = ap_ST_fsm_pp0_stage8;
            end else begin
                ap_NS_fsm = ap_ST_fsm_pp0_stage7;
            end
        end
        ap_ST_fsm_pp0_stage8 : begin
            if ((1'b0 == ap_block_pp0_stage8_subdone)) begin
                ap_NS_fsm = ap_ST_fsm_pp0_stage9;
            end else begin
                ap_NS_fsm = ap_ST_fsm_pp0_stage8;
            end
        end
        ap_ST_fsm_pp0_stage9 : begin
            if ((1'b0 == ap_block_pp0_stage9_subdone)) begin
                ap_NS_fsm = ap_ST_fsm_pp0_stage10;
            end else begin
                ap_NS_fsm = ap_ST_fsm_pp0_stage9;
            end
        end
        ap_ST_fsm_pp0_stage10 : begin
            if ((1'b0 == ap_block_pp0_stage10_subdone)) begin
                ap_NS_fsm = ap_ST_fsm_pp0_stage11;
            end else begin
                ap_NS_fsm = ap_ST_fsm_pp0_stage10;
            end
        end
        ap_ST_fsm_pp0_stage11 : begin
            if ((1'b0 == ap_block_pp0_stage11_subdone)) begin
                ap_NS_fsm = ap_ST_fsm_pp0_stage0;
            end else begin
                ap_NS_fsm = ap_ST_fsm_pp0_stage11;
            end
        end
        default : begin
            ap_NS_fsm = 'bx;
        end
    endcase
end

assign ap_CS_fsm_pp0_stage0 = ap_CS_fsm[32'd0];

assign ap_CS_fsm_pp0_stage1 = ap_CS_fsm[32'd1];

assign ap_CS_fsm_pp0_stage10 = ap_CS_fsm[32'd10];

assign ap_CS_fsm_pp0_stage11 = ap_CS_fsm[32'd11];

assign ap_CS_fsm_pp0_stage2 = ap_CS_fsm[32'd2];

assign ap_CS_fsm_pp0_stage3 = ap_CS_fsm[32'd3];

assign ap_CS_fsm_pp0_stage4 = ap_CS_fsm[32'd4];

assign ap_CS_fsm_pp0_stage5 = ap_CS_fsm[32'd5];

assign ap_CS_fsm_pp0_stage6 = ap_CS_fsm[32'd6];

assign ap_CS_fsm_pp0_stage7 = ap_CS_fsm[32'd7];

assign ap_CS_fsm_pp0_stage8 = ap_CS_fsm[32'd8];

assign ap_CS_fsm_pp0_stage9 = ap_CS_fsm[32'd9];

assign ap_block_pp0_stage0 = ~(1'b1 == 1'b1);

always @ (*) begin
    ap_block_pp0_stage0_01001 = (((cacheBuff_i_full_n == 1'b0) & (ap_enable_reg_pp0_iter1 == 1'b1)) | ((ap_done_reg == 1'b1) & (ap_enable_reg_pp0_iter0 == 1'b1)));
end

always @ (*) begin
    ap_block_pp0_stage0_11001 = (((cacheBuff_i_full_n == 1'b0) & (ap_enable_reg_pp0_iter1 == 1'b1)) | ((ap_done_reg == 1'b1) & (ap_enable_reg_pp0_iter0 == 1'b1)));
end

always @ (*) begin
    ap_block_pp0_stage0_subdone = (((cacheBuff_i_full_n == 1'b0) & (ap_enable_reg_pp0_iter1 == 1'b1)) | ((ap_done_reg == 1'b1) & (ap_enable_reg_pp0_iter0 == 1'b1)));
end

assign ap_block_pp0_stage1 = ~(1'b1 == 1'b1);

assign ap_block_pp0_stage10 = ~(1'b1 == 1'b1);

always @ (*) begin
    ap_block_pp0_stage10_01001 = ((icmp_ln29_reg_169 == 1'd1) & (cacheBuff_i_full_n == 1'b0) & (ap_enable_reg_pp0_iter0 == 1'b1));
end

always @ (*) begin
    ap_block_pp0_stage10_11001 = ((icmp_ln29_reg_169 == 1'd1) & (cacheBuff_i_full_n == 1'b0) & (ap_enable_reg_pp0_iter0 == 1'b1));
end

always @ (*) begin
    ap_block_pp0_stage10_subdone = ((icmp_ln29_reg_169 == 1'd1) & (cacheBuff_i_full_n == 1'b0) & (ap_enable_reg_pp0_iter0 == 1'b1));
end

assign ap_block_pp0_stage11 = ~(1'b1 == 1'b1);

always @ (*) begin
    ap_block_pp0_stage11_01001 = ((icmp_ln29_reg_169 == 1'd1) & (cacheBuff_i_full_n == 1'b0) & (ap_enable_reg_pp0_iter0 == 1'b1));
end

always @ (*) begin
    ap_block_pp0_stage11_11001 = ((icmp_ln29_reg_169 == 1'd1) & (cacheBuff_i_full_n == 1'b0) & (ap_enable_reg_pp0_iter0 == 1'b1));
end

always @ (*) begin
    ap_block_pp0_stage11_subdone = ((icmp_ln29_reg_169 == 1'd1) & (cacheBuff_i_full_n == 1'b0) & (ap_enable_reg_pp0_iter0 == 1'b1));
end

always @ (*) begin
    ap_block_pp0_stage1_01001 = ((ap_done_reg == 1'b1) | ((ap_enable_reg_pp0_iter0 == 1'b1) & (((icmp_ln29_reg_169 == 1'd1) & (cacheBuff_i_full_n == 1'b0)) | ((img_data_empty_n == 1'b0) & (icmp_ln29_reg_169 == 1'd1)))));
end

always @ (*) begin
    ap_block_pp0_stage1_11001 = ((ap_done_reg == 1'b1) | ((ap_enable_reg_pp0_iter0 == 1'b1) & (((icmp_ln29_reg_169 == 1'd1) & (cacheBuff_i_full_n == 1'b0)) | ((img_data_empty_n == 1'b0) & (icmp_ln29_reg_169 == 1'd1)))));
end

always @ (*) begin
    ap_block_pp0_stage1_subdone = ((ap_done_reg == 1'b1) | ((ap_enable_reg_pp0_iter0 == 1'b1) & (((icmp_ln29_reg_169 == 1'd1) & (cacheBuff_i_full_n == 1'b0)) | ((img_data_empty_n == 1'b0) & (icmp_ln29_reg_169 == 1'd1)))));
end

assign ap_block_pp0_stage2 = ~(1'b1 == 1'b1);

always @ (*) begin
    ap_block_pp0_stage2_01001 = ((icmp_ln29_reg_169 == 1'd1) & (cacheBuff_i_full_n == 1'b0) & (ap_enable_reg_pp0_iter0 == 1'b1));
end

always @ (*) begin
    ap_block_pp0_stage2_11001 = ((icmp_ln29_reg_169 == 1'd1) & (cacheBuff_i_full_n == 1'b0) & (ap_enable_reg_pp0_iter0 == 1'b1));
end

always @ (*) begin
    ap_block_pp0_stage2_subdone = ((icmp_ln29_reg_169 == 1'd1) & (cacheBuff_i_full_n == 1'b0) & (ap_enable_reg_pp0_iter0 == 1'b1));
end

assign ap_block_pp0_stage3 = ~(1'b1 == 1'b1);

always @ (*) begin
    ap_block_pp0_stage3_01001 = ((icmp_ln29_reg_169 == 1'd1) & (cacheBuff_i_full_n == 1'b0) & (ap_enable_reg_pp0_iter0 == 1'b1));
end

always @ (*) begin
    ap_block_pp0_stage3_11001 = ((icmp_ln29_reg_169 == 1'd1) & (cacheBuff_i_full_n == 1'b0) & (ap_enable_reg_pp0_iter0 == 1'b1));
end

always @ (*) begin
    ap_block_pp0_stage3_subdone = ((icmp_ln29_reg_169 == 1'd1) & (cacheBuff_i_full_n == 1'b0) & (ap_enable_reg_pp0_iter0 == 1'b1));
end

assign ap_block_pp0_stage4 = ~(1'b1 == 1'b1);

always @ (*) begin
    ap_block_pp0_stage4_01001 = ((icmp_ln29_reg_169 == 1'd1) & (cacheBuff_i_full_n == 1'b0) & (ap_enable_reg_pp0_iter0 == 1'b1));
end

always @ (*) begin
    ap_block_pp0_stage4_11001 = ((icmp_ln29_reg_169 == 1'd1) & (cacheBuff_i_full_n == 1'b0) & (ap_enable_reg_pp0_iter0 == 1'b1));
end

always @ (*) begin
    ap_block_pp0_stage4_subdone = ((icmp_ln29_reg_169 == 1'd1) & (cacheBuff_i_full_n == 1'b0) & (ap_enable_reg_pp0_iter0 == 1'b1));
end

assign ap_block_pp0_stage5 = ~(1'b1 == 1'b1);

always @ (*) begin
    ap_block_pp0_stage5_01001 = ((ap_enable_reg_pp0_iter0 == 1'b1) & (((icmp_ln29_reg_169 == 1'd1) & (cacheBuff_i_full_n == 1'b0)) | ((img_data_empty_n == 1'b0) & (icmp_ln29_reg_169 == 1'd1))));
end

always @ (*) begin
    ap_block_pp0_stage5_11001 = ((ap_enable_reg_pp0_iter0 == 1'b1) & (((icmp_ln29_reg_169 == 1'd1) & (cacheBuff_i_full_n == 1'b0)) | ((img_data_empty_n == 1'b0) & (icmp_ln29_reg_169 == 1'd1))));
end

always @ (*) begin
    ap_block_pp0_stage5_subdone = ((ap_enable_reg_pp0_iter0 == 1'b1) & (((icmp_ln29_reg_169 == 1'd1) & (cacheBuff_i_full_n == 1'b0)) | ((img_data_empty_n == 1'b0) & (icmp_ln29_reg_169 == 1'd1))));
end

assign ap_block_pp0_stage6 = ~(1'b1 == 1'b1);

always @ (*) begin
    ap_block_pp0_stage6_01001 = ((icmp_ln29_reg_169 == 1'd1) & (cacheBuff_i_full_n == 1'b0) & (ap_enable_reg_pp0_iter0 == 1'b1));
end

always @ (*) begin
    ap_block_pp0_stage6_11001 = ((icmp_ln29_reg_169 == 1'd1) & (cacheBuff_i_full_n == 1'b0) & (ap_enable_reg_pp0_iter0 == 1'b1));
end

always @ (*) begin
    ap_block_pp0_stage6_subdone = ((icmp_ln29_reg_169 == 1'd1) & (cacheBuff_i_full_n == 1'b0) & (ap_enable_reg_pp0_iter0 == 1'b1));
end

assign ap_block_pp0_stage7 = ~(1'b1 == 1'b1);

always @ (*) begin
    ap_block_pp0_stage7_01001 = ((ap_enable_reg_pp0_iter0 == 1'b1) & (((icmp_ln29_reg_169 == 1'd1) & (cacheBuff_i_full_n == 1'b0)) | ((img_data_empty_n == 1'b0) & (icmp_ln29_reg_169 == 1'd1))));
end

always @ (*) begin
    ap_block_pp0_stage7_11001 = ((ap_enable_reg_pp0_iter0 == 1'b1) & (((icmp_ln29_reg_169 == 1'd1) & (cacheBuff_i_full_n == 1'b0)) | ((img_data_empty_n == 1'b0) & (icmp_ln29_reg_169 == 1'd1))));
end

always @ (*) begin
    ap_block_pp0_stage7_subdone = ((ap_enable_reg_pp0_iter0 == 1'b1) & (((icmp_ln29_reg_169 == 1'd1) & (cacheBuff_i_full_n == 1'b0)) | ((img_data_empty_n == 1'b0) & (icmp_ln29_reg_169 == 1'd1))));
end

assign ap_block_pp0_stage8 = ~(1'b1 == 1'b1);

always @ (*) begin
    ap_block_pp0_stage8_01001 = ((ap_enable_reg_pp0_iter0 == 1'b1) & (((icmp_ln29_reg_169 == 1'd1) & (cacheBuff_i_full_n == 1'b0)) | ((img_data_empty_n == 1'b0) & (icmp_ln29_reg_169 == 1'd1))));
end

always @ (*) begin
    ap_block_pp0_stage8_11001 = ((ap_enable_reg_pp0_iter0 == 1'b1) & (((icmp_ln29_reg_169 == 1'd1) & (cacheBuff_i_full_n == 1'b0)) | ((img_data_empty_n == 1'b0) & (icmp_ln29_reg_169 == 1'd1))));
end

always @ (*) begin
    ap_block_pp0_stage8_subdone = ((ap_enable_reg_pp0_iter0 == 1'b1) & (((icmp_ln29_reg_169 == 1'd1) & (cacheBuff_i_full_n == 1'b0)) | ((img_data_empty_n == 1'b0) & (icmp_ln29_reg_169 == 1'd1))));
end

assign ap_block_pp0_stage9 = ~(1'b1 == 1'b1);

always @ (*) begin
    ap_block_pp0_stage9_01001 = ((icmp_ln29_reg_169 == 1'd1) & (cacheBuff_i_full_n == 1'b0) & (ap_enable_reg_pp0_iter0 == 1'b1));
end

always @ (*) begin
    ap_block_pp0_stage9_11001 = ((icmp_ln29_reg_169 == 1'd1) & (cacheBuff_i_full_n == 1'b0) & (ap_enable_reg_pp0_iter0 == 1'b1));
end

always @ (*) begin
    ap_block_pp0_stage9_subdone = ((icmp_ln29_reg_169 == 1'd1) & (cacheBuff_i_full_n == 1'b0) & (ap_enable_reg_pp0_iter0 == 1'b1));
end

always @ (*) begin
    ap_block_state10_pp0_stage9_iter0 = ((icmp_ln29_reg_169 == 1'd1) & (cacheBuff_i_full_n == 1'b0));
end

always @ (*) begin
    ap_block_state11_pp0_stage10_iter0 = ((icmp_ln29_reg_169 == 1'd1) & (cacheBuff_i_full_n == 1'b0));
end

always @ (*) begin
    ap_block_state12_pp0_stage11_iter0 = ((icmp_ln29_reg_169 == 1'd1) & (cacheBuff_i_full_n == 1'b0));
end

always @ (*) begin
    ap_block_state13_pp0_stage0_iter1 = (cacheBuff_i_full_n == 1'b0);
end

always @ (*) begin
    ap_block_state1_pp0_stage0_iter0 = (ap_done_reg == 1'b1);
end

always @ (*) begin
    ap_block_state2_pp0_stage1_iter0 = (((icmp_ln29_reg_169 == 1'd1) & (cacheBuff_i_full_n == 1'b0)) | ((img_data_empty_n == 1'b0) & (icmp_ln29_reg_169 == 1'd1)));
end

always @ (*) begin
    ap_block_state3_pp0_stage2_iter0 = ((icmp_ln29_reg_169 == 1'd1) & (cacheBuff_i_full_n == 1'b0));
end

always @ (*) begin
    ap_block_state4_pp0_stage3_iter0 = ((icmp_ln29_reg_169 == 1'd1) & (cacheBuff_i_full_n == 1'b0));
end

always @ (*) begin
    ap_block_state5_pp0_stage4_iter0 = ((icmp_ln29_reg_169 == 1'd1) & (cacheBuff_i_full_n == 1'b0));
end

always @ (*) begin
    ap_block_state6_pp0_stage5_iter0 = (((icmp_ln29_reg_169 == 1'd1) & (cacheBuff_i_full_n == 1'b0)) | ((img_data_empty_n == 1'b0) & (icmp_ln29_reg_169 == 1'd1)));
end

always @ (*) begin
    ap_block_state7_pp0_stage6_iter0 = ((icmp_ln29_reg_169 == 1'd1) & (cacheBuff_i_full_n == 1'b0));
end

always @ (*) begin
    ap_block_state8_pp0_stage7_iter0 = (((icmp_ln29_reg_169 == 1'd1) & (cacheBuff_i_full_n == 1'b0)) | ((img_data_empty_n == 1'b0) & (icmp_ln29_reg_169 == 1'd1)));
end

always @ (*) begin
    ap_block_state9_pp0_stage8_iter0 = (((icmp_ln29_reg_169 == 1'd1) & (cacheBuff_i_full_n == 1'b0)) | ((img_data_empty_n == 1'b0) & (icmp_ln29_reg_169 == 1'd1)));
end

always @ (*) begin
    ap_condition_525 = ((icmp_ln29_reg_169 == 1'd1) & (1'b0 == ap_block_pp0_stage11_11001) & (1'b1 == ap_CS_fsm_pp0_stage11));
end

always @ (*) begin
    ap_condition_529 = ((1'b0 == ap_block_pp0_stage0_11001) & (ap_loop_init == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0));
end

assign ap_enable_pp0 = (ap_idle_pp0 ^ 1'b1);

assign ap_loop_exit_ready = ap_condition_exit_pp0_iter0_stage0;

assign col_3_fu_147_p2 = (col_2_reg_164 + 12'd4);

assign icmp_ln29_fu_127_p2 = ((ap_sig_allocacmp_col_2 < p_read_cast_cast_cast_cast_cast_fu_115_p1) ? 1'b1 : 1'b0);

assign p_read_cast_cast_cast_cast_cast_fu_115_p1 = $unsigned(p_read_cast_cast_cast_cast_fu_111_p1);

assign p_read_cast_cast_cast_cast_fu_111_p1 = $signed(p_read);

assign trunc_ln34_fu_133_p1 = img_data_dout[7:0];

assign trunc_ln36_fu_138_p1 = img_data_dout[7:0];

assign trunc_ln38_fu_143_p1 = img_data_dout[7:0];

endmodule //stream2mem_dataflow_in_loop_VITIS_LOOP_25_1_1_Loop_VITIS_LOOP_29_2_proc13