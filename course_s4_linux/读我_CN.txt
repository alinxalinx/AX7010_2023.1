#////////////////////////////////////////////////////////////////////////////////
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

文档使用说明：

文档结构
course_s1
   ├── 01_led/                     # 用于恢复vivado工程的Tcl脚本文件夹（包括所需源文件）
   │   │
   │   │ 
   │   └── auto_create_project/                         # 创建vivado工程
   │        ├── src/  #创建vivado工程的源文件、批处理文件、tcl文件
   │        │         ├── block_design  #BD文件
   │        │         ├── constraints   #约束文件
   │        │         ├── design        #.v源文件
   │        │         └── testbench     #激励文件
   │        │ 
   │        ├── led.bat  #.bat批处理文件
   │        └── led.tcl  #Tcl脚本文件
   │ 
   ├──  02_pll/
   └──  ....../

course_s2
   ├── 01_ps_hello/                          # 用于恢复vivado工程的Tcl脚本文件夹（包括所需源文件）
   │   │
   │   ├── Bootimage                         #存放的boot.bin文件
   │   │
   │   ├── Vitis                             # vitis工程
   │   │    ├── auto_create_vitis/           #创建vitis工程的源文件、.bat批处理文件、tcl文件
   │   │    │         ├── src                #.C/.h源文件
   │   │    │         ├── build_vitis.bat    #批处理文件
   │   │    │         └── build_vitis.tcl    #tcl文件
   │   │    │         
   │   │    └── design_1_wrapper.xsa         #硬件信息
   │   │ 
   │   └── Vivado                             # vivado工程
   │        ├── auto_create_project/          #创建vivado工程的源文件、.bat批处理文件、tcl文件
   │        │         ├── my_ip/              #自定义IP
   │        │         ├── src/                #源文件、约束文件、激励文件
   │        │         ├── create_project.bat  #批处理文件
   │        │         ├── create_project.tcl  #tcl文件
   │        │         ├── pl_config.tcl       #PL端tcl文件
   │        │         └── ps_config.tcl       #PS端tcl文件
   │        │
   │        └── design_1_wrapper.bit  #比特流文件
   │ 
   ├──  02_ps_timer/
   └──  ....../


创建Vivado工程步骤

1.解压压缩包
2.打开对应工程；例如：C:\Users\Administrator\Desktop\vivado_2023.1\AX7010_2023.1\course_s1_fpga\01_led
3.打开S1教程打开auto_create_project文件夹；S2教程打开vivado/auto_create_project文件夹
4.用文本编辑器打开create_project.bat文件，修改D:\Xilinx2023.1\Vivado\2023.1\bin\vivado.bat路径到自己的2023.1版本下，保存
5.双击create_project.bat文件，等待vivado创建工程
6.完成工程的创建，在create_project.bat文件的上一级目录下可以看到刚生成的vivado工程文件夹
7.双击打开对应的工程文件夹中的.xpr文件
8.等待GUI界面的打开

创建Vitis工程步骤

1.解压压缩包
2.打开对应工程；例如：C:\Users\Administrator\Desktop\vivado_2023.1\AX7010_2023.1\course_s2_vitis\01_ps_hello
3.打开S2教程Vitis/auto_create_vitis文件夹
4.用文本编辑器打开build_vitis.bat文件，修改D:\Xilinx2023.1\Vitis\2023.1\bin\xsct.bat路径到自己的2023.1版本下，保存
5.双击build_vitis.bat文件，等待创建vitis工程
6.完成工程的创建，在build_vitis.bat文件的上一级目录下可以看到刚生成的vitis工程文件夹
7.运行vitis软件，找到C:\Users\Administrator\Desktop\vivado_2023.1\AX7010_2023.1\course_s2_vitis\01_ps_hello\Vitis这个路径下
8.完成vitis工程的创建