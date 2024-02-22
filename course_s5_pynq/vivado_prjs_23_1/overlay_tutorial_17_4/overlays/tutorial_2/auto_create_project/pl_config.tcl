#////////////////////////////////////////////////////////////////////////////////
#  project：tutorial_2                                                         //
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

# Hierarchical cell: mb_ss_0
create_bd_cell -type hier const_multiply

# Create interface pins
create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 const_multiply/M_AXI_MM2S
create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 const_multiply/M_AXI_S2MM
create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 const_multiply/S_AXI_LITE
create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 const_multiply/s_axi_AXILiteS


# Create pins
create_bd_pin -dir I const_multiply/clk ap_clk
create_bd_pin -dir I -from 0 -to 0 const_multiply/rst ap_rst_n

# Create instance: multiply, and set properties
set multiply [ create_bd_cell -type ip -vlnv Xilinx:hls:mult_constant:1.0 const_multiply/multiply ]

# Create instance: multiply_dma, and set properties
set multiply_dma [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 const_multiply/multiply_dma ]
set_property -dict [list \
  CONFIG.c_include_sg {0} \
  CONFIG.c_sg_length_width {23} \
] $multiply_dma


# Create interface connections
connect_bd_intf_net -intf_net axi_dma_0_M_AXIS_MM2S [get_bd_intf_pins const_multiply/multiply/in_data] [get_bd_intf_pins const_multiply/multiply_dma/M_AXIS_MM2S]
connect_bd_intf_net -intf_net axi_dma_0_M_AXI_MM2S [get_bd_intf_pins const_multiply/multiply_dma/M_AXI_MM2S] [get_bd_intf_pins const_multiply/M_AXI_MM2S]
connect_bd_intf_net -intf_net axi_dma_0_M_AXI_S2MM [get_bd_intf_pins const_multiply/multiply_dma/M_AXI_S2MM] [get_bd_intf_pins const_multiply/M_AXI_S2MM]
connect_bd_intf_net -intf_net mult_constant_0_out_data [get_bd_intf_pins const_multiply/multiply/out_data] [get_bd_intf_pins const_multiply/multiply_dma/S_AXIS_S2MM]
connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M01_AXI [get_bd_intf_pins const_multiply/multiply/s_axi_AXILiteS] [get_bd_intf_pins const_multiply/s_axi_AXILiteS]
connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M02_AXI [get_bd_intf_pins const_multiply/multiply_dma/S_AXI_LITE] [get_bd_intf_pins const_multiply/S_AXI_LITE]

# Create port connections
connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins const_multiply/ap_clk] [get_bd_pins const_multiply/multiply/ap_clk] [get_bd_pins const_multiply/multiply_dma/s_axi_lite_aclk] [get_bd_pins const_multiply/multiply_dma/m_axi_mm2s_aclk] [get_bd_pins const_multiply/multiply_dma/m_axi_s2mm_aclk]
connect_bd_net -net rst_processing_system7_0_100M_peripheral_aresetn [get_bd_pins const_multiply/ap_rst_n] [get_bd_pins const_multiply/multiply/ap_rst_n] [get_bd_pins const_multiply/multiply_dma/axi_resetn]


# Create interface ports
set DDR [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 DDR ]
set FIXED_IO [ create_bd_intf_port -mode Master -vlnv xilinx.com:display_processing_system7:fixedio_rtl:1.0 FIXED_IO ]


# Create instance: old_add, and set properties
set old_add [ create_bd_cell -type ip -vlnv xilinx.com:hls:add:1.0 old_add ]

set_property -dict [ list \
 CONFIG.SUPPORTS_NARROW_BURST {0} \
 CONFIG.NUM_READ_OUTSTANDING {1} \
 CONFIG.NUM_WRITE_OUTSTANDING {1} \
 CONFIG.MAX_BURST_LENGTH {1} \
] [get_bd_intf_pins /old_add/s_axi_AXILiteS]

# Create instance: axi_mem_intercon, and set properties
set axi_mem_intercon [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_mem_intercon ]
set_property -dict [list \
  CONFIG.NUM_MI {1} \
  CONFIG.NUM_SI {2} \
  CONFIG.SYNCHRONIZATION_STAGES {2} \
] $axi_mem_intercon


# Create instance: processing_system7_0_axi_periph, and set properties
set processing_system7_0_axi_periph [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 processing_system7_0_axi_periph ]
set_property -dict [list \
  CONFIG.NUM_MI {3} \
  CONFIG.SYNCHRONIZATION_STAGES {2} \
] $processing_system7_0_axi_periph


# Create instance: rst_processing_system7_0_100M, and set properties
set rst_processing_system7_0_100M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_processing_system7_0_100M ]

# Create interface connections
connect_bd_intf_net -intf_net axi_dma_0_M_AXI_MM2S [get_bd_intf_pins axi_mem_intercon/S00_AXI] [get_bd_intf_pins const_multiply/M_AXI_MM2S]
connect_bd_intf_net -intf_net axi_dma_0_M_AXI_S2MM [get_bd_intf_pins axi_mem_intercon/S01_AXI] [get_bd_intf_pins const_multiply/M_AXI_S2MM]
connect_bd_intf_net -intf_net axi_mem_intercon_M00_AXI [get_bd_intf_pins axi_mem_intercon/M00_AXI] [get_bd_intf_pins processing_system7_0/S_AXI_ACP]
connect_bd_intf_net -intf_net processing_system7_0_DDR [get_bd_intf_pins processing_system7_0/DDR] [get_bd_intf_ports DDR]
connect_bd_intf_net -intf_net processing_system7_0_FIXED_IO [get_bd_intf_pins processing_system7_0/FIXED_IO] [get_bd_intf_ports FIXED_IO]
connect_bd_intf_net -intf_net processing_system7_0_M_AXI_GP0 [get_bd_intf_pins processing_system7_0/M_AXI_GP0] [get_bd_intf_pins processing_system7_0_axi_periph/S00_AXI]
connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M00_AXI [get_bd_intf_pins old_add/s_axi_AXILiteS] [get_bd_intf_pins processing_system7_0_axi_periph/M00_AXI]
connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M01_AXI [get_bd_intf_pins const_multiply/s_axi_AXILiteS] [get_bd_intf_pins processing_system7_0_axi_periph/M01_AXI]
connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M02_AXI [get_bd_intf_pins const_multiply/S_AXI_LITE] [get_bd_intf_pins processing_system7_0_axi_periph/M02_AXI]

# Create port connections
connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins old_add/ap_clk] [get_bd_pins processing_system7_0/M_AXI_GP0_ACLK] [get_bd_pins processing_system7_0/S_AXI_ACP_ACLK] [get_bd_pins const_multiply/ap_clk] [get_bd_pins axi_mem_intercon/ACLK] [get_bd_pins axi_mem_intercon/S00_ACLK] [get_bd_pins axi_mem_intercon/M00_ACLK] [get_bd_pins axi_mem_intercon/S01_ACLK] [get_bd_pins processing_system7_0_axi_periph/ACLK] [get_bd_pins processing_system7_0_axi_periph/S00_ACLK] [get_bd_pins processing_system7_0_axi_periph/M00_ACLK] [get_bd_pins processing_system7_0_axi_periph/M01_ACLK] [get_bd_pins processing_system7_0_axi_periph/M02_ACLK] [get_bd_pins rst_processing_system7_0_100M/slowest_sync_clk]
connect_bd_net -net processing_system7_0_FCLK_RESET0_N [get_bd_pins processing_system7_0/FCLK_RESET0_N] [get_bd_pins rst_processing_system7_0_100M/ext_reset_in]
connect_bd_net -net rst_processing_system7_0_100M_interconnect_aresetn [get_bd_pins rst_processing_system7_0_100M/interconnect_aresetn] [get_bd_pins axi_mem_intercon/ARESETN] [get_bd_pins processing_system7_0_axi_periph/ARESETN]
connect_bd_net -net rst_processing_system7_0_100M_peripheral_aresetn [get_bd_pins rst_processing_system7_0_100M/peripheral_aresetn] [get_bd_pins old_add/ap_rst_n] [get_bd_pins const_multiply/ap_rst_n] [get_bd_pins axi_mem_intercon/S00_ARESETN] [get_bd_pins axi_mem_intercon/M00_ARESETN] [get_bd_pins axi_mem_intercon/S01_ARESETN] [get_bd_pins processing_system7_0_axi_periph/S00_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M00_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M01_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M02_ARESETN]

# Create address segments
assign_bd_address -offset 0x43C00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs const_multiply/multiply/s_axi_AXILiteS/Reg] -force
assign_bd_address -offset 0x40400000 -range 0x00010000 -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs const_multiply/multiply_dma/S_AXI_LITE/Reg] -force
assign_bd_address -offset 0x43C10000 -range 0x00010000 -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs old_add/s_axi_AXILiteS/Reg] -force
assign_bd_address -offset 0x00000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces const_multiply/multiply_dma/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_ACP/ACP_DDR_LOWOCM] -force
assign_bd_address -offset 0xFC000000 -range 0x01000000 -target_address_space [get_bd_addr_spaces const_multiply/multiply_dma/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_ACP/ACP_QSPI_LINEAR] -force
assign_bd_address -offset 0x00000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces const_multiply/multiply_dma/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_ACP/ACP_DDR_LOWOCM] -force
assign_bd_address -offset 0xFC000000 -range 0x01000000 -target_address_space [get_bd_addr_spaces const_multiply/multiply_dma/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_ACP/ACP_QSPI_LINEAR] -force

# Exclude Address Segments
exclude_bd_addr_seg -offset 0xE0000000 -range 0x00400000 -target_address_space [get_bd_addr_spaces const_multiply/multiply_dma/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_ACP/ACP_IOP]
exclude_bd_addr_seg -offset 0x40000000 -range 0x40000000 -target_address_space [get_bd_addr_spaces const_multiply/multiply_dma/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_ACP/ACP_M_AXI_GP0]
exclude_bd_addr_seg -offset 0xE0000000 -range 0x00400000 -target_address_space [get_bd_addr_spaces const_multiply/multiply_dma/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_ACP/ACP_IOP]
exclude_bd_addr_seg -offset 0x40000000 -range 0x40000000 -target_address_space [get_bd_addr_spaces const_multiply/multiply_dma/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_ACP/ACP_M_AXI_GP0]
