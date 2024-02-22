DMA环通测试
=============

**实验Vivado工程为“dma_loopback”。**

本章介绍一个重要的功能模块，DMA（Direct Memory
Access，直接内存存取），是指外部设备不通过CPU直接与系统内存交换数据的接口技术。要将外设数据读入内存或将内存传送到外设，一般都要通过CPU控制完成，如采用查询或中断方式。如前面讲到的BRAM实验。

虽然中断方式可以提高CPU的利用率，但是也会有效率问题，对于批量传送数据的情况，采用DMA方式，可解决效率与速度问题，CPU只需要提供地址和长度给DMA，DMA即可接管总线，访问内存，等DMA完成工作后，告知CPU，交出总线控制权。

本章中采用Vitis给的DMA例子，稍做修改，在DMA工作结束后，发出结束中断，告知CPU，使CPU读取内存数据。

.. image:: images/15_media/image1.png
      
实验说明
--------

参考DMA文档PG021

1. 先来认识下AXI DMA模块，此模块用到了三种总线，AXI4-Lite用于对寄存器进行配置，AXI4 Memory Map用于与内存交互，在此模块中又分立出了AXI4 Memory Map Read和AXI4 Memory Map Write两个接口，又分别叫做M_AXI_MM2S和M_AXI_S2MM，一个是读一个是写，这里要搞清楚，不能混淆。AXI4 Stream接口用于对外设的读写，其中AXI4 Stream Master（MM2S）用于对外设写，AXI4-Stream Slave(S2MM)用于对外设读。另外还支持Scatter/Gather功能，但本实验不再讲述，留待用户研究。（MM2S表示Memory Map to Stream，S2MM表示Stream to Memory Map）。

..

   AXI Memory Map 数据宽度支持32，64，128，256，512，1024bits
   AXI Stream 数据宽度支持8，16，32，64，128，256，512，1024bits

.. image:: images/15_media/image2.png
      
2. 本实验中采用直接寄存器模式，如下图为寄存器说明，主要分为两部分，一是MM2S，包括Control Register，Status Register，Source Address，Transfer Length四部分，二是S2MM，同样包括Control Register，Status Register，Destination Address，Buffer Length四部分，注意这里的Source Address和Destination Address指的是内存地址。

.. image:: images/15_media/image3.png
      
.. image:: images/15_media/image4.png
      
3. 以下为MM2S_DMACR控制寄存器说明，比较重要的是Bit0，Run/Stop，表示开启或停止DMA。

其他内容不再讲述。

.. image:: images/15_media/image5.png
      
.. image:: images/15_media/image6.png
      
在这里有几个中断可以设置，IOC_IrqEn，使能完成中断，Dly_IrqEn使能延迟中断，Err_IrqEn使能错误中断。

.. image:: images/15_media/image7.png
      
4. MM2S_DMASR为状态寄存器说明，bit12,13,14为中断状态，写1可清除中断。

.. image:: images/15_media/image8.png
      
.. image:: images/15_media/image9.png
      
5. MM2S_DA，MM2S_LENGTH代表地址和长度设置，S2MM端的寄存器与MM2S类似，不再讲述，本实验功能是MM2S从DDR3中读取数据，写到AXI Stream Data FIFO，再从FIFO读出写到DDR3，实现环通测试，需要打开S2MM_DMACR的IOC_Irq，即写内存结束中断，功能框图如下所示：

.. image:: images/15_media/image10.png

硬件环境搭建
------------

1. 以”ps_hello”工程为基础。实验中，需要用到HP接口，高速访问DDR3：

.. image:: images/15_media/image11.png
      
设置如下：

.. image:: images/15_media/image12.png
      
2. 打开PL-PS中断接口，连接DMA中断

.. image:: images/15_media/image13.png
      
3. 设置时钟100MHz，用于PL端AXI的时钟

.. image:: images/15_media/image14.png
      
4. 点击”+”，添加DMA模块。

.. image:: images/15_media/image15.png
      
5. DMA设置如下，Width of Buffer Length Register指的是LENGTH寄存器的宽度，如23bits，也就是最大传输2^26= 67,108,864bytes，这里按默认设置14，打开读和写通道，不打开Allow Unaligned Transfers，如果不打开，Memory Map Data Width设置为32，那么地址就必须是0x0，0x4，0x8，0xC等，按4字节对齐。Max Busrt Size可以设置为2, 4, 8, 16, 32, 64, 128, 256。

.. image:: images/15_media/image16.png
      
6. AXI Stream Data FIFO设置如下，设置深度为1024，TDATA Width为4字节，也就是32位，打开TKEEP，TLAST信号

.. image:: images/15_media/image17.png
      
7. 自动连接

.. image:: images/15_media/image18.png
      
继续自动连接

.. image:: images/15_media/image19.png
      
8. 连接FIFO的S_AXIS和M_AXIS到dma（AXIS为AXI Stream的缩写），继续点击Run Connection Automation

.. image:: images/15_media/image20.png
      
9. 添加Concat，连接MM2S和S2MM中断输出到IRQ_F2P

.. image:: images/15_media/image21.png
      
10. 最终连线如下图所示

.. image:: images/15_media/image22.png
      
11. 选择fifo的S_AXI,M_AXI，count信号，右键选择Debug，添加ILA逻辑分析仪，观察数据变化。

.. image:: images/15_media/image23.png
      
.. image:: images/15_media/image24.png
      
12. 自动连接后，打开ila配置

.. image:: images/15_media/image25.png
      
将Number of Probes改为4，添加两个Probe接口

.. image:: images/15_media/image26.png
      
连接新添加的两个Probe到DMA的中断输出

.. image:: images/15_media/image27.png
      
13. 保存设计，生成bitstream

.. image:: images/15_media/image28.png
      
Vitis程序开发
-------------

1. 本实验程序是根据simple_poll例子做的修改，在BSP里可以通过导入例子来学习模块的应用。

.. image:: images/15_media/image29.png
      
2. 设置MAX_PKT_LEN，也就是长度，单位为字节，TEST_START_VALUE为起始的数据值，NUMBER_OF_TRANSFERS为测试次数。

.. image:: images/15_media/image30.png
      
3. 定义发送和接收数组

.. image:: images/15_media/image31.png
      
4. 在XAxiDma_Setup函数中，打开S2MM的IOC中断，关闭MM2S的所有中断。在S2MM接收完数据后会发出中断。

.. image:: images/15_media/image32.png
      
5. 在XAxiDma_Setup函数，初始化TxBufferPtr之后，需要将Cache里的数据刷新到内存中，这里非常重要，由于DMA需要访问DDR3，而CPU与DDR3之间是通过Cache交互的，数据暂存在Cache里，可能没有真正刷新到DDR3，如果外部设备也就是DMA想要读取DDR3的值，必须将Cache里的数据刷新到DDR3中，这样DMA才能读到正确的值。调用Xil_DCacheFlushRang函数，需要给出内存地址和长度。

.. image:: images/15_media/image33.png
      
6. 打开MM2S通路和S2MM通路。

.. image:: images/15_media/image34.png
      
7. 中断设置方法与前面例程一样

.. image:: images/15_media/image35.png
      
8. 在中断服务程序中，首先清除中断，由于DDR3中的数据已经更新，但Cache中的数据并没有更新，CPU如果想从DDR3中读取数据，需要调用Xil_DCacheInvalidateRang函数，将Cache数据作废，这样CPU就能从DDR3中读取正确的数据。同样也要给出内存地址和长度。

.. image:: images/15_media/image36.png
      
9. 之后CPU从DDR3中读取数据进行对比，检验数据的正确性。

.. image:: images/15_media/image37.png
      
程序验证
--------

1. 选择Debug As，采用Debug模式，点击Debug

.. image:: images/15_media/image38.png
      
2. 打开ILA，设置触发条件axi_dma_0_s2mm_introut上升沿，点击运行

.. image:: images/15_media/image39.png
      
3. 回到Vitis的Debug界面，不用设置断点，点击Resume

.. image:: images/15_media/image40.png
      
4. 此时可以看到ILA已经触发，可以观察采集到的数据。

.. image:: images/15_media/image41.png
      
5. 在串口调试工具中可以看到打印信息，中断了两次，并且测试成功

.. image:: images/15_media/image42.png
      
6. 也可以在Vitis调试中，观察memory信息，设置断点如下图，在中断服务函数中设置断点

.. image:: images/15_media/image43.png
      
7. 重新Run
   Configurations，再点击Resume按键运行至断点处，在Memory窗口添加TxBufferPtr和RxBufferPtr，即可观察对比数据

.. image:: images/15_media/image44.png
      
本章小结
--------

本章知识点较多，运用了DMA进行内存的访问，并使用DMA中断，结合ILA逻辑分析仪观察数据，CPU读写内存时Cache的处理，大家可以多做些练习，灵活运用DMA。

在前面讲过AXI总线通过HP口访问PS端的DDR，是一种PS与PL数据交互的方式，而本章的DMA是另外一种PS与PL数据交互方式，本质上这两种方法是一样的，都是访问PS端DDR，不同的是一个PL端代码实现，对于用户来说更灵活可控，缺点是要写代码，对于不熟悉FPGA的人员来说比较困难；DMA的方式控制权主要在PS端，由PS配置DMA的读写，优点是比较直观，但需要比较好的软件功底。
