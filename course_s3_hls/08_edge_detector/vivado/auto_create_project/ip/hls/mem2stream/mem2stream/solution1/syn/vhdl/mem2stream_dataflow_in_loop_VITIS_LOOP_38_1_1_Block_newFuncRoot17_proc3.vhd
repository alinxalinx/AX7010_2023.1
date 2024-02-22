-- ==============================================================
-- Generated by Vitis HLS v2023.1
-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
-- ==============================================================

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity mem2stream_dataflow_in_loop_VITIS_LOOP_38_1_1_Block_newFuncRoot17_proc3 is
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
end;


architecture behav of mem2stream_dataflow_in_loop_VITIS_LOOP_38_1_1_Block_newFuncRoot17_proc3 is 
    constant ap_const_logic_1 : STD_LOGIC := '1';
    constant ap_const_logic_0 : STD_LOGIC := '0';
    constant ap_ST_fsm_state1 : STD_LOGIC_VECTOR (1 downto 0) := "01";
    constant ap_ST_fsm_state2 : STD_LOGIC_VECTOR (1 downto 0) := "10";
    constant ap_const_lv32_0 : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000000";
    constant ap_const_boolean_1 : BOOLEAN := true;
    constant ap_const_lv32_1 : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000001";
    constant ap_const_lv32_2 : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000010";
    constant ap_const_lv32_1F : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000011111";
    constant ap_const_lv30_0 : STD_LOGIC_VECTOR (29 downto 0) := "000000000000000000000000000000";

attribute shreg_extract : string;
    signal ap_done_reg : STD_LOGIC := '0';
    signal ap_CS_fsm : STD_LOGIC_VECTOR (1 downto 0) := "01";
    attribute fsm_encoding : string;
    attribute fsm_encoding of ap_CS_fsm : signal is "none";
    signal ap_CS_fsm_state1 : STD_LOGIC;
    attribute fsm_encoding of ap_CS_fsm_state1 : signal is "none";
    signal ap_block_state1 : BOOLEAN;
    signal zext_ln42_fu_61_p1 : STD_LOGIC_VECTOR (63 downto 0);
    signal ap_CS_fsm_state2 : STD_LOGIC;
    attribute fsm_encoding of ap_CS_fsm_state2 : signal is "none";
    signal p_cast16_loc_i_i_0_cast_cast_cast_fu_66_p1 : STD_LOGIC_VECTOR (10 downto 0);
    signal p_cast16_loc_i_i_0_cast_cast_cast_cast_fu_70_p1 : STD_LOGIC_VECTOR (31 downto 0);
    signal ap_return_0_preg : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000000";
    signal ap_return_1_preg : STD_LOGIC_VECTOR (29 downto 0) := "000000000000000000000000000000";
    signal ap_NS_fsm : STD_LOGIC_VECTOR (1 downto 0);
    signal ap_ST_fsm_state1_blk : STD_LOGIC;
    signal ap_ST_fsm_state2_blk : STD_LOGIC;
    signal ap_ce_reg : STD_LOGIC;


begin




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
                elsif ((ap_const_logic_1 = ap_CS_fsm_state2)) then 
                    ap_done_reg <= ap_const_logic_1;
                end if; 
            end if;
        end if;
    end process;


    ap_return_0_preg_assign_proc : process(ap_clk)
    begin
        if (ap_clk'event and ap_clk =  '1') then
            if (ap_rst = '1') then
                ap_return_0_preg(0) <= '0';
                ap_return_0_preg(1) <= '0';
                ap_return_0_preg(2) <= '0';
                ap_return_0_preg(3) <= '0';
                ap_return_0_preg(4) <= '0';
                ap_return_0_preg(5) <= '0';
                ap_return_0_preg(6) <= '0';
                ap_return_0_preg(7) <= '0';
                ap_return_0_preg(8) <= '0';
                ap_return_0_preg(9) <= '0';
                ap_return_0_preg(10) <= '0';
            else
                if ((ap_const_logic_1 = ap_CS_fsm_state2)) then 
                                        ap_return_0_preg(10 downto 0) <= p_cast16_loc_i_i_0_cast_cast_cast_cast_fu_70_p1(10 downto 0);
                end if; 
            end if;
        end if;
    end process;


    ap_return_1_preg_assign_proc : process(ap_clk)
    begin
        if (ap_clk'event and ap_clk =  '1') then
            if (ap_rst = '1') then
                ap_return_1_preg <= ap_const_lv30_0;
            else
                if ((ap_const_logic_1 = ap_CS_fsm_state2)) then 
                    ap_return_1_preg <= baseAddr_q0(31 downto 2);
                end if; 
            end if;
        end if;
    end process;

    ap_return_0_preg(31 downto 11) <= "000000000000000000000";

    ap_NS_fsm_assign_proc : process (ap_start, ap_done_reg, ap_CS_fsm, ap_CS_fsm_state1)
    begin
        case ap_CS_fsm is
            when ap_ST_fsm_state1 => 
                if ((not(((ap_start = ap_const_logic_0) or (ap_done_reg = ap_const_logic_1))) and (ap_const_logic_1 = ap_CS_fsm_state1))) then
                    ap_NS_fsm <= ap_ST_fsm_state2;
                else
                    ap_NS_fsm <= ap_ST_fsm_state1;
                end if;
            when ap_ST_fsm_state2 => 
                ap_NS_fsm <= ap_ST_fsm_state1;
            when others =>  
                ap_NS_fsm <= "XX";
        end case;
    end process;
    ap_CS_fsm_state1 <= ap_CS_fsm(0);
    ap_CS_fsm_state2 <= ap_CS_fsm(1);

    ap_ST_fsm_state1_blk_assign_proc : process(ap_start, ap_done_reg)
    begin
        if (((ap_start = ap_const_logic_0) or (ap_done_reg = ap_const_logic_1))) then 
            ap_ST_fsm_state1_blk <= ap_const_logic_1;
        else 
            ap_ST_fsm_state1_blk <= ap_const_logic_0;
        end if; 
    end process;

    ap_ST_fsm_state2_blk <= ap_const_logic_0;

    ap_block_state1_assign_proc : process(ap_start, ap_done_reg)
    begin
                ap_block_state1 <= ((ap_start = ap_const_logic_0) or (ap_done_reg = ap_const_logic_1));
    end process;


    ap_done_assign_proc : process(ap_done_reg, ap_CS_fsm_state2)
    begin
        if ((ap_const_logic_1 = ap_CS_fsm_state2)) then 
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


    ap_ready_assign_proc : process(ap_CS_fsm_state2)
    begin
        if ((ap_const_logic_1 = ap_CS_fsm_state2)) then 
            ap_ready <= ap_const_logic_1;
        else 
            ap_ready <= ap_const_logic_0;
        end if; 
    end process;


    ap_return_0_assign_proc : process(ap_CS_fsm_state2, p_cast16_loc_i_i_0_cast_cast_cast_cast_fu_70_p1, ap_return_0_preg)
    begin
        if ((ap_const_logic_1 = ap_CS_fsm_state2)) then 
            ap_return_0 <= p_cast16_loc_i_i_0_cast_cast_cast_cast_fu_70_p1;
        else 
            ap_return_0 <= ap_return_0_preg;
        end if; 
    end process;


    ap_return_1_assign_proc : process(baseAddr_q0, ap_CS_fsm_state2, ap_return_1_preg)
    begin
        if ((ap_const_logic_1 = ap_CS_fsm_state2)) then 
            ap_return_1 <= baseAddr_q0(31 downto 2);
        else 
            ap_return_1 <= ap_return_1_preg;
        end if; 
    end process;

    baseAddr_address0 <= zext_ln42_fu_61_p1(2 - 1 downto 0);

    baseAddr_ce0_assign_proc : process(ap_start, ap_done_reg, ap_CS_fsm_state1)
    begin
        if ((not(((ap_start = ap_const_logic_0) or (ap_done_reg = ap_const_logic_1))) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
            baseAddr_ce0 <= ap_const_logic_1;
        else 
            baseAddr_ce0 <= ap_const_logic_0;
        end if; 
    end process;

    p_cast16_loc_i_i_0_cast_cast_cast_cast_fu_70_p1 <= std_logic_vector(IEEE.numeric_std.resize(unsigned(p_cast16_loc_i_i_0_cast_cast_cast_fu_66_p1),32));
        p_cast16_loc_i_i_0_cast_cast_cast_fu_66_p1 <= std_logic_vector(IEEE.numeric_std.resize(signed(p_read),11));

    zext_ln42_fu_61_p1 <= std_logic_vector(IEEE.numeric_std.resize(unsigned(index),64));
end behav;