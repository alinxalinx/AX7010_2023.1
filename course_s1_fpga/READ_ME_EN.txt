
#////////////////////////////////////////////////////////////////////////////////
# //
# Author: JunFN //
# 853808728@qq.com //
# ALINX(shanghai) Technology Co., Ltd //
# Black gold //
# WEB: http://www.alinx.cn/ //
# //
#////////////////////////////////////////////////////////////////////////////////
# //
# Copyright (c) 2017,ALINX(shanghai) Technology Co., Ltd //
# All rights reserved //
# //
# This source file may be used and distributed without restriction provided //
# that this copyright statement is not removed from the file and that any //
# derivative work contains the original copyright notice and the associated //
# disclaimer. //
# // 
#////////////////////////////////////////////////////////////////////////////////

#================================================================================
# Revision History.
# Date By Revision Change Description
# --------------------------------------------------------------------------------
# 2023/8/22 1.0 Original
#=================================================================================

Documentation usage instructions:

document structure
course_s1
   ├── 01_led/ # Tcl script folder for restoring vivado project (including required source files)
   │ │
   │ │ 
   │ └── auto_create_project/ # Create vivado project
   │ ├── src/ #create source, batch, and tcl files for vivado project
   │ │ ├── block_design #BD file
   │ │ ├── constraints # constraints file
   │ │ ├── design #.v source file
   │ │ └── testbench #stimulus file
   │ │ 
   │ ├── led.bat #.bat batch file
   │ └── led.tcl #Tcl script file
   │ 
   ├── 02_pll/
   └── ...... /

course_s2
   ├── 01_ps_hello/ # Tcl script folder for restoring vivado project (including required source files)
   │ │
   │ ├── Bootimage #stored boot.bin file
   │ │
   │ ├── Vitis # vitis project
   │ │ ├── auto_create_vitis/ #create vitis project source files, .bat batch files, tcl files
   │ │ │ ├── src #.C/.h source file
   │ │ │ ├── build_vitis.bat #Batch file
   │ │ │ └── build_vitis.tcl #tcl file
   │ │ │   
   │ │ └── design_1_wrapper.xsa #Hardware information
   │ │ 
   │ └── Vivado # vivado project
   │ ├── auto_create_project/ #create vivado project source files, .bat batch files, tcl files
   │ │ ├── my_ip/ #Customize IP
   │ │ ├── src/ # source, constraint, and incentive files
   │ │ ├── create_project.bat #batch file
   │ │ ├── create_project.tcl #tcl file
   │ │ ├── pl_config.tcl #PL side tcl file
   │ └── ps_config.tcl #PS-side tcl file
   │ │
   │ └── design_1_wrapper.bit #bitstream file
   │ 
   ├── 02_ps_timer/
   └── ...... /


Steps to Create a Vivado Project

1. Unzip the zip package
2. Open the corresponding project; for example: C:\Users\Administrator\Desktop\vivado_2023.1\AX7010_2023.1\course_s1_fpga\01_led
3. Open the S1 tutorial to open the auto_create_project folder; S2 tutorial to open the vivado/auto_create_project folder
4. Open the create_project.bat file with a text editor, modify the path of D:\Xilinx2023.1\Vivado\2023.1\bin\vivado.bat to your own 2023.1 version, save!
5. Double-click create_project.bat file, waiting for Vivado to create the project
6. Complete the creation of the project, in the create_project.bat file in the previous directory you can see just generated vivado project folder
7. Double-click to open the .xpr file in the corresponding project folder.
8. Wait for the GUI interface to open

Steps to create a Vitis project

1. Unzip the zip package
2. Open the corresponding project; for example: C:\Users\Administrator\Desktop\vivado_2023.1\AX7010_2023.1\course_s2_vitis\01_ps_hello
3. Open the S2 Tutorial Vitis/auto_create_vitis folder
4. Open the build_vitis.bat file with a text editor, modify the path of D:\Xilinx2023.1\Vitis\2023.1\bin\xsct.bat to your own version of 2023.1 and save it.
5. Double-click the build_vitis.bat file and wait for the vitis project to be created
6. Complete the creation of the project, in the build_vitis.bat file in the previous directory you can see just generated vitis project folder
7. Run the vitis software and find the path C:\Users\Administrator\Desktop\vivado_2023.1\AX7010_2023.1\course_s2_vitis\01_ps_hello\Vitis
8. Complete the creation of the vitis project