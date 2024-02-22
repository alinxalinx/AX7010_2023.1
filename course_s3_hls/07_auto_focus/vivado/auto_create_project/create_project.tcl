#////////////////////////////////////////////////////////////////////////////////
#  project锛歭inux_base                                                         //
#                                                                              //
#  Author: JunFN                                                               //
#          853808728@qq.com                                                    //
#          ALINX(shanghai) Technology Co.,Ltd                                  //
#          榛戦噾                                                                //
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

#璁剧疆椤圭洰鍚嶇О鍜屽伐浣滅洰褰?
set proj_name "auto_focus"
set tclpath [pwd]
cd ..
set projpath [pwd]
cd ..
set Vitispath [pwd]
set bdname "design_1"
#鍒涘缓宸ョ▼
#**********************************************************************************************************
create_project -force $proj_name $projpath/$proj_name -part xc7z010clg400-2
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
# 娣诲姞鑷畾涔塈P
set_property  ip_repo_paths  $tclpath/ip/ [current_project]
update_ip_catalog
#*********************************************************************************************************
#create_bd_design "$bdname"
create_bd_design $bdname
update_compile_order -fileset sources_1
open_bd_design $projpath/$proj_name/$proj_name.srcs/sources_1/bd/$bdname/$bdname.bd
source $tclpath/design_1.tcl
regenerate_bd_layout
validate_bd_design
save_bd_design
make_wrapper -files [get_files $projpath/$proj_name/$proj_name.srcs/sources_1/bd/$bdname/$bdname.bd] -top
add_files -norecurse [glob -nocomplain $projpath/$proj_name/$proj_name.gen/sources_1/bd/$bdname/hdl/*.v]
puts $bdname
append bdWrapperName $bdname "_wrapper"
puts $bdWrapperName
# 璁剧疆椤跺眰鏂囦欢灞炴€?
set_property top $bdWrapperName [current_fileset]

#*********************************************************************************************************
#娣诲姞绾︽潫鏂囦欢
add_files -fileset constrs_1  -copy_to $projpath/$proj_name/$proj_name.srcs/constrs_1/new -force -quiet [glob -nocomplain $tclpath/src/constraints/*.xdc]
#杩愯缁煎悎銆佸疄鐜板拰鐢熸垚姣旂壒娴?
launch_runs synth_1 impl_1 -jobs 5
wait_on_run synth_1
wait_on_run impl_1
synth_design -top $bdWrapperName
opt_design
place_design
route_design
write_bitstream -force $projpath/$proj_name/$proj_name.runs/impl_1/$bdWrapperName.bit
# 鐢熸垚纭欢骞冲彴鏂囦欢
write_hw_platform -fixed -include_bit -force -file $Vitispath/Vitis/$bdWrapperName.xsa
add_files -fileset sources_1  -copy_to $projpath -force -quiet [glob -nocomplain $projpath/$proj_name/$proj_name.runs/impl_1/*.bit]


