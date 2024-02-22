# Xilinx Zynq 7000 系列开发板AX7010
## 开发板介绍
### 开发板简介
此款开发板使用的是Xilinx公司的Zynq7000系列的芯片，型号为XC7Z010-1CLG400I，
400 个引脚的 FBGA 封装。ZYNQ7000 芯片可分成处理器系统部分 Processor System（PS）
和可编程逻辑部分 Programmable Logic（PL）。在 AX7010 开发板上，ZYNQ7000 的 PS
部分和 PL 部分都搭载了丰富的外部接口和设备，方便用户的使用和功能验证。另外开发板上
集成了 Xilinx USB Cable 下载器电路，用户只要用一个 USB 线就可以对开发板进行下载和调
试。
### 关键特性
  1. +5V 电源输入,最大 2A 电流保护； 
  2. Xilinx ARM+FPGA 芯片 Zynq-7000 XC7Z010-1CLG400C   
  3. 两片大容量的 2Gbit（共 4Gbit）高速 DDR3 SDRAM,可作为 ZYNQ 芯片数据的缓存，也可以作为操作系统运行的内存;
  4. 一片 256Mbit 的 QSPI FLASH, 可用作 ZYNQ 芯片的系统文件和用户数据的存储;   
  5. 一路10/100M/1000M以太网RJ-45接口, 可用于和电脑或其它网络设备进行以太网数据交换; 
  6. 一路 HDMI 图像视频输入输出接口, 能实现 1080P 的视频图像传输； 
  7. 一路高速 USB2.0 HOST 接口, 可用于开发板连接鼠标、键盘和 U 盘等 USB 外设;
  8. 一路高速 USB2.0 OTG 接口, 用于和 PC 或 USB 设备的 OTG 通信; 
  9. 一路 USB Uart 接口, 用于和 PC 或外部设备的串口通信; 
  10. 一片的 RTC 实时时钟，配有电池座，电池的型号为 CR1220。  
  11. 一片 IIC 接口的 EEPROM 24LC04;
  12. 6 个用户发光二极管 LED, 2 个 PS 控制，4 个 PL 控制;
  13. 7 个按键，1 个 CPU 复位按键，2 个 PS 控制按键，4 个 PL 控制按键； 
  14. 板载一个 33.333Mhz 的有源晶振，给 PS 系统提供稳定的时钟源，一个 50MHz 的有源晶振，为 PL 逻辑提供额外的时钟；
  15. 2 路 40 针的扩展口（2.54mm 间距），用于扩展 ZYNQ 的 PL 部分的 IO。可以接 7寸 TFT 模块、摄像头模块和 AD/DA 模块等扩展模块；   
  16. 一个 12 针的扩展口（2.54mm 间距），用于扩展 ZYNQ 的 PS 系统的 MIO；
  17. 一路 USB JTAG 口，通过 USB 线及板载的 JTAG 电路对 ZYNQ 系统进行调试和下载。1 路 Micro SD 卡座(开发板背面），用于存储操作系统镜像和文件系统。


# AX7010 文档教程链接
https://ax7010-20231-v101.readthedocs.io/zh-cn/latest/7010_S1_RSTdocument_CN/00_%E5%85%B3%E4%BA%8EALINX_CN.html

 注意：文档的末尾页脚处可以切换中英文语言

# AX7010 例程
## 例程描述
此项目为开发板出厂例程，支持板卡上的大部分外设。
## 开发环境及需求
* Vivado 2023.1
* AX7010开发板
## 创建Vivado工程
* 下载最新的ZIP包。
* 创建新的工程文件夹.
* 解压下载的ZIP包到此工程文件夹中。


有两种方法创建Vivado工程，如下所示：
### 利用Vivado tcl console创建Vivado工程
1. 打开Vivado软件并且利用**cd**命令进入"**auto_create_project**"目录，并回车
```
cd \<archive extracted location\>/vivado/auto_create_project
```
2. 输入 **source ./create_project.tcl** 并且回车
```
source ./create_project.tcl
```

### 利用bat创建Vivado工程
1. 在 "**auto_create_project**" 文件夹, 有个 "**create_project.bat**"文件, 右键以编辑模式打开，并且修改vivado路径为本主机vivado安装路径，保存并关闭。
```
CALL E:\XilinxVitis\Vivado\2023.1\bin\vivado.bat -mode batch -source create_project.tcl
PAUSE
```
2. 在Windows下双击bat文件即可。


更多信息, 请访问[ALINX网站](https://www.alinx.com)