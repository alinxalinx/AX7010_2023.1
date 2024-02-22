非阻塞IO
===============

这章来讲另一种IO模型非阻塞IO(NIO)，也就是同步非阻塞IO。上一章说过，IO操作的两个阶段先查询再读写，而非阻塞IO在查询阶段的处理和阻塞IO不同。应用程序需要进行IO操作前，先发起查询，驱动程序根据数据情况返回查询结果，如果返回查询结果NG，应用程序就不执行读写操作了。如果应用程序非要读写的话，就继续去查询，直到驱动程序返回数据准备完成，才会做下一步的读写操作。

Linux中的NIO
-----------------

非阻塞IO的处理方式是轮询。Linux中提供了应用程序的轮询机制和相应的驱动程序系统调用。

应用程序中的轮询方法
~~~~~~~~~~~~~~~~~~~~~~~~~~~

应用程序中提供了三种轮询的方法：select、poll、epoll。实际上他们也是多路复用IO的解决方法，这里就不展开说了。

1) select

select有良好的跨平台支持性，但是他的单个进程能够监视的文件描述符的数量存在最大限制(Linux中一般为1024)。

函数原型：

+-----------------------------------------------------------------------+
| int select(int maxfdp, fd_set \*readfds, fd_set \*writefds, fd_set    |
| \*errorfds, struct timeval \*timeout);                                |
+-----------------------------------------------------------------------+

参数说明：

**maxfdp**\ ：是集合中所有文件描述符的范围，即等于所有文件描述符的最大值加1。

**readfds**\ ：struct fd_set结构体可以理解为是文件描述符(file
descriptor)的集合，也就是文件句柄，他的每一位就代表一个描述符，readfds用于监视指定描述符集的读变化，只要其中有一位可读，select就会返回一个大于0的值。可以已使用这些宏来操作fd_set变量：

+-----------------------------------------------------------------------+
| /\* 把fdset所有位置0, 清楚fdset和所有文件句柄的关系 \*/               |
|                                                                       |
| FD_ZERO(fd_set \*fdset)                                               |
|                                                                       |
| /\* 把fdset某个位置1, 把fdset和文件句柄fd关联 \*/                     |
|                                                                       |
| FD_SET(int fd, fd_set \*fdset)                                        |
|                                                                       |
| /\* 把fdset某个位置0, 取消fdset和文件句柄的关联 \*/                   |
|                                                                       |
| | FD_CLR(int fd, fd_set \*fdset)                                      |
| | /\* 判断某个文件句柄是否为1, 即是否可操作 \*/                       |
|                                                                       |
| FD_ISSET(int fd, fdset \*fdset)                                       |
+-----------------------------------------------------------------------+

**writefds**\ ：用于见识文件是否可写。

**errorfds**\ ：用于监视文件异常。

**timeout**\ ：struct
timeval用来代表时间值，有两个成员，一个是秒数，另一个是毫秒数。定义如下：

.. code:: c

 struct timeval{
 long tv_sec; /*秒 */
 long tv_usec; /*微秒 */
 }


这个参数的值有三种情况

如果传入NULL，即不传入时间结构，就是一个阻塞函数，直到某个文件描述符发生变化才会返回。

如果把秒和微妙都设为0，就是一个非阻塞函数，会立刻返，文件无变化返回0，有变化返回正值。

如果值大于0，则意为超时时间，
select若在timeout时间内没有检测到文件描述符变化，则会直接返回0，有变化则返回正值。

使用示例：

.. code:: c

 void main(void)
 {
 /* ret 获取返回值, fd 获取文件句柄 */
 int ret, fd;
 /* 定义一个监视文件读变化的描述符合集 */
 fd_set readfds;
 /* 定义一个超时时间结构体 */
 struct timeval timeout;

 /* 获取文件句柄, O_NONBLOCK 表示非阻塞访问 */
 fd = open("dev_xxx", O_RDWR | O_NONBLOCK);

 /* 初始化描述符合集 */
 FD_ZERO(&readfds);
 /* 把文件句柄 fd 指向的文件添加到描述符 */
 FD_SET(fd, &readfds);

 /* 超时时间初始化为 1.5 秒 */
 timeout.tv_sec = 1;
 timeout.tv_usec = 500000;

 /* 调用 select, 注意第一个参数为 fd+1 */
 ret = select(fd + 1, &readfds, NULL, NULL, &timeout);

 switch (ret)
 {
 case 0:
 {
 /* 超时 */
 break;
 }
 case -1:
 {
 /* 出错 */
 break;
 }
 default:
 {
 /* 监视的文件可操作 */
 /* 判断可操作的文件是不是文件句柄 fd 指向的文件 */
 if(FD_ISSET(fd, &readfds))
 {
 /* 操作文件 */
 }
 break;
 }
 }
 } 
 
在23行调用select函数之前，做了很多准备工作，主要是select函数输入参数的初始化。

注意11行open函数输入参数中的O_NONBLOCK属性，如果需要非阻塞的访问文件，则需要添加这个属性。

41行，在ret返回大于0时，使用宏定义FD_ISSET判断可操作的句柄是不是我们需要的句柄，在只等待一个文件的情况下，可以不做这个判断。

2) poll

poll本质上和sellect没有区别，但是是他的最大连接数没有限制。

函数原型：

+-----------------------------------------------------------------------+
| int poll (struct pollfd \*fds, unsigned int nfds, int timeout);       |
+-----------------------------------------------------------------------+

参数说明：

**fds**\ ：struct pollfd结构体是文件句柄和事件的组合，定义如下：

.. code:: c

 struct pollfd {
 int fd;
 short events;
 short revents;
 };

**fd**\ 是文件句柄，events是对于这个文件需要监视的事件类型，revents是内核返回的事件类型。事件类型有：

+-----------------------------------------------------------------------+
| POLLIN //有数据可读                                                   |
|                                                                       |
| POLLPRI //有紧急数据可读                                              |
|                                                                       |
| POLLOUT //数据可写                                                    |
|                                                                       |
| POLLERR //指定文件描述符发生错误                                      |
|                                                                       |
| POLLHUP //指定文件描述符挂起                                          |
|                                                                       |
| POLLNVAL //无效请求                                                   |
|                                                                       |
| POLLRDNORM //有数据可读                                               |
+-----------------------------------------------------------------------+

**nfds**\ ：poll监视的文件句柄数量，也就是fds的数组长度。

**timeout**\ ：超时时间，单位为毫秒。

使用示例：

.. code:: c

 void main(void)
 {
 /* ret 获取返回值, fd 获取文件句柄 */
 int ret, fd;
 /* 定义 struct pollfd 结构体变量 */
 struct pollfd fds[1];

 /* 非阻塞访问文件 */
 fd = open(filename, O_RDWR | O_NONBLOCK);

 /* 初始化 struct pollfd 结构体变量 */
 fds[0].fd = fd;
 fds[0].events = POLLIN;

 /* 调用 poll */
 ret = poll(fds, sizeof(fds), 1500);
 if(ret == 0)
 {
 /* 超时 */
 }
 else if (ret < 0)
 {
 /* 错误 */
 }
 else
 {
 /* 操作数据 */
 }
 }

3) epoll

可以理解为event
poll，设计用于大并发时的IO查询，常用于网络编程，暂不介绍。

驱动程序中的poll函数
~~~~~~~~~~~~~~~~~~~~~~~~~~~

应用程序中调用select、poll、epoll时，系统调用就会执行驱动程序中file_operations的poll函数。也就是我们需要实现的函数。圆原型如下：

+-----------------------------------------------------------------------+
| unsigned int (\*poll) (struct file \*filp, struct poll_table_struct   |
| \*wait)                                                               |
+-----------------------------------------------------------------------+


参数说明：

**filp**\ ：应用程序传递过来的值，应用程序open之后获得的目标文件句柄。

**wait**\ ：应用程序传递过来的值，代表应用程序线程。我们需要在poll函数中调用
poll_wait将应用程序添线程wait添加到poll_table等待队列中，poll_wait函数原型如下：

+-----------------------------------------------------------------------+
| void poll_wait(struct file \* filp, wait_queue_head_t \*              |
| wait_address, poll_table \*p)                                         |
+-----------------------------------------------------------------------+

wait作为参数p传递给poll_wait函数。

**返回值**\ ：返回值和struct pollfd结构体中的事件类型相同。

实验
---------

这章的实验目标和上一章相同，使用ps_key1控制ps_led1，并使cpu占用率相较于中断那一章有所降低。

原理图
~~~~~~~~~~~~~

led部分和 **字符设备** 章节相同。

key部分和 **gpio输入** 章节相同。

设备树
~~~~~~~~~~~~~

和 **gpio输入** 章节相同。

驱动代码
~~~~~~~~~~~~~~~

使用 petalinux 新建名为”ax-nio-drv”的驱劢程序，并执行 petalinux-config -c rootfs 命令选上新增的驱动程序。

在 ax-nio-drv.c 文件中输入下面的代码：

.. code:: c

 #include <linux/module.h>  
 #include <linux/kernel.h>
 #include <linux/init.h>  
 #include <linux/types.h>  
 #include <linux/errno.h>
 #include <linux/cdev.h>
 #include <linux/of.h>
 #include <linux/of_address.h>
 #include <linux/of_gpio.h>
 #include <linux/device.h>
 #include <linux/delay.h>
 #include <linux/init.h>
 #include <linux/gpio.h>
 #include <linux/semaphore.h>
 #include <linux/timer.h>
 #include <linux/of_irq.h>
 #include <linux/irq.h>
 #include <linux/interrupt.h>
 #include <linux/wait.h>
 #include <linux/poll.h>
 #include <asm/uaccess.h>
 #include <asm/mach/map.h>
 #include <asm/io.h>
   
 /* 设备节点名称 */  
 #define DEVICE_NAME       "nio_led"
 /* 设备号个数 */  
 #define DEVID_COUNT       1
 /* 驱动个数 */  
 #define DRIVE_COUNT       1
 /* 主设备号 */
 #define MAJOR_U
 /* 次设备号 */
 #define MINOR_U           0
 
 /* 把驱动代码中会用到的数据打包进设备结构体 */
 struct alinx_char_dev {
 /** 字符设备框架 **/
     dev_t              devid;             //设备号
     struct cdev        cdev;              //字符设备
     struct class       *class;            //类
     struct device      *device;           //设备
     struct device_node *nd;               //设备树的设备节点
 /** gpio **/    
     int                alinx_key_gpio;    //gpio号
 /** 并发处理 **/
     atomic_t           key_sts;           //记录按键状态, 为1时被按下
 /** 中断 **/
     unsigned int       irq;               //中断号
 /** 定时器 **/
     struct timer_list  timer;             //定时器
 /** 等待队列 **/
     wait_queue_head_t  wait_q_h;          //等待队列头
 };
 /* 声明设备结构体 */
 static struct alinx_char_dev alinx_char = {
     .cdev = {
         .owner = THIS_MODULE,
     },
 };
 
 /** 回掉 **/
 /* 中断服务函数 */
 static irqreturn_t key_handler(int irq, void *dev)
 {
     /* 按键按下或抬起时会进入中断 */
     /* 开启50毫秒的定时器用作防抖动 */
     mod_timer(&alinx_char.timer, jiffies + msecs_to_jiffies(50));
     return IRQ_RETVAL(IRQ_HANDLED);
 }
 
 /* 定时器服务函数 */
 void timer_function(struct timer_list *timer)
 {
     /* value用于获取按键值 */
     unsigned char value;
     /* 获取按键值 */
     value = gpio_get_value(alinx_char.alinx_key_gpio);
     if(value == 0)
     {
         /* 按键按下, 状态置1 */
         atomic_set(&alinx_char.key_sts, 1);
 /** 等待队列 **/
         /* 唤醒进程 */
         wake_up_interruptible(&alinx_char.wait_q_h);
     }
     else
     {
         /* 按键抬起 */
     }
 }
 
 /** 系统调用实现 **/
 /* open函数实现, 对应到Linux系统调用函数的open函数 */  
 static int char_drv_open(struct inode *inode_p, struct file *file_p)  
 {  
     printk("gpio_test module open\n");  
     return 0;  
 }  
   
 /* read函数实现, 对应到Linux系统调用函数的write函数 */  
 static ssize_t char_drv_read(struct file *file_p, char __user *buf, size_t len, loff_t *loff_t_p)  
 {  
     unsigned int keysts = 0;
     int ret;
     
     /* 读取key的状态 */
     keysts = atomic_read(&alinx_char.key_sts);
     /* 判断文件打开方式 */
     if(file_p->f_flags & O_NONBLOCK)
     {
         /* 如果是非阻塞访问, 说明以满足读取条件 */
     }
     /* 判断当前按键状态 */
     else if(!keysts)
     {
         /* 按键未被按下(数据未准备好) */
         /* 以当前进程创建并初始化为队列项 */
         DECLARE_WAITQUEUE(queue_mem, current);
         /* 把当前进程的队列项添加到队列头 */
         add_wait_queue(&alinx_char.wait_q_h, &queue_mem);
         /* 设置当前进成为可被信号打断的状态 */
         __set_current_state(TASK_INTERRUPTIBLE);
         /* 切换进程, 是当前进程休眠 */
         schedule();
         
         /* 被唤醒, 修改当前进程状态为RUNNING */
         set_current_state(TASK_RUNNING);
         /* 把当前进程的队列项从队列头中删除 */
         remove_wait_queue(&alinx_char.wait_q_h, &queue_mem);
         
         /* 判断是否是被信号唤醒 */
         if(signal_pending(current))
         {
             /* 如果是直接返回错误 */
             return -ERESTARTSYS;
         }
         else
         {
             /* 被按键唤醒 */
         }
     }
     else
     {
         /* 按键被按下(数据准备好了) */
     }    
       
     /* 读取key的状态 */
     keysts = atomic_read(&alinx_char.key_sts);
     /* 返回按键状态值 */
     ret = copy_to_user(buf, &keysts, sizeof(keysts));
     /* 清除按键状态 */
     atomic_set(&alinx_char.key_sts, 0);
     return 0;  
 }  
 
 /* poll函数实现 */  
 unsigned int char_drv_poll(struct file *filp, struct poll_table_struct *wait)
 {
 	unsigned int ret = 0;
 	
     /* 将应用程序添添加到等待队列中 */
     poll_wait(filp, &alinx_char.wait_q_h, wait);
 	
     /* 判断key的状态 */
 	if(atomic_read(&alinx_char.key_sts))
 	{
         /* key准备好了, 返回数据可读 */
 		ret = POLLIN;
 	}
     else
     {
         
     }
 	
 	return ret;
 }
   
 /* release函数实现, 对应到Linux系统调用函数的close函数 */  
 static int char_drv_release(struct inode *inode_p, struct file *file_p)  
 {  
     printk("gpio_test module release\n");
     return 0;  
 }  
       
 /* file_operations结构体声明, 是上面open、write实现函数与系统调用函数对应的关键 */  
 static struct file_operations ax_char_fops = {  
     .owner   = THIS_MODULE,  
     .open    = char_drv_open,  
     .read    = char_drv_read,   
 	.poll    = char_drv_poll,  
     .release = char_drv_release,   
 };  
   
 /* 模块加载时会调用的函数 */  
 static int __init char_drv_init(void)  
 {
     /* 用于接受返回值 */
     u32 ret = 0;
     
 /** 并发处理 **/
     /* 初始化原子变量 */
     atomic_set(&alinx_char.key_sts, 0);
     
 /** gpio框架 **/   
     /* 获取设备节点 */
     alinx_char.nd = of_find_node_by_path("/alinxkey");
     if(alinx_char.nd == NULL)
     {
         printk("alinx_char node not find\r\n");
         return -EINVAL;
     }
     else
     {
         printk("alinx_char node find\r\n");
     }
     
     /* 获取节点中gpio标号 */
     alinx_char.alinx_key_gpio = of_get_named_gpio(alinx_char.nd, "alinxkey-gpios", 0);
     if(alinx_char.alinx_key_gpio < 0)
     {
         printk("can not get alinxkey-gpios");
         return -EINVAL;
     }
     printk("alinxkey-gpio num = %d\r\n", alinx_char.alinx_key_gpio);
     
     /* 申请gpio标号对应的引脚 */
     ret = gpio_request(alinx_char.alinx_key_gpio, "alinxkey");
     if(ret != 0)
     {
         printk("can not request gpio\r\n");
         return -EINVAL;
     }
     
     /* 把这个io设置为输入 */
     ret = gpio_direction_input(alinx_char.alinx_key_gpio);
     if(ret < 0)
     {
         printk("can not set gpio\r\n");
         return -EINVAL;
     }
 
 /** 中断 **/
     /* 获取中断号 */
     alinx_char.irq = gpio_to_irq(alinx_char.alinx_key_gpio);
     /* 申请中断 */
     ret = request_irq(alinx_char.irq,
                       key_handler,
                       IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING,
                       "alinxkey", 
                       NULL);
     if(ret < 0)
     {
         printk("irq %d request failed\r\n", alinx_char.irq);
         return -EFAULT;
     }
     
 /** 定时器 **/
     __init_timer(&alinx_char.timer, timer_function, 0);
     
 /** 等待队列 **/
     init_waitqueue_head(&alinx_char.wait_q_h);
 
 /** 字符设备框架 **/    
     /* 注册设备号 */
     alloc_chrdev_region(&alinx_char.devid, MINOR_U, DEVID_COUNT, DEVICE_NAME);
     
     /* 初始化字符设备结构体 */
     cdev_init(&alinx_char.cdev, &ax_char_fops);
     
     /* 注册字符设备 */
     cdev_add(&alinx_char.cdev, alinx_char.devid, DRIVE_COUNT);
     
     /* 创建类 */
     alinx_char.class = class_create(THIS_MODULE, DEVICE_NAME);
     if(IS_ERR(alinx_char.class)) 
     {
         return PTR_ERR(alinx_char.class);
     }
     
     /* 创建设备节点 */
     alinx_char.device = device_create(alinx_char.class, NULL, 
                                       alinx_char.devid, NULL, 
                                       DEVICE_NAME);
     if (IS_ERR(alinx_char.device)) 
     {
         return PTR_ERR(alinx_char.device);
     }
     
     return 0;  
 }
 
 /* 卸载模块 */  
 static void __exit char_drv_exit(void)  
 {  
 /** gpio **/
     /* 释放gpio */
     gpio_free(alinx_char.alinx_key_gpio);
 
 /** 中断 **/
     /* 释放中断 */
     free_irq(alinx_char.irq, NULL);
 
 /** 定时器 **/
     /* 删除定时器 */   
     del_timer_sync(&alinx_char.timer);
 
 /** 字符设备框架 **/
     /* 注销字符设备 */
     cdev_del(&alinx_char.cdev);
     
     /* 注销设备号 */
     unregister_chrdev_region(alinx_char.devid, DEVID_COUNT);
     
     /* 删除设备节点 */
     device_destroy(alinx_char.class, alinx_char.devid);
     
     /* 删除类 */
     class_destroy(alinx_char.class);
     
     printk("timer_led_dev_exit_ok\n");  
 }  
   
 /* 标记加载、卸载函数 */  
 module_init(char_drv_init);  
 module_exit(char_drv_exit);  
   
 /* 驱动描述信息 */  
 MODULE_AUTHOR("Alinx");  
 MODULE_ALIAS("alinx char");  
 MODULE_DESCRIPTION("NIO LED driver");  
 MODULE_VERSION("v1.0");  
 MODULE_LICENSE("GPL");    

驱动代码在上一章的代码基础上，增加了poll实现，并稍微修改了read函数。

191行在file_operations结构体中添加poll函数实现。

158行实现poll函数，调用一下poll_wait函数，之后哦按段数据状态，如果数据准备好，就返回POLLIN状态标识。

110行在read函数中稍作修改，先判断文件打开方式，如果是非阻塞的方式访问，就不去做队列相关的操作了，直接返回数据给用户，否则按照阻塞访问处理。

测试代码
~~~~~~~~~~~~~~~

测试代码在 **gpio输入** 章节的基础上修改，新建QT工程名为”ax_nioled_test”，新建main.c，输入下列代码：

.. code:: c

 #include "stdio.h"
 #include "unistd.h"
 #include "sys/types.h"
 #include "sys/stat.h"
 #include "fcntl.h"
 #include "stdlib.h"
 #include "string.h"
 #include "poll.h"
 #include "sys/select.h"
 #include "sys/time.h"
 #include "linux/ioctl.h"
 
 int main(int argc, char *argv[])
 {
 
     /* ret获取返回值, fd获取文件句柄 */
     int ret, fd, fd_l;
     /* 定义一个监视文件读变化的描述符合集 */
     fd_set readfds;
     /* 定义一个超时时间结构体 */
     struct timeval timeout;
 
     char *filename, led_value = 0;
     unsigned int key_value;
 
     if(argc != 2)
     {
         printf("Error Usage\r\n");
         return -1;
     }
 
     filename = argv[1];
     /* 获取文件句柄, O_NONBLOCK表示非阻塞访问 */
     fd = open(filename, O_RDWR | O_NONBLOCK);
     if(fd < 0)
     {
         printf("can not open file %s\r\n", filename);
         return -1;
     }
 
     while(1)
     {
         /* 初始化描述符合集 */
         FD_ZERO(&readfds);
         /* 把文件句柄fd指向的文件添加到描述符 */
         FD_SET(fd, &readfds);
 
         /* 超时时间初始化为1.5秒 */
         timeout.tv_sec = 1;
         timeout.tv_usec = 500000;
 
         /* 调用select, 注意第一个参数为fd+1 */
         ret = select(fd + 1, &readfds, NULL, NULL, &timeout);
         switch (ret)
         {
             case 0:
             {
                 /* 超时 */
                 break;
             }
             case -1:
             {
                 /* 出错 */
                 break;
             }
             default:
             {
                 /* 监视的文件可操作 */
                 /* 判断可操作的文件是不是文件句柄fd指向的文件 */
                 if(FD_ISSET(fd, &readfds))
                 {
                     /* 操作文件 */
                     ret = read(fd, &key_value, sizeof(key_value));
                     if(ret < 0)
                     {
                         printf("read failed\r\n");
                         break;
                     }
                     printf("key_value = %d\r\n", key_value);
                     if(1 == key_value)
                     {
                         printf("ps_key1 press\r\n");
                         led_value = !led_value;
 
                         fd_l = open("/dev/gpio_leds", O_RDWR);
                         if(fd_l < 0)
                         {
                             printf("file /dev/gpio_leds open failed\r\n");
                             break;
                         }
 
                         ret = write(fd_l, &led_value, sizeof(led_value));
                         if(ret < 0)
                         {
                             printf("write failed\r\n");
                             break;
                         }
 
                         ret = close(fd_l);
                         if(ret < 0)
                         {
                             printf("file /dev/gpio_leds close failed\r\n");
                             break;
                         }
                     }
                 }
                 break;
             }
         }
     }
     close(fd);
     return ret;
 }

73行的read函数开始，之后的代码与6.4节是一样的，通过判断key的状态，来改变led的状态。

在调用read之前，先调用select函数来检测数据状态，用法和之前提到的用法相同，就不重复说明了。

运行测试
~~~~~~~~~~~~~~~

测试方式和现象和上一章一样，步骤如下：

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
| insmod ./ax-concled-drv.ko                                            |
|                                                                       |
| insmod ./ax-nio-drv.ko                                                |
|                                                                       |
| cd ./build-ax_nioled_test-ZYNQ-Debug                                  |
|                                                                       |
| ./ax-nioled-test /dev/nio_led&                                        |
|                                                                       |
| top                                                                   |
+-----------------------------------------------------------------------+

此外，可以尝试一下，把测试程中的超时时间改成0或者NULL来贯彻现象。


