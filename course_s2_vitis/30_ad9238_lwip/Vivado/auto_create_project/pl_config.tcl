#////////////////////////////////////////////////////////////////////////////////
#  project：ad9238_lwip                                                        //
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


# Create ports
set adc_ch0_clk [ create_bd_port -dir O -type clk adc_ch0_clk ]
set adc_ch1_clk [ create_bd_port -dir O -type clk adc_ch1_clk ]
set adc_ch0_data [ create_bd_port -dir I -from 11 -to 0 adc_ch0_data ]
set adc_ch1_data [ create_bd_port -dir I -from 11 -to 0 adc_ch1_data ]

# Create instance: ad9238_sample_0, and set properties
set ad9238_sample_0 [ create_bd_cell -type ip -vlnv alinx.com:user:ad9238_sample:1.0 ad9238_sample_0 ]

# Create instance: ad9238_sample_1, and set properties
set ad9238_sample_1 [ create_bd_cell -type ip -vlnv alinx.com:user:ad9238_sample:1.0 ad9238_sample_1 ]

# Create instance: rst_clk_adc, and set properties
set rst_clk_adc [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_clk_adc ]

# Create instance: rst_ps7_0_100M, and set properties
set rst_ps7_0_100M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_ps7_0_100M ]

# Create instance: rst_ps7_0_142M, and set properties
set rst_ps7_0_142M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_ps7_0_142M ]

# Create instance: axi_dma_0, and set properties
set axi_dma_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_0 ]
set_property -dict [list \
  CONFIG.c_include_mm2s {0} \
  CONFIG.c_include_sg {1} \
  CONFIG.c_m_axi_s2mm_data_width {64} \
  CONFIG.c_s2mm_burst_size {128} \
  CONFIG.c_sg_include_stscntrl_strm {0} \
  CONFIG.c_sg_length_width {23} \
] $axi_dma_0


# Create instance: axi_dma_1, and set properties
set axi_dma_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_1 ]
set_property -dict [list \
  CONFIG.c_include_mm2s {0} \
  CONFIG.c_include_sg {1} \
  CONFIG.c_m_axi_s2mm_data_width {64} \
  CONFIG.c_s2mm_burst_size {128} \
  CONFIG.c_sg_include_stscntrl_strm {0} \
  CONFIG.c_sg_length_width {23} \
] $axi_dma_1


# Create instance: axi_interconnect_0, and set properties
set axi_interconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_0 ]
set_property -dict [list \
  CONFIG.M00_HAS_DATA_FIFO {2} \
  CONFIG.M00_HAS_REGSLICE {1} \
  CONFIG.NUM_MI {1} \
  CONFIG.NUM_SI {4} \
  CONFIG.S00_HAS_DATA_FIFO {2} \
  CONFIG.S00_HAS_REGSLICE {1} \
  CONFIG.S01_HAS_DATA_FIFO {2} \
  CONFIG.S01_HAS_REGSLICE {1} \
  CONFIG.S02_HAS_DATA_FIFO {2} \
  CONFIG.S02_HAS_REGSLICE {1} \
  CONFIG.S03_HAS_DATA_FIFO {2} \
  CONFIG.S03_HAS_REGSLICE {1} \
  CONFIG.STRATEGY {2} \
] $axi_interconnect_0


# Create instance: axis_register_slice_0, and set properties
set axis_register_slice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_0 ]
set_property -dict [list \
  CONFIG.HAS_TKEEP {1} \
  CONFIG.HAS_TLAST {1} \
  CONFIG.TDATA_NUM_BYTES {2} \
] $axis_register_slice_0


# Create instance: axis_register_slice_1, and set properties
set axis_register_slice_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_1 ]
set_property CONFIG.TDATA_NUM_BYTES {2} $axis_register_slice_1


# Create instance: ps7_0_axi_periph, and set properties
set ps7_0_axi_periph [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 ps7_0_axi_periph ]
set_property CONFIG.NUM_MI {7} $ps7_0_axi_periph


# Create instance: xlconcat_0, and set properties
set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
set_property CONFIG.NUM_PORTS {2} $xlconcat_0


# Create interface connections
connect_bd_intf_net -intf_net ad9238_sample_0_M00_AXIS [get_bd_intf_pins ad9238_sample_0/M00_AXIS] [get_bd_intf_pins axis_register_slice_0/S_AXIS]
connect_bd_intf_net -intf_net ad9238_sample_1_M00_AXIS [get_bd_intf_pins ad9238_sample_1/M00_AXIS] [get_bd_intf_pins axis_register_slice_1/S_AXIS]
connect_bd_intf_net -intf_net axi_dma_0_M_AXI_S2MM [get_bd_intf_pins axi_dma_0/M_AXI_S2MM] [get_bd_intf_pins axi_interconnect_0/S00_AXI]
connect_bd_intf_net -intf_net axi_dma_0_M_AXI_SG [get_bd_intf_pins axi_dma_0/M_AXI_SG] [get_bd_intf_pins axi_interconnect_0/S02_AXI]
connect_bd_intf_net -intf_net axi_dma_1_M_AXI_S2MM [get_bd_intf_pins axi_dma_1/M_AXI_S2MM] [get_bd_intf_pins axi_interconnect_0/S01_AXI]
connect_bd_intf_net -intf_net axi_dma_1_M_AXI_SG [get_bd_intf_pins axi_dma_1/M_AXI_SG] [get_bd_intf_pins axi_interconnect_0/S03_AXI]
connect_bd_intf_net -intf_net axi_interconnect_0_M00_AXI [get_bd_intf_pins axi_interconnect_0/M00_AXI] [get_bd_intf_pins processing_system7_0/S_AXI_HP0]
connect_bd_intf_net -intf_net axis_register_slice_0_M_AXIS [get_bd_intf_pins axis_register_slice_0/M_AXIS] [get_bd_intf_pins axi_dma_0/S_AXIS_S2MM]
connect_bd_intf_net -intf_net axis_register_slice_1_M_AXIS [get_bd_intf_pins axis_register_slice_1/M_AXIS] [get_bd_intf_pins axi_dma_1/S_AXIS_S2MM]
connect_bd_intf_net -intf_net processing_system7_0_DDR [get_bd_intf_ports DDR] [get_bd_intf_pins processing_system7_0/DDR]
connect_bd_intf_net -intf_net processing_system7_0_FIXED_IO [get_bd_intf_ports FIXED_IO] [get_bd_intf_pins processing_system7_0/FIXED_IO]
connect_bd_intf_net -intf_net processing_system7_0_M_AXI_GP0 [get_bd_intf_pins processing_system7_0/M_AXI_GP0] [get_bd_intf_pins ps7_0_axi_periph/S00_AXI]
connect_bd_intf_net -intf_net ps7_0_axi_periph_M03_AXI [get_bd_intf_pins ps7_0_axi_periph/M03_AXI] [get_bd_intf_pins ad9238_sample_0/S00_AXI]
connect_bd_intf_net -intf_net ps7_0_axi_periph_M04_AXI [get_bd_intf_pins ps7_0_axi_periph/M04_AXI] [get_bd_intf_pins ad9238_sample_1/S00_AXI]
connect_bd_intf_net -intf_net ps7_0_axi_periph_M05_AXI [get_bd_intf_pins ps7_0_axi_periph/M05_AXI] [get_bd_intf_pins axi_dma_0/S_AXI_LITE]
connect_bd_intf_net -intf_net ps7_0_axi_periph_M06_AXI [get_bd_intf_pins ps7_0_axi_periph/M06_AXI] [get_bd_intf_pins axi_dma_1/S_AXI_LITE]

# Create port connections
connect_bd_net -net ARESETN_1 [get_bd_pins rst_ps7_0_142M/interconnect_aresetn] [get_bd_pins axi_interconnect_0/ARESETN]
connect_bd_net -net adc_data_0_3 [get_bd_ports adc_ch0_data] [get_bd_pins ad9238_sample_0/adc_data]
connect_bd_net -net adc_data_1_1 [get_bd_ports adc_ch1_data] [get_bd_pins ad9238_sample_1/adc_data]
connect_bd_net -net axi_dma_0_s2mm_introut [get_bd_pins axi_dma_0/s2mm_introut] [get_bd_pins xlconcat_0/In0]
connect_bd_net -net axi_dma_1_s2mm_introut [get_bd_pins axi_dma_1/s2mm_introut] [get_bd_pins xlconcat_0/In1]
connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins ad9238_sample_0/s00_axi_aclk] [get_bd_pins ad9238_sample_1/s00_axi_aclk] [get_bd_pins processing_system7_0/M_AXI_GP0_ACLK] [get_bd_pins rst_ps7_0_100M/slowest_sync_clk] [get_bd_pins axi_dma_0/s_axi_lite_aclk] [get_bd_pins axi_dma_1/s_axi_lite_aclk] [get_bd_pins ps7_0_axi_periph/ACLK] [get_bd_pins ps7_0_axi_periph/S00_ACLK] [get_bd_pins ps7_0_axi_periph/M00_ACLK] [get_bd_pins ps7_0_axi_periph/M01_ACLK] [get_bd_pins ps7_0_axi_periph/M02_ACLK] [get_bd_pins ps7_0_axi_periph/M03_ACLK] [get_bd_pins ps7_0_axi_periph/M04_ACLK] [get_bd_pins ps7_0_axi_periph/M05_ACLK] [get_bd_pins ps7_0_axi_periph/M06_ACLK]
connect_bd_net -net processing_system7_0_FCLK_CLK1 [get_bd_pins processing_system7_0/FCLK_CLK1] [get_bd_pins ad9238_sample_0/m00_axis_aclk] [get_bd_pins ad9238_sample_1/m00_axis_aclk] [get_bd_pins processing_system7_0/S_AXI_HP0_ACLK] [get_bd_pins rst_ps7_0_142M/slowest_sync_clk] [get_bd_pins axi_dma_0/m_axi_sg_aclk] [get_bd_pins axi_dma_0/m_axi_s2mm_aclk] [get_bd_pins axi_dma_1/m_axi_sg_aclk] [get_bd_pins axi_dma_1/m_axi_s2mm_aclk] [get_bd_pins axi_interconnect_0/ACLK] [get_bd_pins axi_interconnect_0/S00_ACLK] [get_bd_pins axi_interconnect_0/S01_ACLK] [get_bd_pins axi_interconnect_0/S02_ACLK] [get_bd_pins axi_interconnect_0/S03_ACLK] [get_bd_pins axi_interconnect_0/M00_ACLK] [get_bd_pins axis_register_slice_0/aclk] [get_bd_pins axis_register_slice_1/aclk]
connect_bd_net -net processing_system7_0_FCLK_CLK2 [get_bd_pins processing_system7_0/FCLK_CLK2] [get_bd_ports adc_ch1_clk] [get_bd_ports adc_ch0_clk] [get_bd_pins ad9238_sample_0/adc_clk] [get_bd_pins ad9238_sample_1/adc_clk] [get_bd_pins rst_clk_adc/slowest_sync_clk]
connect_bd_net -net processing_system7_0_FCLK_RESET0_N [get_bd_pins processing_system7_0/FCLK_RESET0_N] [get_bd_pins rst_clk_adc/ext_reset_in] [get_bd_pins rst_ps7_0_100M/ext_reset_in] [get_bd_pins rst_ps7_0_142M/ext_reset_in]
connect_bd_net -net rst_clk_32M_0_peripheral_aresetn [get_bd_pins rst_clk_adc/peripheral_aresetn] [get_bd_pins ad9238_sample_0/adc_rst_n] [get_bd_pins ad9238_sample_1/adc_rst_n]
connect_bd_net -net rst_ps7_0_100M_interconnect_aresetn [get_bd_pins rst_ps7_0_100M/interconnect_aresetn] [get_bd_pins ps7_0_axi_periph/ARESETN]
connect_bd_net -net rst_ps7_0_100M_peripheral_aresetn [get_bd_pins rst_ps7_0_100M/peripheral_aresetn] [get_bd_pins ad9238_sample_0/s00_axi_aresetn] [get_bd_pins ad9238_sample_1/s00_axi_aresetn] [get_bd_pins axi_dma_0/axi_resetn] [get_bd_pins axi_dma_1/axi_resetn] [get_bd_pins ps7_0_axi_periph/S00_ARESETN] [get_bd_pins ps7_0_axi_periph/M00_ARESETN] [get_bd_pins ps7_0_axi_periph/M01_ARESETN] [get_bd_pins ps7_0_axi_periph/M02_ARESETN] [get_bd_pins ps7_0_axi_periph/M03_ARESETN] [get_bd_pins ps7_0_axi_periph/M04_ARESETN] [get_bd_pins ps7_0_axi_periph/M05_ARESETN] [get_bd_pins ps7_0_axi_periph/M06_ARESETN]
connect_bd_net -net rst_ps7_0_142M_peripheral_aresetn [get_bd_pins rst_ps7_0_142M/peripheral_aresetn] [get_bd_pins ad9238_sample_0/m00_axis_aresetn] [get_bd_pins ad9238_sample_1/m00_axis_aresetn] [get_bd_pins axi_interconnect_0/S00_ARESETN] [get_bd_pins axi_interconnect_0/S01_ARESETN] [get_bd_pins axi_interconnect_0/S02_ARESETN] [get_bd_pins axi_interconnect_0/S03_ARESETN] [get_bd_pins axi_interconnect_0/M00_ARESETN] [get_bd_pins axis_register_slice_0/aresetn] [get_bd_pins axis_register_slice_1/aresetn]
connect_bd_net -net xlconcat_0_dout [get_bd_pins xlconcat_0/dout] [get_bd_pins processing_system7_0/IRQ_F2P]

# Create address segments
assign_bd_address -offset 0x43C20000 -range 0x00010000 -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs ad9238_sample_0/S00_AXI/S00_AXI_reg] -force
assign_bd_address -offset 0x43C30000 -range 0x00010000 -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs ad9238_sample_1/S00_AXI/S00_AXI_reg] -force
assign_bd_address -offset 0x40400000 -range 0x00010000 -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_dma_0/S_AXI_LITE/Reg] -force
assign_bd_address -offset 0x40410000 -range 0x00010000 -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_dma_1/S_AXI_LITE/Reg] -force
assign_bd_address -offset 0x00000000 -range 0x40000000 -target_address_space [get_bd_addr_spaces axi_dma_0/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_DDR_LOWOCM] -force
assign_bd_address -offset 0x00000000 -range 0x40000000 -target_address_space [get_bd_addr_spaces axi_dma_0/Data_SG] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_DDR_LOWOCM] -force
assign_bd_address -offset 0x00000000 -range 0x40000000 -target_address_space [get_bd_addr_spaces axi_dma_1/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_DDR_LOWOCM] -force
assign_bd_address -offset 0x00000000 -range 0x40000000 -target_address_space [get_bd_addr_spaces axi_dma_1/Data_SG] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_DDR_LOWOCM] -force
