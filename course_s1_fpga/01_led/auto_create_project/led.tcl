#////////////////////////////////////////////////////////////////////////////////
#  project：PL LED experiment                                                  //
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
set projname "vivado_led"
set Topname "led"
set tclpath [pwd]
cd ..
set projpath [pwd]
#创建工程
#**********************************************************************************************************
create_project -force $projname $projpath/$projname -part xc7z010clg400-1
# Create 'sources_1' fileset (if not found)；file mkdir创建ip、new、bd三个子文件
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

create_ip -name ila -vendor xilinx.com -library ip -version 6.2 -module_name ila
set_property -dict [list \
  CONFIG.C_NUM_OF_PROBES {2} \
  CONFIG.C_PROBE0_WIDTH {32} \
  CONFIG.C_PROBE1_WIDTH {4} \
] [get_ips ila]
generate_target {instantiation_template} [get_files $projpath/$projname/$projname.srcs/sources_1/ip/ila/ila.xci]

#************************************************************************************************************
#添加源文件
add_files -fileset sources_1  -copy_to $projpath/$projname/$projname.srcs/sources_1/new -force -quiet [glob -nocomplain $tclpath/src/design/*.v]
add_files -fileset sim_1  -copy_to $projpath/$projname/$projname.srcs/sim_1/new -force -quiet [glob -nocomplain $tclpath/src/testbench/*.v]
#添加约束文件
add_files -fileset constrs_1  -copy_to $projpath/$projname/$projname.srcs/constrs_1/new -force -quiet [glob -nocomplain $tclpath/src/constraints/*.xdc]
#*************************************************************************************************************
# 设置顶层文件属性
set_property top_file "/$projpath/$projname/$projname.srcs/sources_1/new/$Topname.v" [current_fileset]
# 综合
launch_runs synth_1 impl_1 -jobs 5
wait_on_run synth_1
wait_on_run impl_1
#运行综合、实现和生成比特流
#指定综合顶层模块
synth_design -top $Topname
#执行逻辑综合优化，主要是优化逻辑电路的面积、时钟频率、功耗等指标
opt_design
#执行布局，将逻辑元素映射到物理位置，并考虑时序约束
place_design
#执行布线，将物理电路中的逻辑元素通过信号线连接在一起
route_design
#将比特流写入到指定的文件中，即生成.bit文件。-force参数用于强制覆盖已有的文件
write_bitstream -force $projpath/$projname/$projname.runs/impl_1/$projname.bit
#生成用于调试的信号探针，将信号探针写入到指定的文件中，即生成.ltx文件
write_debug_probes -file $projpath/$projname/$projname.runs/impl_1/$projname.ltx
#copy比特流文件到工作目录方便使用
add_files -fileset sources_1  -copy_to $projpath -force -quiet [glob -nocomplain $projpath/$projname/$projname.runs/impl_1/*.bit]
add_files -fileset sources_1  -copy_to $projpath -force -quiet [glob -nocomplain $projpath/$projname/$projname.runs/impl_1/*.ltx]