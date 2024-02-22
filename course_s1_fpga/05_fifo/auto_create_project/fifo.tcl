#////////////////////////////////////////////////////////////////////////////////
#  project：FPGA on-chip FIFO read and write test experiment                   //
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

#设置项目名称和工作目录
set projname "vivado_fifo"
set Topname "fifo_test"
set tclpath [pwd]
cd ..
set projpath [pwd]
#创建工程
#**********************************************************************************************************
create_project -force $projname $projpath/$projname -part xc7z010clg400-1
# Create 'sources_1' fileset (if not found)
if {[string equal [get_filesets -quiet sources_1] ""]} {
  create_fileset -srcset sources_1
}
file mkdir $projpath/$projname/$projname.srcs/sources_1/ip
file mkdir $projpath/$projname/$projname.srcs/sources_1/new
file mkdir $projpath/$projname/$projname.srcs/sources_1/bd
# Create 'constrs_1' fileset (if not found)
if {[string equal [get_filesets -quiet constrs_1] ""]} {
  create_fileset -constrset constrs_1
}
file mkdir $projpath/$projname/$projname.srcs/constrs_1/new
# Create 'sim_1' fileset (if not found)
if {[string equal [get_filesets -quiet sim_1] ""]} {
  create_fileset -simset sim_1
}
file mkdir $projpath/$projname/$projname.srcs/sim_1/new
# 添加IP
create_ip -name clk_wiz -vendor xilinx.com -library ip -version 6.0 -module_name clk_wiz_0
set_property -dict [list \
  CONFIG.CLKIN1_JITTER_PS {200.0} \
  CONFIG.CLKOUT1_JITTER {163.583} \
  CONFIG.CLKOUT1_PHASE_ERROR {160.484} \
  CONFIG.CLKOUT2_JITTER {175.348} \
  CONFIG.CLKOUT2_PHASE_ERROR {160.484} \
  CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {75} \
  CONFIG.CLKOUT2_USED {true} \
  CONFIG.MMCM_CLKFBOUT_MULT_F {19.500} \
  CONFIG.MMCM_CLKIN1_PERIOD {20.000} \
  CONFIG.MMCM_CLKIN2_PERIOD {10.0} \
  CONFIG.MMCM_CLKOUT0_DIVIDE_F {9.750} \
  CONFIG.MMCM_CLKOUT1_DIVIDE {13} \
  CONFIG.NUM_OUT_CLKS {2} \
  CONFIG.PRIM_IN_FREQ {50} \
] [get_ips clk_wiz_0]
generate_target {instantiation_template} [get_files $projpath/$projname/$projname.srcs/sources_1/ip/clk_wiz_0_1/clk_wiz_0.xci]

create_ip -name fifo_generator -vendor xilinx.com -library ip -version 13.2 -module_name fifo_ip
set_property -dict [list \
  CONFIG.Fifo_Implementation {Independent_Clocks_Block_RAM} \
  CONFIG.Input_Data_Width {16} \
  CONFIG.Input_Depth {512} \
  CONFIG.Read_Data_Count {true} \
  CONFIG.Write_Data_Count {true} \
] [get_ips fifo_ip]
generate_target {instantiation_template} [get_files $projpath/$projname/$projname.srcs/sources_1/ip/fifo_ip/fifo_ip.xci]

create_ip -name ila -vendor xilinx.com -library ip -version 6.2 -module_name ila_m0
set_property -dict [list \
  CONFIG.C_DATA_DEPTH {8192} \
  CONFIG.C_NUM_OF_PROBES {4} \
  CONFIG.C_PROBE0_WIDTH {16} \
  CONFIG.C_PROBE1_WIDTH {1} \
  CONFIG.C_PROBE2_WIDTH {1} \
  CONFIG.C_PROBE3_WIDTH {10} \
] [get_ips ila_m0]
generate_target {instantiation_template} [get_files $projpath/$projname/$projname.srcs/sources_1/ip/ila_m0/ila_m0.xci]
#*********************************************************************************************************
#添加源文件
add_files -fileset sources_1  -copy_to $projpath/$projname/$projname.srcs/sources_1/new -force -quiet [glob -nocomplain $tclpath/src/design/*.v]
add_files -fileset sim_1  -copy_to $projpath/$projname/$projname.srcs/sim_1/new -force -quiet [glob -nocomplain $tclpath/src/testbench/*.v]
#添加约束文件
add_files -fileset constrs_1  -copy_to $projpath/$projname/$projname.srcs/constrs_1/new -force -quiet [glob -nocomplain $tclpath/src/constraints/*.xdc]
#**********************************************************************************************************
set_property top_file "/$projpath/$projname/$projname.srcs/sources_1/new/$Topname.v" [current_fileset]
launch_runs synth_1 impl_1 -jobs 5
wait_on_run synth_1
wait_on_run impl_1
synth_design -top $Topname
opt_design
place_design
route_design
write_bitstream -force $projpath/$projname/$projname.runs/impl_1/$projname.bit
write_debug_probes -file $projpath/$projname/$projname.runs/impl_1/$projname.ltx
add_files -fileset sources_1  -copy_to $projpath -force -quiet [glob -nocomplain $projpath/$projname/$projname.runs/impl_1/*.bit]
add_files -fileset sources_1  -copy_to $projpath -force -quiet [glob -nocomplain $projpath/$projname/$projname.runs/impl_1/*.ltx]
