#////////////////////////////////////////////////////////////////////////////////
#  project：sg_dma_test                                                        //
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


# Create instance: xlconcat_0, and set properties
create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0
set_property CONFIG.NUM_PORTS {2} [get_bd_cells xlconcat_0]


# Create instance: rst_clk_wiz_100M, and set properties
create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_clk_wiz_100M

# Create instance: ps7_0_axi_periph, and set properties
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 ps7_0_axi_periph
set_property CONFIG.NUM_MI {1} [get_bd_cells ps7_0_axi_periph]

# Create instance: axi_interconnect_0, and set properties
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_0
set_property CONFIG.NUM_SI {3} [get_bd_cells axi_interconnect_0]
set_property CONFIG.NUM_MI {1} [get_bd_cells axi_interconnect_0]

# Create instance: axi_dma_0, and set properties
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_0
set_property -dict [list \
  CONFIG.c_sg_include_stscntrl_strm {0} \
  CONFIG.c_sg_length_width {23} \
] [get_bd_cells axi_dma_0]

# Create instance: axis_data_fifo_0, and set properties
create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 axis_data_fifo_0
set_property -dict [list \
  CONFIG.FIFO_DEPTH {1024} \
  CONFIG.HAS_RD_DATA_COUNT {1} \
  CONFIG.HAS_WR_DATA_COUNT {1} \
] [get_bd_cells axis_data_fifo_0]

# Make External interface ports
make_bd_intf_pins_external  [get_bd_intf_pins processing_system7_0/DDR]
set_property name DDR [get_bd_intf_ports DDR_0]
make_bd_intf_pins_external  [get_bd_intf_pins processing_system7_0/FIXED_IO]
set_property name FIXED_IO [get_bd_intf_ports FIXED_IO_0]


# Create port connections
connect_bd_intf_net [get_bd_intf_pins processing_system7_0/M_AXI_GP0] -boundary_type upper [get_bd_intf_pins ps7_0_axi_periph/S00_AXI]
connect_bd_intf_net [get_bd_intf_pins processing_system7_0/S_AXI_HP0] -boundary_type upper [get_bd_intf_pins axi_interconnect_0/M00_AXI]
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins axi_interconnect_0/S00_AXI] [get_bd_intf_pins axi_dma_0/M_AXI_MM2S]
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins axi_interconnect_0/S01_AXI] [get_bd_intf_pins axi_dma_0/M_AXI_S2MM]
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins axi_interconnect_0/S02_AXI] [get_bd_intf_pins axi_dma_0/M_AXI_SG]
connect_bd_intf_net [get_bd_intf_pins axi_dma_0/M_AXIS_MM2S] [get_bd_intf_pins axis_data_fifo_0/S_AXIS]
connect_bd_intf_net [get_bd_intf_pins axis_data_fifo_0/M_AXIS] [get_bd_intf_pins axi_dma_0/S_AXIS_S2MM]
connect_bd_intf_net [get_bd_intf_pins axi_dma_0/S_AXI_LITE] -boundary_type upper [get_bd_intf_pins ps7_0_axi_periph/M00_AXI]


connect_bd_net [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins processing_system7_0/M_AXI_GP0_ACLK]
connect_bd_net [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins processing_system7_0/S_AXI_HP0_ACLK]
connect_bd_net [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins axi_interconnect_0/ACLK]
connect_bd_net [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins axi_interconnect_0/S00_ACLK]
connect_bd_net [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins axi_interconnect_0/M00_ACLK]
connect_bd_net [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins axi_interconnect_0/S01_ACLK]
connect_bd_net [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins axi_interconnect_0/S02_ACLK]
connect_bd_net [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins axi_dma_0/s_axi_lite_aclk]
connect_bd_net [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins axi_dma_0/m_axi_sg_aclk]
connect_bd_net [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins axi_dma_0/m_axi_mm2s_aclk]
connect_bd_net [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins axi_dma_0/m_axi_s2mm_aclk]
connect_bd_net [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins axis_data_fifo_0/s_axis_aclk]
connect_bd_net [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins ps7_0_axi_periph/ACLK]
connect_bd_net [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins ps7_0_axi_periph/S00_ACLK]
connect_bd_net [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins ps7_0_axi_periph/M00_ACLK]
connect_bd_net [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins rst_clk_wiz_100M/slowest_sync_clk]

connect_bd_net [get_bd_pins rst_clk_wiz_100M/peripheral_aresetn] [get_bd_pins ps7_0_axi_periph/S00_ARESETN]
connect_bd_net [get_bd_pins rst_clk_wiz_100M/peripheral_aresetn] [get_bd_pins ps7_0_axi_periph/M00_ARESETN]
connect_bd_net [get_bd_pins rst_clk_wiz_100M/peripheral_aresetn] [get_bd_pins axi_dma_0/axi_resetn]
connect_bd_net [get_bd_pins rst_clk_wiz_100M/peripheral_aresetn] [get_bd_pins axi_interconnect_0/S00_ARESETN]
connect_bd_net [get_bd_pins rst_clk_wiz_100M/peripheral_aresetn] [get_bd_pins axi_interconnect_0/S01_ARESETN]
connect_bd_net [get_bd_pins rst_clk_wiz_100M/peripheral_aresetn] [get_bd_pins axi_interconnect_0/S02_ARESETN]
connect_bd_net [get_bd_pins rst_clk_wiz_100M/peripheral_aresetn] [get_bd_pins axi_interconnect_0/M00_ARESETN]

connect_bd_net [get_bd_pins rst_clk_wiz_100M/interconnect_aresetn] [get_bd_pins ps7_0_axi_periph/ARESETN]
connect_bd_net [get_bd_pins rst_clk_wiz_100M/interconnect_aresetn] [get_bd_pins axis_data_fifo_0/s_axis_aresetn]
connect_bd_net [get_bd_pins rst_clk_wiz_100M/interconnect_aresetn] [get_bd_pins axi_interconnect_0/ARESETN]

connect_bd_net [get_bd_pins xlconcat_0/dout] [get_bd_pins processing_system7_0/IRQ_F2P]
connect_bd_net [get_bd_pins axi_dma_0/mm2s_introut] [get_bd_pins xlconcat_0/In0]
connect_bd_net [get_bd_pins axi_dma_0/s2mm_introut] [get_bd_pins xlconcat_0/In1]
connect_bd_net [get_bd_pins rst_clk_wiz_100M/ext_reset_in] [get_bd_pins processing_system7_0/FCLK_RESET0_N]

#Allocate register base address
assign_bd_address	

