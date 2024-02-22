#////////////////////////////////////////////////////////////////////////////////
#  project：bram_test                                                         //
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

# Create instance: pl_bram_ctrl_0, and set properties
set pl_bram_ctrl_0 [ create_bd_cell -type ip -vlnv xilinx.com:user:pl_bram_ctrl:1.0 pl_bram_ctrl_0 ]

# Create instance: rst_ps7_0_50M, and set properties
set rst_ps7_0_50M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_ps7_0_50M ]

# Create instance: axi_bram_ctrl_0, and set properties
set axi_bram_ctrl_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 axi_bram_ctrl_0 ]
set_property CONFIG.SINGLE_PORT_BRAM {1} $axi_bram_ctrl_0


# Create instance: axi_smc, and set properties
set axi_smc [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 axi_smc ]
set_property -dict [list \
  CONFIG.NUM_MI {3} \
  CONFIG.NUM_SI {1} \
] $axi_smc


# Create instance: blk_mem_gen_0, and set properties
set blk_mem_gen_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 blk_mem_gen_0 ]
set_property -dict [list \
  CONFIG.EN_SAFETY_CKT {false} \
  CONFIG.Enable_B {Use_ENB_Pin} \
  CONFIG.Memory_Type {True_Dual_Port_RAM} \
  CONFIG.Port_B_Clock {100} \
  CONFIG.Port_B_Enable_Rate {100} \
  CONFIG.Port_B_Write_Rate {50} \
  CONFIG.Use_RSTB_Pin {true} \
] $blk_mem_gen_0


# Create instance: system_ila_0, and set properties
set system_ila_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:system_ila:1.1 system_ila_0 ]
set_property -dict [list \
  CONFIG.C_MON_TYPE {MIX} \
  CONFIG.C_NUM_MONITOR_SLOTS {1} \
  CONFIG.C_NUM_OF_PROBES {1} \
  CONFIG.C_PROBE0_TYPE {0} \
  CONFIG.C_SLOT_0_INTF_TYPE {xilinx.com:interface:bram_rtl:1.0} \
  CONFIG.C_SLOT_0_TYPE {0} \
] $system_ila_0


# Create interface connections
connect_bd_intf_net -intf_net axi_bram_ctrl_0_BRAM_PORTA [get_bd_intf_pins axi_bram_ctrl_0/BRAM_PORTA] [get_bd_intf_pins blk_mem_gen_0/BRAM_PORTA]
connect_bd_intf_net -intf_net axi_smc_M00_AXI [get_bd_intf_pins axi_smc/M00_AXI] [get_bd_intf_pins axi_bram_ctrl_0/S_AXI]
connect_bd_intf_net -intf_net axi_smc_M01_AXI [get_bd_intf_pins axi_smc/M01_AXI] [get_bd_intf_pins pl_bram_ctrl_0/S00_AXI]
connect_bd_intf_net -intf_net pl_bram_ctrl_0_BRAM_PORT [get_bd_intf_pins pl_bram_ctrl_0/BRAM_PORT] [get_bd_intf_pins blk_mem_gen_0/BRAM_PORTB]
connect_bd_intf_net -intf_net [get_bd_intf_nets pl_bram_ctrl_0_BRAM_PORT] [get_bd_intf_pins pl_bram_ctrl_0/BRAM_PORT] [get_bd_intf_pins system_ila_0/SLOT_0_BRAM]
set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_intf_nets pl_bram_ctrl_0_BRAM_PORT]
connect_bd_intf_net -intf_net processing_system7_0_DDR [get_bd_intf_ports DDR] [get_bd_intf_pins processing_system7_0/DDR]
connect_bd_intf_net -intf_net processing_system7_0_FIXED_IO [get_bd_intf_ports FIXED_IO] [get_bd_intf_pins processing_system7_0/FIXED_IO]
connect_bd_intf_net -intf_net processing_system7_0_M_AXI_GP0 [get_bd_intf_pins processing_system7_0/M_AXI_GP0] [get_bd_intf_pins axi_smc/S00_AXI]

# Create port connections
connect_bd_net -net pl_bram_ctrl_0_intr [get_bd_pins pl_bram_ctrl_0/intr] [get_bd_pins processing_system7_0/IRQ_F2P] [get_bd_pins system_ila_0/probe0]
set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_nets pl_bram_ctrl_0_intr]
connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins pl_bram_ctrl_0/s00_axi_aclk] [get_bd_pins processing_system7_0/M_AXI_GP0_ACLK] [get_bd_pins rst_ps7_0_50M/slowest_sync_clk] [get_bd_pins axi_bram_ctrl_0/s_axi_aclk] [get_bd_pins axi_smc/aclk] [get_bd_pins system_ila_0/clk]
connect_bd_net -net processing_system7_0_FCLK_RESET0_N [get_bd_pins processing_system7_0/FCLK_RESET0_N] [get_bd_pins rst_ps7_0_50M/ext_reset_in]
connect_bd_net -net rst_ps7_0_50M_peripheral_aresetn [get_bd_pins rst_ps7_0_50M/peripheral_aresetn] [get_bd_pins pl_bram_ctrl_0/s00_axi_aresetn] [get_bd_pins axi_bram_ctrl_0/s_axi_aresetn] [get_bd_pins axi_smc/aresetn]

# Create address segments
assign_bd_address -offset 0x40000000 -range 0x00001000 -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_bram_ctrl_0/S_AXI/Mem0] -force
assign_bd_address -offset 0x43C00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs pl_bram_ctrl_0/S00_AXI/S00_AXI_reg] -force
