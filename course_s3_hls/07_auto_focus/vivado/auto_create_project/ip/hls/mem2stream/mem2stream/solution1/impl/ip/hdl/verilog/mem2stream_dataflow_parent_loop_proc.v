// ==============================================================
// Generated by Vitis HLS v2023.1
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// ==============================================================

`timescale 1 ns / 1 ps 

module mem2stream_dataflow_parent_loop_proc (
        local_rows,
        baseAddr_address0,
        baseAddr_ce0,
        baseAddr_d0,
        baseAddr_q0,
        baseAddr_we0,
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
        p_read,
        p_read1,
        img_data_din,
        img_data_full_n,
        img_data_write,
        index,
        ap_clk,
        ap_rst,
        pMemPort_ap_vld,
        p_read_ap_vld,
        p_read1_ap_vld,
        index_ap_vld,
        ap_start,
        ap_done,
        ap_ready,
        ap_idle,
        ap_continue
);


input  [10:0] local_rows;
output  [1:0] baseAddr_address0;
output   baseAddr_ce0;
output  [31:0] baseAddr_d0;
input  [31:0] baseAddr_q0;
output   baseAddr_we0;
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
input  [10:0] p_read;
input  [7:0] p_read1;
output  [23:0] img_data_din;
input   img_data_full_n;
output   img_data_write;
input  [31:0] index;
input   ap_clk;
input   ap_rst;
input   pMemPort_ap_vld;
input   p_read_ap_vld;
input   p_read1_ap_vld;
input   index_ap_vld;
input   ap_start;
output   ap_done;
output   ap_ready;
output   ap_idle;
input   ap_continue;

reg ap_done;
reg ap_ready;
reg ap_idle;

wire   [1:0] dataflow_in_loop_VITIS_LOOP_38_1_1_U0_baseAddr_address0;
wire    dataflow_in_loop_VITIS_LOOP_38_1_1_U0_baseAddr_ce0;
wire   [31:0] dataflow_in_loop_VITIS_LOOP_38_1_1_U0_baseAddr_d0;
wire    dataflow_in_loop_VITIS_LOOP_38_1_1_U0_baseAddr_we0;
wire    dataflow_in_loop_VITIS_LOOP_38_1_1_U0_m_axi_gmem_AWVALID;
wire   [63:0] dataflow_in_loop_VITIS_LOOP_38_1_1_U0_m_axi_gmem_AWADDR;
wire   [0:0] dataflow_in_loop_VITIS_LOOP_38_1_1_U0_m_axi_gmem_AWID;
wire   [31:0] dataflow_in_loop_VITIS_LOOP_38_1_1_U0_m_axi_gmem_AWLEN;
wire   [2:0] dataflow_in_loop_VITIS_LOOP_38_1_1_U0_m_axi_gmem_AWSIZE;
wire   [1:0] dataflow_in_loop_VITIS_LOOP_38_1_1_U0_m_axi_gmem_AWBURST;
wire   [1:0] dataflow_in_loop_VITIS_LOOP_38_1_1_U0_m_axi_gmem_AWLOCK;
wire   [3:0] dataflow_in_loop_VITIS_LOOP_38_1_1_U0_m_axi_gmem_AWCACHE;
wire   [2:0] dataflow_in_loop_VITIS_LOOP_38_1_1_U0_m_axi_gmem_AWPROT;
wire   [3:0] dataflow_in_loop_VITIS_LOOP_38_1_1_U0_m_axi_gmem_AWQOS;
wire   [3:0] dataflow_in_loop_VITIS_LOOP_38_1_1_U0_m_axi_gmem_AWREGION;
wire   [0:0] dataflow_in_loop_VITIS_LOOP_38_1_1_U0_m_axi_gmem_AWUSER;
wire    dataflow_in_loop_VITIS_LOOP_38_1_1_U0_m_axi_gmem_WVALID;
wire   [31:0] dataflow_in_loop_VITIS_LOOP_38_1_1_U0_m_axi_gmem_WDATA;
wire   [3:0] dataflow_in_loop_VITIS_LOOP_38_1_1_U0_m_axi_gmem_WSTRB;
wire    dataflow_in_loop_VITIS_LOOP_38_1_1_U0_m_axi_gmem_WLAST;
wire   [0:0] dataflow_in_loop_VITIS_LOOP_38_1_1_U0_m_axi_gmem_WID;
wire   [0:0] dataflow_in_loop_VITIS_LOOP_38_1_1_U0_m_axi_gmem_WUSER;
wire    dataflow_in_loop_VITIS_LOOP_38_1_1_U0_m_axi_gmem_ARVALID;
wire   [63:0] dataflow_in_loop_VITIS_LOOP_38_1_1_U0_m_axi_gmem_ARADDR;
wire   [0:0] dataflow_in_loop_VITIS_LOOP_38_1_1_U0_m_axi_gmem_ARID;
wire   [31:0] dataflow_in_loop_VITIS_LOOP_38_1_1_U0_m_axi_gmem_ARLEN;
wire   [2:0] dataflow_in_loop_VITIS_LOOP_38_1_1_U0_m_axi_gmem_ARSIZE;
wire   [1:0] dataflow_in_loop_VITIS_LOOP_38_1_1_U0_m_axi_gmem_ARBURST;
wire   [1:0] dataflow_in_loop_VITIS_LOOP_38_1_1_U0_m_axi_gmem_ARLOCK;
wire   [3:0] dataflow_in_loop_VITIS_LOOP_38_1_1_U0_m_axi_gmem_ARCACHE;
wire   [2:0] dataflow_in_loop_VITIS_LOOP_38_1_1_U0_m_axi_gmem_ARPROT;
wire   [3:0] dataflow_in_loop_VITIS_LOOP_38_1_1_U0_m_axi_gmem_ARQOS;
wire   [3:0] dataflow_in_loop_VITIS_LOOP_38_1_1_U0_m_axi_gmem_ARREGION;
wire   [0:0] dataflow_in_loop_VITIS_LOOP_38_1_1_U0_m_axi_gmem_ARUSER;
wire    dataflow_in_loop_VITIS_LOOP_38_1_1_U0_m_axi_gmem_RREADY;
wire    dataflow_in_loop_VITIS_LOOP_38_1_1_U0_m_axi_gmem_BREADY;
wire   [23:0] dataflow_in_loop_VITIS_LOOP_38_1_1_U0_img_data_din;
wire    dataflow_in_loop_VITIS_LOOP_38_1_1_U0_img_data_write;
wire    dataflow_in_loop_VITIS_LOOP_38_1_1_U0_ap_start;
wire    dataflow_in_loop_VITIS_LOOP_38_1_1_U0_ap_done;
wire    dataflow_in_loop_VITIS_LOOP_38_1_1_U0_ap_ready;
wire    dataflow_in_loop_VITIS_LOOP_38_1_1_U0_ap_idle;
reg    dataflow_in_loop_VITIS_LOOP_38_1_1_U0_ap_continue;
reg   [10:0] loop_dataflow_input_count;
reg   [10:0] loop_dataflow_output_count;
wire   [10:0] bound_minus_1;
wire    ap_ce_reg;

// power-on initialization
initial begin
#0 loop_dataflow_input_count = 11'd0;
#0 loop_dataflow_output_count = 11'd0;
end

mem2stream_dataflow_in_loop_VITIS_LOOP_38_1_1 dataflow_in_loop_VITIS_LOOP_38_1_1_U0(
    .baseAddr_address0(dataflow_in_loop_VITIS_LOOP_38_1_1_U0_baseAddr_address0),
    .baseAddr_ce0(dataflow_in_loop_VITIS_LOOP_38_1_1_U0_baseAddr_ce0),
    .baseAddr_d0(dataflow_in_loop_VITIS_LOOP_38_1_1_U0_baseAddr_d0),
    .baseAddr_q0(baseAddr_q0),
    .baseAddr_we0(dataflow_in_loop_VITIS_LOOP_38_1_1_U0_baseAddr_we0),
    .m_axi_gmem_AWVALID(dataflow_in_loop_VITIS_LOOP_38_1_1_U0_m_axi_gmem_AWVALID),
    .m_axi_gmem_AWREADY(1'b0),
    .m_axi_gmem_AWADDR(dataflow_in_loop_VITIS_LOOP_38_1_1_U0_m_axi_gmem_AWADDR),
    .m_axi_gmem_AWID(dataflow_in_loop_VITIS_LOOP_38_1_1_U0_m_axi_gmem_AWID),
    .m_axi_gmem_AWLEN(dataflow_in_loop_VITIS_LOOP_38_1_1_U0_m_axi_gmem_AWLEN),
    .m_axi_gmem_AWSIZE(dataflow_in_loop_VITIS_LOOP_38_1_1_U0_m_axi_gmem_AWSIZE),
    .m_axi_gmem_AWBURST(dataflow_in_loop_VITIS_LOOP_38_1_1_U0_m_axi_gmem_AWBURST),
    .m_axi_gmem_AWLOCK(dataflow_in_loop_VITIS_LOOP_38_1_1_U0_m_axi_gmem_AWLOCK),
    .m_axi_gmem_AWCACHE(dataflow_in_loop_VITIS_LOOP_38_1_1_U0_m_axi_gmem_AWCACHE),
    .m_axi_gmem_AWPROT(dataflow_in_loop_VITIS_LOOP_38_1_1_U0_m_axi_gmem_AWPROT),
    .m_axi_gmem_AWQOS(dataflow_in_loop_VITIS_LOOP_38_1_1_U0_m_axi_gmem_AWQOS),
    .m_axi_gmem_AWREGION(dataflow_in_loop_VITIS_LOOP_38_1_1_U0_m_axi_gmem_AWREGION),
    .m_axi_gmem_AWUSER(dataflow_in_loop_VITIS_LOOP_38_1_1_U0_m_axi_gmem_AWUSER),
    .m_axi_gmem_WVALID(dataflow_in_loop_VITIS_LOOP_38_1_1_U0_m_axi_gmem_WVALID),
    .m_axi_gmem_WREADY(1'b0),
    .m_axi_gmem_WDATA(dataflow_in_loop_VITIS_LOOP_38_1_1_U0_m_axi_gmem_WDATA),
    .m_axi_gmem_WSTRB(dataflow_in_loop_VITIS_LOOP_38_1_1_U0_m_axi_gmem_WSTRB),
    .m_axi_gmem_WLAST(dataflow_in_loop_VITIS_LOOP_38_1_1_U0_m_axi_gmem_WLAST),
    .m_axi_gmem_WID(dataflow_in_loop_VITIS_LOOP_38_1_1_U0_m_axi_gmem_WID),
    .m_axi_gmem_WUSER(dataflow_in_loop_VITIS_LOOP_38_1_1_U0_m_axi_gmem_WUSER),
    .m_axi_gmem_ARVALID(dataflow_in_loop_VITIS_LOOP_38_1_1_U0_m_axi_gmem_ARVALID),
    .m_axi_gmem_ARREADY(m_axi_gmem_ARREADY),
    .m_axi_gmem_ARADDR(dataflow_in_loop_VITIS_LOOP_38_1_1_U0_m_axi_gmem_ARADDR),
    .m_axi_gmem_ARID(dataflow_in_loop_VITIS_LOOP_38_1_1_U0_m_axi_gmem_ARID),
    .m_axi_gmem_ARLEN(dataflow_in_loop_VITIS_LOOP_38_1_1_U0_m_axi_gmem_ARLEN),
    .m_axi_gmem_ARSIZE(dataflow_in_loop_VITIS_LOOP_38_1_1_U0_m_axi_gmem_ARSIZE),
    .m_axi_gmem_ARBURST(dataflow_in_loop_VITIS_LOOP_38_1_1_U0_m_axi_gmem_ARBURST),
    .m_axi_gmem_ARLOCK(dataflow_in_loop_VITIS_LOOP_38_1_1_U0_m_axi_gmem_ARLOCK),
    .m_axi_gmem_ARCACHE(dataflow_in_loop_VITIS_LOOP_38_1_1_U0_m_axi_gmem_ARCACHE),
    .m_axi_gmem_ARPROT(dataflow_in_loop_VITIS_LOOP_38_1_1_U0_m_axi_gmem_ARPROT),
    .m_axi_gmem_ARQOS(dataflow_in_loop_VITIS_LOOP_38_1_1_U0_m_axi_gmem_ARQOS),
    .m_axi_gmem_ARREGION(dataflow_in_loop_VITIS_LOOP_38_1_1_U0_m_axi_gmem_ARREGION),
    .m_axi_gmem_ARUSER(dataflow_in_loop_VITIS_LOOP_38_1_1_U0_m_axi_gmem_ARUSER),
    .m_axi_gmem_RVALID(m_axi_gmem_RVALID),
    .m_axi_gmem_RREADY(dataflow_in_loop_VITIS_LOOP_38_1_1_U0_m_axi_gmem_RREADY),
    .m_axi_gmem_RDATA(m_axi_gmem_RDATA),
    .m_axi_gmem_RLAST(m_axi_gmem_RLAST),
    .m_axi_gmem_RID(m_axi_gmem_RID),
    .m_axi_gmem_RFIFONUM(m_axi_gmem_RFIFONUM),
    .m_axi_gmem_RUSER(m_axi_gmem_RUSER),
    .m_axi_gmem_RRESP(m_axi_gmem_RRESP),
    .m_axi_gmem_BVALID(1'b0),
    .m_axi_gmem_BREADY(dataflow_in_loop_VITIS_LOOP_38_1_1_U0_m_axi_gmem_BREADY),
    .m_axi_gmem_BRESP(2'd0),
    .m_axi_gmem_BID(1'd0),
    .m_axi_gmem_BUSER(1'd0),
    .pMemPort(pMemPort),
    .row(loop_dataflow_input_count),
    .p_read(p_read),
    .p_read1(p_read1),
    .img_data_din(dataflow_in_loop_VITIS_LOOP_38_1_1_U0_img_data_din),
    .img_data_full_n(img_data_full_n),
    .img_data_write(dataflow_in_loop_VITIS_LOOP_38_1_1_U0_img_data_write),
    .index(index),
    .ap_clk(ap_clk),
    .ap_rst(ap_rst),
    .p_read1_ap_vld(p_read1_ap_vld),
    .index_ap_vld(index_ap_vld),
    .ap_start(dataflow_in_loop_VITIS_LOOP_38_1_1_U0_ap_start),
    .pMemPort_ap_vld(pMemPort_ap_vld),
    .row_ap_vld(1'b0),
    .p_read_ap_vld(p_read_ap_vld),
    .ap_done(dataflow_in_loop_VITIS_LOOP_38_1_1_U0_ap_done),
    .ap_ready(dataflow_in_loop_VITIS_LOOP_38_1_1_U0_ap_ready),
    .ap_idle(dataflow_in_loop_VITIS_LOOP_38_1_1_U0_ap_idle),
    .ap_continue(dataflow_in_loop_VITIS_LOOP_38_1_1_U0_ap_continue)
);

always @ (posedge ap_clk) begin
    if (ap_rst == 1'b1) begin
        loop_dataflow_input_count <= 11'd0;
    end else begin
        if ((~(loop_dataflow_input_count == bound_minus_1) & (ap_start == 1'b1) & (dataflow_in_loop_VITIS_LOOP_38_1_1_U0_ap_ready == 1'b1))) begin
            loop_dataflow_input_count <= (loop_dataflow_input_count + 11'd1);
        end else if (((loop_dataflow_input_count == bound_minus_1) & (ap_start == 1'b1) & (dataflow_in_loop_VITIS_LOOP_38_1_1_U0_ap_ready == 1'b1))) begin
            loop_dataflow_input_count <= 11'd0;
        end
    end
end

always @ (posedge ap_clk) begin
    if (ap_rst == 1'b1) begin
        loop_dataflow_output_count <= 11'd0;
    end else begin
        if ((~(loop_dataflow_output_count == bound_minus_1) & (dataflow_in_loop_VITIS_LOOP_38_1_1_U0_ap_continue == 1'b1) & (dataflow_in_loop_VITIS_LOOP_38_1_1_U0_ap_done == 1'b1))) begin
            loop_dataflow_output_count <= (loop_dataflow_output_count + 11'd1);
        end else if (((loop_dataflow_output_count == bound_minus_1) & (dataflow_in_loop_VITIS_LOOP_38_1_1_U0_ap_continue == 1'b1) & (dataflow_in_loop_VITIS_LOOP_38_1_1_U0_ap_done == 1'b1))) begin
            loop_dataflow_output_count <= 11'd0;
        end
    end
end

always @ (*) begin
    if (((loop_dataflow_output_count == bound_minus_1) & (dataflow_in_loop_VITIS_LOOP_38_1_1_U0_ap_done == 1'b1))) begin
        ap_done = 1'b1;
    end else begin
        ap_done = 1'b0;
    end
end

always @ (*) begin
    if (((loop_dataflow_output_count == 11'd0) & (ap_start == 1'b0) & (dataflow_in_loop_VITIS_LOOP_38_1_1_U0_ap_idle == 1'b1))) begin
        ap_idle = 1'b1;
    end else begin
        ap_idle = 1'b0;
    end
end

always @ (*) begin
    if (((loop_dataflow_input_count == bound_minus_1) & (ap_start == 1'b1) & (dataflow_in_loop_VITIS_LOOP_38_1_1_U0_ap_ready == 1'b1))) begin
        ap_ready = 1'b1;
    end else begin
        ap_ready = 1'b0;
    end
end

always @ (*) begin
    if ((~(loop_dataflow_output_count == bound_minus_1) | (ap_continue == 1'b1))) begin
        dataflow_in_loop_VITIS_LOOP_38_1_1_U0_ap_continue = 1'b1;
    end else begin
        dataflow_in_loop_VITIS_LOOP_38_1_1_U0_ap_continue = 1'b0;
    end
end

assign baseAddr_address0 = dataflow_in_loop_VITIS_LOOP_38_1_1_U0_baseAddr_address0;

assign baseAddr_ce0 = dataflow_in_loop_VITIS_LOOP_38_1_1_U0_baseAddr_ce0;

assign baseAddr_d0 = 32'd0;

assign baseAddr_we0 = 1'b0;

assign bound_minus_1 = (local_rows - 11'd1);

assign dataflow_in_loop_VITIS_LOOP_38_1_1_U0_ap_start = ap_start;

assign img_data_din = dataflow_in_loop_VITIS_LOOP_38_1_1_U0_img_data_din;

assign img_data_write = dataflow_in_loop_VITIS_LOOP_38_1_1_U0_img_data_write;

assign m_axi_gmem_ARADDR = dataflow_in_loop_VITIS_LOOP_38_1_1_U0_m_axi_gmem_ARADDR;

assign m_axi_gmem_ARBURST = dataflow_in_loop_VITIS_LOOP_38_1_1_U0_m_axi_gmem_ARBURST;

assign m_axi_gmem_ARCACHE = dataflow_in_loop_VITIS_LOOP_38_1_1_U0_m_axi_gmem_ARCACHE;

assign m_axi_gmem_ARID = dataflow_in_loop_VITIS_LOOP_38_1_1_U0_m_axi_gmem_ARID;

assign m_axi_gmem_ARLEN = dataflow_in_loop_VITIS_LOOP_38_1_1_U0_m_axi_gmem_ARLEN;

assign m_axi_gmem_ARLOCK = dataflow_in_loop_VITIS_LOOP_38_1_1_U0_m_axi_gmem_ARLOCK;

assign m_axi_gmem_ARPROT = dataflow_in_loop_VITIS_LOOP_38_1_1_U0_m_axi_gmem_ARPROT;

assign m_axi_gmem_ARQOS = dataflow_in_loop_VITIS_LOOP_38_1_1_U0_m_axi_gmem_ARQOS;

assign m_axi_gmem_ARREGION = dataflow_in_loop_VITIS_LOOP_38_1_1_U0_m_axi_gmem_ARREGION;

assign m_axi_gmem_ARSIZE = dataflow_in_loop_VITIS_LOOP_38_1_1_U0_m_axi_gmem_ARSIZE;

assign m_axi_gmem_ARUSER = dataflow_in_loop_VITIS_LOOP_38_1_1_U0_m_axi_gmem_ARUSER;

assign m_axi_gmem_ARVALID = dataflow_in_loop_VITIS_LOOP_38_1_1_U0_m_axi_gmem_ARVALID;

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

assign m_axi_gmem_RREADY = dataflow_in_loop_VITIS_LOOP_38_1_1_U0_m_axi_gmem_RREADY;

assign m_axi_gmem_WDATA = 32'd0;

assign m_axi_gmem_WID = 1'd0;

assign m_axi_gmem_WLAST = 1'b0;

assign m_axi_gmem_WSTRB = 4'd0;

assign m_axi_gmem_WUSER = 1'd0;

assign m_axi_gmem_WVALID = 1'b0;

endmodule //mem2stream_dataflow_parent_loop_proc