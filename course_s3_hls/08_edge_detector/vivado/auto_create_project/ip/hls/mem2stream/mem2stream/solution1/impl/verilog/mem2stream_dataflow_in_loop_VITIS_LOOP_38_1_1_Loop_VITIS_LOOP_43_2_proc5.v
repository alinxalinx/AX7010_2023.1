// ==============================================================
// Generated by Vitis HLS v2023.1
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// ==============================================================

`timescale 1 ns / 1 ps 

module mem2stream_dataflow_in_loop_VITIS_LOOP_38_1_1_Loop_VITIS_LOOP_43_2_proc5 (
        ap_clk,
        ap_rst,
        ap_start,
        ap_done,
        ap_continue,
        ap_idle,
        ap_ready,
        p_read,
        cacheBuff_dout,
        cacheBuff_num_data_valid,
        cacheBuff_fifo_cap,
        cacheBuff_empty_n,
        cacheBuff_read,
        img_data_din,
        img_data_num_data_valid,
        img_data_fifo_cap,
        img_data_full_n,
        img_data_write
);

parameter    ap_ST_fsm_state1 = 3'd1;
parameter    ap_ST_fsm_state2 = 3'd2;
parameter    ap_ST_fsm_state3 = 3'd4;

input   ap_clk;
input   ap_rst;
input   ap_start;
output   ap_done;
input   ap_continue;
output   ap_idle;
output   ap_ready;
input  [31:0] p_read;
input  [31:0] cacheBuff_dout;
input  [12:0] cacheBuff_num_data_valid;
input  [12:0] cacheBuff_fifo_cap;
input   cacheBuff_empty_n;
output   cacheBuff_read;
output  [23:0] img_data_din;
input  [1:0] img_data_num_data_valid;
input  [1:0] img_data_fifo_cap;
input   img_data_full_n;
output   img_data_write;

reg ap_done;
reg ap_idle;
reg ap_ready;
reg cacheBuff_read;
reg img_data_write;

reg    ap_done_reg;
(* fsm_encoding = "none" *) reg   [2:0] ap_CS_fsm;
wire    ap_CS_fsm_state1;
reg    ap_block_state1;
wire   [31:0] tmp_4_fu_122_p3;
reg   [31:0] tmp_4_reg_138;
wire    ap_CS_fsm_state2;
wire    grp_dataflow_in_loop_VITIS_LOOP_38_1_1_Loop_VITIS_LOOP_43_2_proc5_Pipeline_VITIS_LOO_fu_46_ap_start;
wire    grp_dataflow_in_loop_VITIS_LOOP_38_1_1_Loop_VITIS_LOOP_43_2_proc5_Pipeline_VITIS_LOO_fu_46_ap_done;
wire    grp_dataflow_in_loop_VITIS_LOOP_38_1_1_Loop_VITIS_LOOP_43_2_proc5_Pipeline_VITIS_LOO_fu_46_ap_idle;
wire    grp_dataflow_in_loop_VITIS_LOOP_38_1_1_Loop_VITIS_LOOP_43_2_proc5_Pipeline_VITIS_LOO_fu_46_ap_ready;
wire   [23:0] grp_dataflow_in_loop_VITIS_LOOP_38_1_1_Loop_VITIS_LOOP_43_2_proc5_Pipeline_VITIS_LOO_fu_46_img_data_din;
wire    grp_dataflow_in_loop_VITIS_LOOP_38_1_1_Loop_VITIS_LOOP_43_2_proc5_Pipeline_VITIS_LOO_fu_46_img_data_write;
wire    grp_dataflow_in_loop_VITIS_LOOP_38_1_1_Loop_VITIS_LOOP_43_2_proc5_Pipeline_VITIS_LOO_fu_46_cacheBuff_read;
reg    grp_dataflow_in_loop_VITIS_LOOP_38_1_1_Loop_VITIS_LOOP_43_2_proc5_Pipeline_VITIS_LOO_fu_46_ap_start_reg;
wire    ap_CS_fsm_state3;
wire   [31:0] add_ln43_fu_62_p2;
wire   [31:0] sub_ln43_fu_75_p2;
wire   [29:0] p_lshr_fu_80_p4;
wire   [0:0] tmp_2_fu_67_p3;
wire   [29:0] sub_ln43_1_fu_90_p2;
wire   [29:0] tmp_3_fu_96_p4;
wire   [0:0] tmp_fu_55_p3;
wire   [29:0] select_ln43_fu_106_p3;
wire   [29:0] select_ln43_1_fu_114_p3;
reg   [2:0] ap_NS_fsm;
reg    ap_ST_fsm_state1_blk;
wire    ap_ST_fsm_state2_blk;
reg    ap_ST_fsm_state3_blk;
wire    ap_ce_reg;

// power-on initialization
initial begin
#0 ap_done_reg = 1'b0;
#0 ap_CS_fsm = 3'd1;
#0 grp_dataflow_in_loop_VITIS_LOOP_38_1_1_Loop_VITIS_LOOP_43_2_proc5_Pipeline_VITIS_LOO_fu_46_ap_start_reg = 1'b0;
end

mem2stream_dataflow_in_loop_VITIS_LOOP_38_1_1_Loop_VITIS_LOOP_43_2_proc5_Pipeline_VITIS_LOO grp_dataflow_in_loop_VITIS_LOOP_38_1_1_Loop_VITIS_LOOP_43_2_proc5_Pipeline_VITIS_LOO_fu_46(
    .ap_clk(ap_clk),
    .ap_rst(ap_rst),
    .ap_start(grp_dataflow_in_loop_VITIS_LOOP_38_1_1_Loop_VITIS_LOOP_43_2_proc5_Pipeline_VITIS_LOO_fu_46_ap_start),
    .ap_done(grp_dataflow_in_loop_VITIS_LOOP_38_1_1_Loop_VITIS_LOOP_43_2_proc5_Pipeline_VITIS_LOO_fu_46_ap_done),
    .ap_idle(grp_dataflow_in_loop_VITIS_LOOP_38_1_1_Loop_VITIS_LOOP_43_2_proc5_Pipeline_VITIS_LOO_fu_46_ap_idle),
    .ap_ready(grp_dataflow_in_loop_VITIS_LOOP_38_1_1_Loop_VITIS_LOOP_43_2_proc5_Pipeline_VITIS_LOO_fu_46_ap_ready),
    .img_data_din(grp_dataflow_in_loop_VITIS_LOOP_38_1_1_Loop_VITIS_LOOP_43_2_proc5_Pipeline_VITIS_LOO_fu_46_img_data_din),
    .img_data_num_data_valid(2'd0),
    .img_data_fifo_cap(2'd0),
    .img_data_full_n(img_data_full_n),
    .img_data_write(grp_dataflow_in_loop_VITIS_LOOP_38_1_1_Loop_VITIS_LOOP_43_2_proc5_Pipeline_VITIS_LOO_fu_46_img_data_write),
    .cacheBuff_dout(cacheBuff_dout),
    .cacheBuff_num_data_valid(13'd0),
    .cacheBuff_fifo_cap(13'd0),
    .cacheBuff_empty_n(cacheBuff_empty_n),
    .cacheBuff_read(grp_dataflow_in_loop_VITIS_LOOP_38_1_1_Loop_VITIS_LOOP_43_2_proc5_Pipeline_VITIS_LOO_fu_46_cacheBuff_read),
    .empty(tmp_4_reg_138)
);

always @ (posedge ap_clk) begin
    if (ap_rst == 1'b1) begin
        ap_CS_fsm <= ap_ST_fsm_state1;
    end else begin
        ap_CS_fsm <= ap_NS_fsm;
    end
end

always @ (posedge ap_clk) begin
    if (ap_rst == 1'b1) begin
        ap_done_reg <= 1'b0;
    end else begin
        if ((ap_continue == 1'b1)) begin
            ap_done_reg <= 1'b0;
        end else if (((grp_dataflow_in_loop_VITIS_LOOP_38_1_1_Loop_VITIS_LOOP_43_2_proc5_Pipeline_VITIS_LOO_fu_46_ap_done == 1'b1) & (1'b1 == ap_CS_fsm_state3))) begin
            ap_done_reg <= 1'b1;
        end
    end
end

always @ (posedge ap_clk) begin
    if (ap_rst == 1'b1) begin
        grp_dataflow_in_loop_VITIS_LOOP_38_1_1_Loop_VITIS_LOOP_43_2_proc5_Pipeline_VITIS_LOO_fu_46_ap_start_reg <= 1'b0;
    end else begin
        if ((1'b1 == ap_CS_fsm_state2)) begin
            grp_dataflow_in_loop_VITIS_LOOP_38_1_1_Loop_VITIS_LOOP_43_2_proc5_Pipeline_VITIS_LOO_fu_46_ap_start_reg <= 1'b1;
        end else if ((grp_dataflow_in_loop_VITIS_LOOP_38_1_1_Loop_VITIS_LOOP_43_2_proc5_Pipeline_VITIS_LOO_fu_46_ap_ready == 1'b1)) begin
            grp_dataflow_in_loop_VITIS_LOOP_38_1_1_Loop_VITIS_LOOP_43_2_proc5_Pipeline_VITIS_LOO_fu_46_ap_start_reg <= 1'b0;
        end
    end
end

always @ (posedge ap_clk) begin
    if ((1'b1 == ap_CS_fsm_state2)) begin
        tmp_4_reg_138[31 : 2] <= tmp_4_fu_122_p3[31 : 2];
    end
end

always @ (*) begin
    if (((ap_start == 1'b0) | (ap_done_reg == 1'b1))) begin
        ap_ST_fsm_state1_blk = 1'b1;
    end else begin
        ap_ST_fsm_state1_blk = 1'b0;
    end
end

assign ap_ST_fsm_state2_blk = 1'b0;

always @ (*) begin
    if ((grp_dataflow_in_loop_VITIS_LOOP_38_1_1_Loop_VITIS_LOOP_43_2_proc5_Pipeline_VITIS_LOO_fu_46_ap_done == 1'b0)) begin
        ap_ST_fsm_state3_blk = 1'b1;
    end else begin
        ap_ST_fsm_state3_blk = 1'b0;
    end
end

always @ (*) begin
    if (((grp_dataflow_in_loop_VITIS_LOOP_38_1_1_Loop_VITIS_LOOP_43_2_proc5_Pipeline_VITIS_LOO_fu_46_ap_done == 1'b1) & (1'b1 == ap_CS_fsm_state3))) begin
        ap_done = 1'b1;
    end else begin
        ap_done = ap_done_reg;
    end
end

always @ (*) begin
    if (((ap_start == 1'b0) & (1'b1 == ap_CS_fsm_state1))) begin
        ap_idle = 1'b1;
    end else begin
        ap_idle = 1'b0;
    end
end

always @ (*) begin
    if (((grp_dataflow_in_loop_VITIS_LOOP_38_1_1_Loop_VITIS_LOOP_43_2_proc5_Pipeline_VITIS_LOO_fu_46_ap_done == 1'b1) & (1'b1 == ap_CS_fsm_state3))) begin
        ap_ready = 1'b1;
    end else begin
        ap_ready = 1'b0;
    end
end

always @ (*) begin
    if ((1'b1 == ap_CS_fsm_state3)) begin
        cacheBuff_read = grp_dataflow_in_loop_VITIS_LOOP_38_1_1_Loop_VITIS_LOOP_43_2_proc5_Pipeline_VITIS_LOO_fu_46_cacheBuff_read;
    end else begin
        cacheBuff_read = 1'b0;
    end
end

always @ (*) begin
    if ((1'b1 == ap_CS_fsm_state3)) begin
        img_data_write = grp_dataflow_in_loop_VITIS_LOOP_38_1_1_Loop_VITIS_LOOP_43_2_proc5_Pipeline_VITIS_LOO_fu_46_img_data_write;
    end else begin
        img_data_write = 1'b0;
    end
end

always @ (*) begin
    case (ap_CS_fsm)
        ap_ST_fsm_state1 : begin
            if ((~((ap_start == 1'b0) | (ap_done_reg == 1'b1)) & (1'b1 == ap_CS_fsm_state1))) begin
                ap_NS_fsm = ap_ST_fsm_state2;
            end else begin
                ap_NS_fsm = ap_ST_fsm_state1;
            end
        end
        ap_ST_fsm_state2 : begin
            ap_NS_fsm = ap_ST_fsm_state3;
        end
        ap_ST_fsm_state3 : begin
            if (((grp_dataflow_in_loop_VITIS_LOOP_38_1_1_Loop_VITIS_LOOP_43_2_proc5_Pipeline_VITIS_LOO_fu_46_ap_done == 1'b1) & (1'b1 == ap_CS_fsm_state3))) begin
                ap_NS_fsm = ap_ST_fsm_state1;
            end else begin
                ap_NS_fsm = ap_ST_fsm_state3;
            end
        end
        default : begin
            ap_NS_fsm = 'bx;
        end
    endcase
end

assign add_ln43_fu_62_p2 = (p_read + 32'd3);

assign ap_CS_fsm_state1 = ap_CS_fsm[32'd0];

assign ap_CS_fsm_state2 = ap_CS_fsm[32'd1];

assign ap_CS_fsm_state3 = ap_CS_fsm[32'd2];

always @ (*) begin
    ap_block_state1 = ((ap_start == 1'b0) | (ap_done_reg == 1'b1));
end

assign grp_dataflow_in_loop_VITIS_LOOP_38_1_1_Loop_VITIS_LOOP_43_2_proc5_Pipeline_VITIS_LOO_fu_46_ap_start = grp_dataflow_in_loop_VITIS_LOOP_38_1_1_Loop_VITIS_LOOP_43_2_proc5_Pipeline_VITIS_LOO_fu_46_ap_start_reg;

assign img_data_din = grp_dataflow_in_loop_VITIS_LOOP_38_1_1_Loop_VITIS_LOOP_43_2_proc5_Pipeline_VITIS_LOO_fu_46_img_data_din;

assign p_lshr_fu_80_p4 = {{sub_ln43_fu_75_p2[31:2]}};

assign select_ln43_1_fu_114_p3 = ((tmp_fu_55_p3[0:0] == 1'b1) ? 30'd0 : select_ln43_fu_106_p3);

assign select_ln43_fu_106_p3 = ((tmp_2_fu_67_p3[0:0] == 1'b1) ? sub_ln43_1_fu_90_p2 : tmp_3_fu_96_p4);

assign sub_ln43_1_fu_90_p2 = (30'd0 - p_lshr_fu_80_p4);

assign sub_ln43_fu_75_p2 = ($signed(32'd4294967293) - $signed(p_read));

assign tmp_2_fu_67_p3 = add_ln43_fu_62_p2[32'd31];

assign tmp_3_fu_96_p4 = {{add_ln43_fu_62_p2[31:2]}};

assign tmp_4_fu_122_p3 = {{select_ln43_1_fu_114_p3}, {2'd0}};

assign tmp_fu_55_p3 = p_read[32'd31];

always @ (posedge ap_clk) begin
    tmp_4_reg_138[1:0] <= 2'b00;
end

endmodule //mem2stream_dataflow_in_loop_VITIS_LOOP_38_1_1_Loop_VITIS_LOOP_43_2_proc5
