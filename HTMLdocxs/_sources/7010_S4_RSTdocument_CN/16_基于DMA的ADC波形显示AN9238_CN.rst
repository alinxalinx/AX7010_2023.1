基于DMA的ADC波形显示（AN9238）
==============================

**例程相关文件夹：an9238_wave**

**Vivado工程在vivado.zip压缩包中：an9238_wave**

在SDK裸机例程里我们用DMA将ADC模块AN9238的数据采集到ddr中然后显示出波形，在上面的例程用我们也学习了DMA的读写测试，我们再这个读写测试的基础上写了一个ADC驱动，所以请大家在学习本章内容时请熟练掌握前面的例程。

例程资料中给出了vivado工程，petalinux工程，以及波形显示app。

ADC驱动
-------

1) ADC驱动是内核drivers/dma/xilinx目录中的axi_adc_dma.c，驱动编写时参考了同目录下的axidmatest.c文件和Xilinx官方例程“xapp1183”。

内核驱动配置
------------

内核驱动中涉及到drm显示的部分请参考第八章HDMI显示的内核配置，可以在HDMI显示的工程基础上添加下列配置，也可以用BSP包重新生成工程。

1) 和前面的例程一样要配置一些外设显示的驱动，这里不再复述，主要是要额外配置ADC的驱动，在Device
   Drivers > DMA Engine support > Xilinx DMA Engines选项中选择<*> ALINX
   ADC DMA Test client for AXI DMA

.. image:: images/16_media/image1.png
   
设备树配置
----------

1) 这里是修改了驱动的匹配选项，compatible =
   "alinx,axi-adc-dma";用于匹配驱动程序。详细设备树可以参考例程petalinux工程目录下project-spec/meta-user/recipes-bsp/device-tree/files/system-user.dtsi文件

.. image:: images/16_media/image2.png
   
2) 设备树修改技巧，先编译一次，然后到components/plnx_workspace/device-tree/device-tree-generation目录下找到pl.dtsi这里包含了所有PL端外设的设备树信息，最好不要直接修改这个文件，plnx_arm-system.dts是最后生成的文件，也是非常重要的信息，开发者可以自己好好研究一下这些文件。

.. image:: images/16_media/image3.png

应用程序
--------

1) 应用程序采用Vitis编写，Vitis建立Linux应用程序的方法在前面的教程中讲到。

.. image:: images/16_media/image4.png

2) 程序没有使用QT，而是直接绘制framebuffer，frame_buffer.c文件为Linux的fb操作。

3) adc_capture.c为波形采集模块，主要是打开ADC驱动

4) 波形绘制函数完全来自裸机SDK

运行结果
--------

1) 资料包中给出了编译好的程序在sd_boot目录，所有文件复制到sd卡根目录运行即可。

2) 给AN9238第一通道输入峰峰值为5V，频率1Mhz的正弦波，波形显示如下。

.. image:: images/16_media/image5.png
   
.. image:: images/16_media/image6.png

AX7021硬件连接图（J15扩展口）

.. image:: images/16_media/image7.png

AX7020/AX7010硬件连接图（J11扩展口）

常见问题
--------

内核崩溃
~~~~~~~~

启动过程中有一定几率内核崩溃，原因未知，需要重启开发板

.. image:: images/16_media/image8.png
