#////////////////////////////////////////////////////////////////////////////////
#  project：audio_test                                                         //
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
set proj_name "audio_test"
set tclpath [pwd]
cd ..
set projpath [pwd]
cd ..
set Vitispath [pwd]
set bdname "design_1"
#创建工程
#**********************************************************************************************************
create_project -force $proj_name $projpath/$proj_name -part xc7z010clg400-1
# Create 'sources_1' fileset (if not found)
if {[string equal [get_filesets -quiet sources_1] ""]} {
  create_fileset -srcset sources_1
}
file mkdir $projpath/$proj_name/$proj_name.srcs/sources_1/ip
file mkdir $projpath/$proj_name/$proj_name.srcs/sources_1/new
file mkdir $projpath/$proj_name/$proj_name.srcs/sources_1/bd
# Create 'constrs_1' fileset (if not found)
if {[string equal [get_filesets -quiet constrs_1] ""]} {
  create_fileset -constrset constrs_1
}
file mkdir $projpath/$proj_name/$proj_name.srcs/constrs_1/new
# Create 'sim_1' fileset (if not found)
if {[string equal [get_filesets -quiet sim_1] ""]} {
  create_fileset -simset sim_1
}
file mkdir $projpath/$proj_name/$proj_name.srcs/sim_1/new
# 添加自定义IP
set_property  ip_repo_paths  $tclpath/my_ip [current_project]
update_ip_catalog
#*********************************************************************************************************
#create_bd_design "$bdname"
create_bd_design $bdname
update_compile_order -fileset sources_1
open_bd_design $projpath/$proj_name/$proj_name.srcs/sources_1/bd/$bdname/$bdname.bd
create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0
source $tclpath/ps_config.tcl
set_ps_config processing_system7_0
source $tclpath/pl_config.tcl
regenerate_bd_layout
validate_bd_design
save_bd_design
make_wrapper -files [get_files $projpath/$proj_name/$proj_name.srcs/sources_1/bd/$bdname/$bdname.bd] -top
add_files -norecurse [glob -nocomplain $projpath/$proj_name/$proj_name.gen/sources_1/bd/$bdname/hdl/*.v]
puts $bdname
append bdWrapperName $bdname "_wrapper"
puts $bdWrapperName
# 设置顶层文件属性
set_property top $bdWrapperName [current_fileset]

#*********************************************************************************************************
#添加约束文件
add_files -fileset constrs_1  -copy_to $projpath/$proj_name/$proj_name.srcs/constrs_1/new -force -quiet [glob -nocomplain $tclpath/src/constraints/*.xdc]
#运行综合、实现和生成比特流
launch_runs synth_1 impl_1 -jobs 5
wait_on_run synth_1
wait_on_run impl_1
synth_design -top $bdWrapperName
opt_design
place_design
route_design
write_bitstream -force $projpath/$proj_name/$proj_name.runs/impl_1/$bdWrapperName.bit
# 生成硬件平台文件
write_hw_platform -fixed -include_bit -force -file $Vitispath/Vitis/$bdWrapperName.xsa
add_files -fileset sources_1  -copy_to $projpath -force -quiet [glob -nocomplain $projpath/$proj_name/$proj_name.runs/impl_1/*.bit]


