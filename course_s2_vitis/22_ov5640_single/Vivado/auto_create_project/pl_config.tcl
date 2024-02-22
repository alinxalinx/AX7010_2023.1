#////////////////////////////////////////////////////////////////////////////////
#  project：ov5640_single                                                      //
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
set TMDS [ create_bd_intf_port -mode Master -vlnv digilentinc.com:interface:tmds_rtl:1.0 TMDS ]
set cmos1_i2c [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 cmos1_i2c ]
set cmos_rstn [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 cmos_rstn ]


# Create ports
set cmos1_d [ create_bd_port -dir I -from 9 -to 0 cmos1_d ]
set cmos1_href [ create_bd_port -dir I cmos1_href ]
set cmos1_pclk [ create_bd_port -dir I cmos1_pclk ]
set cmos1_vsync [ create_bd_port -dir I cmos1_vsync ]
set hdmi_oen [ create_bd_port -dir O hdmi_oen ]

# Create instance: axi_dynclk_0, and set properties
set axi_dynclk_0 [ create_bd_cell -type ip -vlnv digilentinc.com:ip:axi_dynclk:1.0 axi_dynclk_0 ]

# Create instance: rgb2dvi_0, and set properties
set rgb2dvi_0 [ create_bd_cell -type ip -vlnv digilentinc.com:ip:rgb2dvi:1.3 rgb2dvi_0 ]

# Create instance: rst_processing_system7_0_100M, and set properties
set rst_processing_system7_0_100M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_processing_system7_0_100M ]

# Create instance: rst_processing_system7_0_150M, and set properties
set rst_processing_system7_0_150M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_processing_system7_0_150M ]

# Create instance: alinx_ov5640_0, and set properties
set alinx_ov5640_0 [ create_bd_cell -type ip -vlnv www.alinx.com.cn:user:alinx_ov5640:5.4 alinx_ov5640_0 ]

# Create instance: cmos_rst, and set properties
set cmos_rst [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 cmos_rst ]
set_property -dict [list \
  CONFIG.C_ALL_OUTPUTS {1} \
  CONFIG.C_GPIO_WIDTH {1} \
] $cmos_rst


# Create instance: axi_mem_intercon, and set properties
set axi_mem_intercon [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_mem_intercon ]
set_property -dict [list \
  CONFIG.NUM_MI {1} \
  CONFIG.NUM_SI {2} \
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
  CONFIG.c_mm2s_max_burst_length {128} \
  CONFIG.c_num_fstores {1} \
] $axi_vdma_0


# Create instance: axi_vdma_1, and set properties
set axi_vdma_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vdma:6.3 axi_vdma_1 ]
set_property -dict [list \
  CONFIG.c_include_mm2s {0} \
  CONFIG.c_include_s2mm_dre {1} \
  CONFIG.c_m_axi_s2mm_data_width {64} \
  CONFIG.c_num_fstores {1} \
  CONFIG.c_s2mm_genlock_mode {0} \
  CONFIG.c_s2mm_linebuffer_depth {4096} \
  CONFIG.c_s2mm_max_burst_length {128} \
  CONFIG.c_use_s2mm_fsync {2} \
] $axi_vdma_1


# Create instance: axis_subset_converter_0, and set properties
set axis_subset_converter_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_subset_converter:1.1 axis_subset_converter_0 ]
set_property -dict [list \
  CONFIG.M_HAS_TKEEP {1} \
  CONFIG.M_HAS_TLAST {1} \
  CONFIG.M_TDATA_NUM_BYTES {3} \
  CONFIG.M_TUSER_WIDTH {1} \
  CONFIG.S_HAS_TKEEP {1} \
  CONFIG.S_HAS_TLAST {1} \
  CONFIG.S_TDATA_NUM_BYTES {2} \
  CONFIG.S_TUSER_WIDTH {1} \
  CONFIG.TDATA_REMAP {tdata[4:0],3'b000,tdata[10:5],2'b00,tdata[15:11],3'b000} \
  CONFIG.TKEEP_REMAP {1'b1,tkeep[1:0]} \
  CONFIG.TLAST_REMAP {tlast[0]} \
  CONFIG.TUSER_REMAP {tuser[0:0]} \
 ] $axis_subset_converter_0

# Create instance: processing_system7_0_axi_periph, and set properties
set processing_system7_0_axi_periph [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 processing_system7_0_axi_periph ]
set_property -dict [list \
  CONFIG.NUM_MI {5} \
  CONFIG.SYNCHRONIZATION_STAGES {2} \
] $processing_system7_0_axi_periph


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
set_property CONFIG.NUM_PORTS {2} $xlconcat_0


# Create instance: xlconstant_1, and set properties
set xlconstant_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_1 ]

# Create interface connections
connect_bd_intf_net -intf_net alinx_ov5640_0_m_axis_video [get_bd_intf_pins axis_subset_converter_0/S_AXIS] [get_bd_intf_pins alinx_ov5640_0/m_axis_video]
connect_bd_intf_net -intf_net axi_mem_intercon_M00_AXI [get_bd_intf_pins axi_mem_intercon/M00_AXI] [get_bd_intf_pins processing_system7_0/S_AXI_HP0]
connect_bd_intf_net -intf_net axi_vdma_0_M_AXIS_MM2S [get_bd_intf_pins axi_vdma_0/M_AXIS_MM2S] [get_bd_intf_pins v_axi4s_vid_out_0/video_in]
connect_bd_intf_net -intf_net axi_vdma_0_M_AXI_MM2S [get_bd_intf_pins axi_mem_intercon/S00_AXI] [get_bd_intf_pins axi_vdma_0/M_AXI_MM2S]
connect_bd_intf_net -intf_net axi_vdma_1_M_AXI_S2MM [get_bd_intf_pins axi_mem_intercon/S01_AXI] [get_bd_intf_pins axi_vdma_1/M_AXI_S2MM]
connect_bd_intf_net -intf_net axis_subset_converter_0_M_AXIS [get_bd_intf_pins axis_subset_converter_0/M_AXIS] [get_bd_intf_pins axi_vdma_1/S_AXIS_S2MM]
connect_bd_intf_net -intf_net coms_rst_GPIO [get_bd_intf_ports cmos_rstn] [get_bd_intf_pins cmos_rst/GPIO]
connect_bd_intf_net -intf_net processing_system7_0_DDR [get_bd_intf_ports DDR] [get_bd_intf_pins processing_system7_0/DDR]
connect_bd_intf_net -intf_net processing_system7_0_FIXED_IO [get_bd_intf_ports FIXED_IO] [get_bd_intf_pins processing_system7_0/FIXED_IO]
connect_bd_intf_net -intf_net processing_system7_0_IIC_0 [get_bd_intf_ports cmos1_i2c] [get_bd_intf_pins processing_system7_0/IIC_0]
connect_bd_intf_net -intf_net processing_system7_0_M_AXI_GP0 [get_bd_intf_pins processing_system7_0/M_AXI_GP0] [get_bd_intf_pins processing_system7_0_axi_periph/S00_AXI]
connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M00_AXI [get_bd_intf_pins axi_vdma_0/S_AXI_LITE] [get_bd_intf_pins processing_system7_0_axi_periph/M00_AXI]
connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M01_AXI [get_bd_intf_pins processing_system7_0_axi_periph/M01_AXI] [get_bd_intf_pins v_tc_0/ctrl]
connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M02_AXI [get_bd_intf_pins axi_dynclk_0/s00_axi] [get_bd_intf_pins processing_system7_0_axi_periph/M02_AXI]
connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M03_AXI [get_bd_intf_pins axi_vdma_1/S_AXI_LITE] [get_bd_intf_pins processing_system7_0_axi_periph/M03_AXI]
connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M04_AXI [get_bd_intf_pins processing_system7_0_axi_periph/M04_AXI] [get_bd_intf_pins cmos_rst/S_AXI]
connect_bd_intf_net -intf_net rgb2dvi_0_TMDS [get_bd_intf_ports TMDS] [get_bd_intf_pins rgb2dvi_0/TMDS]
connect_bd_intf_net -intf_net v_axi4s_vid_out_0_vid_io_out [get_bd_intf_pins v_axi4s_vid_out_0/vid_io_out] [get_bd_intf_pins rgb2dvi_0/RGB]
connect_bd_intf_net -intf_net v_tc_0_vtiming_out [get_bd_intf_pins v_axi4s_vid_out_0/vtiming_in] [get_bd_intf_pins v_tc_0/vtiming_out]

# Create port connections
connect_bd_net -net axi_dynclk_0_LOCKED_O [get_bd_pins axi_dynclk_0/LOCKED_O] [get_bd_pins rgb2dvi_0/aRst_n]
connect_bd_net -net axi_dynclk_0_PXL_CLK_5X_O [get_bd_pins axi_dynclk_0/PXL_CLK_5X_O] [get_bd_pins rgb2dvi_0/SerialClk]
connect_bd_net -net axi_dynclk_0_PXL_CLK_O [get_bd_pins axi_dynclk_0/PXL_CLK_O] [get_bd_pins rgb2dvi_0/PixelClk] [get_bd_pins v_axi4s_vid_out_0/vid_io_out_clk] [get_bd_pins v_tc_0/clk]
connect_bd_net -net axi_vdma_0_mm2s_introut [get_bd_pins axi_vdma_0/mm2s_introut] [get_bd_pins xlconcat_0/In0]
connect_bd_net -net cmos_d_1 [get_bd_ports cmos1_d] [get_bd_pins alinx_ov5640_0/cmos_d]
connect_bd_net -net cmos_href_1 [get_bd_ports cmos1_href] [get_bd_pins alinx_ov5640_0/cmos_href]
connect_bd_net -net cmos_pclk_1 [get_bd_ports cmos1_pclk] [get_bd_pins alinx_ov5640_0/cmos_pclk]
connect_bd_net -net cmos_vsync_1 [get_bd_ports cmos1_vsync] [get_bd_pins alinx_ov5640_0/cmos_vsync]
connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins axi_dynclk_0/REF_CLK_I] [get_bd_pins axi_dynclk_0/s00_axi_aclk] [get_bd_pins processing_system7_0/M_AXI_GP0_ACLK] [get_bd_pins rst_processing_system7_0_100M/slowest_sync_clk] [get_bd_pins cmos_rst/s_axi_aclk] [get_bd_pins axi_vdma_0/s_axi_lite_aclk] [get_bd_pins axi_vdma_1/s_axi_lite_aclk] [get_bd_pins processing_system7_0_axi_periph/ACLK] [get_bd_pins processing_system7_0_axi_periph/S00_ACLK] [get_bd_pins processing_system7_0_axi_periph/M00_ACLK] [get_bd_pins processing_system7_0_axi_periph/M01_ACLK] [get_bd_pins processing_system7_0_axi_periph/M02_ACLK] [get_bd_pins processing_system7_0_axi_periph/M03_ACLK] [get_bd_pins processing_system7_0_axi_periph/M04_ACLK] [get_bd_pins v_tc_0/s_axi_aclk]
connect_bd_net -net processing_system7_0_FCLK_CLK1 [get_bd_pins processing_system7_0/FCLK_CLK1] [get_bd_pins processing_system7_0/S_AXI_HP0_ACLK] [get_bd_pins rst_processing_system7_0_150M/slowest_sync_clk] [get_bd_pins alinx_ov5640_0/m_axis_video_aclk] [get_bd_pins axi_mem_intercon/ACLK] [get_bd_pins axi_mem_intercon/S00_ACLK] [get_bd_pins axi_mem_intercon/S01_ACLK] [get_bd_pins axi_mem_intercon/M00_ACLK] [get_bd_pins axi_vdma_0/m_axi_mm2s_aclk] [get_bd_pins axi_vdma_0/m_axis_mm2s_aclk] [get_bd_pins axi_vdma_1/m_axi_s2mm_aclk] [get_bd_pins axi_vdma_1/s_axis_s2mm_aclk] [get_bd_pins axis_subset_converter_0/aclk] [get_bd_pins v_axi4s_vid_out_0/aclk]
connect_bd_net -net processing_system7_0_FCLK_RESET0_N [get_bd_pins processing_system7_0/FCLK_RESET0_N] [get_bd_pins rst_processing_system7_0_100M/ext_reset_in] [get_bd_pins rst_processing_system7_0_150M/ext_reset_in]
connect_bd_net -net rgb2dvi_0_oen [get_bd_pins rgb2dvi_0/oen] [get_bd_ports hdmi_oen]
connect_bd_net -net rst_processing_system7_0_100M_interconnect_aresetn [get_bd_pins rst_processing_system7_0_100M/interconnect_aresetn] [get_bd_pins processing_system7_0_axi_periph/ARESETN]
connect_bd_net -net rst_processing_system7_0_100M_peripheral_aresetn [get_bd_pins rst_processing_system7_0_100M/peripheral_aresetn] [get_bd_pins axi_dynclk_0/s00_axi_aresetn] [get_bd_pins cmos_rst/s_axi_aresetn] [get_bd_pins axi_vdma_0/axi_resetn] [get_bd_pins axi_vdma_1/axi_resetn] [get_bd_pins processing_system7_0_axi_periph/S00_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M00_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M01_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M02_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M03_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M04_ARESETN] [get_bd_pins v_tc_0/s_axi_aresetn]
connect_bd_net -net rst_processing_system7_0_140M_interconnect_aresetn [get_bd_pins rst_processing_system7_0_150M/interconnect_aresetn] [get_bd_pins axi_mem_intercon/ARESETN]
connect_bd_net -net rst_processing_system7_0_140M_peripheral_aresetn [get_bd_pins rst_processing_system7_0_150M/peripheral_aresetn] [get_bd_pins alinx_ov5640_0/m_axis_video_aresetn] [get_bd_pins axi_mem_intercon/S00_ARESETN] [get_bd_pins axi_mem_intercon/S01_ARESETN] [get_bd_pins axi_mem_intercon/M00_ARESETN]
connect_bd_net -net v_tc_0_irq [get_bd_pins v_tc_0/irq] [get_bd_pins xlconcat_0/In1]
connect_bd_net -net xlconcat_0_dout [get_bd_pins xlconcat_0/dout] [get_bd_pins processing_system7_0/IRQ_F2P]
connect_bd_net -net xlconstant_1_dout [get_bd_pins xlconstant_1/dout] [get_bd_pins axis_subset_converter_0/aresetn]

# Create address segments
assign_bd_address -offset 0x43C10000 -range 0x00010000 -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_dynclk_0/s00_axi/reg0] -force
assign_bd_address -offset 0x43000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_vdma_0/S_AXI_LITE/Reg] -force
assign_bd_address -offset 0x43010000 -range 0x00010000 -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_vdma_1/S_AXI_LITE/Reg] -force
assign_bd_address -offset 0x41200000 -range 0x00010000 -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs cmos_rst/S_AXI/Reg] -force
assign_bd_address -offset 0x43C00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs v_tc_0/ctrl/Reg] -force
assign_bd_address -offset 0x00000000 -range 0x40000000 -target_address_space [get_bd_addr_spaces axi_vdma_0/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_DDR_LOWOCM] -force
assign_bd_address -offset 0x00000000 -range 0x40000000 -target_address_space [get_bd_addr_spaces axi_vdma_1/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_DDR_LOWOCM] -force
