############################################################
## This file is generated automatically by Vitis HLS.
## Please DO NOT edit it.
## Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
## Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
############################################################
open_project contrast_adj
set_top contrastadj
add_files source/contrastadj.cpp -cflags "-I/media/alinx/nvme4t/yang/Vitis_Libraries-main/vision/L1/include -std=c++0x"
add_files source/contrastadj.h
add_files source/xf_headers.hpp
open_solution "solution1" -flow_target vivado
set_part {xc7z020clg484-2}
create_clock -period 10 -name default
#source "./contrast_adj/solution1/directives.tcl"
#csim_design
csynth_design
#cosim_design
export_design -rtl verilog -format ip_catalog
