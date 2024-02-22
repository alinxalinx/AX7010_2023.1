-- ==============================================================
-- Generated by Vitis HLS v2023.1
-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
-- ==============================================================

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity mem2stream_xfMat2AXIvideo_24_16_1080_1920_1_2_s is
port (
    ap_clk : IN STD_LOGIC;
    ap_rst : IN STD_LOGIC;
    ap_start : IN STD_LOGIC;
    ap_done : OUT STD_LOGIC;
    ap_continue : IN STD_LOGIC;
    ap_idle : OUT STD_LOGIC;
    ap_ready : OUT STD_LOGIC;
    img_1_dout : IN STD_LOGIC_VECTOR (10 downto 0);
    img_1_num_data_valid : IN STD_LOGIC_VECTOR (1 downto 0);
    img_1_fifo_cap : IN STD_LOGIC_VECTOR (1 downto 0);
    img_1_empty_n : IN STD_LOGIC;
    img_1_read : OUT STD_LOGIC;
    img_2_dout : IN STD_LOGIC_VECTOR (7 downto 0);
    img_2_num_data_valid : IN STD_LOGIC_VECTOR (1 downto 0);
    img_2_fifo_cap : IN STD_LOGIC_VECTOR (1 downto 0);
    img_2_empty_n : IN STD_LOGIC;
    img_2_read : OUT STD_LOGIC;
    img_data_dout : IN STD_LOGIC_VECTOR (23 downto 0);
    img_data_num_data_valid : IN STD_LOGIC_VECTOR (1 downto 0);
    img_data_fifo_cap : IN STD_LOGIC_VECTOR (1 downto 0);
    img_data_empty_n : IN STD_LOGIC;
    img_data_read : OUT STD_LOGIC;
    vstream_TDATA : OUT STD_LOGIC_VECTOR (23 downto 0);
    vstream_TVALID : OUT STD_LOGIC;
    vstream_TREADY : IN STD_LOGIC;
    vstream_TKEEP : OUT STD_LOGIC_VECTOR (2 downto 0);
    vstream_TSTRB : OUT STD_LOGIC_VECTOR (2 downto 0);
    vstream_TUSER : OUT STD_LOGIC_VECTOR (0 downto 0);
    vstream_TLAST : OUT STD_LOGIC_VECTOR (0 downto 0);
    vstream_TID : OUT STD_LOGIC_VECTOR (0 downto 0);
    vstream_TDEST : OUT STD_LOGIC_VECTOR (0 downto 0) );
end;


architecture behav of mem2stream_xfMat2AXIvideo_24_16_1080_1920_1_2_s is 
    constant ap_const_logic_1 : STD_LOGIC := '1';
    constant ap_const_logic_0 : STD_LOGIC := '0';
    constant ap_ST_fsm_state1 : STD_LOGIC_VECTOR (3 downto 0) := "0001";
    constant ap_ST_fsm_state2 : STD_LOGIC_VECTOR (3 downto 0) := "0010";
    constant ap_ST_fsm_state3 : STD_LOGIC_VECTOR (3 downto 0) := "0100";
    constant ap_ST_fsm_state4 : STD_LOGIC_VECTOR (3 downto 0) := "1000";
    constant ap_const_lv32_0 : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000000";
    constant ap_const_boolean_1 : BOOLEAN := true;
    constant ap_const_lv32_1 : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000001";
    constant ap_const_lv1_0 : STD_LOGIC_VECTOR (0 downto 0) := "0";
    constant ap_const_lv32_2 : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000010";
    constant ap_const_lv11_0 : STD_LOGIC_VECTOR (10 downto 0) := "00000000000";
    constant ap_const_boolean_0 : BOOLEAN := false;
    constant ap_const_lv1_1 : STD_LOGIC_VECTOR (0 downto 0) := "1";
    constant ap_const_lv12_FFF : STD_LOGIC_VECTOR (11 downto 0) := "111111111111";
    constant ap_const_lv8_0 : STD_LOGIC_VECTOR (7 downto 0) := "00000000";
    constant ap_const_lv11_1 : STD_LOGIC_VECTOR (10 downto 0) := "00000000001";
    constant ap_const_lv32_3 : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000011";
    constant ap_const_lv2_0 : STD_LOGIC_VECTOR (1 downto 0) := "00";

attribute shreg_extract : string;
    signal ap_done_reg : STD_LOGIC := '0';
    signal ap_CS_fsm : STD_LOGIC_VECTOR (3 downto 0) := "0001";
    attribute fsm_encoding : string;
    attribute fsm_encoding of ap_CS_fsm : signal is "none";
    signal ap_CS_fsm_state1 : STD_LOGIC;
    attribute fsm_encoding of ap_CS_fsm_state1 : signal is "none";
    signal img_1_blk_n : STD_LOGIC;
    signal img_2_blk_n : STD_LOGIC;
    signal cols_reg_194 : STD_LOGIC_VECTOR (7 downto 0);
    signal ap_block_state1 : BOOLEAN;
    signal rows_reg_199 : STD_LOGIC_VECTOR (10 downto 0);
    signal sub_fu_131_p2 : STD_LOGIC_VECTOR (11 downto 0);
    signal sub_reg_204 : STD_LOGIC_VECTOR (11 downto 0);
    signal cmp91_fu_137_p2 : STD_LOGIC_VECTOR (0 downto 0);
    signal cmp91_reg_209 : STD_LOGIC_VECTOR (0 downto 0);
    signal i_2_fu_161_p2 : STD_LOGIC_VECTOR (10 downto 0);
    signal i_2_reg_216 : STD_LOGIC_VECTOR (10 downto 0);
    signal ap_CS_fsm_state2 : STD_LOGIC;
    attribute fsm_encoding of ap_CS_fsm_state2 : signal is "none";
    signal grp_xfMat2AXIvideo_24_16_1080_1920_1_2_Pipeline_loop_col_mat2axi_fu_100_ap_start : STD_LOGIC;
    signal grp_xfMat2AXIvideo_24_16_1080_1920_1_2_Pipeline_loop_col_mat2axi_fu_100_ap_done : STD_LOGIC;
    signal grp_xfMat2AXIvideo_24_16_1080_1920_1_2_Pipeline_loop_col_mat2axi_fu_100_ap_idle : STD_LOGIC;
    signal grp_xfMat2AXIvideo_24_16_1080_1920_1_2_Pipeline_loop_col_mat2axi_fu_100_ap_ready : STD_LOGIC;
    signal grp_xfMat2AXIvideo_24_16_1080_1920_1_2_Pipeline_loop_col_mat2axi_fu_100_img_data_read : STD_LOGIC;
    signal grp_xfMat2AXIvideo_24_16_1080_1920_1_2_Pipeline_loop_col_mat2axi_fu_100_vstream_TREADY : STD_LOGIC;
    signal grp_xfMat2AXIvideo_24_16_1080_1920_1_2_Pipeline_loop_col_mat2axi_fu_100_vstream_TDATA : STD_LOGIC_VECTOR (23 downto 0);
    signal grp_xfMat2AXIvideo_24_16_1080_1920_1_2_Pipeline_loop_col_mat2axi_fu_100_vstream_TVALID : STD_LOGIC;
    signal grp_xfMat2AXIvideo_24_16_1080_1920_1_2_Pipeline_loop_col_mat2axi_fu_100_vstream_TKEEP : STD_LOGIC_VECTOR (2 downto 0);
    signal grp_xfMat2AXIvideo_24_16_1080_1920_1_2_Pipeline_loop_col_mat2axi_fu_100_vstream_TSTRB : STD_LOGIC_VECTOR (2 downto 0);
    signal grp_xfMat2AXIvideo_24_16_1080_1920_1_2_Pipeline_loop_col_mat2axi_fu_100_vstream_TUSER : STD_LOGIC_VECTOR (0 downto 0);
    signal grp_xfMat2AXIvideo_24_16_1080_1920_1_2_Pipeline_loop_col_mat2axi_fu_100_vstream_TLAST : STD_LOGIC_VECTOR (0 downto 0);
    signal grp_xfMat2AXIvideo_24_16_1080_1920_1_2_Pipeline_loop_col_mat2axi_fu_100_vstream_TID : STD_LOGIC_VECTOR (0 downto 0);
    signal grp_xfMat2AXIvideo_24_16_1080_1920_1_2_Pipeline_loop_col_mat2axi_fu_100_vstream_TDEST : STD_LOGIC_VECTOR (0 downto 0);
    signal grp_xfMat2AXIvideo_24_16_1080_1920_1_2_Pipeline_loop_col_mat2axi_fu_100_ap_start_reg : STD_LOGIC := '0';
    signal icmp_ln197_fu_156_p2 : STD_LOGIC_VECTOR (0 downto 0);
    signal ap_CS_fsm_state3 : STD_LOGIC;
    attribute fsm_encoding of ap_CS_fsm_state3 : signal is "none";
    signal i_fu_80 : STD_LOGIC_VECTOR (10 downto 0);
    signal ap_block_state3_on_subcall_done : BOOLEAN;
    signal sof_fu_84 : STD_LOGIC_VECTOR (0 downto 0);
    signal cols_cast_cast_cast_cast_cast_fu_123_p0 : STD_LOGIC_VECTOR (7 downto 0);
    signal cols_cast_cast_cast_cast_cast_fu_123_p1 : STD_LOGIC_VECTOR (10 downto 0);
    signal cols_cast_cast_cast_cast_cast_cast_fu_127_p1 : STD_LOGIC_VECTOR (11 downto 0);
    signal cmp91_fu_137_p0 : STD_LOGIC_VECTOR (7 downto 0);
    signal ap_CS_fsm_state4 : STD_LOGIC;
    attribute fsm_encoding of ap_CS_fsm_state4 : signal is "none";
    signal regslice_both_vstream_V_data_V_U_apdone_blk : STD_LOGIC;
    signal ap_NS_fsm : STD_LOGIC_VECTOR (3 downto 0);
    signal ap_ST_fsm_state1_blk : STD_LOGIC;
    signal ap_ST_fsm_state2_blk : STD_LOGIC;
    signal ap_ST_fsm_state3_blk : STD_LOGIC;
    signal ap_ST_fsm_state4_blk : STD_LOGIC;
    signal vstream_TVALID_int_regslice : STD_LOGIC;
    signal vstream_TREADY_int_regslice : STD_LOGIC;
    signal regslice_both_vstream_V_data_V_U_vld_out : STD_LOGIC;
    signal regslice_both_vstream_V_keep_V_U_apdone_blk : STD_LOGIC;
    signal regslice_both_vstream_V_keep_V_U_ack_in_dummy : STD_LOGIC;
    signal regslice_both_vstream_V_keep_V_U_vld_out : STD_LOGIC;
    signal regslice_both_vstream_V_strb_V_U_apdone_blk : STD_LOGIC;
    signal regslice_both_vstream_V_strb_V_U_ack_in_dummy : STD_LOGIC;
    signal regslice_both_vstream_V_strb_V_U_vld_out : STD_LOGIC;
    signal regslice_both_vstream_V_user_V_U_apdone_blk : STD_LOGIC;
    signal regslice_both_vstream_V_user_V_U_ack_in_dummy : STD_LOGIC;
    signal regslice_both_vstream_V_user_V_U_vld_out : STD_LOGIC;
    signal regslice_both_vstream_V_last_V_U_apdone_blk : STD_LOGIC;
    signal regslice_both_vstream_V_last_V_U_ack_in_dummy : STD_LOGIC;
    signal regslice_both_vstream_V_last_V_U_vld_out : STD_LOGIC;
    signal regslice_both_vstream_V_id_V_U_apdone_blk : STD_LOGIC;
    signal regslice_both_vstream_V_id_V_U_ack_in_dummy : STD_LOGIC;
    signal regslice_both_vstream_V_id_V_U_vld_out : STD_LOGIC;
    signal regslice_both_vstream_V_dest_V_U_apdone_blk : STD_LOGIC;
    signal regslice_both_vstream_V_dest_V_U_ack_in_dummy : STD_LOGIC;
    signal regslice_both_vstream_V_dest_V_U_vld_out : STD_LOGIC;
    signal ap_ce_reg : STD_LOGIC;

    component mem2stream_xfMat2AXIvideo_24_16_1080_1920_1_2_Pipeline_loop_col_mat2axi IS
    port (
        ap_clk : IN STD_LOGIC;
        ap_rst : IN STD_LOGIC;
        ap_start : IN STD_LOGIC;
        ap_done : OUT STD_LOGIC;
        ap_idle : OUT STD_LOGIC;
        ap_ready : OUT STD_LOGIC;
        img_data_dout : IN STD_LOGIC_VECTOR (23 downto 0);
        img_data_num_data_valid : IN STD_LOGIC_VECTOR (1 downto 0);
        img_data_fifo_cap : IN STD_LOGIC_VECTOR (1 downto 0);
        img_data_empty_n : IN STD_LOGIC;
        img_data_read : OUT STD_LOGIC;
        vstream_TREADY : IN STD_LOGIC;
        sof : IN STD_LOGIC_VECTOR (0 downto 0);
        cols_cast6 : IN STD_LOGIC_VECTOR (7 downto 0);
        sub : IN STD_LOGIC_VECTOR (11 downto 0);
        vstream_TDATA : OUT STD_LOGIC_VECTOR (23 downto 0);
        vstream_TVALID : OUT STD_LOGIC;
        vstream_TKEEP : OUT STD_LOGIC_VECTOR (2 downto 0);
        vstream_TSTRB : OUT STD_LOGIC_VECTOR (2 downto 0);
        vstream_TUSER : OUT STD_LOGIC_VECTOR (0 downto 0);
        vstream_TLAST : OUT STD_LOGIC_VECTOR (0 downto 0);
        vstream_TID : OUT STD_LOGIC_VECTOR (0 downto 0);
        vstream_TDEST : OUT STD_LOGIC_VECTOR (0 downto 0) );
    end component;


    component mem2stream_regslice_both IS
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
    grp_xfMat2AXIvideo_24_16_1080_1920_1_2_Pipeline_loop_col_mat2axi_fu_100 : component mem2stream_xfMat2AXIvideo_24_16_1080_1920_1_2_Pipeline_loop_col_mat2axi
    port map (
        ap_clk => ap_clk,
        ap_rst => ap_rst,
        ap_start => grp_xfMat2AXIvideo_24_16_1080_1920_1_2_Pipeline_loop_col_mat2axi_fu_100_ap_start,
        ap_done => grp_xfMat2AXIvideo_24_16_1080_1920_1_2_Pipeline_loop_col_mat2axi_fu_100_ap_done,
        ap_idle => grp_xfMat2AXIvideo_24_16_1080_1920_1_2_Pipeline_loop_col_mat2axi_fu_100_ap_idle,
        ap_ready => grp_xfMat2AXIvideo_24_16_1080_1920_1_2_Pipeline_loop_col_mat2axi_fu_100_ap_ready,
        img_data_dout => img_data_dout,
        img_data_num_data_valid => ap_const_lv2_0,
        img_data_fifo_cap => ap_const_lv2_0,
        img_data_empty_n => img_data_empty_n,
        img_data_read => grp_xfMat2AXIvideo_24_16_1080_1920_1_2_Pipeline_loop_col_mat2axi_fu_100_img_data_read,
        vstream_TREADY => grp_xfMat2AXIvideo_24_16_1080_1920_1_2_Pipeline_loop_col_mat2axi_fu_100_vstream_TREADY,
        sof => sof_fu_84,
        cols_cast6 => cols_reg_194,
        sub => sub_reg_204,
        vstream_TDATA => grp_xfMat2AXIvideo_24_16_1080_1920_1_2_Pipeline_loop_col_mat2axi_fu_100_vstream_TDATA,
        vstream_TVALID => grp_xfMat2AXIvideo_24_16_1080_1920_1_2_Pipeline_loop_col_mat2axi_fu_100_vstream_TVALID,
        vstream_TKEEP => grp_xfMat2AXIvideo_24_16_1080_1920_1_2_Pipeline_loop_col_mat2axi_fu_100_vstream_TKEEP,
        vstream_TSTRB => grp_xfMat2AXIvideo_24_16_1080_1920_1_2_Pipeline_loop_col_mat2axi_fu_100_vstream_TSTRB,
        vstream_TUSER => grp_xfMat2AXIvideo_24_16_1080_1920_1_2_Pipeline_loop_col_mat2axi_fu_100_vstream_TUSER,
        vstream_TLAST => grp_xfMat2AXIvideo_24_16_1080_1920_1_2_Pipeline_loop_col_mat2axi_fu_100_vstream_TLAST,
        vstream_TID => grp_xfMat2AXIvideo_24_16_1080_1920_1_2_Pipeline_loop_col_mat2axi_fu_100_vstream_TID,
        vstream_TDEST => grp_xfMat2AXIvideo_24_16_1080_1920_1_2_Pipeline_loop_col_mat2axi_fu_100_vstream_TDEST);

    regslice_both_vstream_V_data_V_U : component mem2stream_regslice_both
    generic map (
        DataWidth => 24)
    port map (
        ap_clk => ap_clk,
        ap_rst => ap_rst,
        data_in => grp_xfMat2AXIvideo_24_16_1080_1920_1_2_Pipeline_loop_col_mat2axi_fu_100_vstream_TDATA,
        vld_in => grp_xfMat2AXIvideo_24_16_1080_1920_1_2_Pipeline_loop_col_mat2axi_fu_100_vstream_TVALID,
        ack_in => vstream_TREADY_int_regslice,
        data_out => vstream_TDATA,
        vld_out => regslice_both_vstream_V_data_V_U_vld_out,
        ack_out => vstream_TREADY,
        apdone_blk => regslice_both_vstream_V_data_V_U_apdone_blk);

    regslice_both_vstream_V_keep_V_U : component mem2stream_regslice_both
    generic map (
        DataWidth => 3)
    port map (
        ap_clk => ap_clk,
        ap_rst => ap_rst,
        data_in => grp_xfMat2AXIvideo_24_16_1080_1920_1_2_Pipeline_loop_col_mat2axi_fu_100_vstream_TKEEP,
        vld_in => grp_xfMat2AXIvideo_24_16_1080_1920_1_2_Pipeline_loop_col_mat2axi_fu_100_vstream_TVALID,
        ack_in => regslice_both_vstream_V_keep_V_U_ack_in_dummy,
        data_out => vstream_TKEEP,
        vld_out => regslice_both_vstream_V_keep_V_U_vld_out,
        ack_out => vstream_TREADY,
        apdone_blk => regslice_both_vstream_V_keep_V_U_apdone_blk);

    regslice_both_vstream_V_strb_V_U : component mem2stream_regslice_both
    generic map (
        DataWidth => 3)
    port map (
        ap_clk => ap_clk,
        ap_rst => ap_rst,
        data_in => grp_xfMat2AXIvideo_24_16_1080_1920_1_2_Pipeline_loop_col_mat2axi_fu_100_vstream_TSTRB,
        vld_in => grp_xfMat2AXIvideo_24_16_1080_1920_1_2_Pipeline_loop_col_mat2axi_fu_100_vstream_TVALID,
        ack_in => regslice_both_vstream_V_strb_V_U_ack_in_dummy,
        data_out => vstream_TSTRB,
        vld_out => regslice_both_vstream_V_strb_V_U_vld_out,
        ack_out => vstream_TREADY,
        apdone_blk => regslice_both_vstream_V_strb_V_U_apdone_blk);

    regslice_both_vstream_V_user_V_U : component mem2stream_regslice_both
    generic map (
        DataWidth => 1)
    port map (
        ap_clk => ap_clk,
        ap_rst => ap_rst,
        data_in => grp_xfMat2AXIvideo_24_16_1080_1920_1_2_Pipeline_loop_col_mat2axi_fu_100_vstream_TUSER,
        vld_in => grp_xfMat2AXIvideo_24_16_1080_1920_1_2_Pipeline_loop_col_mat2axi_fu_100_vstream_TVALID,
        ack_in => regslice_both_vstream_V_user_V_U_ack_in_dummy,
        data_out => vstream_TUSER,
        vld_out => regslice_both_vstream_V_user_V_U_vld_out,
        ack_out => vstream_TREADY,
        apdone_blk => regslice_both_vstream_V_user_V_U_apdone_blk);

    regslice_both_vstream_V_last_V_U : component mem2stream_regslice_both
    generic map (
        DataWidth => 1)
    port map (
        ap_clk => ap_clk,
        ap_rst => ap_rst,
        data_in => grp_xfMat2AXIvideo_24_16_1080_1920_1_2_Pipeline_loop_col_mat2axi_fu_100_vstream_TLAST,
        vld_in => grp_xfMat2AXIvideo_24_16_1080_1920_1_2_Pipeline_loop_col_mat2axi_fu_100_vstream_TVALID,
        ack_in => regslice_both_vstream_V_last_V_U_ack_in_dummy,
        data_out => vstream_TLAST,
        vld_out => regslice_both_vstream_V_last_V_U_vld_out,
        ack_out => vstream_TREADY,
        apdone_blk => regslice_both_vstream_V_last_V_U_apdone_blk);

    regslice_both_vstream_V_id_V_U : component mem2stream_regslice_both
    generic map (
        DataWidth => 1)
    port map (
        ap_clk => ap_clk,
        ap_rst => ap_rst,
        data_in => grp_xfMat2AXIvideo_24_16_1080_1920_1_2_Pipeline_loop_col_mat2axi_fu_100_vstream_TID,
        vld_in => grp_xfMat2AXIvideo_24_16_1080_1920_1_2_Pipeline_loop_col_mat2axi_fu_100_vstream_TVALID,
        ack_in => regslice_both_vstream_V_id_V_U_ack_in_dummy,
        data_out => vstream_TID,
        vld_out => regslice_both_vstream_V_id_V_U_vld_out,
        ack_out => vstream_TREADY,
        apdone_blk => regslice_both_vstream_V_id_V_U_apdone_blk);

    regslice_both_vstream_V_dest_V_U : component mem2stream_regslice_both
    generic map (
        DataWidth => 1)
    port map (
        ap_clk => ap_clk,
        ap_rst => ap_rst,
        data_in => grp_xfMat2AXIvideo_24_16_1080_1920_1_2_Pipeline_loop_col_mat2axi_fu_100_vstream_TDEST,
        vld_in => grp_xfMat2AXIvideo_24_16_1080_1920_1_2_Pipeline_loop_col_mat2axi_fu_100_vstream_TVALID,
        ack_in => regslice_both_vstream_V_dest_V_U_ack_in_dummy,
        data_out => vstream_TDEST,
        vld_out => regslice_both_vstream_V_dest_V_U_vld_out,
        ack_out => vstream_TREADY,
        apdone_blk => regslice_both_vstream_V_dest_V_U_apdone_blk);





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
                elsif (((ap_const_logic_1 = ap_CS_fsm_state4) and (regslice_both_vstream_V_data_V_U_apdone_blk = ap_const_logic_0))) then 
                    ap_done_reg <= ap_const_logic_1;
                end if; 
            end if;
        end if;
    end process;


    grp_xfMat2AXIvideo_24_16_1080_1920_1_2_Pipeline_loop_col_mat2axi_fu_100_ap_start_reg_assign_proc : process(ap_clk)
    begin
        if (ap_clk'event and ap_clk =  '1') then
            if (ap_rst = '1') then
                grp_xfMat2AXIvideo_24_16_1080_1920_1_2_Pipeline_loop_col_mat2axi_fu_100_ap_start_reg <= ap_const_logic_0;
            else
                if (((cmp91_reg_209 = ap_const_lv1_0) and (ap_const_logic_1 = ap_CS_fsm_state2) and (icmp_ln197_fu_156_p2 = ap_const_lv1_0))) then 
                    grp_xfMat2AXIvideo_24_16_1080_1920_1_2_Pipeline_loop_col_mat2axi_fu_100_ap_start_reg <= ap_const_logic_1;
                elsif ((grp_xfMat2AXIvideo_24_16_1080_1920_1_2_Pipeline_loop_col_mat2axi_fu_100_ap_ready = ap_const_logic_1)) then 
                    grp_xfMat2AXIvideo_24_16_1080_1920_1_2_Pipeline_loop_col_mat2axi_fu_100_ap_start_reg <= ap_const_logic_0;
                end if; 
            end if;
        end if;
    end process;


    i_fu_80_assign_proc : process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if ((not(((ap_start = ap_const_logic_0) or (img_2_empty_n = ap_const_logic_0) or (img_1_empty_n = ap_const_logic_0) or (ap_done_reg = ap_const_logic_1))) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
                i_fu_80 <= ap_const_lv11_0;
            elsif (((ap_const_logic_1 = ap_CS_fsm_state3) and (ap_const_boolean_0 = ap_block_state3_on_subcall_done))) then 
                i_fu_80 <= i_2_reg_216;
            end if; 
        end if;
    end process;

    sof_fu_84_assign_proc : process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if ((not(((ap_start = ap_const_logic_0) or (img_2_empty_n = ap_const_logic_0) or (img_1_empty_n = ap_const_logic_0) or (ap_done_reg = ap_const_logic_1))) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
                sof_fu_84 <= ap_const_lv1_1;
            elsif (((cmp91_reg_209 = ap_const_lv1_0) and (ap_const_logic_1 = ap_CS_fsm_state3) and (ap_const_boolean_0 = ap_block_state3_on_subcall_done))) then 
                sof_fu_84 <= ap_const_lv1_0;
            end if; 
        end if;
    end process;
    process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if ((not(((ap_start = ap_const_logic_0) or (img_2_empty_n = ap_const_logic_0) or (img_1_empty_n = ap_const_logic_0) or (ap_done_reg = ap_const_logic_1))) and (ap_const_logic_1 = ap_CS_fsm_state1))) then
                cmp91_reg_209 <= cmp91_fu_137_p2;
                cols_reg_194 <= img_2_dout;
                rows_reg_199 <= img_1_dout;
                sub_reg_204 <= sub_fu_131_p2;
            end if;
        end if;
    end process;
    process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if ((ap_const_logic_1 = ap_CS_fsm_state2)) then
                i_2_reg_216 <= i_2_fu_161_p2;
            end if;
        end if;
    end process;

    ap_NS_fsm_assign_proc : process (ap_start, ap_done_reg, ap_CS_fsm, ap_CS_fsm_state1, img_1_empty_n, img_2_empty_n, ap_CS_fsm_state2, icmp_ln197_fu_156_p2, ap_CS_fsm_state3, ap_block_state3_on_subcall_done, ap_CS_fsm_state4, regslice_both_vstream_V_data_V_U_apdone_blk)
    begin
        case ap_CS_fsm is
            when ap_ST_fsm_state1 => 
                if ((not(((ap_start = ap_const_logic_0) or (img_2_empty_n = ap_const_logic_0) or (img_1_empty_n = ap_const_logic_0) or (ap_done_reg = ap_const_logic_1))) and (ap_const_logic_1 = ap_CS_fsm_state1))) then
                    ap_NS_fsm <= ap_ST_fsm_state2;
                else
                    ap_NS_fsm <= ap_ST_fsm_state1;
                end if;
            when ap_ST_fsm_state2 => 
                if (((ap_const_logic_1 = ap_CS_fsm_state2) and (icmp_ln197_fu_156_p2 = ap_const_lv1_0))) then
                    ap_NS_fsm <= ap_ST_fsm_state3;
                else
                    ap_NS_fsm <= ap_ST_fsm_state4;
                end if;
            when ap_ST_fsm_state3 => 
                if (((ap_const_logic_1 = ap_CS_fsm_state3) and (ap_const_boolean_0 = ap_block_state3_on_subcall_done))) then
                    ap_NS_fsm <= ap_ST_fsm_state2;
                else
                    ap_NS_fsm <= ap_ST_fsm_state3;
                end if;
            when ap_ST_fsm_state4 => 
                if (((ap_const_logic_1 = ap_CS_fsm_state4) and (regslice_both_vstream_V_data_V_U_apdone_blk = ap_const_logic_0))) then
                    ap_NS_fsm <= ap_ST_fsm_state1;
                else
                    ap_NS_fsm <= ap_ST_fsm_state4;
                end if;
            when others =>  
                ap_NS_fsm <= "XXXX";
        end case;
    end process;
    ap_CS_fsm_state1 <= ap_CS_fsm(0);
    ap_CS_fsm_state2 <= ap_CS_fsm(1);
    ap_CS_fsm_state3 <= ap_CS_fsm(2);
    ap_CS_fsm_state4 <= ap_CS_fsm(3);

    ap_ST_fsm_state1_blk_assign_proc : process(ap_start, ap_done_reg, img_1_empty_n, img_2_empty_n)
    begin
        if (((ap_start = ap_const_logic_0) or (img_2_empty_n = ap_const_logic_0) or (img_1_empty_n = ap_const_logic_0) or (ap_done_reg = ap_const_logic_1))) then 
            ap_ST_fsm_state1_blk <= ap_const_logic_1;
        else 
            ap_ST_fsm_state1_blk <= ap_const_logic_0;
        end if; 
    end process;

    ap_ST_fsm_state2_blk <= ap_const_logic_0;

    ap_ST_fsm_state3_blk_assign_proc : process(ap_block_state3_on_subcall_done)
    begin
        if ((ap_const_boolean_1 = ap_block_state3_on_subcall_done)) then 
            ap_ST_fsm_state3_blk <= ap_const_logic_1;
        else 
            ap_ST_fsm_state3_blk <= ap_const_logic_0;
        end if; 
    end process;


    ap_ST_fsm_state4_blk_assign_proc : process(regslice_both_vstream_V_data_V_U_apdone_blk)
    begin
        if ((regslice_both_vstream_V_data_V_U_apdone_blk = ap_const_logic_1)) then 
            ap_ST_fsm_state4_blk <= ap_const_logic_1;
        else 
            ap_ST_fsm_state4_blk <= ap_const_logic_0;
        end if; 
    end process;


    ap_block_state1_assign_proc : process(ap_start, ap_done_reg, img_1_empty_n, img_2_empty_n)
    begin
                ap_block_state1 <= ((ap_start = ap_const_logic_0) or (img_2_empty_n = ap_const_logic_0) or (img_1_empty_n = ap_const_logic_0) or (ap_done_reg = ap_const_logic_1));
    end process;


    ap_block_state3_on_subcall_done_assign_proc : process(cmp91_reg_209, grp_xfMat2AXIvideo_24_16_1080_1920_1_2_Pipeline_loop_col_mat2axi_fu_100_ap_done)
    begin
                ap_block_state3_on_subcall_done <= ((grp_xfMat2AXIvideo_24_16_1080_1920_1_2_Pipeline_loop_col_mat2axi_fu_100_ap_done = ap_const_logic_0) and (cmp91_reg_209 = ap_const_lv1_0));
    end process;


    ap_done_assign_proc : process(ap_done_reg, ap_CS_fsm_state4, regslice_both_vstream_V_data_V_U_apdone_blk)
    begin
        if (((ap_const_logic_1 = ap_CS_fsm_state4) and (regslice_both_vstream_V_data_V_U_apdone_blk = ap_const_logic_0))) then 
            ap_done <= ap_const_logic_1;
        else 
            ap_done <= ap_done_reg;
        end if; 
    end process;


    ap_idle_assign_proc : process(ap_start, ap_CS_fsm_state1)
    begin
        if (((ap_start = ap_const_logic_0) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
            ap_idle <= ap_const_logic_1;
        else 
            ap_idle <= ap_const_logic_0;
        end if; 
    end process;


    ap_ready_assign_proc : process(ap_CS_fsm_state4, regslice_both_vstream_V_data_V_U_apdone_blk)
    begin
        if (((ap_const_logic_1 = ap_CS_fsm_state4) and (regslice_both_vstream_V_data_V_U_apdone_blk = ap_const_logic_0))) then 
            ap_ready <= ap_const_logic_1;
        else 
            ap_ready <= ap_const_logic_0;
        end if; 
    end process;

    cmp91_fu_137_p0 <= img_2_dout;
    cmp91_fu_137_p2 <= "1" when (cmp91_fu_137_p0 = ap_const_lv8_0) else "0";
    cols_cast_cast_cast_cast_cast_cast_fu_127_p1 <= std_logic_vector(IEEE.numeric_std.resize(unsigned(cols_cast_cast_cast_cast_cast_fu_123_p1),12));
    cols_cast_cast_cast_cast_cast_fu_123_p0 <= img_2_dout;
        cols_cast_cast_cast_cast_cast_fu_123_p1 <= std_logic_vector(IEEE.numeric_std.resize(signed(cols_cast_cast_cast_cast_cast_fu_123_p0),11));

    grp_xfMat2AXIvideo_24_16_1080_1920_1_2_Pipeline_loop_col_mat2axi_fu_100_ap_start <= grp_xfMat2AXIvideo_24_16_1080_1920_1_2_Pipeline_loop_col_mat2axi_fu_100_ap_start_reg;
    grp_xfMat2AXIvideo_24_16_1080_1920_1_2_Pipeline_loop_col_mat2axi_fu_100_vstream_TREADY <= (vstream_TREADY_int_regslice and ap_CS_fsm_state3);
    i_2_fu_161_p2 <= std_logic_vector(unsigned(i_fu_80) + unsigned(ap_const_lv11_1));
    icmp_ln197_fu_156_p2 <= "1" when (i_fu_80 = rows_reg_199) else "0";

    img_1_blk_n_assign_proc : process(ap_start, ap_done_reg, ap_CS_fsm_state1, img_1_empty_n)
    begin
        if ((not(((ap_start = ap_const_logic_0) or (ap_done_reg = ap_const_logic_1))) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
            img_1_blk_n <= img_1_empty_n;
        else 
            img_1_blk_n <= ap_const_logic_1;
        end if; 
    end process;


    img_1_read_assign_proc : process(ap_start, ap_done_reg, ap_CS_fsm_state1, img_1_empty_n, img_2_empty_n)
    begin
        if ((not(((ap_start = ap_const_logic_0) or (img_2_empty_n = ap_const_logic_0) or (img_1_empty_n = ap_const_logic_0) or (ap_done_reg = ap_const_logic_1))) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
            img_1_read <= ap_const_logic_1;
        else 
            img_1_read <= ap_const_logic_0;
        end if; 
    end process;


    img_2_blk_n_assign_proc : process(ap_start, ap_done_reg, ap_CS_fsm_state1, img_2_empty_n)
    begin
        if ((not(((ap_start = ap_const_logic_0) or (ap_done_reg = ap_const_logic_1))) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
            img_2_blk_n <= img_2_empty_n;
        else 
            img_2_blk_n <= ap_const_logic_1;
        end if; 
    end process;


    img_2_read_assign_proc : process(ap_start, ap_done_reg, ap_CS_fsm_state1, img_1_empty_n, img_2_empty_n)
    begin
        if ((not(((ap_start = ap_const_logic_0) or (img_2_empty_n = ap_const_logic_0) or (img_1_empty_n = ap_const_logic_0) or (ap_done_reg = ap_const_logic_1))) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
            img_2_read <= ap_const_logic_1;
        else 
            img_2_read <= ap_const_logic_0;
        end if; 
    end process;


    img_data_read_assign_proc : process(cmp91_reg_209, grp_xfMat2AXIvideo_24_16_1080_1920_1_2_Pipeline_loop_col_mat2axi_fu_100_img_data_read, ap_CS_fsm_state3)
    begin
        if (((cmp91_reg_209 = ap_const_lv1_0) and (ap_const_logic_1 = ap_CS_fsm_state3))) then 
            img_data_read <= grp_xfMat2AXIvideo_24_16_1080_1920_1_2_Pipeline_loop_col_mat2axi_fu_100_img_data_read;
        else 
            img_data_read <= ap_const_logic_0;
        end if; 
    end process;

    sub_fu_131_p2 <= std_logic_vector(unsigned(cols_cast_cast_cast_cast_cast_cast_fu_127_p1) + unsigned(ap_const_lv12_FFF));
    vstream_TVALID <= regslice_both_vstream_V_data_V_U_vld_out;
    vstream_TVALID_int_regslice <= grp_xfMat2AXIvideo_24_16_1080_1920_1_2_Pipeline_loop_col_mat2axi_fu_100_vstream_TVALID;
end behav;