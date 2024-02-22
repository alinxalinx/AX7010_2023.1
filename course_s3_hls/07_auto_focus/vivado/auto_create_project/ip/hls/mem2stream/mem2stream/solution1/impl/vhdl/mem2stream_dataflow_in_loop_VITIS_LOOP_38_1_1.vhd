-- ==============================================================
-- Generated by Vitis HLS v2023.1
-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
-- ==============================================================

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity mem2stream_dataflow_in_loop_VITIS_LOOP_38_1_1 is
port (
    baseAddr_address0 : OUT STD_LOGIC_VECTOR (1 downto 0);
    baseAddr_ce0 : OUT STD_LOGIC;
    baseAddr_d0 : OUT STD_LOGIC_VECTOR (31 downto 0);
    baseAddr_q0 : IN STD_LOGIC_VECTOR (31 downto 0);
    baseAddr_we0 : OUT STD_LOGIC;
    m_axi_gmem_AWVALID : OUT STD_LOGIC;
    m_axi_gmem_AWREADY : IN STD_LOGIC;
    m_axi_gmem_AWADDR : OUT STD_LOGIC_VECTOR (63 downto 0);
    m_axi_gmem_AWID : OUT STD_LOGIC_VECTOR (0 downto 0);
    m_axi_gmem_AWLEN : OUT STD_LOGIC_VECTOR (31 downto 0);
    m_axi_gmem_AWSIZE : OUT STD_LOGIC_VECTOR (2 downto 0);
    m_axi_gmem_AWBURST : OUT STD_LOGIC_VECTOR (1 downto 0);
    m_axi_gmem_AWLOCK : OUT STD_LOGIC_VECTOR (1 downto 0);
    m_axi_gmem_AWCACHE : OUT STD_LOGIC_VECTOR (3 downto 0);
    m_axi_gmem_AWPROT : OUT STD_LOGIC_VECTOR (2 downto 0);
    m_axi_gmem_AWQOS : OUT STD_LOGIC_VECTOR (3 downto 0);
    m_axi_gmem_AWREGION : OUT STD_LOGIC_VECTOR (3 downto 0);
    m_axi_gmem_AWUSER : OUT STD_LOGIC_VECTOR (0 downto 0);
    m_axi_gmem_WVALID : OUT STD_LOGIC;
    m_axi_gmem_WREADY : IN STD_LOGIC;
    m_axi_gmem_WDATA : OUT STD_LOGIC_VECTOR (31 downto 0);
    m_axi_gmem_WSTRB : OUT STD_LOGIC_VECTOR (3 downto 0);
    m_axi_gmem_WLAST : OUT STD_LOGIC;
    m_axi_gmem_WID : OUT STD_LOGIC_VECTOR (0 downto 0);
    m_axi_gmem_WUSER : OUT STD_LOGIC_VECTOR (0 downto 0);
    m_axi_gmem_ARVALID : OUT STD_LOGIC;
    m_axi_gmem_ARREADY : IN STD_LOGIC;
    m_axi_gmem_ARADDR : OUT STD_LOGIC_VECTOR (63 downto 0);
    m_axi_gmem_ARID : OUT STD_LOGIC_VECTOR (0 downto 0);
    m_axi_gmem_ARLEN : OUT STD_LOGIC_VECTOR (31 downto 0);
    m_axi_gmem_ARSIZE : OUT STD_LOGIC_VECTOR (2 downto 0);
    m_axi_gmem_ARBURST : OUT STD_LOGIC_VECTOR (1 downto 0);
    m_axi_gmem_ARLOCK : OUT STD_LOGIC_VECTOR (1 downto 0);
    m_axi_gmem_ARCACHE : OUT STD_LOGIC_VECTOR (3 downto 0);
    m_axi_gmem_ARPROT : OUT STD_LOGIC_VECTOR (2 downto 0);
    m_axi_gmem_ARQOS : OUT STD_LOGIC_VECTOR (3 downto 0);
    m_axi_gmem_ARREGION : OUT STD_LOGIC_VECTOR (3 downto 0);
    m_axi_gmem_ARUSER : OUT STD_LOGIC_VECTOR (0 downto 0);
    m_axi_gmem_RVALID : IN STD_LOGIC;
    m_axi_gmem_RREADY : OUT STD_LOGIC;
    m_axi_gmem_RDATA : IN STD_LOGIC_VECTOR (31 downto 0);
    m_axi_gmem_RLAST : IN STD_LOGIC;
    m_axi_gmem_RID : IN STD_LOGIC_VECTOR (0 downto 0);
    m_axi_gmem_RFIFONUM : IN STD_LOGIC_VECTOR (8 downto 0);
    m_axi_gmem_RUSER : IN STD_LOGIC_VECTOR (0 downto 0);
    m_axi_gmem_RRESP : IN STD_LOGIC_VECTOR (1 downto 0);
    m_axi_gmem_BVALID : IN STD_LOGIC;
    m_axi_gmem_BREADY : OUT STD_LOGIC;
    m_axi_gmem_BRESP : IN STD_LOGIC_VECTOR (1 downto 0);
    m_axi_gmem_BID : IN STD_LOGIC_VECTOR (0 downto 0);
    m_axi_gmem_BUSER : IN STD_LOGIC_VECTOR (0 downto 0);
    pMemPort : IN STD_LOGIC_VECTOR (63 downto 0);
    row : IN STD_LOGIC_VECTOR (10 downto 0);
    p_read : IN STD_LOGIC_VECTOR (10 downto 0);
    p_read1 : IN STD_LOGIC_VECTOR (7 downto 0);
    img_data_din : OUT STD_LOGIC_VECTOR (23 downto 0);
    img_data_full_n : IN STD_LOGIC;
    img_data_write : OUT STD_LOGIC;
    index : IN STD_LOGIC_VECTOR (31 downto 0);
    ap_clk : IN STD_LOGIC;
    ap_rst : IN STD_LOGIC;
    p_read1_ap_vld : IN STD_LOGIC;
    index_ap_vld : IN STD_LOGIC;
    ap_start : IN STD_LOGIC;
    pMemPort_ap_vld : IN STD_LOGIC;
    row_ap_vld : IN STD_LOGIC;
    p_read_ap_vld : IN STD_LOGIC;
    ap_done : OUT STD_LOGIC;
    ap_ready : OUT STD_LOGIC;
    ap_idle : OUT STD_LOGIC;
    ap_continue : IN STD_LOGIC );
end;


architecture behav of mem2stream_dataflow_in_loop_VITIS_LOOP_38_1_1 is 
    constant ap_const_lv2_0 : STD_LOGIC_VECTOR (1 downto 0) := "00";
    constant ap_const_logic_0 : STD_LOGIC := '0';
    constant ap_const_lv32_0 : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000000";
    constant ap_const_logic_1 : STD_LOGIC := '1';
    constant ap_const_lv1_0 : STD_LOGIC_VECTOR (0 downto 0) := "0";
    constant ap_const_lv64_0 : STD_LOGIC_VECTOR (63 downto 0) := "0000000000000000000000000000000000000000000000000000000000000000";
    constant ap_const_lv3_0 : STD_LOGIC_VECTOR (2 downto 0) := "000";
    constant ap_const_lv4_0 : STD_LOGIC_VECTOR (3 downto 0) := "0000";
    constant ap_const_boolean_1 : BOOLEAN := true;

attribute shreg_extract : string;
    signal dataflow_in_loop_VITIS_LOOP_38_1_1_Block_newFuncRoot17_proc3_U0_ap_start : STD_LOGIC;
    signal dataflow_in_loop_VITIS_LOOP_38_1_1_Block_newFuncRoot17_proc3_U0_ap_done : STD_LOGIC;
    signal dataflow_in_loop_VITIS_LOOP_38_1_1_Block_newFuncRoot17_proc3_U0_ap_continue : STD_LOGIC;
    signal dataflow_in_loop_VITIS_LOOP_38_1_1_Block_newFuncRoot17_proc3_U0_ap_idle : STD_LOGIC;
    signal dataflow_in_loop_VITIS_LOOP_38_1_1_Block_newFuncRoot17_proc3_U0_ap_ready : STD_LOGIC;
    signal dataflow_in_loop_VITIS_LOOP_38_1_1_Block_newFuncRoot17_proc3_U0_baseAddr_address0 : STD_LOGIC_VECTOR (1 downto 0);
    signal dataflow_in_loop_VITIS_LOOP_38_1_1_Block_newFuncRoot17_proc3_U0_baseAddr_ce0 : STD_LOGIC;
    signal dataflow_in_loop_VITIS_LOOP_38_1_1_Block_newFuncRoot17_proc3_U0_ap_return_0 : STD_LOGIC_VECTOR (31 downto 0);
    signal dataflow_in_loop_VITIS_LOOP_38_1_1_Block_newFuncRoot17_proc3_U0_ap_return_1 : STD_LOGIC_VECTOR (29 downto 0);
    signal ap_channel_done_trunc_ln42_loc_i_i_channel : STD_LOGIC;
    signal trunc_ln42_loc_i_i_channel_full_n : STD_LOGIC;
    signal ap_sync_reg_channel_write_trunc_ln42_loc_i_i_channel : STD_LOGIC := '0';
    signal ap_sync_channel_write_trunc_ln42_loc_i_i_channel : STD_LOGIC;
    signal ap_channel_done_p_cast16_loc_i_i_channel : STD_LOGIC;
    signal p_cast16_loc_i_i_channel_full_n : STD_LOGIC;
    signal ap_sync_reg_channel_write_p_cast16_loc_i_i_channel : STD_LOGIC := '0';
    signal ap_sync_channel_write_p_cast16_loc_i_i_channel : STD_LOGIC;
    signal readmem4_U0_ap_start : STD_LOGIC;
    signal readmem4_U0_ap_done : STD_LOGIC;
    signal readmem4_U0_ap_continue : STD_LOGIC;
    signal readmem4_U0_ap_idle : STD_LOGIC;
    signal readmem4_U0_ap_ready : STD_LOGIC;
    signal readmem4_U0_m_axi_gmem_AWVALID : STD_LOGIC;
    signal readmem4_U0_m_axi_gmem_AWADDR : STD_LOGIC_VECTOR (63 downto 0);
    signal readmem4_U0_m_axi_gmem_AWID : STD_LOGIC_VECTOR (0 downto 0);
    signal readmem4_U0_m_axi_gmem_AWLEN : STD_LOGIC_VECTOR (31 downto 0);
    signal readmem4_U0_m_axi_gmem_AWSIZE : STD_LOGIC_VECTOR (2 downto 0);
    signal readmem4_U0_m_axi_gmem_AWBURST : STD_LOGIC_VECTOR (1 downto 0);
    signal readmem4_U0_m_axi_gmem_AWLOCK : STD_LOGIC_VECTOR (1 downto 0);
    signal readmem4_U0_m_axi_gmem_AWCACHE : STD_LOGIC_VECTOR (3 downto 0);
    signal readmem4_U0_m_axi_gmem_AWPROT : STD_LOGIC_VECTOR (2 downto 0);
    signal readmem4_U0_m_axi_gmem_AWQOS : STD_LOGIC_VECTOR (3 downto 0);
    signal readmem4_U0_m_axi_gmem_AWREGION : STD_LOGIC_VECTOR (3 downto 0);
    signal readmem4_U0_m_axi_gmem_AWUSER : STD_LOGIC_VECTOR (0 downto 0);
    signal readmem4_U0_m_axi_gmem_WVALID : STD_LOGIC;
    signal readmem4_U0_m_axi_gmem_WDATA : STD_LOGIC_VECTOR (31 downto 0);
    signal readmem4_U0_m_axi_gmem_WSTRB : STD_LOGIC_VECTOR (3 downto 0);
    signal readmem4_U0_m_axi_gmem_WLAST : STD_LOGIC;
    signal readmem4_U0_m_axi_gmem_WID : STD_LOGIC_VECTOR (0 downto 0);
    signal readmem4_U0_m_axi_gmem_WUSER : STD_LOGIC_VECTOR (0 downto 0);
    signal readmem4_U0_m_axi_gmem_ARVALID : STD_LOGIC;
    signal readmem4_U0_m_axi_gmem_ARADDR : STD_LOGIC_VECTOR (63 downto 0);
    signal readmem4_U0_m_axi_gmem_ARID : STD_LOGIC_VECTOR (0 downto 0);
    signal readmem4_U0_m_axi_gmem_ARLEN : STD_LOGIC_VECTOR (31 downto 0);
    signal readmem4_U0_m_axi_gmem_ARSIZE : STD_LOGIC_VECTOR (2 downto 0);
    signal readmem4_U0_m_axi_gmem_ARBURST : STD_LOGIC_VECTOR (1 downto 0);
    signal readmem4_U0_m_axi_gmem_ARLOCK : STD_LOGIC_VECTOR (1 downto 0);
    signal readmem4_U0_m_axi_gmem_ARCACHE : STD_LOGIC_VECTOR (3 downto 0);
    signal readmem4_U0_m_axi_gmem_ARPROT : STD_LOGIC_VECTOR (2 downto 0);
    signal readmem4_U0_m_axi_gmem_ARQOS : STD_LOGIC_VECTOR (3 downto 0);
    signal readmem4_U0_m_axi_gmem_ARREGION : STD_LOGIC_VECTOR (3 downto 0);
    signal readmem4_U0_m_axi_gmem_ARUSER : STD_LOGIC_VECTOR (0 downto 0);
    signal readmem4_U0_m_axi_gmem_RREADY : STD_LOGIC;
    signal readmem4_U0_m_axi_gmem_BREADY : STD_LOGIC;
    signal readmem4_U0_cacheBuff_i_i_din : STD_LOGIC_VECTOR (31 downto 0);
    signal readmem4_U0_cacheBuff_i_i_write : STD_LOGIC;
    signal dataflow_in_loop_VITIS_LOOP_38_1_1_Loop_VITIS_LOOP_43_2_proc5_U0_ap_start : STD_LOGIC;
    signal dataflow_in_loop_VITIS_LOOP_38_1_1_Loop_VITIS_LOOP_43_2_proc5_U0_ap_done : STD_LOGIC;
    signal dataflow_in_loop_VITIS_LOOP_38_1_1_Loop_VITIS_LOOP_43_2_proc5_U0_ap_continue : STD_LOGIC;
    signal dataflow_in_loop_VITIS_LOOP_38_1_1_Loop_VITIS_LOOP_43_2_proc5_U0_ap_idle : STD_LOGIC;
    signal dataflow_in_loop_VITIS_LOOP_38_1_1_Loop_VITIS_LOOP_43_2_proc5_U0_ap_ready : STD_LOGIC;
    signal dataflow_in_loop_VITIS_LOOP_38_1_1_Loop_VITIS_LOOP_43_2_proc5_U0_cacheBuff_read : STD_LOGIC;
    signal dataflow_in_loop_VITIS_LOOP_38_1_1_Loop_VITIS_LOOP_43_2_proc5_U0_img_data_din : STD_LOGIC_VECTOR (23 downto 0);
    signal dataflow_in_loop_VITIS_LOOP_38_1_1_Loop_VITIS_LOOP_43_2_proc5_U0_img_data_write : STD_LOGIC;
    signal p_cast16_loc_i_i_channel_dout : STD_LOGIC_VECTOR (31 downto 0);
    signal p_cast16_loc_i_i_channel_num_data_valid : STD_LOGIC_VECTOR (2 downto 0);
    signal p_cast16_loc_i_i_channel_fifo_cap : STD_LOGIC_VECTOR (2 downto 0);
    signal p_cast16_loc_i_i_channel_empty_n : STD_LOGIC;
    signal trunc_ln42_loc_i_i_channel_dout : STD_LOGIC_VECTOR (29 downto 0);
    signal trunc_ln42_loc_i_i_channel_num_data_valid : STD_LOGIC_VECTOR (1 downto 0);
    signal trunc_ln42_loc_i_i_channel_fifo_cap : STD_LOGIC_VECTOR (1 downto 0);
    signal trunc_ln42_loc_i_i_channel_empty_n : STD_LOGIC;
    signal cacheBuff_full_n : STD_LOGIC;
    signal cacheBuff_dout : STD_LOGIC_VECTOR (31 downto 0);
    signal cacheBuff_num_data_valid : STD_LOGIC_VECTOR (12 downto 0);
    signal cacheBuff_fifo_cap : STD_LOGIC_VECTOR (12 downto 0);
    signal cacheBuff_empty_n : STD_LOGIC;
    signal ap_sync_ready : STD_LOGIC;
    signal ap_sync_reg_dataflow_in_loop_VITIS_LOOP_38_1_1_Block_newFuncRoot17_proc3_U0_ap_ready : STD_LOGIC := '0';
    signal ap_sync_dataflow_in_loop_VITIS_LOOP_38_1_1_Block_newFuncRoot17_proc3_U0_ap_ready : STD_LOGIC;
    signal ap_sync_reg_readmem4_U0_ap_ready : STD_LOGIC := '0';
    signal ap_sync_readmem4_U0_ap_ready : STD_LOGIC;
    signal ap_ce_reg : STD_LOGIC;

    component mem2stream_dataflow_in_loop_VITIS_LOOP_38_1_1_Block_newFuncRoot17_proc3 IS
    port (
        ap_clk : IN STD_LOGIC;
        ap_rst : IN STD_LOGIC;
        ap_start : IN STD_LOGIC;
        ap_done : OUT STD_LOGIC;
        ap_continue : IN STD_LOGIC;
        ap_idle : OUT STD_LOGIC;
        ap_ready : OUT STD_LOGIC;
        p_read : IN STD_LOGIC_VECTOR (7 downto 0);
        baseAddr_address0 : OUT STD_LOGIC_VECTOR (1 downto 0);
        baseAddr_ce0 : OUT STD_LOGIC;
        baseAddr_q0 : IN STD_LOGIC_VECTOR (31 downto 0);
        index : IN STD_LOGIC_VECTOR (31 downto 0);
        ap_return_0 : OUT STD_LOGIC_VECTOR (31 downto 0);
        ap_return_1 : OUT STD_LOGIC_VECTOR (29 downto 0) );
    end component;


    component mem2stream_readmem4 IS
    port (
        ap_clk : IN STD_LOGIC;
        ap_rst : IN STD_LOGIC;
        ap_start : IN STD_LOGIC;
        ap_done : OUT STD_LOGIC;
        ap_continue : IN STD_LOGIC;
        ap_idle : OUT STD_LOGIC;
        ap_ready : OUT STD_LOGIC;
        m_axi_gmem_AWVALID : OUT STD_LOGIC;
        m_axi_gmem_AWREADY : IN STD_LOGIC;
        m_axi_gmem_AWADDR : OUT STD_LOGIC_VECTOR (63 downto 0);
        m_axi_gmem_AWID : OUT STD_LOGIC_VECTOR (0 downto 0);
        m_axi_gmem_AWLEN : OUT STD_LOGIC_VECTOR (31 downto 0);
        m_axi_gmem_AWSIZE : OUT STD_LOGIC_VECTOR (2 downto 0);
        m_axi_gmem_AWBURST : OUT STD_LOGIC_VECTOR (1 downto 0);
        m_axi_gmem_AWLOCK : OUT STD_LOGIC_VECTOR (1 downto 0);
        m_axi_gmem_AWCACHE : OUT STD_LOGIC_VECTOR (3 downto 0);
        m_axi_gmem_AWPROT : OUT STD_LOGIC_VECTOR (2 downto 0);
        m_axi_gmem_AWQOS : OUT STD_LOGIC_VECTOR (3 downto 0);
        m_axi_gmem_AWREGION : OUT STD_LOGIC_VECTOR (3 downto 0);
        m_axi_gmem_AWUSER : OUT STD_LOGIC_VECTOR (0 downto 0);
        m_axi_gmem_WVALID : OUT STD_LOGIC;
        m_axi_gmem_WREADY : IN STD_LOGIC;
        m_axi_gmem_WDATA : OUT STD_LOGIC_VECTOR (31 downto 0);
        m_axi_gmem_WSTRB : OUT STD_LOGIC_VECTOR (3 downto 0);
        m_axi_gmem_WLAST : OUT STD_LOGIC;
        m_axi_gmem_WID : OUT STD_LOGIC_VECTOR (0 downto 0);
        m_axi_gmem_WUSER : OUT STD_LOGIC_VECTOR (0 downto 0);
        m_axi_gmem_ARVALID : OUT STD_LOGIC;
        m_axi_gmem_ARREADY : IN STD_LOGIC;
        m_axi_gmem_ARADDR : OUT STD_LOGIC_VECTOR (63 downto 0);
        m_axi_gmem_ARID : OUT STD_LOGIC_VECTOR (0 downto 0);
        m_axi_gmem_ARLEN : OUT STD_LOGIC_VECTOR (31 downto 0);
        m_axi_gmem_ARSIZE : OUT STD_LOGIC_VECTOR (2 downto 0);
        m_axi_gmem_ARBURST : OUT STD_LOGIC_VECTOR (1 downto 0);
        m_axi_gmem_ARLOCK : OUT STD_LOGIC_VECTOR (1 downto 0);
        m_axi_gmem_ARCACHE : OUT STD_LOGIC_VECTOR (3 downto 0);
        m_axi_gmem_ARPROT : OUT STD_LOGIC_VECTOR (2 downto 0);
        m_axi_gmem_ARQOS : OUT STD_LOGIC_VECTOR (3 downto 0);
        m_axi_gmem_ARREGION : OUT STD_LOGIC_VECTOR (3 downto 0);
        m_axi_gmem_ARUSER : OUT STD_LOGIC_VECTOR (0 downto 0);
        m_axi_gmem_RVALID : IN STD_LOGIC;
        m_axi_gmem_RREADY : OUT STD_LOGIC;
        m_axi_gmem_RDATA : IN STD_LOGIC_VECTOR (31 downto 0);
        m_axi_gmem_RLAST : IN STD_LOGIC;
        m_axi_gmem_RID : IN STD_LOGIC_VECTOR (0 downto 0);
        m_axi_gmem_RFIFONUM : IN STD_LOGIC_VECTOR (8 downto 0);
        m_axi_gmem_RUSER : IN STD_LOGIC_VECTOR (0 downto 0);
        m_axi_gmem_RRESP : IN STD_LOGIC_VECTOR (1 downto 0);
        m_axi_gmem_BVALID : IN STD_LOGIC;
        m_axi_gmem_BREADY : OUT STD_LOGIC;
        m_axi_gmem_BRESP : IN STD_LOGIC_VECTOR (1 downto 0);
        m_axi_gmem_BID : IN STD_LOGIC_VECTOR (0 downto 0);
        m_axi_gmem_BUSER : IN STD_LOGIC_VECTOR (0 downto 0);
        pMemPort : IN STD_LOGIC_VECTOR (63 downto 0);
        p_read : IN STD_LOGIC_VECTOR (29 downto 0);
        row : IN STD_LOGIC_VECTOR (10 downto 0);
        p_read1 : IN STD_LOGIC_VECTOR (10 downto 0);
        cacheBuff_i_i_din : OUT STD_LOGIC_VECTOR (31 downto 0);
        cacheBuff_i_i_num_data_valid : IN STD_LOGIC_VECTOR (12 downto 0);
        cacheBuff_i_i_fifo_cap : IN STD_LOGIC_VECTOR (12 downto 0);
        cacheBuff_i_i_full_n : IN STD_LOGIC;
        cacheBuff_i_i_write : OUT STD_LOGIC;
        p_read2 : IN STD_LOGIC_VECTOR (7 downto 0) );
    end component;


    component mem2stream_dataflow_in_loop_VITIS_LOOP_38_1_1_Loop_VITIS_LOOP_43_2_proc5 IS
    port (
        ap_clk : IN STD_LOGIC;
        ap_rst : IN STD_LOGIC;
        ap_start : IN STD_LOGIC;
        ap_done : OUT STD_LOGIC;
        ap_continue : IN STD_LOGIC;
        ap_idle : OUT STD_LOGIC;
        ap_ready : OUT STD_LOGIC;
        p_read : IN STD_LOGIC_VECTOR (31 downto 0);
        cacheBuff_dout : IN STD_LOGIC_VECTOR (31 downto 0);
        cacheBuff_num_data_valid : IN STD_LOGIC_VECTOR (12 downto 0);
        cacheBuff_fifo_cap : IN STD_LOGIC_VECTOR (12 downto 0);
        cacheBuff_empty_n : IN STD_LOGIC;
        cacheBuff_read : OUT STD_LOGIC;
        img_data_din : OUT STD_LOGIC_VECTOR (23 downto 0);
        img_data_num_data_valid : IN STD_LOGIC_VECTOR (1 downto 0);
        img_data_fifo_cap : IN STD_LOGIC_VECTOR (1 downto 0);
        img_data_full_n : IN STD_LOGIC;
        img_data_write : OUT STD_LOGIC );
    end component;


    component mem2stream_fifo_w32_d3_S IS
    port (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        if_read_ce : IN STD_LOGIC;
        if_write_ce : IN STD_LOGIC;
        if_din : IN STD_LOGIC_VECTOR (31 downto 0);
        if_full_n : OUT STD_LOGIC;
        if_write : IN STD_LOGIC;
        if_dout : OUT STD_LOGIC_VECTOR (31 downto 0);
        if_num_data_valid : OUT STD_LOGIC_VECTOR (2 downto 0);
        if_fifo_cap : OUT STD_LOGIC_VECTOR (2 downto 0);
        if_empty_n : OUT STD_LOGIC;
        if_read : IN STD_LOGIC );
    end component;


    component mem2stream_fifo_w30_d2_S IS
    port (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        if_read_ce : IN STD_LOGIC;
        if_write_ce : IN STD_LOGIC;
        if_din : IN STD_LOGIC_VECTOR (29 downto 0);
        if_full_n : OUT STD_LOGIC;
        if_write : IN STD_LOGIC;
        if_dout : OUT STD_LOGIC_VECTOR (29 downto 0);
        if_num_data_valid : OUT STD_LOGIC_VECTOR (1 downto 0);
        if_fifo_cap : OUT STD_LOGIC_VECTOR (1 downto 0);
        if_empty_n : OUT STD_LOGIC;
        if_read : IN STD_LOGIC );
    end component;


    component mem2stream_fifo_w32_d3840_A IS
    port (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        if_read_ce : IN STD_LOGIC;
        if_write_ce : IN STD_LOGIC;
        if_din : IN STD_LOGIC_VECTOR (31 downto 0);
        if_full_n : OUT STD_LOGIC;
        if_write : IN STD_LOGIC;
        if_dout : OUT STD_LOGIC_VECTOR (31 downto 0);
        if_num_data_valid : OUT STD_LOGIC_VECTOR (12 downto 0);
        if_fifo_cap : OUT STD_LOGIC_VECTOR (12 downto 0);
        if_empty_n : OUT STD_LOGIC;
        if_read : IN STD_LOGIC );
    end component;



begin
    dataflow_in_loop_VITIS_LOOP_38_1_1_Block_newFuncRoot17_proc3_U0 : component mem2stream_dataflow_in_loop_VITIS_LOOP_38_1_1_Block_newFuncRoot17_proc3
    port map (
        ap_clk => ap_clk,
        ap_rst => ap_rst,
        ap_start => dataflow_in_loop_VITIS_LOOP_38_1_1_Block_newFuncRoot17_proc3_U0_ap_start,
        ap_done => dataflow_in_loop_VITIS_LOOP_38_1_1_Block_newFuncRoot17_proc3_U0_ap_done,
        ap_continue => dataflow_in_loop_VITIS_LOOP_38_1_1_Block_newFuncRoot17_proc3_U0_ap_continue,
        ap_idle => dataflow_in_loop_VITIS_LOOP_38_1_1_Block_newFuncRoot17_proc3_U0_ap_idle,
        ap_ready => dataflow_in_loop_VITIS_LOOP_38_1_1_Block_newFuncRoot17_proc3_U0_ap_ready,
        p_read => p_read1,
        baseAddr_address0 => dataflow_in_loop_VITIS_LOOP_38_1_1_Block_newFuncRoot17_proc3_U0_baseAddr_address0,
        baseAddr_ce0 => dataflow_in_loop_VITIS_LOOP_38_1_1_Block_newFuncRoot17_proc3_U0_baseAddr_ce0,
        baseAddr_q0 => baseAddr_q0,
        index => index,
        ap_return_0 => dataflow_in_loop_VITIS_LOOP_38_1_1_Block_newFuncRoot17_proc3_U0_ap_return_0,
        ap_return_1 => dataflow_in_loop_VITIS_LOOP_38_1_1_Block_newFuncRoot17_proc3_U0_ap_return_1);

    readmem4_U0 : component mem2stream_readmem4
    port map (
        ap_clk => ap_clk,
        ap_rst => ap_rst,
        ap_start => readmem4_U0_ap_start,
        ap_done => readmem4_U0_ap_done,
        ap_continue => readmem4_U0_ap_continue,
        ap_idle => readmem4_U0_ap_idle,
        ap_ready => readmem4_U0_ap_ready,
        m_axi_gmem_AWVALID => readmem4_U0_m_axi_gmem_AWVALID,
        m_axi_gmem_AWREADY => ap_const_logic_0,
        m_axi_gmem_AWADDR => readmem4_U0_m_axi_gmem_AWADDR,
        m_axi_gmem_AWID => readmem4_U0_m_axi_gmem_AWID,
        m_axi_gmem_AWLEN => readmem4_U0_m_axi_gmem_AWLEN,
        m_axi_gmem_AWSIZE => readmem4_U0_m_axi_gmem_AWSIZE,
        m_axi_gmem_AWBURST => readmem4_U0_m_axi_gmem_AWBURST,
        m_axi_gmem_AWLOCK => readmem4_U0_m_axi_gmem_AWLOCK,
        m_axi_gmem_AWCACHE => readmem4_U0_m_axi_gmem_AWCACHE,
        m_axi_gmem_AWPROT => readmem4_U0_m_axi_gmem_AWPROT,
        m_axi_gmem_AWQOS => readmem4_U0_m_axi_gmem_AWQOS,
        m_axi_gmem_AWREGION => readmem4_U0_m_axi_gmem_AWREGION,
        m_axi_gmem_AWUSER => readmem4_U0_m_axi_gmem_AWUSER,
        m_axi_gmem_WVALID => readmem4_U0_m_axi_gmem_WVALID,
        m_axi_gmem_WREADY => ap_const_logic_0,
        m_axi_gmem_WDATA => readmem4_U0_m_axi_gmem_WDATA,
        m_axi_gmem_WSTRB => readmem4_U0_m_axi_gmem_WSTRB,
        m_axi_gmem_WLAST => readmem4_U0_m_axi_gmem_WLAST,
        m_axi_gmem_WID => readmem4_U0_m_axi_gmem_WID,
        m_axi_gmem_WUSER => readmem4_U0_m_axi_gmem_WUSER,
        m_axi_gmem_ARVALID => readmem4_U0_m_axi_gmem_ARVALID,
        m_axi_gmem_ARREADY => m_axi_gmem_ARREADY,
        m_axi_gmem_ARADDR => readmem4_U0_m_axi_gmem_ARADDR,
        m_axi_gmem_ARID => readmem4_U0_m_axi_gmem_ARID,
        m_axi_gmem_ARLEN => readmem4_U0_m_axi_gmem_ARLEN,
        m_axi_gmem_ARSIZE => readmem4_U0_m_axi_gmem_ARSIZE,
        m_axi_gmem_ARBURST => readmem4_U0_m_axi_gmem_ARBURST,
        m_axi_gmem_ARLOCK => readmem4_U0_m_axi_gmem_ARLOCK,
        m_axi_gmem_ARCACHE => readmem4_U0_m_axi_gmem_ARCACHE,
        m_axi_gmem_ARPROT => readmem4_U0_m_axi_gmem_ARPROT,
        m_axi_gmem_ARQOS => readmem4_U0_m_axi_gmem_ARQOS,
        m_axi_gmem_ARREGION => readmem4_U0_m_axi_gmem_ARREGION,
        m_axi_gmem_ARUSER => readmem4_U0_m_axi_gmem_ARUSER,
        m_axi_gmem_RVALID => m_axi_gmem_RVALID,
        m_axi_gmem_RREADY => readmem4_U0_m_axi_gmem_RREADY,
        m_axi_gmem_RDATA => m_axi_gmem_RDATA,
        m_axi_gmem_RLAST => m_axi_gmem_RLAST,
        m_axi_gmem_RID => m_axi_gmem_RID,
        m_axi_gmem_RFIFONUM => m_axi_gmem_RFIFONUM,
        m_axi_gmem_RUSER => m_axi_gmem_RUSER,
        m_axi_gmem_RRESP => m_axi_gmem_RRESP,
        m_axi_gmem_BVALID => ap_const_logic_0,
        m_axi_gmem_BREADY => readmem4_U0_m_axi_gmem_BREADY,
        m_axi_gmem_BRESP => ap_const_lv2_0,
        m_axi_gmem_BID => ap_const_lv1_0,
        m_axi_gmem_BUSER => ap_const_lv1_0,
        pMemPort => pMemPort,
        p_read => trunc_ln42_loc_i_i_channel_dout,
        row => row,
        p_read1 => p_read,
        cacheBuff_i_i_din => readmem4_U0_cacheBuff_i_i_din,
        cacheBuff_i_i_num_data_valid => cacheBuff_num_data_valid,
        cacheBuff_i_i_fifo_cap => cacheBuff_fifo_cap,
        cacheBuff_i_i_full_n => cacheBuff_full_n,
        cacheBuff_i_i_write => readmem4_U0_cacheBuff_i_i_write,
        p_read2 => p_read1);

    dataflow_in_loop_VITIS_LOOP_38_1_1_Loop_VITIS_LOOP_43_2_proc5_U0 : component mem2stream_dataflow_in_loop_VITIS_LOOP_38_1_1_Loop_VITIS_LOOP_43_2_proc5
    port map (
        ap_clk => ap_clk,
        ap_rst => ap_rst,
        ap_start => dataflow_in_loop_VITIS_LOOP_38_1_1_Loop_VITIS_LOOP_43_2_proc5_U0_ap_start,
        ap_done => dataflow_in_loop_VITIS_LOOP_38_1_1_Loop_VITIS_LOOP_43_2_proc5_U0_ap_done,
        ap_continue => dataflow_in_loop_VITIS_LOOP_38_1_1_Loop_VITIS_LOOP_43_2_proc5_U0_ap_continue,
        ap_idle => dataflow_in_loop_VITIS_LOOP_38_1_1_Loop_VITIS_LOOP_43_2_proc5_U0_ap_idle,
        ap_ready => dataflow_in_loop_VITIS_LOOP_38_1_1_Loop_VITIS_LOOP_43_2_proc5_U0_ap_ready,
        p_read => p_cast16_loc_i_i_channel_dout,
        cacheBuff_dout => cacheBuff_dout,
        cacheBuff_num_data_valid => cacheBuff_num_data_valid,
        cacheBuff_fifo_cap => cacheBuff_fifo_cap,
        cacheBuff_empty_n => cacheBuff_empty_n,
        cacheBuff_read => dataflow_in_loop_VITIS_LOOP_38_1_1_Loop_VITIS_LOOP_43_2_proc5_U0_cacheBuff_read,
        img_data_din => dataflow_in_loop_VITIS_LOOP_38_1_1_Loop_VITIS_LOOP_43_2_proc5_U0_img_data_din,
        img_data_num_data_valid => ap_const_lv2_0,
        img_data_fifo_cap => ap_const_lv2_0,
        img_data_full_n => img_data_full_n,
        img_data_write => dataflow_in_loop_VITIS_LOOP_38_1_1_Loop_VITIS_LOOP_43_2_proc5_U0_img_data_write);

    p_cast16_loc_i_i_channel_U : component mem2stream_fifo_w32_d3_S
    port map (
        clk => ap_clk,
        reset => ap_rst,
        if_read_ce => ap_const_logic_1,
        if_write_ce => ap_const_logic_1,
        if_din => dataflow_in_loop_VITIS_LOOP_38_1_1_Block_newFuncRoot17_proc3_U0_ap_return_0,
        if_full_n => p_cast16_loc_i_i_channel_full_n,
        if_write => ap_channel_done_p_cast16_loc_i_i_channel,
        if_dout => p_cast16_loc_i_i_channel_dout,
        if_num_data_valid => p_cast16_loc_i_i_channel_num_data_valid,
        if_fifo_cap => p_cast16_loc_i_i_channel_fifo_cap,
        if_empty_n => p_cast16_loc_i_i_channel_empty_n,
        if_read => dataflow_in_loop_VITIS_LOOP_38_1_1_Loop_VITIS_LOOP_43_2_proc5_U0_ap_ready);

    trunc_ln42_loc_i_i_channel_U : component mem2stream_fifo_w30_d2_S
    port map (
        clk => ap_clk,
        reset => ap_rst,
        if_read_ce => ap_const_logic_1,
        if_write_ce => ap_const_logic_1,
        if_din => dataflow_in_loop_VITIS_LOOP_38_1_1_Block_newFuncRoot17_proc3_U0_ap_return_1,
        if_full_n => trunc_ln42_loc_i_i_channel_full_n,
        if_write => ap_channel_done_trunc_ln42_loc_i_i_channel,
        if_dout => trunc_ln42_loc_i_i_channel_dout,
        if_num_data_valid => trunc_ln42_loc_i_i_channel_num_data_valid,
        if_fifo_cap => trunc_ln42_loc_i_i_channel_fifo_cap,
        if_empty_n => trunc_ln42_loc_i_i_channel_empty_n,
        if_read => readmem4_U0_ap_ready);

    cacheBuff_U : component mem2stream_fifo_w32_d3840_A
    port map (
        clk => ap_clk,
        reset => ap_rst,
        if_read_ce => ap_const_logic_1,
        if_write_ce => ap_const_logic_1,
        if_din => readmem4_U0_cacheBuff_i_i_din,
        if_full_n => cacheBuff_full_n,
        if_write => readmem4_U0_cacheBuff_i_i_write,
        if_dout => cacheBuff_dout,
        if_num_data_valid => cacheBuff_num_data_valid,
        if_fifo_cap => cacheBuff_fifo_cap,
        if_empty_n => cacheBuff_empty_n,
        if_read => dataflow_in_loop_VITIS_LOOP_38_1_1_Loop_VITIS_LOOP_43_2_proc5_U0_cacheBuff_read);





    ap_sync_reg_channel_write_p_cast16_loc_i_i_channel_assign_proc : process(ap_clk)
    begin
        if (ap_clk'event and ap_clk =  '1') then
            if (ap_rst = '1') then
                ap_sync_reg_channel_write_p_cast16_loc_i_i_channel <= ap_const_logic_0;
            else
                if (((dataflow_in_loop_VITIS_LOOP_38_1_1_Block_newFuncRoot17_proc3_U0_ap_done and dataflow_in_loop_VITIS_LOOP_38_1_1_Block_newFuncRoot17_proc3_U0_ap_continue) = ap_const_logic_1)) then 
                    ap_sync_reg_channel_write_p_cast16_loc_i_i_channel <= ap_const_logic_0;
                else 
                    ap_sync_reg_channel_write_p_cast16_loc_i_i_channel <= ap_sync_channel_write_p_cast16_loc_i_i_channel;
                end if; 
            end if;
        end if;
    end process;


    ap_sync_reg_channel_write_trunc_ln42_loc_i_i_channel_assign_proc : process(ap_clk)
    begin
        if (ap_clk'event and ap_clk =  '1') then
            if (ap_rst = '1') then
                ap_sync_reg_channel_write_trunc_ln42_loc_i_i_channel <= ap_const_logic_0;
            else
                if (((dataflow_in_loop_VITIS_LOOP_38_1_1_Block_newFuncRoot17_proc3_U0_ap_done and dataflow_in_loop_VITIS_LOOP_38_1_1_Block_newFuncRoot17_proc3_U0_ap_continue) = ap_const_logic_1)) then 
                    ap_sync_reg_channel_write_trunc_ln42_loc_i_i_channel <= ap_const_logic_0;
                else 
                    ap_sync_reg_channel_write_trunc_ln42_loc_i_i_channel <= ap_sync_channel_write_trunc_ln42_loc_i_i_channel;
                end if; 
            end if;
        end if;
    end process;


    ap_sync_reg_dataflow_in_loop_VITIS_LOOP_38_1_1_Block_newFuncRoot17_proc3_U0_ap_ready_assign_proc : process(ap_clk)
    begin
        if (ap_clk'event and ap_clk =  '1') then
            if (ap_rst = '1') then
                ap_sync_reg_dataflow_in_loop_VITIS_LOOP_38_1_1_Block_newFuncRoot17_proc3_U0_ap_ready <= ap_const_logic_0;
            else
                if (((ap_sync_ready and ap_start) = ap_const_logic_1)) then 
                    ap_sync_reg_dataflow_in_loop_VITIS_LOOP_38_1_1_Block_newFuncRoot17_proc3_U0_ap_ready <= ap_const_logic_0;
                else 
                    ap_sync_reg_dataflow_in_loop_VITIS_LOOP_38_1_1_Block_newFuncRoot17_proc3_U0_ap_ready <= ap_sync_dataflow_in_loop_VITIS_LOOP_38_1_1_Block_newFuncRoot17_proc3_U0_ap_ready;
                end if; 
            end if;
        end if;
    end process;


    ap_sync_reg_readmem4_U0_ap_ready_assign_proc : process(ap_clk)
    begin
        if (ap_clk'event and ap_clk =  '1') then
            if (ap_rst = '1') then
                ap_sync_reg_readmem4_U0_ap_ready <= ap_const_logic_0;
            else
                if (((ap_sync_ready and ap_start) = ap_const_logic_1)) then 
                    ap_sync_reg_readmem4_U0_ap_ready <= ap_const_logic_0;
                else 
                    ap_sync_reg_readmem4_U0_ap_ready <= ap_sync_readmem4_U0_ap_ready;
                end if; 
            end if;
        end if;
    end process;

    ap_channel_done_p_cast16_loc_i_i_channel <= ((ap_sync_reg_channel_write_p_cast16_loc_i_i_channel xor ap_const_logic_1) and dataflow_in_loop_VITIS_LOOP_38_1_1_Block_newFuncRoot17_proc3_U0_ap_done);
    ap_channel_done_trunc_ln42_loc_i_i_channel <= ((ap_sync_reg_channel_write_trunc_ln42_loc_i_i_channel xor ap_const_logic_1) and dataflow_in_loop_VITIS_LOOP_38_1_1_Block_newFuncRoot17_proc3_U0_ap_done);
    ap_done <= dataflow_in_loop_VITIS_LOOP_38_1_1_Loop_VITIS_LOOP_43_2_proc5_U0_ap_done;
    ap_idle <= (readmem4_U0_ap_idle and (trunc_ln42_loc_i_i_channel_empty_n xor ap_const_logic_1) and (p_cast16_loc_i_i_channel_empty_n xor ap_const_logic_1) and dataflow_in_loop_VITIS_LOOP_38_1_1_Loop_VITIS_LOOP_43_2_proc5_U0_ap_idle and dataflow_in_loop_VITIS_LOOP_38_1_1_Block_newFuncRoot17_proc3_U0_ap_idle);
    ap_ready <= ap_sync_ready;
    ap_sync_channel_write_p_cast16_loc_i_i_channel <= ((p_cast16_loc_i_i_channel_full_n and ap_channel_done_p_cast16_loc_i_i_channel) or ap_sync_reg_channel_write_p_cast16_loc_i_i_channel);
    ap_sync_channel_write_trunc_ln42_loc_i_i_channel <= ((trunc_ln42_loc_i_i_channel_full_n and ap_channel_done_trunc_ln42_loc_i_i_channel) or ap_sync_reg_channel_write_trunc_ln42_loc_i_i_channel);
    ap_sync_dataflow_in_loop_VITIS_LOOP_38_1_1_Block_newFuncRoot17_proc3_U0_ap_ready <= (dataflow_in_loop_VITIS_LOOP_38_1_1_Block_newFuncRoot17_proc3_U0_ap_ready or ap_sync_reg_dataflow_in_loop_VITIS_LOOP_38_1_1_Block_newFuncRoot17_proc3_U0_ap_ready);
    ap_sync_readmem4_U0_ap_ready <= (readmem4_U0_ap_ready or ap_sync_reg_readmem4_U0_ap_ready);
    ap_sync_ready <= (ap_sync_readmem4_U0_ap_ready and ap_sync_dataflow_in_loop_VITIS_LOOP_38_1_1_Block_newFuncRoot17_proc3_U0_ap_ready);
    baseAddr_address0 <= dataflow_in_loop_VITIS_LOOP_38_1_1_Block_newFuncRoot17_proc3_U0_baseAddr_address0;
    baseAddr_ce0 <= dataflow_in_loop_VITIS_LOOP_38_1_1_Block_newFuncRoot17_proc3_U0_baseAddr_ce0;
    baseAddr_d0 <= ap_const_lv32_0;
    baseAddr_we0 <= ap_const_logic_0;
    dataflow_in_loop_VITIS_LOOP_38_1_1_Block_newFuncRoot17_proc3_U0_ap_continue <= (ap_sync_channel_write_trunc_ln42_loc_i_i_channel and ap_sync_channel_write_p_cast16_loc_i_i_channel);
    dataflow_in_loop_VITIS_LOOP_38_1_1_Block_newFuncRoot17_proc3_U0_ap_start <= ((ap_sync_reg_dataflow_in_loop_VITIS_LOOP_38_1_1_Block_newFuncRoot17_proc3_U0_ap_ready xor ap_const_logic_1) and ap_start);
    dataflow_in_loop_VITIS_LOOP_38_1_1_Loop_VITIS_LOOP_43_2_proc5_U0_ap_continue <= ap_continue;
    dataflow_in_loop_VITIS_LOOP_38_1_1_Loop_VITIS_LOOP_43_2_proc5_U0_ap_start <= p_cast16_loc_i_i_channel_empty_n;
    img_data_din <= dataflow_in_loop_VITIS_LOOP_38_1_1_Loop_VITIS_LOOP_43_2_proc5_U0_img_data_din;
    img_data_write <= dataflow_in_loop_VITIS_LOOP_38_1_1_Loop_VITIS_LOOP_43_2_proc5_U0_img_data_write;
    m_axi_gmem_ARADDR <= readmem4_U0_m_axi_gmem_ARADDR;
    m_axi_gmem_ARBURST <= readmem4_U0_m_axi_gmem_ARBURST;
    m_axi_gmem_ARCACHE <= readmem4_U0_m_axi_gmem_ARCACHE;
    m_axi_gmem_ARID <= readmem4_U0_m_axi_gmem_ARID;
    m_axi_gmem_ARLEN <= readmem4_U0_m_axi_gmem_ARLEN;
    m_axi_gmem_ARLOCK <= readmem4_U0_m_axi_gmem_ARLOCK;
    m_axi_gmem_ARPROT <= readmem4_U0_m_axi_gmem_ARPROT;
    m_axi_gmem_ARQOS <= readmem4_U0_m_axi_gmem_ARQOS;
    m_axi_gmem_ARREGION <= readmem4_U0_m_axi_gmem_ARREGION;
    m_axi_gmem_ARSIZE <= readmem4_U0_m_axi_gmem_ARSIZE;
    m_axi_gmem_ARUSER <= readmem4_U0_m_axi_gmem_ARUSER;
    m_axi_gmem_ARVALID <= readmem4_U0_m_axi_gmem_ARVALID;
    m_axi_gmem_AWADDR <= ap_const_lv64_0;
    m_axi_gmem_AWBURST <= ap_const_lv2_0;
    m_axi_gmem_AWCACHE <= ap_const_lv4_0;
    m_axi_gmem_AWID <= ap_const_lv1_0;
    m_axi_gmem_AWLEN <= ap_const_lv32_0;
    m_axi_gmem_AWLOCK <= ap_const_lv2_0;
    m_axi_gmem_AWPROT <= ap_const_lv3_0;
    m_axi_gmem_AWQOS <= ap_const_lv4_0;
    m_axi_gmem_AWREGION <= ap_const_lv4_0;
    m_axi_gmem_AWSIZE <= ap_const_lv3_0;
    m_axi_gmem_AWUSER <= ap_const_lv1_0;
    m_axi_gmem_AWVALID <= ap_const_logic_0;
    m_axi_gmem_BREADY <= ap_const_logic_0;
    m_axi_gmem_RREADY <= readmem4_U0_m_axi_gmem_RREADY;
    m_axi_gmem_WDATA <= ap_const_lv32_0;
    m_axi_gmem_WID <= ap_const_lv1_0;
    m_axi_gmem_WLAST <= ap_const_logic_0;
    m_axi_gmem_WSTRB <= ap_const_lv4_0;
    m_axi_gmem_WUSER <= ap_const_lv1_0;
    m_axi_gmem_WVALID <= ap_const_logic_0;
    readmem4_U0_ap_continue <= ap_const_logic_1;
    readmem4_U0_ap_start <= (trunc_ln42_loc_i_i_channel_empty_n and (ap_sync_reg_readmem4_U0_ap_ready xor ap_const_logic_1) and ap_start);
end behav;
