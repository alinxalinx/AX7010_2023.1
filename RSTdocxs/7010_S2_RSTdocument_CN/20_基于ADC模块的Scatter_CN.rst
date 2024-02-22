基于ADC模块的Scatter/Gather DMA使用(AN108)
============================================

**实验Vivado工程为“ad9280_sg_dma_hdmi”。**

前面几个DMA实验中用的都是simple DMA模式，也就是直接存储器存取方式，本章学习一种效率更高，但较复杂的SG模式，也就是Scatter/Gather（分散/聚集）。直接存取方式一次访问一个内存空间，在每次传输结束后中断通知CPU，增加了CPU的负担，效率较低，而SG模式允许一次单一的DMA传输访问多个内存空间，所有任务都结束后，才发出中断，提高了效率。

.. image:: images/20_media/image1.png

SG DMA原理介绍
--------------

1. 基于AN108的工程，需要对两个DMA进行配置，使能Enable Scatter Gather Engine，这时会出现M_AXI_SG接口，用于读写链表（后面会有介绍）。

.. image:: images/20_media/image2.png
      
2. 先来了解链表，需要在内存中开辟一片空间保存链表，链表内容如下所示，以Descriptor为基本单元，每个Descriptor有13个寄存器，但每个Descriptor地址需要以64字节对齐，也就是0x00, 0x40, 0x80;
NXTDESC表示下一个描述符指针地址，BUFFER_ADDRESS为数据缓存的地址，在本实验中代表接收的ADC数据缓存空间。Control储存Frame的开始、结束、每个Pachage的长度信息（以字节为单位），Status存储错误、结束等信息，APP0~APP4为用户使用空间（仅在打开Status
Control Stream时有效，否则DMA不会抓取此信息）。

.. image:: images/20_media/image3.png
      
下图为MM2S的链表结构，在SG DMA启动后，DMA会通过M_AXI_SG抓取第一个Descriptor，读取BufferAddr，Control等信息，等传输完Control设置的长度后，开始抓取下一个Descriptor信息。依次类推，直到最后一个Descriptor。

.. image:: images/20_media/image4.png
      
3. 有点要注意，MM2S_CONTRL的TXSOF（Frame开始）和TXEOF（Frame结束）需要软件设置。

.. image:: images/20_media/image5.png
      
而S2MM_CONTRL的RXSOF和RXEOF不需要软件设置，在接收数据后由DMA控制。

.. image:: images/20_media/image6.png
      
4. 再来看SG DMA的寄存器，MM2S_CURDESC表示当前的Descriptor地址，MM2S_TAILDESC表示尾部Descriptor地址，也就是最后一个Descriptor。同样，S2MM_CURDESC和S2MM_TAILDESC是指S2MM通路寄存器。这些寄存器通过AXI4_LITE总线配置。

.. image:: images/20_media/image7.png
      
5. SG DMA使用流程

MM2S端：

a) 在内存中开辟缓存空间，制作链表

b) 通过AXI4_LITE总线将第一个Descriptor的地址写入MM2S_CURDESC寄存器

c) 写寄存器MM2S_DMACR.RS=1启动DMA，如果需要，打开MM2S_DMACR.IOC_IrqEn中断，结束后会发出中断

d) 将最后一个Descriptor地址写入MM2S_TAILDESC寄存器，触发DMA开始通过M_AXI_SG总线抓取链表的Descritptor，等package传输结束，读取下一个Descriptor信息，直到结束。

S2MM端：

a) 在内存中开辟缓存空间，制作链表

b) 通过AXI4_LITE总线将第一个Descriptor的地址写入S2MM_CURDESC寄存器

c) 写寄存器S2MM_DMACR.RS=1启动DMA，如果需要，打开S2MM_DMACR.IOC_IrqEn中断，结束后会发出中断

d) 将最后一个Descriptor地址写入S2MM_TAILDESC寄存器，触发DMA开始通过M_AXI_SG总线抓取链表的Descritptor，等package传输结束，读取下一个Descriptor信息，直到结束。

讲到这里，也许大家会疑惑链表该如何制作，下面通过Vitis程序介绍。

Vitis程序开发
-------------

1. 基于AN108的实验，定义了两个链表数组，每个链表设置为最大16个Descriptor，BD_ALIGNMENT宏定义为0x40。

.. image:: images/20_media/image8.png
      
2. 添加了两个文件dma_bd.c和dma_bd.h

.. image:: images/20_media/image9.png
      
CreateBdChain为创建链表函数，BdCount为要创建的Descriptor个数，TotalByteLen为DMA传输的总字节数

.. image:: images/20_media/image10.png
      
只需要配置NEXDESC，BUFFER_ADDRESS，CONTROL三个部分，如果是TXPATH需要设置TXSOF和TXEOF，本实验是RXPATH，不需要设置。

.. image:: images/20_media/image11.png
      
为了匹配Cyclic DMA Mode，将最后一个Descriptor指向第一个Descriptor的地址

.. image:: images/20_media/image12.png
      
3. 为了方便理解，在本实验中将ADC的缓存区域划分为了4个连续的空间，下面通过Debug查看memory信息，首先Run Debug进入Debug界面，在CreateBdChain中设置断点，

.. image:: images/20_media/image13.png
      
4. 点击Resume按钮，运行至断点处

.. image:: images/20_media/image14.png
      
.. image:: images/20_media/image15.png
      
5. 找到链表的地址

.. image:: images/20_media/image16.png
      
6. 在Memory窗口点击添加按钮，填入链表地址

.. image:: images/20_media/image17.png
      
7. 取消当前断点，再添加断点到函数结尾，再次点击Resume按钮运行到断点处

.. image:: images/20_media/image18.png
      
8. 可以看到第一个Descriptor的NEXDESC指向下一个Descriptor地址也就是0x00277700，第一个BUFFER_ADDRESS为0x002767C0，CONTROL为0x00000280，在本实验中设置缓存空间是连续的，0x002767C0+0x00000280=0x00276A40，也就是下一个的BUFFER_ADDRESS，用户也可以设置为不连续的空间。

.. image:: images/20_media/image19.png
      
9. 最后一个Descriptor的NEXDESC指向第一个Descriptor的地址

.. image:: images/20_media/image20.png
      
10. 以上是Buffer Descriptor的设置，下是开始配置寄存器启动SG DMA，采用Bd_Start函数，只需要写CURDESC，DMACR，TAILDESC寄存器即可。

.. image:: images/20_media/image21.png
      
11. 可以在逻辑分析仪中看到M_AXI_SG总线波形，有四次读操作

.. image:: images/20_media/image22.png
      
放大之后可看到读的是链表的内容。

.. image:: images/20_media/image23.png
      
12. 在一个package传输结束后，DMA会通过M_AXI_SG向链表STATUS写入信息，可以在看到第一个Descriptor的值为0x88000280，RXSOF为1，也就是包的起始

.. image:: images/20_media/image24.png
      
13. 每次处理完数据后，需要清除状态，也就是STATUS内容，程序中用Bd_StatusClr函数

.. image:: images/20_media/image25.png
            
本章小节
--------

Scatter/Gather DMA模式需要理解的内容比较多，首先是链表的生成，需要分清链表和DMA寄存器的区别，用户可在此实验基础上向不同地址空间写入数据，灵活运用SG DMA模式。

在例程中同样给大家提供了TXPATH的SG DMA使用，基于AN108的DAC实验，在学完本实验后理解起来会更简单，在此不再详述。

同样也准备了AD7606对应的SG工程，供大家参考。
