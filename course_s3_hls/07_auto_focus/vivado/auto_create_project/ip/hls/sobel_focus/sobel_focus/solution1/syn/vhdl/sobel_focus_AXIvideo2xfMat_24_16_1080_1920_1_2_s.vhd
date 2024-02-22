-- ==============================================================
-- Generated by Vitis HLS v2023.1
-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
-- ==============================================================

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity sobel_focus_AXIvideo2xfMat_24_16_1080_1920_1_2_s is
port (
    ap_clk : IN STD_LOGIC;
    ap_rst : IN STD_LOGIC;
    ap_start : IN STD_LOGIC;
    start_full_n : IN STD_LOGIC;
    ap_done : OUT STD_LOGIC;
    ap_continue : IN STD_LOGIC;
    ap_idle : OUT STD_LOGIC;
    ap_ready : OUT STD_LOGIC;
    start_out : OUT STD_LOGIC;
    start_write : OUT STD_LOGIC;
    src_TDATA : IN STD_LOGIC_VECTOR (23 downto 0);
    src_TVALID : IN STD_LOGIC;
    src_TREADY : OUT STD_LOGIC;
    src_TKEEP : IN STD_LOGIC_VECTOR (2 downto 0);
    src_TSTRB : IN STD_LOGIC_VECTOR (2 downto 0);
    src_TUSER : IN STD_LOGIC_VECTOR (0 downto 0);
    src_TLAST : IN STD_LOGIC_VECTOR (0 downto 0);
    src_TID : IN STD_LOGIC_VECTOR (0 downto 0);
    src_TDEST : IN STD_LOGIC_VECTOR (0 downto 0);
    srcImg_data_din : OUT STD_LOGIC_VECTOR (23 downto 0);
    srcImg_data_num_data_valid : IN STD_LOGIC_VECTOR (1 downto 0);
    srcImg_data_fifo_cap : IN STD_LOGIC_VECTOR (1 downto 0);
    srcImg_data_full_n : IN STD_LOGIC;
    srcImg_data_write : OUT STD_LOGIC );
end;


architecture behav of sobel_focus_AXIvideo2xfMat_24_16_1080_1920_1_2_s is 
    constant ap_const_logic_1 : STD_LOGIC := '1';
    constant ap_const_logic_0 : STD_LOGIC := '0';
    constant ap_ST_fsm_state1 : STD_LOGIC_VECTOR (8 downto 0) := "000000001";
    constant ap_ST_fsm_state2 : STD_LOGIC_VECTOR (8 downto 0) := "000000010";
    constant ap_ST_fsm_state3 : STD_LOGIC_VECTOR (8 downto 0) := "000000100";
    constant ap_ST_fsm_state4 : STD_LOGIC_VECTOR (8 downto 0) := "000001000";
    constant ap_ST_fsm_state5 : STD_LOGIC_VECTOR (8 downto 0) := "000010000";
    constant ap_ST_fsm_state6 : STD_LOGIC_VECTOR (8 downto 0) := "000100000";
    constant ap_ST_fsm_state7 : STD_LOGIC_VECTOR (8 downto 0) := "001000000";
    constant ap_ST_fsm_state8 : STD_LOGIC_VECTOR (8 downto 0) := "010000000";
    constant ap_ST_fsm_state9 : STD_LOGIC_VECTOR (8 downto 0) := "100000000";
    constant ap_const_boolean_1 : BOOLEAN := true;
    constant ap_const_lv32_0 : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000000";
    constant ap_const_lv1_0 : STD_LOGIC_VECTOR (0 downto 0) := "0";
    constant ap_const_lv32_8 : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000001000";
    constant ap_const_lv1_1 : STD_LOGIC_VECTOR (0 downto 0) := "1";
    constant ap_const_lv32_3 : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000011";
    constant ap_const_lv32_1 : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000001";
    constant ap_const_lv32_2 : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000010";
    constant ap_const_lv32_4 : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000100";
    constant ap_const_lv32_5 : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000101";
    constant ap_const_lv32_7 : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000111";
    constant ap_const_lv11_0 : STD_LOGIC_VECTOR (10 downto 0) := "00000000000";
    constant ap_const_lv11_438 : STD_LOGIC_VECTOR (10 downto 0) := "10000111000";
    constant ap_const_lv11_1 : STD_LOGIC_VECTOR (10 downto 0) := "00000000001";
    constant ap_const_lv2_0 : STD_LOGIC_VECTOR (1 downto 0) := "00";

attribute shreg_extract : string;
    signal real_start : STD_LOGIC;
    signal start_once_reg : STD_LOGIC := '0';
    signal ap_done_reg : STD_LOGIC := '0';
    signal ap_CS_fsm : STD_LOGIC_VECTOR (8 downto 0) := "000000001";
    attribute fsm_encoding : string;
    attribute fsm_encoding of ap_CS_fsm : signal is "none";
    signal ap_CS_fsm_state1 : STD_LOGIC;
    attribute fsm_encoding of ap_CS_fsm_state1 : signal is "none";
    signal internal_ap_ready : STD_LOGIC;
    signal grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_start_hunt_fu_110_ap_start : STD_LOGIC;
    signal grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_start_hunt_fu_110_ap_done : STD_LOGIC;
    signal grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_start_hunt_fu_110_ap_idle : STD_LOGIC;
    signal grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_start_hunt_fu_110_ap_ready : STD_LOGIC;
    signal grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_start_hunt_fu_110_src_TREADY : STD_LOGIC;
    signal grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_start_hunt_fu_110_axi_last_out : STD_LOGIC_VECTOR (0 downto 0);
    signal grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_start_hunt_fu_110_axi_last_out_ap_vld : STD_LOGIC;
    signal grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_start_hunt_fu_110_axi_data_out : STD_LOGIC_VECTOR (23 downto 0);
    signal grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_start_hunt_fu_110_axi_data_out_ap_vld : STD_LOGIC;
    signal grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_col_zxi2mat_fu_130_ap_start : STD_LOGIC;
    signal grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_col_zxi2mat_fu_130_ap_done : STD_LOGIC;
    signal grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_col_zxi2mat_fu_130_ap_idle : STD_LOGIC;
    signal grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_col_zxi2mat_fu_130_ap_ready : STD_LOGIC;
    signal grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_col_zxi2mat_fu_130_srcImg_data_din : STD_LOGIC_VECTOR (23 downto 0);
    signal grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_col_zxi2mat_fu_130_srcImg_data_write : STD_LOGIC;
    signal grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_col_zxi2mat_fu_130_src_TREADY : STD_LOGIC;
    signal grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_col_zxi2mat_fu_130_last_out : STD_LOGIC_VECTOR (0 downto 0);
    signal grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_col_zxi2mat_fu_130_last_out_ap_vld : STD_LOGIC;
    signal grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_col_zxi2mat_fu_130_axi_data_5_out : STD_LOGIC_VECTOR (23 downto 0);
    signal grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_col_zxi2mat_fu_130_axi_data_5_out_ap_vld : STD_LOGIC;
    signal grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_last_hunt_fu_157_ap_start : STD_LOGIC;
    signal grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_last_hunt_fu_157_ap_done : STD_LOGIC;
    signal grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_last_hunt_fu_157_ap_idle : STD_LOGIC;
    signal grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_last_hunt_fu_157_ap_ready : STD_LOGIC;
    signal grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_last_hunt_fu_157_src_TREADY : STD_LOGIC;
    signal grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_last_hunt_fu_157_axi_data_4_out : STD_LOGIC_VECTOR (23 downto 0);
    signal grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_last_hunt_fu_157_axi_data_4_out_ap_vld : STD_LOGIC;
    signal start_reg_84 : STD_LOGIC_VECTOR (0 downto 0);
    signal ap_CS_fsm_state9 : STD_LOGIC;
    attribute fsm_encoding of ap_CS_fsm_state9 : signal is "none";
    signal ap_CS_fsm_state4 : STD_LOGIC;
    attribute fsm_encoding of ap_CS_fsm_state4 : signal is "none";
    signal axi_last_2_reg_98 : STD_LOGIC_VECTOR (0 downto 0);
    signal grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_start_hunt_fu_110_ap_start_reg : STD_LOGIC := '0';
    signal ap_CS_fsm_state2 : STD_LOGIC;
    attribute fsm_encoding of ap_CS_fsm_state2 : signal is "none";
    signal ap_CS_fsm_state3 : STD_LOGIC;
    attribute fsm_encoding of ap_CS_fsm_state3 : signal is "none";
    signal axi_data_2_fu_64 : STD_LOGIC_VECTOR (23 downto 0);
    signal grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_col_zxi2mat_fu_130_ap_start_reg : STD_LOGIC := '0';
    signal ap_CS_fsm_state5 : STD_LOGIC;
    attribute fsm_encoding of ap_CS_fsm_state5 : signal is "none";
    signal icmp_ln129_fu_189_p2 : STD_LOGIC_VECTOR (0 downto 0);
    signal ap_CS_fsm_state6 : STD_LOGIC;
    attribute fsm_encoding of ap_CS_fsm_state6 : signal is "none";
    signal grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_last_hunt_fu_157_ap_start_reg : STD_LOGIC := '0';
    signal ap_CS_fsm_state8 : STD_LOGIC;
    attribute fsm_encoding of ap_CS_fsm_state8 : signal is "none";
    signal i_fu_68 : STD_LOGIC_VECTOR (10 downto 0);
    signal i_4_fu_195_p2 : STD_LOGIC_VECTOR (10 downto 0);
    signal ap_block_state1 : BOOLEAN;
    signal ap_NS_fsm : STD_LOGIC_VECTOR (8 downto 0);
    signal ap_ST_fsm_state1_blk : STD_LOGIC;
    signal ap_ST_fsm_state2_blk : STD_LOGIC;
    signal ap_ST_fsm_state3_blk : STD_LOGIC;
    signal ap_ST_fsm_state4_blk : STD_LOGIC;
    signal ap_ST_fsm_state5_blk : STD_LOGIC;
    signal ap_ST_fsm_state6_blk : STD_LOGIC;
    signal ap_ST_fsm_state7_blk : STD_LOGIC;
    signal ap_ST_fsm_state8_blk : STD_LOGIC;
    signal ap_ST_fsm_state9_blk : STD_LOGIC;
    signal regslice_both_src_V_data_V_U_apdone_blk : STD_LOGIC;
    signal src_TDATA_int_regslice : STD_LOGIC_VECTOR (23 downto 0);
    signal src_TVALID_int_regslice : STD_LOGIC;
    signal src_TREADY_int_regslice : STD_LOGIC;
    signal regslice_both_src_V_data_V_U_ack_in : STD_LOGIC;
    signal regslice_both_src_V_keep_V_U_apdone_blk : STD_LOGIC;
    signal src_TKEEP_int_regslice : STD_LOGIC_VECTOR (2 downto 0);
    signal regslice_both_src_V_keep_V_U_vld_out : STD_LOGIC;
    signal regslice_both_src_V_keep_V_U_ack_in : STD_LOGIC;
    signal regslice_both_src_V_strb_V_U_apdone_blk : STD_LOGIC;
    signal src_TSTRB_int_regslice : STD_LOGIC_VECTOR (2 downto 0);
    signal regslice_both_src_V_strb_V_U_vld_out : STD_LOGIC;
    signal regslice_both_src_V_strb_V_U_ack_in : STD_LOGIC;
    signal regslice_both_src_V_user_V_U_apdone_blk : STD_LOGIC;
    signal src_TUSER_int_regslice : STD_LOGIC_VECTOR (0 downto 0);
    signal regslice_both_src_V_user_V_U_vld_out : STD_LOGIC;
    signal regslice_both_src_V_user_V_U_ack_in : STD_LOGIC;
    signal regslice_both_src_V_last_V_U_apdone_blk : STD_LOGIC;
    signal src_TLAST_int_regslice : STD_LOGIC_VECTOR (0 downto 0);
    signal regslice_both_src_V_last_V_U_vld_out : STD_LOGIC;
    signal regslice_both_src_V_last_V_U_ack_in : STD_LOGIC;
    signal regslice_both_src_V_id_V_U_apdone_blk : STD_LOGIC;
    signal src_TID_int_regslice : STD_LOGIC_VECTOR (0 downto 0);
    signal regslice_both_src_V_id_V_U_vld_out : STD_LOGIC;
    signal regslice_both_src_V_id_V_U_ack_in : STD_LOGIC;
    signal regslice_both_src_V_dest_V_U_apdone_blk : STD_LOGIC;
    signal src_TDEST_int_regslice : STD_LOGIC_VECTOR (0 downto 0);
    signal regslice_both_src_V_dest_V_U_vld_out : STD_LOGIC;
    signal regslice_both_src_V_dest_V_U_ack_in : STD_LOGIC;
    signal ap_ce_reg : STD_LOGIC;

    component sobel_focus_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_start_hunt IS
    port (
        ap_clk : IN STD_LOGIC;
        ap_rst : IN STD_LOGIC;
        ap_start : IN STD_LOGIC;
        ap_done : OUT STD_LOGIC;
        ap_idle : OUT STD_LOGIC;
        ap_ready : OUT STD_LOGIC;
        src_TVALID : IN STD_LOGIC;
        src_TDATA : IN STD_LOGIC_VECTOR (23 downto 0);
        src_TREADY : OUT STD_LOGIC;
        src_TKEEP : IN STD_LOGIC_VECTOR (2 downto 0);
        src_TSTRB : IN STD_LOGIC_VECTOR (2 downto 0);
        src_TUSER : IN STD_LOGIC_VECTOR (0 downto 0);
        src_TLAST : IN STD_LOGIC_VECTOR (0 downto 0);
        src_TID : IN STD_LOGIC_VECTOR (0 downto 0);
        src_TDEST : IN STD_LOGIC_VECTOR (0 downto 0);
        axi_last_out : OUT STD_LOGIC_VECTOR (0 downto 0);
        axi_last_out_ap_vld : OUT STD_LOGIC;
        axi_data_out : OUT STD_LOGIC_VECTOR (23 downto 0);
        axi_data_out_ap_vld : OUT STD_LOGIC );
    end component;


    component sobel_focus_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_col_zxi2mat IS
    port (
        ap_clk : IN STD_LOGIC;
        ap_rst : IN STD_LOGIC;
        ap_start : IN STD_LOGIC;
        ap_done : OUT STD_LOGIC;
        ap_idle : OUT STD_LOGIC;
        ap_ready : OUT STD_LOGIC;
        src_TVALID : IN STD_LOGIC;
        srcImg_data_din : OUT STD_LOGIC_VECTOR (23 downto 0);
        srcImg_data_num_data_valid : IN STD_LOGIC_VECTOR (1 downto 0);
        srcImg_data_fifo_cap : IN STD_LOGIC_VECTOR (1 downto 0);
        srcImg_data_full_n : IN STD_LOGIC;
        srcImg_data_write : OUT STD_LOGIC;
        start_2 : IN STD_LOGIC_VECTOR (0 downto 0);
        axi_data_2 : IN STD_LOGIC_VECTOR (23 downto 0);
        axi_last_2 : IN STD_LOGIC_VECTOR (0 downto 0);
        src_TDATA : IN STD_LOGIC_VECTOR (23 downto 0);
        src_TREADY : OUT STD_LOGIC;
        src_TKEEP : IN STD_LOGIC_VECTOR (2 downto 0);
        src_TSTRB : IN STD_LOGIC_VECTOR (2 downto 0);
        src_TUSER : IN STD_LOGIC_VECTOR (0 downto 0);
        src_TLAST : IN STD_LOGIC_VECTOR (0 downto 0);
        src_TID : IN STD_LOGIC_VECTOR (0 downto 0);
        src_TDEST : IN STD_LOGIC_VECTOR (0 downto 0);
        last_out : OUT STD_LOGIC_VECTOR (0 downto 0);
        last_out_ap_vld : OUT STD_LOGIC;
        axi_data_5_out : OUT STD_LOGIC_VECTOR (23 downto 0);
        axi_data_5_out_ap_vld : OUT STD_LOGIC );
    end component;


    component sobel_focus_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_last_hunt IS
    port (
        ap_clk : IN STD_LOGIC;
        ap_rst : IN STD_LOGIC;
        ap_start : IN STD_LOGIC;
        ap_done : OUT STD_LOGIC;
        ap_idle : OUT STD_LOGIC;
        ap_ready : OUT STD_LOGIC;
        src_TVALID : IN STD_LOGIC;
        last_reload : IN STD_LOGIC_VECTOR (0 downto 0);
        axi_data_5_reload : IN STD_LOGIC_VECTOR (23 downto 0);
        src_TDATA : IN STD_LOGIC_VECTOR (23 downto 0);
        src_TREADY : OUT STD_LOGIC;
        src_TKEEP : IN STD_LOGIC_VECTOR (2 downto 0);
        src_TSTRB : IN STD_LOGIC_VECTOR (2 downto 0);
        src_TUSER : IN STD_LOGIC_VECTOR (0 downto 0);
        src_TLAST : IN STD_LOGIC_VECTOR (0 downto 0);
        src_TID : IN STD_LOGIC_VECTOR (0 downto 0);
        src_TDEST : IN STD_LOGIC_VECTOR (0 downto 0);
        axi_data_4_out : OUT STD_LOGIC_VECTOR (23 downto 0);
        axi_data_4_out_ap_vld : OUT STD_LOGIC );
    end component;


    component sobel_focus_regslice_both IS
    generic (
        DataWidth : INTEGER );
    port (
        ap_clk : IN STD_LOGIC;
        ap_rst : IN STD_LOGIC;
        data_in : IN STD_LOGIC_VECTOR (DataWidth-1 downto 0);
        vld_in : IN STD_LOGIC;
        ack_in : OUT STD_LOGIC;
        data_out : OUT STD_LOGIC_VECTOR (DataWidth-1 downto 0);
        vld_out : OUT STD_LOGIC;
        ack_out : IN STD_LOGIC;
        apdone_blk : OUT STD_LOGIC );
    end component;



begin
    grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_start_hunt_fu_110 : component sobel_focus_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_start_hunt
    port map (
        ap_clk => ap_clk,
        ap_rst => ap_rst,
        ap_start => grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_start_hunt_fu_110_ap_start,
        ap_done => grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_start_hunt_fu_110_ap_done,
        ap_idle => grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_start_hunt_fu_110_ap_idle,
        ap_ready => grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_start_hunt_fu_110_ap_ready,
        src_TVALID => src_TVALID_int_regslice,
        src_TDATA => src_TDATA_int_regslice,
        src_TREADY => grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_start_hunt_fu_110_src_TREADY,
        src_TKEEP => src_TKEEP_int_regslice,
        src_TSTRB => src_TSTRB_int_regslice,
        src_TUSER => src_TUSER_int_regslice,
        src_TLAST => src_TLAST_int_regslice,
        src_TID => src_TID_int_regslice,
        src_TDEST => src_TDEST_int_regslice,
        axi_last_out => grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_start_hunt_fu_110_axi_last_out,
        axi_last_out_ap_vld => grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_start_hunt_fu_110_axi_last_out_ap_vld,
        axi_data_out => grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_start_hunt_fu_110_axi_data_out,
        axi_data_out_ap_vld => grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_start_hunt_fu_110_axi_data_out_ap_vld);

    grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_col_zxi2mat_fu_130 : component sobel_focus_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_col_zxi2mat
    port map (
        ap_clk => ap_clk,
        ap_rst => ap_rst,
        ap_start => grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_col_zxi2mat_fu_130_ap_start,
        ap_done => grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_col_zxi2mat_fu_130_ap_done,
        ap_idle => grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_col_zxi2mat_fu_130_ap_idle,
        ap_ready => grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_col_zxi2mat_fu_130_ap_ready,
        src_TVALID => src_TVALID_int_regslice,
        srcImg_data_din => grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_col_zxi2mat_fu_130_srcImg_data_din,
        srcImg_data_num_data_valid => ap_const_lv2_0,
        srcImg_data_fifo_cap => ap_const_lv2_0,
        srcImg_data_full_n => srcImg_data_full_n,
        srcImg_data_write => grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_col_zxi2mat_fu_130_srcImg_data_write,
        start_2 => start_reg_84,
        axi_data_2 => axi_data_2_fu_64,
        axi_last_2 => axi_last_2_reg_98,
        src_TDATA => src_TDATA_int_regslice,
        src_TREADY => grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_col_zxi2mat_fu_130_src_TREADY,
        src_TKEEP => src_TKEEP_int_regslice,
        src_TSTRB => src_TSTRB_int_regslice,
        src_TUSER => src_TUSER_int_regslice,
        src_TLAST => src_TLAST_int_regslice,
        src_TID => src_TID_int_regslice,
        src_TDEST => src_TDEST_int_regslice,
        last_out => grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_col_zxi2mat_fu_130_last_out,
        last_out_ap_vld => grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_col_zxi2mat_fu_130_last_out_ap_vld,
        axi_data_5_out => grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_col_zxi2mat_fu_130_axi_data_5_out,
        axi_data_5_out_ap_vld => grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_col_zxi2mat_fu_130_axi_data_5_out_ap_vld);

    grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_last_hunt_fu_157 : component sobel_focus_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_last_hunt
    port map (
        ap_clk => ap_clk,
        ap_rst => ap_rst,
        ap_start => grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_last_hunt_fu_157_ap_start,
        ap_done => grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_last_hunt_fu_157_ap_done,
        ap_idle => grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_last_hunt_fu_157_ap_idle,
        ap_ready => grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_last_hunt_fu_157_ap_ready,
        src_TVALID => src_TVALID_int_regslice,
        last_reload => grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_col_zxi2mat_fu_130_last_out,
        axi_data_5_reload => grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_col_zxi2mat_fu_130_axi_data_5_out,
        src_TDATA => src_TDATA_int_regslice,
        src_TREADY => grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_last_hunt_fu_157_src_TREADY,
        src_TKEEP => src_TKEEP_int_regslice,
        src_TSTRB => src_TSTRB_int_regslice,
        src_TUSER => src_TUSER_int_regslice,
        src_TLAST => src_TLAST_int_regslice,
        src_TID => src_TID_int_regslice,
        src_TDEST => src_TDEST_int_regslice,
        axi_data_4_out => grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_last_hunt_fu_157_axi_data_4_out,
        axi_data_4_out_ap_vld => grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_last_hunt_fu_157_axi_data_4_out_ap_vld);

    regslice_both_src_V_data_V_U : component sobel_focus_regslice_both
    generic map (
        DataWidth => 24)
    port map (
        ap_clk => ap_clk,
        ap_rst => ap_rst,
        data_in => src_TDATA,
        vld_in => src_TVALID,
        ack_in => regslice_both_src_V_data_V_U_ack_in,
        data_out => src_TDATA_int_regslice,
        vld_out => src_TVALID_int_regslice,
        ack_out => src_TREADY_int_regslice,
        apdone_blk => regslice_both_src_V_data_V_U_apdone_blk);

    regslice_both_src_V_keep_V_U : component sobel_focus_regslice_both
    generic map (
        DataWidth => 3)
    port map (
        ap_clk => ap_clk,
        ap_rst => ap_rst,
        data_in => src_TKEEP,
        vld_in => src_TVALID,
        ack_in => regslice_both_src_V_keep_V_U_ack_in,
        data_out => src_TKEEP_int_regslice,
        vld_out => regslice_both_src_V_keep_V_U_vld_out,
        ack_out => src_TREADY_int_regslice,
        apdone_blk => regslice_both_src_V_keep_V_U_apdone_blk);

    regslice_both_src_V_strb_V_U : component sobel_focus_regslice_both
    generic map (
        DataWidth => 3)
    port map (
        ap_clk => ap_clk,
        ap_rst => ap_rst,
        data_in => src_TSTRB,
        vld_in => src_TVALID,
        ack_in => regslice_both_src_V_strb_V_U_ack_in,
        data_out => src_TSTRB_int_regslice,
        vld_out => regslice_both_src_V_strb_V_U_vld_out,
        ack_out => src_TREADY_int_regslice,
        apdone_blk => regslice_both_src_V_strb_V_U_apdone_blk);

    regslice_both_src_V_user_V_U : component sobel_focus_regslice_both
    generic map (
        DataWidth => 1)
    port map (
        ap_clk => ap_clk,
        ap_rst => ap_rst,
        data_in => src_TUSER,
        vld_in => src_TVALID,
        ack_in => regslice_both_src_V_user_V_U_ack_in,
        data_out => src_TUSER_int_regslice,
        vld_out => regslice_both_src_V_user_V_U_vld_out,
        ack_out => src_TREADY_int_regslice,
        apdone_blk => regslice_both_src_V_user_V_U_apdone_blk);

    regslice_both_src_V_last_V_U : component sobel_focus_regslice_both
    generic map (
        DataWidth => 1)
    port map (
        ap_clk => ap_clk,
        ap_rst => ap_rst,
        data_in => src_TLAST,
        vld_in => src_TVALID,
        ack_in => regslice_both_src_V_last_V_U_ack_in,
        data_out => src_TLAST_int_regslice,
        vld_out => regslice_both_src_V_last_V_U_vld_out,
        ack_out => src_TREADY_int_regslice,
        apdone_blk => regslice_both_src_V_last_V_U_apdone_blk);

    regslice_both_src_V_id_V_U : component sobel_focus_regslice_both
    generic map (
        DataWidth => 1)
    port map (
        ap_clk => ap_clk,
        ap_rst => ap_rst,
        data_in => src_TID,
        vld_in => src_TVALID,
        ack_in => regslice_both_src_V_id_V_U_ack_in,
        data_out => src_TID_int_regslice,
        vld_out => regslice_both_src_V_id_V_U_vld_out,
        ack_out => src_TREADY_int_regslice,
        apdone_blk => regslice_both_src_V_id_V_U_apdone_blk);

    regslice_both_src_V_dest_V_U : component sobel_focus_regslice_both
    generic map (
        DataWidth => 1)
    port map (
        ap_clk => ap_clk,
        ap_rst => ap_rst,
        data_in => src_TDEST,
        vld_in => src_TVALID,
        ack_in => regslice_both_src_V_dest_V_U_ack_in,
        data_out => src_TDEST_int_regslice,
        vld_out => regslice_both_src_V_dest_V_U_vld_out,
        ack_out => src_TREADY_int_regslice,
        apdone_blk => regslice_both_src_V_dest_V_U_apdone_blk);





    ap_CS_fsm_assign_proc : process(ap_clk)
    begin
        if (ap_clk'event and ap_clk =  '1') then
            if (ap_rst = '1') then
                ap_CS_fsm <= ap_ST_fsm_state1;
            else
                ap_CS_fsm <= ap_NS_fsm;
            end if;
        end if;
    end process;


    ap_done_reg_assign_proc : process(ap_clk)
    begin
        if (ap_clk'event and ap_clk =  '1') then
            if (ap_rst = '1') then
                ap_done_reg <= ap_const_logic_0;
            else
                if ((ap_continue = ap_const_logic_1)) then 
                    ap_done_reg <= ap_const_logic_0;
                elsif (((ap_const_logic_1 = ap_CS_fsm_state5) and (icmp_ln129_fu_189_p2 = ap_const_lv1_1))) then 
                    ap_done_reg <= ap_const_logic_1;
                end if; 
            end if;
        end if;
    end process;


    grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_col_zxi2mat_fu_130_ap_start_reg_assign_proc : process(ap_clk)
    begin
        if (ap_clk'event and ap_clk =  '1') then
            if (ap_rst = '1') then
                grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_col_zxi2mat_fu_130_ap_start_reg <= ap_const_logic_0;
            else
                if (((ap_const_logic_1 = ap_CS_fsm_state5) and (icmp_ln129_fu_189_p2 = ap_const_lv1_0))) then 
                    grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_col_zxi2mat_fu_130_ap_start_reg <= ap_const_logic_1;
                elsif ((grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_col_zxi2mat_fu_130_ap_ready = ap_const_logic_1)) then 
                    grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_col_zxi2mat_fu_130_ap_start_reg <= ap_const_logic_0;
                end if; 
            end if;
        end if;
    end process;


    grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_last_hunt_fu_157_ap_start_reg_assign_proc : process(ap_clk)
    begin
        if (ap_clk'event and ap_clk =  '1') then
            if (ap_rst = '1') then
                grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_last_hunt_fu_157_ap_start_reg <= ap_const_logic_0;
            else
                if ((ap_const_logic_1 = ap_CS_fsm_state8)) then 
                    grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_last_hunt_fu_157_ap_start_reg <= ap_const_logic_1;
                elsif ((grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_last_hunt_fu_157_ap_ready = ap_const_logic_1)) then 
                    grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_last_hunt_fu_157_ap_start_reg <= ap_const_logic_0;
                end if; 
            end if;
        end if;
    end process;


    grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_start_hunt_fu_110_ap_start_reg_assign_proc : process(ap_clk)
    begin
        if (ap_clk'event and ap_clk =  '1') then
            if (ap_rst = '1') then
                grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_start_hunt_fu_110_ap_start_reg <= ap_const_logic_0;
            else
                if ((ap_const_logic_1 = ap_CS_fsm_state2)) then 
                    grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_start_hunt_fu_110_ap_start_reg <= ap_const_logic_1;
                elsif ((grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_start_hunt_fu_110_ap_ready = ap_const_logic_1)) then 
                    grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_start_hunt_fu_110_ap_start_reg <= ap_const_logic_0;
                end if; 
            end if;
        end if;
    end process;


    start_once_reg_assign_proc : process(ap_clk)
    begin
        if (ap_clk'event and ap_clk =  '1') then
            if (ap_rst = '1') then
                start_once_reg <= ap_const_logic_0;
            else
                if (((internal_ap_ready = ap_const_logic_0) and (real_start = ap_const_logic_1))) then 
                    start_once_reg <= ap_const_logic_1;
                elsif ((internal_ap_ready = ap_const_logic_1)) then 
                    start_once_reg <= ap_const_logic_0;
                end if; 
            end if;
        end if;
    end process;


    axi_data_2_fu_64_assign_proc : process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if (((ap_const_logic_1 = ap_CS_fsm_state9) and (grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_last_hunt_fu_157_axi_data_4_out_ap_vld = ap_const_logic_1))) then 
                axi_data_2_fu_64 <= grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_last_hunt_fu_157_axi_data_4_out;
            elsif (((grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_start_hunt_fu_110_axi_data_out_ap_vld = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_state3))) then 
                axi_data_2_fu_64 <= grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_start_hunt_fu_110_axi_data_out;
            end if; 
        end if;
    end process;

    axi_last_2_reg_98_assign_proc : process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if ((ap_const_logic_1 = ap_CS_fsm_state4)) then 
                axi_last_2_reg_98 <= grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_start_hunt_fu_110_axi_last_out;
            elsif (((ap_const_logic_1 = ap_CS_fsm_state9) and (grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_last_hunt_fu_157_ap_done = ap_const_logic_1))) then 
                axi_last_2_reg_98 <= ap_const_lv1_1;
            end if; 
        end if;
    end process;

    i_fu_68_assign_proc : process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if ((not(((ap_done_reg = ap_const_logic_1) or (real_start = ap_const_logic_0))) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
                i_fu_68 <= ap_const_lv11_0;
            elsif (((ap_const_logic_1 = ap_CS_fsm_state5) and (icmp_ln129_fu_189_p2 = ap_const_lv1_0))) then 
                i_fu_68 <= i_4_fu_195_p2;
            end if; 
        end if;
    end process;

    start_reg_84_assign_proc : process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if ((ap_const_logic_1 = ap_CS_fsm_state4)) then 
                start_reg_84 <= ap_const_lv1_1;
            elsif (((ap_const_logic_1 = ap_CS_fsm_state9) and (grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_last_hunt_fu_157_ap_done = ap_const_logic_1))) then 
                start_reg_84 <= ap_const_lv1_0;
            end if; 
        end if;
    end process;

    ap_NS_fsm_assign_proc : process (real_start, ap_done_reg, ap_CS_fsm, ap_CS_fsm_state1, grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_start_hunt_fu_110_ap_done, grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_col_zxi2mat_fu_130_ap_done, grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_last_hunt_fu_157_ap_done, ap_CS_fsm_state9, ap_CS_fsm_state3, ap_CS_fsm_state5, icmp_ln129_fu_189_p2, ap_CS_fsm_state6)
    begin
        case ap_CS_fsm is
            when ap_ST_fsm_state1 => 
                if ((not(((ap_done_reg = ap_const_logic_1) or (real_start = ap_const_logic_0))) and (ap_const_logic_1 = ap_CS_fsm_state1))) then
                    ap_NS_fsm <= ap_ST_fsm_state2;
                else
                    ap_NS_fsm <= ap_ST_fsm_state1;
                end if;
            when ap_ST_fsm_state2 => 
                ap_NS_fsm <= ap_ST_fsm_state3;
            when ap_ST_fsm_state3 => 
                if (((grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_start_hunt_fu_110_ap_done = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_state3))) then
                    ap_NS_fsm <= ap_ST_fsm_state4;
                else
                    ap_NS_fsm <= ap_ST_fsm_state3;
                end if;
            when ap_ST_fsm_state4 => 
                ap_NS_fsm <= ap_ST_fsm_state5;
            when ap_ST_fsm_state5 => 
                if (((ap_const_logic_1 = ap_CS_fsm_state5) and (icmp_ln129_fu_189_p2 = ap_const_lv1_1))) then
                    ap_NS_fsm <= ap_ST_fsm_state1;
                else
                    ap_NS_fsm <= ap_ST_fsm_state6;
                end if;
            when ap_ST_fsm_state6 => 
                if (((grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_col_zxi2mat_fu_130_ap_done = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_state6))) then
                    ap_NS_fsm <= ap_ST_fsm_state7;
                else
                    ap_NS_fsm <= ap_ST_fsm_state6;
                end if;
            when ap_ST_fsm_state7 => 
                ap_NS_fsm <= ap_ST_fsm_state8;
            when ap_ST_fsm_state8 => 
                ap_NS_fsm <= ap_ST_fsm_state9;
            when ap_ST_fsm_state9 => 
                if (((ap_const_logic_1 = ap_CS_fsm_state9) and (grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_last_hunt_fu_157_ap_done = ap_const_logic_1))) then
                    ap_NS_fsm <= ap_ST_fsm_state5;
                else
                    ap_NS_fsm <= ap_ST_fsm_state9;
                end if;
            when others =>  
                ap_NS_fsm <= "XXXXXXXXX";
        end case;
    end process;
    ap_CS_fsm_state1 <= ap_CS_fsm(0);
    ap_CS_fsm_state2 <= ap_CS_fsm(1);
    ap_CS_fsm_state3 <= ap_CS_fsm(2);
    ap_CS_fsm_state4 <= ap_CS_fsm(3);
    ap_CS_fsm_state5 <= ap_CS_fsm(4);
    ap_CS_fsm_state6 <= ap_CS_fsm(5);
    ap_CS_fsm_state8 <= ap_CS_fsm(7);
    ap_CS_fsm_state9 <= ap_CS_fsm(8);

    ap_ST_fsm_state1_blk_assign_proc : process(real_start, ap_done_reg)
    begin
        if (((ap_done_reg = ap_const_logic_1) or (real_start = ap_const_logic_0))) then 
            ap_ST_fsm_state1_blk <= ap_const_logic_1;
        else 
            ap_ST_fsm_state1_blk <= ap_const_logic_0;
        end if; 
    end process;

    ap_ST_fsm_state2_blk <= ap_const_logic_0;

    ap_ST_fsm_state3_blk_assign_proc : process(grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_start_hunt_fu_110_ap_done)
    begin
        if ((grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_start_hunt_fu_110_ap_done = ap_const_logic_0)) then 
            ap_ST_fsm_state3_blk <= ap_const_logic_1;
        else 
            ap_ST_fsm_state3_blk <= ap_const_logic_0;
        end if; 
    end process;

    ap_ST_fsm_state4_blk <= ap_const_logic_0;
    ap_ST_fsm_state5_blk <= ap_const_logic_0;

    ap_ST_fsm_state6_blk_assign_proc : process(grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_col_zxi2mat_fu_130_ap_done)
    begin
        if ((grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_col_zxi2mat_fu_130_ap_done = ap_const_logic_0)) then 
            ap_ST_fsm_state6_blk <= ap_const_logic_1;
        else 
            ap_ST_fsm_state6_blk <= ap_const_logic_0;
        end if; 
    end process;

    ap_ST_fsm_state7_blk <= ap_const_logic_0;
    ap_ST_fsm_state8_blk <= ap_const_logic_0;

    ap_ST_fsm_state9_blk_assign_proc : process(grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_last_hunt_fu_157_ap_done)
    begin
        if ((grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_last_hunt_fu_157_ap_done = ap_const_logic_0)) then 
            ap_ST_fsm_state9_blk <= ap_const_logic_1;
        else 
            ap_ST_fsm_state9_blk <= ap_const_logic_0;
        end if; 
    end process;


    ap_block_state1_assign_proc : process(real_start, ap_done_reg)
    begin
                ap_block_state1 <= ((ap_done_reg = ap_const_logic_1) or (real_start = ap_const_logic_0));
    end process;


    ap_done_assign_proc : process(ap_done_reg, ap_CS_fsm_state5, icmp_ln129_fu_189_p2)
    begin
        if (((ap_const_logic_1 = ap_CS_fsm_state5) and (icmp_ln129_fu_189_p2 = ap_const_lv1_1))) then 
            ap_done <= ap_const_logic_1;
        else 
            ap_done <= ap_done_reg;
        end if; 
    end process;


    ap_idle_assign_proc : process(real_start, ap_CS_fsm_state1)
    begin
        if (((ap_const_logic_1 = ap_CS_fsm_state1) and (real_start = ap_const_logic_0))) then 
            ap_idle <= ap_const_logic_1;
        else 
            ap_idle <= ap_const_logic_0;
        end if; 
    end process;

    ap_ready <= internal_ap_ready;
    grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_col_zxi2mat_fu_130_ap_start <= grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_col_zxi2mat_fu_130_ap_start_reg;
    grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_last_hunt_fu_157_ap_start <= grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_last_hunt_fu_157_ap_start_reg;
    grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_start_hunt_fu_110_ap_start <= grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_start_hunt_fu_110_ap_start_reg;
    i_4_fu_195_p2 <= std_logic_vector(unsigned(i_fu_68) + unsigned(ap_const_lv11_1));
    icmp_ln129_fu_189_p2 <= "1" when (i_fu_68 = ap_const_lv11_438) else "0";

    internal_ap_ready_assign_proc : process(ap_CS_fsm_state5, icmp_ln129_fu_189_p2)
    begin
        if (((ap_const_logic_1 = ap_CS_fsm_state5) and (icmp_ln129_fu_189_p2 = ap_const_lv1_1))) then 
            internal_ap_ready <= ap_const_logic_1;
        else 
            internal_ap_ready <= ap_const_logic_0;
        end if; 
    end process;


    real_start_assign_proc : process(ap_start, start_full_n, start_once_reg)
    begin
        if (((start_once_reg = ap_const_logic_0) and (start_full_n = ap_const_logic_0))) then 
            real_start <= ap_const_logic_0;
        else 
            real_start <= ap_start;
        end if; 
    end process;

    srcImg_data_din <= grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_col_zxi2mat_fu_130_srcImg_data_din;

    srcImg_data_write_assign_proc : process(grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_col_zxi2mat_fu_130_srcImg_data_write, ap_CS_fsm_state6)
    begin
        if ((ap_const_logic_1 = ap_CS_fsm_state6)) then 
            srcImg_data_write <= grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_col_zxi2mat_fu_130_srcImg_data_write;
        else 
            srcImg_data_write <= ap_const_logic_0;
        end if; 
    end process;

    src_TREADY <= regslice_both_src_V_data_V_U_ack_in;

    src_TREADY_int_regslice_assign_proc : process(grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_start_hunt_fu_110_src_TREADY, grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_col_zxi2mat_fu_130_src_TREADY, grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_last_hunt_fu_157_src_TREADY, ap_CS_fsm_state9, ap_CS_fsm_state3, ap_CS_fsm_state6)
    begin
        if ((ap_const_logic_1 = ap_CS_fsm_state9)) then 
            src_TREADY_int_regslice <= grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_last_hunt_fu_157_src_TREADY;
        elsif ((ap_const_logic_1 = ap_CS_fsm_state6)) then 
            src_TREADY_int_regslice <= grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_col_zxi2mat_fu_130_src_TREADY;
        elsif ((ap_const_logic_1 = ap_CS_fsm_state3)) then 
            src_TREADY_int_regslice <= grp_AXIvideo2xfMat_24_16_1080_1920_1_2_Pipeline_loop_start_hunt_fu_110_src_TREADY;
        else 
            src_TREADY_int_regslice <= ap_const_logic_0;
        end if; 
    end process;

    start_out <= real_start;

    start_write_assign_proc : process(real_start, start_once_reg)
    begin
        if (((start_once_reg = ap_const_logic_0) and (real_start = ap_const_logic_1))) then 
            start_write <= ap_const_logic_1;
        else 
            start_write <= ap_const_logic_0;
        end if; 
    end process;

end behav;
