PS端UART读写控制
==================

**实验Vivado工程为“ps_uart”。**

在前面的实验中，大家或多或少会发现有打印信息的情况，主要是调用”xil_printf”或”printf”，但是通过什么打印信息呢？我们还记得打印信息之前设置了串口，是的，确实是串口，但这些函数是如何调用串口呢？其实我们可以在”xil_printf”函数定义中看到，注意outbyte函数就是调用UART打印的。

.. image:: images/08_media/image1.png
      
再进入outbye的函数，即可看到调用了PS端UART的函数，得以在串口中显示。

.. image:: images/08_media/image2.png
      
除了打印信息之外，如果我们想用UART进行数据传输呢？本章便来介绍PS端UART的读写控制，实验中，每隔1S向外发送一串字符，如果收到数据，产生中断，并将收到的数据再发送出去。

Vivado工程基于“ps_hello”。

UART模块介绍
------------

以下是UART模块的结构图，TxFIFO和RxFIFO都为64字节。

.. image:: images/08_media/image3.png
      
下图为UART的四种模式

.. image:: images/08_media/image4.png
      
可以用remote loopback mode测试物理电路是否正常，使用API函数XUartPs_SetOperMode

.. image:: images/08_media/image5.png
      
软件工程师工作内容
------------------

以下为软件工程师负责内容。

Vitis程序开发
-------------

1. 本实验流程如下：

**主程序流程：**

UART初始化 —— 设置UART模式 —— 设置数据格式 —— 设置中断 —— 发送UART数据检查是否收到数据 —— 如果收到,发送收到的数据,如果没有,等待1秒钟,继续发数据

**中断程序流程：**

中断初始化 —— 设置接收FIFO trigger中断寄存器,设置为1,即收到一个数据就中断 —— 打开接收trigger中断REMPTY及接收FIFO空中断RTRIG

**中断服务程序：**

判断状态寄存器是trigger还是empty —— 清除相应中断 —— trigger状态读取RxFIFO数据,empty状态将接收标志ReceivedFlag置1

2. 首先来看寄存器，主要分为配置寄存器，用于配置UART的模式，波特率；中断寄存器配置；发送以及接收寄存器的配置。

.. image:: images/08_media/image6.png
      
3. 设置trigger level寄存器，6位，1~63

.. image:: images/08_media/image7.png
      
4. 发送部分比较简单，只要向TxFIFO写数据即可，而接收部分需要用到中断，在这里主要用到Intrpt_en_reg和Intrpt_dis_reg，一般这两个中断寄存器都是成对使用的。使能相应的中断，关闭其余的中断。

.. image:: images/08_media/image8.png
      
需要设置接收的RTRIG中断，也就是trigger中断，在此之前设置好trigger的值，也就是RxFIFO里的数据个数达到了trigger值，即中断，同时打开REMPTY空中断，判断是否为空。

.. image:: images/08_media/image9.png
      
5. 在中断服务程序中读取status register的值，判断接收是否有trigger或为空

.. image:: images/08_media/image10.png
      
.. image:: images/08_media/image11.png
      
6. 在main函数中进行模式的设置，可以直接调用函数，设置为正常模式，数据格式设置为波特率115200，数据8bit，无校验位，1bit停止位。UartFormat定义在uart_parameter.h中。

.. image:: images/08_media/image12.png
      
.. image:: images/08_media/image13.png
      
7. 中断控制器程序初始化可参考按键中断方式，用法类似。

8. 在main函数中将trigger level设置为1，打开trigger和empty中断。

.. image:: images/08_media/image14.png
      
9. 数据的发送和接收函数参考了UARTPS的XUartPs_Send和XUartPs_Rev函数，但它们会打开某些中断，不符合预期，因此做了修改。

.. image:: images/08_media/image15.png
      
在接收缓存中设置了最大2000字节的缓冲，可以根据需要修改。

|image1|\ |image2|

10. 在中断服务程序中，将ReceivedBufferPtr指针地址和ReceivedByteNum加上接收到的个数，如果FIFO空了，将ReceivedFlag置为1。同时向中断状态寄存器写数据，清除中断。

.. image:: images/08_media/image18.png
      
.. image:: images/08_media/image19.png
      
UG585 UART部分清除中断

11. 在main函数中，将ReceivedFlag和ReceivedByteNum清零，ReceivedBufferPtr指针复位。

.. image:: images/08_media/image20.png
      
12. Uart发送函数中，判断TxFIFO是否满，否则继续发送，直到计数达到NumBytes

.. image:: images/08_media/image21.png
      
13. Uart接收函数中，判断接收RxFIFO是否为空，否则继续读数据，NumBytes为需要读取的数据个数，但如果接收的FIFO空了，计数没有达到这个值，也会结束此函数。

.. image:: images/08_media/image22.png
      
14. 除了自己写程序外，还可以从platform.spr的BSP中导入模块的例子，参考Xilinx提供的程序，方便学习。

.. image:: images/08_media/image23.png
      
板上验证
--------

1. 接下来下载程序

.. image:: images/08_media/image24.png
      
2. 打开工程目录下的串口调试工具

.. image:: images/08_media/image25.png
      
3. 设置好参数如下，打开串口，即可看到打印信息。

.. image:: images/08_media/image26.png
      
4. 在发送区填入数据，点击手动发送，即可看到接收区的数据。

.. image:: images/08_media/image27.png
      
总结
----

本章学习了UART的发送与接收，以及中断的使用，希望大家能养成良好的习惯，多看文档，理解原理，能对系统的认识有很大提高。

.. |image1| image:: images/08_media/image16.png
.. |image2| image:: images/08_media/image17.png
      