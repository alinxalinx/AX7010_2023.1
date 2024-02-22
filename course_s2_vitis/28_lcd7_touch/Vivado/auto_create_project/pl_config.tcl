#////////////////////////////////////////////////////////////////////////////////
#  project：lcd7_touch                                                         //
#                                                                              //
#  Author: JunFN                                                               //
#          853808728@qq.com                                                    //
#          ALINX(shanghai) Technology Co.,Ltd                                  //
#          黑金                                                                //
#     WEB: http://www.alinx.cn/                                                //
#                                                                              //
#////////////////////////////////////////////////////////////////////////////////
#                                                                              //
# Copyright (c) 2017,ALINX(shanghai) Technology Co.,Ltd                        //
#                    All rights reserved                                       //
#                                                                              //
# This source file may be used and distributed without restriction provided    //
# that this copyright statement is not removed from the file and that any      //
# derivative work contains the original copyright notice and the associated    //
# disclaimer.                                                                  //
#                                                                              // 
#////////////////////////////////////////////////////////////////////////////////

#================================================================================
#  Revision History:
#  Date          By            Revision    Change Description
# --------------------------------------------------------------------------------
#  2023/8/22                   1.0          Original
#=================================================================================

# Create interface ports
set DDR [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 DDR ]
set FIXED_IO [ create_bd_intf_port -mode Master -vlnv xilinx.com:display_processing_system7:fixedio_rtl:1.0 FIXED_IO ]
set lcd_i2c [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 lcd_i2c ]


# Create ports
set lcd_data [ create_bd_port -dir O -from 23 -to 0 lcd_data ]
set lcd_de [ create_bd_port -dir O lcd_de ]
set lcd_hsync [ create_bd_port -dir O lcd_hsync ]
set lcd_vsync [ create_bd_port -dir O lcd_vsync ]
set lcd_dclk [ create_bd_port -dir O lcd_dclk ]
set lcd_bl_pwm [ create_bd_port -dir O lcd_bl_pwm ]
set lcd_intr [ create_bd_port -dir I lcd_intr ]

# Create instance: ax_pwm_0, and set properties
set ax_pwm_0 [ create_bd_cell -type ip -vlnv xilinx.com:user:ax_pwm:1.0 ax_pwm_0 ]

# Create instance: axi_dynclk_0, and set properties
set axi_dynclk_0 [ create_bd_cell -type ip -vlnv digilentinc.com:ip:axi_dynclk:1.0 axi_dynclk_0 ]

# Create instance: proc_sys_reset_0, and set properties
set proc_sys_reset_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0 ]

# Create instance: proc_sys_reset_1, and set properties
set proc_sys_reset_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_1 ]

# Create instance: util_reduced_logic_0, and set properties
set util_reduced_logic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_reduced_logic:2.0 util_reduced_logic_0 ]
set_property CONFIG.C_SIZE {1} $util_reduced_logic_0


# Create instance: axi_mem_intercon, and set properties
set axi_mem_intercon [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_mem_intercon ]
set_property -dict [list \
  CONFIG.NUM_MI {1} \
  CONFIG.SYNCHRONIZATION_STAGES {2} \
] $axi_mem_intercon


# Create instance: axi_vdma_0, and set properties
set axi_vdma_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vdma:6.3 axi_vdma_0 ]
set_property -dict [list \
  CONFIG.c_include_mm2s_dre {1} \
  CONFIG.c_include_s2mm {0} \
  CONFIG.c_m_axis_mm2s_tdata_width {24} \
  CONFIG.c_mm2s_genlock_mode {0} \
  CONFIG.c_mm2s_linebuffer_depth {512} \
  CONFIG.c_mm2s_max_burst_length {32} \
  CONFIG.c_num_fstores {1} \
] $axi_vdma_0


# Create instance: processing_system7_0_axi_periph, and set properties
set processing_system7_0_axi_periph [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 processing_system7_0_axi_periph ]
set_property -dict [list \
  CONFIG.NUM_MI {4} \
  CONFIG.SYNCHRONIZATION_STAGES {2} \
] $processing_system7_0_axi_periph


# Create instance: util_vector_logic_1, and set properties
set util_vector_logic_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_1 ]
set_property -dict [list \
  CONFIG.C_OPERATION {not} \
  CONFIG.C_SIZE {1} \
] $util_vector_logic_1


# Create instance: v_axi4s_vid_out_0, and set properties
set v_axi4s_vid_out_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_axi4s_vid_out:4.0 v_axi4s_vid_out_0 ]
set_property -dict [list \
  CONFIG.C_ADDR_WIDTH {12} \
  CONFIG.C_HAS_ASYNC_CLK {1} \
  CONFIG.C_S_AXIS_VIDEO_DATA_WIDTH {8} \
  CONFIG.C_S_AXIS_VIDEO_FORMAT {2} \
  CONFIG.C_VTG_MASTER_SLAVE {1} \
] $v_axi4s_vid_out_0


# Create instance: v_tc_0, and set properties
set v_tc_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_tc:6.2 v_tc_0 ]
set_property CONFIG.enable_detection {false} $v_tc_0


# Create instance: xlconcat_0, and set properties
set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
set_property CONFIG.NUM_PORTS {3} $xlconcat_0


# Create interface connections
connect_bd_intf_net -intf_net axi_mem_intercon_M00_AXI [get_bd_intf_pins axi_mem_intercon/M00_AXI] [get_bd_intf_pins processing_system7_0/S_AXI_HP0]
connect_bd_intf_net -intf_net axi_vdma_0_M_AXIS_MM2S [get_bd_intf_pins axi_vdma_0/M_AXIS_MM2S] [get_bd_intf_pins v_axi4s_vid_out_0/video_in]
connect_bd_intf_net -intf_net axi_vdma_0_M_AXI_MM2S [get_bd_intf_pins axi_vdma_0/M_AXI_MM2S] [get_bd_intf_pins axi_mem_intercon/S00_AXI]
connect_bd_intf_net -intf_net processing_system7_0_DDR [get_bd_intf_ports DDR] [get_bd_intf_pins processing_system7_0/DDR]
connect_bd_intf_net -intf_net processing_system7_0_FIXED_IO [get_bd_intf_ports FIXED_IO] [get_bd_intf_pins processing_system7_0/FIXED_IO]
connect_bd_intf_net -intf_net processing_system7_0_IIC_0 [get_bd_intf_ports lcd_i2c] [get_bd_intf_pins processing_system7_0/IIC_0]
connect_bd_intf_net -intf_net processing_system7_0_M_AXI_GP0 [get_bd_intf_pins processing_system7_0/M_AXI_GP0] [get_bd_intf_pins processing_system7_0_axi_periph/S00_AXI]
connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M00_AXI [get_bd_intf_pins processing_system7_0_axi_periph/M00_AXI] [get_bd_intf_pins axi_vdma_0/S_AXI_LITE]
connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M01_AXI [get_bd_intf_pins processing_system7_0_axi_periph/M01_AXI] [get_bd_intf_pins v_tc_0/ctrl]
connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M02_AXI [get_bd_intf_pins processing_system7_0_axi_periph/M02_AXI] [get_bd_intf_pins axi_dynclk_0/s00_axi]
connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M03_AXI [get_bd_intf_pins processing_system7_0_axi_periph/M03_AXI] [get_bd_intf_pins ax_pwm_0/S00_AXI]
connect_bd_intf_net -intf_net v_tc_0_vtiming_out [get_bd_intf_pins v_tc_0/vtiming_out] [get_bd_intf_pins v_axi4s_vid_out_0/vtiming_in]

# Create port connections
connect_bd_net -net ax_pwm_0_pwm [get_bd_pins ax_pwm_0/pwm] [get_bd_ports lcd_bl_pwm]
connect_bd_net -net axi_dynclk_0_PXL_CLK_O1 [get_bd_pins axi_dynclk_0/PXL_CLK_O] [get_bd_pins v_axi4s_vid_out_0/vid_io_out_clk] [get_bd_pins v_tc_0/clk] [get_bd_pins util_reduced_logic_0/Op1]
connect_bd_net -net axi_vdma_0_mm2s_introut [get_bd_pins axi_vdma_0/mm2s_introut] [get_bd_pins xlconcat_0/In1]
connect_bd_net -net lcd_intr_1 [get_bd_ports lcd_intr] [get_bd_pins util_vector_logic_1/Op1]
connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins ax_pwm_0/s00_axi_aclk] [get_bd_pins axi_dynclk_0/REF_CLK_I] [get_bd_pins axi_dynclk_0/s00_axi_aclk] [get_bd_pins processing_system7_0/M_AXI_GP0_ACLK] [get_bd_pins proc_sys_reset_0/slowest_sync_clk] [get_bd_pins axi_vdma_0/s_axi_lite_aclk] [get_bd_pins processing_system7_0_axi_periph/ACLK] [get_bd_pins processing_system7_0_axi_periph/S00_ACLK] [get_bd_pins processing_system7_0_axi_periph/M00_ACLK] [get_bd_pins processing_system7_0_axi_periph/M01_ACLK] [get_bd_pins processing_system7_0_axi_periph/M02_ACLK] [get_bd_pins processing_system7_0_axi_periph/M03_ACLK] [get_bd_pins v_tc_0/s_axi_aclk]
connect_bd_net -net processing_system7_0_FCLK_CLK1 [get_bd_pins processing_system7_0/FCLK_CLK1] [get_bd_pins processing_system7_0/S_AXI_HP0_ACLK] [get_bd_pins proc_sys_reset_1/slowest_sync_clk] [get_bd_pins axi_mem_intercon/ACLK] [get_bd_pins axi_mem_intercon/S00_ACLK] [get_bd_pins axi_mem_intercon/M00_ACLK] [get_bd_pins axi_vdma_0/m_axi_mm2s_aclk] [get_bd_pins axi_vdma_0/m_axis_mm2s_aclk] [get_bd_pins v_axi4s_vid_out_0/aclk]
connect_bd_net -net processing_system7_0_FCLK_RESET0_N [get_bd_pins processing_system7_0/FCLK_RESET0_N] [get_bd_pins proc_sys_reset_0/ext_reset_in] [get_bd_pins proc_sys_reset_1/ext_reset_in]
connect_bd_net -net rst_processing_system7_0_100M_interconnect_aresetn [get_bd_pins proc_sys_reset_0/interconnect_aresetn] [get_bd_pins processing_system7_0_axi_periph/ARESETN]
connect_bd_net -net rst_processing_system7_0_100M_peripheral_aresetn [get_bd_pins proc_sys_reset_0/peripheral_aresetn] [get_bd_pins ax_pwm_0/s00_axi_aresetn] [get_bd_pins axi_dynclk_0/s00_axi_aresetn] [get_bd_pins axi_vdma_0/axi_resetn] [get_bd_pins processing_system7_0_axi_periph/S00_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M00_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M01_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M02_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M03_ARESETN] [get_bd_pins v_tc_0/s_axi_aresetn]
connect_bd_net -net rst_processing_system7_0_140M_interconnect_aresetn [get_bd_pins proc_sys_reset_1/interconnect_aresetn] [get_bd_pins axi_mem_intercon/ARESETN]
connect_bd_net -net rst_processing_system7_0_140M_peripheral_aresetn [get_bd_pins proc_sys_reset_1/peripheral_aresetn] [get_bd_pins axi_mem_intercon/S00_ARESETN] [get_bd_pins axi_mem_intercon/M00_ARESETN]
connect_bd_net -net util_reduced_logic_0_Res [get_bd_pins util_reduced_logic_0/Res] [get_bd_ports lcd_dclk]
connect_bd_net -net util_vector_logic_1_Res [get_bd_pins util_vector_logic_1/Res] [get_bd_pins xlconcat_0/In2]
connect_bd_net -net v_axi4s_vid_out_0_vid_active_video [get_bd_pins v_axi4s_vid_out_0/vid_active_video] [get_bd_ports lcd_de]
connect_bd_net -net v_axi4s_vid_out_0_vid_data [get_bd_pins v_axi4s_vid_out_0/vid_data] [get_bd_ports lcd_data]
connect_bd_net -net v_axi4s_vid_out_0_vid_hsync [get_bd_pins v_axi4s_vid_out_0/vid_hsync] [get_bd_ports lcd_hsync]
connect_bd_net -net v_axi4s_vid_out_0_vid_vsync [get_bd_pins v_axi4s_vid_out_0/vid_vsync] [get_bd_ports lcd_vsync]
connect_bd_net -net v_axi4s_vid_out_0_vtg_ce [get_bd_pins v_axi4s_vid_out_0/vtg_ce] [get_bd_pins v_tc_0/gen_clken]
connect_bd_net -net v_tc_0_irq [get_bd_pins v_tc_0/irq] [get_bd_pins xlconcat_0/In0]
connect_bd_net -net xlconcat_0_dout [get_bd_pins xlconcat_0/dout] [get_bd_pins processing_system7_0/IRQ_F2P]

# Create address segments
assign_bd_address -offset 0x43C20000 -range 0x00010000 -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs ax_pwm_0/S00_AXI/S00_AXI_reg] -force
assign_bd_address -offset 0x43C10000 -range 0x00010000 -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_dynclk_0/s00_axi/reg0] -force
assign_bd_address -offset 0x43000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_vdma_0/S_AXI_LITE/Reg] -force
assign_bd_address -offset 0x43C00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs v_tc_0/ctrl/Reg] -force
assign_bd_address -offset 0x00000000 -range 0x40000000 -target_address_space [get_bd_addr_spaces axi_vdma_0/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_DDR_LOWOCM] -force
