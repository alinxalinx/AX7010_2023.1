AXI DMA读写测试
===============

**例程相关文件夹：sg_dma_test**

**Vivado工程在vivado.zip压缩包中：sg_dma_test**

在前面的SDK裸机例程中我们大量讲解了如何使用DMA，现在我们要在Linux下使用DMA，需要说明的是，这里使用的DMA支持“Scatter
Gather”，也就是SG-DMA。Xilinx提供了DMA驱动和DMA测试程序，测试程序也是一个驱动，从这可以看出，如果要使用DMA，就算有了DMA驱动，我们还是要开发一个DMA驱动客户端，称为DMA
client，所以DMA的使用是有一定的门槛，对于Linux门外汉来说非常有挑战。

vivado工程
----------

1) 和SDK下测试DMA类似，添加DMA的IP，选择“Enable Scatter Gather Engine”

.. image:: images/15_media/image1.png

2) 添加一个“AXI4-Stream Data
   FIFO”，然后将DMA的MM2S（读端口）和S2MM（写端口）端口连接，组成一个读写环路，用于测试DMA功能。

.. image:: images/15_media/image2.png

petalinux工程配置
-----------------

1) 使用Vivado工程导出的xsa文件创建petalinux工程

2) 配置DMA测试客户端驱动，在Device Drivers > DMA Engine support > Xilinx
   DMA Engines中使能DMA Test client for AXI DMA

.. image:: images/15_media/image3.png
   
3) 修改设备树，将petalinux工程中的system-user.dtsi文件修改如下

+-----------------------------------------------------------------------+
| /include/ "system-conf.dtsi"                                          |
|                                                                       |
| / {                                                                   |
|                                                                       |
| axidmatest_0: axidmatest {                                            |
|                                                                       |
| compatible ="xlnx,axi-dma-test-1.00.a";                               |
|                                                                       |
| dmas = <&axi_dma_0 0                                                  |
|                                                                       |
| &axi_dma_0 1>;                                                        |
|                                                                       |
| dma-names = "axidma0", "axidma1";                                     |
|                                                                       |
| } ;                                                                   |
|                                                                       |
| };                                                                    |
+-----------------------------------------------------------------------+

运行测试
--------

1) 编译生成BOOT.BIN和image.ub

2) 将BOOT.BIN和image.ub复制到sd卡中，开发板sd卡模式启动运行

3) 测试结果可以看到，DMA读写环通测试5次，没有错误

+-----------------------------------------------------------------------+
| dma1chan0-dma1c: terminating after 5 tests, 0 failures 632 iops 34138 |
| KB/s (status 0)                                                       |
+-----------------------------------------------------------------------+

.. image:: images/15_media/image4.png
   