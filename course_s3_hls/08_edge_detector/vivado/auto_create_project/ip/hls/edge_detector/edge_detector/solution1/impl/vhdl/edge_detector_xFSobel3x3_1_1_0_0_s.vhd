-- ==============================================================
-- Generated by Vitis HLS v2023.1
-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
-- ==============================================================

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity edge_detector_xFSobel3x3_1_1_0_0_s is
port (
    ap_clk : IN STD_LOGIC;
    ap_rst : IN STD_LOGIC;
    src_buf1_0_val : IN STD_LOGIC_VECTOR (7 downto 0);
    src_buf1_1_val : IN STD_LOGIC_VECTOR (7 downto 0);
    src_buf1_2_val : IN STD_LOGIC_VECTOR (7 downto 0);
    src_buf2_0_val : IN STD_LOGIC_VECTOR (7 downto 0);
    src_buf2_2_val : IN STD_LOGIC_VECTOR (7 downto 0);
    src_buf3_0_val : IN STD_LOGIC_VECTOR (7 downto 0);
    src_buf3_1_val : IN STD_LOGIC_VECTOR (7 downto 0);
    src_buf3_2_val : IN STD_LOGIC_VECTOR (7 downto 0);
    ap_return_0 : OUT STD_LOGIC_VECTOR (7 downto 0);
    ap_return_1 : OUT STD_LOGIC_VECTOR (7 downto 0);
    ap_ce : IN STD_LOGIC );
end;


architecture behav of edge_detector_xFSobel3x3_1_1_0_0_s is 
    constant ap_const_logic_1 : STD_LOGIC := '1';
    constant ap_const_logic_0 : STD_LOGIC := '0';
    constant ap_const_boolean_1 : BOOLEAN := true;
    constant ap_const_boolean_0 : BOOLEAN := false;

attribute shreg_extract : string;
    signal GradientvaluesX_xFGradientX3x3_0_0_s_fu_72_ap_return : STD_LOGIC_VECTOR (7 downto 0);
    signal GradientvaluesX_reg_115 : STD_LOGIC_VECTOR (7 downto 0);
    signal ap_block_state1_pp0_stage0_iter0 : BOOLEAN;
    signal ap_block_state2_pp0_stage0_iter1 : BOOLEAN;
    signal ap_block_pp0_stage0_11001 : BOOLEAN;
    signal GradientvaluesX_xFGradientX3x3_0_0_s_fu_72_ap_ready : STD_LOGIC;
    signal grp_xFGradientY3x3_0_0_s_fu_88_ap_return : STD_LOGIC_VECTOR (7 downto 0);
    signal grp_xFGradientY3x3_0_0_s_fu_88_ap_ce : STD_LOGIC;
    signal ap_block_state1_pp0_stage0_iter0_ignore_call9 : BOOLEAN;
    signal ap_block_state2_pp0_stage0_iter1_ignore_call9 : BOOLEAN;
    signal ap_block_pp0_stage0_11001_ignoreCallOp12 : BOOLEAN;
    signal ap_block_pp0_stage0 : BOOLEAN;
    signal ap_ce_reg : STD_LOGIC;
    signal ap_return_0_int_reg : STD_LOGIC_VECTOR (7 downto 0);
    signal ap_return_1_int_reg : STD_LOGIC_VECTOR (7 downto 0);

    component edge_detector_xFGradientX3x3_0_0_s IS
    port (
        ap_ready : OUT STD_LOGIC;
        t0_val : IN STD_LOGIC_VECTOR (7 downto 0);
        t2_val : IN STD_LOGIC_VECTOR (7 downto 0);
        m0_val : IN STD_LOGIC_VECTOR (7 downto 0);
        m2_val : IN STD_LOGIC_VECTOR (7 downto 0);
        b0_val : IN STD_LOGIC_VECTOR (7 downto 0);
        b2_val : IN STD_LOGIC_VECTOR (7 downto 0);
        ap_return : OUT STD_LOGIC_VECTOR (7 downto 0) );
    end component;


    component edge_detector_xFGradientY3x3_0_0_s IS
    port (
        ap_clk : IN STD_LOGIC;
        ap_rst : IN STD_LOGIC;
        t0_val : IN STD_LOGIC_VECTOR (7 downto 0);
        t1_val : IN STD_LOGIC_VECTOR (7 downto 0);
        t2_val : IN STD_LOGIC_VECTOR (7 downto 0);
        b0_val : IN STD_LOGIC_VECTOR (7 downto 0);
        b1_val : IN STD_LOGIC_VECTOR (7 downto 0);
        b2_val : IN STD_LOGIC_VECTOR (7 downto 0);
        ap_return : OUT STD_LOGIC_VECTOR (7 downto 0);
        ap_ce : IN STD_LOGIC );
    end component;



begin
    GradientvaluesX_xFGradientX3x3_0_0_s_fu_72 : component edge_detector_xFGradientX3x3_0_0_s
    port map (
        ap_ready => GradientvaluesX_xFGradientX3x3_0_0_s_fu_72_ap_ready,
        t0_val => src_buf1_0_val,
        t2_val => src_buf1_2_val,
        m0_val => src_buf2_0_val,
        m2_val => src_buf2_2_val,
        b0_val => src_buf3_0_val,
        b2_val => src_buf3_2_val,
        ap_return => GradientvaluesX_xFGradientX3x3_0_0_s_fu_72_ap_return);

    grp_xFGradientY3x3_0_0_s_fu_88 : component edge_detector_xFGradientY3x3_0_0_s
    port map (
        ap_clk => ap_clk,
        ap_rst => ap_rst,
        t0_val => src_buf1_0_val,
        t1_val => src_buf1_1_val,
        t2_val => src_buf1_2_val,
        b0_val => src_buf3_0_val,
        b1_val => src_buf3_1_val,
        b2_val => src_buf3_2_val,
        ap_return => grp_xFGradientY3x3_0_0_s_fu_88_ap_return,
        ap_ce => grp_xFGradientY3x3_0_0_s_fu_88_ap_ce);





    ap_ce_reg_assign_proc : process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            ap_ce_reg <= ap_ce;
        end if;
    end process;
    process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if (((ap_const_logic_1 = ap_const_logic_1) and (ap_const_boolean_0 = ap_block_pp0_stage0_11001))) then
                GradientvaluesX_reg_115 <= GradientvaluesX_xFGradientX3x3_0_0_s_fu_72_ap_return;
            end if;
        end if;
    end process;
    process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if ((ap_const_logic_1 = ap_ce_reg)) then
                ap_return_0_int_reg <= GradientvaluesX_reg_115;
                ap_return_1_int_reg <= grp_xFGradientY3x3_0_0_s_fu_88_ap_return;
            end if;
        end if;
    end process;
        ap_block_pp0_stage0 <= not((ap_const_boolean_1 = ap_const_boolean_1));
        ap_block_pp0_stage0_11001 <= not((ap_const_boolean_1 = ap_const_boolean_1));
        ap_block_pp0_stage0_11001_ignoreCallOp12 <= not((ap_const_boolean_1 = ap_const_boolean_1));
        ap_block_state1_pp0_stage0_iter0 <= not((ap_const_boolean_1 = ap_const_boolean_1));
        ap_block_state1_pp0_stage0_iter0_ignore_call9 <= not((ap_const_boolean_1 = ap_const_boolean_1));
        ap_block_state2_pp0_stage0_iter1 <= not((ap_const_boolean_1 = ap_const_boolean_1));
        ap_block_state2_pp0_stage0_iter1_ignore_call9 <= not((ap_const_boolean_1 = ap_const_boolean_1));

    ap_return_0_assign_proc : process(GradientvaluesX_reg_115, ap_ce_reg, ap_return_0_int_reg)
    begin
        if ((ap_const_logic_0 = ap_ce_reg)) then 
            ap_return_0 <= ap_return_0_int_reg;
        elsif ((ap_const_logic_1 = ap_ce_reg)) then 
            ap_return_0 <= GradientvaluesX_reg_115;
        else 
            ap_return_0 <= "XXXXXXXX";
        end if; 
    end process;


    ap_return_1_assign_proc : process(grp_xFGradientY3x3_0_0_s_fu_88_ap_return, ap_ce_reg, ap_return_1_int_reg)
    begin
        if ((ap_const_logic_0 = ap_ce_reg)) then 
            ap_return_1 <= ap_return_1_int_reg;
        elsif ((ap_const_logic_1 = ap_ce_reg)) then 
            ap_return_1 <= grp_xFGradientY3x3_0_0_s_fu_88_ap_return;
        else 
            ap_return_1 <= "XXXXXXXX";
        end if; 
    end process;


    grp_xFGradientY3x3_0_0_s_fu_88_ap_ce_assign_proc : process(ap_block_pp0_stage0_11001_ignoreCallOp12)
    begin
        if (((ap_const_logic_1 = ap_const_logic_1) and (ap_const_boolean_0 = ap_block_pp0_stage0_11001_ignoreCallOp12))) then 
            grp_xFGradientY3x3_0_0_s_fu_88_ap_ce <= ap_const_logic_1;
        else 
            grp_xFGradientY3x3_0_0_s_fu_88_ap_ce <= ap_const_logic_0;
        end if; 
    end process;

end behav;
