SD卡读写操作之BMP图片显示
===========================

**实验Vivado工程为“sd_hdmi_out”。**

本章介绍使用FatFs文件系统模块读取SD卡的BMP图片，并通过HDMI显示。

FatFs简介
---------

FatFs是一个通用的文件系统模块，用于在小型嵌入式系统中实现FAT文件系统。FatFs的编写遵循 ANSI C，因此不依赖于硬件平台。它可以嵌入到便宜的微控制器中，如 8051, PIC, AVR, SH, Z80, H8, ARM等等，不需要做任何修改。

应用程序通过API函数来调用FatFs系统模块，从而来控制SD卡这些存储设备。

.. image:: images/25_media/image1.png
      
FatFs 系统提供了很多 API 函数，我们在下面列举了以下我们例程中会用的的 API 函数。

f_mount - 注册/注销一个工作区域（Work Area）

f_open - 打开/创建一个文件

f_close - 关闭一个文件

f_read - 读文件

f_write - 写文件

关于 API 函数的介绍和说明，大家可以参考以下的网站进行更深一步的了解，这个网站上

给出来了每个 API 函数的使用说明和例子。

http://elm-chan.org/fsw/ff/00index_e.html

硬件工程的建立
--------------

这里的硬件工程跟VDMA结合HDMI的显示例程是一样的。

Vitis程序开发
-------------

1. 打开Vitis软件，我们已经为大家生成了一个 bmp_read 的工程。这里需要配置BSP支持包的属性，在Board Support Package Settings里选择xilffs项，使能项目支持xilffs文件系统。

.. image:: images/25_media/image2.png
      
关于xilffs库是Xilinx提供的FAT文件系统支持包，用户可以调用库里的API函数实现对

SD/eMMC等设备的操作。xilffs库里主要包含FAT的文件系统(File System Files)和驱动层文件(Glue Layer Files)。

2. 关于xilffs库的介绍和应用，大家可以参考以下Xilinx官网链接： http://www.wiki.xilinx.com/xilffs

1. 接下来我们来看 bmp_read 的工程代码。在工程代码里，我们需要把 SD 卡里存储的 bmp格式的图像数据读出来，去掉图像头后放到 VDMA 的显示缓冲区中，然后实现图像在HDMI 显示器里的显示。

..

   在 main.c 文件里，我们添加了一个 bmp_read
   的函数，在这个函数里首先用f_open函数打开一个 SD
   卡里的bmp的图片文件。然后读取这个文件的前面 54
   个字节，因为BMP图像文件的前面54个字节为图像头文件，里面包含了图像的像素大小信息。再一行一行的读取图像数据存到
   VDMA 的 frame 显示缓冲区中。

由于BMP的存储是上下颠倒的，因此在bmp_read函数中调整了顺序，存入frame缓存区。

.. image:: images/25_media/image3.png
            
4. 同时我们也准备了BMP文件头结构体，以及一些常用分辨率的图像头设置，放在bmp.h文件中。

.. image:: images/25_media/image4.png
      
5. 结合之前小猫图片的显示，将小猫图片保存成bmp格式，保存到SD卡里，在bmp_write函数中，结合bmp头和bmp数据，保存到SD卡。

.. image:: images/25_media/image5.png
      
6. 在main函数里，调用bmp_read函数实现一副图像从SD卡读取到VDMA显示缓冲的存储，这里的 BMP 图像的文件名1.bmp需要和存储在SD卡里的文件名一样。用bmp_write，将小猫图片写入SD卡。

.. image:: images/25_media/image6.png
      
板上验证
--------

1. 首先需要先存一副1920*1080像素，24bit的BMP文件到SD卡里，文件名为1.bmp（文件在工程目录下），开发板断电情况下，把SD卡插入卡座里。

.. image:: images/25_media/image7.png
      
2. 开发板连接HDMI显示器，然后上电，下载程序运行之后我们可以在HDMI显示器上显示SD卡里存储的1.bmp文件的图像。

.. image:: images/25_media/image8.png
      
AX7015硬件连接图

.. image:: images/25_media/image9.png
      
AX7021硬件连接图

.. image:: images/25_media/image10.png
      
AX7020/AX7010硬件连接图

.. image:: images/25_media/image11.png
      
AX7Z035/AX7Z100硬件连接图

3. 之后可将开发板断电，将SD卡插到电脑上，可以看到多了CAT.BMP

.. image:: images/25_media/image12.png
      