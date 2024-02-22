#////////////////////////////////////////////////////////////////////////////////
#  project：an5642_lwip                                                        //
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
set cmos2_i2c [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 cmos2_i2c ]
set cmos_rstn [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 cmos_rstn ]
set cmos1_i2c [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 cmos1_i2c ]


# Create ports
set cmos2_pclk [ create_bd_port -dir I cmos2_pclk ]
set cmos2_href [ create_bd_port -dir I cmos2_href ]
set cmos2_vsync [ create_bd_port -dir I cmos2_vsync ]
set cmos2_d [ create_bd_port -dir I -from 9 -to 0 cmos2_d ]
set cmos1_vsync [ create_bd_port -dir I cmos1_vsync ]
set cmos1_href [ create_bd_port -dir I cmos1_href ]
set cmos1_pclk [ create_bd_port -dir I cmos1_pclk ]
set cmos1_d [ create_bd_port -dir I -from 9 -to 0 cmos1_d ]

# Create instance: rst_processing_system7_0_100M, and set properties
set rst_processing_system7_0_100M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_processing_system7_0_100M ]

# Create instance: rst_processing_system7_0_150M, and set properties
set rst_processing_system7_0_150M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_processing_system7_0_150M ]

# Create instance: alinx_ov5640_1, and set properties
set alinx_ov5640_1 [ create_bd_cell -type ip -vlnv www.alinx.com.cn:user:alinx_ov5640:5.4 alinx_ov5640_1 ]

# Create instance: alinx_ov5640_0, and set properties
set alinx_ov5640_0 [ create_bd_cell -type ip -vlnv www.alinx.com.cn:user:alinx_ov5640:5.4 alinx_ov5640_0 ]

# Create instance: cmos_rst, and set properties
set cmos_rst [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 cmos_rst ]
set_property -dict [list \
  CONFIG.C_ALL_OUTPUTS {1} \
  CONFIG.C_GPIO_WIDTH {2} \
] $cmos_rst


# Create instance: axi_mem_intercon, and set properties
set axi_mem_intercon [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_mem_intercon ]
set_property -dict [list \
  CONFIG.M00_HAS_DATA_FIFO {0} \
  CONFIG.M00_HAS_REGSLICE {1} \
  CONFIG.NUM_MI {1} \
  CONFIG.NUM_SI {2} \
  CONFIG.S00_HAS_DATA_FIFO {2} \
  CONFIG.S00_HAS_REGSLICE {1} \
  CONFIG.S01_HAS_DATA_FIFO {2} \
  CONFIG.S01_HAS_REGSLICE {1} \
  CONFIG.STRATEGY {2} \
  CONFIG.SYNCHRONIZATION_STAGES {2} \
] $axi_mem_intercon


# Create instance: axi_vdma_0, and set properties
set axi_vdma_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vdma:6.3 axi_vdma_0 ]
set_property -dict [list \
  CONFIG.c_enable_vert_flip {0} \
  CONFIG.c_include_mm2s {0} \
  CONFIG.c_include_s2mm_dre {1} \
  CONFIG.c_m_axi_s2mm_data_width {64} \
  CONFIG.c_num_fstores {3} \
  CONFIG.c_s2mm_genlock_mode {0} \
  CONFIG.c_s2mm_linebuffer_depth {4096} \
  CONFIG.c_s2mm_max_burst_length {128} \
  CONFIG.c_use_s2mm_fsync {2} \
] $axi_vdma_0


# Create instance: axi_vdma_1, and set properties
set axi_vdma_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vdma:6.3 axi_vdma_1 ]
set_property -dict [list \
  CONFIG.c_enable_vert_flip {0} \
  CONFIG.c_include_mm2s {0} \
  CONFIG.c_include_s2mm_dre {1} \
  CONFIG.c_m_axi_s2mm_data_width {64} \
  CONFIG.c_num_fstores {3} \
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


# Create instance: axis_subset_converter_1, and set properties
set axis_subset_converter_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_subset_converter:1.1 axis_subset_converter_1 ]
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
] $axis_subset_converter_1


# Create instance: processing_system7_0_axi_periph, and set properties
set processing_system7_0_axi_periph [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 processing_system7_0_axi_periph ]
set_property -dict [list \
  CONFIG.NUM_MI {3} \
  CONFIG.SYNCHRONIZATION_STAGES {2} \
] $processing_system7_0_axi_periph


# Create instance: xlconcat_0, and set properties
set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
set_property CONFIG.NUM_PORTS {2} $xlconcat_0


# Create instance: xlconstant_0, and set properties
set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]

# Create interface connections
connect_bd_intf_net -intf_net alinx_ov5640_RGB565_0_m_axis_video [get_bd_intf_pins alinx_ov5640_0/m_axis_video] [get_bd_intf_pins axis_subset_converter_0/S_AXIS]
connect_bd_intf_net -intf_net alinx_ov5640_RGB565_1_m_axis_video [get_bd_intf_pins alinx_ov5640_1/m_axis_video] [get_bd_intf_pins axis_subset_converter_1/S_AXIS]
connect_bd_intf_net -intf_net axi_gpio_0_GPIO [get_bd_intf_ports cmos_rstn] [get_bd_intf_pins cmos_rst/GPIO]
connect_bd_intf_net -intf_net axi_mem_intercon_M00_AXI [get_bd_intf_pins axi_mem_intercon/M00_AXI] [get_bd_intf_pins processing_system7_0/S_AXI_HP0]
connect_bd_intf_net -intf_net axi_vdma_1_M_AXI_S2MM [get_bd_intf_pins axi_vdma_0/M_AXI_S2MM] [get_bd_intf_pins axi_mem_intercon/S00_AXI]
connect_bd_intf_net -intf_net axi_vdma_3_M_AXI_S2MM [get_bd_intf_pins axi_vdma_1/M_AXI_S2MM] [get_bd_intf_pins axi_mem_intercon/S01_AXI]
connect_bd_intf_net -intf_net axis_subset_converter_0_M_AXIS [get_bd_intf_pins axis_subset_converter_0/M_AXIS] [get_bd_intf_pins axi_vdma_0/S_AXIS_S2MM]
connect_bd_intf_net -intf_net axis_subset_converter_1_M_AXIS [get_bd_intf_pins axis_subset_converter_1/M_AXIS] [get_bd_intf_pins axi_vdma_1/S_AXIS_S2MM]
connect_bd_intf_net -intf_net processing_system7_0_DDR [get_bd_intf_ports DDR] [get_bd_intf_pins processing_system7_0/DDR]
connect_bd_intf_net -intf_net processing_system7_0_FIXED_IO [get_bd_intf_ports FIXED_IO] [get_bd_intf_pins processing_system7_0/FIXED_IO]
connect_bd_intf_net -intf_net processing_system7_0_IIC_0 [get_bd_intf_ports cmos1_i2c] [get_bd_intf_pins processing_system7_0/IIC_0]
connect_bd_intf_net -intf_net processing_system7_0_IIC_1 [get_bd_intf_ports cmos2_i2c] [get_bd_intf_pins processing_system7_0/IIC_1]
connect_bd_intf_net -intf_net processing_system7_0_M_AXI_GP0 [get_bd_intf_pins processing_system7_0/M_AXI_GP0] [get_bd_intf_pins processing_system7_0_axi_periph/S00_AXI]
connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M00_AXI [get_bd_intf_pins processing_system7_0_axi_periph/M00_AXI] [get_bd_intf_pins axi_vdma_0/S_AXI_LITE]
connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M01_AXI [get_bd_intf_pins processing_system7_0_axi_periph/M01_AXI] [get_bd_intf_pins axi_vdma_1/S_AXI_LITE]
connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M02_AXI [get_bd_intf_pins cmos_rst/S_AXI] [get_bd_intf_pins processing_system7_0_axi_periph/M02_AXI]

# Create port connections
connect_bd_net -net axi_vdma_1_s2mm_introut [get_bd_pins axi_vdma_0/s2mm_introut] [get_bd_pins xlconcat_0/In0]
connect_bd_net -net axi_vdma_3_s2mm_introut [get_bd_pins axi_vdma_1/s2mm_introut] [get_bd_pins xlconcat_0/In1]
connect_bd_net -net cmos1_href_1 [get_bd_ports cmos1_href] [get_bd_pins alinx_ov5640_0/cmos_href]
connect_bd_net -net cmos1_vsync_1 [get_bd_ports cmos1_vsync] [get_bd_pins alinx_ov5640_0/cmos_vsync]
connect_bd_net -net cmos_d_1 [get_bd_ports cmos2_d] [get_bd_pins alinx_ov5640_1/cmos_d]
connect_bd_net -net cmos_d_2 [get_bd_ports cmos1_d] [get_bd_pins alinx_ov5640_0/cmos_d]
connect_bd_net -net cmos_href_1 [get_bd_ports cmos2_href] [get_bd_pins alinx_ov5640_1/cmos_href]
connect_bd_net -net cmos_pclk_1 [get_bd_ports cmos2_pclk] [get_bd_pins alinx_ov5640_1/cmos_pclk]
connect_bd_net -net cmos_pclk_2 [get_bd_ports cmos1_pclk] [get_bd_pins alinx_ov5640_0/cmos_pclk]
connect_bd_net -net cmos_vsync_1 [get_bd_ports cmos2_vsync] [get_bd_pins alinx_ov5640_1/cmos_vsync]
connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins processing_system7_0/M_AXI_GP0_ACLK] [get_bd_pins rst_processing_system7_0_100M/slowest_sync_clk] [get_bd_pins cmos_rst/s_axi_aclk] [get_bd_pins axi_vdma_0/s_axi_lite_aclk] [get_bd_pins axi_vdma_1/s_axi_lite_aclk] [get_bd_pins processing_system7_0_axi_periph/ACLK] [get_bd_pins processing_system7_0_axi_periph/S00_ACLK] [get_bd_pins processing_system7_0_axi_periph/M00_ACLK] [get_bd_pins processing_system7_0_axi_periph/M01_ACLK] [get_bd_pins processing_system7_0_axi_periph/M02_ACLK]
connect_bd_net -net processing_system7_0_FCLK_CLK1 [get_bd_pins processing_system7_0/FCLK_CLK1] [get_bd_pins processing_system7_0/S_AXI_HP0_ACLK] [get_bd_pins rst_processing_system7_0_150M/slowest_sync_clk] [get_bd_pins alinx_ov5640_1/m_axis_video_aclk] [get_bd_pins alinx_ov5640_0/m_axis_video_aclk] [get_bd_pins axi_mem_intercon/ACLK] [get_bd_pins axi_mem_intercon/S00_ACLK] [get_bd_pins axi_mem_intercon/S01_ACLK] [get_bd_pins axi_mem_intercon/M00_ACLK] [get_bd_pins axi_vdma_0/m_axi_s2mm_aclk] [get_bd_pins axi_vdma_0/s_axis_s2mm_aclk] [get_bd_pins axi_vdma_1/m_axi_s2mm_aclk] [get_bd_pins axi_vdma_1/s_axis_s2mm_aclk] [get_bd_pins axis_subset_converter_0/aclk] [get_bd_pins axis_subset_converter_1/aclk]
connect_bd_net -net processing_system7_0_FCLK_RESET0_N [get_bd_pins processing_system7_0/FCLK_RESET0_N] [get_bd_pins rst_processing_system7_0_100M/ext_reset_in] [get_bd_pins rst_processing_system7_0_150M/ext_reset_in]
connect_bd_net -net rst_processing_system7_0_100M_interconnect_aresetn [get_bd_pins rst_processing_system7_0_100M/interconnect_aresetn] [get_bd_pins processing_system7_0_axi_periph/ARESETN]
connect_bd_net -net rst_processing_system7_0_100M_peripheral_aresetn [get_bd_pins rst_processing_system7_0_100M/peripheral_aresetn] [get_bd_pins cmos_rst/s_axi_aresetn] [get_bd_pins axi_vdma_0/axi_resetn] [get_bd_pins axi_vdma_1/axi_resetn] [get_bd_pins processing_system7_0_axi_periph/S00_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M00_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M01_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M02_ARESETN]
connect_bd_net -net rst_processing_system7_0_140M_interconnect_aresetn [get_bd_pins rst_processing_system7_0_150M/interconnect_aresetn] [get_bd_pins axi_mem_intercon/ARESETN]
connect_bd_net -net rst_processing_system7_0_140M_peripheral_aresetn [get_bd_pins rst_processing_system7_0_150M/peripheral_aresetn] [get_bd_pins alinx_ov5640_1/m_axis_video_aresetn] [get_bd_pins alinx_ov5640_0/m_axis_video_aresetn] [get_bd_pins axi_mem_intercon/S00_ARESETN] [get_bd_pins axi_mem_intercon/S01_ARESETN] [get_bd_pins axi_mem_intercon/M00_ARESETN]
connect_bd_net -net xlconcat_0_dout [get_bd_pins xlconcat_0/dout] [get_bd_pins processing_system7_0/IRQ_F2P]
connect_bd_net -net xlconstant_1_dout [get_bd_pins xlconstant_0/dout] [get_bd_pins axis_subset_converter_0/aresetn] [get_bd_pins axis_subset_converter_1/aresetn]

# Create address segments
assign_bd_address -offset 0x41210000 -range 0x00010000 -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs cmos_rst/S_AXI/Reg] -force
assign_bd_address -offset 0x43010000 -range 0x00010000 -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_vdma_0/S_AXI_LITE/Reg] -force
assign_bd_address -offset 0x43030000 -range 0x00010000 -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_vdma_1/S_AXI_LITE/Reg] -force
assign_bd_address -offset 0x00000000 -range 0x40000000 -target_address_space [get_bd_addr_spaces axi_vdma_0/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_DDR_LOWOCM] -force
assign_bd_address -offset 0x00000000 -range 0x40000000 -target_address_space [get_bd_addr_spaces axi_vdma_1/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_DDR_LOWOCM] -force
