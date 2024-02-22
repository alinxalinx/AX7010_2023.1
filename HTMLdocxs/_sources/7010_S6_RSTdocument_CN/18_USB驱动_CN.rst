USB驱动
================

usb是通用串行总线的总称。和windows一样，Linux也支持几乎所有的usb设备如鼠标、键盘、打印机等。这章来学习一下Linux中usb相关的内容。

usb识别过程
----------------

usb设备接入主机后，匹配过程如下：

1) 硬件检测

usb接口有四条线分别为5V、GND、D-、D+。主机端usb接口中的D-或D+有下拉电阻，空载时为低电平。设备端的usb接口内部D-或D+有上拉电阻，usb设备接入主机后，会把主机usb接口的D-或D+拉高，从而主机从硬件的角度检测到usb设备的接入。

2) 握手匹配

主机检测到usb设备接入后，就会和设备进行交互，主机端主动发起获取设备信息的描述符，设备则需要按照固定格式返回描述符。如果实在windows桌面系统下，此时我们就能看到xxx设备接入的弹窗了。

3) 分配地址

一个主机上可以接入多个usb设备，为了区分这些设备，在握手成功后，主机会给设备分配设备地址，主机发出的命令中都会包办地址信息。在握手之前，主机会用编号0来和设备交互。

usb的传输
--------------

usb的传输时主从结构，主就是主机，从就是设备。所有的传输都是由主机发起的，设备没有主动通知主机的能力。我们常说的输入输出，都是在主机的角度去描述的，比如输入设备键盘、鼠标，输出设备显示器等等。

usb的传输模式
~~~~~~~~~~~~~~~~~~~~

在主从结构的基础上，usb可以分为四种传输模式：

1) 控制传输

控制传输是一种特殊的传输方式，相对复杂一些。usb设备连接主机时，主机使用控制传输方式发送控制命令对设备进行配置。同时，需要通过控制传输获取usb设备的描述符对设备进行识别，在设备的枚举过程中都是使用控制传输进行数据交换。可靠，且时效性可保证。

2) 批量传输

批量传输一般用于数据量大但对时间要求又不高的场合，如u盘、打印机等。可靠，不保证时效性。

3) 中断传输

中断传输一般用于数据量小，不连续且实时要求搞得场合，如鼠标、键盘等输入设备。

4) 等时传输

等时传输一般用于数据量大、连续且实时要求高的场合，但可靠性难以保证，一般用于摄像头、话筒等设备。

端点
~~~~~~~~~~~

端点是usb的传输对象。端点是usb协议栈层次中抽象出来的概念，可以说是为了软件工作者而存在的概念。usb协议中从主机host开始
一个host可以连接一个或多个设备device，这个层面是物理上的usb线连接。一个device可以有一个或者多个接口interface，这层开始就是逻辑概念了，一个二合一的usb设备比如耳麦，就有话筒和耳机两接口。一个interface可以有一个或多个端点endpoint，这也是逻辑概念，比如u盘需要有输入端点和输出端点。

除了功能性的端点，每个usb设备都必须要有端点0，端点0一般用于设备的初始化和配置，支持控制传输，总是在设备接入主机时就进行配置。

管道
~~~~~~~~~~~

管道pipe是设备上的端点与主机上的软件之间的关联。管道表示通过内存缓冲区和设备上的端点在主机上的软件之间移动数据的能力。
有两种互斥的管道通信模式：

流：通过管道传输的数据没有USB定义的结构。

消息：通过管道移动的数据具有一些USB定义的结构。

usb总线驱动
----------------

总线驱动已经不陌生了，前面的palform驱动和i2c驱动都是这种思想。同样usb也是分为总线和设备两块驱动，usb驱动框架层次如下：

usb总线驱动和硬件对接，起到一个承接作用。前面说的usb的初始化过程，就需要总线驱动来完成。总线驱动需要做的事有这些：

1) 识别usb设备

2) 查找并安装相应的设备驱动

3) 为设备驱动提供都谐函数

总线驱动一般会由芯片厂家提供，少做了解即可。打开开发板，接上鼠标后拔出，可以在控制台中看到如下信息：

.. image:: images/18_media/image1.png

usb设备驱动
----------------

usb设备驱动中，同样是分成了设备和驱动两个部分。与i2c等有区别的地方是，usb只需要的去实现驱动部分，设备部分由总线驱动获取。

当接上一个 USB
设备时，就会产生中断hub_irq(),在中断里会分配一个编号地址choose_address(udev)。总线把这个地址告诉设备hub_set_address()。接着发出命令获取设备描述符usb_get_device_descriptor()。获取到设备信息后，会注册一个设备device_add()。这个device会被放到usb总线usb_bus_type的设备链表中。usb驱动程序注册后会从usb总线的驱动链表中取出设备驱动结构usb_driver，把usb_interface和usb_driver的id_table比较，匹配成功就会调用usb_driver中的probe函数。

而我们要做的就是定义初始化并注册usb_driver，并实现probe函数。

先来看看usb_driver结构体，定义在文件include/linux/usb.h中如下：

.. code:: c

 struct usb_driver {
 const char *name;

 int (*probe) (struct usb_interface *intf,
 const struct usb_device_id *id);

 void (*disconnect) (struct usb_interface *intf);

 int (*unlocked_ioctl) (struct usb_interface *intf, unsigned int code,
 void *buf);

 int (*suspend) (struct usb_interface *intf, pm_message_t message);
 int (*resume) (struct usb_interface *intf);
 int (*reset_resume)(struct usb_interface *intf);

 int (*pre_reset)(struct usb_interface *intf);
 int (*post_reset)(struct usb_interface *intf);

 const struct usb_device_id *id_table;

 struct usb_dynids dynids;
 struct usbdrv_wrap drvwrap;
 unsigned int no_dynamic_id:1;
 unsigned int supports_autosuspend:1;
 unsigned int disable_hub_initiated_lpm:1;
 unsigned int soft_unbind:1;
 };

name为设备名。

probe函数就是设备匹配成功后会执行的函数，必须实现。

disconnect函数在设备不可用时会执行，如设备拔出。

id_table用于匹配设备。usb_device_id定义在include/linux/mod_devicetable.h中，何以使用下面的宏去初始化：、

+-----------------------------------------------------------------------+
| USB_INTERFACE_INFO(cl,sc,pr)                                          |
+-----------------------------------------------------------------------+

cl之class类，sc是sub
class子类，pr是指协议。这些设备描述符定义在文件include\\linux\\usb\\Ch9.h中。总线驱动会根据这些描述符去匹配设备和驱动。

定义并初始化好usb_driver后，使用下面的宏向内核注册：

+-----------------------------------------------------------------------+
| usb_register(driver)                                                  |
+-----------------------------------------------------------------------+

相对的使用下面的函数注销：

+-----------------------------------------------------------------------+
| void usb_deregister(struct usb_driver \*);                            |
+-----------------------------------------------------------------------+

usb设备驱动示例：

.. code:: c

 static struct usb_device_id usb_id_table [] =
 {
 { USB_INTERFACE_INFO(XXX, XXX, XXX) },
 { }
 };


 static int usb_probe(struct usb_interface *intf, const struct usb_device_id *id)
 {
 return 0;
 }

 static void usb_disconnect(struct usb_interface *intf)
 {

 }

 static struct usb_driver usb_driver = {
 .name = "xxx",
 .probe = usbmouse_as_key_probe,
 .disconnect = usbmouse_as_key_disconnect,
 .id_table = usbmouse_as_key_id_table,
 };


 static int usb_init(void)
 {
 usb_register(&usb_driver);
 return 0;
 }

 static void usb_exit(void)
 {
 usb_deregister(&usb_driver);
 }

 module_init(usb_init);
 module_exit(usb_exit);

 MODULE_LICENSE("GPL");


probe函数和disconnect函数的输入参数struct usb_interface \*intf可以使用和函数interface_to_usbdev()来获取usb_device，如

+-----------------------------------------------------------------------+
| struct usb_device \*dev = interface_to_usbdev(intf);                  |
+-----------------------------------------------------------------------+

urb请求块
--------------

urb是设备驱动中用来描述usb设备通信的基本数据结构，是端点处理的对象，操作usb设备需要使用urb来进行。urb定义在文件include/linux/usb.h中，他的定义和注释如下：

.. code:: c

 struct urb {
 /* 私有的：只能由 USB 核心和主机控制器访问的字段 */
 struct kref kref; /*urb 引用计数 */
 void *hcpriv; /* 主机控制器私有数据 */
 atomic_t use_count; /* 并发传输计数 */
 u8 reject; /* 传输将失败*/
 int unlink; /* unlink 错误码 */
 /* 公共的： 可以被驱动使用的字段 */
 struct list_head urb_list; /* 链表头*/
 struct usb_anchor *anchor;
 struct usb_device *dev; /* 关联的 USB 设备 */
 struct usb_host_endpoint *ep;
 unsigned int pipe; /* 管道信息 */
 int status; /* URB 的当前状态 */
 unsigned int transfer_flags; /* URB_SHORT_NOT_OK | ...*/
 void *transfer_buffer; /* 发送数据到设备或从设备接收数据的缓冲区 */
 dma_addr_t transfer_dma; /*用来以 DMA 方式向设备传输数据的缓冲区 */
 int transfer_buffer_length;/*transfer_buffer 或 transfer_dma 指向缓冲区的大小 */

 int actual_length; /* URB 结束后，发送或接收数据的实际长度 */
 unsigned char *setup_packet; /* 指向控制 URB 的设置数据包的指针*/
 dma_addr_t setup_dma; /*控制 URB 的设置数据包的 DMA 缓冲区*/
 int start_frame; /*等时传输中用于设置或返回初始帧*/
 int number_of_packets; /*等时传输中等时缓冲区数量 */
 int interval; /* URB 被轮询到的时间间隔（对中断和等时 urb 有效） */
 int error_count; /* 等时传输错误数量 */
 void *context; /* completion 函数上下文 */
 usb_complete_t complete; /* 当 URB 被完全传输或发生错误时，被调用 */
 /*单个 URB 一次可定义多个等时传输时，描述各个等时传输 */
 struct usb_iso_packet_descriptor iso_frame_desc[0];
 }; 

urb是使用流程如下：

1) 创建urb

使用下面的函数创建一个urb：

+-----------------------------------------------------------------------+
| struct urb \*usb_alloc_urb(int iso_packets, int mem_flags);           |
+-----------------------------------------------------------------------+

相对的使用下面的函数释放urb：

+-----------------------------------------------------------------------+
| void usb_free_urb(struct urb \*urb);                                  |
+-----------------------------------------------------------------------+

2) 填充urb

对于中断urb，使用下面的函数来初始化：

+-----------------------------------------------------------------------+
| void usb_fill_int_urb(struct urb \*urb, struct usb_device \*dev,      |
| unsigned int pipe, void \*transfer_buffer, int buffer_length,         |
| usb_complete_t complete, void \*context, int interval);               |
+-----------------------------------------------------------------------+

参数说明：
urb：要被初始化的urb的指针；
dev：该urb要被发送到的usb设备；
pipe：该urb要被发送到的usb设备的特定端点，使用usb_sndctrlpipe()或usb_rcvictrlpipe()函数来创建；
transfer_buffer：发送数据或接收数据的缓冲区的指针。它也不能是静态缓冲区，必须使用kmalloc()来分配；
buffer_length：transfer_buffer指针所指向缓冲区的大小；
complete：该urb完成时的回掉函数；
context：完成处理函数的上下文；
interval：该这个urb调度的间隔。
对于批量urb，使用下面的函数来初始化：

+-----------------------------------------------------------------------+
| void usb_fill_bulk_urb(struct urb \*urb, struct usb_device            |
| \*dev,unsigned int pipe, void \*transfer_buffer,int buffer_length,    |
| usb_complete_t complete,void \*context);                              |
+-----------------------------------------------------------------------+


这里的pipe需要使用usb_sndbulkpipe()或者usb_rcvbulkpipe()函数来创建。


其他参数与usb_fill_int_urb()相同。

对于控制 urb，使用下面的函数来初始化：

+-----------------------------------------------------------------------+
| void usb_fill_control_urb(struct urb \*urb, struct usb_device         |
| \*dev,unsigned int pipe, unsigned char \*setup_packet,void            |
| \*transfer_buffer, int buffer_length,usb_complete_t complete, void    |
| \*context);                                                           |
+-----------------------------------------------------------------------+

setup_packet：即将被发送到端点的设置数据包。
这里的pipe需要使用usb_sndctrlpipe()或usb_rcvictrlpipe()函数来创建。
其他参数与usb_fill_int_urb()相同。

3) 提交urb

完成填充后，使用下面的函数来提交urb：

+-----------------------------------------------------------------------+
| int usb_submit_urb(struct urb \*urb, int mem_flags);                  |
+-----------------------------------------------------------------------+

mem_flags有以下定义：
GFP_ATOMIC：在中断服务函数、底半部、tasklet、定时器处理函数以及urb完成回掉函数中，如果调用者持有自旋锁或者读写锁时以及当驱动将当前进程修改为非
TASK_RUNNING 时使用。
GFP_NOIO：在存储设备的块I/O和错误处理路径中使用；
GFP_KERNEL：其他情况都使用这个标志。
在urb提交后，如果urb成功发送给设备、数据发送发生错误或驱动使用usb_unlink_urb()或usb_kill_urb()主动取消urb时，urb会结束。urb结束时可以通过成员变量status来查看结束的原因。
实验
---------

本章写一个usb鼠标动点击动作捕捉实验，点击左键时在控制台输出1，右键在控制台输出0。

原理图
~~~~~~~~~~~~~

前面说过硬件是与usb总线驱动相关的，usb总线驱动由芯片厂家提供，板子上的usb连接和xilinx样板是一样的，所以usb总线驱动程序不需要修改。

设备树
~~~~~~~~~~~~~

设备树可以和前面任意章节的一致，保持usb节点即可。

驱动程序
~~~~~~~~~~~~~~~

使用 petalinux新建名为”ax-usb-drv”驱劢程序，并执行 petalinux-config -c rootfs 命令选上新增的驱动程序。

在ax-usb-drv.c文件中输入下面的代码：

.. code:: c

 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/usb/input.h>
 #include <linux/hid.h>
 
 /* 定义一个输入事件, 表示鼠标的点击事件 */
 static struct input_dev *mouse_dev;
 /* 定义缓冲区首地址 */
 static char             *usb_buf;
 /* dma缓冲区 */
 static dma_addr_t       usb_buf_dma;
 /* 缓冲区长度 */
 static int              usb_buf_len;
 /* 定义一个urb */
 static struct urb       *mouse_urb;
 
 static void ax_usb_irq(struct urb *urb)
 {
     static unsigned char pre_sts;
     int i;
 
     /* 左键发生了变化 */
     if ((pre_sts & 0x01) != (usb_buf[0] & 0x01))
     {
         printk("lf click\n");
         input_event(mouse_dev, EV_KEY, KEY_L, (usb_buf[0] & 0x01) ? 1 : 0);
         input_sync(mouse_dev);
     }
 
     /* 右键发生了变化 */
     if ((pre_sts & 0x02) != (usb_buf[0] & 0x02))
     {
         printk("rt click\n");
         input_event(mouse_dev, EV_KEY, KEY_S, (usb_buf[0] & 0x02) ? 1 : 0);
         input_sync(mouse_dev);
     }
     
     /* 记录当前状态 */
     pre_sts = usb_buf[0];
 
     /* 重新提交urb */
     usb_submit_urb(mouse_urb, GFP_KERNEL);
 }
 
 static int ax_usb_probe(struct usb_interface *intf, const struct usb_device_id *id)
 {
     /* 获取usb_device */
     struct usb_device *dev = interface_to_usbdev(intf);
     struct usb_host_interface *interface;
     struct usb_endpoint_descriptor *endpoint;
     int pipe;
         
     /* 获取端点 */
     interface = intf->cur_altsetting;
     endpoint = &interface->endpoint[0].desc;
 
     /* 分配input_dev */
     mouse_dev = input_allocate_device();
     /* 设置input_dev */
     set_bit(EV_KEY, mouse_dev->evbit);
     set_bit(EV_REP, mouse_dev->evbit);
     set_bit(KEY_L, mouse_dev->keybit);
     set_bit(KEY_S, mouse_dev->keybit);
     /* 注册input_dev */
     input_register_device(mouse_dev);
     
     /* 获取USB设备端点对应的管道 */
     pipe = usb_rcvintpipe(dev, endpoint->bEndpointAddress);
 
     /* 获取端点最大长度作为缓冲区长度 */
     usb_buf_len = endpoint->wMaxPacketSize;
 
     /* 分配缓冲区 */
     usb_buf = usb_alloc_coherent(dev, usb_buf_len, GFP_ATOMIC, &usb_buf_dma);
 
     /* 创建urb */
     mouse_urb = usb_alloc_urb(0, GFP_KERNEL);
     
     /* 分配urb" */
     usb_fill_int_urb(mouse_urb, dev, pipe, usb_buf, usb_buf_len, ax_usb_irq, NULL, endpoint->bInterval);
     mouse_urb->transfer_dma = usb_buf_dma;
     mouse_urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
 
     /* 提交urb */
     usb_submit_urb(mouse_urb, GFP_KERNEL);
     
     return 0;
 }
 
 static void ax_usb_disconnect(struct usb_interface *intf)
 {
     struct usb_device *dev = interface_to_usbdev(intf);
 
     /* 主动结束urb */
     usb_kill_urb(mouse_urb);
     /* 释放urb */
     usb_free_urb(mouse_urb);
     /* 释放缓冲区 */
     usb_free_coherent(dev, usb_buf_len, usb_buf, &usb_buf_dma);
     /* 注销输入事件 */
     input_unregister_device(mouse_dev);
     /* 释放输入事件 */
     input_free_device(mouse_dev);
 }
 
 /* 定义初始化id_table */
 static struct usb_device_id ax_usb_id_table [] = {
     /* 鼠标mouse接口描述符里类是HID类，子类boot，协议mouse */
     { 
         USB_INTERFACE_INFO(USB_INTERFACE_CLASS_HID, 
                            USB_INTERFACE_SUBCLASS_BOOT, 
                            USB_INTERFACE_PROTOCOL_MOUSE) 
     }, { }
 };
 
 /* 定义并初始化usb_driver */
 static struct usb_driver ax_usb_driver = {
     .name       = "ax_usb_test",
     .probe      = ax_usb_probe,
     .disconnect = ax_usb_disconnect,
     .id_table   = ax_usb_id_table,
 };
 
 /* 驱动入口函数 */
 static int ax_usb_init(void)
 {
     /* 注册usb_driver */
     return usb_register(&ax_usb_driver);
 }
 
 /* 驱动出口函数 */
 static void ax_usb_exit(void)
 {
     /* 注销usb_driver */
     usb_deregister(&ax_usb_driver);    
 }
 
 /* 标记加载、卸载函数 */ 
 module_init(ax_usb_init);
 module_exit(ax_usb_exit);
 
 /* 驱动描述信息 */  
 MODULE_AUTHOR("Alinx");  
 MODULE_ALIAS("pwm_led");  
 MODULE_DESCRIPTION("USB TEST driver");  
 MODULE_VERSION("v1.0");  
 MODULE_LICENSE("GPL");   

usb_driver的框架很简单，关键部分是probe函数和urb的回掉函数中的处理。

结合了input子系统，把usb鼠标模拟成按键。

56行，probe函数中从intf中获取接口，再从接口中获取端点。

70行获取管道。

73~79行分配缓冲区。

这些都是在位分配urb做准备。

79~87行创建urb，并用上面获取的参数来分配urb，完成后提交。

usb_fill_int_urb注册终端输入端点数据，当输入设备usb鼠标产生动作时，就会触发终端函数ax_usb_irq。

25~38行在终端函数中，通过input子系统判断输入类型，打印对应的信息。

运行测试
~~~~~~~~~~~~~~~

本次实验的程序加载了鼠标，和系统中原先的会用冲突，所以需要先把系统自的鼠标驱动去掉。方法如下：

1) 在终端中输入命令配置内核petalinux-config -c
   kernel，弹出配置界面如下：

.. image:: images/18_media/image2.png

.. image:: images/18_media/image3.png
   
2) 按回车进入配置界面中的Device Drivers子选项

.. image:: images/18_media/image4.png
   
3) 在进入HID support子选项

.. image:: images/18_media/image5.png
   
4) 按空格，进入USB HID support子选项

..

   .. image:: images/18_media/image6.png
            
5) 进入后，按空格，把USB HID transport layer选项调成空选状态。

.. image:: images/18_media/image7.png
   
之后，测试方法步骤如下：

+-----------------------------------------------------------------------+
| mount -t nfs -o nolock 192.168.1.107:/home/alinx/work /mnt            |
|                                                                       |
| cd /mnt                                                               |
|                                                                       |
| mkdir /tmp/qt                                                         |
|                                                                       |
| mount qt_lib.img /tmp/qt                                              |
|                                                                       |
| cd /tmp/qt                                                            |
|                                                                       |
| source ./qt_env_set.sh                                                |
|                                                                       |
| cd /mnt                                                               |
|                                                                       |
| insmod ./ax-usb-drv.ko                                                |
+-----------------------------------------------------------------------+

IP 和路径根据实际情况调整。

之后接上usb鼠标。点击左键右键查看控制台输出情况。如下：

.. image:: images/18_media/image8.png

拔出鼠标后，会打印disconnect信息。

.. image:: images/18_media/image9.png
