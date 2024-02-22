ADC采集并显示波形
======================

在前面的实验中我们学习了使用PYNQ操作dma，但是不太直观，本实验通过采集ADC数据并显示出波形，用更直观的实例来说明dma的使用。

ADC硬件
-------

实验中使用模块为AN108，一路32M采样率ADC、一路125M采样率DAC，实验中使用了其中的ADC通道。在SDK例程中我们已经使用过AN108模块，这里不做说明了。

.. image:: images/06_media/image1.png
      
Vivado工程
----------

Vivado工程来自course_s2的ad9280_dma_hdmi，这里删除了HDMI显示部分，删除了DMA的中断连接，这里不再讲解这个Vivado工程。

.. image:: images/06_media/image2.png
      
Notebook文件
------------

1. 通过samba访问 `\\\\192.168.x.xxx\\xilinx\\jupyter_notebooks <file:///\\192.168.x.xxx\xilinx\jupyter_notebooks>`__\ ，新建一个文件夹ad9280_dma用于存储bit文件、hwh文件和jupyter_notebook文件

.. image:: images/06_media/image3.png
      
2. 将design_1_wrapper.bit文件复制到\ `\\\\192.168.x.xxx\\xilinx\\jupyter_notebooks\\ad9280_dma <file:///\\192.168.x.xxx\xilinx\jupyter_notebooks\ad9280_dma>`__\ ，并重命名为ad9280_dma.bit

.. image:: images/06_media/image4.png
      
3. 将design_1.hwh复制到\ `\\\\192.168.x.xxx\\xilinx\\jupyter_notebooks\\ad9280_dma <file:///\\192.168.x.xxx\xilinx\jupyter_notebooks\ad9280_dma>`__\ 并重命名为ad9280_dma.hwh

.. image:: images/06_media/image5.png
      
4. 如果不想自己再编辑notebook，把ad9280_dma.ipynb文件复制到\ `\\\\192.168.x.xxx\\xilinx\\jupyter_notebooks\\ad9280_dma <file:///\\192.168.x.xxx\xilinx\jupyter_notebooks\ad9280_dma>`__

.. image:: images/06_media/image6.png
      
5. 浏览器登录打开notebook

.. image:: images/06_media/image7.png
      
6. 等Kernel start完成才能运行

.. image:: images/06_media/image8.png
      
7. 100Khz正弦波，运行结果

.. image:: images/06_media/image9.png
      