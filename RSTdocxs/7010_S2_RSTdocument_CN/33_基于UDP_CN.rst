基于UDP/TCP的远程更新QSPI Flash
=================================

**实验Vivado工程为“remote_update”。**

到目前为止，所有的程序都是通过JTAG下载，QSPI Flash，均是现场下载启动方式。在实际工作中，会遇到产品升级问题，也许产品生产时并没有预留JTAG口，而是预先将程序烧到FLASH里，那么升级过程就比较痛苦。本章介绍一种通过网络远程更新FLASH程序的方法，包含UDP和TCP两种方法。

硬件环境搭建
------------

基于“ps_hello”工程，另存一份。

Vitis程序开发
-------------

UDP传输方式
~~~~~~~~~~~

1. LWIP部分主要处理BIN文件的接收，程序为lwip_app.c

.. image:: images/33_media/image1.png
      
2. 在创建工程后，需要使能lwip库，并进行设置，使能DHCP功能，将memory空间尽可能设置大一些，增大缓存空间，提高效率。

.. image:: images/33_media/image2.png
         
3. udp_receive函数为设置的接收回调函数，主要功能是接收数据，并将接收到的数据缓存到FlashRxBuffer空间，留待更新Flash使用，在发送数据后，再发送“update”命令，开始更新flash，在函数中判断此命令。

4. 在while循环语句中，判断StartUpdate变量值，更新Flash。

.. image:: images/33_media/image3.png
      
TCP传输方式
~~~~~~~~~~~

1. 新建一个TCP的BSP

.. image:: images/33_media/image4.png
      
2. 根据新建的BSP，新建TCP工程，TCP的LWIP部分同样也是lwip_app.c文件，控制部分参考lwip echo server例程，建立一个TCP Server

.. image:: images/33_media/image5.png
      
.. image:: images/33_media/image6.png
      
3. LWIP库设置如下，使能DHCP，增大memory空间，增大tcp窗口

.. image:: images/33_media/image7.png
         
4. 与UDP类似，在recv_callback接收回调函数中，缓存接收到的BIN文件，启动更新命令同样是update，其他部分也与UDP类似。

QSPI Flash读写控制
~~~~~~~~~~~~~~~~~~

UDP和TCP两种方式使用的是同样的QSPI读写文件qspi.c和qspi.h

.. image:: images/33_media/image8.png
      
1. qspi.c文件是根据xqspips_flash_polled_example做的修改

.. image:: images/33_media/image9.png
      
2. 主要有以下一些函数，写使能及关闭，flash擦除，flash写，flash读，读Flash ID等。

.. image:: images/33_media/image10.png
      
3. 主要的函数为update_qspi，其中TotalLen为要更新的总字节数，FlashDataToSend为存放更新数据的缓存区域，流程也比较简单，首先是擦除，在这里没选择擦除整个Flash，而是根据TotalLen大小进行Sector擦除，因此擦除的空间会比TotalLen稍微大一点；然后是写Flash，利用FlashWrite函数进行写入；最后是校验，从Flash里读出数据，并与写入的数据进行对比。

.. image:: images/33_media/image11.png
      
板上验证
--------

我们以OV5640摄像头采集显示一的BOOT.bin文件做举例，当然也可以用其他例程。我们是设定网络环境理想状态下做的实验，在做此实验时，不要打开其他有关以太网传输的上位机软件，由于端口号一样，可能会造成冲突。

1. 首先连接开发板如下，将网线连接到ETH1网口，连接上双目摄像头

.. image:: images/33_media/image12.jpeg
      
AX7015硬件连接图

.. image:: images/33_media/image13.jpeg
      
AX7021硬件连接图（J16扩展口）

2. 如果有DHCP服务器，会自动分配IP给开发板；如果没有DHCP服务器，默认开发板IP地址为192.168.1.11，需要将PC的IP地址设为同一网段，如下图所示。同时要确保网络里没有192.168.1.11的IP地址，否则会造成IP冲突，导致无法显示。可以在板子未上电前在CMD里输入ping
192.168.1.11查看是否能ping通，如果ping通，说明网络中有此IP地址，就无法验证。没有问题之后打开putty软件。

.. image:: images/33_media/image14.png
      
UDP方式
~~~~~~~

1. UDP方式下载程序

.. image:: images/33_media/image15.png
      
2. 可以看putty里的信息

.. image:: images/33_media/image16.png
      
3. 打开工程目录下的板卡网络升级软件

.. image:: images/33_media/image17.png
      
4. 填入板卡的IP地址和端口号，选择UDP发送方式，选择BOOT.bin文件，点击发送

.. image:: images/33_media/image18.png
      
5. 发送完毕后，会显示发送的字节数

.. image:: images/33_media/image19.png
      
6. 在putty窗口可以看到板卡接收到的字节数，以及擦除，烧写，校验过程。

.. image:: images/33_media/image20.png
      
7. 断电通拨码开关选择QSPI启动方式，打开电源启动，即可看到程序运行起来。

TCP方式
~~~~~~~

1. TCP的Run Configurations配置界面如下，下载程序

.. image:: images/33_media/image21.png
      
2. 可以看到putty信息

.. image:: images/33_media/image22.png
      
3. 打开工程目录下的板卡网络升级软件

.. image:: images/33_media/image17.png
      
4. 填入IP地址和端口号，选择TCP发送方式，选择BOOT.bin文件，点击发送

.. image:: images/33_media/image23.png
      
5. 与UDP一样，也能看到发送的字节数

.. image:: images/33_media/image24.png
      
6. 在putty窗口可以看到板卡接收到的字节数，以及擦除，烧写，校验过程。

.. image:: images/33_media/image25.png
      
7. 断电通过拨码开关选择QSPI启动方式，打开电源启动，即可看到程序运行起来。

本章小结
--------

虽然在功能上实现了要求，但是并不完美，程序并未实现网络数据校验，握手，数据重传等功能，一旦网络不太好，或中途停止，就需要重新来一遍。但用户可在此基础上，编写代码，使其更具备实用性。
