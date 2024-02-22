#////////////////////////////////////////////////////////////////////////////////
#  project：lcd7_touch                                                         //
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
set proj_name "lcd7_touch"
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
#set_property  ip_repo_paths  $tclpath/alinx_ip [current_project]
#update_ip_catalog

create_peripheral xilinx.com user ax_pwm 1.0 -dir $projpath/$proj_name/../ip_repo
add_peripheral_interface S00_AXI -interface_mode slave -axi_type lite [ipx::find_open_core xilinx.com:user:ax_pwm:1.0]
generate_peripheral -driver -bfm_example_design -debug_hw_example_design [ipx::find_open_core xilinx.com:user:ax_pwm:1.0]
write_peripheral [ipx::find_open_core xilinx.com:user:ax_pwm:1.0]
set_property  ip_repo_paths  $projpath/$proj_name/../ip_repo/ax_pwm_1_0 [current_project]
update_ip_catalog -rebuild
ipx::edit_ip_in_project -upgrade true -name ax_pwm_v1_0_project -directory $projpath/$proj_name/$proj_name.tmp/ax_pwm_v1_0_project $projpath/ip_repo/ax_pwm_1_0/component.xml
add_files -norecurse -copy_to $projpath/ip_repo/ax_pwm_1_0/src $tclpath/my_ip/ax_pwm_1_0/ax_pwm.v
add_files -force -norecurse -copy_to $projpath/ip_repo/ax_pwm_1_0/hdl $tclpath/my_ip/ax_pwm_1_0/ax_pwm_v1_0.v
add_files -force -norecurse -copy_to $projpath/ip_repo/ax_pwm_1_0/hdl $tclpath/my_ip/ax_pwm_1_0/ax_pwm_v1_0_S00_AXI.v
update_compile_order -fileset sources_1
ipx::remove_file_group xilinx_softwaredriver [ipx::current_core]
ipx::merge_project_changes files [ipx::current_core]
ipx::merge_project_changes hdl_parameters [ipx::current_core]
set_property core_revision 5 [ipx::current_core]
ipx::update_source_project_archive -component [ipx::current_core]
ipx::create_xgui_files [ipx::current_core]
ipx::update_checksums [ipx::current_core]
ipx::check_integrity [ipx::current_core]
ipx::save_core [ipx::current_core]
ipx::move_temp_component_back -component [ipx::current_core]
close_project -delete
update_ip_catalog -rebuild -repo_path $projpath/ip_repo/ax_pwm_1_0
set_property  ip_repo_paths  $projpath/ip_repo/ax_pwm_1_0 [current_project]
update_ip_catalog
#update_ip_catalog -rebuild
update_ip_catalog -add_ip $tclpath/alinx_ip/axi_dynclk_v1_0/component.xml -repo_path $projpath/ip_repo/ax_pwm_1_0
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


