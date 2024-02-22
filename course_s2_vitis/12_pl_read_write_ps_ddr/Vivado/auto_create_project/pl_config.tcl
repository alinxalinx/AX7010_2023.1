#////////////////////////////////////////////////////////////////////////////////
#  project：pl_read_write_ps_ddr                                               //
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
set S00_AXI [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S00_AXI ]
set_property -dict [ list \
 CONFIG.ADDR_WIDTH {32} \
 CONFIG.ARUSER_WIDTH {0} \
 CONFIG.AWUSER_WIDTH {0} \
 CONFIG.BUSER_WIDTH {0} \
 CONFIG.DATA_WIDTH {64} \
 CONFIG.HAS_BRESP {1} \
 CONFIG.HAS_BURST {1} \
 CONFIG.HAS_CACHE {1} \
 CONFIG.HAS_LOCK {1} \
 CONFIG.HAS_PROT {1} \
 CONFIG.HAS_QOS {1} \
 CONFIG.HAS_REGION {1} \
 CONFIG.HAS_RRESP {1} \
 CONFIG.HAS_WSTRB {1} \
 CONFIG.ID_WIDTH {6} \
 CONFIG.MAX_BURST_LENGTH {256} \
 CONFIG.NUM_READ_OUTSTANDING {1} \
 CONFIG.NUM_READ_THREADS {1} \
 CONFIG.NUM_WRITE_OUTSTANDING {1} \
 CONFIG.NUM_WRITE_THREADS {1} \
 CONFIG.PROTOCOL {AXI4} \
 CONFIG.READ_WRITE_MODE {READ_WRITE} \
 CONFIG.RUSER_BITS_PER_BYTE {0} \
 CONFIG.RUSER_WIDTH {0} \
 CONFIG.SUPPORTS_NARROW_BURST {1} \
 CONFIG.WUSER_BITS_PER_BYTE {0} \
 CONFIG.WUSER_WIDTH {0} \
 ] $S00_AXI


# Create ports
set axim_rst_n [ create_bd_port -dir O -from 0 -to 0 -type rst axim_rst_n ]
set axi_hp_clk [ create_bd_port -dir I -type clk -freq_hz 150000000 axi_hp_clk ]
set_property -dict [ list \
 CONFIG.ASSOCIATED_BUSIF {MM2S_AXI:S00_AXI} \
] $axi_hp_clk
set FCLK_CLK0 [ create_bd_port -dir O -type clk FCLK_CLK0 ]

# Create instance: proc_sys_reset_0, and set properties
set proc_sys_reset_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0 ]

# Create instance: axi_interconnect_0, and set properties
set axi_interconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_0 ]
set_property -dict [list \
  CONFIG.ENABLE_ADVANCED_OPTIONS {0} \
  CONFIG.NUM_MI {1} \
  CONFIG.S00_HAS_DATA_FIFO {0} \
  CONFIG.S00_HAS_REGSLICE {0} \
  CONFIG.SYNCHRONIZATION_STAGES {2} \
] $axi_interconnect_0


# Create interface connections
connect_bd_intf_net -intf_net S00_AXI_1 [get_bd_intf_ports S00_AXI] [get_bd_intf_pins axi_interconnect_0/S00_AXI]
connect_bd_intf_net -intf_net axi_interconnect_1_M00_AXI [get_bd_intf_pins axi_interconnect_0/M00_AXI] [get_bd_intf_pins processing_system7_0/S_AXI_HP0]
connect_bd_intf_net -intf_net processing_system7_0_DDR [get_bd_intf_ports DDR] [get_bd_intf_pins processing_system7_0/DDR]
connect_bd_intf_net -intf_net processing_system7_0_FIXED_IO [get_bd_intf_ports FIXED_IO] [get_bd_intf_pins processing_system7_0/FIXED_IO]

# Create port connections
connect_bd_net -net ARESETN_1 [get_bd_pins proc_sys_reset_0/interconnect_aresetn] [get_bd_pins axi_interconnect_0/ARESETN]
connect_bd_net -net clk_100m_1 [get_bd_ports axi_hp_clk] [get_bd_pins proc_sys_reset_0/slowest_sync_clk] [get_bd_pins processing_system7_0/S_AXI_HP0_ACLK] [get_bd_pins axi_interconnect_0/ACLK] [get_bd_pins axi_interconnect_0/S00_ACLK] [get_bd_pins axi_interconnect_0/M00_ACLK]
connect_bd_net -net proc_sys_reset_0_peripheral_aresetn [get_bd_pins proc_sys_reset_0/peripheral_aresetn] [get_bd_ports axim_rst_n] [get_bd_pins axi_interconnect_0/S00_ARESETN] [get_bd_pins axi_interconnect_0/M00_ARESETN]
connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_ports FCLK_CLK0]
connect_bd_net -net processing_system7_0_FCLK_RESET0_N [get_bd_pins processing_system7_0/FCLK_RESET0_N] [get_bd_pins proc_sys_reset_0/ext_reset_in]

# Create address segments
assign_bd_address
assign_bd_address -offset 0x00000000 -range 0x40000000 -target_address_space [get_bd_addr_spaces S00_AXI] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_DDR_LOWOCM] -force
