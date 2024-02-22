############################################################
## This file is generated automatically by Vitis HLS.
## Please DO NOT edit it.
## Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
## Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
############################################################
open_project sobel_focus
set_top sobel_focus
add_files source/sobel_focus.cpp -cflags "-I/media/alinx/nvme4t/yang/Vitis_Libraries-main/vision/L1/include -std=c++0x"
open_solution "solution1" -flow_target vivado
set_part {xc7z020clg484-2}
create_clock -period 10 -name default
#source "./sobel_focus/solution1/directives.tcl"
#csim_design
csynth_design
#cosim_design
export_design -rtl verilog -format ip_catalog
