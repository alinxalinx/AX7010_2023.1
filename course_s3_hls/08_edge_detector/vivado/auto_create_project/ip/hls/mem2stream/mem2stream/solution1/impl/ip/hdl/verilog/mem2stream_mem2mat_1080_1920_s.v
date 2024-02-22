// ==============================================================
// Generated by Vitis HLS v2023.1
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// ==============================================================

`timescale 1 ns / 1 ps 

module mem2stream_mem2mat_1080_1920_s (
        ap_clk,
        ap_rst,
        ap_start,
        start_full_n,
        ap_done,
        ap_continue,
        ap_idle,
        ap_ready,
        start_out,
        start_write,
        p_read,
        p_read1,
        img_data_din,
        img_data_num_data_valid,
        img_data_fifo_cap,
        img_data_full_n,
        img_data_write,
        m_axi_gmem_AWVALID,
        m_axi_gmem_AWREADY,
        m_axi_gmem_AWADDR,
        m_axi_gmem_AWID,
        m_axi_gmem_AWLEN,
        m_axi_gmem_AWSIZE,
        m_axi_gmem_AWBURST,
        m_axi_gmem_AWLOCK,
        m_axi_gmem_AWCACHE,
        m_axi_gmem_AWPROT,
        m_axi_gmem_AWQOS,
        m_axi_gmem_AWREGION,
        m_axi_gmem_AWUSER,
        m_axi_gmem_WVALID,
        m_axi_gmem_WREADY,
        m_axi_gmem_WDATA,
        m_axi_gmem_WSTRB,
        m_axi_gmem_WLAST,
        m_axi_gmem_WID,
        m_axi_gmem_WUSER,
        m_axi_gmem_ARVALID,
        m_axi_gmem_ARREADY,
        m_axi_gmem_ARADDR,
        m_axi_gmem_ARID,
        m_axi_gmem_ARLEN,
        m_axi_gmem_ARSIZE,
        m_axi_gmem_ARBURST,
        m_axi_gmem_ARLOCK,
        m_axi_gmem_ARCACHE,
        m_axi_gmem_ARPROT,
        m_axi_gmem_ARQOS,
        m_axi_gmem_ARREGION,
        m_axi_gmem_ARUSER,
        m_axi_gmem_RVALID,
        m_axi_gmem_RREADY,
        m_axi_gmem_RDATA,
        m_axi_gmem_RLAST,
        m_axi_gmem_RID,
        m_axi_gmem_RFIFONUM,
        m_axi_gmem_RUSER,
        m_axi_gmem_RRESP,
        m_axi_gmem_BVALID,
        m_axi_gmem_BREADY,
        m_axi_gmem_BRESP,
        m_axi_gmem_BID,
        m_axi_gmem_BUSER,
        pMemPort,
        baseAddr_address0,
        baseAddr_ce0,
        baseAddr_q0,
        w,
        indexr,
        indexr_ap_vld,
        img_rows_c_din,
        img_rows_c_num_data_valid,
        img_rows_c_fifo_cap,
        img_rows_c_full_n,
        img_rows_c_write,
        img_cols_c_din,
        img_cols_c_num_data_valid,
        img_cols_c_fifo_cap,
        img_cols_c_full_n,
        img_cols_c_write
);

parameter    ap_ST_fsm_state1 = 3'd1;
parameter    ap_ST_fsm_state2 = 3'd2;
parameter    ap_ST_fsm_state3 = 3'd4;

input   ap_clk;
input   ap_rst;
input   ap_start;
input   start_full_n;
output   ap_done;
input   ap_continue;
output   ap_idle;
output   ap_ready;
output   start_out;
output   start_write;
input  [10:0] p_read;
input  [7:0] p_read1;
output  [23:0] img_data_din;
input  [1:0] img_data_num_data_valid;
input  [1:0] img_data_fifo_cap;
input   img_data_full_n;
output   img_data_write;
output   m_axi_gmem_AWVALID;
input   m_axi_gmem_AWREADY;
output  [63:0] m_axi_gmem_AWADDR;
output  [0:0] m_axi_gmem_AWID;
output  [31:0] m_axi_gmem_AWLEN;
output  [2:0] m_axi_gmem_AWSIZE;
output  [1:0] m_axi_gmem_AWBURST;
output  [1:0] m_axi_gmem_AWLOCK;
output  [3:0] m_axi_gmem_AWCACHE;
output  [2:0] m_axi_gmem_AWPROT;
output  [3:0] m_axi_gmem_AWQOS;
output  [3:0] m_axi_gmem_AWREGION;
output  [0:0] m_axi_gmem_AWUSER;
output   m_axi_gmem_WVALID;
input   m_axi_gmem_WREADY;
output  [31:0] m_axi_gmem_WDATA;
output  [3:0] m_axi_gmem_WSTRB;
output   m_axi_gmem_WLAST;
output  [0:0] m_axi_gmem_WID;
output  [0:0] m_axi_gmem_WUSER;
output   m_axi_gmem_ARVALID;
input   m_axi_gmem_ARREADY;
output  [63:0] m_axi_gmem_ARADDR;
output  [0:0] m_axi_gmem_ARID;
output  [31:0] m_axi_gmem_ARLEN;
output  [2:0] m_axi_gmem_ARSIZE;
output  [1:0] m_axi_gmem_ARBURST;
output  [1:0] m_axi_gmem_ARLOCK;
output  [3:0] m_axi_gmem_ARCACHE;
output  [2:0] m_axi_gmem_ARPROT;
output  [3:0] m_axi_gmem_ARQOS;
output  [3:0] m_axi_gmem_ARREGION;
output  [0:0] m_axi_gmem_ARUSER;
input   m_axi_gmem_RVALID;
output   m_axi_gmem_RREADY;
input  [31:0] m_axi_gmem_RDATA;
input   m_axi_gmem_RLAST;
input  [0:0] m_axi_gmem_RID;
input  [8:0] m_axi_gmem_RFIFONUM;
input  [0:0] m_axi_gmem_RUSER;
input  [1:0] m_axi_gmem_RRESP;
input   m_axi_gmem_BVALID;
output   m_axi_gmem_BREADY;
input  [1:0] m_axi_gmem_BRESP;
input  [0:0] m_axi_gmem_BID;
input  [0:0] m_axi_gmem_BUSER;
input  [63:0] pMemPort;
output  [1:0] baseAddr_address0;
output   baseAddr_ce0;
input  [31:0] baseAddr_q0;
input  [31:0] w;
output  [31:0] indexr;
output   indexr_ap_vld;
output  [10:0] img_rows_c_din;
input  [1:0] img_rows_c_num_data_valid;
input  [1:0] img_rows_c_fifo_cap;
input   img_rows_c_full_n;
output   img_rows_c_write;
output  [7:0] img_cols_c_din;
input  [1:0] img_cols_c_num_data_valid;
input  [1:0] img_cols_c_fifo_cap;
input   img_cols_c_full_n;
output   img_cols_c_write;

reg ap_done;
reg ap_idle;
reg start_write;
reg img_data_write;
reg m_axi_gmem_ARVALID;
reg m_axi_gmem_RREADY;
reg[31:0] indexr;
reg indexr_ap_vld;
reg img_rows_c_write;
reg img_cols_c_write;

reg    real_start;
reg    start_once_reg;
reg    ap_done_reg;
(* fsm_encoding = "none" *) reg   [2:0] ap_CS_fsm;
wire    ap_CS_fsm_state1;
reg    internal_ap_ready;
reg   [31:0] index;
reg    img_rows_c_blk_n;
reg    img_cols_c_blk_n;
reg    ap_block_state1;
wire    ap_CS_fsm_state2;
wire   [1:0] grp_dataflow_parent_loop_proc_fu_131_baseAddr_address0;
wire    grp_dataflow_parent_loop_proc_fu_131_baseAddr_ce0;
wire   [31:0] grp_dataflow_parent_loop_proc_fu_131_baseAddr_d0;
wire    grp_dataflow_parent_loop_proc_fu_131_baseAddr_we0;
wire    grp_dataflow_parent_loop_proc_fu_131_m_axi_gmem_AWVALID;
wire   [63:0] grp_dataflow_parent_loop_proc_fu_131_m_axi_gmem_AWADDR;
wire   [0:0] grp_dataflow_parent_loop_proc_fu_131_m_axi_gmem_AWID;
wire   [31:0] grp_dataflow_parent_loop_proc_fu_131_m_axi_gmem_AWLEN;
wire   [2:0] grp_dataflow_parent_loop_proc_fu_131_m_axi_gmem_AWSIZE;
wire   [1:0] grp_dataflow_parent_loop_proc_fu_131_m_axi_gmem_AWBURST;
wire   [1:0] grp_dataflow_parent_loop_proc_fu_131_m_axi_gmem_AWLOCK;
wire   [3:0] grp_dataflow_parent_loop_proc_fu_131_m_axi_gmem_AWCACHE;
wire   [2:0] grp_dataflow_parent_loop_proc_fu_131_m_axi_gmem_AWPROT;
wire   [3:0] grp_dataflow_parent_loop_proc_fu_131_m_axi_gmem_AWQOS;
wire   [3:0] grp_dataflow_parent_loop_proc_fu_131_m_axi_gmem_AWREGION;
wire   [0:0] grp_dataflow_parent_loop_proc_fu_131_m_axi_gmem_AWUSER;
wire    grp_dataflow_parent_loop_proc_fu_131_m_axi_gmem_WVALID;
wire   [31:0] grp_dataflow_parent_loop_proc_fu_131_m_axi_gmem_WDATA;
wire   [3:0] grp_dataflow_parent_loop_proc_fu_131_m_axi_gmem_WSTRB;
wire    grp_dataflow_parent_loop_proc_fu_131_m_axi_gmem_WLAST;
wire   [0:0] grp_dataflow_parent_loop_proc_fu_131_m_axi_gmem_WID;
wire   [0:0] grp_dataflow_parent_loop_proc_fu_131_m_axi_gmem_WUSER;
wire    grp_dataflow_parent_loop_proc_fu_131_m_axi_gmem_ARVALID;
wire   [63:0] grp_dataflow_parent_loop_proc_fu_131_m_axi_gmem_ARADDR;
wire   [0:0] grp_dataflow_parent_loop_proc_fu_131_m_axi_gmem_ARID;
wire   [31:0] grp_dataflow_parent_loop_proc_fu_131_m_axi_gmem_ARLEN;
wire   [2:0] grp_dataflow_parent_loop_proc_fu_131_m_axi_gmem_ARSIZE;
wire   [1:0] grp_dataflow_parent_loop_proc_fu_131_m_axi_gmem_ARBURST;
wire   [1:0] grp_dataflow_parent_loop_proc_fu_131_m_axi_gmem_ARLOCK;
wire   [3:0] grp_dataflow_parent_loop_proc_fu_131_m_axi_gmem_ARCACHE;
wire   [2:0] grp_dataflow_parent_loop_proc_fu_131_m_axi_gmem_ARPROT;
wire   [3:0] grp_dataflow_parent_loop_proc_fu_131_m_axi_gmem_ARQOS;
wire   [3:0] grp_dataflow_parent_loop_proc_fu_131_m_axi_gmem_ARREGION;
wire   [0:0] grp_dataflow_parent_loop_proc_fu_131_m_axi_gmem_ARUSER;
wire    grp_dataflow_parent_loop_proc_fu_131_m_axi_gmem_RREADY;
wire    grp_dataflow_parent_loop_proc_fu_131_m_axi_gmem_BREADY;
wire   [23:0] grp_dataflow_parent_loop_proc_fu_131_img_data_din;
wire    grp_dataflow_parent_loop_proc_fu_131_img_data_write;
wire    grp_dataflow_parent_loop_proc_fu_131_ap_start;
wire    grp_dataflow_parent_loop_proc_fu_131_ap_done;
wire    grp_dataflow_parent_loop_proc_fu_131_ap_ready;
wire    grp_dataflow_parent_loop_proc_fu_131_ap_idle;
reg    grp_dataflow_parent_loop_proc_fu_131_ap_continue;
reg    grp_dataflow_parent_loop_proc_fu_131_ap_start_reg;
wire    ap_CS_fsm_state3;
wire    ap_sync_grp_dataflow_parent_loop_proc_fu_131_ap_ready;
wire    ap_sync_grp_dataflow_parent_loop_proc_fu_131_ap_done;
reg    ap_block_state3_on_subcall_done;
reg    ap_sync_reg_grp_dataflow_parent_loop_proc_fu_131_ap_ready;
reg    ap_sync_reg_grp_dataflow_parent_loop_proc_fu_131_ap_done;
wire   [31:0] select_ln35_fu_190_p3;
reg   [31:0] indexr_preg;
wire   [30:0] tmp_fu_154_p4;
wire   [0:0] icmp_ln34_fu_164_p2;
wire   [31:0] add_ln34_fu_170_p2;
wire   [31:0] n_fu_176_p3;
wire   [0:0] icmp_ln35_fu_184_p2;
reg   [2:0] ap_NS_fsm;
reg    ap_ST_fsm_state1_blk;
wire    ap_ST_fsm_state2_blk;
reg    ap_ST_fsm_state3_blk;
wire    ap_ce_reg;

// power-on initialization
initial begin
#0 start_once_reg = 1'b0;
#0 ap_done_reg = 1'b0;
#0 ap_CS_fsm = 3'd1;
#0 index = 32'd2;
#0 grp_dataflow_parent_loop_proc_fu_131_ap_start_reg = 1'b0;
#0 ap_sync_reg_grp_dataflow_parent_loop_proc_fu_131_ap_ready = 1'b0;
#0 ap_sync_reg_grp_dataflow_parent_loop_proc_fu_131_ap_done = 1'b0;
#0 indexr_preg = 32'd0;
end

mem2stream_dataflow_parent_loop_proc grp_dataflow_parent_loop_proc_fu_131(
    .local_rows(p_read),
    .baseAddr_address0(grp_dataflow_parent_loop_proc_fu_131_baseAddr_address0),
    .baseAddr_ce0(grp_dataflow_parent_loop_proc_fu_131_baseAddr_ce0),
    .baseAddr_d0(grp_dataflow_parent_loop_proc_fu_131_baseAddr_d0),
    .baseAddr_q0(baseAddr_q0),
    .baseAddr_we0(grp_dataflow_parent_loop_proc_fu_131_baseAddr_we0),
    .m_axi_gmem_AWVALID(grp_dataflow_parent_loop_proc_fu_131_m_axi_gmem_AWVALID),
    .m_axi_gmem_AWREADY(1'b0),
    .m_axi_gmem_AWADDR(grp_dataflow_parent_loop_proc_fu_131_m_axi_gmem_AWADDR),
    .m_axi_gmem_AWID(grp_dataflow_parent_loop_proc_fu_131_m_axi_gmem_AWID),
    .m_axi_gmem_AWLEN(grp_dataflow_parent_loop_proc_fu_131_m_axi_gmem_AWLEN),
    .m_axi_gmem_AWSIZE(grp_dataflow_parent_loop_proc_fu_131_m_axi_gmem_AWSIZE),
    .m_axi_gmem_AWBURST(grp_dataflow_parent_loop_proc_fu_131_m_axi_gmem_AWBURST),
    .m_axi_gmem_AWLOCK(grp_dataflow_parent_loop_proc_fu_131_m_axi_gmem_AWLOCK),
    .m_axi_gmem_AWCACHE(grp_dataflow_parent_loop_proc_fu_131_m_axi_gmem_AWCACHE),
    .m_axi_gmem_AWPROT(grp_dataflow_parent_loop_proc_fu_131_m_axi_gmem_AWPROT),
    .m_axi_gmem_AWQOS(grp_dataflow_parent_loop_proc_fu_131_m_axi_gmem_AWQOS),
    .m_axi_gmem_AWREGION(grp_dataflow_parent_loop_proc_fu_131_m_axi_gmem_AWREGION),
    .m_axi_gmem_AWUSER(grp_dataflow_parent_loop_proc_fu_131_m_axi_gmem_AWUSER),
    .m_axi_gmem_WVALID(grp_dataflow_parent_loop_proc_fu_131_m_axi_gmem_WVALID),
    .m_axi_gmem_WREADY(1'b0),
    .m_axi_gmem_WDATA(grp_dataflow_parent_loop_proc_fu_131_m_axi_gmem_WDATA),
    .m_axi_gmem_WSTRB(grp_dataflow_parent_loop_proc_fu_131_m_axi_gmem_WSTRB),
    .m_axi_gmem_WLAST(grp_dataflow_parent_loop_proc_fu_131_m_axi_gmem_WLAST),
    .m_axi_gmem_WID(grp_dataflow_parent_loop_proc_fu_131_m_axi_gmem_WID),
    .m_axi_gmem_WUSER(grp_dataflow_parent_loop_proc_fu_131_m_axi_gmem_WUSER),
    .m_axi_gmem_ARVALID(grp_dataflow_parent_loop_proc_fu_131_m_axi_gmem_ARVALID),
    .m_axi_gmem_ARREADY(m_axi_gmem_ARREADY),
    .m_axi_gmem_ARADDR(grp_dataflow_parent_loop_proc_fu_131_m_axi_gmem_ARADDR),
    .m_axi_gmem_ARID(grp_dataflow_parent_loop_proc_fu_131_m_axi_gmem_ARID),
    .m_axi_gmem_ARLEN(grp_dataflow_parent_loop_proc_fu_131_m_axi_gmem_ARLEN),
    .m_axi_gmem_ARSIZE(grp_dataflow_parent_loop_proc_fu_131_m_axi_gmem_ARSIZE),
    .m_axi_gmem_ARBURST(grp_dataflow_parent_loop_proc_fu_131_m_axi_gmem_ARBURST),
    .m_axi_gmem_ARLOCK(grp_dataflow_parent_loop_proc_fu_131_m_axi_gmem_ARLOCK),
    .m_axi_gmem_ARCACHE(grp_dataflow_parent_loop_proc_fu_131_m_axi_gmem_ARCACHE),
    .m_axi_gmem_ARPROT(grp_dataflow_parent_loop_proc_fu_131_m_axi_gmem_ARPROT),
    .m_axi_gmem_ARQOS(grp_dataflow_parent_loop_proc_fu_131_m_axi_gmem_ARQOS),
    .m_axi_gmem_ARREGION(grp_dataflow_parent_loop_proc_fu_131_m_axi_gmem_ARREGION),
    .m_axi_gmem_ARUSER(grp_dataflow_parent_loop_proc_fu_131_m_axi_gmem_ARUSER),
    .m_axi_gmem_RVALID(m_axi_gmem_RVALID),
    .m_axi_gmem_RREADY(grp_dataflow_parent_loop_proc_fu_131_m_axi_gmem_RREADY),
    .m_axi_gmem_RDATA(m_axi_gmem_RDATA),
    .m_axi_gmem_RLAST(m_axi_gmem_RLAST),
    .m_axi_gmem_RID(m_axi_gmem_RID),
    .m_axi_gmem_RFIFONUM(m_axi_gmem_RFIFONUM),
    .m_axi_gmem_RUSER(m_axi_gmem_RUSER),
    .m_axi_gmem_RRESP(m_axi_gmem_RRESP),
    .m_axi_gmem_BVALID(1'b0),
    .m_axi_gmem_BREADY(grp_dataflow_parent_loop_proc_fu_131_m_axi_gmem_BREADY),
    .m_axi_gmem_BRESP(2'd0),
    .m_axi_gmem_BID(1'd0),
    .m_axi_gmem_BUSER(1'd0),
    .pMemPort(pMemPort),
    .p_read(p_read),
    .p_read1(p_read1),
    .img_data_din(grp_dataflow_parent_loop_proc_fu_131_img_data_din),
    .img_data_full_n(img_data_full_n),
    .img_data_write(grp_dataflow_parent_loop_proc_fu_131_img_data_write),
    .index(index),
    .ap_clk(ap_clk),
    .ap_rst(ap_rst),
    .pMemPort_ap_vld(1'b1),
    .p_read_ap_vld(1'b1),
    .p_read1_ap_vld(1'b1),
    .index_ap_vld(1'b1),
    .ap_start(grp_dataflow_parent_loop_proc_fu_131_ap_start),
    .ap_done(grp_dataflow_parent_loop_proc_fu_131_ap_done),
    .ap_ready(grp_dataflow_parent_loop_proc_fu_131_ap_ready),
    .ap_idle(grp_dataflow_parent_loop_proc_fu_131_ap_idle),
    .ap_continue(grp_dataflow_parent_loop_proc_fu_131_ap_continue)
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
        end else if (((1'b0 == ap_block_state3_on_subcall_done) & (1'b1 == ap_CS_fsm_state3))) begin
            ap_done_reg <= 1'b1;
        end
    end
end

always @ (posedge ap_clk) begin
    if (ap_rst == 1'b1) begin
        ap_sync_reg_grp_dataflow_parent_loop_proc_fu_131_ap_done <= 1'b0;
    end else begin
        if (((1'b0 == ap_block_state3_on_subcall_done) & (1'b1 == ap_CS_fsm_state3))) begin
            ap_sync_reg_grp_dataflow_parent_loop_proc_fu_131_ap_done <= 1'b0;
        end else if ((grp_dataflow_parent_loop_proc_fu_131_ap_done == 1'b1)) begin
            ap_sync_reg_grp_dataflow_parent_loop_proc_fu_131_ap_done <= 1'b1;
        end
    end
end

always @ (posedge ap_clk) begin
    if (ap_rst == 1'b1) begin
        ap_sync_reg_grp_dataflow_parent_loop_proc_fu_131_ap_ready <= 1'b0;
    end else begin
        if (((1'b0 == ap_block_state3_on_subcall_done) & (1'b1 == ap_CS_fsm_state3))) begin
            ap_sync_reg_grp_dataflow_parent_loop_proc_fu_131_ap_ready <= 1'b0;
        end else if ((grp_dataflow_parent_loop_proc_fu_131_ap_ready == 1'b1)) begin
            ap_sync_reg_grp_dataflow_parent_loop_proc_fu_131_ap_ready <= 1'b1;
        end
    end
end

always @ (posedge ap_clk) begin
    if (ap_rst == 1'b1) begin
        grp_dataflow_parent_loop_proc_fu_131_ap_start_reg <= 1'b0;
    end else begin
        if (((1'b1 == ap_CS_fsm_state2) | ((ap_sync_grp_dataflow_parent_loop_proc_fu_131_ap_ready == 1'b0) & (1'b1 == ap_CS_fsm_state3)))) begin
            grp_dataflow_parent_loop_proc_fu_131_ap_start_reg <= 1'b1;
        end else if ((grp_dataflow_parent_loop_proc_fu_131_ap_ready == 1'b1)) begin
            grp_dataflow_parent_loop_proc_fu_131_ap_start_reg <= 1'b0;
        end
    end
end

always @ (posedge ap_clk) begin
    if (ap_rst == 1'b1) begin
        indexr_preg <= 32'd0;
    end else begin
        if ((~((real_start == 1'b0) | (ap_done_reg == 1'b1) | (img_cols_c_full_n == 1'b0) | (img_rows_c_full_n == 1'b0)) & (1'b1 == ap_CS_fsm_state1))) begin
            indexr_preg <= select_ln35_fu_190_p3;
        end
    end
end

always @ (posedge ap_clk) begin
    if (ap_rst == 1'b1) begin
        start_once_reg <= 1'b0;
    end else begin
        if (((real_start == 1'b1) & (internal_ap_ready == 1'b0))) begin
            start_once_reg <= 1'b1;
        end else if ((internal_ap_ready == 1'b1)) begin
            start_once_reg <= 1'b0;
        end
    end
end

always @ (posedge ap_clk) begin
    if ((~((real_start == 1'b0) | (ap_done_reg == 1'b1) | (img_cols_c_full_n == 1'b0) | (img_rows_c_full_n == 1'b0)) & (1'b1 == ap_CS_fsm_state1))) begin
        index <= select_ln35_fu_190_p3;
    end
end

always @ (*) begin
    if (((real_start == 1'b0) | (ap_done_reg == 1'b1) | (img_cols_c_full_n == 1'b0) | (img_rows_c_full_n == 1'b0))) begin
        ap_ST_fsm_state1_blk = 1'b1;
    end else begin
        ap_ST_fsm_state1_blk = 1'b0;
    end
end

assign ap_ST_fsm_state2_blk = 1'b0;

always @ (*) begin
    if ((1'b1 == ap_block_state3_on_subcall_done)) begin
        ap_ST_fsm_state3_blk = 1'b1;
    end else begin
        ap_ST_fsm_state3_blk = 1'b0;
    end
end

always @ (*) begin
    if (((1'b0 == ap_block_state3_on_subcall_done) & (1'b1 == ap_CS_fsm_state3))) begin
        ap_done = 1'b1;
    end else begin
        ap_done = ap_done_reg;
    end
end

always @ (*) begin
    if (((real_start == 1'b0) & (1'b1 == ap_CS_fsm_state1))) begin
        ap_idle = 1'b1;
    end else begin
        ap_idle = 1'b0;
    end
end

always @ (*) begin
    if (((1'b0 == ap_block_state3_on_subcall_done) & (1'b1 == ap_CS_fsm_state3))) begin
        grp_dataflow_parent_loop_proc_fu_131_ap_continue = 1'b1;
    end else begin
        grp_dataflow_parent_loop_proc_fu_131_ap_continue = 1'b0;
    end
end

always @ (*) begin
    if ((~((real_start == 1'b0) | (ap_done_reg == 1'b1)) & (1'b1 == ap_CS_fsm_state1))) begin
        img_cols_c_blk_n = img_cols_c_full_n;
    end else begin
        img_cols_c_blk_n = 1'b1;
    end
end

always @ (*) begin
    if ((~((real_start == 1'b0) | (ap_done_reg == 1'b1) | (img_cols_c_full_n == 1'b0) | (img_rows_c_full_n == 1'b0)) & (1'b1 == ap_CS_fsm_state1))) begin
        img_cols_c_write = 1'b1;
    end else begin
        img_cols_c_write = 1'b0;
    end
end

always @ (*) begin
    if ((1'b1 == ap_CS_fsm_state3)) begin
        img_data_write = grp_dataflow_parent_loop_proc_fu_131_img_data_write;
    end else begin
        img_data_write = 1'b0;
    end
end

always @ (*) begin
    if ((~((real_start == 1'b0) | (ap_done_reg == 1'b1)) & (1'b1 == ap_CS_fsm_state1))) begin
        img_rows_c_blk_n = img_rows_c_full_n;
    end else begin
        img_rows_c_blk_n = 1'b1;
    end
end

always @ (*) begin
    if ((~((real_start == 1'b0) | (ap_done_reg == 1'b1) | (img_cols_c_full_n == 1'b0) | (img_rows_c_full_n == 1'b0)) & (1'b1 == ap_CS_fsm_state1))) begin
        img_rows_c_write = 1'b1;
    end else begin
        img_rows_c_write = 1'b0;
    end
end

always @ (*) begin
    if ((~((real_start == 1'b0) | (ap_done_reg == 1'b1) | (img_cols_c_full_n == 1'b0) | (img_rows_c_full_n == 1'b0)) & (1'b1 == ap_CS_fsm_state1))) begin
        indexr = select_ln35_fu_190_p3;
    end else begin
        indexr = indexr_preg;
    end
end

always @ (*) begin
    if ((~((real_start == 1'b0) | (ap_done_reg == 1'b1) | (img_cols_c_full_n == 1'b0) | (img_rows_c_full_n == 1'b0)) & (1'b1 == ap_CS_fsm_state1))) begin
        indexr_ap_vld = 1'b1;
    end else begin
        indexr_ap_vld = 1'b0;
    end
end

always @ (*) begin
    if (((1'b0 == ap_block_state3_on_subcall_done) & (1'b1 == ap_CS_fsm_state3))) begin
        internal_ap_ready = 1'b1;
    end else begin
        internal_ap_ready = 1'b0;
    end
end

always @ (*) begin
    if (((1'b1 == ap_CS_fsm_state3) | (1'b1 == ap_CS_fsm_state2))) begin
        m_axi_gmem_ARVALID = grp_dataflow_parent_loop_proc_fu_131_m_axi_gmem_ARVALID;
    end else begin
        m_axi_gmem_ARVALID = 1'b0;
    end
end

always @ (*) begin
    if (((1'b1 == ap_CS_fsm_state3) | (1'b1 == ap_CS_fsm_state2))) begin
        m_axi_gmem_RREADY = grp_dataflow_parent_loop_proc_fu_131_m_axi_gmem_RREADY;
    end else begin
        m_axi_gmem_RREADY = 1'b0;
    end
end

always @ (*) begin
    if (((start_once_reg == 1'b0) & (start_full_n == 1'b0))) begin
        real_start = 1'b0;
    end else begin
        real_start = ap_start;
    end
end

always @ (*) begin
    if (((real_start == 1'b1) & (start_once_reg == 1'b0))) begin
        start_write = 1'b1;
    end else begin
        start_write = 1'b0;
    end
end

always @ (*) begin
    case (ap_CS_fsm)
        ap_ST_fsm_state1 : begin
            if ((~((real_start == 1'b0) | (ap_done_reg == 1'b1) | (img_cols_c_full_n == 1'b0) | (img_rows_c_full_n == 1'b0)) & (1'b1 == ap_CS_fsm_state1))) begin
                ap_NS_fsm = ap_ST_fsm_state2;
            end else begin
                ap_NS_fsm = ap_ST_fsm_state1;
            end
        end
        ap_ST_fsm_state2 : begin
            ap_NS_fsm = ap_ST_fsm_state3;
        end
        ap_ST_fsm_state3 : begin
            if (((1'b0 == ap_block_state3_on_subcall_done) & (1'b1 == ap_CS_fsm_state3))) begin
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

assign add_ln34_fu_170_p2 = (index + 32'd1);

assign ap_CS_fsm_state1 = ap_CS_fsm[32'd0];

assign ap_CS_fsm_state2 = ap_CS_fsm[32'd1];

assign ap_CS_fsm_state3 = ap_CS_fsm[32'd2];

always @ (*) begin
    ap_block_state1 = ((real_start == 1'b0) | (ap_done_reg == 1'b1) | (img_cols_c_full_n == 1'b0) | (img_rows_c_full_n == 1'b0));
end

always @ (*) begin
    ap_block_state3_on_subcall_done = ((ap_sync_grp_dataflow_parent_loop_proc_fu_131_ap_ready & ap_sync_grp_dataflow_parent_loop_proc_fu_131_ap_done) == 1'b0);
end

assign ap_ready = internal_ap_ready;

assign ap_sync_grp_dataflow_parent_loop_proc_fu_131_ap_done = (grp_dataflow_parent_loop_proc_fu_131_ap_done | ap_sync_reg_grp_dataflow_parent_loop_proc_fu_131_ap_done);

assign ap_sync_grp_dataflow_parent_loop_proc_fu_131_ap_ready = (grp_dataflow_parent_loop_proc_fu_131_ap_ready | ap_sync_reg_grp_dataflow_parent_loop_proc_fu_131_ap_ready);

assign baseAddr_address0 = grp_dataflow_parent_loop_proc_fu_131_baseAddr_address0;

assign baseAddr_ce0 = grp_dataflow_parent_loop_proc_fu_131_baseAddr_ce0;

assign grp_dataflow_parent_loop_proc_fu_131_ap_start = grp_dataflow_parent_loop_proc_fu_131_ap_start_reg;

assign icmp_ln34_fu_164_p2 = (($signed(tmp_fu_154_p4) < $signed(31'd1)) ? 1'b1 : 1'b0);

assign icmp_ln35_fu_184_p2 = ((n_fu_176_p3 == w) ? 1'b1 : 1'b0);

assign img_cols_c_din = p_read1;

assign img_data_din = grp_dataflow_parent_loop_proc_fu_131_img_data_din;

assign img_rows_c_din = p_read;

assign m_axi_gmem_ARADDR = grp_dataflow_parent_loop_proc_fu_131_m_axi_gmem_ARADDR;

assign m_axi_gmem_ARBURST = grp_dataflow_parent_loop_proc_fu_131_m_axi_gmem_ARBURST;

assign m_axi_gmem_ARCACHE = grp_dataflow_parent_loop_proc_fu_131_m_axi_gmem_ARCACHE;

assign m_axi_gmem_ARID = grp_dataflow_parent_loop_proc_fu_131_m_axi_gmem_ARID;

assign m_axi_gmem_ARLEN = grp_dataflow_parent_loop_proc_fu_131_m_axi_gmem_ARLEN;

assign m_axi_gmem_ARLOCK = grp_dataflow_parent_loop_proc_fu_131_m_axi_gmem_ARLOCK;

assign m_axi_gmem_ARPROT = grp_dataflow_parent_loop_proc_fu_131_m_axi_gmem_ARPROT;

assign m_axi_gmem_ARQOS = grp_dataflow_parent_loop_proc_fu_131_m_axi_gmem_ARQOS;

assign m_axi_gmem_ARREGION = grp_dataflow_parent_loop_proc_fu_131_m_axi_gmem_ARREGION;

assign m_axi_gmem_ARSIZE = grp_dataflow_parent_loop_proc_fu_131_m_axi_gmem_ARSIZE;

assign m_axi_gmem_ARUSER = grp_dataflow_parent_loop_proc_fu_131_m_axi_gmem_ARUSER;

assign m_axi_gmem_AWADDR = 64'd0;

assign m_axi_gmem_AWBURST = 2'd0;

assign m_axi_gmem_AWCACHE = 4'd0;

assign m_axi_gmem_AWID = 1'd0;

assign m_axi_gmem_AWLEN = 32'd0;

assign m_axi_gmem_AWLOCK = 2'd0;

assign m_axi_gmem_AWPROT = 3'd0;

assign m_axi_gmem_AWQOS = 4'd0;

assign m_axi_gmem_AWREGION = 4'd0;

assign m_axi_gmem_AWSIZE = 3'd0;

assign m_axi_gmem_AWUSER = 1'd0;

assign m_axi_gmem_AWVALID = 1'b0;

assign m_axi_gmem_BREADY = 1'b0;

assign m_axi_gmem_WDATA = 32'd0;

assign m_axi_gmem_WID = 1'd0;

assign m_axi_gmem_WLAST = 1'b0;

assign m_axi_gmem_WSTRB = 4'd0;

assign m_axi_gmem_WUSER = 1'd0;

assign m_axi_gmem_WVALID = 1'b0;

assign n_fu_176_p3 = ((icmp_ln34_fu_164_p2[0:0] == 1'b1) ? add_ln34_fu_170_p2 : 32'd0);

assign select_ln35_fu_190_p3 = ((icmp_ln35_fu_184_p2[0:0] == 1'b1) ? index : n_fu_176_p3);

assign start_out = real_start;

assign tmp_fu_154_p4 = {{index[31:1]}};

endmodule //mem2stream_mem2mat_1080_1920_s